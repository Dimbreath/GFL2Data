require("UI.UIBasePanel")

UIWeaponPartPanel = class("UIWeaponPartPanel", UIBasePanel)
UIWeaponPartPanel.__index = UIWeaponPartPanel

UIWeaponPartPanel.partData = nil
UIWeaponPartPanel.curType = 0
UIWeaponPartPanel.tabList = {}
UIWeaponPartPanel.partInfoContent = nil
UIWeaponPartPanel.enhanceContent = nil
UIWeaponPartPanel.costItem = nil

function UIWeaponPartPanel:ctor()
    UIWeaponPartPanel.super.ctor(self)
end

function UIWeaponPartPanel.Close()
    self = UIWeaponPartPanel
    if UIWeaponGlobal.weaponModel ~= nil then
        setactive(UIWeaponGlobal.weaponModel.gameObject, true)
    end
    UIManager.CloseUI(UIDef.UIWeaponPartPanel)
end

function UIWeaponPartPanel.OnRelease()
    self = UIWeaponPartPanel
    UIWeaponPartPanel.partData = nil
    UIWeaponPartPanel.curType = 0
    UIWeaponPartPanel.tabList = {}
    UIWeaponPartPanel.partInfoContent = nil
    UIWeaponPartPanel.enhanceContent = nil
    UIWeaponPartPanel.costItem = nil
    if self.needModel then
        UIManager.EnableFacilityBarrack(false)
    end
end

function UIWeaponPartPanel.Init(root, data)
    self = UIWeaponPartPanel
    UIWeaponPartPanel.super.SetRoot(UIWeaponPartPanel, root)

    local partId = data[1]
    local type = data[2]
    local needModel = data[3]
    self.partData = NetCmdWeaponPartsData:GetWeaponPartById(partId)
    self.curType = type
    self.needModel = needModel

    UIWeaponPartPanel.mView = UIWeaponPartPanelView.New()
    UIWeaponPartPanel.mView:InitCtrl(root)

    UIManager.EnableFacilityBarrack(true)
end

function UIWeaponPartPanel.OnInit()
    self = UIWeaponPartPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UIWeaponPartPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommandCenter.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_LevelUp.gameObject).onClick = function()
        UIWeaponPartPanel:OnClickLevelUp()
    end

    self:InitTabBtn()
    self:UpdateWeaponInfo()

    if UIWeaponGlobal.weaponModel ~= nil then
        setactive(UIWeaponGlobal.weaponModel.gameObject, false)
    end
end

function UIWeaponPartPanel.OnShow()
    self = UIWeaponPartPanel

    if self.curType ~= 0 then
        self:UpdateTab(self.curType)
    else
        self:UpdateTab(UIWeaponGlobal.WeaponPartPanelTab.Info)
    end
end

function UIWeaponPartPanel:InitTabBtn()
    for i = 1, 2 do
        local item = UIBarrackCommonTabItem.New()
        item:InitCtrl(self.mView.mTrans_TabList)
        item.tagId = i
        item.hintId = item:SetNameByHint(UIWeaponGlobal.WeaponPartTabHint[i])
        UIUtils.GetButtonListener(item.mBtn_ClickTab.gameObject).onClick = function()
            self:OnClickTab(item.tagId)
        end
        self.tabList[i] = item
    end
end

function UIWeaponPartPanel:RefreshPanel()
    self:UpdateTab(self.curType)
end

function UIWeaponPartPanel:OnClickTab(id)
    if self.curType == id or id == nil or id <= 0 then
        return
    end
    self:UpdateTab(id)
end

function UIWeaponPartPanel:UpdateTab(id)
    if self.curType > 0 then
        local lastTab = self.tabList[self.curType]
        lastTab:SetItemState(false)
    end
    local curTab = self.tabList[id]
    curTab:SetItemState(true)
    self.curType = id

    self:UpdatePanelByType(id)
end

