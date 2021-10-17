require("UI.UIBaseCtrl")

UIExpressionItem = class("UIExpressionItem", UIBaseCtrl);
UIExpressionItem.__index = UIExpressionItem
--@@ GF Auto Gen Block Begin
UIExpressionItem.mBtn_TemplateUnchosen = nil;
UIExpressionItem.mImage_ExpressionIcon = nil;
UIExpressionItem.mTrans_ExpressionChosen = nil;

function UIExpressionItem:__InitCtrl()

	self.mBtn_TemplateUnchosen = self:GetButton("Btn_TemplateUnchosen");
	self.mImage_ExpressionIcon = self:GetImage("Btn_TemplateUnchosen/Image_ExpressionIcon");
	self.mTrans_ExpressionChosen = self:GetRectTransform("Btn_TemplateUnchosen/Trans_ExpressionChosen");
end

--@@ GF Auto Gen Block End

function UIExpressionItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end