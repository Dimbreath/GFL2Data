require("UI.UIBaseCtrl")

UIBarrackChrCardItem = class("UIBarrackChrCardItem", UIBaseCtrl)
UIBarrackChrCardItem.__index = UIBarrackChrCardItem
--@@ GF Auto Gen Block Begin
UIBarrackChrCardItem.StarList = {}

UIBarrackChrCardItem.mData = nil
UIBarrackChrCardItem.PrefabPath = "UICommonFramework/ComChrInfoItemV2.prefab"

function UIBarrackChrCardItem:ctor()
	UIBarrackChrCardItem.super.ctor(self)
	self.isUnLock = false
	self.tableData = nil
	self.cmdData = nil
	self.dutyItem = nil
	self.index = 0
end

function UIBarrackChrCardItem:__InitCtrl()
	self.mBtn_Gun = self:GetSelfButton()
	self.mImage_AvatarImage = self:GetImage("GrpContent/GrpChrIcon/Img_Icon")
	self.mImage_Rank = self:GetImage("GrpContent/GrpQualityCor/GrpBottomLine/Img_BottomLine")
	self.mImage_Rank2 = self:GetImage("GrpContent/GrpQualityCor/GrpRightTop/Img_RightTop")
	self.mText_LevelNum = self:GetText("GrpContent/GrpLevel/Text_Level")
	self.mText_DutyName = self:GetText("GrpContent/GrpWeaponType/Text_WeaponName")
	self.mImage_Element = self:GetImage("GrpContent/GrpElement/ComElementItemV2/Image_ElementIcon")
	self.mTrans_Level = self:GetRectTransform("GrpContent/GrpLevel")
	self.mTrans_Duty = self:GetRectTransform("GrpContent/GrpDuty")

	self.mTrans_Fragment = self:GetRectTransform("GrpContent/Trans_GrpFragment")
	self.mText_UnLockNum = self:GetText("GrpContent/Trans_GrpFragment/Text_NumNow")
	self.mText_UnLockTotal = self:GetText("GrpContent/Trans_GrpFragment/Text_NumTotal")

	self.mTrans_Name = self:GetRectTransform("GrpContent/Trans_GrpName")
	self.mText_Name = self:GetText("GrpContent/Trans_GrpName/Text_Name")

	self.mTrans_SelectBlack = self:GetRectTransform("Trans_GrpSelBlack")

	self.mTrans_RedPoint = self:GetRectTransform("GrpContent/Trans_RedPoint")

	self.dutyItem = UICommonDutyItem.New()
	self.dutyItem:InitCtrl(self.mTrans_Duty)
end

function UIBarrackChrCardItem:InitCtrl(parent)
	local itemPrefab = UIUtils.GetGizmosPrefab(self.PrefabPath, self)
	local instObj = instantiate(itemPrefab)

	UIUtils.AddListItem(instObj.gameObject, parent.gameObject)

	self:SetRoot(instObj.transform)
	self:__InitCtrl()
end

function UIBarrackChrCardItem:SetData(gunId, needRedPoint, ItemId, hasTip)
	if gunId then
		self.tableData = TableData.listGunDatas:GetDataById(gunId)
		self.cmdData = NetCmdTeamData:GetGunByID(gunId)
		self.isUnLock = (self.cmdData ~= nil)
		if self.tableData then
			local dutyData = TableData.listGunDutyDatas:GetDataById(self.tableData.duty)
			local avatar = IconUtils.GetCharacterBustSprite(self.tableData.code)
			local color = TableData.GetGlobalGun_Quality_Color2(self.tableData.rank)
			self.mImage_Rank.color = color
			self.mImage_Rank2.color = color
			self.mImage_AvatarImage.sprite = avatar
			self.mText_DutyName.text = dutyData.abbr.str
			self.dutyItem:SetData(dutyData)
		end

		if self.cmdData then
			self.mImage_AvatarImage.color = ColorUtils.StringToColor("FFFFFF")
			self.mText_LevelNum.text = self.cmdData.level
		else
			self.mImage_AvatarImage.color = ColorUtils.StringToColor("808080")
			local itemData = TableData.listItemDatas:GetDataById(self.tableData.core_item_id)
			local curChipNum = NetCmdItemData:GetItemCount(itemData.id)
			local unLockNeedNum = tonumber(self.tableData.unlock_cost)
			self.mText_UnLockNum.text = curChipNum
			self.mText_UnLockTotal.text = "/" .. unLockNeedNum
		end
		setactive(self.mTrans_Level.gameObject, self.cmdData ~= nil)
		setactive(self.mTrans_Fragment, self.cmdData == nil)
		setactive(self.mUIRoot, true)

		if needRedPoint ~= false then
			self:UpdateRedPoint()
		else
			setactive(self.mTrans_RedPoint, false)
		end

		--[[UIUtils.GetButtonListener(self.mBtn_Gun.gameObject).onClick = function()
			if callback then callback(self) end
		end]]
	 	if hasTip == true then
			local itemData = TableData.GetItemData(ItemId)
			TipsManager.Add(self:GetRoot().gameObject,  itemData)
		end
	else
		self.tableData = nil
		self.cmdData = nil
		self.index = 0
		setactive(self.mUIRoot, false)
	end
end

function UIBarrackChrCardItem:SetDisplay(gunId)
	self.tableData = TableData.listGunDatas:GetDataById(gunId)
	local dutyData = TableData.listGunDutyDatas:GetDataById(self.tableData.duty)
	local avatar = IconUtils.GetCharacterBustSprite(self.tableData.code)
	local color = TableData.GetGlobalGun_Quality_Color2(self.tableData.rank)
	self.mImage_Rank.color = color
	self.mImage_Rank2.color = color
	self.mImage_AvatarImage.sprite = avatar
	self.mText_DutyName.text = dutyData.abbr.str
	self.mText_Name.text = self.tableData.name.str
	self.dutyItem:SetData(dutyData)
	setactive(self.mTrans_Level.gameObject, false)
	setactive(self.mTrans_Name.gameObject, true)
end

function UIBarrackChrCardItem:UpdateRedPoint()
	local count = 0
	if self.cmdData then
		count = NetCmdTeamData:UpdateUpgradeRedPoint(self.cmdData)
	else
		count = NetCmdTeamData:UpdateLockRedPoint(self.tableData)
	end
	setactive(self.mTrans_RedPoint, count > 0)
end

function UIBarrackChrCardItem:Enable(enable)
	setactive(self.mUIRoot, enable)
end

function UIBarrackChrCardItem:SetSelect(enable)
	UIUtils.SetInteractive(self.mUIRoot, not enable)
end

function UIBarrackChrCardItem:SetSelectBlack(enable)
	setactive(self.mTrans_SelectBlack, enable)
end
