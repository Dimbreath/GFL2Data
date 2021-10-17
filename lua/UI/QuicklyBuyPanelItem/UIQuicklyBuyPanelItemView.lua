require("UI.UIBaseView")

UIQuicklyBuyPanelItemView = class("UIQuicklyBuyPanelItemView", UIBaseView)
UIQuicklyBuyPanelItemView.__index = UIQuicklyBuyPanelItemView

--@@ GF Auto Gen Block Begin
UIQuicklyBuyPanelItemView.mBtn_JumpStore = nil
UIQuicklyBuyPanelItemView.mBtn_AmountPlusButton = nil
UIQuicklyBuyPanelItemView.mBtn_AmountMinusButton = nil
UIQuicklyBuyPanelItemView.mBtn_AmountMaxButton = nil
UIQuicklyBuyPanelItemView.mBtn_Buy = nil
UIQuicklyBuyPanelItemView.mBtn_off = nil
UIQuicklyBuyPanelItemView.mBtn_DiamondCancel = nil
UIQuicklyBuyPanelItemView.mBtn_Confirm = nil
UIQuicklyBuyPanelItemView.mImage_GoodsRate = nil
UIQuicklyBuyPanelItemView.mImage_IconImage = nil
UIQuicklyBuyPanelItemView.mImage_GoodsTypeIcon = nil
UIQuicklyBuyPanelItemView.mImage_GoodsPrices_CoinImage = nil
UIQuicklyBuyPanelItemView.mImage_UserCoin_CoinImage = nil
UIQuicklyBuyPanelItemView.mText_GoodsNameText = nil
UIQuicklyBuyPanelItemView.mText_Description = nil
UIQuicklyBuyPanelItemView.mText_EffectDescription = nil
UIQuicklyBuyPanelItemView.mText_HaveGoodItem = nil
UIQuicklyBuyPanelItemView.mText_AmountText = nil
UIQuicklyBuyPanelItemView.mText_RemainingText = nil
UIQuicklyBuyPanelItemView.mText_GoodsPrices_PricesText = nil
UIQuicklyBuyPanelItemView.mText_UserCoin_CountText = nil
UIQuicklyBuyPanelItemView.mText_Price = nil
UIQuicklyBuyPanelItemView.mHLayout_GoodsItemList = nil
UIQuicklyBuyPanelItemView.mScrRect_ItemList = nil
UIQuicklyBuyPanelItemView.mTrans_GoodsItem = nil
UIQuicklyBuyPanelItemView.mTrans_BuyDiamond = nil

function UIQuicklyBuyPanelItemView:__InitCtrl()

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
	self.mTrans_Mask = self:GetRectTransform("Image_Mask")
end

--@@ GF Auto Gen Block End

UIQuicklyBuyPanelItemView.mImage_DiamondIcon = nil

UIQuicklyBuyPanelItemView.mConfirmView = nil
UIQuicklyBuyPanelItemView.mCurBuyAmount = 1
UIQuicklyBuyPanelItemView.mData = nil
UIQuicklyBuyPanelItemView.mItemId= 0

UIQuicklyBuyPanelItemView.OnBuySuccessCallback = nil
UIQuicklyBuyPanelItemView.OnRefreshCallback = nil

UIQuicklyBuyPanelItemView.mGoodsAmountInputField = nil
UIQuicklyBuyPanelItemView.mMaxNumPerPurchase = 999

UIQuicklyBuyPanelItemView.MAX_PURCHASE_AMOUNT = 999
UIQuicklyBuyPanelItemView.REAL_MONEY_ID = 0
UIQuicklyBuyPanelItemView.GUN_CORE_ID = 301
UIQuicklyBuyPanelItemView.CHIP_CORE_ID = 302
UIQuicklyBuyPanelItemView.GUILD_COIN_ID = 303
UIQuicklyBuyPanelItemView.GUILD_RESOURCE_ID = 304
UIQuicklyBuyPanelItemView.mCurCurrencyId = 1

