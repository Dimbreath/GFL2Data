require("UI.UIBasePanel")
require("UI.FacilityBarrackPanel.UICharacterDetailPanelView")
require("UI.FacilityBarrackPanel.Content.UIBarrackContentBase")
require("UI.FacilityBarrackPanel.Content.UILevelUpContent")
require("UI.FacilityBarrackPanel.Content.UIUpgradeContent")
require("UI.FacilityBarrackPanel.Content.UIMentalContent")
require("UI.FacilityBarrackPanel.Content.UISkillContent")

UICharacterDetailPanel = class("UICharacterDetailPanel", UIBasePanel)
UICharacterDetailPanel.__index = UICharacterDetailPanel

UICharacterDetailPanel.mView = nil
UICharacterDetailPanel.isGunLock = false
UICharacterDetailPanel.tabList = {}
UICharacterDetailPanel.curTab = 0
-- UICharacterDetailPanel.lastCurTab = 0
UICharacterDetailPanel.childPanelList = {}
UICharacterDetailPanel.closeCallback = nil
UICharacterDetailPanel.curGunIndex = 0
UICharacterDetailPanel.currentGun = nil
UICharacterDetailPanel.gunList = {}
UICharacterDetailPanel.gunDataList = {}
UICharacterDetailPanel.gunDataTempList = {}
UICharacterDetailPanel.gunItemList = {}
UICharacterDetailPanel.mGunModelObj = nil
UICharacterDetailPanel.switchGun = false

UICharacterDetailPanel.sortContent = nil
UICharacterDetailPanel.sortList = {}
UICharacterDetailPanel.curSort = nil

UICharacterDetailPanel.dutyList = {}
UICharacterDetailPanel.curDuty = nil
UICharacterDetailPanel.reflectionPanel = nil

UICharacterDetailPanel.RedPointType = {RedPointConst.Barracks}

function UICharacterDetailPanel:ctor()
    UICharacterDetailPanel.super.ctor(self)
end

function UICharacterDetailPanel.Open()
	
end

function UICharacterDetailPanel.Close()
    self = UICharacterDetailPanel

    if self.curTab == FacilityBarrackGlobal.PowerUpType.Weapon then
        local curChildPanel = self.childPanelList[self.curTab]
        if curChildPanel.curContent == UIWeaponGlobal.ContentType.Replace then
            curChildPanel:CloseReplaceContent()
            return
        end
    end

    if self.switchGun then
        self:OnClickCloseList()
        self:EnableSwitchContent(true)
        self:EnableTabs(true)
        return
    end

    -- self.lastCurTab = 0
    -- self:EnableCharacterModel(true)
    UIManager.CloseUI(UIDef.UICharacterDetailPanel)
end

function UICharacterDetailPanel.ClearUIRecordData()
    -- UICharacterDetailPanel.lastCurTab = 0
end

function UICharacterDetailPanel.Init(root, data)
    UICharacterDetailPanel.super.SetRoot(UICharacterDetailPanel, root)

    self = UICharacterDetailPanel

    self.mData = NetCmdTeamData:GetGunByID(data)
    self.isGunLock = self.mData == nil
    if self.mData == nil then
        self.mData = NetCmdTeamData:GetLockGunData(data)
    end

    self.tabList = {}
    self.curTab = 0
    self.childPanelList = {}

    self.mView = UICharacterDetailPanelView.New()
    self.mView:InitCtrl(root)
    setactive(self.mView.mTrans_Mask, true)

    self.mCharacterSelfShadowSettings = CS.UnityEngine.GameObject.Find("CharacterSelfShadowSettings"):GetComponent("CharacterSelfShadowSettings")
    UIManager.EnableFacilityBarrack(true)

    self:InitGunList(data)
    self:InitDutyList()
    self:InitSortContent()
    -- self:GetUIModel()
end


