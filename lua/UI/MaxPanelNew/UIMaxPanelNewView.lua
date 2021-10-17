require("UI.UIBaseView")

UIMaxPanelNewView = class("UIMaxPanelNewView", UIBaseView);
UIMaxPanelNewView.__index = UIMaxPanelNewView

--@@ GF Auto Gen Block Begin
UIMaxPanelNewView.mBtn_ButtonConfig = nil;
UIMaxPanelNewView.mBtn_ShootButton = nil;
UIMaxPanelNewView.mBtn_JoystickTriggerArea = nil;
UIMaxPanelNewView.mBtn_QTEButton = nil;
UIMaxPanelNewView.mBtn_ButtonRestart = nil;
UIMaxPanelNewView.mBtn_ButtonExit = nil;
UIMaxPanelNewView.mImage_HPSlider = nil;
UIMaxPanelNewView.mImage_HeatBarLeft_Fill = nil;
UIMaxPanelNewView.mImage_HeatBarRight_Fill = nil;
UIMaxPanelNewView.mImage_QTERingBack = nil;
UIMaxPanelNewView.mImage_QTERingFront = nil;
UIMaxPanelNewView.mText_HitsMark = nil;
UIMaxPanelNewView.mText_HitsMarkShadow = nil;
UIMaxPanelNewView.mText_HeatPrecent = nil;
UIMaxPanelNewView.mCanvasG_HitsMark = nil;
UIMaxPanelNewView.mCanvasG_ShootButton = nil;
UIMaxPanelNewView.mCanvasG_HitMark = nil;
UIMaxPanelNewView.mTrans_HPBar = nil;
UIMaxPanelNewView.mTrans_ShootingPanel = nil;
UIMaxPanelNewView.mTrans_Joystick = nil;
UIMaxPanelNewView.mTrans_ControlDirection = nil;
UIMaxPanelNewView.mTrans_ControlPoint = nil;
UIMaxPanelNewView.mTrans_AimingZone = nil;
UIMaxPanelNewView.mTrans_AimPointInner = nil;
UIMaxPanelNewView.mTrans_AimPointOuter = nil;
UIMaxPanelNewView.mTrans_HitMark = nil;
UIMaxPanelNewView.mTrans_DistanceMark = nil;
UIMaxPanelNewView.mTrans_OverHeatMark = nil;
UIMaxPanelNewView.mTrans_JoystickTriggerArea = nil;
UIMaxPanelNewView.mTrans_QTEPanel = nil;
UIMaxPanelNewView.mTrans_QTEZone = nil;
UIMaxPanelNewView.mTrans_TapLabel = nil;
UIMaxPanelNewView.mTrans_Result = nil;
UIMaxPanelNewView.mTrans_Perfect = nil;
UIMaxPanelNewView.mTrans_Good = nil;
UIMaxPanelNewView.mTrans_Bad = nil;
UIMaxPanelNewView.mTrans_SettlementPanel = nil;