UIQuicklyBuyPanelItemView.mPath_ConfirmPanel = "UICommonFramework/UIQuicklyBuyPanelItem.prefab"

UIQuicklyBuyPanelItemView.Instance = nil

UIQuicklyBuyPanelItemView.ColorGreen = Color(143/255,204/255,20/255)
UIQuicklyBuyPanelItemView.ColorBlack = Color(49/255,49/255,49/255)
UIQuicklyBuyPanelItemView.ColorWhite = Color(241/255, 245/225, 220/255)


function UIQuicklyBuyPanelItemView.OpenConfirmPanel(data, root, currencyId, itemId,successHandler, jumpHandler)
	local prefab = UIUtils.GetGizmosPrefab(UIQuicklyBuyPanelItemView.mPath_ConfirmPanel,self);
	local instObj = instantiate(prefab)

	UIQuicklyBuyPanelItemView.Instance = UIQuicklyBuyPanelItemView:New()
	UIQuicklyBuyPanelItemView.Instance:InitCtrl(instObj.transform)
	UIQuicklyBuyPanelItemView.Instance:InitData(data,currencyId,itemId,successHandler,jumpHandler)

	instObj.transform:SetParent(root.gameObject.transform,false)
	instObj.transform.position = Vector3(0,0,UIUtils.GetPanelTopZPos(root));

	--UIStorePanel.IsConfirmPanelOpening = false
	--MessageSys:AddListener(CS.Cmd.CmdDef.store_buy:GetHashCode() * 1000, UIQuicklyBuyPanelItemView.ErrorMsgHandle)
end

function UIQuicklyBuyPanelItemView:InitCtrl(root)

	self:SetRoot(root)

	self:__InitCtrl()

	self.mImage_DiamondIcon = self:GetImage("GoodsConfirm/Btn_Buy/DiamondIcon")

	self.mGoodsAmountInputField = self:GetInputField("GoodsConfirm/Amount/GoodsAmount/Text_AmountText")
end


