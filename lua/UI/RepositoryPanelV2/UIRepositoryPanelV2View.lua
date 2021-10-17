require("UI.UIBaseView")

---@class UIRepositoryPanelV2View : UIBaseView
UIRepositoryPanelV2View = class("UIRepositoryPanelV2View", UIBaseView);
UIRepositoryPanelV2View.__index = UIRepositoryPanelV2View

--@@ GF Auto Gen Block Begin
UIRepositoryPanelV2View.mBtn_BackItem = nil;
UIRepositoryPanelV2View.mBtn_HomeItem = nil;
UIRepositoryPanelV2View.mBtn_ViewAll = nil;
UIRepositoryPanelV2View.mBtn_Decompose = nil;
UIRepositoryPanelV2View.mBtn_Dropdown = nil;
UIRepositoryPanelV2View.mBtn_Screen = nil;
UIRepositoryPanelV2View.mBtn_Close = nil;
UIRepositoryPanelV2View.mText_NumNow = nil;
UIRepositoryPanelV2View.mText_NumAll = nil;
UIRepositoryPanelV2View.mText_Num = nil;
UIRepositoryPanelV2View.mText_Total = nil;
UIRepositoryPanelV2View.mText_SuitName = nil;
UIRepositoryPanelV2View.mContent_EquipSuit = nil;
UIRepositoryPanelV2View.mContent_EquipAll = nil;
UIRepositoryPanelV2View.mContent_Weapon = nil;
UIRepositoryPanelV2View.mContent_Screen = nil;
UIRepositoryPanelV2View.mContent_Tab = nil;
UIRepositoryPanelV2View.mContent_Item = nil;
UIRepositoryPanelV2View.mScrollbar_Tab = nil;
UIRepositoryPanelV2View.mScrollbar_Item = nil;
UIRepositoryPanelV2View.mScrollbar_EquipSuit = nil;
UIRepositoryPanelV2View.mScrollbar_EquipAll = nil;
UIRepositoryPanelV2View.mScrollbar_Weapon = nil;
UIRepositoryPanelV2View.mScrollbar_Screen = nil;
UIRepositoryPanelV2View.mList_Tab = nil;
UIRepositoryPanelV2View.mList_Item = nil;
UIRepositoryPanelV2View.mList_EquipSuit = nil;
UIRepositoryPanelV2View.mList_EquipAll = nil;
UIRepositoryPanelV2View.mList_Weapon = nil;
UIRepositoryPanelV2View.mList_Screen = nil;
UIRepositoryPanelV2View.mTrans_Item = nil;
UIRepositoryPanelV2View.mTrans_Equip = nil;
UIRepositoryPanelV2View.mTrans_Weapon = nil;
UIRepositoryPanelV2View.mTrans_Bottom = nil;
UIRepositoryPanelV2View.mTrans_Total = nil;
UIRepositoryPanelV2View.mTrans_Screen = nil;

