require("UI.UIBaseCtrl")

UIAdjutantItem = class("UIAdjutantItem", UIBaseCtrl);
UIAdjutantItem.__index = UIAdjutantItem
--@@ GF Auto Gen Block Begin
UIAdjutantItem.mBtn_SelButton = nil;
UIAdjutantItem.mImage_GunHead = nil;
UIAdjutantItem.mImage_GunType = nil;
UIAdjutantItem.mImage_CornerColor = nil;
UIAdjutantItem.mText_GunName = nil;
UIAdjutantItem.mTrans_Selected = nil;
UIAdjutantItem.mTrans_Setted = nil;

function UIAdjutantItem:__InitCtrl()

    self.mBtn_SelButton = self:GetButton("Btn_SelButton");
    self.mImage_GunHead = self:GetImage("Avatar/Image_GunHead");
    self.mImage_GunType = self:GetImage("Image_GunType");
    self.mImage_CornerColor = self:GetImage("Image_CornerColor");
    self.mText_GunName = self:GetText("BottomBar/Text_GunName");
    self.mTrans_Selected = self:GetRectTransform("Trans_Selected");
    self.mTrans_Setted = self:GetRectTransform("Trans_Setted");
end

--@@ GF Auto Gen Block End

function UIAdjutantItem:InitCtrl(parent)

    --实例化
    local obj=instantiate(UIUtils.GetGizmosPrefab("CommanderRoom/UIAdjutantItem.prefab",self));
    self:SetRoot(obj.transform);
    --setparent(parent,obj.transform);
    obj.transform:SetParent(parent,false);
    obj.transform.localScale=vectorone;

	self:__InitCtrl();

end


UIAdjutantItem.Stc_Adjutant_ID=nil;

function UIAdjutantItem:SetData(cmd_adjutantData)

    if cmd_adjutantData==nil then
        setactive(self.mUIRoot.gameObject, false);
        return;
    end

    self.Stc_Adjutant_ID=cmd_adjutantData.current;

    local adjutantData=TableData.GetAdjutantData(cmd_adjutantData.current);

    if adjutantData.type==1 then
        local GunData = TableData.GetGunData(adjutantData.detail_id);

        if GunData == nil then
            gferror("Gun 配置表不存在 人形 数据！stc_ID:"..adjutantData.detail_id);
            return;
        end

        --立绘
        self.mImage_GunHead.sprite = IconUtils.GetCharacterHeadSprite(GunData.code);

        --枪种小标签
        self.mImage_GunType.sprite =UIUtils.GetGunMessageSprite("Combat_GunTypeIcon_"..tostring(GunData.typeInt));

        --稀有度
        self.mImage_CornerColor.color = TableData.GetGlobalGun_Quality_Color1(GunData.rank);
        --self.mImage_UI_BarrackCharacterItemBarColor.color = TableData.GetGlobalGun_Quality_Color2(self.GunData.rank);

        --名称
        self.mText_GunName.text = GunData.name;

    else


        local NpcData = TableData.GetNpcData(adjutantData.detail_id);

        if NpcData == nil then
            gferror("Npc 配置表不存在 NPC数据！stc_ID:"..adjutantData.detail_id.."adjutantData.id"..adjutantData.id);
            return;
        end

        --立绘
        self.mImage_GunHead.sprite = IconUtils.GetCharacterHeadSprite(NpcData.code);

        --枪种小标签
       -- self.mImage_GunType.sprite =UIUtils.GetGunMessageSprite("Combat_GunTypeIcon_"..tostring(GunData.typeInt));

        --稀有度
       -- self.mImage_CornerColor.color = TableData.GetGlobalGun_Quality_Color1(GunData.rank);
        --self.mImage_UI_BarrackCharacterItemBarColor.color = TableData.GetGlobalGun_Quality_Color2(self.GunData.rank);

        --名称
        self.mText_GunName.text = NpcData.name;




    end









    --是否是当前的副官


end

function UIAdjutantItem:SetSelectedState(isSelected)

    self.mTrans_Selected = self:GetRectTransform("Trans_Selected");
    self.mTrans_Setted = self:GetRectTransform("Trans_Setted");

    --setactive(self.mImage_UI_BarrackCharacterItemBakNormal.gameObject, not isSelected);
    setactive(self.mTrans_Selected.gameObject, isSelected);
end