require("UI.UIBaseView")

UIAutoBattlePreSetView = class("UIAutoBattlePreSetView", UIBaseView);
UIAutoBattlePreSetView.__index = UIAutoBattlePreSetView

--@@ GF Auto Gen Block Begin
UIAutoBattlePreSetView.mBtn_close = nil;
UIAutoBattlePreSetView.mBtn_Cancel = nil;
UIAutoBattlePreSetView.mBtn_enterPre = nil;
UIAutoBattlePreSetView.mBtn_start = nil;
UIAutoBattlePreSetView.mText_Name = nil;
UIAutoBattlePreSetView.mText_TitelName = nil;
UIAutoBattlePreSetView.mText_hint = nil;
UIAutoBattlePreSetView.mText_Description = nil;

function UIAutoBattlePreSetView:__InitCtrl()

	self.mBtn_close = self:GetButton("Btn_close");
	self.mBtn_Cancel = self:GetButton("Btn_Cancel");
	self.mBtn_enterPre = self:GetButton("Btn_enterPre");
	self.mBtn_start = self:GetButton("Btn_start");
	self.mText_Name = self:GetText("BG/Text_Name");
	self.mText_TitelName = self:GetText("BG/TitlePanel/Text_TitelName");
	self.mText_hint = self:GetText("BG/Text_hint");
	self.mText_Description = self:GetText("Text_Description");
end

--@@ GF Auto Gen Block End

function UIAutoBattlePreSetView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end