require("UI.UIBaseView")
require("UI.Common.UIGetWayView")
require("UI.Tips.UIComAccessItem")

UIItemDetailPanelView = class("UIItemDetailPanelView", UIBaseView)
UIItemDetailPanelView.__index = UIItemDetailPanelView

--@@ GF Auto Gen Block Begin
UIItemDetailPanelView.StarList = {}
UIItemDetailPanelView.subProp = {}
UIItemDetailPanelView.MainProp = nil

UIItemDetailPanelView.mData = nil
UIItemDetailPanelView.mCount = 0
UIItemDetailPanelView.mNeedGetWay = false
UIItemDetailPanelView.mShowTime = false
UIItemDetailPanelView.mRelateId = 0
UIItemDetailPanelView.mItemShowType = nil
UIItemDetailPanelView.mIsShowNum = false
UIItemDetailPanelView.updateFlag = false
UIItemDetailPanelView.detailBrief = nil
UIItemDetailPanelView.weaponDetail = nil


UIItemDetailPanelView.StaminaType = GlobalConfig.ItemType.StaminaType
UIItemDetailPanelView.GunType = GlobalConfig.ItemType.GunType
UIItemDetailPanelView.EquipmentType = GlobalConfig.ItemType.EquipmentType
UIItemDetailPanelView.WeaponType = GlobalConfig.ItemType.Weapon

UIItemDetailPanelView.ItemShowType =
{
	NormalItemType = 1,
	StaminaType = 2,
	GunType = 3,
	EquipmentType = 4,
	WeaponType = 5,
}

--- 体力相关
UIItemDetailPanelView.staminaRegainAmount = nil
UIItemDetailPanelView.staminaRegainInterval = nil

-- 获取途径界面
UIItemDetailPanelView.HowToGetPanel = nil

UIItemDetailPanelView.getWayList = {};
UIItemDetailPanelView.attributeList = {}
UIItemDetailPanelView.equipSetList = {}

function UIItemDetailPanelView:__InitCtrl()
	self.mBtn_BgClose = self:GetButton("Root/GrpBg/Btn_Close")
	self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpBg/GrpTop/GrpClose/Btn_Close")
	self.mText_TopTitle = self:GetText("Root/GrpDialog/GrpBg/GrpTop/GrpText/Text_Name")
	self.mImage_ItemRate = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpQualityLine/Img_Line")
	self.mImage_IconImage = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemIcon/Img_Icon")
	self.mTrans_Count = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpNum")
	self.mText_Count = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpNum/GrpText/Text_Num")
	self.mText_CountName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpNum/GrpText/TextName")
	self.mText_ItemName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpTextName/Text_Name")
	self.mText_Description = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpContentList/Viewport/Content/GrpTextDescription/Text_Description")
	self.mText_AllAdd = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime/Trans_GrpAllTime/Text_Time")
	self.mText_NextAdd = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime/Trans_GrpNextTime/Text_Time")
	self.mText_Full = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime/Trans_GrpMax")
	self.mTrans_TimeLeft = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime")
	self.mTrans_ItemDetailView = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem")
	self.mTrans_AccessList = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpContentList/Viewport/Content/GrpAccessList")
	self.mTrans_AccessTitle = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpContentList/Viewport/Content/GrpTextAccess")
	self.mTrans_Equip = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpEquip")
	self.mImage_EquipBase = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpQualityLine/Img_Line")
	self.mImage_EquipIcon = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipIcon/Img_Icon")
	self.mImage_Pos = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpEquipNum/Img_Icon")
	self.mText_EquipName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpEquipInfo/Text_Name")
	self.mTrans_EquipSub = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute")
	self.mTrans_EquipSkill = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpSkill")
	self.mText_MainAttributeName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/GrpList/Text_Name")
	self.mText_MainAttributeNum = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/Text_Num");
	self.mTrans_Weapon = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpWeapon")
	self.mText_WeaponName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpTextName/Text_Name")
	self.mImage_WeaponBase = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpQualityLine/Img_Line")
	self.mImage_WeaponIcon = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponIcon/Img_Icon")
	self.mImage_WeaponElement = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpElement/ComElementItemV2/Image_ElementIcon")
	self.mTrans_WeaponSub = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpAttributeList/Viewport/Content/GrpAttribute")
	self.mTrans_WeaponSkill = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpAttributeList/Viewport/Content/GrpSkill")

	self.StarList = {}

	self:InitEquipSetList()
