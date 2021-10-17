require("UI.UIBaseView")

UITopBannerPanelView = class("UITopBannerPanelView", UIBaseView);
UITopBannerPanelView.__index = UITopBannerPanelView

--@@ GF Auto Gen Block Begin
UITopBannerPanelView.mBtn_ClosePanel_BGCloseButton = nil;
UITopBannerPanelView.mBtn_ClosePanel_Cancel = nil;
UITopBannerPanelView.mBtn_ClosePanel_Close = nil;
UITopBannerPanelView.mText_ClosePanel_Name = nil;
UITopBannerPanelView.mText_ClosePanel_MainText = nil;
UITopBannerPanelView.mTrans_BannerScrollBar = nil;
UITopBannerPanelView.mTrans_ClosePanel = nil;

function UITopBannerPanelView:__InitCtrl()

	self.mBtn_ClosePanel_BGCloseButton = self:GetButton("UI_Trans_ClosePanel/Btn_BGCloseButton");
	self.mBtn_ClosePanel_Cancel = self:GetButton("UI_Trans_ClosePanel/SearchingPanel/BGPanel/ButtonPanel/Btn_Cancel");
	self.mBtn_ClosePanel_Close = self:GetButton("UI_Trans_ClosePanel/SearchingPanel/BGPanel/ButtonPanel/Btn_Close");
	self.mText_ClosePanel_Name = self:GetText("UI_Trans_ClosePanel/SearchingPanel/Text_Name");
	self.mText_ClosePanel_MainText = self:GetText("UI_Trans_ClosePanel/SearchingPanel/BGPanel/TitlePanel/Text_MainText");
	self.mTrans_BannerScrollBar = self:GetRectTransform("Trans_BannerScrollBar");
	self.mTrans_BannerScrollBarList = self:GetRectTransform("Trans_BannerScrollBar/UI_HLayout_TopBannerList");
	self.mTrans_ClosePanel = self:GetRectTransform("UI_Trans_ClosePanel");
end

--@@ GF Auto Gen Block End

function UITopBannerPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
end
