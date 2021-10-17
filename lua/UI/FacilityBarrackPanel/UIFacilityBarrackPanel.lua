require("UI.UIBasePanel")

UIFacilityBarrackPanel = class("UIFacilityBarrackPanel", UIBasePanel)
UIFacilityBarrackPanel.__index = UIFacilityBarrackPanel

UIFacilityBarrackPanel.mView = nil
UIFacilityBarrackPanel.gunDataList = {}
UIFacilityBarrackPanel.gunList = {}
UIFacilityBarrackPanel.gunItemList = {}
UIFacilityBarrackPanel.gunShowList = {}
UIFacilityBarrackPanel.dutyList = {}
UIFacilityBarrackPanel.curType = nil

UIFacilityBarrackPanel.sortList = {}
UIFacilityBarrackPanel.curSort = nil
UIFacilityBarrackPanel.sortPointer = nil

function UIFacilityBarrackPanel:ctor()
    UIFacilityBarrackPanel.super.ctor(self)
end

function UIFacilityBarrackPanel:Close()
    UIManager.CloseUI(UIDef.UIFacilityBarrackPanel)
end

function UIFacilityBarrackPanel.ClearUIRecordData()

end

function UIFacilityBarrackPanel.Init(root, data)
    UIFacilityBarrackPanel.super.SetRoot(UIFacilityBarrackPanel, root)

    self = UIFacilityBarrackPanel
    ---@type UIFacilityBarrackPanelView
    self.mView = UIFacilityBarrackPanelView.New()
    self.mView:InitCtrl(root)

    if data == nil then
        self.assistFlag = false
    else
        self.assistFlag = data
    end

    MessageSys:AddListener(5002, self.OnQuickBuyCallback)

    FacilityBarrackGlobal:ParseSortType()
end

function UIFacilityBarrackPanel.OnInit()
    self = UIFacilityBarrackPanel

    UIUtils.GetButtonListener(self.mView.mBtn_BackItem.gameObject).onClick = function()
        UIFacilityBarrackPanel:OnReturnClick()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_HomeItem.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    self:InitDutyList()
    self:InitGunList()
    self:InitSortContent()
end

function UIFacilityBarrackPanel.OnShow()
    self = UIFacilityBarrackPanel

    if self.curSort then
        if self.curSort.sortType ~= FacilityBarrackGlobal.SortType.sortType then
            self.curSort.btnSort.interactable = true
        end
    end
    self.curSort = self.sortList[FacilityBarrackGlobal.SortType.sortType]
    self.curSort.isAscend = FacilityBarrackGlobal.SortType.isAscend
    self.curSort.btnSort.interactable = false

    self:OnClickDuty(self.curType)

    setactive(self.mView.mList_Card, true)
end

function UIFacilityBarrackPanel.OnRelease()
    self = UIFacilityBarrackPanel
    UIFacilityBarrackPanel.gunDataList = {}
    UIFacilityBarrackPanel.gunList = {}
    UIFacilityBarrackPanel.gunItemList = {}
    UIFacilityBarrackPanel.gunShowList = {}
    UIFacilityBarrackPanel.dutyList = {}
    UIFacilityBarrackPanel.curType = nil

    UIFacilityBarrackPanel.sortList = {}
    UIFacilityBarrackPanel.curSort = nil
    UIFacilityBarrackPanel.sortPointer = nil

    MessageSys:RemoveListener(5002, self.OnQuickBuyCallback)

    FacilityBarrackGlobal:SaveSortType()
end

function UIFacilityBarrackPanel.OnQuickBuyCallback()
    self = UIFacilityBarrackPanel
    printstack("快速購買刷新")
    self:UpdateLockInfo(self.CurrentGun)
end

function UIFacilityBarrackPanel:OnReturnClick()
    if self.mView.mAnimator then
        self.mView.mAnimator:SetBool("ComPage_FadeOut", true)
        self:Close()
    end
end

function UIFacilityBarrackPanel:OnGunClick(gun)
    if gun then
        UIManager.OpenUIByParam(UIDef.UICharacterDetailPanel, gun.tableData.id)
    end
end

function UIFacilityBarrackPanel:OnClickDuty(item)
    if item then
        if self.curType then
            if self.curType.type ~= item.type then
                self.curType.mBtn.interactable = true
            end
        end
        self.curType = item
        self.curType.mBtn.interactable = false
        self:OnClickSort(self.curSort.sortType)
    end
end

function UIFacilityBarrackPanel:OnClickSortList()
    setactive(self.mView.mTrans_SortList, true)
    -- self.sortPointer.isInSelf = true
end

function UIFacilityBarrackPanel:CloseItemSort()
    setactive(self.mView.mTrans_SortList, false)
end

function UIFacilityBarrackPanel:OnClickSort(type)
    if type then
        if self.curSort then
            if self.curSort.sortType ~= type then
                self.curSort.btnSort.interactable = true
            end
        end
        self.curSort = self.sortList[type]
        self.curSort.btnSort.interactable = false

        FacilityBarrackGlobal:SetSortType(self.curSort)

        self:UpdateGunList()
        self:CloseItemSort()
    end
