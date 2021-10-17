require("UI.UIBasePanel")
require("UI.RepositoryPanelV2.UIRepositoryPanelV2View")
require("UI.Common.UICommonTabButtonItem")
require("UI.RepositoryPanel.Content.UIRepositoryItemPanel")
---@class UIRepositoryPanelV2 : UIBasePanel
UIRepositoryPanelV2 = class("UIRepositoryPanelV2", UIBasePanel)
UIRepositoryPanelV2.__index = UIRepositoryPanelV2
---@type UIRepositoryPanelV2View
UIRepositoryPanelV2.mView = nil
UIRepositoryPanelV2.curTab = 0
UIRepositoryPanelV2.curPanel = 0
UIRepositoryPanelV2.curSort = 0
UIRepositoryPanelV2.tabList = {}
UIRepositoryPanelV2.toggleList = {}
UIRepositoryPanelV2.subPanel = {}
UIRepositoryPanelV2.soldItemList = {}
UIRepositoryPanelV2.soldObjList = {}
UIRepositoryPanelV2.commonReceiveItem = nil
UIRepositoryPanelV2.isDisassemble = false
UIRepositoryPanelV2.isHide = false
UIRepositoryPanelV2.isAscend = false
UIRepositoryPanelV2.isSortDropDownActive = false
UIRepositoryPanelV2.mPath_UICommonItemS = "UICommonFramework/UICommonItemS.prefab"

function UIRepositoryPanelV2:ctor()
    UIRepositoryPanelV2.super.ctor(self)
end

function UIRepositoryPanelV2.Init(root, data)
    self = UIRepositoryPanelV2
    UIRepositoryPanelV2.super.SetRoot(UIRepositoryPanelV2, root)
    self.currentType = data
    self.isHide = false
    ---@type UIRepositoryPanelV2View
    self.mView = UIRepositoryPanelV2View.New()
    self.mView:InitCtrl(root)
end

function UIRepositoryPanelV2.Close()
    UIManager.CloseUI(UIDef.UIRepositoryPanelV2)
end

function UIRepositoryPanelV2.OnReturnClick(gameObj)
    self = UIRepositoryPanelV2
    if self.curPanel == UIRepositoryGlobal.PanelType.EquipPanel then
        self:UpdatePanelByType(UIRepositoryGlobal.PanelType.EquipOverViewPanel)
    else
        UIRepositoryPanelV2.Close()
    end
end

function UIRepositoryPanelV2.OnInit()
    self = UIRepositoryPanelV2
    UIUtils.GetBlockHelper(self.mView.mTrans_Screen.gameObject).onHide = self.OnScreenClose

    UIUtils.GetButtonListener(self.mView.mBtn_BackItem.gameObject).onClick = self.OnReturnClick

    UIUtils.GetButtonListener(self.mView.mBtn_HomeItem.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Dropdown.gameObject).onClick = self.OnDropDownClick

    UIUtils.GetButtonListener(self.mView.mBtn_Screen.gameObject).onClick = self.OnScreenClick

    UIUtils.GetButtonListener(self.mView.mBtn_ViewAll.gameObject).onClick = function()
        UIRepositoryPanelV2:UpdatePanelByType(UIRepositoryGlobal.PanelType.EquipPanel, 0)
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Decompose.gameObject).onClick = function()
        if UIRepositoryPanelV2.curPanel == UIRepositoryGlobal.PanelType.EquipPanel then
            UIManager.OpenUIByParam(UIDef.UIRepositoryDecomposePanelV2, {UIRepositoryDecomposePanelV2.panelType.EQUIP, UIRepositoryPanelV2.subPanel[UIRepositoryPanelV2.curPanel]:GetItemList()})
        elseif UIRepositoryPanelV2.curPanel == UIRepositoryGlobal.PanelType.WeaponPanel then
            UIManager.OpenUIByParam(UIDef.UIRepositoryDecomposePanelV2, {UIRepositoryDecomposePanelV2.panelType.WEAPON, UIRepositoryPanelV2.subPanel[UIRepositoryPanelV2.curPanel]:GetItemList()})
        end
    end

    self:InitAllSubPanel()
    self:InitSortButton()
    self:InitTabButton()
    -- self:InitFiltrateToggle()
end

function UIRepositoryPanelV2.OnScreenClose()
    self = UIRepositoryPanelV2
    setactive(self.mView.mTrans_Screen, false)
    self.isSortDropDownActive = false
end

function UIRepositoryPanelV2.OnDropDownClick()
    self = UIRepositoryPanelV2
    self.isSortDropDownActive = not self.isSortDropDownActive
    setactive(self.mView.mTrans_Screen, self.isSortDropDownActive)
end

