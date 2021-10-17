require("UI.UIBaseView")

UIExpeditionPanelView = class("UIExpeditionPanelView", UIBaseView);
UIExpeditionPanelView.__index = UIExpeditionPanelView

--@@ GF Auto Gen Block Begin
UIExpeditionPanelView.mBtn_TopInformation_Return = nil;
UIExpeditionPanelView.mImage_TopInformation_Coin_GoldCoin_CoinImage = nil;
UIExpeditionPanelView.mImage_TopInformation_Coin_TokenCoin_CoinImage = nil;
UIExpeditionPanelView.mText_TopInformation_Coin_BodyCoin_CoinAmount = nil;
UIExpeditionPanelView.mText_TopInformation_Coin_GoldCoin_CoinAmount = nil;
UIExpeditionPanelView.mText_TopInformation_Coin_TokenCoin_CoinAmount = nil;
UIExpeditionPanelView.mText_ExpeditionTeamPanel_ExpeditionTeamDispatchInformation = nil;
UIExpeditionPanelView.mVLayout_ExpeditionTypeListPanel_ExpeditionTypeList = nil;
UIExpeditionPanelView.mVLayout_ExpeditionTaskListPanel_ExpeditionTaskList = nil;
UIExpeditionPanelView.mVLayout_ExpeditionTeamPanel_ExpeditionTeamList = nil;
UIExpeditionPanelView.mScrRect_ExpeditionTypeListPanel_TypeList = nil;
UIExpeditionPanelView.mScrRect_ExpeditionTaskListPanel_TaskList = nil;
UIExpeditionPanelView.mScrRect_ExpeditionTeamPanel_TeamList = nil;
UIExpeditionPanelView.mTrans_TopInformation_Coin_BodyCoin = nil;

function UIExpeditionPanelView:__InitCtrl()

	self.mBtn_TopInformation_Return = self:GetButton("UI_TopInformation/Btn_Return");
	self.mImage_TopInformation_Coin_GoldCoin_CoinImage = self:GetImage("UI_TopInformation/UI_Coin/UI_GoldCoin/Image_CoinImage");
	self.mImage_TopInformation_Coin_TokenCoin_CoinImage = self:GetImage("UI_TopInformation/UI_Coin/UI_TokenCoin/Image_CoinImage");
	self.mText_TopInformation_Coin_BodyCoin_CoinAmount = self:GetText("UI_TopInformation/UI_Coin/UI_Trans_BodyCoin/Text_CoinAmount");
	self.mText_TopInformation_Coin_GoldCoin_CoinAmount = self:GetText("UI_TopInformation/UI_Coin/UI_GoldCoin/Text_CoinAmount");
	self.mText_TopInformation_Coin_TokenCoin_CoinAmount = self:GetText("UI_TopInformation/UI_Coin/UI_TokenCoin/Text_CoinAmount");
	self.mText_ExpeditionTeamPanel_ExpeditionTeamDispatchInformation = self:GetText("UI_ExpeditionTeamPanel/ExpeditionTeamDispatch/Text_ExpeditionTeamDispatchInformation");
	self.mVLayout_ExpeditionTypeListPanel_ExpeditionTypeList = self:GetVerticalLayoutGroup("UI_ExpeditionTypeListPanel/ScrRect_TypeList/VLayout_ExpeditionTypeList");
	self.mVLayout_ExpeditionTaskListPanel_ExpeditionTaskList = self:GetVerticalLayoutGroup("UI_ExpeditionTaskListPanel/ScrRect_TaskList/VLayout_ExpeditionTaskList");
	self.mVLayout_ExpeditionTeamPanel_ExpeditionTeamList = self:GetVerticalLayoutGroup("UI_ExpeditionTeamPanel/ScrRect_TeamList/VLayout_ExpeditionTeamList");
	self.mScrRect_ExpeditionTypeListPanel_TypeList = self:GetScrollRect("UI_ExpeditionTypeListPanel/ScrRect_TypeList");
	self.mScrRect_ExpeditionTaskListPanel_TaskList = self:GetScrollRect("UI_ExpeditionTaskListPanel/ScrRect_TaskList");
	self.mScrRect_ExpeditionTeamPanel_TeamList = self:GetScrollRect("UI_ExpeditionTeamPanel/ScrRect_TeamList");
	self.mTrans_TopInformation_Coin_BodyCoin = self:GetRectTransform("UI_TopInformation/UI_Coin/UI_Trans_BodyCoin");
end

--@@ GF Auto Gen Block End

function UIExpeditionPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end