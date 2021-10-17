require("UI.UIBaseCtrl")

BtnTabDisplayItem = class("BtnTabDisplayItem", UIBaseCtrl);
BtnTabDisplayItem.__index = BtnTabDisplayItem
--@@ GF Auto Gen Block Begin
BtnTabDisplayItem.mImage_OnlyOnce = nil;
BtnTabDisplayItem.mText_Name = nil;
BtnTabDisplayItem.mText_ENName = nil;
BtnTabDisplayItem.mTrans_OnlyOnce = nil;

function BtnTabDisplayItem:__InitCtrl()

	self.mImage_OnlyOnce = self:GetImage("Trans_Image_OnlyOnce");
	self.mText_Name = self:GetText("Text_Name");
	self.mText_ENName = self:GetText("Text_ENName");
	self.mTrans_OnlyOnce = self:GetRectTransform("Trans_Image_OnlyOnce");
end

--@@ GF Auto Gen Block End

function BtnTabDisplayItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end