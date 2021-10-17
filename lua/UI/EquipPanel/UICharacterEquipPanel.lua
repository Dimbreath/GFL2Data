require("UI.UIBasePanel")

UICharacterEquipPanel = class("UICharacterEquipPanel", UIBasePanel)
UICharacterEquipPanel.__index = UICharacterEquipPanel

UICharacterEquipPanel.curSlot = nil
UICharacterEquipPanel.curTab = nil
UICharacterEquipPanel.curPos = nil
UICharacterEquipPanel.curEquip = nil
UICharacterEquipPanel.curDropSet = nil
UICharacterEquipPanel.curSuitId = 0
UICharacterEquipPanel.equipSetList = {}
UICharacterEquipPanel.changeSetList = {}
UICharacterEquipPanel.attributeList = {}
UICharacterEquipPanel.changeAttrList = {}
UICharacterEquipPanel.equipList = {}
UICharacterEquipPanel.rightEquipDetail = nil
UICharacterEquipPanel.leftEquipDetail = nil
UICharacterEquipPanel.suitList = nil
UICharacterEquipPanel.suitDropList = nil
UICharacterEquipPanel.changeShowSet = false
UICharacterEquipPanel.isHide = false

UICharacterEquipPanel.sortContent = nil
UICharacterEquipPanel.sortList = {}
UICharacterEquipPanel.curSort = nil

function UICharacterEquipPanel:ctor()
    UICharacterEquipPanel.super.ctor(self)
end

function UICharacterEquipPanel.Close()
    self = UICharacterEquipPanel
    if self.curSuitId ~= 0 then
        self.curSuitId = 0
        self:CloseDetail()
        self:UpdatePanel()
    else
        UIManager.CloseUI(UIDef.UICharacterEquipPanel)
    end
end

function UICharacterEquipPanel.OnRelease()
    self = UICharacterEquipPanel
    UICharacterEquipPanel.curSlot = nil
    UICharacterEquipPanel.curTab = nil
    UICharacterEquipPanel.curPos = nil
    UICharacterEquipPanel.curEquip = nil
    UICharacterEquipPanel.equipSetList = {}
    UICharacterEquipPanel.changeSetList = {}
    UICharacterEquipPanel.attributeList = {}
    UICharacterEquipPanel.changeAttrList = {}
    UICharacterEquipPanel.rightEquipDetail = nil
    UICharacterEquipPanel.leftEquipDetail = nil
    UICharacterEquipPanel.equipList = {}
    UICharacterEquipPanel.suitList = nil
    UICharacterEquipPanel.changeShowSet = false
    UICharacterEquipPanel.suitDropList = nil
    UICharacterEquipPanel.sortContent = nil
    UICharacterEquipPanel.sortList = {}
    UICharacterEquipPanel.curSort = nil
end

function UICharacterEquipPanel.Init(root, data)
    self = UICharacterEquipPanel

    UICharacterEquipPanel.super.SetRoot(UICharacterEquipPanel, root)

    UICharacterEquipPanel.mView = UICharacterEquipPanelView.New()
    UICharacterEquipPanel.mView:InitCtrl(root)

    self.gunData = NetCmdTeamData:GetGunByID(data[1])
    self.curSlot = self.mView.slotList[data[2]]
    self.isHide = false

    self.leftPointer = UIUtils.GetPointerClickHelper(self.mView.mTrans_LeftDetail.gameObject, function()
        if UICharacterEquipPanel.leftEquipDetail then
            if UICharacterEquipPanel.rightPointer.isInSelf then
                UICharacterEquipPanel.leftPointer.isInSelf = true
                return
            end
            UICharacterEquipPanel:CloseDetail()
            UICharacterEquipPanel.leftEquipDetail:SetData(nil)
        end
    end, self.mView.mTrans_LeftDetail.gameObject)

    self.rightPointer = UIUtils.GetPointerClickHelper(self.mView.mTrans_RightDetail.gameObject, function()
        if UICharacterEquipPanel.rightEquipDetail then
            if UICharacterEquipPanel.leftPointer.isInSelf then
                UICharacterEquipPanel.rightPointer.isInSelf = true
                return
            end
            UICharacterEquipPanel:CloseDetail()
            UICharacterEquipPanel.rightEquipDetail:SetData(nil)
        end
    end, self.mView.mTrans_RightDetail.gameObject)
end

