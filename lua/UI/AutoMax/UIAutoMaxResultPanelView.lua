require("UI.UIBaseView")

UIAutoMaxResultPanelView = class("UIAutoMaxResultPanelView", UIBaseView);
UIAutoMaxResultPanelView.__index = UIAutoMaxResultPanelView

--@@ GF Auto Gen Block Begin
UIAutoMaxResultPanelView.mCanvasG_ResultBannerWin = nil;
UIAutoMaxResultPanelView.mTrans_Win = nil;
UIAutoMaxResultPanelView.mTrans_Lose = nil;
UIAutoMaxResultPanelView.mTrans_End = nil;

function UIAutoMaxResultPanelView:__InitCtrl()

	self.mCanvasG_ResultBannerWin = self:GetCanvasGroup("CanvasG_ResultBannerWin");
	self.mTrans_Win = self:GetRectTransform("CanvasG_ResultBannerWin/Trans_Win");
	self.mTrans_Lose = self:GetRectTransform("CanvasG_ResultBannerWin/Trans_Lose");
	self.mTrans_End = self:GetRectTransform("CanvasG_ResultBannerWin/Trans_End");
end

--@@ GF Auto Gen Block End

function UIAutoMaxResultPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end