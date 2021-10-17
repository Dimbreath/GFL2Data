require("UI.UIBaseCtrl")

UIStoreAdvertisementItem = class("UIStoreAdvertisementItem", UIBaseCtrl);
UIStoreAdvertisementItem.__index = UIStoreAdvertisementItem
--@@ GF Auto Gen Block Begin
UIStoreAdvertisementItem.mBtn_Advertisement = nil;
UIStoreAdvertisementItem.mImage_Advertisement = nil;

function UIStoreAdvertisementItem:__InitCtrl()

	self.mBtn_Advertisement = self:GetButton("Btn_Image_Advertisement");
	self.mImage_Advertisement = self:GetImage("Btn_Image_Advertisement");
end


--@@ GF Auto Gen Block End

function UIStoreAdvertisementItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIStoreAdvertisementItem:InitData(data)
	self.mData = data;
end