function UIQuicklyBuyPanelItemView:InitData(data,currencyId,itemId, successHandler,jumpHandler)


	self.mData = self:GetGoodData(data)
	print(self.mData)

	self.mCurCurrencyId = currencyId
	self.mItemId = itemId
	self.OnBuySuccessCallback = successHandler
	self.OnJumpCallback = jumpHandler

	self.mText_GoodsNameText.text = self.mData.name
	if(self.mData.buy_times == 0 and self.mData.price_type == 1) then
		self.mText_Description.text = self.mData.first_buy_description
	else
		self.mText_Description.text = self.mData.description
	end
	--if(self.mData.limit ~= 0 or self.mData.hasRefreshTime == true) then
	if(self.mData.limit ~= 0) then
		self.mText_RemainingText.text = ""..self.mData.remain_times
	else
		self.mText_RemainingText.text = "-"
	end

	local rewards = self.mData.ItemNumList;

	if(rewards.Count >= 2) then
		setactive(self.mTrans_GoodsItem,true);
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
		setactive(self.mTrans_GoodsItem,false);
		setactive(self.mText_Description.transform.parent,true);
	end

	printstack(self.mCurBuyAmount)
	self.mGoodsAmountInputField.text = self.mCurBuyAmount
	self.mText_Price.text = formatnum(self.mCurBuyAmount * self.mData.price)
	self.mText_GoodsPrices_PricesText.text = formatnum(self.mCurBuyAmount * self.mData.price)

	self.mImage_IconImage.sprite = UIUtils.GetIconSprite("Icon/Item",self.mData.icon)
	self.mImage_GoodsRate.color = TableData.GetGlobalGun_Quality_Color2(self.mData.rank)

	if(self.mData.price_type > 0) then
		local stcData = TableData.GetItemData(self.mData.price_type)
		local sprite = UIUtils.GetIconSprite("Icon/Item",stcData.icon)
		self.mImage_DiamondIcon.sprite = sprite
		self.mImage_GoodsPrices_CoinImage.sprite = sprite
		self.mImage_UserCoin_CoinImage.sprite = sprite

		local count = 0
		if stcData.type == 1 then
			count = NetCmdItemData:GetResItemCount(stcData.id)
		elseif stcData.type == 3 then
			count = NetCmdItemData:GetItemCount(stcData.id)
		elseif stcData.type == 6 then
			count = GlobalData.GetStaminaResourceItemCount(stcData.id)
		end
		self.mText_UserCoin_CountText.text = count
	end

	local currency = self:GetCurrencyAmount()
	local div = currency / self.mData.price
	self.mMaxNumPerPurchase = math.floor(div)


	if(self.mMaxNumPerPurchase > UIQuicklyBuyPanelItemView.MAX_PURCHASE_AMOUNT) then
		self.mMaxNumPerPurchase = UIQuicklyBuyPanelItemView.MAX_PURCHASE_AMOUNT
	end



	UIUtils.GetButtonListener(self.mBtn_Buy.gameObject).onClick = function()
		self:OnBuyClicked()
	end

	UIUtils.GetButtonListener(self.mBtn_JumpStore.gameObject).onClick = function()
		self.OnJumpCallback()
	end

	UIUtils.GetButtonListener(self.mTrans_Close.gameObject).onClick = function()
		self:OnCancelClicked()
	end


	if(self.mData.price_type ~= UIQuicklyBuyPanelItemView.REAL_MONEY_ID and self.mData.price_type ~= UIQuicklyBuyPanelItemView.GUILD_RESOURCE_ID) then --非rmb 非公会币B
		UIUtils.GetListener(self.mBtn_AmountPlusButton.gameObject).onClick = self.OnIncreaseClicked
		UIUtils.GetListener(self.mBtn_AmountMinusButton.gameObject).onClick = self.OnDecreaseClicked
		UIUtils.GetListener(self.mBtn_AmountMaxButton.gameObject).onClick = self.OnMaxClicked

		self.mGoodsAmountInputField.onValueChanged:AddListener(self.OnGoodsAmountValueChanged)
	else
		setactive(self.mBtn_AmountPlusButton.gameObject,false)
		setactive(self.mBtn_AmountMinusButton.gameObject,false)
		setactive(self.mBtn_AmountMaxButton.gameObject,false)
		setactive(self.mText_AmountText.gameObject,false)
	end

	local itemBtn = UIUtils.GetListener(self.mBtn_DiamondCancel.gameObject)
	itemBtn.onClick = self.CancelGotoBuyDiamond
	itemBtn.param = self

	self:InitAmount()
end



function UIQuicklyBuyPanelItemView:InitAmount()
	local view = self
	local price = formatnum(view.mData.price * view.mCurBuyAmount)

	if(self.CheckRichEnough(price,view.mData.price_type)) then
		view.mText_AmountText.color = UIQuicklyBuyPanelItemView.ColorGreen
		view.mText_Price.color = UIQuicklyBuyPanelItemView.ColorBlack
		view.mText_UserCoin_CountText.color = UIQuicklyBuyPanelItemView.ColorWhite
		view.mBtn_Buy.interactable = true
	else
		view.mText_AmountText.color = Color.red
		view.mText_Price.color = Color.red
		view.mText_UserCoin_CountText.color = Color.red
		view.mBtn_Buy.interactable = false
	end

	local canBuy = UIQuicklyBuyPanelItemView.GetGunCoreBuyLimit(view.mData)

	if(canBuy < view.mCurBuyAmount) then
		view.mBtn_Buy.interactable = false;
	else
		view.mBtn_Buy.interactable = true;
	end
end

