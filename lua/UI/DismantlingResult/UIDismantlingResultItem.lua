require("UI.UIBaseCtrl")

UIDismantlingResultItem = class("UIDismantlingResultItem", UIBaseCtrl);
UIDismantlingResultItem.__index = UIDismantlingResultItem
--@@ GF Auto Gen Block Begin
UIDismantlingResultItem.mImage_Image = nil;
UIDismantlingResultItem.mText_Text = nil;
UIDismantlingResultItem.mText_Cost = nil;

function UIDismantlingResultItem:__InitCtrl()

	self.mImage_Image = self:GetImage("Image_Image");
	self.mText_Text = self:GetText("Text_Text");
	self.mText_Cost = self:GetText("Text_Cost");
end

--@@ GF Auto Gen Block End

UIDismantlingResultItem.mPrizeData = nil;

function UIDismantlingResultItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIDismantlingResultItem:SetData(itemId, num)
	print("")
	self.mText_Text.text = TableData.GetItemData(itemId).name;
	self.mText_Cost.text = tostring(num);
end