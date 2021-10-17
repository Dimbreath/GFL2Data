require("UI.UIBaseCtrl")

Nameplate = class("Nameplate", UIBaseCtrl);
Nameplate.__index = Nameplate
--@@ GF Auto Gen Block Begin
Nameplate.mImage_LightBGImage = nil;
Nameplate.mImage_BaseDamageSlider = nil;
Nameplate.mImage_HealSlider = nil;
Nameplate.mImage_TopLightBGImage = nil;
Nameplate.mImage_HurtSlider = nil;
Nameplate.mImage_HPSlider = nil;
Nameplate.mTrans_BaseDamageSlider = nil;
Nameplate.mTrans_HealSlider = nil;
Nameplate.mTrans_HurtSlider = nil;
Nameplate.mTrans_HPSlider = nil;

function Nameplate:__InitCtrl()

	self.mImage_LightBGImage = self:GetImage("InfoPlate/HP/Image_LightBGImage");
	self.mImage_BaseDamageSlider = self:GetImage("InfoPlate/HP/Trans_Image_BaseDamageSlider");
	self.mImage_HealSlider = self:GetImage("InfoPlate/HP/Trans_Image_HealSlider");
	self.mImage_TopLightBGImage = self:GetImage("InfoPlate/HP/Image_TopLightBGImage");
	self.mImage_HurtSlider = self:GetImage("InfoPlate/HP/Trans_Image_HurtSlider");
	self.mImage_HPSlider = self:GetImage("InfoPlate/HP/Trans_Image_HPSlider");
	self.mTrans_BaseDamageSlider = self:GetRectTransform("InfoPlate/HP/Trans_Image_BaseDamageSlider");
	self.mTrans_HealSlider = self:GetRectTransform("InfoPlate/HP/Trans_Image_HealSlider");
	self.mTrans_HurtSlider = self:GetRectTransform("InfoPlate/HP/Trans_Image_HurtSlider");
	self.mTrans_HPSlider = self:GetRectTransform("InfoPlate/HP/Trans_Image_HPSlider");
end

--@@ GF Auto Gen Block End

function Nameplate:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end