require("UI.UIBaseCtrl")

UICarrierPartDetailMaterialItem = class("UICarrierPartDetailMaterialItem", UIBaseCtrl);
UICarrierPartDetailMaterialItem.__index = UICarrierPartDetailMaterialItem
--@@ GF Auto Gen Block Begin
UICarrierPartDetailMaterialItem.mImage_Rank = nil;
UICarrierPartDetailMaterialItem.mText_PartName = nil;
UICarrierPartDetailMaterialItem.mText_Level = nil;

function UICarrierPartDetailMaterialItem:__InitCtrl()

	self.mImage_Rank = self:GetImage("Image_Rank");
	self.mText_PartName = self:GetText("Text_PartName");
	self.mText_Level = self:GetText("Text_Level");
end

--@@ GF Auto Gen Block End

function UICarrierPartDetailMaterialItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end