require("UI.UIBaseCtrl")

---@class UICommonGrpItem : UIBaseCtrl
UICommonGrpItem = class("UICommonGrpItem", UIBaseCtrl);
UICommonGrpItem.__index = UICommonGrpItem
--@@ GF Auto Gen Block Begin
UICommonGrpItem.mTrans_Item = nil
UICommonGrpItem.mTrans_Weapon = nil
UICommonGrpItem.mTrans_WeaponPart = nil
UICommonGrpItem.mBtn_ItemSelect = nil
UICommonGrpItem.mBtn_WeaponSelect = nil
UICommonGrpItem.mBtn_WeaponPart = nil

function UICommonGrpItem:__InitCtrl()
	self.mTrans_Item = self:GetRectTransform("Trans_Item")
	self.mTrans_Weapon = self:GetRectTransform("Trans_Weapon")
	self.mTrans_WeaponPart = self:GetRectTransform("Trans_WeaponParts")
end

function UICommonGrpItem:__InitCtrlItem()
	self.mBtn_ItemSelect = UIUtils.GetTempBtn(self.mTrans_Item);
	self.mBtn_ItemSelect.transform.anchorMin = vector2zero
	self.mBtn_ItemSelect.transform.anchorMax = vector2one
	self.mBtn_ItemSelect.transform.offsetMin = vector2zero
	self.mBtn_ItemSelect.transform.offsetMax = vector2zero
end

function UICommonGrpItem:__InitCtrlWeapon()
	self.mBtn_WeaponSelect = UIUtils.GetTempBtn(self.mTrans_Weapon);
	self.mBtn_WeaponSelect.transform.anchorMin = vector2zero
	self.mBtn_WeaponSelect.transform.anchorMax = vector2one
	self.mBtn_WeaponSelect.transform.offsetMin = vector2zero
	self.mBtn_WeaponSelect.transform.offsetMax = vector2zero
end

function UICommonGrpItem:__InitCtrlWeaponPart()
	self.mBtn_WeaponPart = UIUtils.GetTempBtn(self.mTrans_WeaponPart);
	self.mBtn_WeaponPart.transform.anchorMin = vector2zero
	self.mBtn_WeaponPart.transform.anchorMax = vector2one
	self.mBtn_WeaponPart.transform.offsetMin = vector2zero
	self.mBtn_WeaponPart.transform.offsetMax = vector2zero
end

--@@ GF Auto Gen Block End

function UICommonGrpItem:InitCtrl(parent)
	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComGrpItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UICommonGrpItem:SetEquipData(id, level, callback, itemId, isReceived)
	setactive(self.mTrans_Item.transform, true)
	setactive(self.mTrans_Weapon.transform, false)
	setactive(self.mTrans_WeaponPart.transform, false)
	if self.mBtn_ItemSelect == nil then
		self:__InitCtrlItem()
		---@type UICommonItem
		self.item = UICommonItem:New()
		self.item:InitObj(self.mBtn_ItemSelect)
	end
	self.item:SetEquipData(id, level, callback,itemId)
	self.item:SetReceived(isReceived)
end

function UICommonGrpItem:SetItemData(id, num, needItemCount, needGetWay, tipsCount, relateId, isReceived)
	setactive(self.mTrans_Item.transform, true)
	setactive(self.mTrans_Weapon.transform, false)
	setactive(self.mTrans_WeaponPart.transform, false)
	if self.mBtn_ItemSelect == nil then
		self:__InitCtrlItem()
		---@type UICommonItem
		self.item = UICommonItem:New()
		self.item:InitObj(self.mBtn_ItemSelect)
	end
	self.item:SetItemData(id, num, needItemCount, needGetWay, tipsCount, relateId)
	self.item:SetReceived(isReceived)
	self.item:EnableEquipIndex(false)
end

function UICommonGrpItem:SetByItemData(itemData, count, isReceived)
	self.mItemData = itemData
	if itemData.type == GlobalConfig.ItemType.Weapon then --武器
		self:SetData(itemData.args[0], 0, nil, isReceived)
	elseif itemData.type == GlobalConfig.ItemType.WeaponPart then --武器
		self:SetWeaponPartData(itemData, isReceived)
	else
		if itemData.type == GlobalConfig.ItemType.EquipmentType then --模组
			self:SetEquipData(itemData.args[0],0,nil, itemData.id, isReceived)
		else
			self:SetItemData(itemData.id, count,nil,nil,nil, nil, isReceived)
		end
	end
end

function UICommonGrpItem:SetData(weaponId, level, callback, isReceived)
	setactive(self.mTrans_Item.transform, false)
	setactive(self.mTrans_Weapon.transform, true)
	setactive(self.mTrans_WeaponPart.transform, false)
	if self.mBtn_WeaponSelect == nil then
		self:__InitCtrlWeapon()
		---@type UICommonWeaponInfoItem
		self.weaponItem = UICommonWeaponInfoItem:New()
		self.weaponItem:InitObj(self.mBtn_WeaponSelect)
	end
	self.weaponItem:SetData(weaponId, level, callback, true)
	self.weaponItem:SetReceived(isReceived)
	self.weaponItem:EnableElement(true)
end

function UICommonGrpItem:SetWeaponPartData(itemData, isReceived)
	setactive(self.mTrans_Item.transform, false)
	setactive(self.mTrans_Weapon.transform, false)
	setactive(self.mTrans_WeaponPart.transform, true)
	if self.mBtn_WeaponPart == nil then
		self:__InitCtrlWeaponPart()
		---@type UIWeaponPartItem
		self.weaponPartItem = UIWeaponPartItem:New()
		self.weaponPartItem:InitObj(self.mBtn_WeaponPart)
	end
	local partData = UIWeaponGlobal:GetWeaponPartSimpleData(CS.GunWeaponPartData(itemData.args[0]))
	self.weaponPartItem:SetData(partData)
	self.weaponPartItem:SetReceived(isReceived)
	self.weaponPartItem:SetLevel(false)
	self.weaponPartItem:SetQualityLine(false)
	TipsManager.Add(self.mBtn_WeaponPart.gameObject, itemData)
end