require("UI.UIBaseCtrl")

ExchangeGoodsItem = class("ExchangeGoodsItem", UIBaseCtrl);
ExchangeGoodsItem.__index = ExchangeGoodsItem
--@@ GF Auto Gen Block Begin
ExchangeGoodsItem.mImage_Rank = nil;
ExchangeGoodsItem.mImage_IconImage = nil;
ExchangeGoodsItem.mImage_Head = nil;
ExchangeGoodsItem.mImage_GoodsRate = nil;
ExchangeGoodsItem.mText_Name = nil;
ExchangeGoodsItem.mText_AmountNumber = nil;
ExchangeGoodsItem.mText_PriceNumber = nil;
ExchangeGoodsItem.mText_refreshtime = nil;
ExchangeGoodsItem.mTrans_HeadIcon = nil;
ExchangeGoodsItem.mTrans_EquipIcon = nil;
ExchangeGoodsItem.mImage_EquipIcon = nil;
ExchangeGoodsItem.mTrans_base_arrow = nil;
ExchangeGoodsItem.mTrans_Recommend = nil;
ExchangeGoodsItem.mTrans_RecommendUnavailableMask = nil;
ExchangeGoodsItem.mTrans_UnavailableMask = nil;
ExchangeGoodsItem.mTrans_Refreshtime = nil;
ExchangeGoodsItem.mTrans_New = nil;
ExchangeGoodsItem.mImage_RankLine = nil;

ExchangeGoodsItem.mTrans_WeaponIcon = nil;
ExchangeGoodsItem.mImage_WeaponIcon = nil;

ExchangeGoodsItem.mTrans_EquipIcon = nil;
ExchangeGoodsItem.mImage_EquipIcon = nil;

ExchangeGoodsItem.mTrans_Pos =nil;
ExchangeGoodsItem.mImage_Pos =nil;

ExchangeGoodsItem.mImagePrice = nil;
ExchangeGoodsItem.mTrans_MonthLeft = nil;
ExchangeGoodsItem.mTrans_GrpElement = nil;
ExchangeGoodsItem.mImage_ElementIcon = nil;

function ExchangeGoodsItem:__InitCtrl()

	self.mImage_Rank = self:GetImage("GrpQualityCor/GrpRightTop/Img_RightTop");
	self.mImage_RankLine = self:GetImage("GrpQualityCor/GrpBottomLine/Img_BottomLine");
	self.mImage_IconImage = self:GetImage("GrpIcon/GrpItemIcon/Img_Icon");
	self.mTrans_IconImage = self:GetRectTransform("GrpIcon/GrpItemIcon");
	--self.mImage_Head = self:GetImage("GoodsIcon/Trans_HeadIcon/HeadBG/mask/Image_Head");
	--self.mImage_GoodsRate = self:GetImage("Image_GoodsRate");
	self.mText_Name = self:GetText("GrpTextLeftAndName/GrpTexName/Text_Name");
	self.mText_AmountNumber = self:GetText("GrpTextLeftAndName/GrpMonthLeft/ImgBg/Text_LeftNum");
	self.mText_PriceNumber = self:GetText("GrpItemCost/Trans_GrpOn/GrpCost/Text_CostNum");
	self.mText_refreshtime = self:GetText("Trans_Refreshtime/Text_refreshtime");
	--self.mTrans_HeadIcon = self:GetRectTransform("GoodsIcon/Trans_HeadIcon");

	--self.mTrans_base_arrow = self:GetRectTransform("GoodsIcon/Trans_EquipIcon/EquipIconBase/UI_base/Trans_arrow");
	self.mTrans_Recommend = self:GetRectTransform("GrpTopLeft");
	--self.mTrans_RecommendUnavailableMask = self:GetRectTransform("Trans_Recommend/Trans_RecommendUnavailableMask");
	self.mTrans_UnavailableMask = self:GetRectTransform("GrpItemCost/Trans_GrpOff");
	self.mTrans_Refreshtime = self:GetRectTransform("Trans_Refreshtime");
	self.mTrans_New = self:GetRectTransform("Trans_New");

	self.mTrans_WeaponIcon = self:GetRectTransform("GrpIcon/GrpWeaponcon");
	self.mImage_WeaponIcon = self:GetImage("GrpIcon/GrpWeaponcon/Img_Icon");

	self.mTrans_EquipIcon = self:GetRectTransform("GrpIcon/GrpEquipIcon");
	self.mImage_EquipIcon = self:GetImage("GrpIcon/GrpEquipIcon/Img_Icon");

	self.mTrans_Pos = self:GetRectTransform("GrpTextLeftAndName/GrpTexName/Trans_GrpEquipNum");
	self.mImage_Pos= self:GetImage("GrpTextLeftAndName/GrpTexName/Trans_GrpEquipNum/Img_Icon");

	self.mImagePrice = self:GetImage("GrpItemCost/Trans_GrpOn/GrpCost/GrpIcon/Img_Icon");

	self.mTrans_MonthLeft = self:GetRectTransform("GrpTextLeftAndName/GrpMonthLeft");
	self.mTrans_GrpElement = self:GetRectTransform("GrpTextLeftAndName/GrpTexName/Trans_GrpElement");

	self.mImage_ElementIcon = self:GetImage("GrpTextLeftAndName/GrpTexName/Trans_GrpElement/ComElementItemV2/Image_ElementIcon");