function UIQuicklyBuyPanelItemView.OnIncreaseClicked(gameObj)
	self = UIQuicklyBuyPanelItemView
	local view = UIQuicklyBuyPanelItemView.Instance

	--if view.mData.limit == 0 and view.mData.hasRefreshTime == false and view.mCurBuyAmount < UIQuicklyBuyPanelItemView.mMaxNumPerPurchase then
	if view.mData.limit == 0  and view.mCurBuyAmount < UIQuicklyBuyPanelItemView.mMaxNumPerPurchase then
		view.mCurBuyAmount = view.mCurBuyAmount + 1
	elseif view.mCurBuyAmount < view.mData.remain_times then
		view.mCurBuyAmount = view.mCurBuyAmount + 1
	end

	local canBuy = UIQuicklyBuyPanelItemView.GetGunCoreBuyLimit(view.mData)
	
	view.mCurBuyAmount = math.min(view.mCurBuyAmount, canBuy)
	view.mCurBuyAmount = math.max(view.mCurBuyAmount,1)

	local price = formatnum(view.mData.price * view.mCurBuyAmount)
	gfdebug(view.mCurBuyAmount)
	view.mGoodsAmountInputField.text = view.mCurBuyAmount
	view.mText_Price.text = price
	view.mText_GoodsPrices_PricesText.text = price

	if(self.CheckRichEnough(price,view.mData.price_type)) then
		view.mText_AmountText.color = UIQuicklyBuyPanelItemView.ColorGreen
		view.mText_Price.color = UIQuicklyBuyPanelItemView.ColorBlack
		view.mText_UserCoin_CountText.color = UIQuicklyBuyPanelItemView.ColorWhite
		view.mBtn_Buy.interactable = true
	else
		view.mText_AmountText.color = Color.red
		view.mText_Price.color = Color.red
		view.mText_UserCoin_CountText.color = Color.red
		view.mBtn_Buy.interactable = false
	end

	if(canBuy < view.mCurBuyAmount) then
		local hint = TableData.GetHintById(40004)
		CS.PopupMessageManager.PopupString(hint)
		view.mBtn_Buy.interactable = false;
	else
		view.mBtn_Buy.interactable = true;
	end
end

function UIQuicklyBuyPanelItemView.GetGunCoreBuyLimit(data)
	if(data.price_type == 10 and UIFacilityBarrackPanel.CurrentGun ~= nil)  then
		if(UIFacilityBarrackPanel.CurrentGun.cmdData ~= nil) then
			local curNum = NetCmdItemData:GetItemCount(data.ItemNumList[0].itemid);
			local needNum = UIFacilityBarrackPanel.CurrentGun.cmdData:GetUpgradeGunCostByStar(UIFacilityBarrackPanel.CurrentGun.cmdData.upgrade);
			local canBuy = math.max(needNum - curNum,0);
			return canBuy;
		else
			local curNum = NetCmdItemData:GetItemCount(data.ItemNumList[0].itemid);
			local needNum = tonumber(UIFacilityBarrackPanel.CurrentGun.tableData.gun_unlock_cost)
			local canBuy = math.max(needNum - curNum,0);
			return canBuy;
		end
	end

	return UIQuicklyBuyPanelItemView.MAX_PURCHASE_AMOUNT;
end

function UIQuicklyBuyPanelItemView.OnDecreaseClicked(gameObj)
	self = UIQuicklyBuyPanelItemView
	local view = UIQuicklyBuyPanelItemView.Instance

	if view.mCurBuyAmount > 1 then
		view.mCurBuyAmount = view.mCurBuyAmount - 1
	end

	local canBuy = UIQuicklyBuyPanelItemView.GetGunCoreBuyLimit(view.mData)

	local price = formatnum(view.mData.price * view.mCurBuyAmount)
	view.mGoodsAmountInputField.text = view.mCurBuyAmount
	view.mText_Price.text = price
	view.mText_GoodsPrices_PricesText.text = price

	if(self.CheckRichEnough(price,view.mData.price_type)) then
		view.mText_AmountText.color = UIQuicklyBuyPanelItemView.ColorGreen
		view.mText_Price.color = UIQuicklyBuyPanelItemView.ColorBlack
		view.mText_UserCoin_CountText.color = UIQuicklyBuyPanelItemView.ColorWhite
		view.mBtn_Buy.interactable = true
	else
		view.mText_AmountText.color = Color.red
		view.mText_Price.color = Color.red
		view.mText_UserCoin_CountText.color = Color.red
		view.mBtn_Buy.interactable = false
	end

	if(canBuy < view.mCurBuyAmount) then
		local hint = TableData.GetHintById(40004)
		CS.PopupMessageManager.PopupString(hint)
		view.mBtn_Buy.interactable = false;
	else
		view.mBtn_Buy.interactable = true;
	end
