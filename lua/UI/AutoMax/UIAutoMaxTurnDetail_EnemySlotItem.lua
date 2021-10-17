require("UI.UIBaseCtrl")

UIAutoMaxTurnDetail_EnemySlotItem = class("UIAutoMaxTurnDetail_EnemySlotItem", UIBaseCtrl);
UIAutoMaxTurnDetail_EnemySlotItem.__index = UIAutoMaxTurnDetail_EnemySlotItem
--@@ GF Auto Gen Block Begin
UIAutoMaxTurnDetail_EnemySlotItem.mImage_ColorSquare = nil;
UIAutoMaxTurnDetail_EnemySlotItem.mImage_FactionColor = nil;
UIAutoMaxTurnDetail_EnemySlotItem.mText_Content = nil;

function UIAutoMaxTurnDetail_EnemySlotItem:__InitCtrl()

	self.mImage_ColorSquare = self:GetImage("Image_ColorSquare");
	self.mImage_FactionColor = self:GetImage("Image_FactionColor");
	self.mText_Content = self:GetText("TextLayout/Text_Content");
end

--@@ GF Auto Gen Block End

function UIAutoMaxTurnDetail_EnemySlotItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end