end

--@@ GF Auto Gen Block End

ExchangeGoodsItem.mData = nil;


function ExchangeGoodsItem:InitCtrl(parent)

	local obj=instantiate(UIUtils.GetGizmosPrefab("StoreExchange/StoreExchangeListItemV2.prefab",self));
	setparent(parent,obj.transform);
	obj.transform.localScale = vectorone;
	obj.transform.localPosition = vectorzero

	self:SetRoot(obj.transform);

	self:__InitCtrl();



end

function ExchangeGoodsItem:InitData(data)
	self.mData = data;

	self.mText_Name.text = data.name;
	local num = tonumber(data.price);
	self.mText_PriceNumber.text = formatnum(num);

	--if(data.limit == 0 and data.hasRefreshTime == false) then
	if(data.limit == 0) then
		setactive(self.mTrans_MonthLeft.gameObject,false)
	else
		setactive(self.mTrans_MonthLeft.gameObject,true)
		self.mText_AmountNumber.text = string_format(TableData.GetHintById(808),data.remain_times);
	end

	if(data.IsRecommend) then
		setactive(self.mTrans_Recommend.gameObject, true);
	else
		setactive(self.mTrans_Recommend.gameObject, false);
	end

	--if(data.remain_times == 0 and (data.limit ~= 0 or data.IsSpecial)) then
	if(data.remain_times == 0 and data.limit ~= 0) then
		setactive(self.mTrans_UnavailableMask.gameObject, true);
	else
		setactive(self.mTrans_UnavailableMask.gameObject, false);
	end



	if(data.price_type > 0) then
		local stcData = TableData.GetItemData(data.price_type);

		if(stcData == nil) then
			gferror("未知的PriceType"..data.price_type..",Item表里没有该ID");
		end
		self.mImagePrice.sprite = UIUtils.GetIconSprite("Icon/Item",stcData.icon);
	end

	self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(data.rank);
	self.mImage_RankLine.color = TableData.GetGlobalGun_Quality_Color2(data.rank);
	-- if(data.refresh_time ~= nil) then
	-- 	gfdebug( data.refresh_time)
	-- 	setactive(self.mTrans_Refreshtime.gameObject,true);
	-- 	--self.mText_refreshtime.text = data.refresh_time.."后刷新购买次数";
	-- 	self.StartItemCountDown({data,self});
	-- end



	local stcData = TableData.GetItemData(data.frame,true);
	setactive(self.mTrans_Pos.gameObject,false)
	setactive(self.mTrans_GrpElement.gameObject,false)
	if data.frame ~= 0 and stcData ~= nil and stcData.type == 5 then
		setactive(self.mTrans_EquipIcon.gameObject,true)
		setactive(self.mTrans_WeaponIcon.gameObject,false)
		setactive(self.mTrans_IconImage.gameObject,false)

		--- 模组图标显示
		local equipData = TableData.GetEquipData(stcData.args[0])
		local rankColor = TableData.GetGlobalGun_Quality_Color2(equipData.rank)

		setactive(self.mTrans_Pos.gameObject,true)
		self.mImage_Pos.sprite =  IconUtils.GetEquipNum(equipData.category, true) 

		self.mImage_Rank.color = rankColor;
		self.mImage_RankLine.color = rankColor;
		--- 模组图标显示
		if data.icon ~= nil and data.icon ~= "" then
			--self.mImage_EquipIcon.sprite = IconUtils.GetItemIcon(data.icon)
			self.mImage_EquipIcon.sprite = IconUtils.GetEquipSprite(data.icon)
		else
			self.mImage_EquipIcon.sprite = IconUtils.GetEquipSprite(equipData.res_code);
		end

	elseif data.frame ~= 0 and stcData ~= nil and stcData.type == 8 then  --武器
		setactive(self.mTrans_EquipIcon.gameObject, false)
		setactive(self.mTrans_WeaponIcon.gameObject, true)
		setactive(self.mTrans_IconImage.gameObject, false)

		setactive(self.mTrans_GrpElement.gameObject, true)
		local weaponData = TableData.listGunWeaponDatas:GetDataById(stcData.args[0]);
		if weaponData ~= nil then
			local elementData = TableData.listLanguageElementDatas:GetDataById(weaponData.element);
			self.mImage_ElementIcon.sprite = IconUtils.GetElementIconM(elementData.icon)
			if data.icon ~= nil and data.icon ~= "" then
				self.mImage_WeaponIcon.sprite = IconUtils.GetItemIcon(data.icon)
			else
				self.mImage_WeaponIcon.sprite = IconUtils.GetWeaponNormalSprite(weaponData.res_code)
			end
		end
	else
		setactive(self.mTrans_EquipIcon.gameObject, false)
		setactive(self.mTrans_WeaponIcon.gameObject, false)
		setactive(self.mTrans_IconImage.gameObject, true)
		if data.icon ~= nil and data.icon ~= "" then
			self.mImage_IconImage.sprite = IconUtils.GetItemIcon(data.icon);
		else
			if stcData ~= nil then
				self.mImage_IconImage.sprite = IconUtils.GetItemIconSprite(stcData.id);
			end
		end

	end
end