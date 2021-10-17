require("UI.UIBaseView")

---@class UIComItemDetailsPanelV2View : UIBaseView
UIComItemDetailsPanelV2View = class("UIComItemDetailsPanelV2View", UIBaseView);
UIComItemDetailsPanelV2View.__index = UIComItemDetailsPanelV2View

--@@ GF Auto Gen Block Begin
UIComItemDetailsPanelV2View.mBtn_Close = nil;
UIComItemDetailsPanelV2View.mBtn_Close1 = nil;
UIComItemDetailsPanelV2View.mImg_EquipIcon = nil;
UIComItemDetailsPanelV2View.mImg_EquipIcon = nil;
UIComItemDetailsPanelV2View.mImg_EquipLine = nil;
UIComItemDetailsPanelV2View.mImg_IconIcon = nil;
UIComItemDetailsPanelV2View.mImg_WeaponIcon = nil;
UIComItemDetailsPanelV2View.mImg_WeaponLine = nil;
UIComItemDetailsPanelV2View.mImg_WeaponPartsIcon = nil;
UIComItemDetailsPanelV2View.mImg_WeaponPartsLine = nil;
UIComItemDetailsPanelV2View.mImg_ItemIcon = nil;
UIComItemDetailsPanelV2View.mImg_ItemLine = nil;
UIComItemDetailsPanelV2View.mText_ = nil;
UIComItemDetailsPanelV2View.mText_Name = nil;
UIComItemDetailsPanelV2View.mText_EquipName = nil;
UIComItemDetailsPanelV2View.mText_Name = nil;
UIComItemDetailsPanelV2View.mText__Num = nil;
UIComItemDetailsPanelV2View.mText_NumNow = nil;
UIComItemDetailsPanelV2View.mText_NumAfter = nil;
UIComItemDetailsPanelV2View.mText_WeaponName = nil;
UIComItemDetailsPanelV2View.mText_WeaponName1 = nil;
UIComItemDetailsPanelV2View.mText_WeaponPartsName = nil;
UIComItemDetailsPanelV2View.mText_WeaponPartsName1 = nil;
UIComItemDetailsPanelV2View.mText_WeaponPartsName2 = nil;
UIComItemDetailsPanelV2View.mText__Description = nil;
UIComItemDetailsPanelV2View.mText_ItemName = nil;
UIComItemDetailsPanelV2View.mText_Description = nil;
UIComItemDetailsPanelV2View.mText_ = nil;
UIComItemDetailsPanelV2View.mText_NextTimeNum = nil;
UIComItemDetailsPanelV2View.mText_NextTime_Time = nil;
UIComItemDetailsPanelV2View.mText_AllTime_Num = nil;
UIComItemDetailsPanelV2View.mText_AllTimeTime = nil;
UIComItemDetailsPanelV2View.mText_Max = nil;
UIComItemDetailsPanelV2View.mText_Name = nil;
UIComItemDetailsPanelV2View.mText_NumNum = nil;
UIComItemDetailsPanelV2View.mContent_Attribute = nil;
UIComItemDetailsPanelV2View.mContent_AttributeAttribute = nil;
UIComItemDetailsPanelV2View.mContent_AttributeAttributeAttribute = nil;
UIComItemDetailsPanelV2View.mContent_ = nil;
UIComItemDetailsPanelV2View.mContent_ = nil;
UIComItemDetailsPanelV2View.mScrollbar_Attribute = nil;
UIComItemDetailsPanelV2View.mScrollbar_AttributeAttribute = nil;
UIComItemDetailsPanelV2View.mScrollbar_AttributeAttributeAttribute = nil;
UIComItemDetailsPanelV2View.mScrollbar_ = nil;
UIComItemDetailsPanelV2View.mScrollbar_ = nil;
UIComItemDetailsPanelV2View.mList_EquipAttribute = nil;
UIComItemDetailsPanelV2View.mList_WeaponAttribute = nil;
UIComItemDetailsPanelV2View.mList_Attribute = nil;
UIComItemDetailsPanelV2View.mList_WeaponParts = nil;
UIComItemDetailsPanelV2View.mList_Item = nil;
UIComItemDetailsPanelV2View.mTrans_Equip = nil;
UIComItemDetailsPanelV2View.mTrans_Bg = nil;
UIComItemDetailsPanelV2View.mTrans_Icon = nil;
UIComItemDetailsPanelV2View.mTrans_NumRight = nil;
UIComItemDetailsPanelV2View.mTrans_Line = nil;
UIComItemDetailsPanelV2View.mTrans_Weapon = nil;
UIComItemDetailsPanelV2View.mTrans_WeaponParts = nil;
UIComItemDetailsPanelV2View.mTrans_Item = nil;
UIComItemDetailsPanelV2View.mTrans_Time = nil;
UIComItemDetailsPanelV2View.mTrans_NextTime = nil;
UIComItemDetailsPanelV2View.mTrans_AllTime = nil;
UIComItemDetailsPanelV2View.mTrans_Max = nil;
UIComItemDetailsPanelV2View.mTrans_Num = nil;