function UICharacterEquipPanel.OnInit()
    self = UICharacterEquipPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UICharacterEquipPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommandCenter.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_DropSet.gameObject).onClick = function()
        UICharacterEquipPanel:OnClickDropSetList()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Reset.gameObject).onClick = function()
        UICharacterEquipPanel:ResetEquip()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_ChangeLeft.gameObject).onClick = function()
        UICharacterEquipPanel:OnClickChangeShowBtn()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_ChangeRight.gameObject).onClick = function()
        UICharacterEquipPanel:OnClickChangeShowBtn()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CloseDrop.gameObject).onClick = function()
        UICharacterEquipPanel:OnCloseDropList()
    end

    self:InitTabButton()
    self:InitPosBtn()
    self:InitVirtualList()
    self:InitSortContent()

    self:UpdatePanel()
end

function UICharacterEquipPanel:InitTabButton()
    for _, tab in ipairs(self.mView.tabList) do
        UIUtils.GetButtonListener(tab.btnTab.gameObject).onClick = function()
            self:OnClickFiltrateTab(tab)
        end
    end
end

function UICharacterEquipPanel:InitPosBtn()
    for _, pos in ipairs(self.mView.posBtnList) do
        UIUtils.GetButtonListener(pos.btnPos.gameObject).onClick = function()
            self:OnClickPosBtn(pos)
        end
    end
end

function UICharacterEquipPanel:InitSortContent()
    if self.sortContent == nil then
        self.sortContent = UIEquipSortItem.New()
        self.sortContent:InitCtrl(self.mView.mTrans_Sort)

        UIUtils.GetButtonListener(self.sortContent.mBtn_Sort.gameObject).onClick = function()
            self:OnClickSortList()
        end

        UIUtils.GetButtonListener(self.sortContent.mBtn_Ascend.gameObject).onClick = function()
            self:OnClickAscend()
        end
    end

    local sortList = self:InstanceUIPrefab("UICommonFramework/ComScreenDropdownListItemV2.prefab", self.mView.mTrans_SortList)
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
            sort.sortCfg = UIEquipGlobal.SortCfg[i]
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

    self.curSort = self.sortList[UIEquipGlobal.SortType.Rank]
end

function UICharacterEquipPanel:InitBriefItem(parent)
    local item = UIBarrackBriefItem.New()
    item:InitCtrl(parent, function (id, isLock)
        self:UpdateEquipLock(id, isLock)
    end)
    item:SetChangeCallback(function ()
        self:CloseDetail()
        self:UpdatePanel()
        self:UpdateLeftDetail(nil)
        self:UpdateRightDetail(nil)
    end)
    item:SetLevelUpCallback(function ()
        self:CloseDetail()
        self:UpdateLeftDetail(nil)
        self:UpdateRightDetail(nil)
    end)
    item:SetGunId(self.gunData.id)

    return item
end

function UICharacterEquipPanel:OnClickFiltrateTab(tab)
    if self.curTab then
        if self.curTab.index == tab.index then
            return
        end
        self.curTab.btnTab.interactable = true
    end
    tab.btnTab.interactable = false
    self.curTab = tab

    self:UpdateChangeListByTab(self.curTab.index)
end

function UICharacterEquipPanel:OnClickPosBtn(pos)
    if self.curPos then
        if self.curPos.index == pos.index then
            return
        end
        self.curPos.btnPos.interactable = true
    end
    pos.btnPos.interactable = false
    self.curPos = pos

    self:CloseDetail()
    self:UpdateEquipListByPos(self.curPos.index)
    self:UpdateSlotByPos(self.curPos.index)
end

function UICharacterEquipPanel:TabBtnCommonFunc(tab, selectTab)
    if tab then
        if tab.index == selectTab.index then
            return false
        end
        setactive(tab.transSelect, false)
    end
    setactive(selectTab.transSelect, true)
    tab = selectTab
    return true
end

function UICharacterEquipPanel:OnShow()
    self = UICharacterEquipPanel
    if self.isHide then
        self:UpdatePanel()
        self.isHide = false
    end
end

function UICharacterEquipPanel.OnHide()
    self = UICharacterEquipPanel
    self.isHide = true
end

function UICharacterEquipPanel:UpdatePanel()
    self:UpdateSlotList(self.mView.slotList)
    self:UpdateEquipSet(self.changeSetList, self.mView.mTrans_ChangeShowSetList, self.mView.mTrans_ChangeSetEmpty)
    self:UpdateAttribute(self.changeAttrList, self.mView.mTrans_ChangeAttrList, self.mView.mTrans_ChangeAttrEmpty)
    self:UpdateChangeShowInfo()
    if self.curTab == nil then
        self:OnClickFiltrateTab(self.mView.tabList[2])
    else
        self:UpdateChangeListByTab(self.curTab.index)
    end
