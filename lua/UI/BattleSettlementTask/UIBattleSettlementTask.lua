require("UI.UIBaseCtrl")

UIBattleSettlementTask = class("UIBattleSettlementTask", UIBaseCtrl);
UIBattleSettlementTask.__index = UIBattleSettlementTask
--@@ GF Auto Gen Block Begin
UIBattleSettlementTask.mText_InfText = nil;

function UIBattleSettlementTask:__InitCtrl()

	self.mText_InfText = self:GetText("TaskText/Text_InfText");
end

--@@ GF Auto Gen Block End

function UIBattleSettlementTask:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end