end

function UIItemDetailPanelView:InitEquipSetList()
	for i = 1, 2 do
		local item = self:InitEquipSet(self.mTrans_EquipSkill)
		table.insert(self.equipSetList, item)
	end
end

function UIItemDetailPanelView:InitEquipSet(parent)
	local equipSet = UIEquipSetItem.New()
	equipSet:InitCtrl(parent)

	return equipSet
end

--@@ GF Auto Gen Block End

function UIItemDetailPanelView:InitCtrl(root)

	self:SetRoot(root)

	self:__InitCtrl()

	UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = self.OnCloseClick
	UIUtils.GetButtonListener(self.mBtn_BgClose.gameObject).onClick = self.OnCloseClick
end

function UIItemDetailPanelView.OnCloseClick(gameObject)
	setactive(self.mUIRoot.gameObject, false)
end

function UIItemDetailPanelView:GetTableData(tableId)
	return TableData.GetItemData(tableId)
end

function UIItemDetailPanelView.OnHowToGetClicked(gameObject)
	self = UIItemDetailPanelView

	if not self.HowToGetPanel then
		local uiRepoItem = UIGetWayView:New()
		uiRepoItem:InitCtrl(self.mUIRoot)
		self.HowToGetPanel = uiRepoItem
	end
	self.HowToGetPanel:SetData(self.mData.id)
end


function UIItemDetailPanelView:CheckItemType(itemData)
	if itemData.type == UIItemDetailPanelView.GunType then
		return UIItemDetailPanelView.ItemShowType.GunType
	elseif itemData.type == UIItemDetailPanelView.EquipmentType then
		return UIItemDetailPanelView.ItemShowType.EquipmentType
	elseif itemData.type == UIItemDetailPanelView.WeaponType then
		return UIItemDetailPanelView.ItemShowType.WeaponType
	elseif itemData.type == UIItemDetailPanelView.StaminaType then
		return UIItemDetailPanelView.ItemShowType.NormalItemType
	else
		return UIItemDetailPanelView.ItemShowType.NormalItemType
	end
end

function UIItemDetailPanelView:ShowItemDetail(itemData, num, needGetWay, showTime, relateId)
	self.mData = itemData
	self.mCount = num
	self.mNeedGetWay = needGetWay
	self.mShowTime = showTime == nil and false or showTime
	self.mRelateId = relateId or 0;
	setactive(self.mUIRoot.gameObject, true)
	local isShowGet = self.mData.HasApproach and self.mNeedGetWay;
	isShowGet = isShowGet~=nil and isShowGet or false;

	if(needGetWay) then
		self:ShowGet();
	else
		setactive(self.mTrans_AccessTitle,false);
	end

	setactive(self.mText_Count.gameObject, self.mCount ~= nil and self.mCount >= 0 )
	setactive(self.mText_CountName.transform.parent, self.mCount ~= nil and self.mCount >= 0)
	local type = self:CheckItemType(itemData)
	setactive(self.mTrans_ItemDetailView.gameObject, type == UIItemDetailPanelView.ItemShowType.NormalItemType)
	setactive(self.mTrans_Equip.gameObject, type == UIItemDetailPanelView.ItemShowType.EquipmentType)
	setactive(self.mTrans_Weapon.gameObject, type == UIItemDetailPanelView.ItemShowType.WeaponType)

	if type == UIItemDetailPanelView.ItemShowType.NormalItemType then
		self.mText_TopTitle.text = TableData.GetHintById(101)
		self:ShowItem()
	elseif type == UIItemDetailPanelView.ItemShowType.EquipmentType then
		self.mText_TopTitle.text = TableData.GetHintById(102)
		self:ShowEquipment()
	elseif type == UIItemDetailPanelView.ItemShowType.GunType then
		self:ShowGun()
	elseif type == UIItemDetailPanelView.ItemShowType.WeaponType then
		self.mText_TopTitle.text = TableData.GetHintById(103)
		self:ShowWeapon()
	end

	self.mItemShowType = type
end

