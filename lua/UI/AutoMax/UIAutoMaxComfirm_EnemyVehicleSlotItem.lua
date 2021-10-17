require("UI.UIBaseCtrl")

UIAutoMaxComfirm_EnemyVehicleSlotItem = class("UIAutoMaxComfirm_EnemyVehicleSlotItem", UIBaseCtrl);
UIAutoMaxComfirm_EnemyVehicleSlotItem.__index = UIAutoMaxComfirm_EnemyVehicleSlotItem
--@@ GF Auto Gen Block Begin
UIAutoMaxComfirm_EnemyVehicleSlotItem.mImage_CarrierIcon = nil;
UIAutoMaxComfirm_EnemyVehicleSlotItem.mImage_HPbar = nil;
UIAutoMaxComfirm_EnemyVehicleSlotItem.mImage_Rank = nil;
UIAutoMaxComfirm_EnemyVehicleSlotItem.mText_Index = nil;

function UIAutoMaxComfirm_EnemyVehicleSlotItem:__InitCtrl()

	self.mImage_CarrierIcon = self:GetImage("Image_CarrierIcon");
	self.mImage_HPbar = self:GetImage("HPbar/Image_HPbar");
	self.mImage_Rank = self:GetImage("Image_Rank");
	self.mText_Index = self:GetText("Index/Text_Index");
end

--@@ GF Auto Gen Block End

function UIAutoMaxComfirm_EnemyVehicleSlotItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIAutoMaxComfirm_EnemyVehicleSlotItem:SetData(data)
	self.mImage_Rank.color =  TableData.GetGlobalGun_Quality_Color1(data.Rank)
	self.mImage_HPbar.fillAmount = data.CurrentHp/data.MaxHp
	self.mImage_CarrierIcon.sprite = UIUtils.GetIconSprite("Icon/Carrier",data.Icon)

	if data.Index == 0 then
		self.mText_Index.text = ""
	else
		self.mText_Index.text = data.Index
	end
end