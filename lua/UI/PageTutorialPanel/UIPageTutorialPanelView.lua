require("UI.UIBaseView")

UIPageTutorialPanelView = class("UIPageTutorialPanelView", UIBaseView);
UIPageTutorialPanelView.__index = UIPageTutorialPanelView

--@@ GF Auto Gen Block Begin
UIPageTutorialPanelView.mBtn_Next = nil;
UIPageTutorialPanelView.mBtn_Skip = nil;
UIPageTutorialPanelView.mImage_avatarImage = nil;
UIPageTutorialPanelView.mImage_mediaImage = nil;
UIPageTutorialPanelView.mText_dialogueText = nil;
UIPageTutorialPanelView.mTrans_clickArea = nil;
UIPageTutorialPanelView.mTrans_clickFrame = nil;
UIPageTutorialPanelView.mTrans_arrowUp = nil;
UIPageTutorialPanelView.mTrans_arrowRight = nil;
UIPageTutorialPanelView.mTrans_arrowLeft = nil;
UIPageTutorialPanelView.mTrans_arrowDown = nil;
UIPageTutorialPanelView.mTrans_dialogueUnit = nil;

function UIPageTutorialPanelView:__InitCtrl()

	self.mBtn_Next = self:GetButton("Btn_Next");
	self.mBtn_Skip = self:GetButton("Btn_Skip");
	self.mImage_avatarImage = self:GetImage("Trans_dialogueUnit/avatar/Image_avatarImage");
	self.mImage_mediaImage = self:GetImage("media/Image_mediaImage");
	self.mText_dialogueText = self:GetText("Trans_dialogueUnit/dialogue/Text_dialogueText");
	self.mTrans_clickArea = self:GetRectTransform("Trans_clickArea");
	self.mTrans_clickFrame = self:GetRectTransform("Trans_clickArea/Trans_clickFrame");
	self.mTrans_arrowUp = self:GetRectTransform("Trans_clickArea/Trans_clickFrame/Trans_arrowUp");
	self.mTrans_arrowRight = self:GetRectTransform("Trans_clickArea/Trans_clickFrame/Trans_arrowRight");
	self.mTrans_arrowLeft = self:GetRectTransform("Trans_clickArea/Trans_clickFrame/Trans_arrowLeft");
	self.mTrans_arrowDown = self:GetRectTransform("Trans_clickArea/Trans_clickFrame/Trans_arrowDown");
	self.mTrans_dialogueUnit = self:GetRectTransform("Trans_dialogueUnit");
end

--@@ GF Auto Gen Block End

function UIPageTutorialPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end