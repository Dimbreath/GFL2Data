require("UI.UIBaseCtrl")

UIAutoMaxTurnDetail_PlayerSlotItem = class("UIAutoMaxTurnDetail_PlayerSlotItem", UIBaseCtrl);
UIAutoMaxTurnDetail_PlayerSlotItem.__index = UIAutoMaxTurnDetail_PlayerSlotItem
--@@ GF Auto Gen Block Begin
UIAutoMaxTurnDetail_PlayerSlotItem.mImage_ColorSquare = nil;
UIAutoMaxTurnDetail_PlayerSlotItem.mImage_FactionColor = nil;
UIAutoMaxTurnDetail_PlayerSlotItem.mText_Content = nil;

function UIAutoMaxTurnDetail_PlayerSlotItem:__InitCtrl()

	self.mImage_ColorSquare = self:GetImage("Image_ColorSquare");
	self.mImage_FactionColor = self:GetImage("Image_FactionColor");
	self.mText_Content = self:GetText("TextLayout/Text_Content");
end

--@@ GF Auto Gen Block End

function UIAutoMaxTurnDetail_PlayerSlotItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end