--- 体力相关
UIComItemDetailsPanelV2View.staminaRegainAmount = nil
UIComItemDetailsPanelV2View.staminaRegainInterval = nil

-- 获取途径界面
UIComItemDetailsPanelV2View.HowToGetPanel = nil

UIComItemDetailsPanelV2View.subProp = {}
UIComItemDetailsPanelV2View.getWayList = {};
UIComItemDetailsPanelV2View.attributeList = {}
UIComItemDetailsPanelV2View.equipSetList = {}

UIComItemDetailsPanelV2View.StaminaType = GlobalConfig.ItemType.StaminaType
UIComItemDetailsPanelV2View.GunType = GlobalConfig.ItemType.GunType
UIComItemDetailsPanelV2View.EquipmentType = GlobalConfig.ItemType.EquipmentType
UIComItemDetailsPanelV2View.WeaponType = GlobalConfig.ItemType.Weapon
UIComItemDetailsPanelV2View.WeaponPartType = GlobalConfig.ItemType.WeaponPart
UIComItemDetailsPanelV2View.ItemShowType =
{
	NormalItemType = 1,
	StaminaType = 2,
	GunType = 3,
	EquipmentType = 4,
	WeaponType = 5,
	WeaponPart = 6
}

function UIComItemDetailsPanelV2View:__InitCtrl()

	self.mBtn_BgClose = self:GetButton("Root/GrpBg/Btn_Close");
	self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpBg/GrpTop/GrpClose/Btn_Close");
	self.mImage_EquipIcon = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipIcon/Img_Icon");
	self.mImage_Pos = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpEquipNum/Img_Icon");
	self.mImage_EquipBase = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpQualityLine/Img_Line");
	self.mImg_IconIcon = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/GrpList/Trans_GrpIcon/Img_Icon");
	self.mImage_WeaponIcon = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponIcon/Img_Icon");
	self.mImage_WeaponBase = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpQualityLine/Img_Line");
	self.mImg_WeaponPartsIcon = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpWeaponPartsIcon/Img_Icon");
	self.mImg_WeaponPartsLine = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpWeaponPartsInfo/GrpQualityLine/Img_Line");
	self.mImage_IconImage = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemIcon/Img_Icon");
	self.mImage_ItemRate = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpQualityLine/Img_Line");
	self.mText_ = self:GetText("Root/GrpDialog/GrpBg/Text");
	self.mText_TopTitle = self:GetText("Root/GrpDialog/GrpBg/GrpTop/GrpText/Text_Name");
	self.mText_EquipName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpEquipInfo/Text_Name");
	self.mText_MainAttributeName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/GrpList/Text_Name");
	self.mText_MainAttributeNum = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/Text_Num");
	self.mText_NumNow = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/Trans_GrpNumRight/Text_NumNow");
	self.mText_NumAfter = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/Trans_GrpNumRight/Text_NumAfter");
	self.mText_WeaponName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpTextName/Text_Name");
	self.mText_WeaponTypeName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpType/Text_Name");
	self.mText_WeaponPartsName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpWeaponPartsInfo/GrpTextName/Text_Name");
	self.mText_WeaponPartsTypeName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpWeaponPartsInfo/GrpType/Text_Name");
	self.mText_WeaponPartsInfo = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpWeaponPartsInfo/GrpTextInfo/Text_Name");
	self.mText_WeaponPartsAttr = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpContentList/Viewport/Content/Text_Description");
	self.mText_ItemName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpTextName/Text_Name");
	self.mText_Description = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpContentList/Viewport/Content/GrpTextDescription/Text_Description");
	self.mText_ = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpContentList/Viewport/Content/GrpTextAccess/Text");
	self.mText_NextTimeNum = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime/Trans_GrpNextTime/ImgBg/Text_Num");
	self.mText_NextAdd = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime/Trans_GrpNextTime/Text_Time");
	self.mText_AllTime_Num = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime/Trans_GrpAllTime/ImgBg/Text_Num");
	self.mText_AllAdd = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime/Trans_GrpAllTime/Text_Time");
	self.mText_Max = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime/Trans_GrpMax/ImgBg/Text");
	self.mText_CountName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpNum/GrpText/TextName");
	self.mText_Count = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpNum/GrpText/Text_Num");
	self.mContent_Attribute = self:GetVerticalLayoutGroup("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content");
	self.mContent_AttributeAttribute = self:GetVerticalLayoutGroup("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpAttributeList/Viewport/Content");
	self.mContent_AttributeAttributeAttribute = self:GetVerticalLayoutGroup("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpWeaponPartsInfo/GrpAttributeList/Viewport/Content");
	self.mContent_WeaponPartsAttr = self:GetVerticalLayoutGroup("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpContentList/Viewport/Content");
	self.mContent_ = self:GetVerticalLayoutGroup("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpContentList/Viewport/Content");
	self.mScrollbar_Attribute = self:GetScrollbar("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Scrollbar");
	self.mScrollbar_AttributeAttribute = self:GetScrollbar("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpAttributeList/Scrollbar");
	self.mScrollbar_AttributeAttributeAttribute = self:GetScrollbar("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpWeaponPartsInfo/GrpAttributeList/Scrollbar");
	self.mScrollbar_ = self:GetScrollbar("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpContentList/Scrollbar");
	self.mScrollbar_ = self:GetScrollbar("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpContentList/Scrollbar");
	self.mList_EquipAttribute = self:GetScrollRect("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList");
	self.mList_WeaponAttribute = self:GetScrollRect("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpAttributeList");
	self.mList_Attribute = self:GetScrollRect("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpWeaponPartsInfo/GrpAttributeList");
	self.mList_WeaponParts = self:GetScrollRect("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpContentList");
	self.mList_Item = self:GetScrollRect("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpContentList");
	self.mTrans_Equip = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpEquip");
	self.mTrans_Bg = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/Trans_GrpBg");
	self.mTrans_Icon = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/GrpList/Trans_GrpIcon");
	self.mTrans_NumRight = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/Trans_GrpNumRight");
	self.mTrans_Line = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute/AttributeMain/Trans_GrpLine");
	self.mTrans_Weapon = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpWeapon");
	self.mTrans_WeaponParts = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts");
	self.mTrans_ItemDetailView = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem");
	self.mTrans_TimeLeft = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime");
	self.mTrans_NextTime = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime/Trans_GrpNextTime");
	self.mTrans_AllTime = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime/Trans_GrpAllTime");
	self.mText_Full = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem/Trans_GrpTime/Trans_GrpMax");
	self.mTrans_Count = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpNum");
	self.mTrans_AccessTitle = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpContentList/Viewport/Content/GrpTextAccess")
	self.mTrans_AccessList=self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpItem/GrpItemInfo/GrpContentList/Viewport/Content/GrpAccessList")
	self.mTrans_EquipSub = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpAttribute")
	self.mTrans_EquipSkill = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpEquip/GrpEquipInfo/GrpAttributeList/Viewport/Content/GrpSkill")
	self.mTrans_WeaponSub = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpAttributeList/Viewport/Content/GrpAttribute")
	self.mTrans_WeaponSkill = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpAttributeList/Viewport/Content/GrpSkill")
	self.mImage_WeaponElement = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpWeapon/GrpWeaponInfo/GrpElement/ComElementItemV2/Image_ElementIcon")
	self.mTrans_WeaponPartsAttr = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpWeaponParts/GrpWeaponPartsInfo/GrpAttributeList/Viewport/Content/GrpAttribute")
	self.StarList = {}

	self:InitEquipSetList()