function UIRepositoryPanelV2.OnScreenClick()
    self = UIRepositoryPanelV2
    self.isAscend = not self.isAscend
    self:UpdateSortList(self.curSort)
end

function UIRepositoryPanelV2:InitAllSubPanel()
    for _, id in pairs(UIRepositoryGlobal.PanelType) do
        self:InitSubPanel(id)
    end
end

function UIRepositoryPanelV2:InitSubPanel(panelId)
    local subPanel = nil
    if panelId == UIRepositoryGlobal.PanelType.ItemPanel then
        subPanel = UIRepositoryItemPanel.New(self, panelId, self.mView.mList_Item.transform)
    elseif panelId == UIRepositoryGlobal.PanelType.EquipPanel then
        subPanel = UIRepositoryEquipPanel.New(self, panelId, self.mView.mList_EquipAll.transform)
    elseif panelId == UIRepositoryGlobal.PanelType.WeaponPanel then
        subPanel = UIRepositoryWeaponPanel.New(self, panelId, self.mView.mList_Weapon.transform)
    elseif panelId == UIRepositoryGlobal.PanelType.EquipOverViewPanel then
        subPanel = UIRepositoryEquipOverViewPanel.New(self, panelId, self.mView.mList_EquipSuit.transform)
    elseif panelId == UIRepositoryGlobal.PanelType.GunCore then
         subPanel = UIRepositoryGunCorePanel.New(self, panelId, self.mView.mList_GunCore.transform)
    end
    self.subPanel[panelId] = subPanel
end

function UIRepositoryPanelV2.OnShow()
    self = UIRepositoryPanelV2
    if self.isHide then
        self:RefreshContent()
        self.isHide = false
    end
end

function UIRepositoryPanelV2:RefreshContent()
    if self.curPanel == UIRepositoryGlobal.PanelType.EquipPanel or self.curPanel == UIRepositoryGlobal.PanelType.WeaponPanel then
        self.subPanel[self.curPanel]:RefreshItemList()
        self:UpdateCurrentCount()
    end
end

function UIRepositoryPanelV2.OnHide()
    self = UIRepositoryPanelV2
    self.isHide = true
end

function UIRepositoryPanelV2.OnDataUpdate(data)

end

function UIRepositoryPanelV2.OnRelease()
    self = UIRepositoryPanelV2

    for _, panel in pairs(self.subPanel) do
        panel:OnRelease()
    end

    UIRepositoryPanelV2.curTab = 0
    UIRepositoryPanelV2.curPanel = 0
    UIRepositoryPanelV2.curSort = 0
    UIRepositoryPanelV2.tabList = {}
    UIRepositoryPanelV2.toggleList = {}
    UIRepositoryPanelV2.subPanel = {}
    UIRepositoryPanelV2.soldItemList = {}
    UIRepositoryPanelV2.soldObjList = {}
    UIRepositoryPanelV2.commonReceiveItem = nil
    UIRepositoryPanelV2.isDisassemble = false
end

function UIRepositoryPanelV2:InitTabButton()
    local leftTabPrefab = UIUtils.GetGizmosPrefab("UICommonFramework/ComLeftTab1ItemV2.prefab", self)
    for id = 1, 4 do
        ---@type UICommonLeftTabItemV2
        local item = UICommonLeftTabItemV2.New()
        local obj = instantiate(leftTabPrefab, self.mView.mContent_Tab.transform)
        item:InitCtrl(obj.transform)
        item.tagId = id
        item.mText_Name.text = TableData.GetHintById(1051 + id)
        item:SetUnlock(UIRepositoryGlobal.SystemIdList[id])
        UIUtils.GetButtonListener(item.mBtn.gameObject).onClick = function()
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

function UIRepositoryPanelV2:InitSortButton()
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
end

function UIRepositoryPanelV2:OnClickTab(id)
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

function UIRepositoryPanelV2:OnClickSort(id)
    self.curSort = id
    self.mView.mText_SuitName.text = TableData.GetHintById(53 + id)
    setactive(self.mView.mTrans_Screen, false)
    self.isSortDropDownActive = false
    self:UpdateSortList(self.curSort)
end

function UIRepositoryPanelV2:ResetItemListSort()
    local defaultSort = UIRepositoryGlobal.SortType.Level
    if self.curSort == defaultSort then
        self.curSort = 0
    end
    self:OnClickSort(defaultSort)
end

