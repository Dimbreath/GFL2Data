---
--- Created by Lile
--- DateTime: 26/12/19 16:21

require("UI.UIBasePanel")
require("UI.UITweenCamera")
require("UI.StorePanel.UIStorePanelView")
require("UI.StorePanel.Item.UIGoodsItem")
require("UI.StorePanel.UIStoreConfirmPanelView")
require("UI.StorePanel.UIStoreSkinPanel");
require("UI.StoreCoin.StoreCoin")
require("UI._TagButtonItem.UI_TagButtonItem")

UIStorePanel = class("UIStorePanel", UIBasePanel);
UIStorePanel.__index = UIStorePanel;

--UI路径
UIStorePanel.m3DCanvasRootPath = "FormationCameraRoot/3DFormationCanvas";
UIStorePanel.mPath_GoodsItem = "Store/UIGoodsItem.prefab";
UIStorePanel.mPath_GoodsItem_Big = "Store/UIGoodsItem_Big.prefab";
UIStorePanel.mPath_ConfirmPanel = "Store/UIStoreConfirmPanel.prefab"
UIStorePanel.mPath_StoreCoin = "Store/StoreCoin.prefab"

--UI控件
UIStorePanel.mView = nil;

--逻辑参数
UIStorePanel.mData = nil;
UIStorePanel.mTagButtons = nil;
UIStorePanel.mCurTagIndex = 1;
UIStorePanel.mStoreItems = {};
UIStorePanel.mIsBubbling = false;
UIStorePanel.mIsLeveling = false;

UIStorePanel.mTweenEase = CS.DG.Tweening.Ease.InOutSine;
UIStorePanel.mTweenExpo = CS.DG.Tweening.Ease.InOutCirc;
UIStorePanel.mTweenCirc = CS.DG.Tweening.Ease.OutCirc;

UIStorePanel.mTagTimer = nil;
UIStorePanel.mItemTimer = nil;

UIStorePanel.LevelDuringAnim = 0;

UIStorePanel.mGoodDatas = nil;
UIStorePanel.mStcGelinaId = 1001;
UIStorePanel.mCurCurrencyId = 1;
UIStorePanel.mSpecialTagDataDict = nil;

UIStorePanel.mRTCamera = nil;

function UIStorePanel:ctor()
    UIStorePanel.super.ctor(self);
end

function UIStorePanel.Open()
    UIStorePanel.OpenUI(UIDef.UIStorePanel);
end

function UIStorePanel.Close()
	self = UIStorePanel;
    UIManager.CloseUI(UIDef.UIStorePanel);
	if(self.mData[2] == false) then
		UIMainStorePanel.ShowPanel();
	else
		UIManager.CloseUI(UIDef.UIMainStorePanel);
	end
end

function UIStorePanel.OnHide()
	if(UIMainStorePanel.mGunModel ~= nil) then
		setactive(UIMainStorePanel.mGunModel.transform,false);
	end
end

function UIStorePanel.OnShow()
	if(UIMainStorePanel.mGunModel ~= nil) then
		setactive(UIMainStorePanel.mGunModel.transform,true);
	end

	UIMainStorePanel.mIsOpeningStorePanel = false;
end

function UIStorePanel.Init(root, data)
	self = UIStorePanel;
    self.mData = data;	
	self.mView = UIStorePanelView;
    self.mView:InitCtrl(root);
end

function UIStorePanel.OnInit()
	self = UIStorePanel;
	
	self.mCurTagIndex = self.mData[1];	
	self.mTagButtons = List:New();

	self:InitTagButtons();
	--self:InitSpTagButtons();
	self:InitStoreItems();
	self:InitResources();
	self:InitBubble();
	self.HideAffectionBar();
	
	UIUtils.GetListener(self.mView.mBtn_Return.gameObject).onClick = self.OnReturnClick;
	UIUtils.GetButtonListener(self.mView.mBtn_TouchArea.gameObject).onClick = self.OnTouchGelina;
	UIUtils.GetButtonListener(self.mView.mBtn_SwitchToSkin.gameObject).onClick = self.OnSkinClicked;

	MessageSys:AddListener(130001,self.OnUpdateAffection);
	MessageSys:AddListener(130002,self.OnRefreshGelina);

	self.mRTCamera = UIMainStorePanel.mRTCamera;
