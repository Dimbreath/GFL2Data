require("UI.UIBaseView")

UIGashaponMainView = class("UIGashaponMainView", UIBaseView);
UIGashaponMainView.__index = UIGashaponMainView

UIGashaponMainView.mBtnTabActivity = nil;
UIGashaponMainView.mBtnTabNormal = nil;
UIGashaponMainView.mImgTabActivity = nil;
UIGashaponMainView.mImgTabNormal = nil;
UIGashaponMainView.mBtnTenTime = nil;
UIGashaponMainView.mBtnOneTime = nil;
UIGashaponMainView.mBtnTenTimeAgain = nil;
UIGashaponMainView.mBtnOneTimeAgain = nil;
UIGashaponMainView.mBtnSkipFlip = nil;
UIGashaponMainView.mBtnConfirm = nil;
UIGashaponMainView.mBtnGachaList = nil;
UIGashaponMainView.mButton_UI_Return = nil;
UIGashaponMainView.mListItemRoot = nil;
UIGashaponMainView.mImgNormalBanner = nil;
UIGashaponMainView.mImgActivityBanner = nil;
UIGashaponMainView.mTxtTicketAmount = nil;
UIGashaponMainView.mTxtDiamondAmount = nil;
UIGashaponMainView.mTxtTabActivity = nil;
UIGashaponMainView.mTxtTabNormal = nil;
UIGashaponMainView.mTxtActivityCountDown = nil;
UIGashaponMainView.mImgResultPanel = nil;
UIGashaponMainView.mButton_UI_AddResourcesBtn = nil;


UIGashaponMainView.mGachaPanelObj = nil;
UIGashaponMainView.mAdsPanelObj = nil;
UIGashaponMainView.mGachaResultPanelObj = nil;
UIGashaponMainView.mGachaPanelBGObj = nil;
UIGashaponMainView.mBannerItemObj1 = nil;
UIGashaponMainView.mBannerItemObj2 = nil;
UIGashaponMainView.mGetCachaBtnObj = nil;

UIGashaponMainView.mTweenEase = CS.DG.Tweening.Ease.InOutSine;
UIGashaponMainView.mTweenExpo = CS.DG.Tweening.Ease.InOutCirc;

--UIGashaponMainView.mSelectedColor = nil;
--UIGashaponMainView.mUnSelecteedColor = nil;

function UIGashaponMainView:__InitCtrl()

	self.mBtnTabActivity = self:GetButton("GachaPanel/BG/TabPanel/UI_GachaActivityBtn");
	self.mBtnTabNormal = self:GetButton("GachaPanel/BG/TabPanel/UI_GachaNormalBtn");
	self.mBtnTenTime = self:GetButton("GachaPanel/BG/UI_GetGachaBtn/UI_GetTenBtn");
	self.mBtnOneTime = self:GetButton("GachaPanel/BG/UI_GetGachaBtn/UI_GetOneBtn");
	self.mBtnTenTimeAgain = self:GetButton("GachaPanel/UI_GachaResultPanel/UI_GetGachaBtn/UI_GetTenBtn");
	self.mBtnOneTimeAgain = self:GetButton("GachaPanel/UI_GachaResultPanel/UI_GetGachaBtn/UI_GetOneBtn");
	self.mBtnSkipFlip = self:GetButton("GachaPanel/UI_GachaResultPanel/UI_SkipFlipBtn");
	self.mBtnConfirm = self:GetButton("GachaPanel/UI_GachaResultPanel/UI_ConfirmBtn");
	self.mBtnGachaList = self:GetButton("GachaPanel/BG/UI_GachaListBtn");
	self.mButton_UI_Return = self:GetButton("GachaPanel/Btn_Close");
	
	self.mImgNormalBanner = self:GetImage("GachaPanel/BG/Banner/BannerItem1/UI_BannerImg");
	self.mImgActivityBanner = self:GetImage("GachaPanel/BG/Banner/BannerItem2/UI_BannerImg");
	self.mImgTabActivity = self:GetImage("GachaPanel/BG/TabPanel/UI_GachaActivityBtn");
	self.mImgTabNormal = self:GetImage("GachaPanel/BG/TabPanel/UI_GachaNormalBtn");
	self.mBannerItemObj1 = self:GetImage("GachaPanel/BG/Banner/BannerItem1").gameObject;
	self.mBannerItemObj2 = self:GetImage("GachaPanel/BG/Banner/BannerItem2").gameObject;
	self.mImgResultPanel = self:GetImage("GachaPanel/UI_GachaResultPanel");
	
	self.mTxtTicketAmount = self:GetText("GachaPanel/UI_CurrencyPanel/ResourcesList/Resources_Ticket/ResourcesAmountText");
	self.mTxtDiamondAmount = self:GetText("GachaPanel/UI_CurrencyPanel/ResourcesList/Resources_diamond/ResourcesAmountText");
	self.mTxtTabActivity = self:GetText("GachaPanel/BG/TabPanel/UI_GachaActivityBtn/Text");
	self.mTxtTabNormal = self:GetText("GachaPanel/BG/TabPanel/UI_GachaNormalBtn/Text");
	self.mTxtActivityCountDown = self:GetText("GachaPanel/BG/Banner/BannerItem2/CountDown/Text");
	
	self.mGachaPanelObj = self:GetImage("GachaPanel").gameObject;
	self.mAdsPanelObj = self:GetImage("AdsPanel").gameObject;
	self.mGachaResultPanelObj = self:GetImage("GachaPanel/UI_GachaResultPanel").gameObject;
	self.mGachaPanelBGObj = self:GetImage("GachaPanel/BG").gameObject;
	self.mListItemRoot = self:GetImage("GachaPanel/UI_GachaResultPanel/UI_ListLayout").gameObject;
	self.mGetCachaBtnObj = self:GetRectTransform("GachaPanel/UI_GachaResultPanel/UI_GetGachaBtn").gameObject;
	
	self.mButton_UI_AddResourcesBtn = self:GetButton("GachaPanel/UI_CurrencyPanel/ResourcesList/AddResourcesButton");
	self.mImgResultPanel.sprite = UIUtils.GetIconSprite("Gashapon/Res","GachaResultBG");
