require("UI.UIBaseView")

UIStoreConfirmPanelView = class("UIStoreConfirmPanelView", UIBaseView);
UIStoreConfirmPanelView.__index = UIStoreConfirmPanelView

--@@ GF Auto Gen Block Begin
UIStoreConfirmPanelView.mBtn_Close = nil;
UIStoreConfirmPanelView.mBtn_Cancel = nil;
UIStoreConfirmPanelView.mBtn_GoodsIcon = nil;
UIStoreConfirmPanelView.mBtn_AmountPlusButton = nil;
UIStoreConfirmPanelView.mBtn_AmountMinusButton = nil;
UIStoreConfirmPanelView.mBtn_AmountMaxButton = nil;
UIStoreConfirmPanelView.mBtn_Buy = nil;
UIStoreConfirmPanelView.mBtn_off = nil;
UIStoreConfirmPanelView.mBtn_DiamondCancel = nil;
UIStoreConfirmPanelView.mBtn_Confirm = nil;
UIStoreConfirmPanelView.mImage_IconImage = nil;
UIStoreConfirmPanelView.mImage_WeaponImage = nil;
UIStoreConfirmPanelView.mImage_WeaponImageBg = nil;
UIStoreConfirmPanelView.mImage_Head = nil;
UIStoreConfirmPanelView.mImage_GoodsRate = nil;
UIStoreConfirmPanelView.mImage_GoodsTypeIcon = nil;
UIStoreConfirmPanelView.mText_GoodsNameText = nil;
UIStoreConfirmPanelView.mText_Description = nil;
UIStoreConfirmPanelView.mText_EffectDescription = nil;
UIStoreConfirmPanelView.mText_HaveGoodItem = nil;
UIStoreConfirmPanelView.mText_AmountText = nil;
UIStoreConfirmPanelView.mText_RemainingText = nil;
UIStoreConfirmPanelView.mText_Price = nil;
UIStoreConfirmPanelView.mText_OwnerNum = nil;
UIStoreConfirmPanelView.mHLayout_GoodsItemList = nil;
UIStoreConfirmPanelView.mScrRect_ItemList = nil;
UIStoreConfirmPanelView.mTrans_EquipIcon = nil;
UIStoreConfirmPanelView.mTrans_base_arrow = nil;
UIStoreConfirmPanelView.mTrans_HeadIcon = nil;
UIStoreConfirmPanelView.mTrans_GoodsItem = nil;
UIStoreConfirmPanelView.mTrans_BuyDiamond = nil;

UIStoreConfirmPanelView.mTrans_WeaponItem = nil;
--
UIStoreConfirmPanelView.mTrans_GrpItem = nil;
UIStoreConfirmPanelView.mSlider_Item = nil;
UIStoreConfirmPanelView.mText_MaxNum = nil;
UIStoreConfirmPanelView.mText_MinNum = nil;
UIStoreConfirmPanelView.mImage_GoldIcon = nil;
UIStoreConfirmPanelView.mBtn_Exit = nil;
UIStoreConfirmPanelView.mBtn_DetailInfo = nil;
UIStoreConfirmPanelView.mBtn_WeaponItem = nil;

