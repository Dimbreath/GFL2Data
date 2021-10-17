require("UI.UIBaseCtrl")
---@class UICommonItem : UIBaseCtrl
UICommonItem = class("UICommonItem", UIBaseCtrl)
UICommonItem.__index = UICommonItem

function UICommonItem:ctor()
	self.itemId = 0
	self.itemNum = 0
	self.isItemEnough = false
	self.relateId = nil
end

UICommonItem.mObj = nil;

function UICommonItem:__InitCtrl()
	self.mBtn_Select = self:GetSelfButton()
	self.mImage_Icon = self:GetImage("GrpItem/Img_Item")
	self.mImage_Bg = self:GetImage("GrpBg/Img_Bg")
	self.mText_Num = self:GetText("Trans_GrpNum/ImgBg/Text_Num")
	self.mTrans_Num = self:GetRectTransform("Trans_GrpNum")
	self.mTrans_First = self:GetRectTransform("Trans_GrpFirst")
	self.mTrans_Received = self:GetRectTransform("Trans_GrpReceived")
	self.mTrans_EquipIndex = self:GetRectTransform("Trans_GrpEquipNum")
	self.mImage_EquipIndex = self:GetImage("Trans_GrpEquipNum/Img_Icon")
	self.mTrans_Choose = self:GetRectTransform("Trans_GrpChoose")
	self.mTrans_Lock = self:GetRectTransform("Trans_GrpLock")
	self.mTrans_Equipped = self:GetRectTransform("Trans_Equiped")
	self.mImage_Head = self:GetImage("Trans_Equiped/GrpHead/Img_ChrHead")
end

function UICommonItem:InitObj(obj)
	if obj then
		self:SetRoot(obj.transform)
		self:__InitCtrl()
	end
end

function UICommonItem:InitCtrl(parent)
   local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
	end

	
	self:SetRoot(obj.transform)
	self:__InitCtrl()
	self.mObj = obj;
end

--- id                  物品Id
--- num                 物品显示数量
--- needItemCount       是否需要显示拥有量100/100
--- needGetWay 			是否需要详情显示获取途径按钮
--- tipsCount           详情显示的数量
--- relateId			索引Id
function UICommonItem:SetItemData(id, num, needItemCount, needGetWay, tipsCount, relateId, callback)
	needGetWay = needGetWay == true and true or false
	needItemCount = needItemCount == true and true or false

	if id ~= nil then
		self.itemId = id
		self.itemNum = num

		local itemData = TableData.GetItemData(id)
		local itemOwn = 0

		itemOwn = NetCmdItemData:GetItemCountById(id)
		self.mImage_Icon.sprite = IconUtils.GetItemIconSprite(id)
		self.mImage_Bg.sprite = IconUtils.GetQuiltyByRank(itemData.rank)

		if itemData.type ~= GlobalConfig.ItemType.GunType then
			if needItemCount then
				self.isItemEnough = (itemOwn >= num)
				if itemOwn < num then
					self.mText_Num.text = "<color=red>" ..itemOwn .. "</color>/" .. num
				else
					self.mText_Num.text = itemOwn .. "/" .. num
				end
			else
				if num == nil or num < 0 then
					setactive(self.mTrans_Num.gameObject, false)
				else
					self.mText_Num.text = num
				end
			end
		end

		if itemData.type == GlobalConfig.ItemType.EquipPackages then
			setactive(self.mTrans_EquipIndex, true)
			self.mImage_EquipIndex.sprite = CS.IconUtils.GetIconV2("EquipmentNum","Equipment_NumRandom_S")
			self.mImage_Icon.sprite = CS.IconUtils.GetIconV2("EquipmentIcon", itemData.icon.. "_1");
		end

		setactive(self.mTrans_Num, itemData.type ~= GlobalConfig.ItemType.GunType and self.itemNum ~= nil)
		TipsManager.Add(self.mBtn_Select.gameObject, itemData, tipsCount, needGetWay, false, relateId, callback)

		setactive(self.mUIRoot, true)
	else
		if self.mUIRoot then
			setactive(self.mUIRoot, false)
		end
	end
end

function UICommonItem:SetEquipByData(data, callback, isChoose)
	self.mData = data
	self:SetEquipData(data.stcId, data.level, callback)
	if isChoose ~= nil then
		self:SetSelect(isChoose)
	else
		self:SetSelect(false)
	end
	if data then
		setactive(self.mTrans_Lock, data.locked)
		setactive(self.mTrans_Equipped, data.gun_id > 0)
		if data.gun_id > 0 then
			local gunData = TableData.listGunDatas:GetDataById(data.gun_id)
			self.mImage_Head.sprite = IconUtils.GetCharacterHeadSprite(IconUtils.cCharacterAvatarType_Avatar, gunData.code)
		end
	end
	
end

function UICommonItem:SetEquipData(id, level, callback,itemId, relateId)
	self.equipId = id
	local equipData = TableData.listGunEquipDatas:GetDataById(id)
	self.mImage_Icon.sprite = IconUtils.GetEquipSprite(equipData.res_code .. "_1")
	self.mImage_Bg.sprite = IconUtils.GetQuiltyByRank(equipData.rank)
	self.mText_Num.text = "Lv." .. level
	self.mImage_EquipIndex.sprite = IconUtils.GetEquipNum(equipData.category, true)
	setactive(self.mTrans_EquipIndex, true)


	if callback then
		UIUtils.GetButtonListener(self.mBtn_Select.gameObject).onClick = function() callback(self) end
	else
		TipsManager.Add(self.mBtn_Select.gameObject, TableData.GetItemData(itemId), nil, nil, nil, relateId)
  	end


	--if (itemId ~= nil and itemId ~= 0) then
	--	local itemData = TableData.GetItemData(itemId, true)
	--	if itemData ~= nil then
	--		TipsManager.Add(self:GetRoot().gameObject, itemData)
	--	end
	--end
	
end

function UICommonItem:SetEquipDataWithoutInfo(id, level)
	self.equipId = id
	local equipData = TableData.listGunEquipDatas:GetDataById(id)
	self.mImage_Icon.sprite = IconUtils.GetEquipSprite(equipData.res_code .. "_1")
	self.mImage_Bg.sprite = IconUtils.GetQuiltyByRank(equipData.rank)
	self.mText_Num.text = "Lv." .. level
	self.mImage_EquipIndex.sprite = IconUtils.GetEquipNum(equipData.category, true)
	setactive(self.mTrans_EquipIndex, true)
end

function UICommonItem:SetSelect(isChoose)
	self.isChoose = isChoose
	setactive(self.mTrans_Choose, isChoose)
end

function UICommonItem:SetFirstDrop(isFirst)
	setactive(self.mTrans_First, isFirst)
end

function UICommonItem:SetReceived(isReceived)
	setactive(self.mTrans_Received, isReceived)
end

function UICommonItem:IsItemEnough()
	return self.isItemEnough
end

function UICommonItem:EnableButton(enable)
	self.mBtn_Select.interactable = enable
end

function UICommonItem:EnableEquipIndex(enable)
	setactive(self.mTrans_EquipIndex, enable)
end