function UIItemDetailPanelView:ShowGet()
	local data = self.mData

	if(data.get_list == "") then
		setactive(self.mTrans_AccessTitle,false)
		return
	end

	local getList = string.split(data.get_list, ",")

	for _, item in ipairs(getList) do
		if item ~= "" then
			local getListData = TableData.listItemGetListDatas:GetDataById(tonumber(item))
			local itemHowToGetData = TableData.listItemHowToGetDatas:GetDataById(getListData.type)

			if getListData then

				local dataParam =
				{
					title = getListData.title.str,
					type = getListData.typ,
					getList = getListData,
					itemData = data,
					howToGetData = getListData,
					root = self
				}
				item = UIComAccessItem.New()
				item:InitCtrl(self.mTrans_AccessList)
				item:SetData(dataParam);
			end
		end
	end
end


function UIItemDetailPanelView:ShowItem()
	self.mText_ItemName.text = self.mData.name.str
	if self.mCount and tonumber(self.mCount) >= 0 then
		self.mText_Count.text = tostring(self.mCount)
	else
		self.mText_Count.text = ""
	end
	self.mText_Description.text = self.mData.introduction.str
	self.mImage_IconImage.sprite = UIUtils.GetIconSprite("Icon/" .. self.mData.icon_path, self.mData.icon)
	self.mImage_ItemRate.color = TableData.GetGlobalGun_Quality_Color2(self.mData.rank)
	setactive(self.mTrans_TimeLeft, self.mData.type == UIItemDetailPanelView.StaminaType)
	if self.mData.type == UIItemDetailPanelView.StaminaType then
		self:ShowStamina()
	elseif self.mData.type == 2 then
		--self.mText_TimeLeft.text = tonumber(self.mCount)
	elseif self.mData.type == GlobalConfig.ItemType.Weapon then
		if self.detailBrief == nil then
			local item = UICommonWeaponBriefItem.New()
			item:InitCtrl(self.mTrans_Brief)
			self.detailBrief = item
		end

		if self.mRelateId == nil or self.mRelateId == 0 then
			self.detailBrief:SetData(UICommonEquipBriefItem.ShowType.Item, self.mData.id)
		else
			self.detailBrief:SetData(UICommonEquipBriefItem.ShowType.Equip, self.mRelateId)
		end
	elseif self.mData.type == GlobalConfig.ItemType.EquipPackages then
		if self.detailBrief == nil then
			local item = UICommonEquipBriefItem.New()
			item:InitCtrl(self.mTrans_Brief)
			self.detailBrief = item
		end
		if self.mRelateId == nil or self.mRelateId == 0 then
			self.detailBrief:SetData(UICommonEquipBriefItem.ShowType.Item, self.mData.id)
		else
			self.detailBrief:SetData(UICommonEquipBriefItem.ShowType.Equip, self.mRelateId)
		end
	end
end

function UIItemDetailPanelView:ShowGun()
	self.mText_ItemName.text = self.mData.name.str
	self.mText_Description.text = self.mData.description.str

	self.mImage_ItemRate.color = TableData.GetGlobalGun_Quality_Color1(self.mData.rank)
end

function UIItemDetailPanelView:ShowWeapon()
	self.mText_WeaponName.text = self.mData.name.str
	self.mText_Description.text = self.mData.description.str

	local weaponData = TableData.listGunWeaponDatas:GetDataById(tonumber(self.mData.args[0]))
	local rankColor = TableData.GetGlobalGun_Quality_Color2(weaponData.rank)

	self.mImage_WeaponIcon.sprite = IconUtils.GetWeaponNormalSprite(weaponData.res_code)
	self.mImage_WeaponBase.color = rankColor

	local elementData = TableData.listLanguageElementDatas:GetDataById(weaponData.Element)
	self.mImage_WeaponElement.sprite = IconUtils.GetElementIcon(elementData.icon .. "_M")

	local cmdData = NetCmdWeaponData:GetWeaponById(self.mRelateId)
	self:UpdateWeaponAttribute(cmdData,weaponData);

	if(weaponData.skill ~= 0) then
		local normalSkillItem = UIWeaponSkillItem.New()
		normalSkillItem:InitCtrl(self.mTrans_WeaponSkill)
		normalSkillItem:SetData(weaponData.skill)
	end

	if(weaponData.elemen_skill ~= 0) then
		local elementSkillItem = UIWeaponSkillItem.New()
		elementSkillItem:InitCtrl(self.mTrans_WeaponSkill)
		elementSkillItem:SetData(weaponData.elemen_skill)
	end

	if(cmdData == nil) then
		cmdData = CS.WeaponCmdData(weaponData.id)
		self.mText_Count.text = cmdData:GetBasePower();
	else
		self.mText_Count.text = cmdData:GetPower();
	end

	setactive(self.mText_Count.gameObject, true)
	setactive(self.mText_CountName.gameObject, true)
	self.mText_CountName.text = "参数"