function UIRepositoryPanelV2:RefreshSubPanelItemList()
    local subPanel = self.subPanel[self.curPanel]
    subPanel:RefreshItemList()
    subPanel:ResetSelectItemList()

    setactive(self.mView.mTrans_NoneItem, #subPanel:GetItemList() <= 0)
end

function UIRepositoryPanelV2:UpdateSortList(sortType)
    local sortFunc = nil
    if self.curPanel == UIRepositoryGlobal.PanelType.WeaponPanel then
        sortFunc = UIRepositoryGlobal:GetWeaponSortFunction(sortType, 1, self.isAscend)
    elseif self.curPanel == UIRepositoryGlobal.PanelType.GunCore then
        sortFunc = nil
    else
        sortFunc = UIRepositoryGlobal:GetSortFunction(sortType, 1, self.isAscend)
    end

    local subPanel = self.subPanel[self.curPanel]
    subPanel:SortItemList(sortFunc)
end

function UIRepositoryPanelV2:UpdatePanelByType(type, param)
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
    if type == UIRepositoryGlobal.PanelType.ItemPanel then
        setactive(self.mView.mTrans_Item, true)
        setactive(self.mView.mTrans_Equip, false)
        setactive(self.mView.mTrans_Weapon, false)
        setactive(self.mView.mTrans_GunCore, false)
        setactive(self.mView.mTrans_Bottom, false)
    elseif type == UIRepositoryGlobal.PanelType.EquipPanel then
        setactive(self.mView.mTrans_Item, false)
        setactive(self.mView.mTrans_Equip, true)
        setactive(self.mView.mList_EquipSuit.gameObject, false)
        setactive(self.mView.mList_EquipAll.gameObject, true)
        setactive(self.mView.mTrans_Weapon, false)
        setactive(self.mView.mTrans_GunCore, false)
        setactive(self.mView.mTrans_Bottom, true)
        self:ResetItemListSort()
        self:UpdateCurrentCount()
    elseif type == UIRepositoryGlobal.PanelType.EquipOverViewPanel then
        setactive(self.mView.mTrans_Item, false)
        setactive(self.mView.mTrans_Equip, true)
        setactive(self.mView.mList_EquipSuit.gameObject, true)
        setactive(self.mView.mList_EquipAll.gameObject, false)
        setactive(self.mView.mTrans_Weapon, false)
        setactive(self.mView.mTrans_GunCore, false)
        setactive(self.mView.mTrans_Bottom, false)
        self:UpdateCurrentCount()
    elseif type == UIRepositoryGlobal.PanelType.WeaponPanel then
        setactive(self.mView.mTrans_Item, false)
        setactive(self.mView.mTrans_Equip, false)
        setactive(self.mView.mTrans_Weapon, true)
        setactive(self.mView.mTrans_GunCore, false)
        setactive(self.mView.mTrans_Bottom, true)
        self:ResetItemListSort()
        self:UpdateCurrentCount()
    elseif type == UIRepositoryGlobal.PanelType.GunCore then
        setactive(self.mView.mTrans_Item, false)
        setactive(self.mView.mTrans_Equip, false)
        setactive(self.mView.mTrans_Weapon, false)
        setactive(self.mView.mTrans_GunCore, true)
        setactive(self.mView.mTrans_Bottom, false)
        self:ResetItemListSort()
        self:UpdateCurrentCount()
    else
        gfwarning("No valid panel type found!!")
    end
end

function UIRepositoryPanelV2:UpdateCurrentCount()
    local maxLimit = 0
    local itemList = self.subPanel[self.curPanel]:GetItemList()
    if self.curPanel == UIRepositoryGlobal.PanelType.WeaponPanel then
        maxLimit = CS.GF2.Data.GlobalData.weapon_capacity
    elseif self.curPanel == UIRepositoryGlobal.PanelType.EquipPanel then
        maxLimit = CS.GF2.Data.GlobalData.equip_capacity
    elseif self.curPanel == UIRepositoryGlobal.PanelType.EquipOverViewPanel then
        maxLimit = CS.GF2.Data.GlobalData.equip_capacity
        self.mView.mText_NumNow.text = NetCmdEquipData:GetEquipListBySetId(0).Count
        self.mView.mText_NumAll.text = "/" .. maxLimit
    end

    local text = self.isDisassemble and UIRepositoryGlobal.DisassembleCountText or UIRepositoryGlobal.CurrentCountText
    local title = self.isDisassemble and TableData.GetHintById(30012) or TableData.GetHintById(30011)
    self.mView.mText_Num.text = #itemList
    self.mView.mText_Total.text = "/" .. maxLimit
end

function UIRepositoryPanelV2:GetSelectItemList()
    local subPanel = self.subPanel[self.curPanel]
    return subPanel:GetSelectItemList()
end

function UIRepositoryPanelV2:UpdateConfirmBtn()
    local selectList = self:GetSelectItemList()
    setactive(self.mView.mTrans_CanNotDismantle, #selectList <= 0)
end