function UIStoreConfirmPanelView:__InitCtrl()


	self.mBtn_GoodsIcon = self:GetButton("Root/GrpDialog/GrpCenter/GrpItem/ComItemV2");  --
	self.mBtn_Cancel = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnCancel"));
	self.mBtn_Close = self:GetButton("Root/GrpBg/Btn_Close");
	UIStoreConfirmPanelView.mBtn_Close = self.mBtn_Close --
	self.mBtn_Exit = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close");    --
	self.mBtn_AmountPlusButton = self:GetButton("Root/GrpDialog/GrpCenter/GrpSlider/GrpBtnIncrease/Btn_ComBtnAdd");  --
	self.mBtn_AmountMinusButton = self:GetButton("Root/GrpDialog/GrpCenter/GrpSlider/GrpBtnReduce/Btn_ComBtnReduce");  --
	--self.mBtn_AmountMaxButton = self:GetButton("GoodsConfirm/Amount/Btn_AmountMaxButton");
	self.mBtn_Buy = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnConfirm"));
	self.mBtn_off = self:GetButton("Trans_BuyDiamond/BuyDiamondtitle/Btn_BuyDiamond_off");
	self.mBtn_DiamondCancel = self:GetButton("Trans_BuyDiamond/Btn_DiamondCancel");
	--self.mBtn_Confirm = self:GetButton("Root/GrpDialog/GrpAction/BtnConfirm");
	self.mImage_IconImage = self:GetImage("Root/GrpDialog/GrpCenter/GrpItem/ComItemV2/GrpItem/Img_Item"); --

	self.mTrans_GrpItem = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpItem/ComItemV2");
	--self.mImage_Head = self:GetImage("GoodsView/Btn_GoodsIcon/Trans_HeadIcon/HeadBG/mask/Image_Head");
	self.mImage_GoodsRate = self:GetImage("Root/GrpDialog/GrpCenter/GrpItem/ComItemV2/GrpBg/Img_Bg");
	--self.mImage_GoodsTypeIcon = self:GetImage("GoodsConfirm/Amount/Image_GoodsTypeIcon");
	self.mText_GoodsNameText = self:GetText("Root/GrpDialog/GrpCenter/GrpContent/GrpTextName/Text_Name");
	self.mText_Description = self:GetText("Root/GrpDialog/GrpCenter/GrpContent/GrpDescriptionList/Viewport/Content/GrpTextDescription/Text_Description");
	--self.mText_EffectDescription = self:GetText("GoodsView/Description/Text_EffectDescription");
	--self.mText_HaveGoodItem = self:GetText("GoodsView/Trans_GoodsItem/Text_HaveGoodItem");
	self.mText_AmountText = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpTextNow/Text_CompoundNum"); --
	--self.mText_RemainingText = self:GetText("GoodsConfirm/Amount/RemainingAmount/Text_RemainingText");
	self.mText_Price = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpGoldConsume/Text_CostNum");
	--self.mText_OwnerNum = self:GetText("Owner/Text_OwnerNum");
	self.mHLayout_GoodsItemList = self:GetHorizontalLayoutGroup("GoodsView/Trans_GoodsItem/ScrRect_ItemList/HLayout_GoodsItemList");   --功能未发现
	--self.mScrRect_ItemList = self:GetScrollRect("GoodsView/Trans_GoodsItem/ScrRect_ItemList");
	--self.mTrans_EquipIcon = self:GetRectTransform("GoodsView/Btn_GoodsIcon/Trans_EquipIcon");
	self.mImage_WeaponImage = self:GetImage("Root/GrpDialog/GrpCenter/GrpItem/ComWeaponInfoItemV2/GrpNor/GrpWeaponIcon/Img_Icon");
	self.mImage_WeaponImageBg = self:GetImage("Root/GrpDialog/GrpCenter/GrpItem/ComWeaponInfoItemV2/GrpNor/GrpWeaponIcon/Img_Bg");

	--self.mTrans_base_arrow = self:GetRectTransform("GoodsView/Btn_GoodsIcon/Trans_EquipIcon/EquipIconBase/UI_base/Trans_arrow");
	--self.mTrans_HeadIcon = self:GetRectTransform("GoodsView/Btn_GoodsIcon/Trans_HeadIcon");
	--self.mTrans_GoodsItem = self:GetRectTransform("GoodsView/Trans_GoodsItem");
	--self.mTrans_BuyDiamond = self:GetRectTransform("Trans_BuyDiamond");

	self.mTrans_ItemBrief = self:GetRectTransform("Root/ItemBriefPanel")

	self.mTrans_WeaponItem = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpItem/ComWeaponInfoItemV2")
	self.mBtn_WeaponItem = self:GetButton("Root/GrpDialog/GrpCenter/GrpItem/ComWeaponInfoItemV2")

	self.mTrans_EquipPos = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpItem/ComItemV2/Trans_GrpEquipNum")
	self.mImage_Pos = self:GetImage("Root/GrpDialog/GrpCenter/GrpItem/ComItemV2/Trans_GrpEquipNum/Img_Icon");

	self.mText_MaxNum = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpTextMax/Text_MaxNum");
	self.mSlider_Item = self:GetSlider("Root/GrpDialog/GrpCenter/GrpSlider/GrpSlider/SliderLine/Slider_Line")
	self.mText_MinNum = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpTextMin/Text_MinNum");

	self.mImage_GoldIcon = self:GetImage("Root/GrpDialog/GrpCenter/GrpSlider/GrpGoldConsume/GrpGoldIcon/Img_Bg");
	self.mBtn_DetailInfo = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpCenter/Btn_PriceDetails/BtnInfo"));

	self.mBtn_PriceDetails = self:GetButton("Root/GrpDialog/GrpCenter/Btn_PriceDetails");
	self.mImage_PriceDetailsIcon = self:GetImage("Root/GrpDialog/GrpCenter/Btn_PriceDetails/GrpItemIcon/Img_Icon")
	self.mText_PriceDetailsNum = self:GetText("Root/GrpDialog/GrpCenter/Btn_PriceDetails/Text_Num")

	self.mTrans_GrpSkillDetails = self:GetRectTransform("Root/GrpDialog/Trans_GrpSkillDetails");
	self.mBtn_GrpSkillDetailsBtn = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/Trans_GrpSkillDetails/BtnInfo"))

	self.mTrans_GrpCurrency = self:GetRectTransform("Root/GrpTop/GrpCurrency");

	self.mTrans_GrpTextLeft = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpTextLeft")
	self.mText_GrpTextLeftText = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpTextLeft/TextNum")
	self.mText_GrpTextLeftNum = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpTextLeft/Text_Num")

	self.mTrans_PriceDetailsContent = self:GetRectTransform("Root/GrpDialog/Trans_GrpSkillDetails/GrpAllSkillDescription/GrpDescribe/Viewport/Content")
end

--@@ GF Auto Gen Block End


UIStoreConfirmPanelView.mImage_DiamondIcon = nil;

UIStoreConfirmPanelView.mConfirmView = nil;
UIStoreConfirmPanelView.mCurBuyAmount = 1;
UIStoreConfirmPanelView.mData = nil;

