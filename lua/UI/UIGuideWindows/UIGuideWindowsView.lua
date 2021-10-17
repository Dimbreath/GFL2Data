require("UI.UIBaseView")
---@class UIGuideWindowsView : UIBaseView
UIGuideWindowsView = class("UIGuideWindowsView", UIBaseView);
UIGuideWindowsView.__index = UIGuideWindowsView

--@@ GF Auto Gen Block Begin
UIGuideWindowsView.mBtn_PreviousPageBtn = nil;
UIGuideWindowsView.mBtn_NextPageBtn = nil;
UIGuideWindowsView.mBtn_FinishBtn = nil;
UIGuideWindowsView.mImage_GuideImage = nil;
UIGuideWindowsView.mText_GuideText = nil;
UIGuideWindowsView.mTrans_FinishBtn = nil;

UIGuideWindowsView.mProgressBarLayout = nil;

function UIGuideWindowsView:__InitCtrl()

	self.mBtn_PreviousPageBtn = self:GetButton("Root/GrpSkillSwitch/BtnArrow/Trans_GrpLeft/Btn_Left");
	self.mBtn_NextPageBtn = self:GetButton("Root/GrpSkillSwitch/BtnArrow/Trans_GrpRight/Btn_Right");
	self.mBtn_FinishBtn = self:GetButton("Root/Trans_GrpClose/Btn_Close");
	self.mImage_GuideImage = self:GetImage("Root/GrpContent/GrpGuidePic/GrpGuidePic/Img_GuidePic");
	self.mText_GuideText = self:GetText("Root/GrpContent/GrpText/Viewport/Content/Text/Text_Guide");
	self.mTrans_FinishBtn = self:GetRectTransform("Root/Trans_GrpClose");
	self.mProgressBarLayout = self:GetRectTransform("Root/GrpContent/GrpIndicator");
end

--@@ GF Auto Gen Block End

function UIGuideWindowsView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	self.mAnimator = self:GetComponent("Root", typeof(CS.UnityEngine.Animator))
	self.mCanvasGroup = self:GetCanvasGroup("Root");
end