end

--@@ GF Auto Gen Block End

function UIComItemDetailsPanelV2View:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = self.OnCloseClick
	UIUtils.GetButtonListener(self.mBtn_BgClose.gameObject).onClick = self.OnCloseClick
end

function UIComItemDetailsPanelV2View:InitEquipSetList()
	for i = 1, 2 do
		local item = self:InitEquipSet(self.mTrans_EquipSkill)
		table.insert(self.equipSetList, item)
	end
end

function UIComItemDetailsPanelV2View:InitEquipSet(parent)
	local equipSet = UIEquipSetItem.New()
	equipSet:InitCtrl(parent)

	return equipSet
end

--@@ GF Auto Gen Block End

function UIComItemDetailsPanelV2View:InitCtrl(root)

	self:SetRoot(root)

	self:__InitCtrl()

	UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = self.OnCloseClick
	UIUtils.GetButtonListener(self.mBtn_BgClose.gameObject).onClick = self.OnCloseClick
end

function UIComItemDetailsPanelV2View.OnCloseClick(gameObject)
	setactive(self.mUIRoot.gameObject, false)
end

function UIComItemDetailsPanelV2View:GetTableData(tableId)
	return TableData.GetItemData(tableId)
end

function UIComItemDetailsPanelV2View.OnHowToGetClicked(gameObject)
	self = UIComItemDetailsPanelV2View

	if not self.HowToGetPanel then
		local uiRepoItem = UIGetWayView:New()
		uiRepoItem:InitCtrl(self.mUIRoot)
		self.HowToGetPanel = uiRepoItem
	end
	self.HowToGetPanel:SetData(self.mData.id)
