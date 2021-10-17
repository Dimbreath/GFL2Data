require("UI.UIBaseView")

UIStoreMainPanelView = class("UIStoreMainPanelView", UIBaseView);
UIStoreMainPanelView.__index = UIStoreMainPanelView

--@@ GF Auto Gen Block Begin
UIStoreMainPanelView.mBtn_Return = nil;
UIStoreMainPanelView.mBtn_TouchArea = nil;
UIStoreMainPanelView.mBtn_ExchangeBtn = nil;
UIStoreMainPanelView.mImage_AffectionFilledBar = nil;
UIStoreMainPanelView.mText_NameCHS = nil;
UIStoreMainPanelView.mText_NameEn = nil;
UIStoreMainPanelView.mText_SortName = nil;
UIStoreMainPanelView.mText_SortName2 = nil;
UIStoreMainPanelView.mText_Level = nil;
UIStoreMainPanelView.mText_AffectionDialog = nil;
UIStoreMainPanelView.mLayout_ListSmall_DetailList = nil;
UIStoreMainPanelView.mHLayout_ListBig_DetailList = nil;
UIStoreMainPanelView.mHLayout_ButtonTab = nil;
UIStoreMainPanelView.mScrRect_ListBig = nil;
UIStoreMainPanelView.mScrRect_ListSmall = nil;
UIStoreMainPanelView.mTrans_ListBig = nil;
UIStoreMainPanelView.mTrans_ListSmall = nil;
UIStoreMainPanelView.mTrans_AffectionBar = nil;
UIStoreMainPanelView.mTrans_Dialog = nil;
UIStoreMainPanelView.mTrans_AffectionBubble = nil;
UIStoreMainPanelView.mTrans_ExchangeBtn = nil;

function UIStoreMainPanelView:__InitCtrl()

	self.mBtn_Return = self:GetButton("TopPanel/Btn_Return");
	self.mBtn_TouchArea = self:GetButton("QuartermasterPanel/Btn_TouchArea");
	self.mBtn_ExchangeBtn = self:GetButton("QuartermasterPanel/Trans_Btn_ExchangeBtn");
	self.mImage_AffectionFilledBar = self:GetImage("QuartermasterPanel/Trans_AffectionBar/AffectionFilledBarbg/Image_AffectionFilledBar");
	self.mText_NameCHS = self:GetText("TopPanel/Title/Text_NameCHS");
	self.mText_NameEn = self:GetText("TopPanel/Title/Text_NameEn");
	self.mText_SortName = self:GetText("Panel/SortLine/NameBG/Text_SortName");
	self.mText_SortName2 = self:GetText("Panel/SortLine/Text_SortName2");
	self.mText_Level = self:GetText("QuartermasterPanel/Trans_AffectionBar/Text_Level");
	self.mText_AffectionDialog = self:GetText("QuartermasterPanel/Trans_Dialog/BG/Text_AffectionDialog");
	self.mLayout_ListSmall_DetailList = self:GetGridLayoutGroup("Panel/UI_Trans_ScrRect_ListSmall/Layout_DetailList");
	self.mHLayout_ListBig_DetailList = self:GetHorizontalLayoutGroup("Panel/UI_Trans_ScrRect_ListBig/HLayout_DetailList");
	self.mHLayout_ButtonTab = self:GetHorizontalLayoutGroup("HLayout_ButtonTab");
	self.mScrRect_ListBig = self:GetScrollRect("Panel/UI_Trans_ScrRect_ListBig");
	self.mScrRect_ListSmall = self:GetScrollRect("Panel/UI_Trans_ScrRect_ListSmall");
	self.mTrans_ListBig = self:GetRectTransform("Panel/UI_Trans_ScrRect_ListBig");
	self.mTrans_ListSmall = self:GetRectTransform("Panel/UI_Trans_ScrRect_ListSmall");
	self.mTrans_AffectionBar = self:GetRectTransform("QuartermasterPanel/Trans_AffectionBar");
	self.mTrans_Dialog = self:GetRectTransform("QuartermasterPanel/Trans_Dialog");
	self.mTrans_AffectionBubble = self:GetRectTransform("QuartermasterPanel/Trans_AffectionBubble");
	self.mTrans_ExchangeBtn = self:GetRectTransform("QuartermasterPanel/Trans_Btn_ExchangeBtn");
end

--@@ GF Auto Gen Block End

function UIStoreMainPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end