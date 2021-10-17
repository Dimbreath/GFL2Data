require("UI.UIBaseCtrl")

RaidAndAutoBattleBtnItem = class("RaidAndAutoBattleBtnItem", UIBaseCtrl);
RaidAndAutoBattleBtnItem.__index = RaidAndAutoBattleBtnItem
--@@ GF Auto Gen Block Begin
RaidAndAutoBattleBtnItem.mBtn_RaidButton = nil;
RaidAndAutoBattleBtnItem.mBtn_AutoBattleBtn = nil;
RaidAndAutoBattleBtnItem.mTrans_RaidButton_locked = nil;
RaidAndAutoBattleBtnItem.mTrans_AutoBattleBtn_locked = nil;

function RaidAndAutoBattleBtnItem:__InitCtrl()

	self.mBtn_RaidButton = self:GetButton("UI_Btn_RaidButton");
	self.mBtn_AutoBattleBtn = self:GetButton("UI_Btn_AutoBattleBtn");
	self.mTrans_RaidButton_locked = self:GetRectTransform("UI_Btn_RaidButton/Trans_locked");
	self.mTrans_AutoBattleBtn_locked = self:GetRectTransform("UI_Btn_AutoBattleBtn/Trans_locked");
end

--@@ GF Auto Gen Block End

function RaidAndAutoBattleBtnItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end