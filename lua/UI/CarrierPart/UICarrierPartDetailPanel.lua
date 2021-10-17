require("UI.UIBasePanel")

UICarrierPartDetailPanel = class("UICarrierPartDetailPanel", UIBasePanel);
UICarrierPartDetailPanel.__index = UICarrierPartDetailPanel;

UICarrierPartDetailPanel.mView = nil;

UICarrierPartDetailPanel.mCarrierPartData = nil;

UICarrierPartDetailPanel.mPrefabPropertyPath = "CarrierPart/UICarrierPartDetailPropertyItem.prefab";
UICarrierPartDetailPanel.mPropertyObj = nil;
UICarrierPartDetailPanel.mPropItemList = nil;

function UICarrierPartDetailPanel:ctor()
    UICarrierPartDetailPanel.super.ctor(self);
end

function UICarrierPartDetailPanel.Open()
    UICarrierPartDetailPanel.OpenUI(UIDef.UICarrierPartDetailPanel);
end

function UICarrierPartDetailPanel.Close()
    UIManager.CloseUI(UIDef.UICarrierPartDetailPanel);
end

function UICarrierPartDetailPanel.Init(root, data)

    UICarrierPartDetailPanel.super.SetRoot(UICarrierPartDetailPanel, root);

    self = UICarrierPartDetailPanel;

    self.mData = data;

    self.mView = UICarrierPartDetailPanelView;
    self.mView:InitCtrl(root);

    self.mCarrierPartData = TableData.listCarrierPartDatas:GetDataById(data.stc_part_id);

    UIUtils.GetListener(self.mView.mBtn_Panel_Exit.gameObject).onClick = self.OnCloseClick;
    UIUtils.GetListener(self.mView.mBtn_Panel_Powerup.gameObject).onClick = self.OnPowerUpOpenClick;
    UIUtils.GetListener(self.mView.mBtn_PowerUpPanel_Back.gameObject).onClick = self.OnPowerUpCloseClick;
    UIUtils.GetListener(self.mView.mBtn_PowerUpPanel_PowerUpButton.gameObject).onClick = self.OnPowerUpClick;
    UIUtils.GetListener(self.mView.mBtn_PowerUpPanel_AddMaterial.gameObject).onClick = self.OnAddMaterialClick;

    self.mPropItemList = List:New();
    self:UpdateInfo();
end

function UICarrierPartDetailPanel.OnInit()

end

function UICarrierPartDetailPanel.OnShow()
    self = UICarrierPartDetailPanel;
end

function UICarrierPartDetailPanel.OnRelease()

    self = UICarrierPartDetailPanel;

    for i = 1, self.mPropItemList:Count() do
        gfdestroy(self.mPropItemList[i].mUIRoot.gameObject);
    end
    self.mPropItemList:Clear();

end

function UICarrierPartDetailPanel.OnCloseClick()

    self = UICarrierPartDetailPanel;
    UICarrierPartDetailPanel.Close();

end

function UICarrierPartDetailPanel.OnPowerUpOpenClick()

    self = UICarrierPartDetailPanel;
    setactive(self.mView.mTrans_PowerUpPanel, true);

end

function UICarrierPartDetailPanel.OnPowerUpCloseClick()

    self = UICarrierPartDetailPanel;
    setactive(self.mView.mTrans_PowerUpPanel, false);

end

function UICarrierPartDetailPanel.OnPowerUpClick()

    self = UICarrierPartDetailPanel;

end

function UICarrierPartDetailPanel.OnAddMaterialClick()

    self = UICarrierPartDetailPanel;

end

function UICarrierPartDetailPanel.UpdateInfo()
    if self.mCarrierPartData == nil then
        return;
    end

    --名字
    self.mView.mText_Panel_Name.text = self.mCarrierPartData.name;
    --强化等级
    self.mView.mText_Panel_Level.text = self.mData.level;
    --简介
    self.mView.mText_Panel_Introduction.text = self.mCarrierPartData.introduction;

    --稀有度颜色
    self.mView.mImage_Panel_Rank.color = TableData.GetGlobalGun_Quality_Color1(self.mCarrierPartData.rank);

    --Icon
    self.mView.mImage_Panel_Icon.sprite = CS.IconUtils.GetIconSprite(CS.GF2Icon.CarrierPart, self.mCarrierPartData.icon)

    --类型名称
    local defineTypeData = TableData.listDefinePartTypeDatas:GetDataById(self.mCarrierPartData.define_type);
    self.mView.mText_Panel_Type.text = defineTypeData.name;

    self:SetCarrierPartDetailProps();

    self:UpdatePowerupInfo();
end

