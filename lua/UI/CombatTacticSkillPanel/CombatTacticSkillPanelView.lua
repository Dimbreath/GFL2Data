require("UI.UIBaseView")

CombatTacticSkillPanelView = class("CombatTacticSkillPanelView", UIBaseView);
CombatTacticSkillPanelView.__index = CombatTacticSkillPanelView

--@@ GF Auto Gen Block Begin
CombatTacticSkillPanelView.mBtn_CancelBtn = nil;
CombatTacticSkillPanelView.mBtn_DefineBtn = nil;
CombatTacticSkillPanelView.mText_BulletNumber = nil;

function CombatTacticSkillPanelView:__InitCtrl()

	self.mBtn_CancelBtn = self:GetButton("AirGunShip/Button/Btn_CancelBtn");
	self.mBtn_DefineBtn = self:GetButton("AirGunShip/Button/Btn_DefineBtn");
	self.mText_BulletNumber = self:GetText("AirGunShip/Text_BulletNumber");
end

--@@ GF Auto Gen Block End

function CombatTacticSkillPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end