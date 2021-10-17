require("UI.UIBasePanel")

UIWeaponPanel = class("UIWeaponPanel", UIBasePanel)
UIWeaponPanel.__index = UIWeaponPanel

UIWeaponPanel.curType = 0
UIWeaponPanel.tabList = {}
UIWeaponPanel.enhanceContent = nil
UIWeaponPanel.breakContent = nil
UIWeaponPanel.weaponPartContent = nil
UIWeaponPanel.attributeList = {}
UIWeaponPanel.weaponModel = nil
UIWeaponPanel.weaponInfoContent = nil
UIWeaponPanel.partsList = {}
UIWeaponPanel.curSlot = nil

function UIWeaponPanel:ctor()
    UIWeaponPanel.super.ctor(self)
end

function UIWeaponPanel.Close()
    self = UIWeaponPanel
    if self.enhanceContent.isLevelUpMode then
        self.enhanceContent:CloseEnhance()
    elseif self.breakContent.isLevelUpMode then
        self.breakContent:CloseBreak()
    else
        UIManager.CloseUI(UIDef.UIWeaponPanel)
    end
end

function UIWeaponPanel.OnRelease()
    self = UIWeaponPanel
    UIWeaponPanel.enhanceContent:OnRelease()
    UIWeaponPanel.breakContent:OnRelease()
    UIWeaponPanel.curType = 0
    UIWeaponPanel.tabList = {}
    UIWeaponPanel.enhanceContent = nil
    UIWeaponPanel.breakContent = nil
    UIWeaponPanel.weaponPartContent = nil
    UIWeaponPanel.attributeList = {}
    UIWeaponPanel.weaponInfoContent = nil
    UIWeaponPanel.partsList = {}
    UIWeaponPanel.curSlot = nil
	UIModelToucher.ReleaseWeaponToucher()
    if(UIWeaponPanel.weaponModel ~= nil) then
        CS.UITweenManager.KillTween(UIWeaponPanel.weaponModel.transform)
        ResourceManager:DestroyInstance(UIWeaponPanel.weaponModel)
        UIWeaponPanel.weaponModel = nil
        UIWeaponGlobal.weaponModel = nil
    end
    if self.needModel then
        UIManager.EnableFacilityBarrack(false)
    end
end

function UIWeaponPanel.Init(root, data)
    self = UIWeaponPanel

    UIWeaponPanel.super.SetRoot(UIWeaponPanel, root)

    local weaponId = data[1]
    local type = data[2]
    local needModel = data[3]
    self.weaponData = NetCmdWeaponData:GetWeaponById(weaponId)
    self.curType = type
    self.needModel = needModel

    UIWeaponPanel.mView = UIWeaponPanelView.New()
    UIWeaponPanel.mView:InitCtrl(root)

    UIWeaponPanel.enhanceContent = UIWeaponEnhanceContent.New(self.weaponData, self)
    UIWeaponPanel.enhanceContent:InitCtrl(self.mView.mTrans_Enhance, self.mView.weaponListContent)

    UIWeaponPanel.breakContent = UIWeaponBreakContent.New(self.weaponData, self)
    UIWeaponPanel.breakContent:InitCtrl(self.mView.mTrans_Break, self.mView.weaponListContent)

    UIManager.EnableFacilityBarrack(true)

    if needModel then
        self:InitWeaponModel()
    end
end

function UIWeaponPanel.OnInit()
    self = UIWeaponPanel

    UIWeaponPanel.super.SetPosZ(UIWeaponPanel)

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UIWeaponPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommandCenter.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    self:InitTabBtn()
    self:UpdateGunInfo()
    setactive(self.mView.weaponListContent.mUIRoot, false)
end

function UIWeaponPanel.OnShow()
    self = UIWeaponPanel

    if self.curType ~= 0 then
        self:UpdateTab(self.curType)
    else
        self:UpdateTab(UIWeaponGlobal.WeaponPanelTab.Info)
    end

    if self.weaponModel then
        setactive(self.weaponModel.gameObject, true)
    end
	
	UIModelToucher.SwitchToucher(2)
end

function UIWeaponPanel.OnHide()
    self = UIWeaponPanel
    if self.weaponModel then
        setactive(self.weaponModel.gameObject, false)
    end
end

function UIWeaponPanel:InitWeaponModel()
    if(self.weaponModel ~= nil) then
        CS.UITweenManager.KillTween(self.weaponModel.transform)
        ResourceManager:DestroyInstance(self.weaponModel)
    end
	
	self.weaponModel = UIModelToucher.CreateWeapon(self.weaponData);
    UIWeaponGlobal.WeaponModel = self.weaponModel
