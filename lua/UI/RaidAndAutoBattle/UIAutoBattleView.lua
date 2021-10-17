require("UI.UIBaseView")

UIAutoBattleView = class("UIAutoBattleView", UIBaseView);
UIAutoBattleView.__index = UIAutoBattleView

--@@ GF Auto Gen Block Begin
UIAutoBattleView.mBtn_BasePanel_battleReport = nil;
UIAutoBattleView.mBtn_BasePanel_stop = nil;
UIAutoBattleView.mBtn_BasePanel_setting = nil;
UIAutoBattleView.mBtn_return = nil;
UIAutoBattleView.mBtn_ButtonPlusOne = nil;
UIAutoBattleView.mBtn_ButtonPlusTen = nil;
UIAutoBattleView.mBtn_ButtonMinusOne = nil;
UIAutoBattleView.mBtn_ButtonMinusTen = nil;
UIAutoBattleView.mImage_Dropdown = nil;
UIAutoBattleView.mText_BasePanel_battleResult = nil;
UIAutoBattleView.mText_TimesNum = nil;
UIAutoBattleView.mToggle_failStopToggle = nil;
UIAutoBattleView.mToggle_maxTimeToggle = nil;
UIAutoBattleView.mTrans_setting = nil;

function UIAutoBattleView:__InitCtrl()

	self.mBtn_BasePanel_battleReport = self:GetButton("UI_BasePanel/Btn_battleReport");
	self.mBtn_BasePanel_stop = self:GetButton("UI_BasePanel/Btn_stop");
	self.mBtn_BasePanel_setting = self:GetButton("UI_BasePanel/Btn_setting");
	self.mBtn_return = self:GetButton("Trans_setting/Btn_return");
	self.mBtn_ButtonPlusOne = self:GetButton("Trans_setting/maxTime/raidTime/Btn_ButtonPlusOne");
	self.mBtn_ButtonPlusTen = self:GetButton("Trans_setting/maxTime/raidTime/Btn_ButtonPlusTen");
	self.mBtn_ButtonMinusOne = self:GetButton("Trans_setting/maxTime/raidTime/Btn_ButtonMinusOne");
	self.mBtn_ButtonMinusTen = self:GetButton("Trans_setting/maxTime/raidTime/Btn_ButtonMinusTen");
	self.mImage_Dropdown = self:GetImage("Trans_setting/AutoStamina/Image_Dropdown");
	self.mText_BasePanel_battleResult = self:GetText("UI_BasePanel/Text_battleResult");
	self.mText_TimesNum = self:GetText("Trans_setting/maxTime/raidTime/TimesNum/Text_TimesNum");
	self.mToggle_failStopToggle = self:GetToggle("Trans_setting/failStop/Toggle_failStopToggle");
	self.mToggle_maxTimeToggle = self:GetToggle("Trans_setting/maxTime/Toggle_maxTimeToggle");
	self.mTrans_setting = self:GetRectTransform("Trans_setting");
end

--@@ GF Auto Gen Block End

UIAutoBattleView.mDropDown_AutoStamina = nil;
UIAutoBattleView.mBtn_ButtonMask = nil;

function UIAutoBattleView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mDropDown_AutoStamina = self:GetDropDown("Trans_setting/AutoStamina/Image_Dropdown");
	self.mBtn_ButtonMask = self:GetButton("Btn_ButtonMask");

	self.UpdateTimesNum();
end

function UIAutoBattleView.UpdateTimesNum( )
	self = UIAutoBattleView;
	self.mText_TimesNum.text = AFKBattleManager.MaxTimes;
	self.mText_BasePanel_battleResult.text = string.format( "胜利次数:%d  失败次数:%d",AFKBattleManager.WinTimes,AFKBattleManager.FailedTimes );
end