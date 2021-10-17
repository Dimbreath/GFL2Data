require("UI.UIBaseCtrl")

PlayerHeadInforItem = class("PlayerHeadInforItem", UIBaseCtrl);
PlayerHeadInforItem.__index = PlayerHeadInforItem
--@@ GF Auto Gen Block Begin
PlayerHeadInforItem.mImage_SelectImage = nil;
PlayerHeadInforItem.mImage_HeadMask_Head = nil;
PlayerHeadInforItem.mImage_GunTypeIcon = nil;
PlayerHeadInforItem.mImage_GunStatusBgImage = nil;
PlayerHeadInforItem.mImage_BloodImagebg_BloodImage = nil;
PlayerHeadInforItem.mText_GunStatus = nil;
PlayerHeadInforItem.mTrans_SelectImage = nil;

function PlayerHeadInforItem:__InitCtrl()

	self.mImage_SelectImage = self:GetImage("PlayerHeadInformation/Trans_Image_SelectImage");
	self.mImage_HeadMask_Head = self:GetImage("PlayerHeadInformation/UI_Btn_HeadMask/Image_Head");
	self.mImage_GunTypeIcon = self:GetImage("PlayerHeadInformation/GunType/Image_GunTypeIcon");
	self.mImage_GunStatusBgImage = self:GetImage("PlayerHeadInformation/Image_GunStatusBgImage");
	self.mImage_BloodImagebg_BloodImage = self:GetImage("PlayerHeadInformation/UI_BloodImagebg/Image_BloodImage");
	self.mText_GunStatus = self:GetText("PlayerHeadInformation/Image_GunStatusBgImage/Text_GunStatus");
	self.mTrans_SelectImage = self:GetRectTransform("PlayerHeadInformation/Trans_Image_SelectImage");
end

--@@ GF Auto Gen Block End

function PlayerHeadInforItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end