end

function UIItemDetailPanelView:UpdateWeaponAttribute(data,stcData)
	local attrList = {}
	local curLv = 0;
	if(data) then
		curLv = data.CurLv;
	else
		data = CS.WeaponCmdData(stcData.id)
	end

	local expandList = TableData.GetPropertyExpandList()
	for i = 0, expandList.Count - 1 do
		local lanData = expandList[i]
		if(lanData.type == 1) then
			local value = 0;
			if(data) then
				value = data:GetPropertyByLevelAndSysName(lanData.sys_name, curLv, data.BreakTimes)
			else
				value = stcData
			end
			if(value > 0) then
				local attr = {}
				attr.propData = lanData
				attr.value = value
				table.insert(attrList, attr)
			end
		end
	end

	table.sort(attrList, function (a, b) return a.propData.order < b.propData.order end)

	for _, item in ipairs(self.attributeList) do
		item:SetData(nil)
	end

	for i = 1, #attrList do
		local item = nil
		if i <= #self.attributeList then
			item = self.attributeList[i]
		else
			item = PropertyItemS.New()
			item:InitCtrl(self.mTrans_WeaponSub)
			table.insert(self.attributeList, item)
		end
		item:SetData(attrList[i].propData, attrList[i].value,false, UIWeaponGlobal.BlackColor, false)
	end
end


function UIItemDetailPanelView:ShowEquipment()
	self.mText_EquipName.text = self.mData.name.str
	self.mText_Description.text = self.mData.description.str

	self.mImage_ItemRate.color = TableData.GetGlobalGun_Quality_Color1(self.mData.rank)

	local equipData = TableData.listGunEquipDatas:GetDataById(tonumber(self.mData.args[0]))
	local rankColor = TableData.GetGlobalGun_Quality_Color2(equipData.rank)
	self.mImage_EquipIcon.sprite = IconUtils.GetEquipSprite(equipData.res_code)
	self.mImage_EquipBase.color = rankColor
	self.mImage_Pos.sprite = IconUtils.GetEquipNum(equipData.category, true)

	local cmdData = NetCmdEquipData:GetEquipById(self.mRelateId)
	self:UpdateEquipMainAttribute(cmdData);
	self:UpdateEquipSubAttribute(cmdData);


	local setData = TableData.listEquipSetDatas:GetDataById(equipData.SetIdCs)
	for i, item in ipairs(self.equipSetList) do
		item:SetData(equipData.SetIdCs,setData["set" .. i .. "_num"])
	end

	setactive(self.mTrans_Count.gameObject,false)
end

function UIItemDetailPanelView:UpdateEquipMainAttribute(data)
	if data ~= nil and data.main_prop ~= nil then
		local tableData = TableData.listCalibrationDatas:GetDataById(data.main_prop.Id)
		if tableData then
			local propData = TableData.GetPropertyDataByName(tableData.property, tableData.type)
			self.mText_MainAttributeName.text = propData.show_name.str
			if propData.show_type == 2 then
				self.mText_MainAttributeNum.text = math.ceil(data.main_prop.Value / 10)  .. "%"
			else
				self.mText_MainAttributeNum.text = data.main_prop.Value
			end
		end
	else
		self.mText_MainAttributeName.text = TableData.GetHintById(20010);
		self.mText_MainAttributeNum.text = "";
	end
end


