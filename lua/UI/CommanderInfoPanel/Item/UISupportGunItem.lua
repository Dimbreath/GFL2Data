require("UI.UIBaseCtrl")
---@class UISupportGunItem : UIBaseCtrl

UISupportGunItem = class("UISupportGunItem", UIBaseCtrl)
UISupportGunItem.__index = UISupportGunItem

function UISupportGunItem:ctor()
    self.parentObj = nil

    self.equipGun = nil
    self.equipGunId = 0
    self.gunList = {}
    self.gunDataList = {}
    self.gunItemList = {}

    self.dutyList = {}
    self.curDuty = nil

    self.sortContent = nil
    self.sortList = {}
    self.curSort = nil

    self.curGun = nil
    self.curGunId = 0

    self.callback = nil
end

function UISupportGunItem:__InitCtrl()
    self.mBtn_Replace = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpLeft/Content/GrpAction/BtnConfirm"))
    self.mBtn_Close = self:GetButton("Root/Btn_Close")
    self.mBtn_Duty = self:GetButton("Root/GrpLeft/Content/GrpElementScreen/BtnScreen/Btn_Screen")

    self.mTrans_DutyContent = self:GetRectTransform("Root/GrpLeft/Content/GrpElementScreen/Trans_GrpScreenList")
    self.mTrans_SortContent = self:GetRectTransform("Root/GrpLeft/Content/GrpScreen/BtnScreen")
    self.mTrans_SortList = self:GetRectTransform("Root/GrpLeft/Content/GrpScreen/Trans_GrpScreenList")

    self.mTrans_GunList = self:GetRectTransform("Root/GrpLeft/Content/GrpSupChrList/Viewport/Content")

    self.mTrans_Confirm = self:GetRectTransform("Root/GrpLeft/Content/GrpAction/BtnConfirm")
    self.mTrans_Used = self:GetRectTransform("Root/GrpLeft/Content/GrpAction/Trans_Used")
    self.mImage_DutyIcon = self:GetImage("Root/GrpLeft/Content/GrpElementScreen/BtnScreen/Btn_Screen/Img_Icon")

    self.mAniTime = UIUtils.GetRectTransform(self.mUIRoot, "Root"):GetComponent("AniTime")
    self.mAnimator = UIUtils.GetRectTransform(self.mUIRoot, "Root"):GetComponent("Animator")

    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = function()
        self:CloseSupportGunList()
    end

    UIUtils.GetButtonListener(self.mBtn_Duty.gameObject).onClick = function()
        self:OnClickElementList()
    end

    UIUtils.GetButtonListener(self.mBtn_Replace.gameObject).onClick = function()
        self:OnClickReplaceGun()
    end
end

