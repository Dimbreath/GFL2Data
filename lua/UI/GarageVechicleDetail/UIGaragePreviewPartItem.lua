require("UI.UIBaseCtrl")

UIGaragePreviewPartItem = class("UIGaragePreviewPartItem", UIBaseCtrl);
UIGaragePreviewPartItem.__index = UIGaragePreviewPartItem
--@@ GF Auto Gen Block Begin
UIGaragePreviewPartItem.mImage_TypeIcon = nil;

function UIGaragePreviewPartItem:__InitCtrl()

	self.mImage_TypeIcon = self:GetImage("Image_TypeIcon");
end

--@@ GF Auto Gen Block End

function UIGaragePreviewPartItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIGaragePreviewPartItem:SetData(partID)
	setactive(self.mUIRoot,true)
	local typeID = CarrierNetCmdHandler:GetCarrierPartStcData(partID).define_type
	local iconName = TableData.GetPartDefineTypeData(typeID).icon
	self.mImage_TypeIcon.sprite =IconUtils.GetIconSprite(CS.GF2Icon.CarrierPartType,iconName)
end

function UIGaragePreviewPartItem:Reset()
	setactive(self.mUIRoot,false)
end