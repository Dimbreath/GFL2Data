require("UI.UIBaseView")

UIAutoMaxConfirmPanelView = class("UIAutoMaxConfirmPanelView", UIBaseView);
UIAutoMaxConfirmPanelView.__index = UIAutoMaxConfirmPanelView

--@@ GF Auto Gen Block Begin
UIAutoMaxConfirmPanelView.mBtn_Comfirm = nil;
UIAutoMaxConfirmPanelView.mBtn_AnimSkipSwitch = nil;
UIAutoMaxConfirmPanelView.mText_Diffculty = nil;
UIAutoMaxConfirmPanelView.mTrans_PlayerTeam = nil;
UIAutoMaxConfirmPanelView.mTrans_EnemyTeam = nil;
UIAutoMaxConfirmPanelView.mTrans_AnimSkipSwitch_Off = nil;
UIAutoMaxConfirmPanelView.mTrans_AnimSkipSwitch_On = nil;

function UIAutoMaxConfirmPanelView:__InitCtrl()

	self.mBtn_Comfirm = self:GetButton("Btn_Comfirm");
	self.mBtn_AnimSkipSwitch = self:GetButton("SkipOptions/UI_Btn_AnimSkipSwitch");
	self.mText_Diffculty = self:GetText("Text_Diffculty");
	self.mTrans_PlayerTeam = self:GetRectTransform("Trans_PlayerTeam");
	self.mTrans_EnemyTeam = self:GetRectTransform("Trans_EnemyTeam");
	self.mTrans_AnimSkipSwitch_Off = self:GetRectTransform("SkipOptions/UI_Btn_AnimSkipSwitch/Trans_Off");
	self.mTrans_AnimSkipSwitch_On = self:GetRectTransform("SkipOptions/UI_Btn_AnimSkipSwitch/Trans_On");
end

--@@ GF Auto Gen Block End

function UIAutoMaxConfirmPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end