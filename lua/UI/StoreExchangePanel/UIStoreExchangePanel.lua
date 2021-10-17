---
--- Created by Lile
--- DateTime: 26/12/19 16:21

require("UI.UIBasePanel")

UIStoreExchangePanel = class("UIStoreExchangePanel", UIBasePanel);
UIStoreExchangePanel.__index = UIStoreExchangePanel;

UIStoreExchangePanel.mTagButtons = nil;
UIStoreExchangePanel.mCurTagIndex = 0;    --对应 store_tag 表
UIStoreExchangePanel.mCurSideTagIndex = 0; --左边tag
UIStoreExchangePanel.mStoreItems = {};

UIStoreExchangePanel.mTagTimer = nil;
UIStoreExchangePanel.mDefaultSelect = nil;
UIStoreExchangePanel.Instance = nil;

UIStoreExchangePanel.mTopTagItems = {};

UIStoreExchangePanel.mUITopResourceBar = nil;
UIStoreExchangePanel.mRoot = nil;

function UIStoreExchangePanel:ctor()
	UIStoreExchangePanel.super.ctor(self);
end

function UIStoreExchangePanel.Open()
	UIStoreExchangePanel.OpenUI(UIDef.UIStoreExchangePanel);
end

function UIStoreExchangePanel.Close()
	self = UIStoreExchangePanel;
	UIManager.CloseUI(UIDef.UIStoreExchangePanel);

end

function UIStoreExchangePanel.Init(root, data)
	self = UIStoreExchangePanel;
	UIStoreExchangePanel.Instance = self;
	self.mData = data;
	self.mView = UIStoreExchangePanelView;
	self.mView:InitCtrl(root);
	self.mRoot = root;
	
	if data ~= nil then
		self.mCurSideTagIndex = data;
	else
		self.mCurSideTagIndex = TableData.GlobalSystemData.StoreexchangeDefaultTag;
	end
	local sideTagData = TableData.listStoreSidetagDatas:GetDataById(self.mCurSideTagIndex);
	
	self:GetCurSideTagDefaultStoreTag(sideTagData)

	local storeTagData = TableData.listStoreTagDatas:GetDataById(self.mCurTagIndex);
	if storeTagData ~= nil then
		UITopResourceBar.Init(root, storeTagData.trade_item_list);
	end
end

function UIStoreExchangePanel.OnInit()
	--UIManager.OpenUI(UIDef.UIStoreExchangeTopBarPanel)
	
	self = UIStoreExchangePanel;

	self.mTagButtons = List:New();

	setactive(self.mView.mBtn_RenewButton,false);
	setactive(self.mView.mTrans_Refresh,false);
	UIUtils.GetButtonListener(self.mView.mBtn_Return.gameObject).onClick = self.OnReturnClick;
	UIUtils.GetButtonListener(self.mView.mBtn_RenewButton.gameObject).onClick = self.OnRenewClick;

	
	
	self:InitTagButtons();
	self:InitStoreItems();

	MessageSys:AddListener(CS.GF2.Message.StoreEvent.StoreExchangeRefresh,self.OnAutoRefresh);

	UIUtils.GetButtonListener(self.mView.mBtn_CommandCenter.gameObject).onClick = function()
		--NetCmdStoreData:SendStoreTagRefresh(1,false,self.UpdateRefreshTime)
		UIManager.JumpToMainPanel()
	end
end



