require("UI.UIBasePanel")
require("UI.RepositoryPanel.UIRepositoryPanelView")
require("UI.Common.UICommonTabButtonItem")
require("UI.RepositoryPanel.Content.UIRepositoryItemPanel")

UIRepositoryPanel = class("UIRepositoryPanel", UIBasePanel)
UIRepositoryPanel.__index = UIRepositoryPanel

UIRepositoryPanel.mView = nil
UIRepositoryPanel.curTab = 0
UIRepositoryPanel.curPanel = 0
UIRepositoryPanel.curSort = 0
UIRepositoryPanel.tabList = {}
UIRepositoryPanel.sortList = {}
UIRepositoryPanel.toggleList = {}
UIRepositoryPanel.subPanel = {}
UIRepositoryPanel.soldItemList = {}
UIRepositoryPanel.soldObjList = {}
UIRepositoryPanel.commonReceiveItem = nil
UIRepositoryPanel.isDisassemble = false
UIRepositoryPanel.isHide = false

UIRepositoryPanel.equipDetail = nil
UIRepositoryPanel.weaponDetail = nil

UIRepositoryPanel.mPath_UICommonItemS = "UICommonFramework/UICommonItemS.prefab"

function UIRepositoryPanel:ctor()
    UIRepositoryPanel.super.ctor(self)
end

function UIRepositoryPanel.Close()
    self = UIRepositoryPanel
    self:ReturnPanel()
end

function UIRepositoryPanel:ReturnPanel()
    if self.curPanel == UIRepositoryGlobal.PanelType.EquipPanel then
        self:UpdatePanelByType(UIRepositoryGlobal.PanelType.EquipOverViewPanel)
    else
        UIManager.CloseUI(UIDef.UIRepositoryPanelV2)
    end
end

function UIRepositoryPanel.Init(root, data)
    self = UIRepositoryPanel
    UIRepositoryPanel.super.SetRoot(UIRepositoryPanel, root)
    self.currentType = data
    self.isHide = false
    self.mView = UIRepositoryPanelView.New()
    self.mView:InitCtrl(root)
end

function UIRepositoryPanel.OnInit()
    self = UIRepositoryPanel
    UIUtils.GetButtonListener(self.mView.mBtn_Exit.gameObject).onClick = function()
        UIRepositoryPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommanderCenter.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    UIUtils.GetButtonListener(self.mView.mTrans_Sold.gameObject).onClick = function()
        UIRepositoryPanel:OnClickSold()
    end

    UIUtils.GetButtonListener(self.mView.mTrans_Confirm.gameObject).onClick = function()
        UIRepositoryPanel:OnDismantle()
    end
    
    UIUtils.GetButtonListener(self.mView.mTrans_SoldClose.gameObject).onClick = function()
        UIRepositoryPanel:OnCloseSold()
    end

    UIUtils.GetButtonListener(self.mView.mTrans_SoldCancel.gameObject).onClick = function()
        UIRepositoryPanel:OnCloseSold()
    end

    self.pointer = UIUtils.GetPointerClickHelper(self.mView.mTrans_ItemBrief.gameObject, function()
        UIRepositoryPanel:CloseEquipDetail()
        UIRepositoryPanel:CloseWeaponDetail()
    end, self.mView.mTrans_ItemBrief.gameObject)

    MessageSys:AddListener(CS.GF2.Message.GunEquipEvent.WeaponDismantleDrop, self.DismantleDrop)
    MessageSys:AddListener(CS.GF2.Message.GunEquipEvent.EquipDismantleDrop, self.DismantleDrop)

    self:InitAllSubPanel()
    self:InitSortButton()
    self:InitTabButton()
    -- self:InitFiltrateToggle()
end

function UIRepositoryPanel:InitAllSubPanel()
    for _, id in pairs(UIRepositoryGlobal.PanelType) do
        self:InitSubPanel(id)
    end
end

