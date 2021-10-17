---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by jingkai.
--- DateTime: 2021/4/28 16:28
---
require("UI.UIBasePanel")
require("UI.RepositoryPanelV2.UIRepositoryDecomposePanelV2View")
---@class UIRepositoryDecomposePanelV2 : UIBasePanel
UIRepositoryDecomposePanelV2 = class("UIRepositoryDecomposePanelV2", UIBasePanel)
UIRepositoryDecomposePanelV2.__index = UIRepositoryDecomposePanelV2
---@type UIRepositoryDecomposePanelV2View
UIRepositoryDecomposePanelV2.mView = nil
UIRepositoryDecomposePanelV2.isHide = false
UIRepositoryDecomposePanelV2.curPanelType = false
UIRepositoryDecomposePanelV2.soldItemList = {}
UIRepositoryDecomposePanelV2.soldObjList = {}
UIRepositoryDecomposePanelV2.selectItemList = {}
UIRepositoryDecomposePanelV2.selectItemIdList = {}
UIRepositoryDecomposePanelV2.skillList = {}
UIRepositoryDecomposePanelV2.suitList = {}
UIRepositoryDecomposePanelV2.attributeList = {}
UIRepositoryDecomposePanelV2.isSortDropDownActive = false
UIRepositoryDecomposePanelV2.isSuitDropDownActive = false
UIRepositoryDecomposePanelV2.isAscend = false
UIRepositoryDecomposePanelV2.curSort = UIRepositoryGlobal.SortType.Level
UIRepositoryDecomposePanelV2.curSuit = 0
UIRepositoryDecomposePanelV2.itemViewList = {}
UIRepositoryDecomposePanelV2.isSelectStar1 = false
UIRepositoryDecomposePanelV2.isSelectStar2 = false
UIRepositoryDecomposePanelV2.isSelectStar3 = false
UIRepositoryDecomposePanelV2.subProp = {}
UIRepositoryDecomposePanelV2.panelType = {
    EQUIP = 1,
    WEAPON = 2,
    WEAPON_PARTS = 3
}

function UIRepositoryDecomposePanelV2:ctor()
    UIRepositoryDecomposePanelV2.super.ctor(self)
end

function UIRepositoryDecomposePanelV2.Init(root, data)
    self = UIRepositoryDecomposePanelV2
    UIRepositoryDecomposePanelV2.super.SetRoot(UIRepositoryDecomposePanelV2, root)
    self.isHide = false
    ---@type UIRepositoryDecomposePanelV2View
    self.mView = UIRepositoryDecomposePanelV2View.New()
    self.mView:InitCtrl(root, data[1])

    self.curPanelType = data[1]
    if data[2] ~= nil then
        self.mIsPop = data[2]
    end
end