function UICarrierPartDetailPanel.UpdatePowerupInfo()

    --名字
    self.mView.mText_PowerUpPanel_PartName.text = self.mCarrierPartData.name;
    --强化等级
    self.mView.mText_PowerUpPanel_Level.text = self.mData.level;

    --稀有度颜色
    self.mView.mImage_PowerUpPanel_Rank.color = TableData.GetGlobalGun_Quality_Color1(self.mCarrierPartData.rank);
    --Icon
    self.mView.mImage_PowerUpPanel_PartIcon.sprite = CS.IconUtils.GetIconSprite(CS.GF2Icon.CarrierPart, self.mCarrierPartData.icon)

    --类型名称
    local defineTypeData = TableData.listDefinePartTypeDatas:GetDataById(self.mCarrierPartData.define_type);
    self.mView.mText_PowerUpPanel_Type.text = defineTypeData.name;

    --强化前信息
    self.mView.mText_PowerUpPanel_Before_CurrentLevel.text = self.mData.level;

    --强化后信息
    self.mView.mText_PowerUpPanel_After_NextLevel.text = self.mData.level + 1;

    local expData = TableData.GetCarrierPartExpByLevel(self.mData.level);
    local expAddon = 0;

    self.mView.mText_PowerUpPanel_ExpText.text = (self.mData.exp + expAddon).."/"..expData.part_need_exp;
    local goldCost = expData.part_cash_rate * 0.001 * expAddon;
    self.mView.mText_PowerUpPanel_CoinCost.text = goldCost.."/"..GlobalData.diamond;
    setactive(self.mView.mTrans_PowerUpPanel_LVUP, true);
end

function UICarrierPartDetailPanel:GetPropItem(index)
    if index <= self.mPropItemList:Count() then
        return  self.mPropItemList[index];
    end

    if self.mPropertyObj == nil then
        self.mPropertyObj = UIUtils.GetGizmosPrefab(self.mPrefabPropertyPath,self);
    end

    local i = self.mPropItemList:Count();
    while i <= index do
        local instItem = instantiate(self.mPropertyObj);
        local uiPropItem = UICarrierPartDetailPropertyItem.New();
        uiPropItem:InitCtrl(instItem.transform);
        UIUtils.AddListItem(instItem, self.mView.mTrans_Panel_PropertyLayout.gameObject);
        self.mPropItemList:Add(uiPropItem);
        i = i + 1;
    end

    return self.mPropItemList[index];
end

function UICarrierPartDetailPanel:AddProp(name, value, index)
    local uiPropItem = self:GetPropItem(index);
    uiPropItem.mText_PropertyName.text = name;
    if value < 0 then
        uiPropItem.mText_PropertyValue.text = value;
    else
        uiPropItem.mText_PropertyValue.text = "+"..value;
    end
end

function UICarrierPartDetailPanel:SetCarrierPartDetailProps()

    --属性列表
    local index = 1;
    if self.mData.prop.max_hp ~= 0 then
        self:AddProp("HP", self.mData.prop.max_hp, index);
        index = index + 1;
    end

    if self.mData.prop.pow ~= 0 then
        self:AddProp("火力", self.mData.prop.pow, index);
        index = index + 1;
    end

    if self.mData.prop.taunt ~= 0 then
        self:AddProp("嘲讽", self.mData.prop.taunt, index);
        index = index + 1;
    end

    if self.mData.prop.pierce ~= 0 then
        self:AddProp("穿甲", self.mData.prop.pierce, index);
        index = index + 1;
    end

    if self.mData.prop.armor ~= 0 then
        self:AddProp("护甲", self.mData.prop.armor, index);
        index = index + 1;
    end

    if self.mData.prop.expertise ~= 0 then
        self:AddProp("评价", self.mData.prop.expertise, index);
        index = index + 1;
    end

    if self.mData.prop.flexible ~= 0 then
        self:AddProp("灵活", self.mData.prop.flexible, index);
        index = index + 1;
    end

    if self.mData.prop.crit ~= 0 then
        self:AddProp("暴击", self.mData.prop.crit, index);
        index = index + 1;
    end

    if self.mData.prop.tough ~= 0 then
        self:AddProp("韧性", self.mData.prop.tough, index);
        index = index + 1;
    end

    if self.mData.prop.float_wide ~= 0 then
        self:AddProp("浮动", self.mData.prop.float_wide, index);
        index = index + 1;
    end

    if self.mData.prop.max_bearing ~= 0 then
        self:AddProp("载重", self.mData.prop.max_bearing, index);
        index = index + 1;
    end

    if self.mData.prop.fuel_param ~= 0 then
        self:AddProp("燃料", self.mData.prop.max_bearing, index);
        index = index + 1;
    end

    if self.mData.prop.part_param ~= 0 then
        self:AddProp("零件", self.mData.prop.max_bearing, index);
        index = index + 1;
    end

    if self.mData.prop.max_speed ~= 0 then
        self:AddProp("速度", self.mData.prop.max_speed, index);
        index = index + 1;
    end

    if self.mData.prop.vision ~= 0 then
        self:AddProp("视野", self.mData.prop.vision, index);
        index = index + 1;
    end
end