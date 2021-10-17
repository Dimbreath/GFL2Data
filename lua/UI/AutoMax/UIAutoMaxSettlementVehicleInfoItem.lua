require("UI.UIBaseCtrl")

UIAutoMaxSettlementVehicleInfoItem = class("UIAutoMaxSettlementVehicleInfoItem", UIBaseCtrl);
UIAutoMaxSettlementVehicleInfoItem.__index = UIAutoMaxSettlementVehicleInfoItem
--@@ GF Auto Gen Block Begin
UIAutoMaxSettlementVehicleInfoItem.mImage_Icon = nil;
UIAutoMaxSettlementVehicleInfoItem.mImage_HPBar_Damage = nil;
UIAutoMaxSettlementVehicleInfoItem.mImage_HPBar_Origin = nil;
UIAutoMaxSettlementVehicleInfoItem.mText_Name = nil;
UIAutoMaxSettlementVehicleInfoItem.mText_HPText_Origin = nil;
UIAutoMaxSettlementVehicleInfoItem.mText_HPText_Damage = nil;
UIAutoMaxSettlementVehicleInfoItem.mText_DamagePercent = nil;
UIAutoMaxSettlementVehicleInfoItem.mTrans_HighlyDamagedMark = nil;

function UIAutoMaxSettlementVehicleInfoItem:__InitCtrl()

	self.mImage_Icon = self:GetImage("Avatar/Image_Icon");
	self.mImage_HPBar_Damage = self:GetImage("UI_HPBar/Image_Damage");
	self.mImage_HPBar_Origin = self:GetImage("UI_HPBar/Image_Origin");
	self.mText_Name = self:GetText("Text_Name");
	self.mText_HPText_Origin = self:GetText("UI_HPText/Text_Origin");
	self.mText_HPText_Damage = self:GetText("UI_HPText/Text_Origin/Text_Damage");
	self.mText_DamagePercent = self:GetText("DamagePercent/Text_DamagePercent");
	self.mTrans_HighlyDamagedMark = self:GetRectTransform("Text_Name/Trans_HighlyDamagedMark");
end

--@@ GF Auto Gen Block End

function UIAutoMaxSettlementVehicleInfoItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end