end

function UIStorePanel.OnDataUpdate(data)
	self = UIStorePanel
	self.mData = data

	self.OnConfirmGotoBuyDiamond(self.mData[1])
end


function UIStorePanel:InitTagButtons()

	local storeTagList = TableData.listStoreTagDatas;
	local defaultSelect = nil;

	self.mTagButtons = List:New();
	for i = 0, self.mView.mTrans_TagList.transform.childCount-1 do
		local obj = self.mView.mTrans_TagList.transform:GetChild(i);
		gfdestroy(obj);
	end

	for i= 0, storeTagList.Count - 1 do
		local data = storeTagList[i];
		local hide = (data.Type ~= CS.GF2.Data.StoreTagType.Shop);

		if(hide == false) then
			local item = UI_TagButtonItem.New();
			item:InitCtrl(self.mView.mTrans_TagList);
			item:InitData(data);
			local listener = UIUtils.GetButtonListener(item.mBtnSelf.gameObject);
			listener.onClick = self.OnTagButtonClicked;
			listener.param = data.id;

			self.mTagButtons:Add(item);

			if(i == 0) then
				defaultSelect = item.mBtnSelf.gameObject;
			end

			if(self.mCurTagIndex == data.id) then
				defaultSelect = item.mBtnSelf.gameObject;
			end
		end
	end

	--TimerSys:DelayCall(0.1,function(idx) 
		self.OnTagButtonClicked(defaultSelect);       
	--end,nil);
end


function UIStorePanel:InitStoreItems()
	local prefab_s = UIUtils.GetGizmosPrefab(self.mPath_GoodsItem,self);
	local prefab_b = UIUtils.GetGizmosPrefab(self.mPath_GoodsItem_Big,self);

	self:ClearStoreItems();
	
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

			local instObj = nil;		
			if(goods.Type == 0) then
				instObj = instantiate(prefab_s);
			else
				instObj = instantiate(prefab_b);
			end
			
			local item = nil;
			if(goods.Type == 0) then
				item = UIGoodsItem.New();
			else
				item = UIGoodsItem_Big.New();
			end

			item:InitCtrl(instObj.transform);
			item:InitData(goods);
			
			if(goods.remain_times ~= 0 or goods.limit == 0) then
				local itemBtn = UIUtils.GetButtonListener(item.mUIRoot.gameObject);
				itemBtn.onClick = self.OnGoodsItemClicked;
				itemBtn.param = item;
				itemBtn.paramData = nil;
			end		
			
			if(goods.Type == 0) then
				UIUtils.AddListItem(instObj, self.mView.mTrans_GoodsList.transform);
			else
				UIUtils.AddListItem(instObj, self.mView.mTrans_Big.transform);
			end

			self.mStoreItems[goods.id] = item;
		
		end
	end
	
	
	self.RefreshStoreItemsByTag();

end

function UIStorePanel:InitResources()
	setactive(self.mView.mTrans_StoreCoinList,false);
end

function UIStorePanel:InitBubble()
	local bubble = self.mView.mTrans_AffectionBubble.gameObject;
	if(NetCmdStoreData:CanTouchGelina(self.mStcGelinaId) == true) then
		setactive(bubble,true);
		CS.UITweenManager.PlayFadeTweens(bubble.transform,0.0,1.0,0.3,false,nil,self.mTweenExpo);
	end

	self.SetAffectionBar();
end

function UIStorePanel.OnUpdateResource(msg)
	self = UISkillCoreDetailPanel;	
	self:InitResources();
end

