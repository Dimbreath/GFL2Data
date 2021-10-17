require("UI.UIBaseCtrl")

UICommonItemS = class("UICommonItemS", UIBaseCtrl)
UICommonItemS.__index = UICommonItemS
--@@ GF Auto Gen Block Begin
UICommonItemS.mImage_Picture = nil
UICommonItemS.mText_Count = nil
UICommonItemS.mImage_CountBgImage = nil

UICommonItemS.mIsItemEnough = true
UICommonItemS.mRelateId = nil

UICommonItemS.Path_UICommonItemS = "UICommonFramework/UICommonItemS.prefab"

function UICommonItemS:__InitCtrl()
	self.mImage_Picture = self:GetImage("IconMask/Image_Icon")
	self.mText_Count = self:GetText("Text_Count")
	self.mImage_CountBgImage = self:GetImage("Image_ItemQualityImage")
	self.mTrans_HeadBG = self:GetRectTransform("IconMask/Trans_HeadBG")
	self.mImage_Head = self:GetImage("IconMask/Trans_HeadBG/mask/Image_Head")
	self.mTrans_Equip = self:GetRectTransform("IconMask/EquipIconBase")
	self.mImage_EquipBase = self:GetImage("IconMask/EquipIconBase/UI_base")
	self.mImage_EquipIcon = self:GetImage("IconMask/EquipIconBase/UI_base/mask/avatareImage")
	self.mText_Pos = self:GetText("IconMask/EquipIconBase/UI_position/Text")
	self.mTrans_FirstDrop = self:GetRectTransform("Trans_FirstDrop")
	self.mTrans_New = self:GetRectTransform("Trans_NewTag")
end

--@@ GF Auto Gen Block End

function UICommonItemS:InitCtrl(root)

	self:SetRoot(root)

	self:__InitCtrl()
end

--- needGetWay 物品的tips是否需要显示获取途径   默认false不显示
function UICommonItemS:InitData(id, num, needGetWay, needItemCount, tipsCount)
	needGetWay = needGetWay == true and true or false
	needItemCount = needItemCount == true and true or false
	if id ~= nil then
		local stcData = TableData.GetItemData(id)
		local itemOwn = 0

		setactive(self.mTrans_HeadBG.gameObject, stcData.type == 4)
		setactive(self.mImage_Picture.gameObject, stcData.type ~= 4 and stcData.type ~= 5)
		setactive(self.mTrans_Equip.gameObject, stcData.type == 5)
		if stcData.type ~= GlobalConfig.ItemType.GunType then
			if(stcData.type == GlobalConfig.ItemType.Resource) then
				itemOwn = NetCmdItemData:GetResItemCount(id)
			else
				itemOwn = NetCmdItemData:GetItemCount(id)
			end
		end

		self.mImage_CountBgImage.color = TableData.GetGlobalGun_Quality_Color2(stcData.rank)
		if stcData.type == GlobalConfig.ItemType.GunType then
			self.mImage_Head.sprite = IconUtils.GetItemIconSprite(stcData.id)
		elseif stcData.type == GlobalConfig.ItemType.EquipmentType then
			local equipData = TableData.GetEquipData(stcData.args[0])
			local rankColor = TableData.GetGlobalGun_Quality_Color2(equipData.rank)
			self.mImage_EquipIcon.sprite = IconUtils.GetEquipSprite(equipData.res_code .. "_1")
			self.mImage_EquipBase.color = rankColor
			self.mText_Pos.text = equipData.category
		else
			self.mImage_Picture.sprite = IconUtils.GetItemIconSprite(stcData.id)
		end

		setactive(self.mText_Count.gameObject, stcData.type ~= 4)
		if stcData.type ~= 4 then
			if needItemCount then
				if(itemOwn < num) then
					self.mText_Count.text = "<color=red>"..itemOwn.."</color>/"..num
					self.mIsItemEnough = false
				else
					self.mText_Count.text = itemOwn.."/"..num
					self.mIsItemEnough = true
				end
				tipsCount = itemOwn
			else
				if num == 0 then
					setactive(self.mText_Count, false)
				else
					self.mText_Count.text = num
				end
			end
		end

		TipsManager.Add(self:GetRoot().gameObject, stcData, tipsCount, needGetWay, false, self.mRelateId)
		setactive(self.mUIRoot, true)
	else
		setactive(self.mUIRoot, false)
	end
end

--- needGetWay 物品的tips是否需要显示获取途径   默认false不显示
function UICommonItemS:SetData(id, num, needGetWay, tipsCount)
	setactive(self.mUIRoot, id ~= nil)
	if id~=nil then
		needGetWay = needGetWay == true and true or false
		setactive(self.mUIRoot, true)
		local stcData = TableData.GetItemData(id)
		if stcData == nil then
			gferror("itemID : " .. id .. "的配置为空请检查")
			return
		end
		self.mImage_CountBgImage.color = TableData.GetGlobalGun_Quality_Color2(stcData.rank)

		local iconPath = stcData.icon_path
		if(iconPath == "") then
			iconPath = "Item"
		end
		self.mImage_Picture.sprite = UIUtils.GetIconSprite("Icon/"..iconPath,stcData.icon)

		self.mText_Count.text = num

		local count = num
		if needGetWay then
			if(stcData.type == 1) then
				count = NetCmdItemData:GetResItemCount(id)
			else
				count = NetCmdItemData:GetItemCount(id)
			end
		end

		TipsManager.Add(self:GetRoot().gameObject, stcData, tipsCount, needGetWay, false, self.mRelateId)
	end
end

function UICommonItemS:SetFirstDrop(isFirst)
	setactive(self.mTrans_FirstDrop, isFirst)
end

function UICommonItemS:SetGunNewFlag(isNew)
	setactive(self.mTrans_New, isNew)
end

function UICommonItemS:SetRelateId(relateId)
	self.mRelateId = relateId
end

function UICommonItemS:IsItemEnough( )
	return self.mIsItemEnough
end