end

function UIQuicklyBuyPanelItemView.OnMaxClicked(gameObj)
	self = UIQuicklyBuyPanelItemView
	local view = UIQuicklyBuyPanelItemView.Instance
	local maxNum = 1
	if view.mData.limit == 0 then
		local currency = view:GetCurrencyAmount()
		maxNum = currency / view.mData.price
		maxNum = math.min( maxNum, UIQuicklyBuyPanelItemView.MAX_PURCHASE_AMOUNT)
		maxNum = math.floor(maxNum)
	elseif view.mData.remain_times > 0 then
		local currency = view:GetCurrencyAmount()
		maxNum = currency / view.mData.price
		maxNum = math.min( maxNum, view.mData.remain_times)
		maxNum = math.floor(maxNum)
	end

	local canBuy = UIQuicklyBuyPanelItemView.GetGunCoreBuyLimit(view.mData)

	maxNum = math.min( maxNum, canBuy)

	if(maxNum <= 0) then
		maxNum = 1
	end

	view.mCurBuyAmount = maxNum
	local price = formatnum(view.mData.price * view.mCurBuyAmount)
	view.mGoodsAmountInputField.text = view.mCurBuyAmount
	view.mText_Price.text = price
	view.mText_GoodsPrices_PricesText.text = price

	if(self.CheckRichEnough(price,view.mData.price_type)) then
		view.mText_AmountText.color = UIQuicklyBuyPanelItemView.ColorGreen
		view.mText_Price.color = UIQuicklyBuyPanelItemView.ColorBlack
		view.mText_UserCoin_CountText.color = UIQuicklyBuyPanelItemView.ColorWhite
		view.mBtn_Buy.interactable = true
	else
		view.mText_AmountText.color = Color.red
		view.mText_Price.color = Color.red
		view.mText_UserCoin_CountText.color = Color.red
		view.mBtn_Buy.interactable = false
	end

	if(canBuy < view.mCurBuyAmount) then
		local hint = TableData.GetHintById(40004)
		CS.PopupMessageManager.PopupString(hint)
		view.mBtn_Buy.interactable = false;
	else
		view.mBtn_Buy.interactable = true;
	end
end

function UIQuicklyBuyPanelItemView.OnGoodsAmountValueChanged()

	local view = UIQuicklyBuyPanelItemView.Instance
	local num = tonumber(view.mGoodsAmountInputField.text)

	if(num == nil or num == 0) then
		num = 1
	end

	local maxNum = view.mData.remain_times
	--if(view.mData.limit == 0 and view.mData.hasRefreshTime == false) then
	if(view.mData.limit == 0 ) then
		maxNum = UIQuicklyBuyPanelItemView.mMaxNumPerPurchase
	end

	if(maxNum < num) then
		num = maxNum
	end

	if(0 >= num) then
		num = 1
	end

	view.mCurBuyAmount = num

	local price = formatnum(view.mData.price * view.mCurBuyAmount)
	view.mGoodsAmountInputField.text = view.mCurBuyAmount
	view.mText_Price.text = price
	view.mText_GoodsPrices_PricesText.text = price

	if(view.CheckRichEnough(price,view.mData.price_type)) then
		view.mText_AmountText.color = UIQuicklyBuyPanelItemView.ColorGreen
		view.mText_Price.color = UIQuicklyBuyPanelItemView.ColorBlack
		view.mText_UserCoin_CountText.color = UIQuicklyBuyPanelItemView.ColorWhite
		view.mBtn_Buy.interactable = true
	else
		view.mText_AmountText.color = Color.red
		view.mText_Price.color = Color.red
		view.mText_UserCoin_CountText.color = Color.red
		view.mBtn_Buy.interactable = false
	end
