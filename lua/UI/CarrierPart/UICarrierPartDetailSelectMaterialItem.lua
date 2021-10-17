require("UI.UIBaseCtrl")

UICarrierPartDetailSelectMaterialItem = class("UICarrierPartDetailSelectMaterialItem", UIBaseCtrl);
UICarrierPartDetailSelectMaterialItem.__index = UICarrierPartDetailSelectMaterialItem
--@@ GF Auto Gen Block Begin
UICarrierPartDetailSelectMaterialItem.mImage_Rank = nil;
UICarrierPartDetailSelectMaterialItem.mImage_PictureShadow = nil;
UICarrierPartDetailSelectMaterialItem.mImage_Picture = nil;
UICarrierPartDetailSelectMaterialItem.mText_Name = nil;
UICarrierPartDetailSelectMaterialItem.mText_Level = nil;
UICarrierPartDetailSelectMaterialItem.mText_Type = nil;
UICarrierPartDetailSelectMaterialItem.mTrans_Selected = nil;
UICarrierPartDetailSelectMaterialItem.mTrans_Prefect = nil;

function UICarrierPartDetailSelectMaterialItem:__InitCtrl()

	self.mImage_Rank = self:GetImage("Image_Rank");
	self.mImage_PictureShadow = self:GetImage("Image_PictureShadow");
	self.mImage_Picture = self:GetImage("Image_Picture");
	self.mText_Name = self:GetText("Text_Name");
	self.mText_Level = self:GetText("Text_Level");
	self.mText_Type = self:GetText("Text_Type");
	self.mTrans_Selected = self:GetRectTransform("Trans_Selected");
	self.mTrans_Prefect = self:GetRectTransform("Trans_Prefect");
end

--@@ GF Auto Gen Block End

function UICarrierPartDetailSelectMaterialItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end