function UIStorePanel.RefreshStoreItemsByTag()
	self = UIStorePanel;
	local tagType = NetCmdStoreData:GetStoreTagType(self.mCurTagIndex);
	
	if(tagType == 1) then
		setactive(self.mView.mTrans_Big.gameObject, true);
		setactive(self.mView.mTrans_GoodsList.gameObject, false);
	else
		setactive(self.mView.mTrans_Big.gameObject, false);
		setactive(self.mView.mTrans_GoodsList.gameObject, true);
	end
	
	for k,v in pairs(self.mStoreItems) do
		local item = v;
		if(item.mData.tag == self.mCurTagIndex) then
			setactive(item:GetRoot().gameObject,true);
		else
			setactive(item:GetRoot().gameObject,false);
		end
	end

end

-- function UIStorePanel.StartTagCountDown(tagData)
-- 	self = UIStorePanel;

-- 	if(tagData.IsShowTime == false) then
-- 		if(self.mCurTagIndex == tagData.tag) then		
-- 			self.mCurTagIndex = 1;
-- 			self:InitTagButtons();	
-- 			self.mTagButtons[1]:SetSelect(true);
-- 			self.RefreshStoreItemsByTag();
-- 		end		
-- 		return;
-- 	end

-- 	local countdown = NetCmdStoreData:GetStoreTagRefreshTime(tagData.close_time);
-- 	self.mTagTimer = CS.GF2.Timer.Timer(1, self.StartTagCountDown, tagData);
-- 	TimerSys:Add(self.mTagTimer);
-- 	self.mView.mText_RefreshTime.text = countdown;
-- end

function UIStorePanel.StartStoreItemCountDown()
	self = UIStorePanel;

	if(self.mItemTimer ~= nil) then
		self.mItemTimer:Stop()
		-- TimerSys:Remove(self.mItemTimer);
	end

	for k,v in pairs(self.mStoreItems) do
		local goods = v.mData;
		if(goods.can_refresh and goods.next_refresh_cd < 0) then
			gfdebug("商品刷新时间到")
			NetCmdStoreData:SendStoreTagRefresh(self.mCurTagIndex,false,self.UpdateStoreGood);
			self.mItemTimer = TimerSys:DelayCall(1, self.StartStoreItemCountDown, nil);
			return;
		end
	end

	self.mItemTimer = TimerSys:DelayCall(1, self.StartStoreItemCountDown, nil);
end


function UIStorePanel.OnTagButtonClicked(gameObj)
	self = UIStorePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		self.mCurTagIndex = eventTrigger.param
	end

	self:InitStoreItems();
	
	for i = 1, #self.mTagButtons do
		self.mTagButtons[i]:SetSelect(false);

		if(self.mTagButtons[i].mData.id == self.mCurTagIndex) then
			self.mTagButtons[i]:SetSelect(true);
		end
	end
		
	self.StartStoreItemCountDown()
	self.RefreshStoreItemsByTag();	
	self:InitResources();
end

UIStorePanel.IsConfirmPanelOpening = false;
function UIStorePanel.OnGoodsItemClicked(gameObj)
	self = UIStorePanel;

	if(UIStorePanel.IsConfirmPanelOpening == true) then
		return;
	end
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		UIStorePanel.IsConfirmPanelOpening = true;
		local item = eventTrigger.param;
		self:OpenConfirmPanel(item.mData);
	end
end

function UIStorePanel.OnSkinClicked(gameObj)
	self = UIStorePanel;
	self.mGelinaData = NetCmdNpcData:GetNpcDataById(self.mStcGelinaId);
	UIManager.OpenUIByParam(UIDef.UIStoreSkinPanel, {self.mGelinaData, 2});
end


----------------------------------好感度面板逻辑-------------------------------------------
function UIStorePanel.OnTouchGelina(gameObj)
	self = UIStorePanel;	
	
	if(self.mIsBubbling == true or self.mIsLeveling == true) then
		return;
	end

	self.SetAffectionBar();
	setactive(self.mView.mTrans_AffectionBar.gameObject,true);
	self.mIsBubbling = true;

	if(NetCmdStoreData:CanTouchGelina(self.mStcGelinaId) == false) then
		self.HideAffectionBar();
		return;
	end
	
	
	NetCmdStoreData:SendStoreTouchGelina(self.TouchGelinaCallback);		