UIStoreConfirmPanelView.OnBuySuccessCallback = nil;
UIStoreConfirmPanelView.OnRefreshCallback = nil;

UIStoreConfirmPanelView.mGoodsAmountInputField = nil;
UIStoreConfirmPanelView.mMaxNumPerPurchase = 999;

UIStoreConfirmPanelView.MAX_PURCHASE_AMOUNT = 999;
UIStoreConfirmPanelView.REAL_MONEY_ID = 0;
UIStoreConfirmPanelView.GUN_CORE_ID = 10;
UIStoreConfirmPanelView.CHIP_CORE_ID = 302;
UIStoreConfirmPanelView.GUILD_COIN_ID = 303;
UIStoreConfirmPanelView.GUILD_RESOURCE_ID = 304;
UIStoreConfirmPanelView.mCurCurrencyId = 1;

UIStoreConfirmPanelView.mPath_ConfirmPanel = "StoreExchange/StoreExchangeItemBuyDialogV2.prefab"

UIStoreConfirmPanelView.Instance = nil;
UIStoreConfirmPanelView.mView = nil;

UIStoreConfirmPanelView.ColorGreen = Color(143/255,204/255,20/255);
UIStoreConfirmPanelView.ColorBlack = Color(49/255,49/255,49/255);

UIStoreConfirmPanelView.mObj = nil;


UIStoreConfirmPanelView.mCurBuyNum = 0;
UIStoreConfirmPanelView.mItemReward = nil;
UIStoreConfirmPanelView.mIsFristBuy = false;
UIStoreConfirmPanelView.mNeedCheckRepository = false;
UIStoreConfirmPanelView.mIsSlider = false;


function UIStoreConfirmPanelView.OpenConfirmPanel(data,root, currencyId,successHandler,refreshHandler)
	local self = UIStoreConfirmPanelView;
	self.itemPrefab = UIUtils.GetUIRes(UIStoreConfirmPanelView.mPath_ConfirmPanel);
	local instObj = instantiate(self.itemPrefab);
	
	self.mRoot = root;
	UIStoreConfirmPanelView.mData = data;
	self.mView =  UIStoreConfirmPanelView:New();
	self.mView:InitCtrl(instObj.transform);
	self.mView:InitData(data,currencyId,successHandler,refreshHandler);

	--instObj.transform:SetParent(root.gameObject.transform,false);
	instObj.transform:SetParent(UISystem.rootCanvasTrans,false);
	UIStoreConfirmPanelView.mObj = instObj;
	UIStoreConfirmPanelView.detailBrief = nil
end

function UIStoreConfirmPanelView:InitCtrl(root)
	self:SetRoot(root);
	self:__InitCtrl();
end


function UIStoreConfirmPanelView:InitData(data,currencyId,successHandler,refreshHandler)

	UISystem:AddContentUi("StoreExchangeItemBuyDialogV2")
	self.mCurBuyAmount = 1;
	UIStoreConfirmPanelView.mCurCurrencyId = currencyId;
	self.OnBuySuccessCallback = successHandler;
	self.OnRefreshCallback = refreshHandler;

	self.mText_GoodsNameText.text = data.name;
	if(data.buy_times == 0 and data.price_type == 0) then
		self.mText_Description.text = data.first_buy_description;
	else
		self.mText_Description.text = data.description;
	end

	local rewards = data.ItemNumList;
	UIStoreConfirmPanelView.mItemReward =  data.ItemNumList;
	if(rewards.Count >= 2) then
		setactive(self.mText_Description.transform.parent,false);
		local prefab =  UIUtils.GetGizmosPrefab(UICommonItemS.Path_UICommonItemS,self);
		local items = rewards;
		for i = 0, items.Count - 1 do
			local item = items[i];
			local instObj = instantiate(prefab);
			local itemS = UICommonItemS.New();
			itemS:InitCtrl(instObj.transform);
			itemS:SetData(item.itemid,item.num);
			UIUtils.AddListItem(instObj, self.mHLayout_GoodsItemList.transform);
		end
	else
		setactive(self.mText_Description.transform.parent,true);
	end

	self.mText_AmountText.text = self.mCurBuyAmount;


	self.mText_Price.text = string_format("{0}", formatnum(self.mCurBuyAmount * self.mData.price))


	setactive(self.mTrans_GrpItem.gameObject, false)

	local stcData = TableData.GetItemData(data.frame,true);
	setactive(self.mTrans_EquipPos.gameObject,false)
	setactive(self.mTrans_WeaponItem.gameObject,false)


	if data.frame ~= 0 and stcData ~= nil and stcData.type == 5 then
		--- 模组图标显示
		local equipData = TableData.GetEquipData(stcData.args[0])

		self.mImage_GoodsRate.sprite = IconUtils.GetQuiltyByRank(equipData.rank);

		self.mImage_IconImage.sprite = 	UIUtils.GetIconSprite(data.iconPath,data.icon.."_1");
