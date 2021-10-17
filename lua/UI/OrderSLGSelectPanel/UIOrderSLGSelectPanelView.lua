require("UI.UIBaseView")

UIOrderSLGSelectPanelView = class("UIOrderSLGSelectPanelView", UIBaseView);
UIOrderSLGSelectPanelView.__index = UIOrderSLGSelectPanelView

--@@ GF Auto Gen Block Begin
UIOrderSLGSelectPanelView.mBtn_OrderIgnoreMoveLimit = nil;
UIOrderSLGSelectPanelView.mBtn_OrderIgnoreSkillCooldown = nil;
UIOrderSLGSelectPanelView.mBtn_OrderAllyHP = nil;
UIOrderSLGSelectPanelView.mBtn_OrderIgnoreEnemyHP = nil;
UIOrderSLGSelectPanelView.mBtn_OrderIgnoreEnemyTurn = nil;
UIOrderSLGSelectPanelView.mBtn_OrderClearEnemy = nil;
UIOrderSLGSelectPanelView.mBtn_OrderClearAlly = nil;
UIOrderSLGSelectPanelView.mBtn_OrderAddEnergy = nil;
UIOrderSLGSelectPanelView.mBtn_OrderDirectWin = nil;
UIOrderSLGSelectPanelView.mBtn_OrderDirectLose = nil;
UIOrderSLGSelectPanelView.mBtn_OrderDirectOver = nil;
UIOrderSLGSelectPanelView.mBtn_Close = nil;

function UIOrderSLGSelectPanelView:__InitCtrl()

	self.mBtn_OrderIgnoreMoveLimit = self:GetButton("Canvas (Environment)//UI_Btn_OrderIgnoreMoveLimit");
	self.mBtn_OrderIgnoreSkillCooldown = self:GetButton("Canvas (Environment)//UI_Btn_OrderIgnoreSkillCooldown");
	self.mBtn_OrderAllyHP = self:GetButton("Canvas (Environment)//UI_Btn_OrderAllyHP");
	self.mBtn_OrderIgnoreEnemyHP = self:GetButton("Canvas (Environment)//UI_Btn_OrderIgnoreEnemyHP");
	self.mBtn_OrderIgnoreEnemyTurn = self:GetButton("Canvas (Environment)//UI_Btn_OrderIgnoreEnemyTurn");
	self.mBtn_OrderClearEnemy = self:GetButton("Canvas (Environment)//UI_Btn_OrderClearEnemy");
	self.mBtn_OrderClearAlly = self:GetButton("Canvas (Environment)//UI_Btn_OrderClearAlly");
	self.mBtn_OrderAddEnergy = self:GetButton("Canvas (Environment)//UI_Btn_OrderAddEnergy");
	self.mBtn_OrderDirectWin = self:GetButton("Canvas (Environment)//UI_Btn_OrderDirectWin");
	self.mBtn_OrderDirectLose = self:GetButton("Canvas (Environment)//UI_Btn_OrderDirectLose");
	self.mBtn_OrderDirectOver = self:GetButton("Canvas (Environment)//UI_Btn_OrderDirectOver");
	self.mBtn_Close = self:GetButton("Canvas (Environment)//UI_Btn_Close");
end

--@@ GF Auto Gen Block End

function UIOrderSLGSelectPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end