function UIRepositoryPanel:InitSubPanel(panelId)
    local subPanel = nil
    if panelId == UIRepositoryGlobal.PanelType.ItemPanel then
        subPanel = UIRepositoryItemPanel.New(self, panelId, self.mView.mTrans_ItemList)
    elseif panelId == UIRepositoryGlobal.PanelType.EquipPanel then
        subPanel = UIRepositoryEquipPanel.New(self, panelId, self.mView.mTrans_EquipList)
    elseif panelId == UIRepositoryGlobal.PanelType.WeaponPanel then
        subPanel = UIRepositoryWeaponPanel.New(self, panelId, self.mView.mTrans_EquipList)
    elseif panelId == UIRepositoryGlobal.PanelType.EquipOverViewPanel then
        subPanel = UIRepositoryEquipOverViewPanel.New(self, panelId, self.mView.mTrans_EquipOverView)
    end
    self.subPanel[panelId] = subPanel
end

function UIRepositoryPanel.OnShow()
    self = UIRepositoryPanel
    if self.isHide then
        if self.curPanel == UIRepositoryGlobal.PanelType.EquipPanel or self.curPanel == UIRepositoryGlobal.PanelType.WeaponPanel then
            self.subPanel[self.curPanel]:RefreshItemList()
            self:UpdateCurrentCount()
        end
        self.isHide = false
    end
end

function UIRepositoryPanel.OnHide()
    self = UIRepositoryPanel
    self.isHide = true
end

function UIRepositoryPanel.OnDataUpdate(data)

end

function UIRepositoryPanel.OnRelease()
    self = UIRepositoryPanel

    for _, panel in pairs(self.subPanel) do
        panel:OnRelease()
    end

    MessageSys:RemoveListener(CS.GF2.Message.GunEquipEvent.WeaponDismantleDrop, self.DismantleDrop)
    MessageSys:RemoveListener(CS.GF2.Message.GunEquipEvent.EquipDismantleDrop, self.DismantleDrop)

    UIRepositoryPanel.curTab = 0
    UIRepositoryPanel.curPanel = 0
    UIRepositoryPanel.curSort = 0
    UIRepositoryPanel.tabList = {}
    UIRepositoryPanel.sortList = {}
    UIRepositoryPanel.toggleList = {}
    UIRepositoryPanel.subPanel = {}
    UIRepositoryPanel.soldItemList = {}
    UIRepositoryPanel.soldObjList = {}
    UIRepositoryPanel.commonReceiveItem = nil
    UIRepositoryPanel.isDisassemble = false
    UIRepositoryPanel.equipDetail = nil
    UIRepositoryPanel.weaponDetail = nil
end

function UIRepositoryPanel:InitTabButton()
    for _, id in pairs(UIRepositoryGlobal.TabType) do
        local obj = UIUtils.GetObject(self.mUIRoot, "Trans_PageSwitcher/UI_CommonTabButtonItem" .. id)
        local item = UICommonTabButtonItem.New()
        item:InitCtrl(obj.transform)
        item.systemId = UIRepositoryGlobal.SystemIdList[id]
        item.tagId = id
        item:UpdateSystemLock()
        UIUtils.GetButtonListener(item.mBtn_ClickTab.gameObject).onClick = function()
            self:OnClickTab(item.tagId)
        end
        self.tabList[id] = item
    end

    if self.currentType ~= nil then
        self:OnClickTab(self.currentType)
    else
        self:OnClickTab(UIRepositoryGlobal.TabType.Item)
    end
end

function UIRepositoryPanel:InitSortButton()
    for _, id in pairs(UIRepositoryGlobal.SortType) do
        local button = {}
        local obj = UIUtils.GetObject(self.mUIRoot, "TopBar/Trans_FilterPanel/ItemSortType" .. id)
        button.obj = obj
        button.btnSort = UIUtils.GetRectTransform(obj, "Btn_SortingSwitch")
        button.transOff = UIUtils.GetRectTransform(obj, "Btn_SortingSwitch/Trans_Off")
        button.transDown = UIUtils.GetRectTransform(obj, "Btn_SortingSwitch/Trans_DownSortingOn")
        button.transUp = UIUtils.GetRectTransform(obj, "Btn_SortingSwitch/Trans_UpSortingOn")
        button.type = id
        button.isAscend = true

        UIUtils.GetButtonListener(button.btnSort.gameObject).onClick = function () self:OnClickSort(id) end
        self.sortList[id] = button
    end
end

