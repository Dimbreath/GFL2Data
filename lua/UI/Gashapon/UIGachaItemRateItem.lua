require("UI.UIBaseCtrl")

UIGachaItemRateItem = class("UIGachaItemRateItem", UIBaseCtrl);
UIGachaItemRateItem.__index = UIGachaItemRateItem
--@@ GF Auto Gen Block Begin
UIGachaItemRateItem.mImage_Quality = nil;
UIGachaItemRateItem.mText_ItemName = nil;
UIGachaItemRateItem.mText_Type = nil;
UIGachaItemRateItem.mText_Rate = nil;
UIGachaItemRateItem.mTrans_UpTag = nil;

function UIGachaItemRateItem:__InitCtrl()

	self.mImage_Quality = self:GetImage("Image_Quality");
	self.mText_ItemName = self:GetText("Text_ItemName");
	self.mText_Type = self:GetText("Text_Type");
	self.mText_Rate = self:GetText("Text_Rate");
	self.mTrans_UpTag = self:GetRectTransform("Trans_UpTag");
end

--@@ GF Auto Gen Block End

UIGachaItemRateItem.mPath_Prefab = "Gashapon/UIGachaItemRateItem.prefab";

function UIGachaItemRateItem:InitCtrl(parent)

	local instObj = instantiate(UIUtils.GetGizmosPrefab(self.mPath_Prefab,self));

	self:SetRoot(instObj.transform);

	instObj.transform:SetParent(parent.transform,false);

	self:__InitCtrl();

end

function UIGachaItemRateItem:InitGunData(k,v)
	local itemData = TableData.listItemDatas:GetDataById(k);
	local gunId = itemData.Args[0];
	local gunData = TableData.listGunDatas:GetDataById(gunId);
	self.mText_ItemName.text = gunData.Name.str;
	self.mText_Type.text = TableData.GetHintById(56 + gunData.duty);
	self.mText_Rate.text = string.format("%.2f", v * 100).."%"
	self.mImage_Quality.sprite = UIUtils.GetIconSprite("Icon/Rarity","Rarity_"..gunData.rank);
end

function UIGachaItemRateItem:InitWeaponData(k,v)
	local itemData = TableData.listItemDatas:GetDataById(k);
	local weaponId = itemData.Args[0];
	local weaponData = TableData.listGunWeaponDatas:GetDataById(weaponId);
	self.mText_ItemName.text = weaponData.Name.str;
	self.mText_Type.text = "";
	self.mText_Rate.text = string.format("%.2f", v * 100).."%"
	self.mImage_Quality.sprite = UIUtils.GetIconSprite("Icon/Rarity","Rarity_"..weaponData.Rank);
end