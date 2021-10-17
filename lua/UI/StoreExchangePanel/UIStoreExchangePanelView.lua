require("UI.UIBaseView")

UIStoreExchangePanelView = class("UIStoreExchangePanelView", UIBaseView);
UIStoreExchangePanelView.__index = UIStoreExchangePanelView

--@@ GF Auto Gen Block Begin
UIStoreExchangePanelView.mBtn_CommandCenter = nil;
UIStoreExchangePanelView.mBtn_HButtonUp0 = nil;
UIStoreExchangePanelView.mBtn_HButtonUp1 = nil;
UIStoreExchangePanelView.mBtn_HButtonUp2 = nil;
UIStoreExchangePanelView.mBtn_Return = nil;
UIStoreExchangePanelView.mBtn_RenewButton = nil;
UIStoreExchangePanelView.mImage_CostItem = nil;
UIStoreExchangePanelView.mText_HButtonUp0_Off_Title = nil;
UIStoreExchangePanelView.mText_HButtonUp0_On_Title = nil;
UIStoreExchangePanelView.mText_HButtonUp1_Off_Title = nil;
UIStoreExchangePanelView.mText_HButtonUp1_On_Title = nil;
UIStoreExchangePanelView.mText_HButtonUp2_Off_Title = nil;
UIStoreExchangePanelView.mText_HButtonUp2_On_Title = nil;
UIStoreExchangePanelView.mText_CountDown = nil;
UIStoreExchangePanelView.mText_CostNum = nil;
UIStoreExchangePanelView.mLayout_List = nil;
UIStoreExchangePanelView.mTrans_HButtonUp0_Off = nil;
UIStoreExchangePanelView.mTrans_HButtonUp0_On = nil;
UIStoreExchangePanelView.mTrans_HButtonUp1_Off = nil;
UIStoreExchangePanelView.mTrans_HButtonUp1_On = nil;
UIStoreExchangePanelView.mTrans_HButtonUp2_Off = nil;
UIStoreExchangePanelView.mTrans_HButtonUp2_On = nil;
UIStoreExchangePanelView.mTrans_ButtonList = nil;
UIStoreExchangePanelView.mTrans_BottomPanel = nil;

UIStoreExchangePanelView.mTrans_TopTabContent = nil;
UIStoreExchangePanelView.mTrans_Refresh = nil;
function UIStoreExchangePanelView:__InitCtrl()

	self.mBtn_CommandCenter = self:GetButton("Root/GrpTop/BtnHome/Btn_Home");
	self.mBtn_HButtonUp0 = self:GetButton("UpButtonList/UI_Btn_HButtonUp0");
	self.mBtn_HButtonUp1 = self:GetButton("UpButtonList/UI_Btn_HButtonUp1");
	self.mBtn_HButtonUp2 = self:GetButton("UpButtonList/UI_Btn_HButtonUp2");
	self.mBtn_Return = self:GetButton("Root/GrpTop/BtnBack/Btn_Back");
	self.mBtn_RenewButton = self:GetButton("Root/GrpRight/GrpContent/Trans_GrpTextCountdown/GrpBtnFresh/Btn_Refresh");
	self.mImage_CostItem = self:GetImage("Root/GrpRight/GrpContent/Trans_GrpTextCountdown/GrpFresh/GrpIcon/Img_Icon");
	self.mText_HButtonUp0_Off_Title = self:GetText("UpButtonList/UI_Btn_HButtonUp0/UI_Trans_Off/Text_Title");
	self.mText_HButtonUp0_On_Title = self:GetText("UpButtonList/UI_Btn_HButtonUp0/UI_Trans_On/Text_Title");
	self.mText_HButtonUp1_Off_Title = self:GetText("UpButtonList/UI_Btn_HButtonUp1/UI_Trans_Off/Text_Title");
	self.mText_HButtonUp1_On_Title = self:GetText("UpButtonList/UI_Btn_HButtonUp1/UI_Trans_On/Text_Title");
	self.mText_HButtonUp2_Off_Title = self:GetText("UpButtonList/UI_Btn_HButtonUp2/UI_Trans_Off/Text_Title");
	self.mText_HButtonUp2_On_Title = self:GetText("UpButtonList/UI_Btn_HButtonUp2/UI_Trans_On/Text_Title");
	self.mText_CountDown = self:GetText("Root/GrpRight/GrpContent/Trans_GrpTextCountdown/GrpText/Text_Name");
	self.mText_CostNum = self:GetText("Root/GrpRight/GrpContent/Trans_GrpTextCountdown/GrpFresh/Text_CostNum");
	self.mLayout_List = self:GetGridLayoutGroup("Root/GrpRight/GrpContent/GrpItemList/Viewport/Content");
	self.mTrans_HButtonUp0_Off = self:GetRectTransform("UpButtonList/UI_Btn_HButtonUp0/UI_Trans_Off");
	self.mTrans_HButtonUp0_On = self:GetRectTransform("UpButtonList/UI_Btn_HButtonUp0/UI_Trans_On");
	self.mTrans_HButtonUp1_Off = self:GetRectTransform("UpButtonList/UI_Btn_HButtonUp1/UI_Trans_Off");
	self.mTrans_HButtonUp1_On = self:GetRectTransform("UpButtonList/UI_Btn_HButtonUp1/UI_Trans_On");
	self.mTrans_HButtonUp2_Off = self:GetRectTransform("UpButtonList/UI_Btn_HButtonUp2/UI_Trans_Off");
	self.mTrans_HButtonUp2_On = self:GetRectTransform("UpButtonList/UI_Btn_HButtonUp2/UI_Trans_On");
	self.mTrans_ButtonList = self:GetRectTransform("Root/GrpLeft/Content/GrpTabList/Viewport/Content");
	self.mTrans_BottomPanel = self:GetRectTransform("Trans_BottomPanel");

	self.mTrans_TopTabContent = self:GetRectTransform("Root/GrpRight/GrpContent/Trans_GrpTopTab");
	self.mTrans_Refresh = self:GetRectTransform("Root/GrpRight/GrpContent/Trans_GrpTextCountdown/GrpFresh");
end

--@@ GF Auto Gen Block End

function UIStoreExchangePanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end