function UIRepositoryDecomposePanelV2.listToTable(clrlist)
    local t = {}
    local it = clrlist:GetEnumerator()
    while it:MoveNext() do
        if not it.Current.IsEquipped and not it.Current.locked and not it.Current.IsLocked and (it.Current.PartsCount == nil or it.Current.PartsCount == 0) then
            t[#t+1] = it.Current
        end
    end
    return t
end

function UIRepositoryDecomposePanelV2.OnCommanderCenter()
    UIManager.JumpToMainPanel()
end

function UIRepositoryDecomposePanelV2.OnSelectStar1(isOn)
    self = UIRepositoryDecomposePanelV2
    self.isSelectStar1 = isOn
    self:UpdateSelect(1, self.isSelectStar1)
    self.mView.mAnimator_Star1:SetBool("Sel", isOn)
    self.virtualList:Refresh()
end

function UIRepositoryDecomposePanelV2.OnSelectStar2(isOn)
    self = UIRepositoryDecomposePanelV2
    self.isSelectStar2 = isOn
    self:UpdateSelect(2, self.isSelectStar2)
    self.mView.mAnimator_Star2:SetBool("Sel", isOn)
    self.virtualList:Refresh()
end

function UIRepositoryDecomposePanelV2.OnSelectStar3(isOn)
    self = UIRepositoryDecomposePanelV2
    self.isSelectStar3 = isOn
    self:UpdateSelect(3, self.isSelectStar3)
    self.mView.mAnimator_Star3:SetBool("Sel", isOn)
    self.virtualList:Refresh()
end

function UIRepositoryDecomposePanelV2.OnDropDown()
    self = UIRepositoryDecomposePanelV2
    setactive(self.mView.mTrans_Screen, true)
end

function UIRepositoryDecomposePanelV2.OnSuitDropDown()
    self = UIRepositoryDecomposePanelV2
    setactive(self.mView.mTrans_Suit, true)
end

function UIRepositoryDecomposePanelV2.OnScreenClose()
    self = UIRepositoryDecomposePanelV2
    setactive(self.mView.mTrans_Screen, false)
end

function UIRepositoryDecomposePanelV2.OnSuitClose()
    self = UIRepositoryDecomposePanelV2
    setactive(self.mView.mTrans_Suit, false)
end

function UIRepositoryDecomposePanelV2.OnAscend()
    self = UIRepositoryDecomposePanelV2
    self.isAscend = not self.isAscend
    self:UpdateSortList(self.curSort)
end

function UIRepositoryDecomposePanelV2.OnInit()
    self = UIRepositoryDecomposePanelV2

    UIUtils.GetButtonListener(self.mView.mBtn_Back.gameObject).onClick = self.OnReturnClick

    UIUtils.GetButtonListener(self.mView.mBtn_Home.gameObject).onClick = self.OnCommanderCenter


    self.mView.mBtn_Star1.onValueChanged:AddListener(function (isOn)
        UIRepositoryDecomposePanelV2.OnSelectStar1(isOn)
    end)

    self.mView.mBtn_Star2.onValueChanged:AddListener(function (isOn)
        UIRepositoryDecomposePanelV2.OnSelectStar2(isOn)
    end)

    self.mView.mBtn_Star3.onValueChanged:AddListener(function (isOn)
        UIRepositoryDecomposePanelV2.OnSelectStar3(isOn)
    end)
    --UIUtils.GetButtonListener(self.mView.mBtn_Star1.gameObject).onClick = self.OnSelectStar1
    --
    --UIUtils.GetButtonListener(self.mView.mBtn_Star2.gameObject).onClick = self.OnSelectStar2
    --
    --UIUtils.GetButtonListener(self.mView.mBtn_Star3.gameObject).onClick = self.OnSelectStar3

    UIUtils.GetButtonListener(self.mView.mBtn_3Item.gameObject).onClick = self.OnDismantle

    if self.curPanelType == UIRepositoryDecomposePanelV2.panelType.EQUIP then
        UIUtils.GetButtonListener(self.mView.mBtn_SuitDropdown.gameObject).onClick = self.OnSuitDropDown
        UIUtils.GetBlockHelper(self.mView.mTrans_Suit.gameObject).onHide = self.OnSuitClose
        local equipList = NetCmdEquipData:GetEquipListBySetId(0)
        self.itemList = self.listToTable(equipList)
        self.virtualList = self.mView.mVirtualList_EquipAll
        self.virtualList.itemProvider = self.EquipProvider
        setactive(self.mView.mTrans_LeftEquip, true)
        setactive(self.mView.mTrans_EquipSuitList.transform, true)
        self:InitSuitButton()
    else
        local weaponList = NetCmdWeaponData:GetEnhanceWeaponList(0)
        self.itemList = self.listToTable(weaponList)
        self.virtualList = self.mView.mVirtualList_Weapon
        self.virtualList.itemProvider = self.WeaponProvider
        setactive(self.mView.mList_WeaponSuit.transform, true)
    end
    UIUtils.GetButtonListener(self.mView.mBtn_Screen.gameObject).onClick = self.OnAscend
    UIUtils.GetButtonListener(self.mView.mBtn_Dropdown.gameObject).onClick = self.OnDropDown
    UIUtils.GetBlockHelper(self.mView.mTrans_Screen.gameObject).onHide = self.OnScreenClose
    self:InitSortButton()
    setactive(self.mView.mTrans_Action, true)
    setactive(self.mView.mTrans_RightList, false)
    setactive(self.mView.mTrans_Equip, self.curPanelType == UIRepositoryDecomposePanelV2.panelType.EQUIP)
    setactive(self.mView.mTrans_Weapon, self.curPanelType == UIRepositoryDecomposePanelV2.panelType.WEAPON)
    setactive(self.mView.mTrans_WeaponParts, self.curPanelType == UIRepositoryDecomposePanelV2.panelType.WEAPON_PARTS)

    self:UpdateConfirmBtn()
    self:UpdateCurrentCount()
end

function UIRepositoryDecomposePanelV2:CanSelect(data)
    if self.curPanelType == UIRepositoryDecomposePanelV2.panelType.EQUIP then
        return (self.isSelectStar1 and TableData.GlobalSystemData.QualityStar[data.Rank - 1] == 1) or (self.isSelectStar2 and TableData.GlobalSystemData.QualityStar[data.Rank - 1] == 2) or (self.isSelectStar3 and TableData.GlobalSystemData.QualityStar[data.Rank - 1] == 3)
    else
        return (self.isSelectStar1 and TableData.GlobalSystemData.QualityStar[data.Rank - 1] == 1) or (self.isSelectStar2 and TableData.GlobalSystemData.QualityStar[data.Rank - 1] == 2) or (self.isSelectStar3 and TableData.GlobalSystemData.QualityStar[data.Rank - 1] == 3)
    end
end

function UIRepositoryDecomposePanelV2:CheckHaveHighRank(itemList)
    if itemList then
        for _, item in ipairs(itemList) do
            local rank = item.rank or item.Rank
            if UIRepositoryGlobal:IsHighRank(rank) then
                return true
            end
        end
    end
    return false
end

function UIRepositoryDecomposePanelV2.OnDismantle()
    self = UIRepositoryDecomposePanelV2
    local selectList = self.selectItemList
    if #selectList <= 0 then
        return
    end
    if self:CheckHaveHighRank(selectList) then
        MessageBoxPanel.ShowDoubleType(TableData.GetHintById(30013), self.OnDismantle)
        return
    else
        self:DismantleItem(selectList)
    end
end

function UIRepositoryDecomposePanelV2.OnDismantle()
    self = UIRepositoryDecomposePanelV2
    self:DismantleItem(self.selectItemList)
end

function UIRepositoryDecomposePanelV2:DismantleItem(selectList)
    local idList = {}
    for _, item in ipairs(selectList) do
        table.insert(idList, item.id)
    end

    if self.curPanelType == UIRepositoryDecomposePanelV2.panelType.EQUIP then
        NetCmdGunEquipData:SendGunEquipDismantlingCmd(idList, function (ret)
            self:OnCloseSold(ret)
        end)
    elseif self.curPanelType == UIRepositoryDecomposePanelV2.panelType.WEAPON then
        NetCmdWeaponData:SendGunWeaponDismantle(idList, function (ret)
            self:OnCloseSold(ret)
        end)
    end
end

function UIRepositoryDecomposePanelV2.UpdateItemList()
    self = UIRepositoryDecomposePanelV2
    self.soldItemList = {}
    self.selectItemIdList = {}
    for _, item in ipairs(self.itemList) do
        local soldItem = self:GetSoldItem(item)
        self:RemoveSelectItemById(item.id)
        self:RemoveSoldItem(soldItem)
    end
    self:ResetRankButtons()
    if self.curPanelType == UIRepositoryDecomposePanelV2.panelType.EQUIP then
        local equipList = NetCmdEquipData:GetEquipListBySetId(self.curSuit)
        self.itemList = self.listToTable(equipList)
    elseif self.curPanelType == UIRepositoryDecomposePanelV2.panelType.WEAPON then
        local weaponList = NetCmdWeaponData:GetEnhanceWeaponList(0)
        self.itemList = self.listToTable(weaponList)
    end
    if self.sortFunc then
        table.sort(self.itemList, self.sortFunc)
    end
    self.virtualList.numItems = #self.itemList
    self.virtualList:Refresh()
    self:CheckDetail()
    self:UpdateCurrentCount()
    self:UpdateSoldContent()
    self:UpdateConfirmBtn()
    if self.curPanelType == UIRepositoryDecomposePanelV2.panelType.EQUIP then
        self.suitList[self.curSuit].mText_SuitNum.text = #self.itemList
    end
end

function UIRepositoryDecomposePanelV2:OnCloseSold(ret)
    if ret == CS.CMDRet.eSuccess then
        UIManager.OpenUIByParam(UIDef.UICommonReceivePanel)
        UIRepositoryPanelV2:RefreshContent()
        self.UpdateItemList()
    else
        gferror("Dismantle Failed !!!!!")
    end
end

function UIRepositoryDecomposePanelV2:UpdateCurrentCount()
    self.mView.mText_NumNow.text = #self.selectItemList
    self.mView.mText_NumTotal.text = "/" .. #self.itemList
end

function UIRepositoryDecomposePanelV2:GetSoldItem(data)
    local soldItem = nil
    if self.curPanelType == UIRepositoryDecomposePanelV2.panelType.EQUIP then
        soldItem = UIRepositoryGlobal:GetSoldOutItem(data.TableData.sold_get)
    else
        soldItem = UIRepositoryGlobal:GetSoldOutItem(data.StcData.sold_get)
    end
    return soldItem
end

function UIRepositoryDecomposePanelV2:UpdateSelect(i, select)
    for _, item in ipairs(self.itemList) do
        local rank = item.rank or item.Rank
        local soldItem = self:GetSoldItem(item)
        if TableData.GlobalSystemData.QualityStar[rank - 1] == i then
            if select and not self.selectItemIdList[item.id] then
                table.insert(self.selectItemList, item)
                self.selectItemIdList[item.id] = true
                self:AddSoldItem(soldItem)

            end
            if not select then
                self:RemoveSelectItemById(item.id)
                self:RemoveSoldItem(soldItem)
            end
        end
    end
    self:UpdateSoldContent()
    self:CheckDetail()
    self:UpdateConfirmBtn()
end

function UIRepositoryDecomposePanelV2:InitSuitButton()
    local sortOptionPrefab = UIUtils.GetGizmosPrefab("Character/ChrEquipSuitDropDownItemV2.prefab", self)
    ---@type ChrEquipSuitDropdownItemV2
    local item = ChrEquipSuitDropdownItemV2.New()
    local obj = instantiate(sortOptionPrefab, self.mView.mContent_Suit.transform)
    item:InitCtrl(obj.transform)
    item:SetZeroData(#self.itemList, self.OnClickSuit)
    self.suitList[0] = item
    local setList = TableData.listEquipSetDatas
    for i = 0, setList.Count - 1 do
        ---@type ChrEquipSuitDropdownItemV2
        item = ChrEquipSuitDropdownItemV2.New()
        obj = instantiate(sortOptionPrefab, self.mView.mContent_Suit.transform)
        item:InitCtrl(obj.transform)
        item:SetData(setList[i], self.OnClickSuit)
        self.suitList[setList[i].id] = item
    end
    self.mView.mText_Dropdown_SuitName.text = TableData.GetHintById(1051)
end

function UIRepositoryDecomposePanelV2:InitSortButton()
    local sortOptionPrefab = UIUtils.GetGizmosPrefab("Character/ChrEquipSuitDropDownItemV2.prefab", self)

    for _, id in pairs(UIRepositoryGlobal.SortType) do
        ---@type ChrEquipSuitDropdownItemV2
        local item = ChrEquipSuitDropdownItemV2.New()
        local obj = instantiate(sortOptionPrefab, self.mView.mContent_Screen.transform)
        item:InitCtrl(obj.transform)
        item.sortId = id
        item.mText_SuitName.text = TableData.GetHintById(53 + id)
        item.mText_SuitNum.text = ""
        UIUtils.GetButtonListener(item.mBtn_Select.gameObject).onClick = function()
            self:OnClickSort(item.sortId)
        end
    end
    self.mView.mText_DropdownSuitName.text = TableData.GetHintById(53 + self.curSort)
end

function UIRepositoryDecomposePanelV2:OnClickSort(id)
    self.curSort = id
    self.mView.mText_DropdownSuitName.text = TableData.GetHintById(53 + id)
    setactive(self.mView.mTrans_Screen, false)
    self.isSortDropDownActive = false
    self:UpdateSortList(self.curSort)
end

function UIRepositoryDecomposePanelV2:ResetRankButtons()
    self.isSelectStar1 = false
    self.isSelectStar2 = false
    self.isSelectStar3 = false

    self.mView.mAnimator_Star1:SetBool("Sel", self.isSelectStar1)
    self.mView.mAnimator_Star2:SetBool("Sel", self.isSelectStar2)
    self.mView.mAnimator_Star3:SetBool("Sel", self.isSelectStar3)
end

function UIRepositoryDecomposePanelV2.OnClickSuit(item)
    self = UIRepositoryDecomposePanelV2
    if item.mData then
        self.curSuit = item.mData.id
    else
        self.curSuit = item.id
    end
    self.selectItemIdList = {}
    for _, item in ipairs(self.itemList) do
        local soldItem = self:GetSoldItem(item)
        self:RemoveSelectItemById(item.id)
        self:RemoveSoldItem(soldItem)
    end
    self:ResetRankButtons()

    self.mView.mText_Dropdown_SuitName.text = item.mText_SuitName.text
    self.isSuitDropDownActive = false
    setactive(self.mView.mTrans_Suit, false)

    local equipList = NetCmdEquipData:GetEquipListBySetId(self.curSuit)
    self.itemList = self.listToTable(equipList)
    if self.sortFunc then
        table.sort(self.itemList, self.sortFunc)
    end
    self.virtualList.numItems = #self.itemList
    self.virtualList:Refresh()
    self:CheckDetail()
    self:UpdateCurrentCount()
end

function UIRepositoryDecomposePanelV2:SortItemList(sortFunc)
    if self.curPanelType == UIRepositoryDecomposePanelV2.panelType.EQUIP then
        self.virtualList.itemRenderer = function(index, renderData) self:EquipRenderer(index, renderData) end
    else
        self.virtualList.itemRenderer = function(index, renderData) self:WeaponRenderer(index, renderData) end
    end
    if sortFunc then
        table.sort(self.itemList, sortFunc)
        self.virtualList.numItems = #self.itemList
        self.virtualList:Refresh()
        self.sortFunc = sortFunc
    end
end

function UIRepositoryDecomposePanelV2:UpdateSortList(sortType)
    local sortFunc = nil
    if self.curPanelType == UIRepositoryDecomposePanelV2.panelType.EQUIP then
        sortFunc = UIRepositoryGlobal:GetEquipSortFunction(sortType, 1, self.isAscend)
    else
        sortFunc = UIRepositoryGlobal:GetWeaponSortFunction(sortType, 1, self.isAscend)
    end
    self:SortItemList(sortFunc)
end

function UIRepositoryDecomposePanelV2.EquipProvider()
    self = UIRepositoryDecomposePanelV2
    ---@type UICommonItem
    local itemView = UICommonItem.New()
    itemView:InitCtrl(self.parent)
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView
    table.insert(self.itemViewList, itemView)
    return renderDataItem
end

function UIRepositoryDecomposePanelV2.WeaponProvider()
    self = UIRepositoryDecomposePanelV2
    ---@type UICommonWeaponInfoItem
    local itemView = UICommonWeaponInfoItem.New()
    itemView:InitCtrl(self.parent)
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView
    table.insert(self.itemViewList, itemView)
    return renderDataItem
end

function UIRepositoryDecomposePanelV2:UpdateConfirmBtn()
    --setactive(self.mView.mBtn_3Item.transform, #self.selectItemList > 0)
end

function UIRepositoryDecomposePanelV2.OnClickItem(item)
    self = UIRepositoryDecomposePanelV2
    item.isChoose = not self.selectItemIdList[item.mData.id]
    item:SetSelect(item.isChoose)
    local soldItem = self:GetSoldItem(item.mData)
    if item.isChoose then
        table.insert(self.selectItemList, item.mData)
        self.selectItemIdList[item.mData.id] = true
        self:AddSoldItem(soldItem)
        setactive(self.mView.mTrans_RightList, true)
    else
        self:RemoveSelectItemById(item.mData.id)
        self:RemoveSoldItem(soldItem)
    end

    local selectedAllStar1 = true
    local selectedAllStar2 = true
    local selectedAllStar3 = true
    local containsStar1 = false
    local containsStar2 = false
    local containsStar3 = false
    for i = 1, #self.itemList do
        local item = self.itemList[i]
        local rank = item.rank or item.Rank
        if not self.selectItemIdList[item.id] then
            if TableData.GlobalSystemData.QualityStar[rank - 1] == 1 then
                selectedAllStar1 = false
                containsStar1 = true
            end
            if TableData.GlobalSystemData.QualityStar[rank - 1] == 2 then
                selectedAllStar2 = false
                containsStar2 = true
            end
            if TableData.GlobalSystemData.QualityStar[rank - 1] == 3 then
                selectedAllStar3 = false
                containsStar3 = true
            end
        else
            if TableData.GlobalSystemData.QualityStar[rank - 1] == 1 then
                containsStar1 = true
            end
            if TableData.GlobalSystemData.QualityStar[rank - 1] == 2 then
                containsStar2 = true
            end
            if TableData.GlobalSystemData.QualityStar[rank - 1] == 3 then
                containsStar3 = true
            end
        end
    end
    if selectedAllStar1 and containsStar1 and not self.isSelectStar1 then
        self.isSelectStar1 = true
        self.mView.mAnimator_Star1:SetBool("Sel", self.isSelectStar1)
    end
    if not selectedAllStar1 and self.isSelectStar1 then
        self.isSelectStar1 = false
        self.mView.mAnimator_Star1:SetBool("Sel", self.isSelectStar1)
    end
    if selectedAllStar2 and containsStar2 and not self.isSelectStar2 then
        self.isSelectStar2 = true
        self.mView.mAnimator_Star2:SetBool("Sel", self.isSelectStar2)
    end
    if not selectedAllStar2 and self.isSelectStar2 then
        self.isSelectStar2 = false
        self.mView.mAnimator_Star2:SetBool("Sel", self.isSelectStar2)
    end
    if selectedAllStar3 and containsStar3 and not self.isSelectStar3 then
        self.isSelectStar3 = true
        self.mView.mAnimator_Star3:SetBool("Sel", self.isSelectStar3)
    end
    if not selectedAllStar3 and self.isSelectStar3 then
        self.isSelectStar3 = false
        self.mView.mAnimator_Star3:SetBool("Sel", self.isSelectStar3)
    end

    self:UpdateSoldContent()
    self:CheckDetail()
    self:UpdateConfirmBtn()
end

function UIRepositoryDecomposePanelV2:CheckDetail()
    if #self.selectItemList > 0 then
        if self.curPanelType == UIRepositoryDecomposePanelV2.panelType.EQUIP then
            self:UpdateEquipDetail(self.selectItemList[#self.selectItemList])
        else
            self:UpdateWeaponDetail(self.selectItemList[#self.selectItemList])
        end
    end
    setactive(self.mView.mTrans_RightList, #self.selectItemList > 0)
end

function UIRepositoryDecomposePanelV2:RemoveSelectItemById(id)
    local index = 0
    for i, item in ipairs(self.selectItemList) do
        if item.id == id then
            index = i
            break
        end
    end
    if index > 0 then
        table.remove(self.selectItemList, index)
    end
    self.selectItemIdList[id] = false
end

function UIRepositoryDecomposePanelV2:UpdateEquipDetail(data)
    self.mView.mText_EquipName.text = data.name
    self.mView.mText_EquipLevel.text = string_format(UIEquipGlobal.EquipLvRichText, data.level, data.max_level)
    self.mView.mImg_QualityLine.color = TableData.GetGlobalGun_Quality_Color2(data.rank)

    self:UpdateEquipSet(data)
    self:UpdateEquipAttribute(data)
end

function UIRepositoryDecomposePanelV2:UpdateEquipSet(data)
    if data.setId ~= 0 then
        local setData = TableData.listEquipSetDatas:GetDataById(data.setId)
        for i, item in ipairs(self.mView.equipSetList) do
            item:SetData(data.setId,setData["set" .. i .. "_num"])
        end
    end
end

function UIRepositoryDecomposePanelV2:UpdateEquipAttribute(data)
    self:UpdateMainAttribute(data)
    self:UpdateSubAttribute(data)
end

function UIRepositoryDecomposePanelV2:UpdateMainAttribute(data)
    if data.main_prop then
        local tableData = TableData.listCalibrationDatas:GetDataById(data.main_prop.Id)
        if tableData then
            local propData = TableData.GetPropertyDataByName(tableData.property, tableData.type)
            self.mView.mText_MainAttrName.text = propData.show_name.str
            if propData.show_type == 2 then
                self.mView.mText_MainAttrNum.text = math.ceil(data.main_prop.Value / 10)  .. "%"
            else
                self.mView.mText_MainAttrNum.text = data.main_prop.Value
            end
        end
    end
end

function UIRepositoryDecomposePanelV2:UpdateSubAttribute(data)
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
                item:InitCtrl(self.mView.mTrans_SubAttr)
                table.insert(self.subProp, item)
            end
            item:SetData(propData, prop.Value, true, false, false, false)
        end
    end
end

function UIRepositoryDecomposePanelV2:UpdateWeaponDetail(data)
    self.gunElement = gunElement
    local elementData = TableData.listLanguageElementDatas:GetDataById(data.Element)
    self.mView.mText_WeaponName.text = data.Name
    self.mView.mText_WeaponLevel.text = string_format(UIWeaponGlobal.WeaponLvRichText2, data.Level, data.CurMaxLv)
    local weaponTypeData = TableData.listGunWeaponTypeDatas:GetDataById(data.Type);
    self.mView.mText_WeaponTypeName.text = weaponTypeData.name.str
    self.mView.mImage_Element.sprite = IconUtils.GetElementIcon(elementData.icon)
    self.mView.mImg_QualityLine.color = TableData.GetGlobalGun_Quality_Color2(data.Rank)
    --self.mView.mText_Power.text = self.data:GetPower()
    self.mView.stageItem:SetData(data.BreakTimes);
    self:UpdateAttribute(data)

    if(data.Skill and data.Skill.id ~= 0) then
        if self.normalSkillItem == nil then
            self.normalSkillItem = UIWeaponSkillItem.New()
            self.normalSkillItem:InitCtrl(self.mView.mTrans_Skill)
        end
        setactive(self.normalSkillItem.mUIRoot, true)
        self.normalSkillItem:SetData(data.Skill.id)
    else
        if self.normalSkillItem ~= nil then
            setactive(self.normalSkillItem.mUIRoot, false)
        end
    end

    if(data.BuffSkill and data.BuffSkill.id ~= 0) then
        if self.elementSkillItem == nil then
            self.elementSkillItem = UIWeaponSkillItem.New()
            self.elementSkillItem:InitCtrl(self.mView.mTrans_Skill)
        end
        setactive(self.elementSkillItem.mUIRoot, true)
        self.elementSkillItem:SetData(data.BuffSkill.id)
    else
        if self.elementSkillItem ~= nil then
            setactive(self.elementSkillItem.mUIRoot, false)
        end
    end
end

function UIRepositoryDecomposePanelV2:UpdateAttribute(data)
    local attrList = {}

    local expandList = TableData.GetPropertyExpandList()
    for i = 0, expandList.Count - 1 do
        local lanData = expandList[i]
        if (lanData.type == 1) then
            local value = data:GetPropertyByLevelAndSysName(lanData.sys_name, data.CurLv, data.BreakTimes)
            if (value > 0) then
                local attr = {}
                attr.propData = lanData
                attr.value = value
                table.insert(attrList, attr)
            end
        end
    end

    table.sort(attrList, function(a, b)
        return a.propData.order < b.propData.order
    end)

    for _, item in ipairs(self.attributeList) do
        item:SetData(nil)
    end

    for i = 1, #attrList do
        local item = nil
        if i <= #self.attributeList then
            item = self.attributeList[i]
        else
            ---@type UICommonPropertyItem
            item = UICommonPropertyItem.New()
            item:InitCtrl(self.mView.mTrans_AttrList)
            table.insert(self.attributeList, item)
        end
        item:SetData(attrList[i].propData, attrList[i].value, true, false, false)
        item:SetTextColor(attrList[i].propData.statue == 2 and ColorUtils.OrangeColor or ColorUtils.BlackColor)
    end
end

--- 拆解
function UIRepositoryDecomposePanelV2:AddSoldItem(soldItem)
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
    end
end

function UIRepositoryDecomposePanelV2:RemoveSoldItem(soldItem)
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

function UIRepositoryDecomposePanelV2:UpdateSoldContent()
    self.mView.mText_NumNow.text = #self.selectItemList
    self.mView.mText_NumTotal.text = "/" .. #self.itemList
    if #self.soldObjList > #self.soldItemList then
        for i = #self.soldItemList + 1, #self.soldObjList do
            self.soldObjList[i]:SetItemData(nil)
        end
    end

    for i, soldItem in ipairs(self.soldItemList) do
        ---@type UICommonItem
        local item = nil
        if i <= #self.soldObjList then
            item = self.soldObjList[i]
        else
            item = UICommonItem.New()
            item:InitCtrl(self.mView.mContent_DecomposeItem)

            table.insert(self.soldObjList, item)
        end

        item:SetItemData(soldItem.id, soldItem.count)
    end
end

function UIRepositoryDecomposePanelV2:GetSoldItemById(id)
    for _, item in ipairs(self.soldItemList) do
        if item.id == id then
            return item
        end
    end
    return nil
end

function UIRepositoryDecomposePanelV2:RemoveSoldItemById(id)
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

function UIRepositoryDecomposePanelV2:EquipRenderer(index, renderData)
    local data = self.itemList[index + 1]
    ---@type UICommonItem
    local item = renderData.data
    item:SetEquipByData(data, self.OnClickItem, self.selectItemIdList[data.id])
end

function UIRepositoryDecomposePanelV2:WeaponRenderer(index, renderData)
    local data = self.itemList[index + 1]
    ---@type UICommonWeaponInfoItem
    local item = renderData.data
    item:SetByData(data, self.OnClickItem, self.selectItemIdList[data.id])
end

function UIRepositoryDecomposePanelV2.OnShow()
    self = UIRepositoryDecomposePanelV2

    self:UpdateSortList(self.curSort)
end

function UIRepositoryDecomposePanelV2.OnReturnClick(gameObj)
    self = UIRepositoryDecomposePanelV2
    if self.mView.mAnimator then
        self.mView.mAnimator:SetBool("ComPage_FadeOut", true)
        TimerSys:DelayCall(0.3, function ()
            UIRepositoryDecomposePanelV2.Close()
        end)
    end
end

function UIRepositoryDecomposePanelV2.Close()
    UIManager.CloseUI(UIDef.UIRepositoryDecomposePanelV2)
end

function UIRepositoryDecomposePanelV2.OnHide()
    self = UIRepositoryDecomposePanelV2
    self.isHide = true
end


function UIRepositoryDecomposePanelV2.OnRelease()
    self = UIRepositoryDecomposePanelV2
    UIRepositoryDecomposePanelV2.setView = nil
    UIRepositoryDecomposePanelV2.virtualList = nil
    UIRepositoryDecomposePanelV2.itemList = {}
    UIRepositoryDecomposePanelV2.sortFunc = nil
    UIRepositoryDecomposePanelV2.selectItemList = {}
    UIRepositoryDecomposePanelV2.selectItemIdList = {}
    UIRepositoryDecomposePanelV2.curTab = 0
    UIRepositoryDecomposePanelV2.curPanel = 0
    UIRepositoryDecomposePanelV2.curSort = UIRepositoryGlobal.SortType.Level
    UIRepositoryDecomposePanelV2.tabList = {}
    UIRepositoryDecomposePanelV2.sortList = {}
    UIRepositoryDecomposePanelV2.subPanel = {}
    UIRepositoryDecomposePanelV2.soldItemList = {}
    UIRepositoryDecomposePanelV2.soldObjList = {}
    UIRepositoryDecomposePanelV2.subProp = {}
    UIRepositoryDecomposePanelV2.skillList = {}
    UIRepositoryDecomposePanelV2.attributeList = {}
    UIRepositoryDecomposePanelV2.elementSkillItem = nil
    UIRepositoryDecomposePanelV2.normalSkillItem = nil
    UIRepositoryDecomposePanelV2.suitList = {}
    if UIRepositoryDecomposePanelV2.mView.stageItem then
        UIRepositoryDecomposePanelV2.mView.stageItem:Release()
    end
end