require("UI.UIBaseView")

UIAutoMaxSettlementPanelView = class("UIAutoMaxSettlementPanelView", UIBaseView);
UIAutoMaxSettlementPanelView.__index = UIAutoMaxSettlementPanelView

--@@ GF Auto Gen Block Begin
UIAutoMaxSettlementPanelView.mBtn_Continue = nil;
UIAutoMaxSettlementPanelView.mBtn_DetailInfo = nil;
UIAutoMaxSettlementPanelView.mBtn_RewardPanel = nil;
UIAutoMaxSettlementPanelView.mBtn_DetailPanel_Close = nil;
UIAutoMaxSettlementPanelView.mText_PlayerTotalDamage = nil;
UIAutoMaxSettlementPanelView.mText_EnemyTotalDamage = nil;
UIAutoMaxSettlementPanelView.mTrans_BattleResult_Win = nil;
UIAutoMaxSettlementPanelView.mTrans_BattleResult_Lose = nil;
UIAutoMaxSettlementPanelView.mTrans_BattleResult_End = nil;
UIAutoMaxSettlementPanelView.mTrans_PlayerTeam = nil;
UIAutoMaxSettlementPanelView.mTrans_EnemyTeam = nil;
UIAutoMaxSettlementPanelView.mTrans_RewardPanel = nil;
UIAutoMaxSettlementPanelView.mTrans_ItemLayout = nil;
UIAutoMaxSettlementPanelView.mTrans_DetailPanel = nil;
UIAutoMaxSettlementPanelView.mTrans_DetailPanel_TurnLayout = nil;

function UIAutoMaxSettlementPanelView:__InitCtrl()

	self.mBtn_Continue = self:GetButton("Btn_Continue");
	self.mBtn_DetailInfo = self:GetButton("Btn_DetailInfo");
	self.mBtn_RewardPanel = self:GetButton("Btn_Trans_RewardPanel");
	self.mBtn_DetailPanel_Close = self:GetButton("UI_Trans_DetailPanel/ContentPanel/Title/Btn_Close");
	self.mText_PlayerTotalDamage = self:GetText("PlayerTotalDamage/Text_PlayerTotalDamage");
	self.mText_EnemyTotalDamage = self:GetText("EnemyTotalDamage/Text_EnemyTotalDamage");
	self.mTrans_BattleResult_Win = self:GetRectTransform("UI_BattleResult/Trans_Win");
	self.mTrans_BattleResult_Lose = self:GetRectTransform("UI_BattleResult/Trans_Lose");
	self.mTrans_BattleResult_End = self:GetRectTransform("UI_BattleResult/Trans_End");
	self.mTrans_PlayerTeam = self:GetRectTransform("Trans_PlayerTeam");
	self.mTrans_EnemyTeam = self:GetRectTransform("Trans_EnemyTeam");
	self.mTrans_RewardPanel = self:GetRectTransform("Btn_Trans_RewardPanel");
	self.mTrans_ItemLayout = self:GetRectTransform("Btn_Trans_RewardPanel/ContentPanel/Trans_ItemLayout");
	self.mTrans_DetailPanel = self:GetRectTransform("UI_Trans_DetailPanel");
	self.mTrans_DetailPanel_TurnLayout = self:GetRectTransform("UI_Trans_DetailPanel/ContentPanel/Trans_TurnLayout");
end

--@@ GF Auto Gen Block End

function UIAutoMaxSettlementPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end