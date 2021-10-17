require("UI.UIBaseView")

---@class UIFriendPanelView : UIBaseView
UIFriendPanelView = class("UIFriendPanelView", UIBaseView)
UIFriendPanelView.__index = UIFriendPanelView

function UIFriendPanelView:ctor()
	UIFriendPanelView.super.ctor(self)
	self.tagList = {}
	self.sortList = {}
end

function UIFriendPanelView:__InitCtrl()
	self.mBtn_Past = self:GetButton("Root/Trans_GrpFriendAdd_2/GrpBottom/GrpInputField/Btn_Copy")
	self.mBtn_Return = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
	self.mBtn_CommandCenter = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))
	self.mBtn_RefreshList = UIUtils.GetTempBtn(self:GetRectTransform("Root/Trans_GrpFriendAdd_2/GrpRefresh/BtnRefresh"))
	self.mBtn_Search = UIUtils.GetTempBtn(self:GetRectTransform("Root/Trans_GrpFriendAdd_2/GrpBottom/BtnSearch"))
	self.mBtn_BlackList = UIUtils.GetTempBtn(self:GetRectTransform("Root/Trans_GrpFriendList_0/Trans_GrpBottom/BtnBlackList"))
	self.mBtn_RefuseAll = UIUtils.GetTempBtn(self:GetRectTransform("Root/Trans_GrpFriendApply_1/Trans_GrpBottom/BtnRefuseAll"))

	self.mTrans_Pointer = self:GetRectTransform("Root/Trans_GrpFriendList_0/Trans_GrpBottom/GrpScreen/Trans_Pointer")
	self.mTrans_TagList = self:GetRectTransform("Root/GrpTop/GrpTabSwitch")
	self.mTrans_Sort = self:GetRectTransform("Root/Trans_GrpFriendList_0/Trans_GrpBottom/GrpScreen/BtnScreen")
	self.mTrans_SortList = self:GetRectTransform("Root/Trans_GrpFriendList_0/Trans_GrpBottom/GrpScreen/Trans_GrpScreenList")
	self.mTrans_SortItem = self:GetRectTransform("Root/Trans_GrpFriendList_0/Trans_GrpBottom/GrpScreen/Trans_GrpScreenList/Viewport/Content")
	self.mTrans_RefuseAll = self:GetRectTransform("Root/Trans_GrpFriendApply_1/Trans_GrpBottom/BtnRefuseAll")

	self.mTrans_FriendListEmpty = self:GetRectTransform("Root/Trans_GrpFriendList_0/Trans_GrpEmpty")
	self.mTrans_ApplListEmpty = self:GetRectTransform("Root/Trans_GrpFriendApply_1/Trans_GrpEmpty")
	self.mTrans_AddEmpty = self:GetRectTransform("Root/Trans_GrpFriendAdd_2/Trans_GrpEmpty")

	self.mTrans_Friend = self:GetRectTransform("Root/Trans_GrpFriendList_0")
	self.mTrans_Apply = self:GetRectTransform("Root/Trans_GrpFriendApply_1")
	self.mTrans_Add = self:GetRectTransform("Root/Trans_GrpFriendAdd_2")

	self.mTrans_FriendList = self:GetRectTransform("Root/Trans_GrpFriendList_0/GrpList")
	self.mTrans_AddList = self:GetRectTransform("Root/Trans_GrpFriendAdd_2/GrpList")
	self.mTrans_ApplyList = self:GetRectTransform("Root/Trans_GrpFriendApply_1/GrpList")

	self.mText_FriendNum = self:GetText("Root/Trans_GrpFriendList_0/Trans_GrpBottom/GrpFriendNum/GrpText/Text_Num")
	self.mText_FriendNumAll = self:GetText("Root/Trans_GrpFriendList_0/Trans_GrpBottom/GrpFriendNum/GrpText/Text_NumAll")

	self.mText_InputField = self:GetInputField("Root/Trans_GrpFriendAdd_2/GrpBottom/GrpInputField/Btn_InputField")

	self.mAnimator = self:GetRectTransform("Root"):GetComponent("Animator")

	self.mFriendVirtualList = UIUtils.GetVirtualList(self.mTrans_FriendList)
	self.mAddVirtualList = UIUtils.GetVirtualList(self.mTrans_AddList)
	self.mApplyVirtualList = UIUtils.GetVirtualList(self.mTrans_ApplyList)
end


function UIFriendPanelView:InitCtrl(root)

	self:SetRoot(root)

	self:__InitCtrl()
end