function UICharacterDetailPanel.OnInit()
    self = UICharacterDetailPanel

    UICharacterDetailPanel.super.SetPosZ(UICharacterDetailPanel)

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UICharacterDetailPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommandCenter.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_GunList.gameObject).onClick = function()
        UICharacterDetailPanel:OnClickCharacterList()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CurGun.gameObject).onClick = function()
        UICharacterDetailPanel:OnClickCharacterList()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CloseCharacterList.gameObject).onClick = function()
        UICharacterDetailPanel:OnClickCloseList()
        UICharacterDetailPanel:EnableSwitchContent(true)
        UICharacterDetailPanel:EnableTabs(true)
    end

    UIUtils.GetButtonListener(self.mView.mBtn_PreGun.gameObject).onClick = function()
        UICharacterDetailPanel:OnClickChangeGun(-1)
    end

    UIUtils.GetButtonListener(self.mView.mBtn_NextGun.gameObject).onClick = function()
        UICharacterDetailPanel:OnClickChangeGun(1)
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Duty.gameObject).onClick = function()
        UICharacterDetailPanel:OnClickElementList()
    end

    MessageSys:AddListener(CS.GF2.Message.UIEvent.MergeEquipSucc, UICharacterDetailPanel.MergeEquipSucc)
    MessageSys:AddListener(CS.GF2.Message.UIEvent.OnChangeWeapon, UICharacterDetailPanel.OnWeaponChange)
    
    self:InitTabs()
    local gunData = TableData.listGunDatas:GetDataById(self.mData.id)
    self:UpdateModel(gunData)
end

function UICharacterDetailPanel.OnShow()
    self = UICharacterDetailPanel
    local curChildPanel = self.childPanelList[self.curTab]
    if curChildPanel and curChildPanel.OnShow then
        curChildPanel:OnShow()
    end

    self:UpdateSystemLock()
    self:UpdateTabList()
    self:OnClickElement(self.curDuty)
    self:OnClickCloseList()
    self:UpdateCurGunInfo()

    self.gunDataTempList = self.gunList
    setactive(self.mView.mTrans_Mask, false)
end

function UICharacterDetailPanel:UpdatePanel()
    local gunData = TableData.listGunDatas:GetDataById(self.mData.id)
    if self.isGunLock then
        if self.curTab == FacilityBarrackGlobal.PowerUpType.LevelUp then
            self:UpdateRightContent(self.curTab)
        else
            self:OnClickTab(FacilityBarrackGlobal.PowerUpType.LevelUp)
        end
    else
        self:UpdateRightContent(self.curTab)
    end
    self:UpdateModel(gunData)
    self:UpdateTabList()
    self:UpdateCurGunInfo()
end

function UICharacterDetailPanel.OnHide()
    self = UICharacterDetailPanel
    local curChildPanel = self.childPanelList[self.curTab]
    if curChildPanel and curChildPanel.OnHide then
        curChildPanel:OnHide()
    end
end

function UICharacterDetailPanel.OnUpdate()
    self = UICharacterDetailPanel
    if UICharacterDetailPanel.curTab == 0 then
        return
    end
    local curChildPanel = self.childPanelList[self.curTab]
    if curChildPanel and curChildPanel.OnUpdate then
        curChildPanel:OnUpdate()
    end
end

function UICharacterDetailPanel.OnRelease()
    self = UICharacterDetailPanel

    for _, childPanel in pairs(self.childPanelList) do
        if childPanel then
            childPanel:OnRelease()
        end
    end

    UICharacterDetailPanel.tabList = {}
    UICharacterDetailPanel.childPanelList = {}
    UICharacterDetailPanel.gunModel = nil
    UICharacterDetailPanel.curTab = 0
    UICharacterDetailPanel.curGunIndex = 0
    UICharacterDetailPanel.gunList = {}
    UICharacterDetailPanel.gunDataList = {}
    UICharacterDetailPanel.gunItemList = {}
    UICharacterDetailPanel.currentGun = nil
    UICharacterDetailPanel.switchGun = false

    UICharacterDetailPanel.sortContent = nil
    UICharacterDetailPanel.sortList = {}
    UICharacterDetailPanel.curSort = nil

    UICharacterDetailPanel.dutyList = {}
    UICharacterDetailPanel.curDuty = nil

    UICharacterDetailPanel.reflectionPanel = nil

    UIManager.EnableFacilityBarrack(false)

    UICharacterDetailPanel.mGunModelObj:Destroy()
    UIFacilityBarrackPanel.mGunModelObj = nil
    FacilityBarrackGlobal.UIModel = nil
	
	UIModelToucher.ReleaseWeaponToucher()
	UIModelToucher.ReleaseCharacterToucher()

    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.OnChangeWeapon, UICharacterDetailPanel.OnWeaponChange)
    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.MergeEquipSucc, UICharacterDetailPanel.MergeEquipSucc)
