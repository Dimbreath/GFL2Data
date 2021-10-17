require("UI.UIBaseCtrl")

UICarrierPartDetailPropertyItem = class("UICarrierPartDetailPropertyItem", UIBaseCtrl);
UICarrierPartDetailPropertyItem.__index = UICarrierPartDetailPropertyItem
--@@ GF Auto Gen Block Begin
UICarrierPartDetailPropertyItem.mText_PropertyName = nil;
UICarrierPartDetailPropertyItem.mText_PropertyValue = nil;

function UICarrierPartDetailPropertyItem:__InitCtrl()

	self.mText_PropertyName = self:GetText("Text_PropertyName");
	self.mText_PropertyValue = self:GetText("Text_PropertyValue");
end

--@@ GF Auto Gen Block End

function UICarrierPartDetailPropertyItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end