function UIStoreExchangePanel:InitTagButtons()
	--local storeTagList = TableData.listStoreTagDatas;
	--local defaultSelect = nil;

	local storeSideTagList = TableData.listStoreSidetagDatas;
	self.mTagButtons:Clear();

	for i = 0, self.mView.mTrans_ButtonList.transform.childCount-1 do
		local obj = self.mView.mTrans_ButtonList.transform:GetChild(i);
		gfdestroy(obj);
	end

	for i= 0, storeSideTagList.Count - 1 do
		--local curSideTag = storeSideTagList[i];

		local data = storeSideTagList[i];
		local hide = (data.SidetagType ~= CS.GF2.Data.StoreTagType.Exchange and data.SidetagType ~= CS.GF2.Data.StoreTagType.Blackmarket);
		
		
		if(hide == false) then
			if(self.mCurSideTagIndex == 0) then
				self.mCurSideTagIndex = data.id;
			end

			local item = ExchangeTagItem.New();
			item:InitCtrl(self.mView.mTrans_ButtonList);
			item:InitData(data);
			local listener = UIUtils.GetButtonListener(item.mBtnSelf.gameObject);
			listener.onClick = self.OnTagButtonClicked;
			listener.param = data.id;
			listener.paramData = item;

			self.mTagButtons:Add(item);

			if (data.id == self.mCurSideTagIndex) then
				self.mDefaultSelect = item.mBtnSelf.gameObject;
			end
		end
	end

	TimerSys:DelayCall(0.1,function(idx)
			self.OnTagButtonClicked(self.mDefaultSelect);
		end,nil);


end

function UIStoreExchangePanel.OnTagButtonClicked(gameObj)
	self = UIStoreExchangePanel;
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		if(eventTrigger.paramData.mIsLocked) then
			TipsManager.NeedLockTips(eventTrigger.paramData.mData.unlock);
			return;
		end

		self.mCurSideTagIndex = eventTrigger.param
	end

	

	local selectData = nil;
	for i = 1, #self.mTagButtons do
		self.mTagButtons[i]:SetSelect(false);

		if(self.mTagButtons[i].mData.id == self.mCurSideTagIndex) then
			self.mTagButtons[i]:SetSelect(true);
			selectData = self.mTagButtons[i].mData;
			
			--UIStoreExchangePanel.UpdateResourceBar(self.mTagButtons[i].mData);
		end
	end

	self:GetCurSideTagDefaultStoreTag(selectData)
	self:RefreshSingleTag()
	
end

-- 右侧和左侧的商店
function UIStoreExchangePanel:RefreshSingleTag()
	
	self:InitStoreItems();

	self.RefreshStoreItemsByTag();
	self.RefreshBlackMarket();
	self.UpdateRefreshTime();
	self.UpdateRefreshBtn();

	local storeTagData = TableData.listStoreTagDatas:GetDataById(self.mCurTagIndex);
	if storeTagData ~= nil then
		UIStoreExchangePanel.UpdateResourceBar(storeTagData);
	end
end


function UIStoreExchangePanel.UpdateRefreshBtn()
	self = UIStoreExchangePanel;

	if(NetCmdStoreData:ShowRefreshButton(self.mCurTagIndex)) then
		setactive(self.mView.mBtn_RenewButton,true);
		setactive(self.mView.mTrans_Refresh,true);

		local priceData = NetCmdStoreData:GetRefreshPriceByTag(self.mCurTagIndex);
		local stcData = TableData.listItemDatas:GetDataById(priceData.itemid);

		if(priceData.num <= 0) then
			local hint = TableData.GetHintById(60013);
			self.mView.mText_CostNum.text = hint;
		else
			self.mView.mText_CostNum.text = priceData.num;
		end
		self.mView.mImage_CostItem.sprite = UIUtils.GetIconSprite("Icon/"..stcData.IconPath ,stcData.Icon);

		local has = NetCmdItemData:GetResItemCount(stcData.id);

		if(has < priceData.num) then
			self.mView.mBtn_RenewButton.interactable = false;
			self.mView.mText_CostNum.color = Color.red;
		else
			self.mView.mBtn_RenewButton.interactable = true;
			self.mView.mText_CostNum.color = Color.black;
		end
	else
		
		setactive(self.mView.mBtn_RenewButton,false);
		setactive(self.mView.mTrans_Refresh,false);
	end

end