end


function UIComItemDetailsPanelV2View:CheckItemType(itemData)
	if itemData.type == UIComItemDetailsPanelV2View.GunType then
		return UIComItemDetailsPanelV2View.ItemShowType.GunType
	elseif itemData.type == UIComItemDetailsPanelV2View.EquipmentType then
		return UIComItemDetailsPanelV2View.ItemShowType.EquipmentType
	elseif itemData.type == UIComItemDetailsPanelV2View.WeaponType then
		return UIComItemDetailsPanelV2View.ItemShowType.WeaponType
	elseif itemData.type == UIComItemDetailsPanelV2View.StaminaType then
		return UIComItemDetailsPanelV2View.ItemShowType.NormalItemType
	elseif itemData.type == UIComItemDetailsPanelV2View.WeaponPartType then
		return UIComItemDetailsPanelV2View.ItemShowType.WeaponPart
	else
		return UIComItemDetailsPanelV2View.ItemShowType.NormalItemType
	end
end

function UIComItemDetailsPanelV2View:ShowItemDetail(itemData, num, needGetWay, showTime, relateId)
	self.mData = itemData
	self.mCount = num
	self.mNeedGetWay = needGetWay
	self.mShowTime = showTime == nil and false or showTime
	self.mRelateId = relateId or 0;
	setactive(self.mUIRoot.gameObject, true)
	local isShowGet = self.mData.HasApproach and self.mNeedGetWay;
	isShowGet = isShowGet~=nil and isShowGet or false;

	if(needGetWay) then
		setactive(self.mTrans_AccessTitle,true)
		setactive(self.mTrans_AccessList,true)
		self:ShowGet();
	else
		setactive(self.mTrans_AccessTitle,false);
		setactive(self.mTrans_AccessList,false)
	end

	setactive(self.mText_Count.gameObject, self.mCount ~= nil and self.mCount >= 0 )
	setactive(self.mText_CountName.transform.parent, self.mCount ~= nil and self.mCount >= 0)
	local type = self:CheckItemType(itemData)
	setactive(self.mTrans_ItemDetailView.gameObject, type == UIComItemDetailsPanelV2View.ItemShowType.NormalItemType)
	setactive(self.mTrans_Equip.gameObject, type == UIComItemDetailsPanelV2View.ItemShowType.EquipmentType)
	setactive(self.mTrans_Weapon.gameObject, type == UIComItemDetailsPanelV2View.ItemShowType.WeaponType)
	setactive(self.mTrans_WeaponParts.gameObject, type == UIComItemDetailsPanelV2View.ItemShowType.WeaponPart)
	if type == UIComItemDetailsPanelV2View.ItemShowType.NormalItemType then
		self.mText_TopTitle.text = TableData.GetHintById(101)
		self:ShowItem()
	elseif type == UIComItemDetailsPanelV2View.ItemShowType.EquipmentType then
		self.mText_TopTitle.text = TableData.GetHintById(102)
		self:ShowEquipment()
	elseif type == UIComItemDetailsPanelV2View.ItemShowType.GunType then
		self:ShowGun()
	elseif type == UIComItemDetailsPanelV2View.ItemShowType.WeaponType then
		self.mText_TopTitle.text = TableData.GetHintById(103)
		self:ShowWeapon()
	elseif type == UIComItemDetailsPanelV2View.ItemShowType.WeaponPart then
		self.mText_TopTitle.text = TableData.GetHintById(101)
		self:ShowWeaponPart()
	end

	self.mItemShowType = type