--[[		if data.icon ~= "" then
			self.mImage_IconImage.sprite =  IconUtils.GetItemIcon(data.icon.."_1");
		else
			self.mImage_IconImage.sprite =  IconUtils.GetEquipSprite(equipData.res_code.."_1");
		end]]
		setactive(self.mTrans_GrpItem.gameObject, true)
		setactive(self.mTrans_EquipPos.gameObject,true)
		self.mImage_Pos.sprite =  IconUtils.GetEquipNum(equipData.category, true)
		--- 模组图标显示
	elseif data.frame ~= 0 and stcData ~= nil and stcData.type == 8 then
		setactive(self.mTrans_WeaponItem.gameObject, true)
		setactive(self.mTrans_GrpItem.gameObject, false)

		self.mImage_WeaponImageBg.sprite = IconUtils.GetWeaponQuiltyByRank(data.rank);
		local weaponData = TableData.listGunWeaponDatas:GetDataById(stcData.args[0]);
		if weaponData ~= nil then
			local elementData = TableData.listLanguageElementDatas:GetDataById(weaponData.element);
			local elementParent = self.mTrans_WeaponItem:Find("GrpNor/GrpElement")
			setactive(elementParent,true)
			local prefab = UIUtils.GetUIRes("UICommonFramework/ComElementItemV2.prefab");
			local instObj = instantiate(prefab,elementParent);
			instObj.transform:Find("Image_ElementIcon"):GetComponent("Image").sprite = IconUtils.GetElementIconM(elementData.icon)
			if data.icon ~= "" then
				self.mImage_WeaponImage.sprite =  IconUtils.GetItemIcon(data.icon.."_s");
			else
				self.mImage_WeaponImage.sprite = IconUtils.GetWeaponSprite(weaponData.res_code)
			end

		end
		self.mTrans_WeaponItem:Find("GrpNor/GrpQualityLine/ImgLine"):GetComponent("Image").color =  TableData.GetGlobalGun_Quality_Color2(data.rank);
		self.mTrans_WeaponItem:Find("GrpNor/GrpLevel/Text_Level"):GetComponent("Text").text = "Lv.0"

	else
		setactive(self.mTrans_GrpItem.gameObject, true)
		self.mImage_GoodsRate.sprite = IconUtils.GetQuiltyByRank(data.rank);
		if  data.icon ~= "" then
			self.mImage_IconImage.sprite =  IconUtils.GetItemIcon(data.icon)
		else
			self.mImage_IconImage.sprite =  IconUtils.GetItemIconSprite(stcData.id)
		end
	end

	if(data.price_type > 0) then
		local stcData = TableData.GetItemData(data.price_type);
		self.mImage_GoldIcon.sprite = UIUtils.GetIconSprite("Icon/Item",stcData.icon);
	end

	if(UIStoreConfirmPanelView.mCurCurrencyId ~= UIStoreConfirmPanelView.REAL_MONEY_ID) then

		local currency = self:GetCurrencyAmount();
		local div = currency / data.price;
		self.mMaxNumPerPurchase = math.floor(div);

		if(self.mMaxNumPerPurchase > UIStoreConfirmPanelView.MAX_PURCHASE_AMOUNT) then
			self.mMaxNumPerPurchase = UIStoreConfirmPanelView.MAX_PURCHASE_AMOUNT;
		end

		if (self.mMaxNumPerPurchase > data.remain_times and data.remain_times ~= 0) then
			self.mMaxNumPerPurchase = data.remain_times
		end
	end

	local itemBtn1 = UIUtils.GetButtonListener(self.mBtn_Buy.gameObject);
	itemBtn1.onClick = self.OnBuyClicked;
	itemBtn1.param = self;
	itemBtn1.paramData = data;

	local itemBtn2 = UIUtils.GetButtonListener(self.mBtn_Cancel.gameObject);
	itemBtn2.onClick = self.OnCancelClicked;
	itemBtn2.param = self;
	itemBtn2.paramData = nil;


	local itemCloseBtn = UIUtils.GetButtonListener(self.mBtn_Close.gameObject);
	itemCloseBtn.onClick = self.OnCloseClicked;
	itemCloseBtn.param = self;
	itemCloseBtn.paramData = nil;

	local itemExitBtn = UIUtils.GetButtonListener(self.mBtn_Exit.gameObject);
	itemExitBtn.onClick = self.OnCancelClicked;
	itemExitBtn.param = self;
	itemExitBtn.paramData = nil;
	

	local itemCloseBtn = UIUtils.GetButtonListener(self.mBtn_GrpSkillDetailsBtn.gameObject);
	itemCloseBtn.onClick = self.OnCloseClicked;
	itemCloseBtn.param = self;
	itemCloseBtn.paramData = nil;

	self.mSlider_Item.onValueChanged:AddListener(function(value)
			UIStoreConfirmPanelView:OnSliderChange(value)
		end)

	local itemType = 0;
	if self.mData.ItemNumList then
		local itemId = self.mData.ItemNumList[0].itemid
		local itemData = TableData.listItemDatas:GetDataById(tonumber(itemId))
		itemType = itemData.Type
		TipsManager.Add(self.mBtn_GoodsIcon.gameObject, itemData, nil,false)
		TipsManager.Add(self.mBtn_WeaponItem.gameObject, itemData, nil,false)

		if(self.mData.IsMultiPrice) then
			setactive(self.mBtn_DetailInfo.gameObject,true)
			UIUtils.GetListener(self.mBtn_PriceDetails.gameObject).onClick = self.ShowPriceDetails;
			UIUtils.GetListener(self.mBtn_DetailInfo.gameObject).onClick = self.ShowPriceDetails;
			setactive(self.mBtn_PriceDetails.gameObject,true);
		else
			setactive(self.mBtn_DetailInfo.gameObject,false)
			setactive(self.mBtn_PriceDetails.gameObject,false)
		end
	end

	if(data.price_type ~= UIStoreConfirmPanelView.REAL_MONEY_ID and data.price_type ~= UIStoreConfirmPanelView.GUILD_RESOURCE_ID) then --非rmb 非公会币B
		UIUtils.GetListener(self.mBtn_AmountPlusButton.gameObject).onClick = self.OnIncreaseClicked;
		UIUtils.GetListener(self.mBtn_AmountMinusButton.gameObject).onClick = self.OnDecreaseClicked;
	else
		setactive(self.mBtn_AmountPlusButton.gameObject,false);
		setactive(self.mBtn_AmountMinusButton.gameObject,false);
		setactive(self.mText_AmountText.gameObject,false);
		setactive(self.mTrans_GoodsAmount,false);
	end

	self:InitAmount();

	for key, value in pairs(self.mData.ItemNumList) do
		local itemId = value.itemid
		local itemData = TableData.listItemDatas:GetDataById(tonumber(itemId))
		if itemData ~= nil and itemData.Type == 5 or itemData.Type == 8 then
			self.mNeedCheckRepository = true;
		end
	end
	self.mText_MaxNum.text = self.mMaxNumPerPurchase
	self.mText_MinNum.text = self.mMaxNumPerPurchase == 0 and "0" or "1"

	self.mIsSlider = true
	if self.mMaxNumPerPurchase ~= 0 then
		self.mSlider_Item.value = self.mCurBuyAmount/self.mMaxNumPerPurchase
	else
		self.mSlider_Item.value = 1;
	end
	self.mIsSlider = false

	self:InitGrpCurrency();