function UIRepositoryPanel:UpdateFiltrateToggle()
    for _, toggle in pairs(self.mView.toggleList) do
        setactive(toggle.obj, false)
    end

    local filtrateList = nil
    if self.curPanel == UIRepositoryGlobal.PanelType.WeaponPanel then
        filtrateList = TableData.GlobalSystemData.RepositorySoldRankWeapon
    elseif self.curPanel == UIRepositoryGlobal.PanelType.EquipPanel then
        filtrateList = TableData.GlobalSystemData.RepositorySoldRankEquip
    end
    if filtrateList then
        for i = 0, filtrateList.Count - 1 do
            local rank = filtrateList[i]
            local toggle = self.mView.toggleList[i + 1]
            toggle.type = rank
            toggle.txtName.text = string_format(TableData.GetHintById(1050), tostring(rank))
            setactive(toggle.obj, true)

            toggle.toggleSelect.onValueChanged:AddListener(function (isOn) self:FiltrateToggleSelect(isOn, rank) end)
        end
    end
end

function UIRepositoryPanel:OnClickTab(id)
    if TipsManager.NeedLockTips(UIRepositoryGlobal.SystemIdList[id]) then
        return
    end

    if self.curTab == id or id == nil or id <= 0 then
        return
    end
    if self.curTab > 0 then
        local lastTab = self.tabList[self.curTab]
        lastTab:SetItemState(false)
    end
    local curTab = self.tabList[id]
    curTab:SetItemState(true)
    self.curTab = id

    self:UpdatePanelByType(id)
end

function UIRepositoryPanel:OnClickSort(id)
    local curSortButton = self.sortList[self.curSort]
    if self.curSort == id then
        curSortButton.isAscend = not curSortButton.isAscend
        setactive(curSortButton.transUp, curSortButton.isAscend)
        setactive(curSortButton.transDown, not curSortButton.isAscend)
    else
        if curSortButton then
            curSortButton.isAscend = true
            setactive(curSortButton.transUp, false)
            setactive(curSortButton.transDown, false)
            setactive(curSortButton.transOff, true)
        end

        local nowSortButton = self.sortList[id]
        setactive(nowSortButton.transOff, false)
        setactive(nowSortButton.transUp, nowSortButton.isAscend)
        setactive(nowSortButton.transDown, not nowSortButton.isAscend)
        self.curSort = id
    end

    self:UpdateSortList(self.curSort)
end

function UIRepositoryPanel:ResetItemListSort()
    local defaultSort = UIRepositoryGlobal.SortType.Level
    if self.curSort == defaultSort then
        self.curSort = 0
    end
    self:OnClickSort(defaultSort)
end