end

function UIWeaponPanel:RotateWeapon()
    local trans = self.weaponModel.transform
    CS.UITweenManager.PlayRotationTweenLoop(trans, 8)
end

function UIWeaponPanel:InitTabBtn()
    for i = 1, 3 do
        local item = UIBarrackCommonTabItem.New()
        item:InitCtrl(self.mView.mTrans_TabList)
        item.tagId = i
        item.hintId = item:SetNameByHint(UIWeaponGlobal.WeaponTabHint[i])
        item.systemId = UIWeaponGlobal.SystemIdList[i]
        item:UpdateSystemLock()
        UIUtils.GetButtonListener(item.mBtn_ClickTab.gameObject).onClick = function()
            self:OnClickTab(item.tagId)
        end
        self.tabList[i] = item
    end
end

function UIWeaponPanel:RefreshPanel()
    setactive(self.mView.weaponListContent.mUIRoot, false)
    self:UpdateTab(self.curType)
end

function UIWeaponPanel:OnClickTab(id)
    if TipsManager.NeedLockTips(UIWeaponGlobal.SystemIdList[id]) or self.curType == id or id == nil or id <= 0 then
        return
    end
    self:UpdateTab(id)
end

function UIWeaponPanel:UpdateTab(id)
    if self.curType > 0 then
        local lastTab = self.tabList[self.curType]
        lastTab:SetItemState(false)
    end
    local curTab = self.tabList[id]
    curTab:SetItemState(true)
    self.curType = id

    self:UpdatePanelByType(id)
end

function UIWeaponPanel:UpdatePanelByType(type)
    local needBreak = (self.weaponData.Level >= self.weaponData.CurMaxLv) and (self.weaponData.BreakTimes < self.weaponData.MaxBreakTime)
    if type == UIWeaponGlobal.WeaponPanelTab.Info then
        self:UpdateWeaponDetail()
    elseif type == UIWeaponGlobal.WeaponPanelTab.Enhance then
        if needBreak then
            self.breakContent:ResetWeaponList()
            self.breakContent:UpdatePanel()
        else
            self.enhanceContent:ResetWeaponList()
            self.enhanceContent:UpdatePanel()
        end
    elseif type == UIWeaponGlobal.WeaponPanelTab.WeaponPart then
        self:UpdateWeaponPartsContent()
    end
    setactive(self.mView.mTrans_WeaponInfo, type == UIWeaponGlobal.WeaponPanelTab.Info)
    setactive(self.mView.mTrans_Enhance, type == UIWeaponGlobal.WeaponPanelTab.Enhance and not needBreak)
    setactive(self.mView.mTrans_Break, type == UIWeaponGlobal.WeaponPanelTab.Enhance and needBreak)
    setactive(self.mView.mTrans_WeaponPartContent, type == UIWeaponGlobal.WeaponPanelTab.WeaponPart)
end

function UIWeaponPanel:UpdateWeaponDetail()
    if self.weaponInfoContent == nil then
        self.weaponInfoContent = UIBarrackWeaponInfoItem.New()
        self.weaponInfoContent:InitCtrl(self.mView.mTrans_WeaponInfo)
    end
    self.weaponInfoContent:SetData(self.weaponData)
end

function UIWeaponPanel:UpdateSkill(skill, data)
    setactive(skill.obj, data ~= nil)
    if data then
        skill.imageIcon.sprite = UIUtils.GetIconSprite("Icon/Skill", data.icon)
        skill.txtName.text = data.name.str
        skill.txtDesc.text = data.description.str
    end
end

function UIWeaponPanel:UpdateLockStatue()
    setactive(self.mView.mTrans_Lock, self.weaponData.IsLocked)
    setactive(self.mView.mTrans_UnLock, not self.weaponData.IsLocked)
end

function UIWeaponPanel:UpdateAttribute(data)
    local attrList = {}

    local expandList = TableData.GetPropertyExpandList()
    for i = 0, expandList.Count - 1 do
        local lanData = expandList[i]
        if(lanData.type == 1) then
            local value = data:GetPropertyByLevelAndSysName(lanData.sys_name, data.CurLv, data.BreakTimes)
            if(value > 0) then
                local attr = {}
                attr.propData = lanData
                attr.value = value
                table.insert(attrList, attr)
            end
        end
    end

    table.sort(attrList, function (a, b) return a.propData.order < b.propData.order end)

    for _, item in ipairs(self.attributeList) do
        item:SetData(nil)
    end

    for i = 1, #attrList do
        local item = nil
        if i <= #self.attributeList then
            item = self.attributeList[i]
        else
            item = PropertyItemS.New()
            item:InitCtrl(self.mView.mTrans_Properties)
            table.insert(self.attributeList, item)
        end
        item:SetData(attrList[i].propData, attrList[i].value, i % 2 == 0 , ColorUtils.WhiteColor, false)
    end
