require("UI.UIBasePanel")

UIEquipPanel = class("UIEquipPanel", UIBasePanel)
UIEquipPanel.__index = UIEquipPanel

UIEquipPanel.curType = 0
UIEquipPanel.tabList = {}
UIEquipPanel.enhanceContent = nil
UIEquipPanel.subProp = {}

function UIEquipPanel:ctor()
    UIEquipPanel.super.ctor(self)
end

function UIEquipPanel.Close()
    self = UIEquipPanel
    if self.enhanceContent.isLevelUpMode then
        self.enhanceContent:CloseEnhance()
    else
        UIManager.CloseUI(UIDef.UIEquipPanel)
    end
end

function UIEquipPanel.OnRelease()
    self = UIEquipPanel
    UIEquipPanel.enhanceContent:OnRelease()
    UIEquipPanel.curType = 0
    UIEquipPanel.tabList = {}
    UIEquipPanel.enhanceContent = nil
    UIEquipPanel.subProp = {}
end

function UIEquipPanel.Init(root, data)
    self = UIEquipPanel

    UIEquipPanel.super.SetRoot(UIEquipPanel, root)

    local equipId = data[1]
    local type = data[2]
    self.equipData = NetCmdEquipData:GetEquipById(equipId)
    self.curType = type

    UIEquipPanel.mView = UIEquipPanelView.New()
    UIEquipPanel.mView:InitCtrl(root)

    UIEquipPanel.enhanceContent = UIEquipEnhanceContent.New(self.equipData)
    UIEquipPanel.enhanceContent:InitCtrl(self.mView.mTrans_Enhance)
end

function UIEquipPanel.OnInit()
    self = UIEquipPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UIEquipPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommandCenter.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Lock.gameObject).onClick = function()
        UIEquipPanel:OnClickLock()
    end

    self:InitTabBtn()
    self:UpdateEquipIcon()
end

function UIEquipPanel.OnShow()
    self = UIEquipPanel
end

function UIEquipPanel:InitTabBtn()
    for i, id in ipairs(UIEquipGlobal.EquipTabSort) do
        local parent = self.mView.mTrans_TabParent
        local obj = self:InstanceUIPrefab("Character/PowerUpListItemV2.prefab", parent, true)
        local item = UIBarrackCommonTabItem.New()
        item:InitObj(obj.transform)
        item.tagId = id
        item:SetName(TableData.GetHintById(UIEquipGlobal.EquipTabHint[i]))
        UIUtils.GetButtonListener(item.mBtn_ClickTab.gameObject).onClick = function()
            self:OnClickTab(item.tagId)
        end
        self.tabList[id] = item
    end

    if self.curType ~= 0 then
        self:UpdateTab(self.curType)
    else
        self:UpdateTab(UIEquipGlobal.EquipPanelTab.Info)
    end
end

function UIEquipPanel:OnClickTab(id)
    if self.curType == id or id == nil or id <= 0 then
        return
    end
    self:UpdateTab(id)
end

function UIEquipPanel:UpdateTab(id)
    if self.curType > 0 then
        local lastTab = self.tabList[self.curType]
        lastTab:SetItemState(false)
    end
    local curTab = self.tabList[id]
    curTab:SetItemState(true)
    self.curType = id

    self:UpdatePanelByType(id)
end

function UIEquipPanel:UpdatePanelByType(type)
    if type == UIEquipGlobal.EquipPanelTab.Info then
        self:UpdateEquipDetail()
    elseif type == UIEquipGlobal.EquipPanelTab.Enhance then
        -- self.enhanceContent:UpdatePanel()
    end
    setactive(self.mView.mTrans_Info, type == UIEquipGlobal.EquipPanelTab.Info)
    setactive(self.mView.mTrans_Enhance, type == UIEquipGlobal.EquipPanelTab.Enhance)
end

function UIEquipPanel:UpdateEquipIcon()
    self.mView.mImage_EquipIcon.sprite = IconUtils.GetEquipSprite(self.equipData.icon)
    self.mView.mImage_RankBg.color = TableData.GetGlobalGun_Quality_Color2(self.equipData.rank)
    UIUtils.SetAlpha(self.mView.mImage_RankBg, 0.4)

    if self.equipData.gun_id ~= 0 then
        local gunData = TableData.listGunDatas:GetDataById(self.equipData.gun_id)
        self.mView.mImage_GunIcon.sprite = IconUtils.GetCharacterHeadSprite(gunData.code)
    end
    setactive(self.mView.mTrans_Equipped, self.equipData.gun_id ~= 0)
end

function UIEquipPanel:UpdateEquipDetail()
    self.mView.mText_EquipName.text = self.equipData.name
    self.mView.mText_Lv.text = string_format(UIEquipGlobal.EquipLvRichText, self.equipData.level, self.equipData.max_level)
    self.mView.mImage_Grade.color = TableData.GetGlobalGun_Quality_Color2(self.equipData.rank)
    self.mView.mImage_Index.sprite = IconUtils.GetEquipNum(self.equipData.category, true)

    self:UpdateLockStatue()
    self:UpdateEquipSet()
    self:UpdateAttribute(self.equipData)
end

function UIEquipPanel:UpdateAttribute(data)
    self:UpdateMainAttribute(data)
    self:UpdateSubAttribute(data)
end

function UIEquipPanel:UpdateMainAttribute(data)
    if data.main_prop then
        local tableData = TableData.listCalibrationDatas:GetDataById(data.main_prop.Id)
        if tableData then
            local propData = TableData.GetPropertyDataByName(tableData.property, tableData.type)
            self.mView.mText_MainPropName.text = propData.show_name.str
            if propData.show_type == 2 then
                self.mView.mText_MainPropValue.text = math.ceil(data.main_prop.Value / 10)  .. "%"
            else
                self.mView.mText_MainPropValue.text = data.main_prop.Value
            end
        end
    end
end

function UIEquipPanel:UpdateSubAttribute(data)
    if data.sub_props then
        local item = nil
        for _, item in ipairs(self.subProp) do
            item:SetData(nil)
        end

        for i = 0, data.sub_props.Length - 1 do
            local prop = data.sub_props[i]
            local tableData = TableData.listCalibrationDatas:GetDataById(prop.Id)
            local propData = TableData.GetPropertyDataByName(tableData.property, tableData.type)
            if i + 1 <= #self.subProp then
                item = self.subProp[i + 1]
            else
                item = UICommonPropertyItem.New()
                item:InitCtrl(self.mView.mTrans_SubPropList)
                table.insert(self.subProp, item)
            end
            item:SetData(propData, prop.Value, true, false, false, false)
        end
    end
end

function UIEquipPanel:UpdateLockStatue()
    setactive(self.mView.mTrans_Lock, self.equipData.locked)
    setactive(self.mView.mTrans_UnLock, not self.equipData.locked)
end

function UIEquipPanel:UpdateEquipSet()
    if self.equipData.setId ~= 0 then
        local setData = TableData.listEquipSetDatas:GetDataById(self.equipData.setId)
        for i, item in ipairs(self.mView.equipSetList) do
            item:SetData(setData.id, setData["set" .. i .. "_num"])
        end
    end
end

function UIEquipPanel:OnClickLock()
    NetCmdGunEquipData:SendEquipLockOrUnlockCmd(self.equipData.id, function ()
        self:UpdateLockStatue()
    end)
end