function UIItemDetailPanelView:UpdateEquipSubAttribute(data)
	if(data == nil) or (data.sub_props == nil) then
		local item = PropertyItemS.New()
		item:InitCtrl(self.mTrans_EquipSub)
		item.mText_Name.text = TableData.GetHintById(20011);
		item.mText_Num.text = ""
		return;
	end

	if data.sub_props then
		local item = nil
		for _, item in ipairs(self.subProp) do
			item:SetData(nil)
		end

		for i = 0, data.sub_props.Length - 1 do
			local prop = data.sub_props[i]
			local tableData = TableData.listCalibrationDatas:GetDataById(prop.Id)
			local propData = TableData.GetPropertyDataByName(tableData.property, tableData.type)
			if i + 1 <= #self.subProp then
				item = self.subProp[i + 1]
			else
				item = PropertyItemS.New()
				item:InitCtrl(self.mTrans_EquipSub)
				table.insert(self.subProp, item)
			end
			item:SetData(propData, prop.Value, false, ColorUtils.BlackColor, false)
			item:SetNameColor(ColorUtils.BlackColor)
			item:SetTextSize(24)
		end
	end
end

function UIItemDetailPanelView:ShowStamina()
	self.staminaRegainInterval = self.mData.args[0]

	if self.mCount and tonumber(self.mCount) >= 0 then
		self.mText_Count.text = tostring(self.mCount)
	else
		self.mText_Count.text = ""
	end

	if not self.mNeedGetWay and not self.mShowTime then
		setactive(self.mText_AllAdd.transform.parent, false)
		setactive(self.mText_NextAdd.transform.parent, false)
		setactive(self.mText_Full.gameObject, false)
		self.updateFlag = false
	else
		local maxStamina = GlobalData.GetStaminaResourceMaxNum(self.mData.id)
		setactive(self.mText_AllAdd.transform.parent, self.mCount < maxStamina)
		setactive(self.mText_NextAdd.transform.parent, self.mCount < maxStamina)
		setactive(self.mText_Full.gameObject, self.mCount >= maxStamina)

		self.updateFlag = self.mCount < maxStamina
	end
end

function UIItemDetailPanelView:UpdateStaminaContent()
	local staminaInfo = GlobalData.GetStaminaTypeResById(self.mData.id)
	if staminaInfo then
		local maxStaminaInScene = GlobalData.GetStaminaResourceMaxNum(self.mData.id)
		local lastTime = 0
		if self.mCount < maxStaminaInScene then
			local staminaTime = staminaInfo.RefreshTime --上次更新时的时间戳
			local passedTime = (CGameTime:GetTimestamp() - staminaTime) % self.staminaRegainInterval
			if passedTime <= 0 then
				passedTime = self.staminaRegainInterval
			end
			lastTime = self.staminaRegainInterval - passedTime--剩余时间
			if lastTime <= 0 then
				MessageSys:SendMessage(CS.GF2.Message.ModelDataEvent.StaminaUpdate, nil)
				lastTime = 0
			end
			local timeMax = self.staminaRegainInterval * (maxStaminaInScene - self.mCount) - passedTime
			local timeMaxString =  CS.LuaUIUtils.GetTimeStringBySecond(timeMax)
			local timeString = CS.LuaUIUtils.GetTimeStringBySecond(lastTime)
			self.mText_NextAdd.text = timeString
			self.mText_AllAdd.text = timeMaxString
		else
			setactive(self.mText_AllAdd.gameObject, false)
			setactive(self.mText_NextAdd.gameObject, false)
			setactive(self.mText_Full.gameObject, true)
			self.updateFlag = false
		end
	end

end

function UIItemDetailPanelView:UpdateDetailContent()
	if self.mItemShowType == UIItemDetailPanelView.ItemShowType.NormalItemType then
		local count = 0
		if self.mData.type == 1 then
			count = NetCmdItemData:GetResItemCount(self.mData.id)
		elseif self.mData.type == 3 then
			count = NetCmdItemData:GetItemCount(self.mData.id)
		elseif self.mData.type == UIItemDetailPanelView.StaminaType then
			count = GlobalData.GetStaminaResourceItemCount(self.mData.id)
			self:ShowStamina()
		end
		self.mCount = count
		if self.mCount and tonumber(self.mCount) >= 0 then
			self.mText_Count.text = tostring(self.mCount)
		else
			self.mText_Count.text = ""
		end
	end
end

function UIItemDetailPanelView:SetStars(count)
	for i, star in ipairs(self.StarList) do
		setactive(star, count >= i)
	end
end

function UIItemDetailPanelView:onRelease()
	self.HowToGetPanel = nil
	self.StarList = {}
	self.MainProp = nil
	self.subProp = {}
	self.attributeList = {}
	self.detailBrief = nil
	self.equipSetList={}
end