end

function UIComItemDetailsPanelV2View:ShowGet()
	local data = self.mData

	if(data.get_list == "") then
		setactive(self.mTrans_AccessTitle,false)
		setactive(self.mTrans_AccessList,false)
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


function UIComItemDetailsPanelV2View:ShowItem()
	self.mText_ItemName.text = self.mData.name.str
	if self.mCount and tonumber(self.mCount) >= 0 then
		self.mText_Count.text = tostring(self.mCount)
	else
		self.mText_Count.text = ""
	end
	self.mText_Description.text = self.mData.introduction.str
	self.mImage_IconImage.sprite = UIUtils.GetIconSprite("Icon/" .. self.mData.icon_path, self.mData.icon)
	self.mImage_ItemRate.color = TableData.GetGlobalGun_Quality_Color2(self.mData.rank)
	setactive(self.mTrans_TimeLeft, self.mData.type == UIComItemDetailsPanelV2View.StaminaType)
	if self.mData.type == UIComItemDetailsPanelV2View.StaminaType then
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

function UIComItemDetailsPanelV2View:ShowGun()
	self.mText_ItemName.text = self.mData.name.str
	self.mText_Description.text = self.mData.description.str

	self.mImage_ItemRate.color = TableData.GetGlobalGun_Quality_Color1(self.mData.rank)
end

function UIComItemDetailsPanelV2View:ShowWeapon()
	self.mText_WeaponName.text = self.mData.name.str
	self.mText_Description.text = self.mData.description.str


	local weaponData = TableData.listGunWeaponDatas:GetDataById(tonumber(self.mData.args[0]))
	local rankColor = TableData.GetGlobalGun_Quality_Color2(weaponData.rank)
	local weaponTypeData = TableData.listGunWeaponTypeDatas:GetDataById(weaponData.type)

	self.mText_WeaponTypeName.text = weaponTypeData.name.str
	self.mImage_WeaponIcon.sprite = IconUtils.GetWeaponNormalSprite(weaponData.res_code)
	self.mImage_WeaponBase.color = rankColor

	local elementData = TableData.listLanguageElementDatas:GetDataById(weaponData.Element)
	self.mImage_WeaponElement.sprite = IconUtils.GetElementIcon(elementData.icon)

	local cmdData = NetCmdWeaponData:GetWeaponById(self.mRelateId)
	self:UpdateWeaponAttribute(cmdData,weaponData);

	if(weaponData.skill ~= 0) then
		local normalSkillItem = UIWeaponSkillItem.New()
		normalSkillItem:InitCtrl(self.mTrans_WeaponSkill)
		normalSkillItem:SetData(weaponData.skill)
	end

	if(weaponData.buff_skill ~= 0) then
		local elementSkillItem = UIWeaponSkillItem.New()
		elementSkillItem:InitCtrl(self.mTrans_WeaponSkill)
		elementSkillItem:SetData(weaponData.buff_skill)
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

