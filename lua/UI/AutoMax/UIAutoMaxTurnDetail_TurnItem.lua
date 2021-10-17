require("UI.UIBaseCtrl")

UIAutoMaxTurnDetail_TurnItem = class("UIAutoMaxTurnDetail_TurnItem", UIBaseCtrl);
UIAutoMaxTurnDetail_TurnItem.__index = UIAutoMaxTurnDetail_TurnItem
--@@ GF Auto Gen Block Begin
UIAutoMaxTurnDetail_TurnItem.mText_TurnNum = nil;
UIAutoMaxTurnDetail_TurnItem.mTrans_SlotLayout = nil;

function UIAutoMaxTurnDetail_TurnItem:__InitCtrl()

	self.mText_TurnNum = self:GetText("TurnMark/Text_TurnNum");
	self.mTrans_SlotLayout = self:GetRectTransform("Trans_SlotLayout");
end

--@@ GF Auto Gen Block End

function UIAutoMaxTurnDetail_TurnItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end