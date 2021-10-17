require("UI.UIBaseCtrl")

UIAutoMaxSettlement_PlayerVehicleSlotItem = class("UIAutoMaxSettlement_PlayerVehicleSlotItem", UIBaseCtrl);
UIAutoMaxSettlement_PlayerVehicleSlotItem.__index = UIAutoMaxSettlement_PlayerVehicleSlotItem
--@@ GF Auto Gen Block Begin
UIAutoMaxSettlement_PlayerVehicleSlotItem.mImage_CarrierIcon = nil;
UIAutoMaxSettlement_PlayerVehicleSlotItem.mImage_OriginHPBar = nil;
UIAutoMaxSettlement_PlayerVehicleSlotItem.mImage_HPbar = nil;
UIAutoMaxSettlement_PlayerVehicleSlotItem.mImage_Rank = nil;
UIAutoMaxSettlement_PlayerVehicleSlotItem.mText_Index = nil;
UIAutoMaxSettlement_PlayerVehicleSlotItem.mText_DamagePercent = nil;
UIAutoMaxSettlement_PlayerVehicleSlotItem.mTrans_BreakMask = nil;

function UIAutoMaxSettlement_PlayerVehicleSlotItem:__InitCtrl()

	self.mImage_CarrierIcon = self:GetImage("Image_CarrierIcon");
	self.mImage_OriginHPBar = self:GetImage("HPbar/Image_OriginHPBar");
	self.mImage_HPbar = self:GetImage("HPbar/Image_HPbar");
	self.mImage_Rank = self:GetImage("Image_Rank");
	self.mText_Index = self:GetText("Index/Text_Index");
	self.mText_DamagePercent = self:GetText("Text_DamagePercent");
	self.mTrans_BreakMask = self:GetRectTransform("Trans_BreakMask");
end

--@@ GF Auto Gen Block End

function UIAutoMaxSettlement_PlayerVehicleSlotItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end