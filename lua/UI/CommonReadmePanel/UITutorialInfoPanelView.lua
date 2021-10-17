require("UI.UIBaseView")

UITutorialInfoPanelView = class("UITutorialInfoPanelView", UIBaseView);
UITutorialInfoPanelView.__index = UITutorialInfoPanelView

--@@ GF Auto Gen Block Begin
UITutorialInfoPanelView.mBtn_Prev = nil;
UITutorialInfoPanelView.mBtn_Next = nil;
UITutorialInfoPanelView.mBtn_CloseButton = nil;
UITutorialInfoPanelView.mImage_Image = nil;
UITutorialInfoPanelView.mText_HintDetail = nil;
UITutorialInfoPanelView.mTrans_HintDetail = nil;
UITutorialInfoPanelView.mTrans_Image = nil;
UITutorialInfoPanelView.mTrans_Prev = nil;
UITutorialInfoPanelView.mTrans_Next = nil;
UITutorialInfoPanelView.mTrans_CloseButton = nil;

function UITutorialInfoPanelView:__InitCtrl()

	self.mBtn_Prev = self:GetButton("Trans_Btn_Prev");
	self.mBtn_Next = self:GetButton("Trans_Btn_Next");
	self.mBtn_CloseButton = self:GetButton("Trans_Btn_CloseButton");
	self.mImage_Image = self:GetImage("DetailPagePanel/InfoDetailItem/DetailMask/Message/Trans_Image_Image");
	self.mText_HintDetail = self:GetText("DetailPagePanel/InfoDetailItem/DetailMask/Message/Trans_Text_HintDetail");
	self.mTrans_HintDetail = self:GetRectTransform("DetailPagePanel/InfoDetailItem/DetailMask/Message/Trans_Text_HintDetail");
	self.mTrans_Image = self:GetRectTransform("DetailPagePanel/InfoDetailItem/DetailMask/Message/Trans_Image_Image");
	self.mTrans_Prev = self:GetRectTransform("Trans_Btn_Prev");
	self.mTrans_Next = self:GetRectTransform("Trans_Btn_Next");
	self.mTrans_CloseButton = self:GetRectTransform("Trans_Btn_CloseButton");
	self.mTrans_PageView = self:GetRectTransform("DetailPagePanel")
	self.mTrans_Pagination = self:GetRectTransform("Pagination")
	self.mTrans_Content = self:GetRectTransform("DetailPagePanel/Content")
	self.mTrans_TempObj = self:GetRectTransform("DetailPagePanel/InfoDetailItem")
	self.mPageScroll = UIUtils.GetPageScroll(self.mTrans_PageView)
end

--@@ GF Auto Gen Block End

function UITutorialInfoPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end