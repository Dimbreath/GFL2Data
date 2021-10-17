require("UI.UIBaseCtrl")

UnlockItem = class("UnlockItem", UIBaseCtrl);
UnlockItem.__index = UnlockItem
--@@ GF Auto Gen Block Begin
UnlockItem.mText_ItemDetail = nil;

function UnlockItem:__InitCtrl()

	self.mText_ItemDetail = self:GetText("Text_ItemDetail");
end

--@@ GF Auto Gen Block End

function UnlockItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end