function UIMaxPanelNewView:__InitCtrl()
	self.mBtn_ButtonConfig = self:GetButton("Btn_ButtonConfig");
	self.mBtn_ShootButton = self:GetButton("Trans_ShootingPanel/CanvasG_Btn_ShootButton");
	self.mBtn_JoystickTriggerArea = self:GetButton("Trans_ShootingPanel/Btn_Trans_JoystickTriggerArea");
	self.mBtn_QTEButton = self:GetButton("Trans_QTEPanel/Trans_QTEZone/Btn_QTEButton");
	self.mBtn_ButtonRestart = self:GetButton("Trans_SettlementPanel/SettlementBackground/BtnPanel/Btn_ButtonRestart");
	self.mBtn_ButtonExit = self:GetButton("Trans_SettlementPanel/SettlementBackground/BtnPanel/Btn_ButtonExit");
	self.mImage_HPSlider = self:GetImage("Trans_HPBar/Image_HPSlider");
	self.mImage_HeatBarLeft_Fill = self:GetImage("Trans_ShootingPanel/Trans_AimingZone/UI_HeatBarLeft/Image_Fill");
	self.mImage_HeatBarRight_Fill = self:GetImage("Trans_ShootingPanel/Trans_AimingZone/UI_HeatBarRight/Image_Fill");
	self.mImage_QTERingBack = self:GetImage("Trans_QTEPanel/Trans_QTEZone/QTERings/Image_QTERingBack");
	self.mImage_QTERingFront = self:GetImage("Trans_QTEPanel/Trans_QTEZone/QTERings/Image_QTERingFront");
	self.mText_HitsMark = self:GetText("Trans_ShootingPanel/CanvasG_Text_HitsMark");
	self.mText_HitsMarkShadow = self:GetText("Trans_ShootingPanel/CanvasG_Text_HitsMark/Text_HitsMarkShadow");
	self.mText_HeatPrecent = self:GetText("Trans_ShootingPanel/Trans_AimingZone/Text_HeatPrecent");
	self.mCanvasG_HitsMark = self:GetCanvasGroup("Trans_ShootingPanel/CanvasG_Text_HitsMark");
	self.mCanvasG_ShootButton = self:GetCanvasGroup("Trans_ShootingPanel/CanvasG_Btn_ShootButton");
	self.mCanvasG_HitMark = self:GetCanvasGroup("Trans_ShootingPanel/Trans_AimingZone/CanvasG_Trans_HitMark");
	self.mTrans_HPBar = self:GetRectTransform("Trans_HPBar");
	self.mTrans_ShootingPanel = self:GetRectTransform("Trans_ShootingPanel");
	self.mTrans_Joystick = self:GetRectTransform("Trans_ShootingPanel/Trans_Joystick");
	self.mTrans_ControlDirection = self:GetRectTransform("Trans_ShootingPanel/Trans_Joystick/Trans_ControlDirection");
	self.mTrans_ControlPoint = self:GetRectTransform("Trans_ShootingPanel/Trans_Joystick/Trans_ControlPoint");
	self.mTrans_AimingZone = self:GetRectTransform("Trans_ShootingPanel/Trans_AimingZone");
	self.mTrans_AimPointInner = self:GetRectTransform("Trans_ShootingPanel/Trans_AimingZone/Trans_AimPointInner");
	self.mTrans_AimPointOuter = self:GetRectTransform("Trans_ShootingPanel/Trans_AimingZone/Trans_AimPointOuter");
	self.mTrans_HitMark = self:GetRectTransform("Trans_ShootingPanel/Trans_AimingZone/CanvasG_Trans_HitMark");
	self.mTrans_DistanceMark = self:GetRectTransform("Trans_ShootingPanel/Trans_AimingZone/Trans_DistanceMark");
	self.mTrans_OverHeatMark = self:GetRectTransform("Trans_ShootingPanel/Trans_AimingZone/Trans_OverHeatMark");
	self.mTrans_JoystickTriggerArea = self:GetRectTransform("Trans_ShootingPanel/Btn_Trans_JoystickTriggerArea");
	self.mTrans_QTEPanel = self:GetRectTransform("Trans_QTEPanel");
	self.mTrans_QTEZone = self:GetRectTransform("Trans_QTEPanel/Trans_QTEZone");
	self.mTrans_TapLabel = self:GetRectTransform("Trans_QTEPanel/Trans_QTEZone/Btn_QTEButton/Trans_TapLabel");
	self.mTrans_Result = self:GetRectTransform("Trans_QTEPanel/Trans_Result");
	self.mTrans_Perfect = self:GetRectTransform("Trans_QTEPanel/Trans_Result/Trans_Result_Perfect");
	self.mTrans_Good = self:GetRectTransform("Trans_QTEPanel/Trans_Result/Trans_Result_Good");
	self.mTrans_Bad = self:GetRectTransform("Trans_QTEPanel/Trans_Result/Trans_Result_Bad");
	self.mTrans_SettlementPanel = self:GetRectTransform("Trans_SettlementPanel");
end

--@@ GF Auto Gen Block End

function UIMaxPanelNewView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end