function UIStoreExchangePanel.UpdateRefreshTime()
	self = UIStoreExchangePanel;

	if(self.mTagTimer ~= nil) then
		self.mTagTimer:Stop()
		-- TimerSys:Remove(self.mTagTimer);
	end
	self.StartTagCountDown();
	--self.RefreshBlackMarket();
	self:ClearStoreItems();
	self:InitStoreItems();
end

function UIStoreExchangePanel.RefreshBlackMarket()
	self = UIStoreExchangePanel;
	local countdown = NetCmdStoreData:GetStoreTagTimeInt(self.mCurTagIndex);

	if(countdown < 0  ) then
		NetCmdStoreData:SendStoreTagRefresh(self.mCurTagIndex,false,self.UpdateRefreshTime)
	end
end

function UIStoreExchangePanel.StartTagCountDown()
	self = UIStoreExchangePanel;

	if(NetCmdStoreData:StoreTagCanRefresh(self.mCurTagIndex)) then
		return;
	end

	local countdown = NetCmdStoreData:GetStoreTagTimeInt(self.mCurTagIndex);
	if(countdown == 0 ) then
		NetCmdStoreData:SendStoreTagRefresh(self.mCurTagIndex,false,self.UpdateRefreshTime)
		return;
	end

	self.mTagTimer = TimerSys:DelayCall(1, self.StartTagCountDown, nil);

	if(countdown > 0) then
		self.mView.mText_CountDown.text = NetCmdStoreData:GetStoreTagRefreshTime(self.mCurTagIndex);
		setactive(self.mView.mText_CountDown.transform.parent,true);
		-- else
		-- 	setactive(self.mView.mText_CountDown.transform.parent,false);
	end
end

UIStoreExchangePanel.mLastPanelResource = nil;
UIStoreExchangePanel.mIsOpen = false;

function UIStoreExchangePanel.UpdateResourceBar(tagData)

	--UIStoreExchangeTopBarPanel.OnUpdateData(tagData.trade_item_list);
	UITopResourceBar:UpdateCurrencyContent(self.mRoot, tagData.trade_item_list)
end

function UIStoreExchangePanel:InitStoreItems()

	for i = 0, self.mView.mLayout_List.transform.childCount-1 do
		local obj = self.mView.mLayout_List.transform:GetChild(i);
		gfdestroy(obj);
	end

	self.mStoreItems = {};

	self.mGoodDatas = List:New(CS.Cmd.StoreGoods);
	local storeGoodList = NetCmdStoreData:GetStoreGoodsList();
	for i = 0, storeGoodList.Count-1 do
		local goods = storeGoodList[i];
		self.mGoodDatas:Add(goods);
	end

	local function compareBySort(elem1,elem2)
		return elem1.sort<elem2.sort
	end

	self.mGoodDatas:Sort(compareBySort);

	for i = 1, self.mGoodDatas:Count() do
		local goods = self.mGoodDatas[i];

		if(goods.IsShowTime and goods.tag == self.mCurTagIndex and  goods.IsCurrentSection and goods.is_unlocked) then

			local item = ExchangeGoodsItem.New();
			item:InitCtrl(self.mView.mLayout_List.transform);
			item:InitData(goods);

			if(goods.remain_times ~= 0 or goods.limit == 0) then
				local itemBtn = UIUtils.GetButtonListener(item.mUIRoot.gameObject);
				itemBtn.onClick = self.OnGoodsItemClicked;
				itemBtn.param = item;
				itemBtn.paramData = nil;
			end

			self.mStoreItems[goods.id] = item;

		end
	end

	self.RefreshStoreItemsByTag();
end

function UIStoreExchangePanel.RefreshStoreItemsByTag( )
	self = UIStoreExchangePanel;
	local tagType = NetCmdStoreData:GetStoreTagType(self.mCurTagIndex);

	for k,v in pairs(self.mStoreItems) do
		local item = v;
		if(item.mData.tag == self.mCurTagIndex) then
			if(not item.mData.IsCurrentSection) then
				setactive(item:GetRoot().gameObject,false);
			else
				setactive(item:GetRoot().gameObject,true);
			end
		else
			setactive(item:GetRoot().gameObject,false);
		end
	end