end

function UICharacterDetailPanel:InitTabs()
    for i = 0, TableData.listBarrackDatas.Count - 1 do
        local data = TableData.listBarrackDatas[i]
        local item = UIBarrackCommonTabItem.New()
        item.tagId = data.id
        item.tagName = FacilityBarrackGlobal.PowerUpName[i + 1]
        item.systemId = data.unlock

        item:InitCtrl(self.mView.mTrans_Tabs)
        item:SetName(data.name.str)
        item:UpdateSystemLock()
        UIUtils.GetButtonListener(item.mBtn_ClickTab.gameObject).onClick = function()
            self:OnClickTab(item.tagId)
        end

        self.tabList[item.tagId] = item
    end

    --if self.lastCurTab == 0 then
    --
    --else
    --    self:OnClickTab(self.lastCurTab)
    --end
    self:OnClickTab(FacilityBarrackGlobal.PowerUpType.LevelUp)
end

function UICharacterDetailPanel:OnClickTab(id)
    if id then
        if TipsManager.NeedLockTips(self.tabList[id].systemId) or self.curTab == id then
            return
        end

        if self.curTab > 0 then
            local lastTab = self.tabList[self.curTab]
            lastTab:SetItemState(false)
            self:CloseCurChildPanel()
        end
        local curTab = self.tabList[id]
        curTab:SetItemState(true)
        self.curTab = id
        -- self.lastCurTab = id

        self:UpdateRightContent(self.curTab)
        setactive(self.mView.mTrans_GunList, self.curTab == FacilityBarrackGlobal.PowerUpType.LevelUp)
        setactive(self.mView.mTrans_CurGun, self.curTab ~= FacilityBarrackGlobal.PowerUpType.LevelUp)
    end
end

function UICharacterDetailPanel:UpdateRightContent(type)
    local childPanel = self.childPanelList[type]
    if childPanel == nil then
        if type == FacilityBarrackGlobal.PowerUpType.LevelUp then     --- 升级
            childPanel = UIGunInfoContent.New()
            childPanel:InitCtrl(self.mView.mTrans_LevelUp)
            self.childPanelList[type] = childPanel
        elseif type == FacilityBarrackGlobal.PowerUpType.Upgrade then    --- 升星
            childPanel = UIUpgradeContent.New()
            childPanel:InitCtrl(self.mView.mTrans_Upgrade)
            self.childPanelList[type] = childPanel
        elseif type == FacilityBarrackGlobal.PowerUpType.Mental then     --- 心智
            childPanel = UIMentalContent.New()
            childPanel:InitCtrl(self.mView.mTrans_Mental)
            self.childPanelList[type] = childPanel
        elseif type == FacilityBarrackGlobal.PowerUpType.Equip then
            childPanel = UIEquipContent.New()
            childPanel:InitCtrl(self.mView.mTrans_Equip)
            self.childPanelList[type] = childPanel
        elseif type == FacilityBarrackGlobal.PowerUpType.Weapon then
            childPanel = UIWeaponContent.New()
            childPanel:InitCtrl(self.mView.mTrans_Weapon)
            self.childPanelList[type] = childPanel
        end
    end

    if childPanel then
        childPanel:SetData(self.mData, self)
    end
end

function UICharacterDetailPanel:EnableCharacterModel(enable)
    if self.gunModel then
        if enable then
            local data = TableData.listModelConfigDatas:GetDataById(self.mData.model_id)
            local vec = UIUtils.SplitStrToVector(data.character_type)
            self.gunModel.transform.position = vec
            if self.reflectionPanel == nil then
                local canvas = UISystem.CharacterCanvas
                self.reflectionPanel = UIUtils.GetTransform(canvas, "ReflectionPlane")
            end
            self.reflectionPanel.transform.position = vec
        else
            local tempVec = self.gunModel.transform.localPosition
            tempVec.x = 1000
            self.gunModel.transform.localPosition = tempVec
        end
    end
end