end

function UIQuicklyBuyPanelItemView.CheckRichEnough(total_price, price_type)
	if(price_type == UIQuicklyBuyPanelItemView.REAL_MONEY_ID) then
		return true
	end

	local view = UIQuicklyBuyPanelItemView.Instance
	local currency = view:GetCurrencyAmount()

	if(total_price > currency) then
		return false

	else
		if view.mData.remain_times <= 0 and view.mData.limit ~= 0 then
			return false
		end
		return true
	end
end

function UIQuicklyBuyPanelItemView:GetCurrencyAmount()
	local currency = 0
	local stcData = TableData.GetItemData(self.mData.price_type)
	printstack(self.mData.price_type)
	if(stcData ~= nil and stcData.type ~= 1) then
		local data = NetCmdItemData:GetNormalItem(self.mData.price_type)
		if(data == nil) then
			currency = 0
		else
			currency = data.item_num
		end
		--elseif(stcData.id == 1) then
		--	currency = GlobalData.diamond
		--elseif(stcData.id == 2) then
		--	currency = GlobalData.cash
		--end
	else
		currency = NetCmdItemData:GetResItemCount(stcData.id)
	end
	return currency
end

function UIQuicklyBuyPanelItemView.CancelGotoBuyDiamond(gameObj)
	self = UIQuicklyBuyPanelItemView
	local view = UIQuicklyBuyPanelItemView.Instance
	setactive(view.mTrans_BuyDiamond.gameObject,false)
end


function UIQuicklyBuyPanelItemView:OnBuyClicked()
	-- self = UIQuicklyBuyPanelItemView
	local view = self
	local data = self.mData
	local num = view.mCurBuyAmount
	local price = view.mData.price * view.mCurBuyAmount

	if(data.IsTagShowTime == false) then
		MessageBox.Show("提示", "该商品已过期!", MessageBox.ShowFlag.eMidBtn, price,nil, nil)
		gfdestroy(view:GetRoot().gameObject)
		UIQuicklyBuyPanelItemView.Instance = nil
		return
	end

	--if((data.limit ~= 0 or data.hasRefreshTime == true) and view.mData.remain_times <= 0) then
	if((data.limit ~= 0) and view.mData.remain_times <= 0) then
		MessageBox.Show("提示", "购买次数不足!", MessageBox.ShowFlag.eMidBtn, price,nil, nil)
		return
	end


	if(self.CheckRichEnough(price,view.mData.price_type) == false) then
		--local diamond = NetTeamHandle:GetMaintainResDiomandNum();
		--local delta = formatnum(price - diamond);
		--
		--if(view.mData.price_type == 1) then
		--	--MessageBox.Show("钻石不足", "还缺少"..delta.."钻石，是否前往购买？", MessageBox.ShowFlag.eNone, price,self.ConfirmGotoBuyDiamond, nil);
		--	UICommonLackToBuyView.OpenLackToBuyPanel(view.mUIRoot.parent, view.mCurCurrencyId,delta)
		---- elseif(view.mData.price_type == UIStoreConfirmPanelView.GUN_CORE_ID or view.mData.price_type == UIStoreConfirmPanelView.CHIP_CORE_ID) then
		---- 	MessageBox.Show("提示", "碎片币不足!", MessageBox.ShowFlag.eMidBtn, price,nil, nil);
		---- elseif(view.mData.price_type == UIStoreConfirmPanelView.GUILD_COIN_ID) then
		---- 	MessageBox.Show("提示", "车队声望不足!", MessageBox.ShowFlag.eMidBtn, price,nil, nil);
		---- elseif(view.mData.price_type == UIStoreConfirmPanelView.GUILD_RESOURCE_ID) then
		---- 	MessageBox.Show("提示", "车队资源不足!", MessageBox.ShowFlag.eMidBtn, price,nil, nil);
		--else
		--	local uiRepoItem = UIGetWayView:New()
		--	uiRepoItem:InitCtrl(UIStoreConfirmPanelView.mObj.transform)
		--	self.HowToGetPanel = uiRepoItem
		--	self.HowToGetPanel:SetData(view.mCurCurrencyId)
		--end
		local str = ""
		if(view.mData.price_type > 0) then
			local stcData = TableData.GetItemData(view.mData.price_type);

			if(stcData == nil) then
				gferror("未知的PriceType"..data.price_type..",Item表里没有该ID");
				return
			end
			str = stcData.name.str
		end
		CS.PopupMessageManager.PopupString(string_format(TableData.GetHintById(225), str))
		return;
	else
		setactive(view.mTrans_BuyDiamond.gameObject,false);
	end

	if(data.price_type ~= UIQuicklyBuyPanelItemView.REAL_MONEY_ID) then --非rmb购买
		if(data.price_type ~= UIQuicklyBuyPanelItemView.GUILD_RESOURCE_ID) then
			NetCmdStoreData:SendStoreBuy(data.id,num, function(ret)
				self:OnBuyCallback(ret)
			end)
		else
			NetCmdStoreData:SendSocialBuyStore(data.id,function(ret)
				self:OnBuyCallback(ret)
			end)
		end
	else --RMB购买
		NetCmdStoreData:SendStoreOrder(data.id,function(ret)
			self:OnBuyCallback(ret)
		end)
	end

	setactive(self.mTrans_Mask.gameObject, true)