end

UIStoreExchangePanel.IsConfirmPanelOpening = false;
function UIStoreExchangePanel.OnGoodsItemClicked(gameObj)
	self = UIStoreExchangePanel;

	--if(UIStoreExchangePanel.IsConfirmPanelOpening == true) then
	--	return;
	--end
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		UIStoreExchangePanel.IsConfirmPanelOpening = true;
		local item = eventTrigger.param;
		self:OpenConfirmPanel(item.mData);
	end
end

----------------------------------购买确认面板逻辑------------------------------------------
function UIStoreExchangePanel:OpenConfirmPanel(data)
	gfdebug("OpenConfirmPanel")
	UIStoreConfirmPanelView.OpenConfirmPanel(data,self.mView.mUIRoot,data.price_type,self.OnBuySuccess,self.OnConfirmGotoBuyDiamond);

	UITopResourceBar.Hide()
end

function UIStoreExchangePanel.OnConfirmGotoBuyDiamond(tagId)
	self = UIStoreExchangePanel;

	gfdebug("OnConfirmGotoBuyDiamond")
	self.mCurTagIndex = tagId;
	self:InitTagButtons();
	self:RefreshStoreItemsByTag();
end

function UIStoreExchangePanel.OnBuySuccess()
	gfdebug("OnBuySuccess");
	self = UIStoreExchangePanel;
	self.UpdateStoreGood();

end

function UIStoreExchangePanel.UpdateStoreGood()
	self = UIStoreExchangePanel;
	self.OnRefreshStoreGood(CS.CMDRet.eSuccess);
end

