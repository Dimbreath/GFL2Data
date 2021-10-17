require("UI.UIBaseCtrl")

UIDormPopItem = class("UIDormPopItem", UIBaseCtrl);
UIDormPopItem.__index = UIDormPopItem
--@@ GF Auto Gen Block Begin
UIDormPopItem.mText_content = nil;
UIDormPopItem.mTrans_bg = nil;

function UIDormPopItem:__InitCtrl()

	self.mText_content = self:GetText("Trans_bg/Text_content");
	self.mTrans_bg = self:GetRectTransform("Trans_bg");
end

--@@ GF Auto Gen Block End

function UIDormPopItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end