end

function UICharacterEquipPanel:UpdateEquipSet(itemList, parent, transEmpty)
    local setList = self.gunData:GetGunEquipSet()
    for _, item in ipairs(itemList) do
        item:SetData(nil)
    end

    local item = nil
    local count = 0
    for id, num in pairs(setList) do
        for i = 1, num do
            count = count + 1
            if count <= #itemList then
                item = itemList[count]
            else
                item = UIEquipSetItem.New()
                item:InitCtrl(parent)
                table.insert(itemList, item)
            end
            local count = self.gunData:GetEquipSetById(id)
            item:SetData(id, count)
        end
    end

    setactive(transEmpty, count <= 0)
end

function UICharacterEquipPanel:UpdateAttribute(itemList, parent, transEmpty)
    for _, item in ipairs(itemList) do
        item:SetData(nil)
    end

    local list = self.gunData.GetGunEquipAttrList
    if not list then
        setactive(transEmpty, true)
        return
    end
    local item = nil
    for i = 0, list.Count - 1 do
        if i + 1 <= #itemList then
            item = itemList[i + 1]
        else
            item = UICommonPropertyItem.New()
            item:InitCtrl(parent)
            table.insert(itemList, item)
        end
        local value = self.gunData:GetGunEquipValueByName(list[i])
        item:SetDataByName(list[i], value, true, false, false, true)
    end

    setactive(transEmpty, list.Count <= 0)
end

function UICharacterEquipPanel:UpdateSlotList(list)
    for _, slot in ipairs(list) do
        local equipData = self.gunData:GetEquipBar(slot.index - 1)
        self:UpdateSlot(slot, equipData)
    end
end

function UICharacterEquipPanel:CheckHadEquip(list)
    for _, slot in ipairs(list) do
        if slot.data.HasEquip then
            return true
        end
    end
    return false
end

function UICharacterEquipPanel:UpdateSlot(slot, data)
    if data then
        slot.data = data
        slot.animator:SetBool("EquipStated", data.HasEquip)
        if data.HasEquip then
            local equipData = data.EquipData
            slot.imageIcon.sprite = IconUtils.GetEquipSprite(equipData.icon)
            slot.textLv.text = GlobalConfig.LVText .. equipData.level
            slot.imgBg.color = TableData.GetGlobalGun_Quality_Color2(equipData.rank)
            slot.imgLine.color = TableData.GetGlobalGun_Quality_Color2(equipData.rank)
            UIUtils.SetAlpha(slot.imgBg, 49 / 100)
            if self.curSlot ~= nil then
                setactive(slot.transSelect.gameObject, self.curSlot.index == slot.index)
            end
        end

        UIUtils.GetButtonListener(slot.btnEquip.gameObject).onClick = function()
            self:OnClickSlot(slot)
        end

    end
end

function UICharacterEquipPanel:OnClickSlot(slot)
    self:OnClickChangeSlot(slot)
end

function UICharacterEquipPanel:OnClickChangeSlot(slot)
    if self.curSlot then
        if self.curSlot.index == slot.index then
            local equipId = self.curSlot.data.HasEquip and self.curSlot.data.EquipData.id or nil
            self:UpdateSlotEquipDetail(equipId, slot.index)
            return
        end
        setactive(self.curSlot.transSelect, false)
    end
    setactive(slot.transSelect, true)
    self.curSlot = slot

    self:CloseDetail()
    self:UpdateEquipListByPos(self.curSlot.index)
    self:UpdatePosBySlot(self.curSlot.index)

    --if self.curTab.index == UIEquipGlobal.FiltrateType.Suit then
    --    local equipId = slot.data.HasEquip and slot.data.EquipData.id or nil
    --    self:CloseDetail()
    --    self:UpdateSlotEquipDetail(equipId, slot.index)
    --elseif self.curTab.index == UIEquipGlobal.FiltrateType.Position then
    --
    --end
end

function UICharacterEquipPanel:UpdateSlotEquipDetail(id)
    self:UpdateLeftDetail(id, false)
end

