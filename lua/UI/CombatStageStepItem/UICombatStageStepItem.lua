require("UI.UIBaseCtrl")

UICombatStageStepItem = class("UICombatStageStepItem", UIBaseCtrl);
UICombatStageStepItem.__index = UICombatStageStepItem
--@@ GF Auto Gen Block Begin
UICombatStageStepItem.mText_StageStepInformation = nil;

function UICombatStageStepItem:__InitCtrl()

	self.mText_StageStepInformation = self:GetText("Text_StageStepInformation");
end

--@@ GF Auto Gen Block End

function UICombatStageStepItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end