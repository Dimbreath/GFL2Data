require("UI.UIBaseCtrl")

PreparationUIRoot = class("PreparationUIRoot", UIBaseCtrl);
PreparationUIRoot.__index = PreparationUIRoot
--@@ GF Auto Gen Block Begin
PreparationUIRoot.mImage_Head = nil;
PreparationUIRoot.mImage_GunTypeBGImage = nil;
PreparationUIRoot.mImage_GunType = nil;

function PreparationUIRoot:__InitCtrl()

	self.mImage_Head = self:GetImage("Mask/Image_Head");
	self.mImage_GunTypeBGImage = self:GetImage("GunTypeBG/Image_GunTypeBGImage");
	self.mImage_GunType = self:GetImage("GunTypeBG/Image_GunType");
end

--@@ GF Auto Gen Block End

function PreparationUIRoot:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end