require("UI.UIBaseCtrl")

---@class UIGashaponCardDisplayItemV2 : UIBaseCtrl
UIGashaponCardDisplayItemV2 = class("UIGashaponCardDisplayItemV2", UIBaseCtrl);
UIGashaponCardDisplayItemV2.__index = UIGashaponCardDisplayItemV2
--@@ GF Auto Gen Block Begin
UIGashaponCardDisplayItemV2.mImg_Chr = nil;
UIGashaponCardDisplayItemV2.mImg_Weapon = nil;
UIGashaponCardDisplayItemV2.mImg_QualityFrame = nil;
UIGashaponCardDisplayItemV2.mImage_Glow = nil;
UIGashaponCardDisplayItemV2.mText_New = nil;
UIGashaponCardDisplayItemV2.mTrans_Character = nil;
UIGashaponCardDisplayItemV2.mTrans_Weapon = nil;
UIGashaponCardDisplayItemV2.mImage_ElementBg = nil;
UIGashaponCardDisplayItemV2.mTrans_NewTag = nil;
UIGashaponCardDisplayItemV2.mTrans_Again = nil;

function UIGashaponCardDisplayItemV2:__InitCtrl()
	self.animator = self:GetRootAnimator()
	self.mImg_Character = self:GetImage("Root/GrpAvater/Trans_Img_Chr");
	self.mImg_Weapon = self:GetImage("Root/GrpAvater/Trans_Img_Weapon");
	self.mImg_QualityFrame = self:GetImage("Root/GrpFrame/Img_QualityFrame");
	self.mImage_Glow = self:GetImage("Root/GrpFrame/Img_Halo");
	self.mText_New = self:GetText("Root/Trans_GrpNew/NewText");

	self.mTrans_Character = self:GetRectTransform("Root/GrpAvater/Trans_Img_Chr");
	self.mTrans_Weapon = self:GetRectTransform("Root/GrpAvater/Trans_Img_Weapon");
	self.mTrans_GrpDuty = self:GetRectTransform("Root/GrpItem/GrpIcon/Trans_GrpDuty");
	self.mTrans_GrpElement = self:GetRectTransform("Root/GrpItem/GrpIcon/Trans_GrpElement");
	self.mTrans_NewTag = self:GetRectTransform("Root/Trans_GrpNew");
	self.mTrans_Star = self:GetRectTransform("Root/GrpItem/GrpStar");
	self.mTrans_Again = self:GetRectTransform("Root/GrpItem/GrpIcon/AgainItem");
	self.mTrans_AgainItem = self:GetRectTransform("Root/GrpItem/GrpIcon/AgainItem/GrpItem");
	self.mTrans_Blue = self:GetRectTransform("Root/FX_Blue");
	self.mTrans_Purple = self:GetRectTransform("Root/FX_Purple");
	self.mTrans_Gold = self:GetRectTransform("Root/FX_glod");
	self.mTrans_Root = self:GetRectTransform("Root");
end

--@@ GF Auto Gen Block End

function UIGashaponCardDisplayItemV2:InitCtrl(root, index)

	self:SetRoot(root);

	self:__InitCtrl();
	self.mStartList = {}
	for i = 1, 5 do
		local starObj = instantiate(UIUtils.GetGizmosPrefab("Gashapon/ComStarV2.prefab", self))
		CS.LuaUIUtils.SetParent(starObj, self.mTrans_Star.gameObject)
		table.insert(self.mStartList, CS.LuaUIUtils.GetRectTransform(starObj.transform))
	end
	local elementObj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComElementItemV2.prefab", self))
	self.mTrans_IconElement = self:GetRectTransform("Root/GrpItem/GrpIcon/Trans_GrpElement/GrpElement");
	CS.LuaUIUtils.SetParent(elementObj, self.mTrans_IconElement.gameObject, true)
	self.mImg_ElementIcon = UIUtils.GetImage(elementObj, "Image_ElementIcon")
	local delayAni = getcomponent(root, typeof(CS.DelayAni))
	setactive(delayAni.root, false)

	local dutyObj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComDutyItemV2.prefab", self))
	self:GetRectTransform("Root/GrpItem/GrpIcon/Trans_GrpDuty/GrpDuty");
	self.mTrans_IconDuty = self:GetRectTransform("Root/GrpItem/GrpIcon/Trans_GrpDuty/GrpDuty");
	self.mImg_DutyIcon = UIUtils.GetImage(dutyObj, "Img_DutyIcon")
	CS.LuaUIUtils.SetParent(dutyObj, self.mTrans_IconDuty.gameObject, true)

	self.timer = TimerSys:DelayCall(delayAni.delayTime * index, function ()
		setactive(delayAni.root, true)
		self.animator:Play(delayAni.AniName, 0, 0)
		self.animator:SetInteger("Color", self.mStcData.rank)
		self.timer = nil
	end )
end

function UIGashaponCardDisplayItemV2:InitData(data)
	self.mData = data;
	self.mStcData = TableData.GetItemData(data.ItemId);
	if(self.mStcData == nil) then
		gferror("没有找到id是"..data.ItemId.."的道具");
	else
		self:InitItemInfo();
	end
end