end

function UIWeaponPanel:UpdateGunInfo()
    if self.weaponData.gun_id ~= 0 then
        local gunData = TableData.listGunDatas:GetDataById(self.weaponData.gun_id)
        self.mView.mImage_GunIcon.sprite = IconUtils.GetCharacterHeadSprite(gunData.code)
    end
    setactive(self.mView.mTrans_Equipped, self.weaponData.gun_id ~= 0)
end

function UIWeaponPanel:OnClickLock()
    NetCmdWeaponData:SendGunWeaponLockUnlock(self.weaponData.id, function ()
        self:UpdateLockStatue()
    end)
end

function UIWeaponPanel:UpdateWeaponPartsContent()
    self:UpdateWeaponPartsList(self.weaponData)
    if self.curSlot then
        self:OnClickPart(self.curSlot)
    end
end

function UIWeaponPanel:UpdateWeaponPartsList(data)
    if not AccountNetCmdHandler:CheckSystemIsUnLock(SystemList.GundetailWeaponpart) then
        return
    end
    
    if data == nil then
        return
    end

    for i, part in ipairs(self.partsList) do
        part:SetData(nil, nil)
    end

    local slotList = data.slotList
    for i = 0, slotList.Count - 1 do
        local item = self.partsList[i + 1]
        if item == nil then
            item = UIWeaponSlotItem.New()
            item:InitCtrl(self.mView.mTrans_WeaponPartList)
            table.insert(self.partsList, item)
        end
        local data = data:GetWeaponPartByIndex(slotList[i])
        item:SetData(data, slotList[i])
        UIUtils.GetButtonListener(item.mBtn_Part.gameObject).onClick = function()
            self:OnClickPart(item)
        end
    end

    setactive(self.mView.mTrans_WeaponPartsInfo, data.BuffSkillId > 0)
end

function UIWeaponPanel:UpdateWeaponPartsListByType(type, partId)
    if partId == nil then
        return
    end

    local curSlot = nil
    for _, slot in ipairs(self.partsList) do
        if slot.slotId and slot.slotId == type then
            curSlot = slot
            break
        end
    end
    local data = NetCmdWeaponPartsData:GetWeaponPartById(partId)
    curSlot:SetData(data, curSlot.slotId)
end

function UIWeaponPanel:OnClickPart(item)
    if self.weaponPartContent == nil then
        self.weaponPartContent = UIWeaponPartsReplaceContent.New()
        self.weaponPartContent:InitCtrl(self.mView.mTrans_WeaponPartContent, self.mParentObj)

        self.weaponPartContent:SetReplaceCallback(function ()
            self:UpdateWeaponPartsList(self.weaponData)
        end)
        self.weaponPartContent:SetLockCallback(function (id)
            self:UpdateWeaponPartStateById(id)
        end)
        self.weaponPartContent:SetCloseCallback(function ()
            self:CloseWeaponPartRelpace()
        end)
        self.weaponPartContent:SetClickPartCallback(function (partId)
            self:UpdateWeaponPartsListByType(self.curSlot.slotId, partId)
        end)
    end

    self:UpdateWeaponPartsList(self.weaponData)
    if self.curSlot then
        self.curSlot:SetItemSelect(false)
    end
    self.curSlot = item
    self.curSlot:SetItemSelect(true)
    self.weaponPartContent:SetData(self.curSlot.partData, self.curSlot.slotId, self.weaponData.id)
    setactive(self.weaponPartContent.mUIRoot, true)
end

function UIWeaponPanel:CloseWeaponPartRelpace()
    self:UpdateWeaponPartsList(self.weaponData)
    self.curSlot:SetItemSelect(false)
    self.curSlot = nil
    setactive(self.weaponPartContent.mUIRoot, false)
end

function UIWeaponPanel:UpdateWeaponPartStateById(id)
    for i, part in ipairs(self.partsList) do
        if part.partData and part.partData.id == id then
            local data = NetCmdWeaponPartsData:GetWeaponPartById(id)
            part:SetData(data, part.slotId)
            return
        end
    end
end