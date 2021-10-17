require("UI.UIBaseView")

UISkillCoreSelectionPanelView = class("UISkillCoreSelectionPanelView", UIBaseView);
UISkillCoreSelectionPanelView.__index = UISkillCoreSelectionPanelView

--@@ GF Auto Gen Block Begin
UISkillCoreSelectionPanelView.mBtn_Return = nil;
UISkillCoreSelectionPanelView.mBtn_change = nil;
UISkillCoreSelectionPanelView.mBtn_FilterButton = nil;
UISkillCoreSelectionPanelView.mBtn_Confirm = nil;
UISkillCoreSelectionPanelView.mText_Num = nil;
UISkillCoreSelectionPanelView.mText_Sort_SortType = nil;
UISkillCoreSelectionPanelView.mText_Filter_SortType = nil;
UISkillCoreSelectionPanelView.mTrans_CoreList = nil;

function UISkillCoreSelectionPanelView:__InitCtrl()

	self.mBtn_Return = self:GetButton("TopPanel/Btn_Return");
	self.mBtn_change = self:GetButton("TopPanel/ListInfo/Options/Btn_AD_change");
	self.mBtn_FilterButton = self:GetButton("TopPanel/ListInfo/Options/Btn_FilterButton");
	self.mBtn_Confirm = self:GetButton("RightPanel/Btn_Confirm");
	self.mText_Num = self:GetText("TopPanel/ListInfo/CoreTotal/Text_Num");
	self.mText_Sort_SortType = self:GetText("TopPanel/ListInfo/Options/UI_Sort/Text_SortType");
	self.mText_Filter_SortType = self:GetText("TopPanel/ListInfo/Options/UI_Filter/Text_SortType");
	self.mTrans_CoreList = self:GetRectTransform("Cores/Trans_CoreList");
end

--@@ GF Auto Gen Block End

function UISkillCoreSelectionPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end