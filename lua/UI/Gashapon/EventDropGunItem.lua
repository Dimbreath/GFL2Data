require("UI.UIBaseCtrl")

EventDropGunItem = class("EventDropGunItem", UIBaseCtrl);
EventDropGunItem.__index = EventDropGunItem
--@@ GF Auto Gen Block Begin
EventDropGunItem.mImage_RankImg = nil;
EventDropGunItem.mText_GunName = nil;
EventDropGunItem.mText_GunType = nil;

EventDropGunItem.mData = nil;

function EventDropGunItem:__InitCtrl()

	self.mImage_RankImg = self:GetImage("Image_RankImg");
	self.mText_GunName = self:GetText("Text_GunName");
	self.mText_GunType = self:GetText("Text_GunType");
end

--@@ GF Auto Gen Block End

function EventDropGunItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function EventDropGunItem:InitData(data)
	self.mData = data;

	self.mText_GunName.text = data.name;
	self.mText_GunType.text = data.type;	
	self.mImage_RankImg.color = TableData.GetGlobalGun_Quality_Color2(data.rank);
end