function UIStoreExchangePanel.OnRefreshStoreGood(ret)
	self = UIStoreExchangePanel;

	if ret == CS.CMDRet.eSuccess then
		gfdebug("刷新商品列表");
		self:ClearStoreItems();
		self:InitStoreItems();

		self.UpdateRefreshTime();
		self.UpdateRefreshBtn();
	else
		gfdebug("刷新商品列表失败");
		MessageBox.Show("出错了", "刷新商品列表失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
	end
end

function UIStoreExchangePanel.OnRenewClick(gameobj)
	self = UIStoreExchangePanel;
	local hint = TableData.GetHintById(60047)
	MessageBox.Show("注意", hint, MessageBox.ShowFlag.eNone, nil, UIStoreExchangePanel.OnRenew, nil);
end

function UIStoreExchangePanel.OnRenew()
	self = UIStoreExchangePanel;
	NetCmdStoreData:SendStoreTagRefresh(self.mCurTagIndex,true,self.OnManualRefresh);
end

function UIStoreExchangePanel.OnManualRefresh(ret)
	self = UIStoreExchangePanel;
	self.OnRefreshStoreGood(ret);

	if ret == CS.CMDRet.eSuccess then
		local hint = TableData.GetHintById(60011)
		CS.PopupMessageManager.PopupString(hint)
	end
end

function UIStoreExchangePanel.OnAutoRefresh(msg)
	self = UIStoreExchangePanel;
	self.OnRefreshStoreGood(CS.CMDRet.eSuccess);
end

------------------------------------------------------------------------------------------------------

function UIStoreExchangePanel:ClearStoreItems()

	for k,v in pairs(self.mStoreItems) do
		local item = v;
		gfdestroy(v.mUIRoot.gameObject);
	end

	self.mStoreItems = {};
end

function UIStoreExchangePanel.Hide()
	self = UIStoreExchangePanel;
	self:Show(false);
end

function UIStoreExchangePanel.OnReturnClick(gameobj)
	self = UIStoreExchangePanel;
	--UIStoreExchangeTopBarPanel.Close()
	UITopResourceBar.Release()
	
	UIStoreExchangePanel.Close();

end

function UIStoreExchangePanel:GetCurSideTagDefaultStoreTag(sideTag)
	local strArr = string.split(sideTag.IncludeTag, ',')
	self.mCurTagIndex = tonumber(strArr[1]) --默认切换标签时
	self:InitSideTag(sideTag);
end
--
function UIStoreExchangePanel:InitSideTag(sideTag)
	
	for k, v in pairs(self.mTopTagItems) do
		gfdestroy(v);
	end

	local strArr = string.split(sideTag.IncludeTag, ',')
	self.mTopTagItems = {};
	if #strArr > 1 then
		setactive(self.mView.mTrans_TopTabContent.gameObject,true)
		for i = 1, #strArr do
			local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComTabBtn1ItemV2.prefab", self))
			table.insert(self.mTopTagItems, obj)
			obj.transform:SetParent(self.mView.mTrans_TopTabContent, true);
			obj.transform.localPosition = vectorzero;
			obj.transform.localScale = vectorone;
			UIUtils.GetButtonListener(obj.gameObject).onClick = function()
				UIStoreExchangePanel:OnTopTagClick(i);
			end;

			obj.gameObject.transform:GetComponent("Button").interactable = tonumber(strArr[i]) ~= self.mCurTagIndex;
			
			local storeTagData = TableData.listStoreTagDatas:GetDataById(tonumber(strArr[i]));
			if storeTagData ~= nil then
				obj.transform:Find("Root/GrpText/Text_Name"):GetComponent("Text").text = storeTagData.name.str;
				local isLock  =not AccountNetCmdHandler:CheckSystemIsUnLock(storeTagData.unlock);
				local lockTransform = obj.transform:Find("Root/GrpLock");
				setactive( lockTransform.gameObject,isLock)
 
			end
		end
	else
		setactive(self.mView.mTrans_TopTabContent.gameObject,false)
		--UIStoreExchangePanel:OnTopTagClick(1)
	end
end


function UIStoreExchangePanel:OnTopTagClick(index)
	
	local sideTagData = TableData.listStoreSidetagDatas:GetDataById(self.mCurSideTagIndex);
	local strArr = string.split(sideTagData.IncludeTag, ',')

	for k, v in pairs(strArr) do
		if index == k then
			local tagId = tonumber(v)
			local storeTagData = TableData.listStoreTagDatas:GetDataById(tagId);
			local isLock = not AccountNetCmdHandler:CheckSystemIsUnLock(storeTagData.unlock);
			if isLock == true then
				TipsManager.NeedLockTips(storeTagData.unlock);
				return;
			end
		end
	end
	
	
	for k, obj in pairs(self.mTopTagItems) do
		obj.gameObject.transform:GetComponent("Button").interactable = index ~= k;
	end

	for k,v in pairs(strArr) do
		if index == k then
			self.mCurTagIndex = tonumber(v)
		end
	end
	
	self:RefreshSingleTag()
end


function UIStoreExchangePanel.OnRelease()
	self = UIStoreExchangePanel;
	UIStoreExchangePanel.mView = nil;
	UIStoreExchangePanel.mCurTagIndex = 0;
	UIStoreExchangePanel.mCurSideTagIndex = 0;

	if self.mTagTimer ~=nil then
		self.mTagTimer:Stop()
	end
	
	-- TimerSys:Remove(self.mTagTimer);
	MessageSys:RemoveListener(CS.GF2.Message.StoreEvent.StoreExchangeRefresh,self.OnAutoRefresh);

	--if UIUniTopBarPanel~= nil then
	--	local resData = UIUniTopBarPanel.mData;
	--	if(UIStoreExchangePanel.mLastPanelResource ~= nil) then
	--		resData.Resources = UIStoreExchangePanel.mLastPanelResource;
	--		UIUniTopBarPanel.OnUpdateData(resData);
	--		UIStoreExchangePanel.mLastPanelResource = nil;
	--	end
	--end

	UIStoreExchangePanel.Instance = nil;
end