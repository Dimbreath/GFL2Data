require("UI.UIBaseCtrl")

UICostumeItem = class("UICostumeItem", UIBaseCtrl);
UICostumeItem.__index = UICostumeItem
--@@ GF Auto Gen Block Begin
UICostumeItem.mBtn_TemplateUnchosen = nil;
UICostumeItem.mImage_ExpressionIcon = nil;
UICostumeItem.mTrans_ExpressionChosen = nil;

UICostumeItem.mData = nil;

function UICostumeItem:__InitCtrl()

	self.mBtn_TemplateUnchosen = self:GetButton("Btn_TemplateUnchosen");
	self.mImage_ExpressionIcon = self:GetImage("Btn_TemplateUnchosen/Image_ExpressionIcon");
	self.mTrans_ExpressionChosen = self:GetRectTransform("Btn_TemplateUnchosen/Trans_ExpressionChosen");
end

--@@ GF Auto Gen Block End

function UICostumeItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UICostumeItem:InitData(data)
	self.mData = data;
end

function UICostumeItem:SetSelect(isSelect)
	setactive(self.mTrans_ExpressionChosen.gameObject, isSelect);
end