function UIRepositoryPanel:OnClickSold()
    self.isDisassemble = true
    self.mView.mVirtualList.constraintCount = 5
    self:InitFiltrateItemList()
    self:UpdateSoldContent()
    self:UpdateCurrentCount()
    self:UpdateConfirmBtn()
    self:UpdateFiltrateToggle()

    local itemList = self.subPanel[self.curPanel]:GetItemList()
    setactive(self.mView.mTrans_NoneItem, #itemList <= 0)
    setactive(self.mView.mTrans_SoldPanel, true)
    setactive(self.mView.mTrans_ItemBrief, true)
end

function UIRepositoryPanel:FiltrateToggleSelect(isOn, type)
    self:FiltrateItem(type, isOn)
    self:UpdateSoldContent()
    self:UpdateConfirmBtn()
end

function UIRepositoryPanel:InitFiltrateItemList()
    local subPanel = self.subPanel[self.curPanel]
    subPanel:InitFiltrateItemList()
end

function UIRepositoryPanel:FiltrateItem(type, isOn)
    local subPanel = self.subPanel[self.curPanel]
    subPanel:FiltrateItemList(type, isOn)
end

function UIRepositoryPanel:RefreshSubPanelItemList()
    local subPanel = self.subPanel[self.curPanel]
    subPanel:RefreshItemList()
    subPanel:ResetSelectItemList()

    setactive(self.mView.mTrans_NoneItem, #subPanel:GetItemList() <= 0)
end

function UIRepositoryPanel:OnCloseSold()
    setactive(self.mView.mTrans_ItemBrief, false)
    setactive(self.mView.mTrans_SoldPanel, false)

    self.mView.mVirtualList.constraintCount = 7

    -- setactive(self.mView.mTrans_NoneItem, false)
    for _, toggle in pairs(self.toggleList) do
        toggle.toggleSelect.isOn = false
    end

    self.soldItemList = {}
    self.isDisassemble = false
    self:RefreshSubPanelItemList()
    self:UpdateCurrentCount()
end

function UIRepositoryPanel:UpdateSortList(sortType)
    local curSort = self.sortList[sortType]
    local sortFunc = UIRepositoryGlobal:GetSortFunction(sortType, 1, curSort.isAscend)
    local subPanel = self.subPanel[self.curPanel]
    subPanel:SortItemList(sortFunc)
end

function UIRepositoryPanel:UpdatePanelByType(type, param)
    local isEquipOrWeapon = (type == UIRepositoryGlobal.PanelType.WeaponPanel) or (type == UIRepositoryGlobal.PanelType.EquipPanel)
    setactive(self.mView.mTrans_Capacity, isEquipOrWeapon)
    setactive(self.mView.mTrans_Sort, isEquipOrWeapon)
    setactive(self.mView.mTrans_Sold, isEquipOrWeapon)
    local curPanel = self.subPanel[self.curPanel]
    if curPanel then
        curPanel:Close()
    end
    local subPanel = self.subPanel[type]
    if subPanel then
        subPanel:Show()
        subPanel:UpdateItemList(param)
    end
    self.curPanel = type
    if isEquipOrWeapon then
        self:ResetItemListSort()
        self:UpdateCurrentCount()
    end
    local itemList = subPanel:GetItemList()
    setactive(self.mView.mTrans_NoneItem, #itemList <= 0)
end

function UIRepositoryPanel:UpdateCurrentCount()
    local maxLimit = 0
    local itemList = self.subPanel[self.curPanel]:GetItemList()
    if self.curPanel == UIRepositoryGlobal.PanelType.WeaponPanel then
        maxLimit = CS.GF2.Data.GlobalData.weapon_capacity
    elseif self.curPanel == UIRepositoryGlobal.PanelType.EquipPanel then
        maxLimit = CS.GF2.Data.GlobalData.equip_capacity
    end

    local text = self.isDisassemble and UIRepositoryGlobal.DisassembleCountText or UIRepositoryGlobal.CurrentCountText
    local title = self.isDisassemble and TableData.GetHintById(30012) or TableData.GetHintById(30011)
    self.mView.mText_CurrentCount.text = string_format(text, #itemList, maxLimit)
    self.mView.mText_CurrentTitle.text = title
end

--- 拆解
function UIRepositoryPanel:AddSoldItem(soldItem)
    if soldItem then
        for _, v in ipairs(soldItem) do
            local item = self:GetSoldItemById(v.id)
            if item then
                item.count = item.count + v.count
            else
                local tempItem = {}
                tempItem.id = v.id
                tempItem.count = v.count
                table.insert(self.soldItemList, tempItem)
                table.sort(self.soldItemList, function (a, b) return a.id < b.id end)
            end
        end

        self:UpdateSoldContent()
    end
end

function UIRepositoryPanel:RemoveSoldItem(soldItem)
    if soldItem then
        for _, v in ipairs(soldItem) do
            local item = self:GetSoldItemById(v.id)
            if item then
                item.count = item.count - v.count
                if item.count <= 0 then
                    self:RemoveSoldItemById(item.id)
                end
            end
        end

        self:UpdateSoldContent()
    end
end

function UIRepositoryPanel:UpdateSoldContent()
    self.mView.mText_SoldCount.text = #self:GetSelectItemList()

    if #self.soldObjList > #self.soldItemList then
        for i = #self.soldItemList + 1, #self.soldObjList do
            self.soldObjList[i]:SetData(nil)
        end
    end

    for i, soldItem in ipairs(self.soldItemList) do
        local item = nil
        if i <= #self.soldObjList then
            item = self.soldObjList[i]
        else
            local prefab =  UIUtils.GetGizmosPrefab(self.mPath_UICommonItemS,self)
            local instObj = instantiate(prefab)
            item = UICommonItemS.New()
            item:InitCtrl(instObj.transform)

            setparent(self.mView.mTrans_SoldItemRoot, instObj)
            instObj.transform.localScale = vectorone
            table.insert(self.soldObjList, item)
        end

        item:SetData(soldItem.id, soldItem.count)
    end
end

function UIRepositoryPanel:GetSoldItemById(id)
    for _, item in ipairs(self.soldItemList) do
        if item.id == id then
            return item
        end
    end
    return nil
end

function UIRepositoryPanel:RemoveSoldItemById(id)
    local index = 0
    for i, item in ipairs(self.soldItemList) do
        if item.id == id then
            index = i
        end
    end
    if index > 0 then
        table.remove(self.soldItemList, index)
    end
end

function UIRepositoryPanel:GetSelectItemList()
    local subPanel = self.subPanel[self.curPanel]
    return subPanel:GetSelectItemList()
end

function UIRepositoryPanel:UpdateConfirmBtn()
    local selectList = self:GetSelectItemList()
    setactive(self.mView.mTrans_CanNotDismantle, #selectList <= 0)
end

function UIRepositoryPanel:OnDismantle()
    local selectList = self:GetSelectItemList()
    if #selectList <= 0 then
        return
    end
    if self:CheckHaveHighRank(selectList) then
        MessageBoxPanel.ShowDoubleType(TableData.GetHintById(30013), function () self:DismantleItem(selectList) end)
        return
    else
        self:DismantleItem(selectList)
    end
end

function UIRepositoryPanel:DismantleItem(selectList)
    local idList = {}
    for _, item in ipairs(selectList) do
        table.insert(idList, item.id)
    end

    if self.curPanel == UIRepositoryGlobal.PanelType.EquipPanel then
        NetCmdGunEquipData:SendGunEquipDismantlingCmd(idList, function ()
            self:OnCloseSold()
        end)
    elseif self.curPanel == UIRepositoryGlobal.PanelType.WeaponPanel then
        NetCmdWeaponData:SendGunWeaponDismantle(idList, function ()
            self:OnCloseSold()
        end)
    end
end

function UIRepositoryPanel:CheckHaveHighRank(itemList)
    if itemList then
        for _, item in ipairs(itemList) do
            if UIRepositoryGlobal:IsHighRank(item.rank) then
                return true
            end
        end
    end
    return false
end

function UIRepositoryPanel.DismantleDrop(msg)
    self = UIRepositoryPanel

    local dropList = msg.Content
    if self.commonReceiveItem == nil then
        self.commonReceiveItem = UICommonReceiveItem.New()
        self.commonReceiveItem:InitCtrl(self.mUIRoot)
        UIUtils.GetButtonListener(self.commonReceiveItem.mBtn_Confirm.gameObject).onClick= function()
            UIRepositoryPanel:CloseTakeQuestRewardCallBack()
        end
    end

    self.commonReceiveItem:SetData(dropList)
end

function UIRepositoryPanel:CloseTakeQuestRewardCallBack()
    if self.commonReceiveItem ~= nil then
        self.commonReceiveItem:SetData(nil)
    end
end

function UIRepositoryPanel:UpdateEquipDetail(id)
    if self.equipDetail == nil then
        self.equipDetail = UICommonEquipBriefItem.New()
        self.equipDetail:InitCtrl(self.mView.mTrans_ItemBrief)
    end
    self.pointer.isInSelf = true
    self.equipDetail:SetData(UICommonEquipBriefItem.ShowType.Equip, id)
end

function UIRepositoryPanel:CloseEquipDetail()
    if self.equipDetail ~= nil then
        self.equipDetail:SetData(nil)
    end
end

function UIRepositoryPanel:UpdateWeaponDetail(id)
    if self.weaponDetail == nil then
        self.weaponDetail = UICommonWeaponBriefItem.New()
        self.weaponDetail:InitCtrl(self.mView.mTrans_ItemBrief)
    end
    -- print("ShowFlag" .. "true")
    self.pointer.isInSelf = true
    self.weaponDetail:SetData(UICommonWeaponBriefItem.ShowType.Weapon, id)
end

function UIRepositoryPanel:CloseWeaponDetail()
    if self.weaponDetail ~= nil then
        self.weaponDetail:SetData(nil)
    end
end