end

function UIStoreConfirmPanelView:OnRelease()
	if self.itemPrefab then
        ResourceManager:UnloadAsset(self.itemPrefab)
    end
end

UIStoreConfirmPanelView.mCurrencyItem = nil;

function UIStoreConfirmPanelView:InitGrpCurrency()
	if(self.mCurrencyItem ~= nil) then
		self.mCurrencyItem:OnRelease();
	end

	local item = {}
	item.id = self.mData.price_type;
	item.jumpID = nil;
	item.param = 0

	local data = item
	self.mCurrencyItem = ResourcesCommonItem.New()
	self.mCurrencyItem:InitCtrl(self.mTrans_GrpCurrency.transform)
	self.mCurrencyItem:SetData(data)
end

function UIStoreConfirmPanelView.ShowPriceDetails(gameObject)
	local self = UIStoreConfirmPanelView;
	local view = self.mView;

	setactive(view.mTrans_GrpSkillDetails,true);

	local priceList = view.mData.MultiPriceDict;

	for i = 0, view.mTrans_PriceDetailsContent.transform.childCount-1 do
		local obj = view.mTrans_PriceDetailsContent.transform:GetChild(i);
		gfdestroy(obj);
	end

	for i = 0, priceList.Count - 1 do
		local item  = UIStoreExchangePriceInfoItem.New();
		item:InitCtrl(view.mTrans_PriceDetailsContent);
		item:SetData(priceList[i])

		if(view.mData.id == priceList[i].id) then
			item:SetNow()
		end
	end
end

function UIStoreConfirmPanelView:InitAmount()
	local view = self;
	local price = formatnum(view.mData.price * view.mCurBuyAmount);


	local stcData = TableData.GetItemData(view.mData.price_type);
	self.mText_PriceDetailsNum.text = view.mData.price;
	self.mImage_PriceDetailsIcon.sprite = UIUtils.GetIconSprite("Icon/Item",stcData.icon);

	if(self.CheckRichEnough(price,view.mData.price_type)) then
		--view.mText_AmountText.color = UIStoreConfirmPanelView.ColorGreen;
		view.mText_Price.color = UIStoreConfirmPanelView.ColorBlack
		view.mText_AmountText.color = UIStoreConfirmPanelView.ColorBlack;
	else
		view.mText_AmountText.color = Color.red;
		view.mText_Price.color = Color.red;
	end

	view.CheckCanBuyItem()

	if view.mData.limit > 0 then
		setactive(view.mTrans_GrpTextLeft,true)

		local hint = "剩余"
		if(view.mData.refresh_type == 1) then
			hint = TableData.GetHintById(106001)
		end
		if(view.mData.refresh_type == 2) then
			hint = TableData.GetHintById(106002)
		end
		if(view.mData.refresh_type == 3) then
			hint = TableData.GetHintById(106003)
		end

		view.mText_GrpTextLeftText.text = hint
		view.mText_GrpTextLeftNum.text = view.mData.remain_times;

	end
end