function UIWeaponPartPanel:UpdatePanelByType(type)
    if type == UIWeaponGlobal.WeaponPartPanelTab.Info then
        self:UpdateWeaponPartDetail()
    elseif type == UIWeaponGlobal.WeaponPartPanelTab.Enhance then
        self:UpdateEnhanceContent()
    end
    setactive(self.mView.mTrans_Detail, type == UIWeaponGlobal.WeaponPartPanelTab.Info)
    setactive(self.mView.mTrans_Enhance, type == UIWeaponGlobal.WeaponPartPanelTab.Enhance)
end

function UIWeaponPartPanel:UpdateWeaponPartDetail()
    if self.partInfoContent == nil then
        self.partInfoContent = UIBarrackWeaponPartInfoItem.New()
        self.partInfoContent:InitCtrl(self.mView.mTrans_PartInfo)
    end
    self.partInfoContent:SetData(self.partData)

    local text = TableData.GetHintById(40014)
    if self.partData.exclusiveWeapon and self.partData.exclusiveWeapon.Count > 0 then
        for i = 0, self.partData.exclusiveWeapon.Count - 1 do
            local weaponData = TableData.listGunWeaponDatas:GetDataById(self.partData.exclusiveWeapon[i])
            if i < self.partData.exclusiveWeapon.Count - 1 then
                text = text .. weaponData.name.str .. "/"
            else
                text = text .. weaponData.name.str
            end
        end
    else
        local typeData = TableData.listWeaponPartTypeDatas:GetDataById(self.partData.type)
        for i = 0, typeData.weapon_type.Count - 1 do
            local weaponType = TableData.listGunWeaponTypeDatas:GetDataById(typeData.weapon_type[i])
            if i < typeData.weapon_type.Count - 1 then
                text = text .. weaponType.name.str .. "/"
            else
                text = text .. weaponType.name.str
            end
        end
    end

    self.mView.mText_EquipWeapon.text = text
end

function UIWeaponPartPanel:UpdateWeaponInfo()
    self.mView.mImage_Icon.sprite = IconUtils.GetWeaponPartIcon(self.partData.icon .. "_512")
    setactive(self.mView.mTrans_Weapon, self.partData.equipWeapon ~= 0)
end

function UIWeaponPartPanel:UpdateEnhanceContent()
    if self.enhanceContent == nil then
        self.enhanceContent = UIBarrackWeaponPartInfoItem.New()
        self.enhanceContent:InitCtrl(self.mView.mTrans_EnhaceInfo)
    end
    self.enhanceContent:SetData(self.partData)

    if self.costItem == nil then
        self.costItem = UICommonItem.New()
        self.costItem:InitCtrl(self.mView.mTrans_CostItem)
    end
    local data = self.partData.calibrationData
    if data then
        for itemId, itemNum in pairs(data.adjust_num) do
            self.costItem:SetItemData(itemId, itemNum, true)
        end
    else
        self.costItem:SetItemData(nil)
    end

    setactive(self.mView.mTrans_MaxLevel, not self.partData.isCanLevelUp)
    setactive(self.mView.mTrans_LevelUp, self.partData.isCanLevelUp)
    setactive(self.mView.mTrans_CostContent, self.partData.isCanLevelUp)
end

function UIWeaponPartPanel:OnClickLevelUp()
    if self.costItem:IsItemEnough() then
        NetCmdWeaponPartsData:ReqWeaponPartCalibration(self.partData.id, function (ret)
            self:LevelUpCallback(ret)
        end)
    else
        UIUtils.PopupHintMessage(40018)
    end
end

function UIWeaponPartPanel:LevelUpCallback(ret)
    if ret == CS.CMDRet.eSuccess then
        self:OpenCalibrationSucPanel()
        self:RefreshPanel()
    end
end

function UIWeaponPartPanel:OpenCalibrationSucPanel()
    local lvUpData = CommonLvUpData.New()
    lvUpData:SetWeaponPartLvUpData(self.enhanceContent.attribute, self.partData.attributeValue)
    UIManager.OpenUIByParam(UIDef.UIWeaponPartCailbrationSucPanel, lvUpData)
end