end

function UIStorePanel.SetAffectionBar()
	self = UIStorePanel;	
	local npcData = NetCmdNpcData:GetNpcDataById(self.mStcGelinaId);	
	local lv = npcData.affection_lv;
	local affection = npcData.affection;	
	local nextExp = TableData.GetAffectionByLevel(lv+1);
	local curExp = affection;
	local next_scale = 0;
	if(nextExp > 0) then
		next_scale = curExp / nextExp;
	else
		next_scale = 1.0;
	end
	local toScale = Vector3(next_scale,1.0,1.0);
	
	self.mView.mImage_AffectionBar_AffectionFilledBar.fillAmount = next_scale;
	self.mView.mText_AffectionBar_Level.text = lv;
end

function UIStorePanel.HideAffectionBar()
	self = UIStorePanel;
	CS.UITweenManager.PlayFadeTweensWithDelay(self.mView.mTrans_AffectionBar.transform,1.0,0.0,0.3,1,false,self.TweenCallback,UIStorePanel.mTweenExpo);
end

function UIStorePanel.HideBubble()
	self = UIStorePanel;
	
	local bubble = self.mView.mTrans_AffectionBubble.gameObject;
	CS.UITweenManager.PlayFadeTweens(bubble.transform,1.0,0.0,1.0,false,nil,self.mTweenExpo);
	
	if(NetCmdStoreData:CanTouchGelina(self.mStcGelinaId)) then
		setactive(bubble,true);
		CS.UITweenManager.PlayFadeTweensWithDelay(bubble.transform,0.0,1.0,0.3,2.0,false,self.TweenCallback,self.mTweenExpo);
	else
		setactive(bubble,false);
	end	
end

function UIStorePanel.TouchGelinaCallback(ret)
	self = UIStorePanel;
	
	if ret == CS.CMDRet.eSuccess then
		local bubble = self.mView.mTrans_AffectionBubble.gameObject;		
		self.HideBubble();
	else
		gfdebug("触摸格林娜失败");
	end	
end

function UIStorePanel.TweenCallback()
	self = UIStorePanel;
	self.mIsBubbling = false;
end


function UIStorePanel.OnUpdateAffection(msg)
	self = UIStorePanel;
	local npcData = msg.Content;
	self.UpdateAffectionBar(npcData);	
end

function UIStorePanel.OnRefreshGelina(msg)
	self = UIMainStorePanel;
	local bubble = self.mView.mTrans_AffectionBubble.gameObject;
	if(NetCmdStoreData:CanTouchGelina(self.mStcGelinaId) == true) then
		setactive(bubble,true);
		CS.UITweenManager.PlayFadeTweens(bubble.transform,0.0,1.0,0.3,false,nil,self.mTweenExpo);
	end
end

function UIStorePanel.UpdateAffectionBar(npcData)
	self = UIStorePanel;

	setactive(self.mView.mTrans_AffectionBar.gameObject,true);
	CS.UITweenManager.KillTween(self.mView.mTrans_AffectionBar.transform);
	CS.UITweenManager.PlayFadeTweens(self.mView.mTrans_AffectionBar.transform,0.0,1.0,0.3,false,nil,UIStorePanel.mTweenExpo);

	local lv = npcData.affection_lv;
	local affection = npcData.affection;
	local prevExp = npcData.prev_affection;
	local prevLv = npcData.prev_affection_lv;
	
	local curLevelExp = TableData.GetAffectionByLevel(prevLv+1);
	local nextExp = TableData.GetAffectionByLevel(lv+1);
	local curExp = affection;
	
	local prev_scale = 0;	
	local next_scale = 0;

	if(curLevelExp > 0) then
		prev_scale = prevExp / curLevelExp;
	else
		prev_scale = 1.0;
	end

	if(nextExp > 0) then
		next_scale = curExp / nextExp;
	else
		next_scale = 1.0;
	end
	
	UIStorePanel.LevelDuringAnim = prevLv;
	self.mView.mText_AffectionBar_Level.text = prevLv;

	local max_level = NetCmdStoreData:GetAffectionMaxLevel();
	local start_level = prevLv + prev_scale;
	local end_level = math.min(lv + next_scale,max_level+0.9999);
	local duration = math.max(2,lv - prevLv)/2;

	if(start_level < max_level) then
		self.mIsLeveling = true;
	else
		self.mIsLeveling = false;
		self.HideAffectionBar();
	end

	if(self.mView.mImage_AffectionBar_AffectionFilledBar.gameObject.activeInHierarchy == false) then
		return;
	end

	CS.ProgressBarAnimationHelper.Play(self.mView.mImage_AffectionBar_AffectionFilledBar,start_level,end_level,duration,
    function (curLv)
        UIStorePanel.mView.mText_AffectionBar_Level.text = curLv;
    end,
    function ()
		print("over");
		UIStorePanel.mIsLeveling = false;
		UIStorePanel.HideAffectionBar();
    end);
	