function UIStoreConfirmPanelView.OnIncreaseClicked(gameObj)
	local self = UIStoreConfirmPanelView;
	local view = self.mView;

	if view.mData.remain_times == 0 then
		if (view.mData.limit == 0 or view.mCurBuyAmount < view.mData.limit) and view.mCurBuyAmount < view.mMaxNumPerPurchase then
			view.mCurBuyAmount = view.mCurBuyAmount + 1;
		end
	else
		if (view.mData.limit == 0 or view.mCurBuyAmount < view.mData.limit) and view.mCurBuyAmount < view.mMaxNumPerPurchase and view.mCurBuyAmount < view.mData.remain_times then
			view.mCurBuyAmount = view.mCurBuyAmount + 1;
		end
	end

	local price = formatnum(view.mData.price * view.mCurBuyAmount);
	view.mText_Price.text = string_format("{0}", price)
	gfdebug(view.mCurBuyAmount);

	if(self.CheckRichEnough(price,view.mData.price_type)) then
		view.mText_Price.color = UIStoreConfirmPanelView.ColorBlack
		view.mText_AmountText.color = UIStoreConfirmPanelView.ColorBlack;
	else
		view.mText_AmountText.color = Color.red;
		view.mText_Price.color = Color.red;
	end

	view.mIsSlider = true
	if view.mMaxNumPerPurchase ~= 0 then
		view.mSlider_Item.value = view.mCurBuyAmount/view.mMaxNumPerPurchase
	else
		view.mSlider_Item.value = 1
	end

	view.mIsSlider = false
	view.mText_AmountText.text = view.mCurBuyAmount;
	view.CheckCanBuyItem()

end

function UIStoreConfirmPanelView.OnDecreaseClicked(gameObj)
	local self = UIStoreConfirmPanelView;
	local view = self.mView;

	if view.mCurBuyAmount > 1 then
		view.mCurBuyAmount = view.mCurBuyAmount - 1;
	end

	local price = formatnum(view.mData.price * view.mCurBuyAmount);
	view.mText_Price.text = string_format("{0}", price)

	if(self.CheckRichEnough(price,view.mData.price_type)) then
		view.mText_Price.color = UIStoreConfirmPanelView.ColorBlack
		view.mText_AmountText.color = UIStoreConfirmPanelView.ColorBlack;
	else
		view.mText_AmountText.color = Color.red;
		view.mText_Price.color = Color.red;
	end

	view.mIsSlider = true

	if view.mMaxNumPerPurchase ~= 0 then
		view.mSlider_Item.value = view.mCurBuyAmount/view.mMaxNumPerPurchase
	else
		view.mSlider_Item.value = 1;
	end

	view.mIsSlider = false
	view.mText_AmountText.text = view.mCurBuyAmount;
	view.CheckCanBuyItem();

end

function UIStoreConfirmPanelView.OnMaxClicked(gameObj)
	local self = UIStoreConfirmPanelView;
	local view = self.mView;
	local maxNum = view.mData.remain_times

	if(view.mData.limit == 0) then
		local currency = self:GetCurrencyAmount();
		maxNum = currency / view.mData.price;
		maxNum = math.min( maxNum, UIStoreConfirmPanelView.MAX_PURCHASE_AMOUNT);
		maxNum = math.floor(maxNum);
	end

	if(view.mData.limit > 0) then
		local currency = self:GetCurrencyAmount();
		local p = currency / view.mData.price;
		maxNum = math.min( p, UIStoreConfirmPanelView.MAX_PURCHASE_AMOUNT,maxNum);
		maxNum = math.floor(maxNum);
	end

	if(maxNum <= 0) then
		maxNum = 1;
	end

	view.mCurBuyAmount = maxNum;
	local price = formatnum(view.mData.price * view.mCurBuyAmount);

	view.mText_Price.text = string_format("{0}", price)
	if(self.CheckRichEnough(price,view.mData.price_type)) then
		view.mText_Price.color = UIStoreConfirmPanelView.ColorBlack
		view.mText_AmountText.color = UIStoreConfirmPanelView.ColorBlack;
	else
		view.mText_AmountText.color = Color.red;
		view.mText_Price.color = Color.red;
	end

	view.CheckCanBuyItem()
end

function UIStoreConfirmPanelView.OnGoodsAmountValueChanged()

	local view = self.mView;
	local num = tonumber(view.mGoodsAmountInputField.text);

	if(num == nil or num == 0) then
		num = 1;
	end

	local maxNum = view.mData.remain_times
	if(view.mData.limit == 0) then
		maxNum = UIStoreConfirmPanelView.mMaxNumPerPurchase;
	end

	if(maxNum < num) then
		num = maxNum;
	end

	if(0 >= num) then
		num = 1;
	end

	view.mCurBuyAmount = num;

	local price = formatnum(view.mData.price * view.mCurBuyAmount);
	view.mGoodsAmountInputField.text = view.mCurBuyAmount;
	view.mText_Price.text = string_format("{0}", price)
	if(view.CheckRichEnough(price,view.mData.price_type)) then
		view.mText_Price.color = UIStoreConfirmPanelView.ColorBlack
		view.mText_AmountText.color = UIStoreConfirmPanelView.ColorBlack;
	else
		view.mText_AmountText.color = Color.red;
		view.mText_Price.color = Color.red;
	end

	view.CheckCanBuyItem();