function UICharacterDetailPanel:CloseCurChildPanel()
    if self.curTab then
        local childPanel = self.childPanelList[self.curTab]
        if childPanel then
            childPanel:OnEnable(false)
        end
    end
end

function UICharacterDetailPanel:GetGunPropByType(type)
    if not type then
        return 0
    end
    return self.mData:GetGunPropertyValueByType(type)
end

function UICharacterDetailPanel:CloseChildPanel()
    self:CloseCurChildPanel()
    self.curTab = 0
end

function UICharacterDetailPanel:UpdateGunModel(model_id, weapon_id)
    if(self.mGunModelObj ~= nil) then
        self.mGunModelObj:Destroy()
    end

    local data = TableData.listModelConfigDatas:GetDataById(model_id)

    self.mGunModelObj = UIUtils.GetModel(FacilityBarrackGlobal.E3DModelType.eGun, model_id, CS.EGetModelUIType.eBarrack, weapon_id)
    if self.mGunModelObj ~= nil and self.mGunModelObj.gameObject ~= nil then
        self.mGunModelObj.transform.localEulerAngles = Vector3(0,180,0)

        GFUtils.MoveToLayer(self.mGunModelObj.transform,CS.UnityEngine.LayerMask.NameToLayer("Friend"))

        self:SetLookAtCharacter(self.mGunModelObj.gameObject)
		UIModelToucher.AttachCharacterTransToTouch(self.mGunModelObj.gameObject);

        FacilityBarrackGlobal.UIModel = self.mGunModelObj.gameObject
    else
        FacilityBarrackGlobal.UIModel = nil
    end

    UIManager.SetCharacterCameraScaleModelId(model_id)
end

function UICharacterDetailPanel.OnWeaponChange()
    self = UICharacterDetailPanel

    self:UpdateModel(self.mData.TabGunData)
end

function UICharacterDetailPanel:SetLookAtCharacter(obj)
    if(self.mCharacterSelfShadowSettings ~= nil) then
        self.mCharacterSelfShadowSettings:SetLookAtCharacter(obj)
    end
end

function UICharacterDetailPanel:UpdateModel(tableData)
    local modelId = self.mData ~= nil and self.mData.model_id or TableData.GetRoleTemplateData(tableData.role_template_id).model_code
    local weaponModelId = self.mData ~= nil and (self.mData.WeaponData ~= nil and self.mData.WeaponData.stc_id or tableData.weapon_default) or tableData.weapon_default
    self:UpdateGunModel(modelId, weaponModelId)
    self.gunModel = FacilityBarrackGlobal.UIModel
    if self.gunModel ~= nil then
        local camera = UISystem.CharacterCamera
        local characterCameraScaleCtrl = CS.CharacterCameraScaleController.Get(camera.gameObject)
        characterCameraScaleCtrl:SetModel(self.gunModel.gameObject)
    end

    self:EnableCharacterModel(self.childPanelList[self.curTab].needModel)
end

function UICharacterDetailPanel:UpdateSystemLock()
    for _, tab in pairs(self.tabList) do
        tab:UpdateSystemLock()
    end
end

function UICharacterDetailPanel:OnClickCharacterList()
    for _, gun in ipairs(self.gunItemList) do
        if gun and gun.tableData then
            gun:SetData(gun.tableData.id)
            gun:SetSelect(self.mData.id == gun.tableData.id)
            if self.mData.id == gun.tableData.id then
                self.currentGun = gun
            end
        end
    end

    if self.curTab == FacilityBarrackGlobal.PowerUpType.LevelUp then
        self.childPanelList[self.curTab]:EnableLevelInfo(false)
    end
    self.switchGun = true
    setactive(self.mView.mTrans_Character, true)
    self:EnableSwitchContent(false)
    self:EnableTabs(false)
end

function UICharacterDetailPanel:OnGunClick(gun)
    if gun then
        if self.currentGun then
            if self.currentGun.tableData.id == gun.tableData.id then
                return
            end
            self.currentGun:SetSelect(false)
        end
        gun:SetSelect(true)
        self.currentGun = gun
        self.curGunIndex = gun.index
        self.gunDataTempList = self.gunList

        self.mData = NetCmdTeamData:GetGunByID(gun.tableData.id)
        self.isGunLock = self.mData == nil
        if self.mData == nil then
            self.mData = NetCmdTeamData:GetLockGunData(gun.tableData.id)
        end
        self:UpdatePanel()
    end
