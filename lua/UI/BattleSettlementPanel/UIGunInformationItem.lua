require("UI.UIBaseCtrl")

UIGunInformationItem = class("UIGunInformationItem", UIBaseCtrl);
UIGunInformationItem.__index = UIGunInformationItem
--@@ GF Auto Gen Block Begin
UIGunInformationItem.mImage_GunIconImage = nil;
UIGunInformationItem.mImage_EXPImage = nil;
UIGunInformationItem.mImage_EXPFill = nil;
UIGunInformationItem.mText_GunNameText = nil;
UIGunInformationItem.mText_LVText = nil;
UIGunInformationItem.mText_EXPNumberText = nil;

function UIGunInformationItem:__InitCtrl()

	self.mImage_GunIconImage = self:GetImage("GunIconImageMask/Image_GunIconImage");
	self.mImage_EXPImage = self:GetImage("EXPText/EXPSlider/Image_EXPImage");
	self.mImage_EXPFill = self:GetImage("EXPText/EXPSlider/Image_EXPFill");
	self.mText_GunNameText = self:GetText("Text_GunNameText");
	self.mText_LVText = self:GetText("LVImagebg/Text_LVText");
	self.mText_EXPNumberText = self:GetText("EXPText/Text_EXPNumberText");
end

--@@ GF Auto Gen Block End

function UIGunInformationItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end