require("UI.UIBaseCtrl")

UIAutoMaxSettlement_EnemyVehicleSlotItem = class("UIAutoMaxSettlement_EnemyVehicleSlotItem", UIBaseCtrl);
UIAutoMaxSettlement_EnemyVehicleSlotItem.__index = UIAutoMaxSettlement_EnemyVehicleSlotItem
--@@ GF Auto Gen Block Begin
UIAutoMaxSettlement_EnemyVehicleSlotItem.mImage_CarrierIcon = nil;
UIAutoMaxSettlement_EnemyVehicleSlotItem.mImage_OriginHPBar = nil;
UIAutoMaxSettlement_EnemyVehicleSlotItem.mImage_HPbar = nil;
UIAutoMaxSettlement_EnemyVehicleSlotItem.mImage_Rank = nil;
UIAutoMaxSettlement_EnemyVehicleSlotItem.mText_Index = nil;
UIAutoMaxSettlement_EnemyVehicleSlotItem.mText_DamagePercent = nil;
UIAutoMaxSettlement_EnemyVehicleSlotItem.mTrans_BreakMask = nil;

function UIAutoMaxSettlement_EnemyVehicleSlotItem:__InitCtrl()

	self.mImage_CarrierIcon = self:GetImage("Image_CarrierIcon");
	self.mImage_OriginHPBar = self:GetImage("HPbar/Image_OriginHPBar");
	self.mImage_HPbar = self:GetImage("HPbar/Image_HPbar");
	self.mImage_Rank = self:GetImage("Image_Rank");
	self.mText_Index = self:GetText("Index/Text_Index");
	self.mText_DamagePercent = self:GetText("Text_DamagePercent");
	self.mTrans_BreakMask = self:GetRectTransform("Trans_BreakMask");
end

--@@ GF Auto Gen Block End

function UIAutoMaxSettlement_EnemyVehicleSlotItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