end

function UICharacterDetailPanel:OnClickCloseList()
    self.switchGun = false
    self:CloseDuty()
    self:CloseItemSort()
    if self.curTab == FacilityBarrackGlobal.PowerUpType.LevelUp then
        self.childPanelList[self.curTab]:EnableLevelInfo(true)
    end
    setactive(self.mView.mTrans_Character, false)
end

function UICharacterDetailPanel:OnClickChangeGun(step)
    local index = self.curGunIndex + step
    if index <= 0 then
        index = #self.gunDataTempList
    elseif index > #self.gunDataTempList then
        index = 1
    end
    self.curGunIndex = index

    local gun = self.gunDataTempList[self.curGunIndex]
    self.mData = NetCmdTeamData:GetGunByID(gun.id)
    self.isGunLock = self.mData == nil
    if self.mData == nil then
        self.mData = NetCmdTeamData:GetLockGunData(gun.id)
    end
    self.childPanelList[self.curTab]:PlaySwitchAni(step)
    self:UpdatePanel()
end

function UICharacterDetailPanel:OnClickElementList()
    setactive(self.mView.mTrans_DutyContent, true)
end

function UICharacterDetailPanel:CloseDuty()
    setactive(self.mView.mTrans_DutyContent, false)
end

function UICharacterDetailPanel:OnClickElement(item)
    if item then
        if self.curDuty then
            if self.curDuty.type ~= item.type then
                self.curDuty.btnSort.interactable = true
            end
        end
        self.curDuty = item
        self.curDuty.btnSort.interactable = false
        self:OnClickSort(self.curSort.sortType)

        self:CloseDuty()

        self.mView.mImage_DutyIcon.sprite = IconUtils.GetGunTypeIcon(self.curDuty.data.icon .. "_W")
    end
end

function UICharacterDetailPanel:OnClickSortList()
    setactive(self.mView.mTrans_SortList, true)
end

function UICharacterDetailPanel:CloseItemSort()
    setactive(self.mView.mTrans_SortList, false)
end

function UICharacterDetailPanel:OnClickSort(type)
    if type then
        if self.curSort then
            if self.curSort.sortType ~= type then
                self.curSort.btnSort.interactable = true
            end
        end
        self.curSort = self.sortList[type]
        self.curSort.btnSort.interactable = false
        self.sortContent:SetData(self.curSort)

        FacilityBarrackGlobal:SetSortType(self.curSort)

        self:UpdateGunList()

        self:CloseItemSort()
     end
end

function UICharacterDetailPanel:OnClickAscend()
    if self.curSort then
        self.curSort.isAscend = not self.curSort.isAscend

        FacilityBarrackGlobal:SetSortType(self.curSort)

        self:UpdateGunList()
    end
end

function UICharacterDetailPanel:UpdateGunList()
    self.gunList = self:GetGunListByDuty(self.curDuty.type)
    local sortFunc = FacilityBarrackGlobal:GetSortFunc(1, self.curSort.sortCfg, self.curSort.isAscend)
    table.sort(self.gunList, sortFunc)

    for _, gun in ipairs(self.gunItemList) do
        gun:SetData(nil)
        gun:SetSelect(false)
    end

    if self.gunList then
        for i = 1, #self.gunList do
            local item = nil
            local data = self.gunList[i]
            if i > #self.gunItemList then
                ---@type UIBarrackCardDisplayItem
                item = UIBarrackChrCardItem.New()
                item:InitCtrl(self.mView.mTrans_CharacterList.transform)

                table.insert(self.gunItemList, item)
            else
                item = self.gunItemList[i]
            end
            item:SetData(data.id)
            item.index = i

            UIUtils.GetButtonListener(item.mBtn_Gun.gameObject).onClick = function() self:OnGunClick(item) end
        end
    end

    local currentGun, curGunIndex = self:GetGunItemById(self.mData.id)
    if currentGun then
        self.currentGun = currentGun
        self.curGunIndex = curGunIndex
        self.currentGun:SetSelect(true)
        self.gunDataTempList = self.gunList
    else
        currentGun, curGunIndex = self:GetTempGunItemById(self.mData.id)
        if currentGun then
            self.currentGun = nil
            self.curGunIndex = curGunIndex
        end
    end