function UIRepositoryPanelV2View:__InitCtrl()

	self.mBtn_BackItem = self:GetButton("Root/GrpTop/BtnBack/ComBtnBackItemV2");
	self.mBtn_HomeItem = self:GetButton("Root/GrpTop/BtnHome/ComBtnHomeItemV2");
	self.mBtn_ViewAll = self:GetButton("Root/GrpRight/Trans_GrpEquip/GrpEquipSuitList/Viewport/Content/Btn_ViewAll");
	self.mBtn_Decompose = self:GetButton("Root/GrpRight/Trans_Bottom/Screen/GrpDecompose/GrpLeftBtn/Btn_Decompose");

	self.mText_NumNow = self:GetText("Root/GrpRight/Trans_GrpEquip/GrpEquipSuitList/Viewport/Content/Btn_ViewAll/GrpTextNum/Text_NumNow");
	self.mText_NumAll = self:GetText("Root/GrpRight/Trans_GrpEquip/GrpEquipSuitList/Viewport/Content/Btn_ViewAll/GrpTextNum/Text_NumAll");
	self.mText_Num = self:GetText("Root/GrpRight/Trans_Bottom/Screen/GrpDecompose/GrpLeftBtn/GrpOwnNum/Text_Num");
	self.mText_Total = self:GetText("Root/GrpRight/Trans_Bottom/Screen/GrpDecompose/GrpLeftBtn/GrpOwnNum/Trans_Text_Total");

	self.mContent_EquipSuit = self:GetGridLayoutGroup("Root/GrpRight/Trans_GrpEquip/GrpEquipSuitList/Viewport/Content");
	self.mContent_EquipAll = self:GetGridLayoutGroup("Root/GrpRight/Trans_GrpEquip/GrpEquipAllList/Viewport/Content");
	self.mContent_Weapon = self:GetGridLayoutGroup("Root/GrpRight/Trans_GrpWeapon/GrpWeaponList/Viewport/Content");
	self.mContent_GunCore = self:GetGridLayoutGroup("Root/GrpRight/Trans_GrpFragment/GrpFragmentList/Viewport/Content")
	self.mContent_Tab = self:GetVerticalLayoutGroup("Root/GrpLeft/Content/GrpTabList/Viewport/Content");
	self.mContent_Item = self:GetVerticalLayoutGroup("Root/GrpRight/Trans_GrpItem/GrpItemList/Viewport/Content");
	self.mScrollbar_Tab = self:GetScrollbar("Root/GrpLeft/Content/GrpTabList/Scrollbar");
	self.mScrollbar_Item = self:GetScrollbar("Root/GrpRight/Trans_GrpItem/GrpItemList/Scrollbar");
	self.mScrollbar_EquipSuit = self:GetScrollbar("Root/GrpRight/Trans_GrpEquip/GrpEquipSuitList/Scrollbar");
	self.mScrollbar_EquipAll = self:GetScrollbar("Root/GrpRight/Trans_GrpEquip/GrpEquipAllList/Scrollbar");
	self.mScrollbar_Weapon = self:GetScrollbar("Root/GrpRight/Trans_GrpWeapon/GrpWeaponList/Scrollbar");
	self.mScrollbar_GunCore = self:GetScrollbar("Root/GrpRight/Trans_GrpFragment/GrpFragmentList/Scrollbar")
	self.mList_Tab = self:GetScrollRect("Root/GrpLeft/Content/GrpTabList");
	self.mList_Item = self:GetScrollRect("Root/GrpRight/Trans_GrpItem/GrpItemList");
	self.mList_EquipSuit = self:GetScrollRect("Root/GrpRight/Trans_GrpEquip/GrpEquipSuitList");
	self.mList_EquipAll = self:GetScrollRect("Root/GrpRight/Trans_GrpEquip/GrpEquipAllList");
	self.mList_Weapon = self:GetScrollRect("Root/GrpRight/Trans_GrpWeapon/GrpWeaponList");
	self.mList_GunCore = self:GetScrollRect("Root/GrpRight/Trans_GrpFragment/GrpFragmentList")
	self.mTrans_Item = self:GetRectTransform("Root/GrpRight/Trans_GrpItem");
	self.mTrans_Equip = self:GetRectTransform("Root/GrpRight/Trans_GrpEquip");
	self.mTrans_Weapon = self:GetRectTransform("Root/GrpRight/Trans_GrpWeapon");
	self.mTrans_GunCore = self:GetRectTransform("Root/GrpRight/Trans_GrpFragment")
	self.mTrans_Bottom = self:GetRectTransform("Root/GrpRight/Trans_Bottom");
	self.mTrans_Total = self:GetRectTransform("Root/GrpRight/Trans_Bottom/Screen/GrpDecompose/GrpLeftBtn/GrpOwnNum/Trans_Text_Total");
	self.mTrans_Screen = self:GetRectTransform("Root/GrpRight/Trans_Bottom/Screen/GrpScreen/Trans_GrpScreenList");
	self.mTrans_BtnScreen = self:GetRectTransform("Root/GrpRight/Trans_Bottom/Screen/GrpScreen/BtnScreen");
end

--@@ GF Auto Gen Block End

function UIRepositoryPanelV2View:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mVirtualList_EquipAll = UIUtils.GetVirtualListEx(self.mList_EquipAll.transform)

	self.mVirtualList_Weapon = UIUtils.GetVirtualListEx(self.mList_Weapon.transform)

	local screenItem = self:InstanceUIPrefab("UICommonFramework/ComScreenItemV2.prefab", self.mTrans_BtnScreen, true);
	self.mBtn_Dropdown = screenItem.transform:Find("Btn_Dropdown")
	self.mBtn_Screen = screenItem.transform:Find("Btn_Screen")
	self.mText_SuitName = screenItem.transform:Find("Btn_Dropdown/Text_SuitName"):GetComponent("Text");

	local sortList = self:InstanceUIPrefab("UICommonFramework/ComScreenDropdownListItemV2.prefab", self.mTrans_Screen, true);
	self.mContent_Screen = sortList.transform:Find("Content");

	self.mAnimator = self:GetComponent("Root", typeof(CS.UnityEngine.Animator))
end