function UICharacterEquipPanel:UpdateChangeListByTab(tabType)
    self:CloseDetail()
    if tabType == UIEquipGlobal.FiltrateType.Position then
        self.curSuitId = 0
        if self.curSlot == nil then
            self.curSlot = self.mView.slotList[1]
            setactive(self.curSlot.transSelect, true)
        end
        self:UpdateEquipListByPos(self.curSlot.index)
        self:UpdatePosBySlot(self.curSlot.index)
    elseif tabType == UIEquipGlobal.FiltrateType.Suit then
        if self.curSuitId ~= 0 then
            self:OnClickEquipSet(self.curSuitId)
        else
            self:UpdateSuitList()
            self:UpdatePosBySlot(nil)
            self:UpdateSlotByPos(nil)
            setactive(self.mView.mTrans_EquipListEmpty, false)
        end
    end
    setactive(self.mView.mTrans_SortContent, tabType == UIEquipGlobal.FiltrateType.Position or self.curSuitId ~= 0)
    setactive(self.mView.mTrans_ChangePos, tabType == UIEquipGlobal.FiltrateType.Position or self.curSuitId ~= 0)
    setactive(self.mView.mTrans_ChangeSet, tabType == UIEquipGlobal.FiltrateType.Suit and self.curSuitId == 0)
    setactive(self.mView.mTrans_DropSetBtn, tabType == UIEquipGlobal.FiltrateType.Suit and self.curSuitId ~= 0)
    setactive(self.mView.mTrans_ButtonGroup, self.curSuitId == 0)
end

function UICharacterEquipPanel:UpdateSuitList()
    if self.suitList == nil then
        self.suitList = UIEquipGlobal:GetEquipSetList()
        for i = 1, #self.suitList do
            local data = self.suitList[i]
            local item = UIEquipOverViewItem.New()
            item:InitCtrl(self.mView.mTrans_ChangeSetList)
            item:SetData(data)

            UIUtils.GetButtonListener(item.mBtn_Detail.gameObject).onClick = function()
                self:OnClickEquipSet(data.id)
            end
        end
    end

    self.mView.mScroll_SetList.verticalNormalizedPosition = 1
end

function UICharacterEquipPanel:UpdateDropSuitList()
    if self.suitDropList == nil then
        self.suitDropList = {}
        local list = UIEquipGlobal:GetEquipSetList()
        for i = 1, #list do
            local data = list[i]
            local item = UIEquipSuitDropdownItem.New()
            item:InitCtrl(self.mView.mTrans_DropSetList)
            item:SetData(data.id)

            UIUtils.GetButtonListener(item.mBtn_Suit.gameObject).onClick = function()
                self:OnClickDropSet(item)
            end

            table.insert(self.suitDropList, item)
        end
    end

    for _, item in ipairs(self.suitDropList) do
        if item.setId == self.curSuitId then
            self.curDropSet = item
            self.curDropSet.mBtn_Suit.interactable = false
            break
        end
    end

    setactive(self.mView.mTrans_DropSet, true)
end

function UICharacterEquipPanel:OnClickDropSetList()
    self:UpdateDropSuitList()
    setactive(self.mView.mTrans_DropSet, true)
end

function UICharacterEquipPanel:OnCloseDropList()
    if self.curDropSet then
        self.curDropSet.mBtn_Suit.interactable = true
    end
    setactive(self.mView.mTrans_DropSet, false)
end

function UICharacterEquipPanel:OnClickDropSet(item)
    if item == nil then
        if self.curDropSet then
            self.curDropSet.mBtn_Suit.interactable = true
            self.curSlot = nil
        end
        return
    end

    if self.curDropSet then
        if self.curDropSet.setId == item.setId then
            return
        end
        self.curDropSet.mBtn_Suit.interactable = true
    end
    item.mBtn_Suit.interactable = false
    self.curDropSet = item

    self:OnClickEquipSet(self.curDropSet.setId)
    self:OnCloseDropList()
end

function UICharacterEquipPanel:OnClickEquipSet(suitId)
    local setData = TableData.listEquipSetDatas:GetDataById(suitId)
    self.curSuitId = suitId
    self:UpdateEquipListBySuit(suitId)
    self:ResetPos()
    self.mView.mText_DropSetName.text = setData.name.str
    setactive(self.mView.mTrans_ChangePos, true)
    setactive(self.mView.mTrans_ChangeSet, false)
    setactive(self.mView.mTrans_DropSetBtn, true)
    setactive(self.mView.mTrans_SortContent, true)
    setactive(self.mView.mTrans_ButtonGroup, false)
end

