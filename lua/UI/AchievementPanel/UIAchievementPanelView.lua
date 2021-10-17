require("UI.UIBaseView")

UIAchievementPanelView = class("UIAchievementPanelView", UIBaseView);
UIAchievementPanelView.__index = UIAchievementPanelView

--@@ GF Auto Gen Block Begin
UIAchievementPanelView.mBtn_Return = nil;
UIAchievementPanelView.mBtn_ReceiveAll = nil;
UIAchievementPanelView.mImage_AchievementPanel_AchievementQuantityPanel_Progress = nil;
UIAchievementPanelView.mText_AchievementPanel_AchievementQuantityPanel_AchievementQuantityText = nil;
UIAchievementPanelView.mText_AchievementPanel_AchievementCountPanel_AchievementCountText = nil;
UIAchievementPanelView.mVLayout_AchievementTypeList_TypeList = nil;
UIAchievementPanelView.mTrans_AchievementTypeList = nil;
UIAchievementPanelView.mTrans_AchievementTypeList_ArrowImage = nil;
UIAchievementPanelView.mTrans_AchievementPanel = nil;
UIAchievementPanelView.mTrans_AchievementPanel_AchievementListPanel = nil;
UIAchievementPanelView.mTrans_AchievementPanel_AchievementListPanel_QuestList = nil;

function UIAchievementPanelView:__InitCtrl()

	self.mBtn_Return = self:GetButton("TopPanel/Btn_Return");
	self.mBtn_ReceiveAll = self:GetButton("TopPanel/Btn_ReceiveAll");
	self.mImage_AchievementPanel_AchievementQuantityPanel_Progress = self:GetImage("UI_Trans_AchievementPanel/AchievementInfor/UI_AchievementQuantityPanel/ProgressBG/Image_Progress");
	self.mText_AchievementPanel_AchievementQuantityPanel_AchievementQuantityText = self:GetText("UI_Trans_AchievementPanel/AchievementInfor/UI_AchievementQuantityPanel/Text_AchievementQuantityText");
	self.mText_AchievementPanel_AchievementCountPanel_AchievementCountText = self:GetText("UI_Trans_AchievementPanel/AchievementInfor/UI_AchievementCountPanel/Text_AchievementCountText");
	self.mVLayout_AchievementTypeList_TypeList = self:GetVerticalLayoutGroup("UI_Trans_AchievementTypeList/VLayout_TypeList");
	self.mTrans_AchievementTypeList = self:GetRectTransform("UI_Trans_AchievementTypeList");
	self.mTrans_AchievementTypeList_ArrowImage = self:GetRectTransform("UI_Trans_AchievementTypeList/VLayout_TypeList/Trans_ArrowImage");
	self.mTrans_AchievementPanel = self:GetRectTransform("UI_Trans_AchievementPanel");
	self.mTrans_AchievementPanel_AchievementListPanel = self:GetRectTransform("UI_Trans_AchievementPanel/UI_Trans_AchievementListPanel");
	self.mTrans_AchievementPanel_AchievementListPanel_QuestList = self:GetRectTransform("UI_Trans_AchievementPanel/UI_Trans_AchievementListPanel/QuestList/Trans_QuestList");
end

--@@ GF Auto Gen Block End

function UIAchievementPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end