end

function UIQuicklyBuyPanelItemView:OnCancelClicked()
	gfdestroy(self:GetRoot().gameObject)
	UIQuicklyBuyPanelItemView.Instance = nil
end

function UIQuicklyBuyPanelItemView:OnBuyCallback(ret)
	-- self = UIQuicklyBuyPanelItemView

	if ret == CS.CMDRet.eSuccess then
		gfdebug("购买成功")
		self.OnBuySuccessCallback()
		CS.PopupMessageManager.PopupStoreGood(self.mData.id, self.mCurBuyAmount)
		self.mCurBuyAmount = 1
		self:InitData(self.mData, self.mCurCurrencyId, self.mItemId, self.OnBuySuccessCallback, self.OnJumpCallback)
		--MessageSys:RemoveListener(CS.Cmd.CmdDef.store_buy:GetHashCode() * 1000, UIQuicklyBuyPanelItemView.ErrorMsgHandle)
	else
		gfdebug("购买失败")
		MessageBox.Show("出错了", "购买失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
	end
	setactive(self.mTrans_Mask.gameObject, false)
end

function UIQuicklyBuyPanelItemView.ErrorMsgHandle(content)
	self = UIQuicklyBuyPanelItemView
	local msg = content.Sender
	if(msg == "StoreTagLimitedNotFound") then
		MessageBox.Show("出错了", "该商品已过期!", MessageBox.ShowFlag.eMidBtn, price,nil, nil)
	else
		MessageBox.Show("出错了", "购买失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
	end
end

--- 获取商品数据，有些商品有跳转购买
function UIQuicklyBuyPanelItemView:GetGoodData(goodData)
	if goodData.remain_times > 0 or goodData.limit == 0 then  --- 表示还能购买
		return goodData
	else							--- 不能购买，找跳转商品
		local nextGoodData = NetCmdStoreData:GetStoreGoodById(goodData.jump_id)
		if nextGoodData then
			local data = NetCmdStoreData:GetStoreGoodById(nextGoodData.id)
			return self:GetGoodData(data)
		else
			return goodData
		end
	end
end



