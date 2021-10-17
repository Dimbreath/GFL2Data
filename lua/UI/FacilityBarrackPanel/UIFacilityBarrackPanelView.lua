require("UI.UIBaseView")

---@class UIFacilityBarrackPanelView : UIBaseView
UIFacilityBarrackPanelView = class("UIFacilityBarrackPanelView", UIBaseView)
UIFacilityBarrackPanelView.__index = UIFacilityBarrackPanelView

function UIFacilityBarrackPanelView:__InitCtrl()
	self.mBtn_BackItem = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
	self.mBtn_HomeItem = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))
	self.mBtn_Sort = self:GetButton("Root/GrpLeft/GrpScreen/BtnScreen/Btn_Dropdown")
	self.mBtn_Ascend = self:GetButton("Root/GrpLeft/GrpScreen/BtnScreen/Btn_Screen")

	self.mText_Name = self:GetText("Root/GrpLeft/GrpTypeSelList/Viewport/Content/ChrCardMainTabListItemV2/GrpText/Text_Name")
	self.mText_ENName = self:GetText("Root/GrpLeft/GrpTypeSelList/Viewport/Content/ChrCardMainTabListItemV2/GrpText/Text_ENName")
	self.mText_ENNameplete = self:GetText("Root/GrpLeft/GrpTypeSelList/Viewport/Content/ChrCardMainTabListItemV2/GrpText/Text_ENNameComplete")
	self.mContent_Card = self:GetGridLayoutGroup("Root/GrpRight/GrpCardList/Viewport/Content")
	self.mContent_TypeSel = self:GetVerticalLayoutGroup("Root/GrpLeft/GrpTypeSelList/Viewport/Content")
	self.mList_TypeSel = self:GetScrollRect("Root/GrpLeft/GrpTypeSelList")
	self.mList_Card = self:GetScrollRect("Root/GrpRight/GrpCardList")

	self.mTrans_Empty = self:GetRectTransform("Root/GrpRight/GrpCardList/Viewport/Content/GrpEmpty")
	self.mAnimator = self:GetComponent("Root", typeof(CS.UnityEngine.Animator))

	self.mTrans_SortList = self:GetRectTransform("Root/GrpLeft/GrpScreen/Trans_GrpScreenList")
end

function UIFacilityBarrackPanelView:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end
