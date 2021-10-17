require("UI.UIBaseCtrl")

UIPrefixTypeItem = class("UIPrefixTypeItem", UIBaseCtrl);
UIPrefixTypeItem.__index = UIPrefixTypeItem
--@@ GF Auto Gen Block Begin
UIPrefixTypeItem.mText_PrefixName = nil;

function UIPrefixTypeItem:__InitCtrl()

	self.mText_PrefixName = self:GetText("Text_PrefixName");
end

--@@ GF Auto Gen Block End

function UIPrefixTypeItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPrefixTypeItem:SetData(data)
	setactive(self.mUIRoot,true)
	self.mText_PrefixName.text = data.name
end

function UIPrefixTypeItem:Reset()
	setactive(self.mUIRoot,false)
end