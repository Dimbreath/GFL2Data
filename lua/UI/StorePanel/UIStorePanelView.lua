require("UI.UIBaseView")

UIStorePanelView = class("UIStorePanelView", UIBaseView);
UIStorePanelView.__index = UIStorePanelView

--@@ GF Auto Gen Block Begin
UIStorePanelView.mBtn_TouchArea = nil;
UIStorePanelView.mBtn_Return = nil;
UIStorePanelView.mBtn_SwitchToStore = nil;
UIStorePanelView.mBtn_SwitchToSkin = nil;
UIStorePanelView.mImage_AffectionBar_AffectionFilledBar = nil;
UIStorePanelView.mImage_Message = nil;
UIStorePanelView.mText_Title = nil;
UIStorePanelView.mText_RefreshTime = nil;
UIStorePanelView.mText_AffectionBar_Level = nil;
UIStorePanelView.mText_AffectionDialog = nil;
UIStorePanelView.mTrans_RefreshTimebg = nil;
UIStorePanelView.mTrans_TagList = nil;
UIStorePanelView.mTrans_GoodsList = nil;
UIStorePanelView.mTrans_Big = nil;
UIStorePanelView.mTrans_AffectionBar = nil;
UIStorePanelView.mTrans_Dialog = nil;
UIStorePanelView.mTrans_Message = nil;
UIStorePanelView.mTrans_LevelUp = nil;
UIStorePanelView.mTrans_AffectionBubble = nil;

function UIStorePanelView:__InitCtrl()

	self.mBtn_TouchArea = self:GetButton("QuartermasterPanel/Btn_TouchArea");
	self.mBtn_Return = self:GetButton("TopPanel/Btn_Return");
	self.mBtn_SwitchToStore = self:GetButton("SwitchView/Btn_SwitchToStore");
	self.mBtn_SwitchToSkin = self:GetButton("SwitchView/Btn_SwitchToSkin");
	self.mImage_AffectionBar_AffectionFilledBar = self:GetImage("QuartermasterPanel/UI_Trans_AffectionBar/AffectionFilledBarbg/Image_AffectionFilledBar");
	self.mImage_Message = self:GetImage("QuartermasterPanel/Trans_Image_Message");
	self.mText_Title = self:GetText("StoreBuyPanel/Text_Store_Title");
	self.mText_RefreshTime = self:GetText("StoreBuyPanel/Trans_RefreshTimebg/Text_RefreshTime");
	self.mText_AffectionBar_Level = self:GetText("QuartermasterPanel/UI_Trans_AffectionBar/Text_Level");
	self.mText_AffectionDialog = self:GetText("QuartermasterPanel/Trans_Dialog/AffectionDialog/Text_AffectionDialog");
	self.mTrans_RefreshTimebg = self:GetRectTransform("StoreBuyPanel/Trans_RefreshTimebg");
	self.mTrans_TagList = self:GetRectTransform("StoreBuyPanel/StoreTagPanel/Trans_TagList");
	self.mTrans_GoodsList = self:GetRectTransform("StoreBuyPanel/Goods/Trans_GoodsList");
	self.mTrans_Big = self:GetRectTransform("StoreBuyPanel/Goods_big/Trans_GoodsList_Big");
	self.mTrans_AffectionBar = self:GetRectTransform("QuartermasterPanel/UI_Trans_AffectionBar");
	self.mTrans_Dialog = self:GetRectTransform("QuartermasterPanel/Trans_Dialog");
	self.mTrans_Message = self:GetRectTransform("QuartermasterPanel/Trans_Image_Message");
	self.mTrans_LevelUp = self:GetRectTransform("QuartermasterPanel/Trans_Image_Message/Trans_LevelUp");
	self.mTrans_AffectionBubble = self:GetRectTransform("QuartermasterPanel/Trans_AffectionBubble");
end

--@@ GF Auto Gen Block End

UIStorePanelView.mTrans_StoreCoinList = nil;

function UIStorePanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mTrans_StoreCoinList = self:GetRectTransform("StoreBuyPanel/StoreCoinList");

	setactive(self.mBtn_SwitchToStore.gameObject,false);

end


function UIStorePanelView:SetCoinListWidth(num)
	local h = self.mTrans_StoreCoinList.rect.height;
	self.mTrans_StoreCoinList.sizeDelta = Vector2(num * UIStorePanelView.CoreItemWidth, h);
end
