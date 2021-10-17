require("UI.UIBaseView")

UIQuickCorePanelItemView = class("UIQuickCorePanelItemView", UIBaseView)
UIQuickCorePanelItemView.__index = UIQuickCorePanelItemView

--@@ GF Auto Gen Block Begin
UIQuickCorePanelItemView.mBtn_JumpStore = nil
UIQuickCorePanelItemView.mBtn_AmountPlusButton = nil
UIQuickCorePanelItemView.mBtn_AmountMinusButton = nil
UIQuickCorePanelItemView.mBtn_AmountMaxButton = nil
UIQuickCorePanelItemView.mBtn_Buy = nil
UIQuickCorePanelItemView.mBtn_off = nil
UIQuickCorePanelItemView.mBtn_DiamondCancel = nil
UIQuickCorePanelItemView.mBtn_Confirm = nil
UIQuickCorePanelItemView.mImage_GoodsRate = nil
UIQuickCorePanelItemView.mImage_IconImage = nil
UIQuickCorePanelItemView.mImage_GoodsTypeIcon = nil
UIQuickCorePanelItemView.mImage_GoodsPrices_CoinImage = nil
UIQuickCorePanelItemView.mImage_UserCoin_CoinImage = nil
UIQuickCorePanelItemView.mText_GoodsNameText = nil
UIQuickCorePanelItemView.mText_Description = nil
UIQuickCorePanelItemView.mText_EffectDescription = nil
UIQuickCorePanelItemView.mText_HaveGoodItem = nil
UIQuickCorePanelItemView.mText_AmountText = nil
UIQuickCorePanelItemView.mText_RemainingText = nil
UIQuickCorePanelItemView.mText_GoodsPrices_PricesText = nil
UIQuickCorePanelItemView.mText_UserCoin_CountText = nil
UIQuickCorePanelItemView.mText_Price = nil
UIQuickCorePanelItemView.mHLayout_GoodsItemList = nil
UIQuickCorePanelItemView.mScrRect_ItemList = nil
UIQuickCorePanelItemView.mTrans_GoodsItem = nil
UIQuickCorePanelItemView.mTrans_BuyDiamond = nil

function UIQuickCorePanelItemView:__InitCtrl()

	self.mBtn_JumpStore = self:GetButton("GoodsConfirm/Btn_JumpStore")
	self.mBtn_AmountPlusButton = self:GetButton("GoodsConfirm/Amount/Btn_AmountPlusButton")
	self.mBtn_AmountMinusButton = self:GetButton("GoodsConfirm/Amount/Btn_AmountMinusButton")
	self.mBtn_AmountMaxButton = self:GetButton("GoodsConfirm/Amount/Btn_AmountMaxButton")
	self.mBtn_Buy = self:GetButton("GoodsConfirm/Btn_Buy")
	self.mBtn_off = self:GetButton("Trans_BuyDiamond/BuyDiamondtitle/Btn_BuyDiamond_off")
	self.mBtn_DiamondCancel = self:GetButton("Trans_BuyDiamond/Btn_DiamondCancel")
	self.mBtn_Confirm = self:GetButton("Trans_BuyDiamond/Btn_Confirm")
	self.mImage_GoodsRate = self:GetImage("GoodsView/GoodsIcon/Image_GoodsRate")
	self.mImage_IconImage = self:GetImage("GoodsView/GoodsIcon/Image_IconImage")
	self.mImage_GoodsTypeIcon = self:GetImage("GoodsConfirm/Amount/Image_GoodsTypeIcon")
	self.mImage_GoodsPrices_CoinImage = self:GetImage("GoodsConfirm/CoinPrices/UI_GoodsPrices/Image_CoinImage")
	self.mImage_UserCoin_CoinImage = self:GetImage("GoodsConfirm/CoinPrices/UI_UserCoin/Image_CoinImage")
	self.mText_GoodsNameText = self:GetText("GoodsView/Name/Text_GoodsNameText")
	self.mText_Description = self:GetText("GoodsView/Description/Text_Description")
	self.mText_EffectDescription = self:GetText("GoodsView/Description/Text_EffectDescription")
	self.mText_HaveGoodItem = self:GetText("GoodsView/Trans_GoodsItem/Text_HaveGoodItem")
	self.mText_AmountText = self:GetText("GoodsConfirm/Amount/GoodsAmount/Text_AmountText")
	self.mText_RemainingText = self:GetText("GoodsConfirm/Amount/RemainingAmount/Text_RemainingText")
	self.mText_GoodsPrices_PricesText = self:GetText("GoodsConfirm/CoinPrices/UI_GoodsPrices/Text_PricesText")
	self.mText_UserCoin_CountText = self:GetText("GoodsConfirm/CoinPrices/UI_UserCoin/Text_CountText")
	self.mText_Price = self:GetText("GoodsConfirm/Btn_Buy/Text_Price")
	self.mHLayout_GoodsItemList = self:GetHorizontalLayoutGroup("GoodsView/Trans_GoodsItem/ScrRect_ItemList/HLayout_GoodsItemList")
	self.mScrRect_ItemList = self:GetScrollRect("GoodsView/Trans_GoodsItem/ScrRect_ItemList")
	self.mTrans_GoodsItem = self:GetRectTransform("GoodsView/Trans_GoodsItem")
	self.mTrans_BuyDiamond = self:GetRectTransform("Trans_BuyDiamond")
	self.mTrans_Close = self:GetRectTransform("Background")