function UICharacterEquipPanel:UpdateEquipListByPos(index)
    self.equipList = self:GetEquipListByPos(index, self.curSuitId)
    self:OnClickSort(self.curSort.sortType)
    setactive(self.mView.mTrans_EquipListEmpty, #self.equipList <= 0)
end

function UICharacterEquipPanel:UpdateEquipListBySuit(suitId)
    self.equipList = self:GetEquipListBySuit(suitId)
    self:OnClickSort(self.curSort.sortType)
    setactive(self.mView.mTrans_EquipListEmpty, #self.equipList <= 0)
end

function UICharacterEquipPanel:UpdateSlotByPos(index)
    if index == nil then
        if self.curSlot then
            setactive(self.curSlot.transSelect, false)
            self.curSlot = nil
        end
        return
    end

    if self.curSlot then
        if self.curSlot.index == index then
            return
        end
        setactive(self.curSlot.transSelect, false)
    end
    setactive(self.mView.slotList[index].transSelect, true)
    self.curSlot = self.mView.slotList[index]
end

function UICharacterEquipPanel:UpdatePosBySlot(index)
    if index == nil then
        if self.curPos then
            self.curPos.btnPos.interactable = true
            self.curPos = nil
        end
        return
    end

    if self.curPos then
        if self.curPos.index == index then
            return
        end
        self.curPos.btnPos.interactable = true
    end
    self.mView.posBtnList[index].btnPos.interactable = false
    self.curPos = self.mView.posBtnList[index]
end

function UICharacterEquipPanel:GetEquipListByPos(index, setId)
    local equipList = {}
    local list = NetCmdEquipData:GetEquipListByIndex(index, setId)
    if list then
        for i = 0, list.Count - 1 do
            if list[i].gun_id ~= self.gunData.id then
                local data = UIEquipGlobal:GetMaterialSimpleData(list[i], UIEquipGlobal.MaterialType.Equip)
                table.insert(equipList, data)
            end
        end
    end

    return equipList
end

function UICharacterEquipPanel:GetEquipListBySuit(suitId)
    local equipList = {}
    local list = NetCmdEquipData:GetEquipListBySetId(suitId)
    if list then
        for i = 0, list.Count - 1 do
            if list[i].gun_id ~= self.gunData.id then
                local data = UIEquipGlobal:GetMaterialSimpleData(list[i], UIEquipGlobal.MaterialType.Equip)
                table.insert(equipList, data)
            end
        end
    end

    return equipList
end

function UICharacterEquipPanel:ResetEquipIndex(list)
    if list then
        for i, item in ipairs(list) do
            item.index = i - 1
        end
    end
end

function UICharacterEquipPanel:InitVirtualList()
    self.mView.mVirtualList.itemProvider = function()
        local item = self:EquipItemProvider()
        return item
    end

    self.mView.mVirtualList.itemRenderer = function(index, rendererData)
        self:EquipItemRenderer(index, rendererData)
    end
end

function UICharacterEquipPanel:EquipItemProvider()
    local itemView = UIEquipMaterialItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UICharacterEquipPanel:EquipItemRenderer(index, renderDataItem)
    local itemData = self.equipList[index + 1]
    local item = renderDataItem.data
    item:SetReplaceEquip(itemData)
    -- item.instanceId = index

    UIUtils.GetButtonListener(item.mBtn_Select.gameObject).onClick = function()
        self:OnClickEquip(item)
    end
end

function UICharacterEquipPanel:OnClickEquip(equip)
    if self.curEquip then
        if self.curEquip.id == equip.equipData.id then
            return
        end
        self.curEquip.selectCount = 0
        self.mView.mVirtualList:RefreshItem(self.curEquip.index)
    end
    equip.equipData.selectCount = 1
    self.curEquip = equip.equipData
    equip:EnableSelect(true)

    local equipId = self:GetEquipIdBySlotIndex(equip.equipData.category)
    if equipId ~= nil then
        self:UpdateLeftDetail(equipId, true, true)
        self:UpdateRightDetail(equip.equipData.id, true, true)
    else
        self:UpdateLeftDetail(equip.equipData.id, true, false)
        self:UpdateRightDetail(nil)
    end
end

function UICharacterEquipPanel:GetEquipIdBySlotIndex(index)
    local curSlot = self.mView.slotList[index]
    if curSlot then
        if curSlot.data.HasEquip then
            return curSlot.data.EquipData.id
        else
            return nil
        end
    end
end

function UICharacterEquipPanel:UpdateRightDetail(equipId, isCompare, hasEquiped)
    if self.rightEquipDetail == nil then
        self.rightEquipDetail = self:InitBriefItem(self.mView.mTrans_RightDetail)
    end

    if equipId == nil then
        self.rightEquipDetail:SetData(nil)
        return
    end
    self.rightEquipDetail:SetData(UIBarrackBriefItem.ShowType.Equip, equipId)
    self.rightEquipDetail:SetEquipCompareButtonGroup(isCompare, hasEquiped)
    self.rightPointer.isInSelf = true
end

function UICharacterEquipPanel:UpdateLeftDetail(equipId, isCompare, hasEquiped)
    if self.leftEquipDetail == nil then
        self.leftEquipDetail = self:InitBriefItem(self.mView.mTrans_LeftDetail)
    end

    if equipId == nil then
        self.leftEquipDetail:SetData(nil)
        return
    end
    self.leftEquipDetail:SetData(UIBarrackBriefItem.ShowType.Equip, equipId)
    self.leftEquipDetail:SetEquipCompareButtonGroup(isCompare, hasEquiped)
    self.leftPointer.isInSelf = true
end


function UICharacterEquipPanel:CloseDetail()
    if self.curEquip then
        self.curEquip.selectCount = 0
        self.mView.mVirtualList:RefreshItem(self.curEquip.index)
        self.curEquip = nil
    end

    --self:UpdateLeftDetail(nil)
    --self:UpdateRightDetail(nil)
end

function UICharacterEquipPanel:ResetEquip()
    if self:CheckHadEquip(self.mView.slotList) then
        NetCmdGunEquipData:SendEquipBelongCmd(self.gunData.id, 0, 0, function (ret)
            if ret == CS.CMDRet.eSuccess then
                self:CloseDetail()
                self:UpdatePanel()
            end
        end)
    end
end

function UICharacterEquipPanel:ResetTab()
    for _, tab in ipairs(self.mView.tabList) do
        tab.btnTab.interactable = true
    end
end

function UICharacterEquipPanel:ResetPos()
    for _, pos in ipairs(self.mView.posBtnList) do
        pos.btnPos.interactable = true
    end
    self.curPos = nil
end

function UICharacterEquipPanel:OnClickChangeShowBtn()
    self.changeShowSet = not self.changeShowSet
    self:UpdateChangeShowInfo()
end


function UICharacterEquipPanel:OnClickSortList()
    setactive(self.mView.mTrans_SortList, true)
end

function UICharacterEquipPanel:CloseItemSort()
    setactive(self.mView.mTrans_SortList, false)
end

function UICharacterEquipPanel:OnClickSort(type)
    if type then
        if self.curSort then
            if self.curSort.sortType ~= type then
                self.curSort.btnSort.interactable = true
            end
        end
        self.curSort = self.sortList[type]
        self.curSort.isAscend = false
        self.curSort.btnSort.interactable = false
        self.sortContent:SetData(self.curSort)

        self:UpdateListBySort()

        self:CloseItemSort()
    end
end

function UICharacterEquipPanel:OnClickAscend()
    if self.curSort then
        self.curSort.isAscend = not self.curSort.isAscend
        self.sortContent:SetData(self.curSort)

        self:UpdateListBySort()
    end
end

function UICharacterEquipPanel:UpdateListBySort()
    local sortFunc = self.sortContent.sortFunc
    table.sort(self.equipList, sortFunc)

    self.mView.mVirtualList.numItems = #self.equipList
    self.mView.mVirtualList:Refresh()

    self.mView.mVirtualList.verticalNormalizedPosition = 1

    self:ResetEquipIndex(self.equipList)
end

function UICharacterEquipPanel:UpdateEquipLock(id, isLock)
    for _, item in ipairs(self.equipList) do
        if item.id == id then
            item.isLock = isLock
            break
        end
    end
    self.mView.mVirtualList:Refresh()
end

function UICharacterEquipPanel:UpdateChangeShowInfo()
    self.mView.mBtn_ChangeLeft.interactable = self.changeShowSet
    self.mView.mBtn_ChangeRight.interactable = not self.changeShowSet
    setactive(self.mView.mTrans_ShowInfo, not self.changeShowSet)
    setactive(self.mView.mTrans_ShowSet, self.changeShowSet)
end

function UICharacterEquipPanel:OnClickPowerInfo()
    UIManager.OpenUIByParam(UIDef.UICharacterPropPanel, self.gunData.id)
end