function UIComItemDetailsPanelV2View:ShowWeaponPart()
	local weaponPartData = TableData.listWeaponPartDatas:GetDataById(tonumber(self.mData.args[0]))
	local weaponPartTypeData = TableData.listWeaponPartTypeDatas:GetDataById(weaponPartData.type)
	self.mText_WeaponPartsName.text = weaponPartData.name.str;
	self.mText_WeaponPartsTypeName.text = weaponPartTypeData.name;
	self.mText_WeaponPartsAttr.text = self.mData.introduction.str
	self.mImg_WeaponPartsIcon.sprite = IconUtils.GetWeaponPartIcon(weaponPartData.icon .. "_S")
	self.mImg_WeaponPartsLine.color = TableData.GetGlobalGun_Quality_Color2(self.mData.rank)
	local text = TableData.GetHintById(40014);
	for i = 0, weaponPartTypeData.weapon_type.Count - 1 do
		if i ~= 0 then
			text = text .. "、"
		end
		text = text .. TableData.listGunWeaponTypeDatas:GetDataById(weaponPartTypeData.weapon_type[i]).name.str
	end
	self.mText_WeaponPartsInfo.text = text;

	local attributeData = TableData.GetPropertyDataByName(weaponPartData.part_ability, 1);
	if(self.mWeaponPartsAttr == nil) then
		self.mWeaponPartsAttr = PropertyItemS:New()
		self.mWeaponPartsAttr:InitCtrl(self.mTrans_WeaponPartsAttr)
		self.mWeaponPartsAttr.mUIRoot.transform:SetSiblingIndex(0)
	end

	self.mWeaponPartsAttr:SetData(attributeData, weaponPartData.part_ability_ini, false, ColorUtils.BlackColor, false)
	self.mWeaponPartsAttr:SetNameColor(ColorUtils.BlackColor)
	self.mWeaponPartsAttr:SetTextSize(24)
end

function UIComItemDetailsPanelV2View:UpdateWeaponAttribute(data,stcData)
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
		item:SetData(attrList[i].propData, attrList[i].value,false, attrList[i].propData.statue == 2 and ColorUtils.OrangeColor or ColorUtils.BlackColor, false)
	end
end


function UIComItemDetailsPanelV2View:ShowEquipment()
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

function UIComItemDetailsPanelV2View:UpdateEquipMainAttribute(data)
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


function UIComItemDetailsPanelV2View:UpdateEquipSubAttribute(data)
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

function UIComItemDetailsPanelV2View:ShowStamina()
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

function UIComItemDetailsPanelV2View:UpdateStaminaContent()
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

function UIComItemDetailsPanelV2View:UpdateDetailContent()
	if self.mItemShowType == UIComItemDetailsPanelV2View.ItemShowType.NormalItemType then
		local count = 0
		if self.mData.type == 1 then
			count = NetCmdItemData:GetResItemCount(self.mData.id)
		elseif self.mData.type == 3 then
			count = NetCmdItemData:GetItemCount(self.mData.id)
		elseif self.mData.type == UIComItemDetailsPanelV2View.StaminaType then
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

function UIComItemDetailsPanelV2View:SetStars(count)
	for i, star in ipairs(self.StarList) do
		setactive(star, count >= i)
	end
end

function UIComItemDetailsPanelV2View:onRelease()
	self.HowToGetPanel = nil
	self.StarList = {}
	self.MainProp = nil
	self.subProp = {}
	self.attributeList = {}
	self.detailBrief = nil
	self.equipSetList={}
	self.mWeaponPartsAttr = nil
end