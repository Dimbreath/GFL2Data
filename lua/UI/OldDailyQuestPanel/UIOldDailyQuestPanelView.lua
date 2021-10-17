require("UI.UIBaseView")

UIOldDailyQuestPanelView = class("UIOldDailyQuestPanelView", UIBaseView);
UIOldDailyQuestPanelView.__index = UIOldDailyQuestPanelView

--@@ GF Auto Gen Block Begin
UIOldDailyQuestPanelView.mBtn_Return = nil;
UIOldDailyQuestPanelView.mBtn_DailyQuestButton = nil;
UIOldDailyQuestPanelView.mBtn_DailyQuestUnChosen = nil;
UIOldDailyQuestPanelView.mBtn_WeeklyQuestButton = nil;
UIOldDailyQuestPanelView.mBtn_WeeklyQuestUnChosen = nil;
UIOldDailyQuestPanelView.mBtn_ChapterRewardBox = nil;
UIOldDailyQuestPanelView.mBtn_off = nil;
UIOldDailyQuestPanelView.mImage_ChapterRewardBox = nil;
UIOldDailyQuestPanelView.mImage_WeeklyReward1 = nil;
UIOldDailyQuestPanelView.mImage_WeeklyReward2 = nil;
UIOldDailyQuestPanelView.mImage_WeeklyReward3 = nil;
UIOldDailyQuestPanelView.mImage_WeeklyReward4 = nil;
UIOldDailyQuestPanelView.mText_WeeklyReward1Number_NumberText = nil;
UIOldDailyQuestPanelView.mText_WeeklyReward2Number_NumberText = nil;
UIOldDailyQuestPanelView.mText_WeeklyReward3Number_NumberText = nil;
UIOldDailyQuestPanelView.mText_WeeklyReward4Number_NumberText = nil;
UIOldDailyQuestPanelView.mTrans_DailyQuestButton_RedPoint = nil;
UIOldDailyQuestPanelView.mTrans_DailyQuestUnChosen_RedPoint = nil;
UIOldDailyQuestPanelView.mTrans_WeeklyQuestButton_RedPoint = nil;
UIOldDailyQuestPanelView.mTrans_WeeklyQuestUnChosen_RedPoint = nil;
UIOldDailyQuestPanelView.mTrans_QuestListPanel = nil;
UIOldDailyQuestPanelView.mTrans_QuestList = nil;
UIOldDailyQuestPanelView.mTrans_RewardPanel = nil;
UIOldDailyQuestPanelView.mTrans_GetReward = nil;
UIOldDailyQuestPanelView.mTrans_rewardList = nil;

function UIOldDailyQuestPanelView:__InitCtrl()

	self.mBtn_Return = self:GetButton("TopPanel/Btn_Return");
	self.mBtn_DailyQuestButton = self:GetButton("TopPanel/UI_Btn_DailyQuestButton");
	self.mBtn_DailyQuestUnChosen = self:GetButton("TopPanel/UI_Btn_DailyQuestUnChosen");
	self.mBtn_WeeklyQuestButton = self:GetButton("TopPanel/UI_Btn_WeeklyQuestButton");
	self.mBtn_WeeklyQuestUnChosen = self:GetButton("TopPanel/UI_Btn_WeeklyQuestUnChosen");
	self.mBtn_ChapterRewardBox = self:GetButton("Trans_RewardPanel/Btn_Image_ChapterRewardBox");
	self.mBtn_off = self:GetButton("Trans_GetReward/Title/Btn_BuyDiamond_off");
	self.mImage_ChapterRewardBox = self:GetImage("Trans_RewardPanel/Btn_Image_ChapterRewardBox");
	self.mImage_WeeklyReward1 = self:GetImage("Trans_RewardPanel/Image_WeeklyReward1");
	self.mImage_WeeklyReward2 = self:GetImage("Trans_RewardPanel/Image_WeeklyReward2");
	self.mImage_WeeklyReward3 = self:GetImage("Trans_RewardPanel/Image_WeeklyReward3");
	self.mImage_WeeklyReward4 = self:GetImage("Trans_RewardPanel/Image_WeeklyReward4");
	self.mText_WeeklyReward1Number_NumberText = self:GetText("Trans_RewardPanel/UI_WeeklyReward1Number/Text_NumberText");
	self.mText_WeeklyReward2Number_NumberText = self:GetText("Trans_RewardPanel/UI_WeeklyReward2Number/Text_NumberText");
	self.mText_WeeklyReward3Number_NumberText = self:GetText("Trans_RewardPanel/UI_WeeklyReward3Number/Text_NumberText");
	self.mText_WeeklyReward4Number_NumberText = self:GetText("Trans_RewardPanel/UI_WeeklyReward4Number/Text_NumberText");
	self.mTrans_DailyQuestButton_RedPoint = self:GetRectTransform("TopPanel/UI_Btn_DailyQuestButton/Trans_RedPoint");
	self.mTrans_DailyQuestUnChosen_RedPoint = self:GetRectTransform("TopPanel/UI_Btn_DailyQuestUnChosen/Trans_RedPoint");
	self.mTrans_WeeklyQuestButton_RedPoint = self:GetRectTransform("TopPanel/UI_Btn_WeeklyQuestButton/Trans_RedPoint");
	self.mTrans_WeeklyQuestUnChosen_RedPoint = self:GetRectTransform("TopPanel/UI_Btn_WeeklyQuestUnChosen/Trans_RedPoint");
	self.mTrans_QuestListPanel = self:GetRectTransform("Trans_QuestListPanel");
	self.mTrans_QuestList = self:GetRectTransform("Trans_QuestListPanel/QuestList/Trans_QuestList");
	self.mTrans_RewardPanel = self:GetRectTransform("Trans_RewardPanel");
	self.mTrans_GetReward = self:GetRectTransform("Trans_GetReward");
	self.mTrans_rewardList = self:GetRectTransform("Trans_GetReward/Trans_rewardList");
end

--@@ GF Auto Gen Block End

function UIOldDailyQuestPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end