function UISupportGunItem:InitCtrl(parent, callback)
    local obj = instantiate(UIUtils.GetGizmosPrefab("CommanderInfo/CommanderSupChrReplaceItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self.parentObj = parent
    self.callback = callback
    self:SetRoot(obj.transform)
    self:__InitCtrl()

    self:InitGunList()
    self:InitSortContent()
    self:InitElementList()
end

function UISupportGunItem:SetData(gunId)
    self.equipGunId = gunId
    self.curGunId = gunId
    self:OnClickElement(self.curDuty)

    setactive(self.mTrans_Used, true)
    setactive(self.mTrans_Confirm, false)
end

function UISupportGunItem:OnGunClick(gun)
    if gun then
        if self.curGun then
            if self.curGun.tableData.id == gun.tableData.id then
                return
            end
            self.curGun:SetSelect(false)
        end
        gun:SetSelect(true)
        self.curGun = gun
        self.curGunId = gun.tableData.id

        setactive(self.mTrans_Used, gun.tableData.id == self.equipGunId)
        setactive(self.mTrans_Confirm, gun.tableData.id ~= self.equipGunId)
    end
end

function UISupportGunItem:UpdateGunList()
    self.gunList = self:GetGunListByDuty(self.curDuty.type)
    self.curGun = nil
    self.equipGun = nil
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
                item:InitCtrl(self.mTrans_GunList.transform)

                table.insert(self.gunItemList, item)
            else
                item = self.gunItemList[i]
            end
            item:SetData(data.id, false)
            item.index = i

            item:SetSelectBlack(data.id == self.equipGunId)
            if data.id == self.equipGunId then
                self.equipGun = item
            end

            item:SetSelect(data.id == self.curGunId)
            if data.id == self.curGunId then
                self.curGun = item
            end

            UIUtils.GetButtonListener(item.mBtn_Gun.gameObject).onClick = function() self:OnGunClick(item) end
        end
    end
end

function UISupportGunItem:GetGunListByDuty(duty)
    if duty then
        local tempGunList = {}
        if duty == 0 then
            for _, gunList in pairs(self.gunDataList) do
                if gunList then
                    for _, gunId in ipairs(gunList) do
                        local data = NetCmdTeamData:GetGunByID(gunId)
                        if data ~= nil then
                            table.insert(tempGunList, data)
                        end
                    end
                end
            end
        else
            local gunIdList = self.gunDataList[duty]
            if gunIdList then
                for _, gunId in ipairs(gunIdList) do
                    local data = NetCmdTeamData:GetGunByID(gunId)
                    if data ~= nil then
                        table.insert(tempGunList, data)
                    end
                end
            end
        end
        return tempGunList
    end
    return nil
end

function UISupportGunItem:OnClickElement(item)
    if item then
        if self.curDuty then
            if self.curDuty.type ~= item.type then
                self.curDuty.btnSort.interactable = true
            end
        end
        self.curDuty = item
        self.curDuty.btnSort.interactable = false
        self:OnClickSort(self.curSort.sortType)

        self:CloseElement()

        self.mImage_DutyIcon.sprite = IconUtils.GetGunTypeIcon(self.curDuty.data.icon .. "_W")
    end
end

function UISupportGunItem:OnClickSortList()
    setactive(self.mTrans_SortList, true)
end

function UISupportGunItem:CloseItemSort()
    setactive(self.mTrans_SortList, false)
end

function UISupportGunItem:OnClickElementList()
    setactive(self.mTrans_DutyContent, true)
end

function UISupportGunItem:CloseElement()
    setactive(self.mTrans_DutyContent, false)
end

function UISupportGunItem:CloseSupportGunList()
    if self.mAniTime and self.mAnimator then
        self.mAnimator:SetTrigger("FadeOut")
        TimerSys:DelayCall(self.mAniTime.m_FadeOutTime, function ()
            setactive(self.parentObj, false)
        end)
    else
        setactive(self.parentObj, false)
    end
end

function UISupportGunItem:OnClickSort(type)
    if type then
        if self.curSort then
            if self.curSort.sortType ~= type then
                self.curSort.btnSort.interactable = true
            end
        end
        self.curSort = self.sortList[type]
        self.curSort.btnSort.interactable = false
        self.sortContent:SetData(self.curSort)

        self:UpdateGunList()
        self:CloseItemSort()
    end
end

function UISupportGunItem:OnClickAscend()
    if self.curSort then
        self.curSort.isAscend = not self.curSort.isAscend
        self:UpdateGunList()
    end
end

function UISupportGunItem:OnClickReplaceGun()
    if self.curGunId == self.equipGunId then
        return
    end
    if self.callback then
        self.callback(self.curGunId)
        self:CloseSupportGunList()
    end
end

function UISupportGunItem:InitGunList(curId)
    self.gunDataList = {}

    for i = 0, NetCmdTeamData.GunList.Count - 1 do
        local gunData = NetCmdTeamData.GunList[i]
        if self.gunDataList[gunData.TabGunData.duty] == nil then
            self.gunDataList[gunData.TabGunData.duty] = {}
        end
        table.insert(self.gunDataList[gunData.TabGunData.duty], gunData.id)
    end
end

function UISupportGunItem:InitElementList()
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

    local sortList = self:InstanceUIPrefab("UICommonFramework/ComScreenDropdownListItemV2.prefab", self.mTrans_DutyContent)
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

    UIUtils.GetUIBlockHelper(UICommanderInfoPanelV2.mView.mUIRoot, self.mTrans_DutyContent, function ()
        self:CloseElement()
    end)
    self.curDuty = self.dutyList[1]
end

function UISupportGunItem:InitSortContent()
    if self.sortContent == nil then
        self.sortContent = UIGunSortItem.New()
        self.sortContent:InitCtrl(self.mTrans_SortContent)

        UIUtils.GetButtonListener(self.sortContent.mBtn_Sort.gameObject).onClick = function()
            self:OnClickSortList()
        end

        UIUtils.GetButtonListener(self.sortContent.mBtn_Ascend.gameObject).onClick = function()
            self:OnClickAscend()
        end
    end

    local sortList = self:InstanceUIPrefab("UICommonFramework/ComScreenDropdownListItemV2.prefab", self.mTrans_SortList)
    local parent = UIUtils.GetRectTransform(sortList, "Content")
    for i = 1, 3 do
        local obj = self:InstanceUIPrefab("Character/ChrEquipSuitDropdownItemV2.prefab", parent)
        if obj then
            local sort = {}
            sort.obj = obj
            sort.btnSort = UIUtils.GetButton(obj)
            sort.txtName = UIUtils.GetText(obj, "GrpText/Text_SuitName")
            sort.sortType = i
            sort.hintID = 101000 + i
            sort.sortCfg = FacilityBarrackGlobal.GunSortCfg[i]
            sort.isAscend = false

            sort.txtName.text = TableData.GetHintById(sort.hintID)

            UIUtils.GetButtonListener(sort.btnSort.gameObject).onClick = function()
                self:OnClickSort(sort.sortType)
            end

            table.insert(self.sortList, sort)
        end
    end

    UIUtils.GetUIBlockHelper(UICommanderInfoPanelV2.mView.mUIRoot, self.mTrans_SortList, function ()
        self:CloseItemSort()
    end)

    self.curSort = self.sortList[FacilityBarrackGlobal.GunSortType.Time]
    self.curSort.isAscend = true
end
