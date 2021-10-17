require("UI.UIBaseView")

UIStoreSkinPanelView = class("UIStoreSkinPanelView", UIBaseView);
UIStoreSkinPanelView.__index = UIStoreSkinPanelView

--@@ GF Auto Gen Block Begin
UIStoreSkinPanelView.mBtn_ConfirmButton = nil;
UIStoreSkinPanelView.mBtn_ViewButton = nil;
UIStoreSkinPanelView.mBtn_SwitchToStore = nil;
UIStoreSkinPanelView.mBtn_CloseView = nil;
UIStoreSkinPanelView.mBtn_Return = nil;
UIStoreSkinPanelView.mImage_ConfirmButton = nil;
UIStoreSkinPanelView.mText_SkinHavePerCent = nil;
UIStoreSkinPanelView.mText_OverView_GunName = nil;
UIStoreSkinPanelView.mText_DescriptionDetailPanel_SkinName = nil;
UIStoreSkinPanelView.mText_DescriptionDetailPanel_SkinDSC = nil;
UIStoreSkinPanelView.mVLayout_DescriptionDetailPanel_SkinDetailPanel = nil;
UIStoreSkinPanelView.mTrans_SkinOption = nil;
UIStoreSkinPanelView.mTrans_OverView_GunGrade = nil;
UIStoreSkinPanelView.mTrans_DescriptionDetailPanel_SkinDetailPanel = nil;
UIStoreSkinPanelView.mTrans_SkinListPanel = nil;

function UIStoreSkinPanelView:__InitCtrl()

	self.mBtn_ConfirmButton = self:GetButton("Trans_SkinOption/Image_Btn_ConfirmButton");
	self.mBtn_ViewButton = self:GetButton("SkinView/Btn_ViewButton");
	self.mBtn_SwitchToStore = self:GetButton("Trans_SkinOption/Btn_SwitchToStore");
	self.mBtn_CloseView = self:GetButton("SkinView/Btn_CloseView");
	self.mBtn_Return = self:GetButton("TopPanel/Btn_Return");
	self.mImage_ConfirmButton = self:GetImage("Trans_SkinOption/Image_Btn_ConfirmButton");
	self.mText_SkinHavePerCent = self:GetText("Trans_SkinOption/Title/Text_SkinHavePerCent");
	self.mText_OverView_GunName = self:GetText("Trans_SkinOption/UI_OverView/Text_GunName");
	self.mText_DescriptionDetailPanel_SkinName = self:GetText("Trans_SkinOption/Title/Text_SkinName");
	self.mText_DescriptionDetailPanel_SkinDSC = self:GetText("Trans_SkinOption/UI_DescriptionDetailPanel/Trans_VLayout_SkinDetailPanel/Text_SkinDSC");
	self.mVLayout_DescriptionDetailPanel_SkinDetailPanel = self:GetVerticalLayoutGroup("Trans_SkinOption/UI_DescriptionDetailPanel/Trans_VLayout_SkinDetailPanel");
	self.mTrans_SkinOption = self:GetRectTransform("Trans_SkinOption");
	self.mTrans_OverView_GunGrade = self:GetRectTransform("Trans_SkinOption/UI_OverView/UI_Trans_GunGrade");
	self.mTrans_DescriptionDetailPanel_SkinDetailPanel = self:GetRectTransform("Trans_SkinOption/UI_DescriptionDetailPanel/Trans_VLayout_SkinDetailPanel");
	self.mTrans_SkinListPanel = self:GetRectTransform("Trans_SkinOption/DetailPanel/Trans_Layout_SkinListPanel");
	self.mTrans_Title = self:GetRectTransform("Trans_SkinOption/Title");
end

--@@ GF Auto Gen Block End

function UIStoreSkinPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
end