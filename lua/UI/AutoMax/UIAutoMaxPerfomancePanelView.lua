require("UI.UIBaseView")

UIAutoMaxPerfomancePanelView = class("UIAutoMaxPerfomancePanelView", UIBaseView);
UIAutoMaxPerfomancePanelView.__index = UIAutoMaxPerfomancePanelView

--@@ GF Auto Gen Block Begin
UIAutoMaxPerfomancePanelView.mBtn_SkipPerformance = nil;
UIAutoMaxPerfomancePanelView.mImage_Progress = nil;
UIAutoMaxPerfomancePanelView.mText_BreakInfoPopup_TextLayout_TeamNumber = nil;
UIAutoMaxPerfomancePanelView.mTrans_PlayerTeams = nil;
UIAutoMaxPerfomancePanelView.mTrans_EnemyTeams = nil;
UIAutoMaxPerfomancePanelView.mTrans_BreakInfoPopup = nil;
UIAutoMaxPerfomancePanelView.mTrans_BreakInfoPopup_TextLayout_Player = nil;
UIAutoMaxPerfomancePanelView.mTrans_BreakInfoPopup_TextLayout_Enemy = nil;

function UIAutoMaxPerfomancePanelView:__InitCtrl()

	self.mBtn_SkipPerformance = self:GetButton("Btn_SkipPerformance");
	self.mImage_Progress = self:GetImage("ProgressBar/Image_Progress");
	self.mText_BreakInfoPopup_TextLayout_TeamNumber = self:GetText("UI_Trans_BreakInfoPopup/UI_TextLayout/Text_TeamNumber");
	self.mTrans_PlayerTeams = self:GetRectTransform("Trans_PlayerTeams");
	self.mTrans_EnemyTeams = self:GetRectTransform("Trans_EnemyTeams");
	self.mTrans_BreakInfoPopup = self:GetRectTransform("UI_Trans_BreakInfoPopup");
	self.mTrans_BreakInfoPopup_TextLayout_Player = self:GetRectTransform("UI_Trans_BreakInfoPopup/UI_TextLayout/Trans_Player");
	self.mTrans_BreakInfoPopup_TextLayout_Enemy = self:GetRectTransform("UI_Trans_BreakInfoPopup/UI_TextLayout/Trans_Enemy");
end

--@@ GF Auto Gen Block End

function UIAutoMaxPerfomancePanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end