end


----------------------------------购买确认面板逻辑------------------------------------------
function UIStorePanel:OpenConfirmPanel(data)
	gfdebug("OpenConfirmPanel")
	UIStoreConfirmPanelView.OpenConfirmPanel(data,self.mView.mUIRoot,data.price_type,self.OnBuySuccess,self.OnConfirmGotoBuyDiamond);
	UIStoreConfirmPanelView.mObj.transform.localPosition = Vector3(0,0,-1500);
end

function UIStorePanel.OnConfirmGotoBuyDiamond(tagId)
	self = UIStorePanel;

	gfdebug("OnConfirmGotoBuyDiamond")
	self.mCurTagIndex = tagId;
	self:InitTagButtons();
	self:RefreshStoreItemsByTag();
end

function UIStorePanel.OnBuySuccess()
	gfdebug("OnBuySuccess");
	self = UIStorePanel;
	self:InitResources();
	self.UpdateStoreGood();
end

function UIStorePanel.UpdateStoreGood()
	self = UIStorePanel;
	--NetCmdStoreData:SendReqStoreGoodsCmd(self.OnRefreshStoreGood);
	self.OnRefreshStoreGood(CS.CMDRet.eSuccess);
end

function UIStorePanel.OnRefreshStoreGood(ret)
	self = UIStorePanel;
	
	if ret == CS.CMDRet.eSuccess then
		gfdebug("刷新商品列表");
		self:ClearStoreItems();
		self:InitStoreItems();
	else
		gfdebug("刷新商品列表失败");
		MessageBox.Show("出错了", "刷新商品列表失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
	end
end


------------------------------------------------------------------------------------------------------

function UIStorePanel:ClearTable()	
	self:ClearTimer();
	self.mTagButtons:Clear();
end

function UIStorePanel:ClearStoreItems()
	
	for k,v in pairs(self.mStoreItems) do
		local item = v;
		item:ReleaseTimer();
		gfdestroy(v.mUIRoot.gameObject);
	end
	
	self.mStoreItems = {};
end

function UIStorePanel:ClearTimer()
	self.mTagTimer:Stop()
	self.mItemTimer:Stop()
	--TimerSys:Remove(self.mTagTimer);
	--TimerSys:Remove(self.mItemTimer);
end

function UIStorePanel.Hide()
	self = UIStorePanel;
	self:Show(false);
end

function UIStorePanel.OnReturnClick(gameobj)	
    self = UIStorePanel;
	local isQuickPurchase = self.mData[2];
	self.Close();
end

function UIStorePanel.OnRelease()
    self = UIStorePanel;
	MessageSys:RemoveListener(130001,self.OnUpdateAffection);
	MessageSys:RemoveListener(130002,self.OnRefreshGelina);
	
	self.mCurTagIndex = NetCmdStoreData:GetStoreStartTag();
	self.mIsBubbling = false;
	self.mIsLeveling = false;
	self:ClearTable();
	self:ClearStoreItems();
	
	UIStorePanel.mView = nil;
end