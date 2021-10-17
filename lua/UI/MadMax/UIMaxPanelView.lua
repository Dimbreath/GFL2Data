--region *.lua

require("UI.UIBaseView")

UIMaxPanelView = class("UIMaxPanelView",UIBaseView);
UIMaxPanelView.__index = UIMaxPanelView;

-----------------------[�ؼ�]----------------------
UIMaxPanelView.mPanel_ShootingPanel = nil;
UIMaxPanelView.mPanel_QTEPanel = nil;

UIMaxPanelView.mObj_Win = nil;
UIMaxPanelView.mObj_Lose = nil;

UIMaxPanelView.mImage_HPSlider = nil;
UIMaxPanelView.mButton_ReturnButton = nil;

--shootingpanel
UIMaxPanelView.mImage_HeatSlider = nil;
UIMaxPanelView.mRectTrans_AimUp = nil;
UIMaxPanelView.mRectTrans_AimLeft = nil;
UIMaxPanelView.mRectTrans_AimRight = nil;
UIMaxPanelView.mRectTrans_AimDown = nil;
UIMaxPanelView.mObj_AimHitMark = nil;
UIMaxPanelView.mButton_ShootButton = nil;

--QTEpanel
UIMaxPanelView.mButton_QTEButton = nil;
UIMaxPanelView.mObj_ResultGood = nil;
UIMaxPanelView.mObj_ResultOK = nil;
UIMaxPanelView.mObj_ResultMiss = nil;
UIMaxPanelView.mText_ResultGood = nil;
UIMaxPanelView.mText_ResultOK = nil;
UIMaxPanelView.mText_ResultMiss = nil;
UIMaxPanelView.mPanel_QTERings = nil;
UIMaxPanelView.mImage_QTERingBack = nil;
UIMaxPanelView.mImage_QTERingFront = nil;



--����
function UIMaxPanelView:ctor()
	UIMaxPanelView.super.ctor(self);
end

function UIMaxPanelView:InitCtrl(root)
	self:SetRoot(root);
	self.mPanel_QTEPanel = self:FindChild("UIQTEPanel");
	self.mPanel_ShootingPanel = self:FindChild("UIMaxShootingPanel");
	
	self.mButton_ReturnButton = self:GetButton("Return");
	
	self.mObj_Win = self:FindChild("Win");
	self.mObj_Lose = self:FindChild("Lose");
	
	self.mImage_HPSlider = self:GetImage("HPSlider");

	
	self.mImage_HeatSlider = self:GetImage("UIMaxShootingPanel/HeatSlider/FillArea/Fill");
	self.mRectTrans_AimUp = self:GetImage("UIMaxShootingPanel/AimPoint/Up");
	self.mRectTrans_AimDown = self:GetImage("UIMaxShootingPanel/AimPoint/Down");
	self.mRectTrans_AimLeft = self:GetImage("UIMaxShootingPanel/AimPoint/Left");
	self.mRectTrans_AimRight = self:GetImage("UIMaxShootingPanel/AimPoint/Right");
	self.mObj_AimHitMark = self:FindChild("UIMaxShootingPanel/HitMark");
	self.mButton_ShootButton = self:GetButton("UIMaxShootingPanel/ShootButton");
	
	self.mButton_QTEButton = self:GetButton("UIQTEPanel/QTEButton");
	self.mObj_ResultGood = self:FindChild("UIQTEPanel/QTEResultGood");
	self.mObj_ResultOK = self:FindChild("UIQTEPanel/QTEResultOK");
	self.mObj_ResultMiss = self:FindChild("UIQTEPanel/QTEResultMiss");
	self.mText_ResultGood = self:GetText("UIQTEPanel/QTEResultGood/Text");
	self.mText_ResultOK = self:GetText("UIQTEPanel/QTEResultOK/Text");
	self.mText_ResultMiss = self:GetText("UIQTEPanel/QTEResultMiss/Text");
	self.mPanel_QTERings = self:FindChild("UIQTEPanel/QTERings");
	self.mImage_QTERingBack = self:GetImage("UIQTEPanel/QTERings/QTERingBack")
	self.mImage_QTERingFront = self:GetImage("UIQTEPanel/QTERings/QTERingFront")
	
	
end



--endregion