require("UI.UIBaseView")

UIMainStorePanelView = class("UIMainStorePanelView", UIBaseView);
UIMainStorePanelView.__index = UIMainStorePanelView

--@@ GF Auto Gen Block Begin
UIMainStorePanelView.mBtn_Return = nil;
UIMainStorePanelView.mBtn_Diamond = nil;
UIMainStorePanelView.mBtn_TouchArea = nil;
UIMainStorePanelView.mBtn_SwitchToStore = nil;
UIMainStorePanelView.mBtn_SwitchToSkin = nil;
UIMainStorePanelView.mImage_AffectionBar_AffectionFilledBar = nil;
UIMainStorePanelView.mImage_Message = nil;
UIMainStorePanelView.mText_DiamondAmount = nil;
UIMainStorePanelView.mText_AffectionBar_Level = nil;
UIMainStorePanelView.mText_AffectionDialog = nil;
UIMainStorePanelView.mTrans_AdvertisementList = nil;
UIMainStorePanelView.mTrans_AdvertisementPageList = nil;
UIMainStorePanelView.mTrans_TagList = nil;
UIMainStorePanelView.mTrans_AffectionBar = nil;
UIMainStorePanelView.mTrans_Dialog = nil;
UIMainStorePanelView.mTrans_Message = nil;
UIMainStorePanelView.mTrans_LevelUp = nil;
UIMainStorePanelView.mTrans_AffectionBubble = nil;

function UIMainStorePanelView:__InitCtrl()

	self.mBtn_Return = self:GetButton("TopPanel/Btn_Return");
	self.mBtn_Diamond = self:GetButton("RightTopPanel/Btn_Diamond");
	self.mBtn_TouchArea = self:GetButton("QuartermasterPanel/Btn_TouchArea");
	self.mBtn_SwitchToStore = self:GetButton("SwitchView/Btn_SwitchToStore");
	self.mBtn_SwitchToSkin = self:GetButton("SwitchView/Btn_SwitchToSkin");
	self.mImage_AffectionBar_AffectionFilledBar = self:GetImage("QuartermasterPanel/UI_Trans_AffectionBar/AffectionFilledBarbg/Image_AffectionFilledBar");
	self.mImage_Message = self:GetImage("QuartermasterPanel/Trans_Image_Message");
	self.mText_DiamondAmount = self:GetText("RightTopPanel/Btn_Diamond/Text_DiamondAmount");
	self.mText_AffectionBar_Level = self:GetText("QuartermasterPanel/UI_Trans_AffectionBar/Text_Level");
	self.mText_AffectionDialog = self:GetText("QuartermasterPanel/Trans_Dialog/AffectionDialog/Text_AffectionDialog");
	self.mTrans_AdvertisementList = self:GetRectTransform("RightTopPanel/StoreAdvertisement/Advertisement/Trans_AdvertisementList");
	self.mTrans_AdvertisementPageList = self:GetRectTransform("RightTopPanel/StoreAdvertisement/Trans_AdvertisementPageList");
	self.mTrans_TagList = self:GetRectTransform("RightTopPanel/StoreTagPanel/Trans_TagList");
	self.mTrans_AffectionBar = self:GetRectTransform("QuartermasterPanel/UI_Trans_AffectionBar");
	self.mTrans_Dialog = self:GetRectTransform("QuartermasterPanel/Trans_Dialog");
	self.mTrans_Message = self:GetRectTransform("QuartermasterPanel/Trans_Image_Message");
	self.mTrans_LevelUp = self:GetRectTransform("QuartermasterPanel/Trans_Image_Message/Trans_LevelUp");
	self.mTrans_AffectionBubble = self:GetRectTransform("QuartermasterPanel/Trans_AffectionBubble");
end

--@@ GF Auto Gen Block End

UIMainStorePanelView.mTrans_StoreCoinList = nil;

function UIMainStorePanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mTrans_StoreCoinList = self:GetRectTransform("RightTopPanel/StoreCoinList");


end

function UIMainStorePanelView:SetCoinListWidth(num)
	local h = self.mTrans_StoreCoinList.rect.height;
	self.mTrans_StoreCoinList.sizeDelta = Vector2(num * UIStorePanelView.CoreItemWidth, h);
end