function UIGashaponCardDisplayItemV2:InitItemInfo()
	local name = self.mStcData.name;
	local icon = self.mStcData.icon;
	local rank = TableData.GlobalSystemData.QualityStar[self.mStcData.rank - 1];

	--if(self.mStcData.type == 1) then
	--	local gunData = TableData.GetGunData(1001);
	--	self.mImg_Character.sprite = UIUtils.GetIconTexture("CharacterRes/"..gunData.code,"Gacha");
	--	setactive(self.mTrans_Character,true);
	--	setactive(self.mTrans_Weapon,false);
	--
	--else
	if (self.mStcData.type == 4) then
		local gunData = TableData.GetGunData(tonumber(self.mStcData.args[0]));
		self.mImg_Character.sprite = IconUtils.GetCharacterGachaSprite(gunData.code);
		setactive(self.mTrans_Character,true);
		setactive(self.mTrans_Weapon,false);

		--elseif(self.mStcData.type == 3) then
		--	self.mImg_Weapon.sprite = UIUtils.GetIconTexture("Icon/"..self.mStcData.IconPath,icon);
		--	setactive(self.mTrans_Character,false);
		--	setactive(self.mTrans_Weapon,true);

	elseif(self.mStcData.type == 8) then
		self.mImg_Weapon.sprite = IconUtils.GetWeaponNormalSprite(icon);
		setactive(self.mTrans_Character,false);
		setactive(self.mTrans_Weapon,true);

		--elseif(self.mStcData.type == 5) then
		--	self.mImg_Weapon.sprite = UIUtils.GetIconTexture("Icon/"..self.mStcData.IconPath,icon);
		--	setactive(self.mTrans_Character,false);
		--	setactive(self.mTrans_Weapon,true);

		--elseif(self.mStcData.type == 12) then
		--local gunData = TableData.GetGunData(tonumber(self.mStcData.args[0]));
		--self.mImg_Character.sprite = UIUtils.GetIconTexture("CharacterRes/"..gunData.code,"Gacha");
		--
		--setactive(self.mTrans_Character,true);
		--setactive(self.mTrans_Weapon,false);
	else
		gfwarning("Invalid type !!!!!!!!!!!!!!!" .. self.mStcData.type)
	end

	local rankColor = TableData.GetGlobalGun_Quality_Color2(rank);

	self.mImage_Glow.color = Color(rankColor.r,rankColor.g,rankColor.b,0);

	for i = 1, #self.mStartList do
		setactive(self.mStartList[i],false);
	end

	for i = 1, rank do
		setactive(self.mStartList[i],true);
	end
	self.rank = rank
	self.animator:SetInteger("Color", self.mStcData.rank)

	self:ConvertChipAnim();
end

function UIGashaponCardDisplayItemV2:ConvertChipAnim()

	if(self.mData.ItemNum == 0) then
		setactive(self.mTrans_Again,true);
		setactive(self.mTrans_NewTag,false);
		local sort = self.mData.ExtItems.orderBy
		for key, value in pairs(self.mData.ExtItems) do
			if(key <= 100) then
				---@type UICommonItem
				local consumeItem = UICommonItem.New();
				consumeItem:InitCtrl(self.mTrans_AgainItem);
				consumeItem:SetItemData(key,value,false);
			end
		end

		for key, value in pairs(self.mData.ExtItems) do
			if(key > 100) then
				---@type UICommonItem
				local consumeItem = UICommonItem.New();
				consumeItem:InitCtrl(self.mTrans_AgainItem);
				consumeItem:SetItemData(key,value,false);
			end
		end

		if(self.mStcData.type ~= 8) then
			local id = self.mStcData.Args[0];
			local gunData = TableData.listGunDatas:GetDataById(id)
			local dutyData = TableData.listGunDutyDatas:GetDataById(gunData.duty)
			setactive(self.mTrans_GrpDuty,true);
			setactive(self.mTrans_GrpElement,false);
			self.mImg_DutyIcon.sprite = IconUtils.GetGunTypeSprite(dutyData.icon)
			self.delayCall = TimerSys:DelayCall(2, function()
				setactive(self.mTrans_GrpDuty,false);
			end)
		end
	else
		setactive(self.mTrans_Again,false);
		setactive(self.mTrans_NewTag,true);

		local id = self.mStcData.Args[0];

		if(self.mStcData.type ~= 8) then
			local gunData = TableData.listGunDatas:GetDataById(id)
			local dutyData = TableData.listGunDutyDatas:GetDataById(gunData.duty)
			setactive(self.mTrans_GrpDuty,true);
			setactive(self.mTrans_GrpElement,false);
			self.mImg_DutyIcon.sprite = IconUtils.GetGunTypeSprite(dutyData.icon)
		else
			local weaponData = TableData.listGunWeaponDatas:GetDataById(id)
			local elementData = TableData.listLanguageElementDatas:GetDataById(weaponData.element)
			self.mImg_ElementIcon.sprite = IconUtils.GetElementIcon(elementData.icon)
			setactive(self.mTrans_NewTag, NetCmdIllustrationData:CheckItemIsFirstTime(self.mStcData.type, weaponData.id, true))
			setactive(self.mTrans_GrpDuty,false);
			setactive(self.mTrans_GrpElement,true);
		end
	end
end



function UIGashaponCardDisplayItemV2:SetIndex(index)
	self.mIndex = index;
end

function UIGashaponCardDisplayItemV2:StopTimer()
	if self.timer ~= nil then
		self.timer:Stop();
	end
	self.timer = nil;
	if self.delayCall ~= nil then
		self.delayCall:Stop();
	end
	self.delayCall = nil;
end