end

function UIGashaponMainView:InitCtrl(root)
	self:SetRoot(root);
	self:__InitCtrl();
end

function UIGashaponMainView:ShowActivityBanner()	
	setactive(self.mBannerItemObj1,false);
	setactive(self.mBannerItemObj2,true);
	
	CS.LuaUIUtils.SetColor(self.mImgTabActivity,"#D3EDF6FF");
	CS.LuaUIUtils.SetColor(self.mImgTabNormal,"#1A2F36FF");

	CS.LuaUIUtils.SetColor(self.mTxtTabActivity,"#124552FF");
	CS.LuaUIUtils.SetColor(self.mTxtTabNormal,"#E0F3F8FF");
end

function UIGashaponMainView:ShowNormalBanner()
	setactive(self.mBannerItemObj1,true);
	setactive(self.mBannerItemObj2,false);
	
	CS.LuaUIUtils.SetColor(self.mImgTabActivity,"#1A2F36FF");
	CS.LuaUIUtils.SetColor(self.mImgTabNormal,"#D3EDF6FF");
	
	CS.LuaUIUtils.SetColor(self.mTxtTabActivity,"#E0F3F8FF");
	CS.LuaUIUtils.SetColor(self.mTxtTabNormal,"#124552FF");
end

-- function UIGashaponMainView:FadeInGachaPanel()
	-- setactive(self.mGachaPanelObj,true);
	-- setactive(self.mAdsPanelObj,false);
	-- CS.UITweenManager.PlayFadeTweens(self.mGachaPanelObj.transform,0,1,0.5,false,nil,self.mTweenEase);
	-- --CS.UITweenManager.PlayFadeTween(self.mAdsPanelObj.transform,1,0,0.5,0,nil,self.mTweenExpo);
-- end

function UIGashaponMainView:ShowResultPanel()
	setactive(self.mGachaResultPanelObj,true);
	setactive(self.mGachaPanelBGObj,false);
	
	if(self.mImgResultPanel.color.a < 0.05) then
		CS.UITweenManager.PlayFadeTweens(self.mGachaResultPanelObj.transform,0,1,0.5,false,nil,self.mTweenEase);
		CS.UITweenManager.PlayFadeTweens(self.mGachaPanelBGObj.transform,1,0,0.5,false,nil,self.mTweenEase);
	end
end

function UIGashaponMainView:HideResultPanel()
	setactive(self.mGachaResultPanelObj,false);
	setactive(self.mGachaPanelBGObj,true);
	
	CS.UITweenManager.PlayFadeTweens(self.mGachaResultPanelObj.transform,1,0,0.5,false,nil,self.mTweenEase);
	CS.UITweenManager.PlayFadeTweens(self.mGachaPanelBGObj.transform,0,1,0.2,false,nil,self.mTweenEase);
end

function UIGashaponMainView.ShowSkip()
	self = UIGashaponMainView;
	setactive(self.mBtnTenTime,false);
	setactive(self.mBtnOneTime,false);
	setactive(self.mBtnSkipFlip,true);
	setactive(self.mBtnConfirm,false);
	setactive(self.mGetCachaBtnObj,false);
end

function UIGashaponMainView.ShowConfirm()
	self = UIGashaponMainView;
	setactive(self.mBtnTenTime,false);
	setactive(self.mBtnOneTime,false);
	setactive(self.mBtnSkipFlip,false);
	setactive(self.mBtnConfirm,true);
	setactive(self.mGetCachaBtnObj,true);
end

function UIGashaponMainView.HideConfirm()
	self = UIGashaponMainView;
	setactive(self.mBtnConfirm,false);
	setactive(self.mGetCachaBtnObj,false);
end

function UIGashaponMainView.ShowDrawButtons()
	self = UIGashaponMainView;
	setactive(self.mBtnTenTime,true);
	setactive(self.mBtnOneTime,true);
	setactive(self.mBtnSkipFlip,false);
	setactive(self.mBtnConfirm,false);
	setactive(self.mGetCachaBtnObj,false);
	setactive(self.mButton_UI_Return.gameObject,true);
end

function UIGashaponMainView.HideDrawButtons()
	self = UIGashaponMainView;
	setactive(self.mBtnTenTime,false);
	setactive(self.mBtnOneTime,false);
	setactive(self.mBtnConfirm,false);
	setactive(self.mGetCachaBtnObj,false);
	setactive(self.mButton_UI_Return.gameObject,false);
end