end

--@@ GF Auto Gen Block End

UIQuickCorePanelItemView.mImage_DiamondIcon = nil

UIQuickCorePanelItemView.mConfirmView = nil
UIQuickCorePanelItemView.mCurBuyAmount = 1
UIQuickCorePanelItemView.mData = nil

UIQuickCorePanelItemView.OnBuySuccessCallback = nil
UIQuickCorePanelItemView.OnRefreshCallback = nil

UIQuickCorePanelItemView.mGoodsAmountInputField = nil
UIQuickCorePanelItemView.mMaxNumPerPurchase = 999

UIQuickCorePanelItemView.MAX_PURCHASE_AMOUNT = 999

UIQuickCorePanelItemView.mPath_ConfirmPanel = "UICommonFramework/UIQuicklyBuyPanelItem.prefab"

UIQuickCorePanelItemView.Instance = nil;
UIQuickCorePanelItemView.mGunInfo = nil;

UIQuickCorePanelItemView.ColorGreen = Color(143/255,204/255,20/255)
UIQuickCorePanelItemView.ColorBlack = Color(49/255,49/255,49/255)


function UIQuickCorePanelItemView.OpenConfirmPanel(data, root, currencyId, itemId,successHandler)
	local prefab = UIUtils.GetGizmosPrefab(UIQuickCorePanelItemView.mPath_ConfirmPanel,self);
    local instObj = instantiate(prefab)
    UIQuickCorePanelItemView.mGunInfo = NetCmdTeamData:GetGunByID(data.itemData.Args[0]);

	UIQuickCorePanelItemView.Instance = UIQuickCorePanelItemView:New()
	UIQuickCorePanelItemView.Instance:InitCtrl(instObj.transform)
    UIQuickCorePanelItemView.Instance:InitData();
    UIQuickCorePanelItemView.Instance:InitStcData(data.itemData);

	instObj.transform:SetParent(root.gameObject.transform,false)
end

function UIQuickCorePanelItemView:InitCtrl(root)

	self:SetRoot(root)

	self:__InitCtrl()

	self.mImage_DiamondIcon = self:GetImage("GoodsConfirm/Btn_Buy/DiamondIcon")

    self.mGoodsAmountInputField = self:GetInputField("GoodsConfirm/Amount/GoodsAmount/Text_AmountText")
    
    UIUtils.GetButtonListener(self.mTrans_Close.gameObject).onClick = function()
		self:OnCancelClicked();
	end

    UIUtils.GetButtonListener(self.mBtn_AmountPlusButton.gameObject).onClick = function () 
        self:OnPlusClicked();
    end

    UIUtils.GetButtonListener(self.mBtn_AmountMinusButton.gameObject).onClick = function () 
         self:OnMinusClicked()
    end

    UIUtils.GetButtonListener(self.mBtn_AmountMaxButton.gameObject).onClick = function () 
         self:OnMaxClicked();
    end
    
    UIUtils.GetButtonListener(self.mBtn_Buy.gameObject).onClick = function () 
        self:OnBuyCoreClicked();
    end
end

function UIQuickCorePanelItemView:InitData()
    local limit = self.GetMaxLimit();

    if(self.mCurBuyAmount > limit ) then
        self.mCurBuyAmount = limit;
    end

    self.mText_AmountText.text = self.mCurBuyAmount;

    self:SetBuyInfo();
    self:SetCost(self.mCurBuyAmount);
end

function UIQuickCorePanelItemView:SetBuyInfo()
	self.mText_GoodsPrices_PricesText.text = UIQuickCorePanelItemView.mGunInfo.CoreShopStepPrice;

	-- local remainMaxCount = UIQuickCorePanelItemView.mGunInfo.CoreRemainMaxCount;
	-- if(remainMaxCount <= 0) then
    --     self.mBtn_Buy.interactable = false;
    -- end

    --local limit = self.GetMaxLimit();
    local shopStepCount = UIQuickCorePanelItemView.mGunInfo.CoreShopStepCount;

    if(shopStepCount <= 0) then
        self.mText_RemainingText.text = "-";
    else
        self.mText_RemainingText.text = shopStepCount;
    end

end

