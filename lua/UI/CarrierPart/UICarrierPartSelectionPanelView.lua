require("UI.UIBaseView")

UICarrierPartSelectionPanelView = class("UICarrierPartSelectionPanelView", UIBaseView);
UICarrierPartSelectionPanelView.__index = UICarrierPartSelectionPanelView

--@@ GF Auto Gen Block Begin
UICarrierPartSelectionPanelView.mBtn_Return = nil;
UICarrierPartSelectionPanelView.mBtn_change = nil;
UICarrierPartSelectionPanelView.mBtn_FilterButton = nil;
UICarrierPartSelectionPanelView.mBtn_Confirm = nil;
UICarrierPartSelectionPanelView.mText_Num = nil;
UICarrierPartSelectionPanelView.mText_Sort_SortType = nil;
UICarrierPartSelectionPanelView.mText_Filter_SortType = nil;
UICarrierPartSelectionPanelView.mTrans_PartList = nil;

function UICarrierPartSelectionPanelView:__InitCtrl()

	self.mBtn_Return = self:GetButton("TopPanel/Btn_Return");
	self.mBtn_change = self:GetButton("TopPanel/ListInfo/Options/Btn_AD_change");
	self.mBtn_FilterButton = self:GetButton("TopPanel/ListInfo/Options/Btn_FilterButton");
	self.mBtn_Confirm = self:GetButton("RightPanel/Btn_Confirm");
	self.mText_Num = self:GetText("TopPanel/ListInfo/CoreTotal/Text_Num");
	self.mText_Sort_SortType = self:GetText("TopPanel/ListInfo/Options/UI_Sort/Text_SortType");
	self.mText_Filter_SortType = self:GetText("TopPanel/ListInfo/Options/UI_Filter/Text_SortType");
	self.mTrans_PartList = self:GetRectTransform("Parts/Trans_PartList");
end

--@@ GF Auto Gen Block End

function UICarrierPartSelectionPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end