end

function UICharacterDetailPanel:GetGunListByDuty(duty)
    if duty then
        local tempGunList = {}
        if duty == 0 then
            for _, gunList in pairs(self.gunDataList) do
                if gunList then
                    for _, gunId in ipairs(gunList) do
                        local data = NetCmdTeamData:GetGunByID(gunId)
                        if data == nil then
                            data = FacilityBarrackGlobal:GetLockGunData(gunId)
                        end
                        table.insert(tempGunList, data)
                    end
                end
            end
        else
            local gunIdList = self.gunDataList[duty]
            if gunIdList then
                for _, gunId in ipairs(gunIdList) do
                    local data = NetCmdTeamData:GetGunByID(gunId)
                    if data == nil then
                        data = FacilityBarrackGlobal:GetLockGunData(gunId)
                    end
                    table.insert(tempGunList, data)
                end
            end
        end
        return tempGunList
    end
    return nil
end

function UICharacterDetailPanel.MergeEquipSucc()
    self = UICharacterDetailPanel
    if self.curTab == FacilityBarrackGlobal.PowerUpType.Mental then
        self.childPanelList[self.curTab]:OnShow()
    end
end

function UICharacterDetailPanel:UpdateTabList()
    for i, tab in ipairs(self.tabList) do
        local redPoint = 0
        local isUnlock = FacilityBarrackGlobal:GetSystemIsUnlock(self.mData.TabGunData.system_switch, FacilityBarrackGlobal.SystemList[tab.tagName])
        if tab.tagId ~= FacilityBarrackGlobal.PowerUpType.LevelUp then
            isUnlock = (isUnlock) and (not self.isGunLock)
            if tab.tagId == FacilityBarrackGlobal.PowerUpType.Upgrade and isUnlock then
                redPoint = NetCmdTeamData:UpdateUpgradeRedPoint(self.mData)
            end
        else
            if self.isGunLock then
                redPoint = NetCmdTeamData:UpdateLockRedPoint(self.mData.TabGunData)
            end
        end
        tab:SetEnable(isUnlock)
        tab:SetRedPointEnable(redPoint > 0)
    end
end

function UICharacterDetailPanel:RefreshGun()
    self.mData = NetCmdTeamData:GetGunByID(self.mData.id)
    self.isGunLock = self.mData == nil
    if self.mData == nil then
        self.mData = NetCmdTeamData:GetLockGunData(self.mData.id)
    end
    self:UpdatePanel()
    self:UpdateRedPoint()
end

function UICharacterDetailPanel:UpdateSwichContent()
    setactive(self.modelViewer.gameObject, self.curTab == FacilityBarrackGlobal.PowerUpType.LevelUp)
end

function UICharacterDetailPanel:EnableTabs(enable)
    setactive(self.mView.mTrans_Tabs, enable and not self.switchGun)
end

function UICharacterDetailPanel:EnableSwitchContent(enable)
    setactive(self.mView.mTrans_SwitchContent, enable and not self.switchGun)
    setactive(self.mView.mTrans_Switch, enable)
    setactive(self.mView.mTrans_GunList, enable and self.curTab == FacilityBarrackGlobal.PowerUpType.LevelUp)
    setactive(self.mView.mTrans_CurGun, enable and self.curTab ~= FacilityBarrackGlobal.PowerUpType.LevelUp)
end

--------------- private ---------------------
function UICharacterDetailPanel:InitGunList(curId)
    self.gunDataList = {}

    for i = 0, TableData.listGunDatas.Count - 1 do
        local gunData = TableData.listGunDatas[i]
        if self.gunDataList[gunData.duty] == nil then
            self.gunDataList[gunData.duty] = {}
        end
        table.insert(self.gunDataList[gunData.duty], gunData.id)
    end
end

