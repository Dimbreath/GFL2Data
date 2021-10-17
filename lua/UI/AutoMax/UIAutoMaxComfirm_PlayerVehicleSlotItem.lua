require("UI.UIBaseCtrl")

UIAutoMaxComfirm_PlayerVehicleSlotItem = class("UIAutoMaxComfirm_PlayerVehicleSlotItem", UIBaseCtrl);
UIAutoMaxComfirm_PlayerVehicleSlotItem.__index = UIAutoMaxComfirm_PlayerVehicleSlotItem
--@@ GF Auto Gen Block Begin
UIAutoMaxComfirm_PlayerVehicleSlotItem.mImage_CarrierIcon = nil;
UIAutoMaxComfirm_PlayerVehicleSlotItem.mImage_HPbar = nil;
UIAutoMaxComfirm_PlayerVehicleSlotItem.mImage_Rank = nil;
UIAutoMaxComfirm_PlayerVehicleSlotItem.mText_Index = nil;

function UIAutoMaxComfirm_PlayerVehicleSlotItem:__InitCtrl()

	self.mImage_CarrierIcon = self:GetImage("Image_CarrierIcon");
	self.mImage_HPbar = self:GetImage("HPbar/Image_HPbar");
	self.mImage_Rank = self:GetImage("Image_Rank");
	self.mText_Index = self:GetText("Index/Text_Index");
end

--@@ GF Auto Gen Block End

function UIAutoMaxComfirm_PlayerVehicleSlotItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end


function UIAutoMaxComfirm_PlayerVehicleSlotItem:SetData(data)

	self.mImage_Rank.color =  TableData.GetGlobalGun_Quality_Color1(data.Rank)
	self.mImage_HPbar.fillAmount = data.CurrentHp/data.MaxHp
	self.mImage_CarrierIcon.sprite = UIUtils.GetIconSprite("Icon/Carrier",data.Icon)
	if data.Index == 0 then
		self.mText_Index.text = ""
	else
		self.mText_Index.text = data.Index
	end
end