function UIQuickCorePanelItemView:InitStcData(itemData)
    self.mText_GoodsNameText.text = itemData.Name.str;
    self.mText_Description.text = itemData.Introduction.str;
    self.mText_EffectDescription.text = itemData.Description.str;

    local iconPath = itemData.icon_path;
	if(iconPath == "") then
		iconPath = "Item";
    end
    
    local stcData = TableData.GetItemData(UIStoreConfirmPanelView.GUN_CORE_ID)
	local sprite = UIUtils.GetIconSprite("Icon/Item",stcData.icon)
        
    self.mImage_IconImage.sprite = UIUtils.GetIconSprite("Icon/"..iconPath,itemData.icon);
    self.mImage_GoodsPrices_CoinImage.sprite = sprite;
    self.mImage_UserCoin_CoinImage.sprite = sprite;
    self.mImage_DiamondIcon.sprite = sprite;
end

function UIQuickCorePanelItemView:SetCost(amount)
	local costPerCore = UIQuickCorePanelItemView.mGunInfo.CoreShopStepPrice;
	local needed = costPerCore * amount;
    local owned = NetCmdItemData:GetItemCount(UIStoreConfirmPanelView.GUN_CORE_ID);
    
	self.mText_Price.text = needed;
	self.mText_UserCoin_CountText.text = owned;

	if(needed > owned) then
		self.mBtn_Buy.interactable = false;
	else
		self.mBtn_Buy.interactable = true;
	end

	local remainMaxCount = UIQuickCorePanelItemView.mGunInfo.CoreRemainMaxCount;
	if(remainMaxCount <= 0) then
        self.mBtn_Buy.interactable = false;
    end

    --self.mText_AmountText.text = self.mCurBuyAmount;
end

function UIQuickCorePanelItemView.GetMaxLimit()
    self = UIQuickCorePanelItemView;
    local data = NetCmdItemData:GetNormalItem(UIStoreConfirmPanelView.GUN_CORE_ID);
    local coreCoinAmount = 0;
    if(data ~= nil) then
        coreCoinAmount = data.item_num;
    end


    local shopStepCount = UIQuickCorePanelItemView.mGunInfo.CoreShopStepCount;
    local remainMaxCount = UIQuickCorePanelItemView.mGunInfo.CoreRemainMaxCount;
    local maxBuyCount = math.floor(coreCoinAmount / UIQuickCorePanelItemView.mGunInfo.CoreShopStepPrice);

    if(shopStepCount < 0) then
        shopStepCount = 2147483647;
    end

    --setactive(self.mView.mText_CorePanel_HelpText.gameObject,false);

    local min = math.min(shopStepCount,remainMaxCount,maxBuyCount);

    return min;
end

function UIQuickCorePanelItemView:OnPlusClicked()
    local limit = self.GetMaxLimit();

    if(self.mCurBuyAmount < limit ) then
        self.mCurBuyAmount = self.mCurBuyAmount + 1;
    end

    self.mText_AmountText.text = self.mCurBuyAmount;
    self:SetCost(self.mCurBuyAmount);
end

function UIQuickCorePanelItemView:OnMinusClicked()

    if(self.mCurBuyAmount > 1 ) then
        self.mCurBuyAmount = self.mCurBuyAmount - 1;
    end

    --setactive(self.mView.mText_CorePanel_HelpText.gameObject,false);
    self.mText_AmountText.text = self.mCurBuyAmount;
    self:SetCost(self.mCurBuyAmount);

    self.GetMaxLimit();
end

function UIQuickCorePanelItemView:OnMaxClicked()

    local limit = self.GetMaxLimit();

    if(limit <= 0) then
        limit = 1;
    end

    self.mCurBuyAmount = limit;

    self.mText_AmountText.text = self.mCurBuyAmount;
    self:SetCost(self.mCurBuyAmount);
end


function UIQuickCorePanelItemView:OnBuyCoreClicked( )
    if(self.mCurBuyAmount == 0) then
        return;
    end
    NetCmdStoreData:SendReqGunCoreBuy(UIQuickCorePanelItemView.mGunInfo.stc_gun_id, self.mCurBuyAmount,self.OnBuyCoreCallback);
end

function UIQuickCorePanelItemView.OnBuyCoreCallback(ret)
	--self = UIQuickCorePanelItemView;
	
	if ret == CS.CMDRet.eSuccess then
        gfdebug("购买碎片成功");
        UIQuickCorePanelItemView.Instance:InitData(); 
        --self.OnMinClicked(nil);
        UICharacterUpgradePanel.UpdateData();
	else
		gfdebug("购买碎片失败");
	end	
end

function UIQuickCorePanelItemView:OnCancelClicked()
	gfdestroy(self:GetRoot().gameObject)
	UIQuickCorePanelItemView.Instance = nil
end

