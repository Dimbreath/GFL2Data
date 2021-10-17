require("UI.UIBaseView")

UICommonReadmePanelView = class("UICommonReadmePanelView", UIBaseView);
UICommonReadmePanelView.__index = UICommonReadmePanelView

--@@ GF Auto Gen Block Begin
UICommonReadmePanelView.mBtn_CloseButton = nil;
UICommonReadmePanelView.mImage_ADImage = nil;
UICommonReadmePanelView.mImage_BannerImagePanel_ADImage = nil;
UICommonReadmePanelView.mImage_HugeImagePanel_ADImage = nil;
UICommonReadmePanelView.mText_Title = nil;
UICommonReadmePanelView.mText_HintDetail = nil;
UICommonReadmePanelView.mVLayout_ButtonListPanel = nil;
UICommonReadmePanelView.mTrans_Title = nil;
UICommonReadmePanelView.mTrans_BannerImagePanel = nil;
UICommonReadmePanelView.mTrans_HugeImagePanel = nil;
UICommonReadmePanelView.mTrans_HintDetail = nil;

function UICommonReadmePanelView:__InitCtrl()

	self.mBtn_CloseButton = self:GetButton("WindowBG/Btn_CloseButton");
	self.mImage_ADImage = self:GetImage("WindowBG/ReadmeDetailPanel/DetailMask/DetailPanel/Message/Trans_Text_Title/Line/Image_ADImage");
	self.mImage_BannerImagePanel_ADImage = self:GetImage("WindowBG/ReadmeDetailPanel/DetailMask/DetailPanel/Message/Trans_BannerImagePanel/Image_ADImage");
	self.mImage_HugeImagePanel_ADImage = self:GetImage("WindowBG/ReadmeDetailPanel/DetailMask/DetailPanel/Message/Trans_HugeImagePanel/Image_ADImage");
	self.mText_Title = self:GetText("WindowBG/ReadmeDetailPanel/DetailMask/DetailPanel/Message/Trans_Text_Title");
	self.mText_HintDetail = self:GetText("WindowBG/ReadmeDetailPanel/DetailMask/DetailPanel/Message/Trans_Text_HintDetail");
	self.mVLayout_ButtonListPanel = self:GetVerticalLayoutGroup("WindowBG/VLayout_ButtonListPanel");
	self.mTrans_Title = self:GetRectTransform("WindowBG/ReadmeDetailPanel/DetailMask/DetailPanel/Message/Trans_Text_Title");
	self.mTrans_BannerImagePanel = self:GetRectTransform("WindowBG/ReadmeDetailPanel/DetailMask/DetailPanel/Message/Trans_BannerImagePanel");
	self.mTrans_HugeImagePanel = self:GetRectTransform("WindowBG/ReadmeDetailPanel/DetailMask/DetailPanel/Message/Trans_HugeImagePanel");
	self.mTrans_HintDetail = self:GetRectTransform("WindowBG/ReadmeDetailPanel/DetailMask/DetailPanel/Message/Trans_Text_HintDetail");
	self.mTrans_ReadmeContent = self:GetRectTransform("WindowBG/ReadmeDetailPanel")
	self.mTrans_Message = self:GetRectTransform("WindowBG/ReadmeDetailPanel/DetailMask/DetailPanel/Message")
	self.mScroll_Content = self:GetScrollRect("WindowBG/ReadmeDetailPanel/DetailMask/DetailPanel")
	self.mCanvasGroup = self.mTrans_ReadmeContent:GetComponent("CanvasGroup");
end

--@@ GF Auto Gen Block End

function UICommonReadmePanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end