end

function UIStoreConfirmPanelView.CheckRichEnough(total_price, price_type)
	if(price_type == UIStoreConfirmPanelView.REAL_MONEY_ID) then
		return true;
	end

	local self = UIStoreConfirmPanelView
	local currency = self.mView:GetCurrencyAmount();

	if(total_price > currency) then
		return false;
	else
		return true;
	end
end

function UIStoreConfirmPanelView:GetCurrencyAmount()
	local currency = 0;

	local stcData = TableData.GetItemData(UIStoreConfirmPanelView.mCurCurrencyId);
	if(stcData ~= nil and stcData.type ~= 1) then
		local data = NetCmdItemData:GetNormalItem(UIStoreConfirmPanelView.mCurCurrencyId);
		if(data == nil) then
			currency = 0;
		else
			currency = data.item_num;
		end
	else
		currency = NetCmdItemData:GetResItemCount(stcData.id);
	end

	return currency;
end

function UIStoreConfirmPanelView.CancelGotoBuyDiamond(gameObj)
	local self = UIStoreConfirmPanelView;
	local view = self.mView;
end


function UIStoreConfirmPanelView.OnBuyClicked(gameObj)
	local self = UIStoreConfirmPanelView;
	
	local view = self.mView;
	if view.mNeedCheckRepository == true then
		if TipsManager.CheckRepositoryIsFull() == true then
			return;
		end
	end

	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local view = eventTrigger.param;
		local data = eventTrigger.paramData;
		local num = view.mCurBuyAmount;
		self.mCurBuyNum = num;
		local curBuyNum = view.mCurBuyAmount ~= 0 and view.mCurBuyAmount or 1;
		local price = view.mData.price * curBuyNum;

		if(data.IsTagShowTime == false) then
			MessageBox.Show("提示", "该商品已过期!", MessageBox.ShowFlag.eMidBtn, price,nil, nil);
			view:OnRelease();
			gfdestroy(view:GetRoot().gameObject);
			self.mView = nil;
			return;
		end


		if view.mData.ItemNumList then
			local itemId = self.mData.ItemNumList[0].itemid
			local itemData = TableData.listItemDatas:GetDataById(tonumber(itemId))
			if itemData.Type == 6 then --体力
				local goodData = self.mData:GetStoreGoodData();
				if self:StaminaOverFlowWarning(self.mData.ItemNumList[0].num*self.mCurBuyNum,data.id,num,self.OnBuyCallback) == true then
					return;
				end
			end

		end

		if(self.CheckRichEnough(price,view.mData.price_type) == false) then
			local str = ""
			if(view.mData.price_type > 0) then
				local stcData = TableData.GetItemData(view.mData.price_type);

				if(stcData == nil) then
					gferror("未知的PriceType"..data.price_type..",Item表里没有该ID");
					return
				end
				str = stcData.name.str
			end

			CS.PopupMessageManager.PopupString(string_format(TableData.GetHintById(225), str))  -- xx 不足
			return;
		end

		local  storeHistory =  NetCmdStoreData:GetGoodsHistoryById(data.tag.."#" ..data.id);
		if storeHistory~=nil and storeHistory.Total == 0 then
			self.mIsFristBuy = true
		end
		if(data.price_type ~= UIStoreConfirmPanelView.REAL_MONEY_ID) then --非rmb购买
			if(data.price_type ~= UIStoreConfirmPanelView.GUILD_RESOURCE_ID) then
				if(data.is_black_market) then
					NetCmdStoreData:SendStoreBlackBuy(data.index,data.tag,self.OnBuyCallback);
				else
					NetCmdStoreData:SendStoreBuy(data.id,num,self.OnBuyCallback);
				end
			else
				NetCmdStoreData:SendSocialBuyStore(data.id,self.OnBuyCallback);
			end
		else --RMB购买
			NetCmdStoreData:SendStoreOrder(data.id,self.OnBuyCallback);
		end
	end
end

function UIStoreConfirmPanelView.OnCancelClicked(gameObj)
	local self = UIStoreConfirmPanelView;
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local view = eventTrigger.param;

		view:OnRelease();
		gfdestroy(view:GetRoot().gameObject);
		self.mView = nil;
		UIStoreMainPanel.IsConfirmPanelOpening = false;
		UIStoreExchangePanel.IsConfirmPanelOpening = false;
		
	end

	UITopResourceBar.Show()
end



function UIStoreConfirmPanelView.OnCloseClicked(gameObj)
	local self = UIStoreConfirmPanelView;

	local view = self.mView;
	if(view.mTrans_GrpSkillDetails.gameObject.activeSelf) then
		setactive(view.mTrans_GrpSkillDetails,false)
	else
		self.OnCancelClicked(gameObj)
	end
end



