require("UI.UIBaseView")

UIRepositoryPanelView = class("UIRepositoryPanelView", UIBaseView)
UIRepositoryPanelView.__index = UIRepositoryPanelView

function UIRepositoryPanelView:ctor()
	self.toggleList = {}
end

function UIRepositoryPanelView:__InitCtrl()
	self.mBtn_Exit = self:GetButton("TopBar/Btn_Close")
	self.mBtn_CommanderCenter = self:GetButton("TopBar/Btn_CommandCenter")

	self.mTrans_Capacity = self:GetRectTransform("TopBar/Trans_Capacity")
	self.mTrans_Sort = self:GetRectTransform("TopBar/Trans_FilterPanel")
	self.mTrans_Sold = self:GetRectTransform("TopBar/Trans_Btn_Sold")

	self.mTrans_ItemList = self:GetRectTransform("UI_Trans_List_Items")
	self.mTrans_ItemListContent = self:GetRectTransform("UI_Trans_List_Items/viewPort/Layout")
	self.mTrans_EquipOverView = self:GetRectTransform("UI_Trans_List_EquipOverView")
	self.mTrans_EquipOverViewContent = self:GetRectTransform("UI_Trans_List_EquipOverView/Layout")
	self.mTrans_EquipList = self:GetRectTransform("UI_Trans_List_Equip")
	self.mTrans_EquipListContent = self:GetRectTransform("UI_Trans_List_Equip/viewPort/Layout")

	self.mTrans_SoldPanel = self:GetRectTransform("Trans_SoldPanel")
	self.mTrans_SoldClose = self:GetRectTransform("Trans_SoldPanel/Btn_Close")
	self.mTrans_SoldCancel = self:GetRectTransform("Trans_SoldPanel/Btn_Cancel")
	self.mTrans_Confirm = self:GetRectTransform("Trans_SoldPanel/Options/Btn_Confirm")
	self.mTrans_SoldItemRoot = self:GetRectTransform("Trans_SoldPanel/Options/SoldMessage/HLayout_GetItemPanel")
	self.mText_SoldCount = self:GetText("Trans_SoldPanel/Options/SoldMessage/SoldDetail/Text_SoldNum")

	self.mTrans_NoneItem = self:GetRectTransform("Trans_NoneItem")
	self.mText_CurrentCount = self:GetText("TopBar/Trans_Capacity/Text_Count")
	self.mText_CurrentTitle = self:GetText("TopBar/Trans_Capacity/Text_CapacityTitle")
	self.mTrans_CanNotDismantle = self:GetRectTransform("Trans_SoldPanel/Options/Btn_Confirm/Trans_CantUse")
	self.mTrans_ItemBrief = self:GetRectTransform("Trans_ItemBriefPanel")

	self.mVirtualList = UIUtils.GetVirtualList(self.mTrans_EquipList)

	self:InitToggle()
end

function UIRepositoryPanelView:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end

function UIRepositoryPanelView:InitToggle()
	for i = 1, 3 do
		local toggle = {}
		local obj = self:GetRectTransform("Trans_SoldPanel/Options/SoldMessage/FilterPanel/Toggle" ..  i)
		toggle.obj = obj.gameObject
		toggle.txtName = UIUtils.GetText(obj, "Label")
		toggle.toggleSelect = UIUtils.GetToggle(obj)
		toggle.type = 0

		-- toggle.toggleSelect.onValueChanged:AddListener(function (isOn) self:FiltrateToggleSelect(isOn, id) end)
		self.toggleList[i] = toggle
	end
end