end

function UIFacilityBarrackPanel:OnClickAscend()
    if self.curSort then
        self.curSort.isAscend = not self.curSort.isAscend

        FacilityBarrackGlobal:SetSortType(self.curSort)

        self:UpdateGunList()
    end
end

function UIFacilityBarrackPanel:RefreshGunList(list)
    for _, gun in ipairs(list) do
        if gun then
            gun:UpdateData()
        end
    end
end

function UIFacilityBarrackPanel:UpdateGunList()
    local hasNewItem = false

    self.gunList = self:GetGunListByDuty(self.curType.type)
    local sortFunc = FacilityBarrackGlobal:GetSortFunc(1, self.curSort.sortCfg, self.curSort.isAscend)
    table.sort(self.gunList, sortFunc)

    for _, gun in ipairs(self.gunItemList) do
        gun:SetBaseData(nil)
    end

    if self.gunList then
        for i = 1, #self.gunList do
            local item = nil
            local data = self.gunList[i]
            if i > #self.gunItemList then
                ---@type UIBarrackCardDisplayItem
                item = UIBarrackCardDisplayItem.New()
                item:InitCtrl(self.mView.mContent_Card.transform)
                table.insert(self.gunItemList, item)
                hasNewItem = true
            else
                item = self.gunItemList[i]
            end
            item:SetBaseData(data.id)

            UIUtils.GetButtonListener(item.mBtn_Gun.gameObject).onClick = function() self:OnGunClick(item) end
        end
        if hasNewItem then
            self.mView.mTrans_Empty:SetAsLastSibling()
        end
    end
end

function UIFacilityBarrackPanel:GetGunListByDuty(duty)
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

----------------------- private -----------------------
function UIFacilityBarrackPanel:InitGunList()
    self.gunDataList = {}

    for i = 0, TableData.listGunDatas.Count - 1 do
        local gunData = TableData.listGunDatas[i]
        if self.gunDataList[gunData.duty] == nil then
            self.gunDataList[gunData.duty] = {}
        end
        table.insert(self.gunDataList[gunData.duty], gunData.id)
    end
end

function UIFacilityBarrackPanel:InitDutyList()
    self.dutyList = {}

    local dutyDataList = {}
    local data = {}
    data.id = 0
    table.insert(dutyDataList, data)
    local list = TableData.listGunDutyDatas:GetList()
    for i = 0, list.Count - 1 do
        local data = list[i]
        table.insert(dutyDataList, data)
    end

    for i = 1, #dutyDataList do
        local data = dutyDataList[i]
        ---@type UIBarrackMainTabItem
        local item = UIBarrackMainTabItem.New()
        item:InitCtrl(self.mView.mContent_TypeSel.transform)
        item:SetData(data)

        local tempItem = item
        UIUtils.GetButtonListener(item.mBtn.gameObject).onClick = function()
            self:OnClickDuty(tempItem)
        end

        table.insert(self.dutyList, item)
    end

    self.curType = self.dutyList[1]
end

function UIFacilityBarrackPanel:InitSortContent()
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
            if sort.sortType == FacilityBarrackGlobal.GunSortType.Time then
                sort.isAscend = true
            else
                sort.isAscend = false
            end

            sort.txtName.text = TableData.GetHintById(sort.hintID)

            UIUtils.GetButtonListener(sort.btnSort.gameObject).onClick = function()
                self:OnClickSort(sort.sortType)
            end

            table.insert(self.sortList, sort)
        end
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Sort.gameObject).onClick = function()
        self:OnClickSortList()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Ascend.gameObject).onClick = function()
        self:OnClickAscend()
    end

    UIUtils.GetUIBlockHelper(self.mView.mUIRoot, self.mView.mTrans_SortList, function ()
        UIFacilityBarrackPanel:CloseItemSort()
    end)

    self.curSort = self.sortList[FacilityBarrackGlobal.GunSortType.Time]
end


----------------------- 助战相关 -----------------------------
function UIFacilityBarrackPanel:UpdateReward()
    self.mView.mBtn_GetAssistRewardButton.interactable = not (AccountNetCmdHandler.AssistantRewards <= 0)
    self.mView.mText_RewardNum.text = AccountNetCmdHandler.AssistantRewards
end

function UIFacilityBarrackPanel:OnSetAssistGun()
    if self.CurrentGun then
        if self.CurrentGun.tableData.id == AccountNetCmdHandler.AssistantGunId then
            self:OnReturnClick()
            return
        end

        AccountNetCmdHandler:SendReqSetAssistant(self.CurrentGun.tableData.id, function()
            UIPlayerInfoPanel:RefreshAssistGun()
            self:OnReturnClick()
        end)
    end
end

function UIFacilityBarrackPanel:OnGetRewards()
    AccountNetCmdHandler:SendReqAssistantAcquire(function ()
        self:UpdateReward()
    end)
end