function UICharacterDetailPanel:InitDutyList()
    self.dutyList = {}

    local dutyDataList = {}
    local data = {}
    data.id = 0
    data.icon = "Icon_Professional_ALL"
    table.insert(dutyDataList, data)
    local list = TableData.listGunDutyDatas:GetList()
    for i = 0, list.Count - 1 do
        local data = list[i]
        table.insert(dutyDataList, data)
    end

    local sortList = self:InstanceUIPrefab("UICommonFramework/ComScreenDropdownListItemV2.prefab", self.mView.mTrans_DutyContent)
    local parent = UIUtils.GetRectTransform(sortList, "Content")
    for i = 1, #dutyDataList do
        local data = dutyDataList[i]
        local obj = self:InstanceUIPrefab("Character/ChrEquipSuitDropdownItemV2.prefab", parent)
        if obj then
            local duty = {}
            duty.obj = obj
            duty.data = data
            duty.btnSort = UIUtils.GetButton(obj)
            duty.txtName = UIUtils.GetText(obj, "GrpText/Text_SuitName")
            duty.transIcon = UIUtils.GetRectTransform(obj, "Trans_GrpElement")
            duty.imgIcon = UIUtils.GetImage(obj, "Trans_GrpElement/ImgIcon")
            duty.type = data.id

            duty.imgIcon.sprite = IconUtils.GetGunTypeIcon(data.icon .. "_W")
            duty.txtName.text = data.id == 0 and TableData.GetHintById(101006) or data.name.str
            setactive(duty.transIcon, true)

            UIUtils.GetButtonListener(duty.btnSort.gameObject).onClick = function()
                self:OnClickElement(duty)
            end

            table.insert(self.dutyList, duty)
        end
    end

    UIUtils.GetUIBlockHelper(self.mView.mUIRoot, self.mView.mTrans_DutyContent, function ()
        self:CloseDuty()
    end)
    self.curDuty = self.dutyList[1]
end

function UICharacterDetailPanel:InitSortContent()
    if self.sortContent == nil then
        self.sortContent = UIGunSortItem.New()
        self.sortContent:InitCtrl(self.mView.mTrans_SortContent)

        UIUtils.GetButtonListener(self.sortContent.mBtn_Sort.gameObject).onClick = function()
            self:OnClickSortList()
        end

        UIUtils.GetButtonListener(self.sortContent.mBtn_Ascend.gameObject).onClick = function()
            self:OnClickAscend()
        end
    end

    local sortList = self:InstanceUIPrefab("UICommonFramework/ComScreenDropdownListItemV2.prefab", self.mView.mTrans_SortList)
    local parent = UIUtils.GetRectTransform(sortList, "Content")
    for i = 1, 4 do
        local obj = self:InstanceUIPrefab("Character/ChrEquipSuitDropdownItemV2.prefab", parent)
        if obj then
            local sort = {}
            sort.obj = obj
            sort.btnSort = UIUtils.GetButton(obj)
            sort.txtName = UIUtils.GetText(obj, "GrpText/Text_SuitName")
            sort.sortType = i
            sort.hintID = FacilityBarrackGlobal.SortHint[i]
            sort.sortCfg = FacilityBarrackGlobal.GunSortCfg[i]
            sort.isAscend = false

            sort.txtName.text = TableData.GetHintById(sort.hintID)

            UIUtils.GetButtonListener(sort.btnSort.gameObject).onClick = function()
                self:OnClickSort(sort.sortType)
            end

            table.insert(self.sortList, sort)
        end
    end

    UIUtils.GetUIBlockHelper(self.mView.mUIRoot, self.mView.mTrans_SortList, function ()
        self:CloseItemSort()
    end)

    self.curSort = self.sortList[FacilityBarrackGlobal.SortType.sortType]
    self.curSort.isAscend = FacilityBarrackGlobal.SortType.isAscend
end

function UICharacterDetailPanel:GetGunItemById(id)
    for i, gun in ipairs(self.gunItemList) do
        if gun and gun.tableData then
            if id == gun.tableData.id then
                return gun, i
            end
        end
    end
    return nil, nil
end

function UICharacterDetailPanel:GetTempGunItemById(id)
    for i, gun in ipairs(self.gunDataTempList) do
        if gun then
            if id == gun.id then
                return gun, i
            end
        end
    end
    return nil, nil
end

function UICharacterDetailPanel:UpdateCurGunInfo()
    local gunData = self.mData.TabGunData
    self.mView.mImage_GunHead.sprite = IconUtils.GetCharacterHeadSprite(gunData.code)
    self.mView.mText_GunName.text = gunData.name.str
end