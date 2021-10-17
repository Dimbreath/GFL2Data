require("UI.UIBaseCtrl")

UIDormSelectItem = class("UIDormSelectItem", UIBaseCtrl);
UIDormSelectItem.__index = UIDormSelectItem
--@@ GF Auto Gen Block Begin
UIDormSelectItem.mText_DormName = nil;

function UIDormSelectItem:__InitCtrl()

	self.mText_DormName = self:GetText("Text_DormName");
end

--@@ GF Auto Gen Block End

function UIDormSelectItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end