function UIStoreConfirmPanelView.OnBuyCallback(ret)
	local self = UIStoreConfirmPanelView;

	if ret == CS.CMDRet.eSuccess then
		gfdebug("购买成功");

		UIStoreMainPanel.IsConfirmPanelOpening = false;
		UIStoreExchangePanel.IsConfirmPanelOpening = false;

		--- 计算奖励数量
		---local rewardList = { { [self.mCurItemId] = self.mCurItemNum } }
		local rewardList = {};
		local goodData = self.mData:GetStoreGoodData();
		if goodData ~= nil then
			if self.mIsFristBuy == true then
				for key, value in pairs(goodData.FirstBuyReward) do
					if value ~= nil then
						rewardList[value.itemid] = value.num;
					end
				end
			end

			for key, value in pairs(goodData.BuyReward) do
				local hasNum = 0;
				if rewardList[key] ~= nil then
					hasNum = rewardList[key]
				end
				rewardList[key] = value * self.mCurBuyNum + hasNum;

			end
		end

		for key, value in pairs(self.mItemReward) do
			if value ~= nil then
				local hasNum = 0;
				if rewardList[value.itemid] ~= nil then
					hasNum = rewardList[value.itemid]
				end
				rewardList[value.itemid] = value.num * self.mCurBuyNum+ hasNum;
			end
		end

		local rewardItemList = {}
		for key, value in pairs(rewardList) do
			local rewardItem = { ["ItemId"] = key, ["ItemNum"] = value }
			table.insert(rewardItemList,rewardItem)
		end

		UIManager.JumpUIByParam(UIDef.UICommonReceivePanel);
		gfdestroy(self.mView:GetRoot().gameObject);
		UITopResourceBar.Show()

		self.mView.CheckMultiPriceChange();
		self.mView.OnBuySuccessCallback();
		self.mView = nil;
	else
		gfdebug("购买失败");
		TimerSys:DelayCall(0.1,function(idx)
				if(not MessageBox.IsVisible()) then
					MessageBox.Show("出错了", "购买失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
				end
			end,0);
	end
end

function UIStoreConfirmPanelView.CheckMultiPriceChange()
	local self =  UIStoreConfirmPanelView;
	local view = self.mView;

	if(view.mData.IsMultiPrice and view.mData.remain_times == 0 and view.mData.jump_id > 0) then
		UIManager.OpenUIByParam(UIDef.UIStoreExchangePriceChangeDialog,view.mData)
	end
end

function UIStoreConfirmPanelView.ErrorMsgHandle(content)
	local self = UIStoreConfirmPanelView;
	local msg = content.Sender;
	if(msg == "StoreTagLimitedNotFound") then
		MessageBox.Show("出错了", "该商品已过期!", MessageBox.ShowFlag.eMidBtn, price,nil, nil);
	else
		MessageBox.Show("出错了", "购买失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
	end
end

function UIStoreConfirmPanelView:UpdateItemBrief(itemType ,id)
	if itemType == GlobalConfig.ItemType.Weapon then
		if self.detailBrief == nil then
			local item = UICommonWeaponBriefItem.New()
			item:InitCtrl(self.mTrans_ItemBrief)
			self.detailBrief = item
		end
		self.detailBrief:SetData(UICommonWeaponBriefItem.ShowType.Item, id)
	elseif itemType == GlobalConfig.ItemType.EquipPackages or itemType == GlobalConfig.ItemType.EquipmentType then
		if self.detailBrief == nil then
			local item = UICommonEquipBriefItem.New()
			item:InitCtrl(self.mTrans_ItemBrief)
			self.detailBrief = item
		end
		self.detailBrief:SetData(UICommonEquipBriefItem.ShowType.Item, id)
	end
end
--- 体力溢出警告
function UIStoreConfirmPanelView:StaminaOverFlowWarning(addNum,dataId,num,BuyCallback)
	local playerStamina =  GlobalData.GetStaminaResourceItemCount(UICommonGetPanel.StaminaId)
	local maxStamina = TableData.GetPlayerCurExtraStaminaMax()
	if playerStamina <= maxStamina and playerStamina + addNum > maxStamina then
		local hint = TableData.GetHintById(211)
		MessageBoxPanel.ShowDoubleType(hint, function () NetCmdStoreData:SendStoreBuy(dataId, num,BuyCallback) end)
		return true
	end
	return false
end

function UIStoreConfirmPanelView:OnSliderChange(value)
	local view = self.mView;
	if (view.mIsSlider == true) then
		return ;
	end

	view.mCurBuyAmount = luaRoundNum(value * view.mMaxNumPerPurchase)
	view.mCurBuyAmount = view.mCurBuyAmount == 0 and 1 or view.mCurBuyAmount
	view.mText_AmountText.text = view.mCurBuyAmount;
	view.mText_Price.text = string_format("{0}", formatnum(view.mCurBuyAmount * view.mData.price))

	view.CheckCanBuyItem()

	view.mIsSlider = true
	if view.mMaxNumPerPurchase ~= 0 then
		view.mSlider_Item.value = view.mCurBuyAmount / view.mMaxNumPerPurchase
	else
		view.mSlider_Item.value = 1;
	end
	view.mIsSlider = false
end

--商品最大数量为0
function UIStoreConfirmPanelView.CheckCanBuyItem()
	local self =  UIStoreConfirmPanelView;
	local view = self.mView;
	if view.mMaxNumPerPurchase == 0 then
		view.mText_AmountText.text = "0"
		view.mText_Price.text = "0"
	end
end







