---
--- Created by Lile
--- DateTime: 18/11/19 15:50
---
require("UI.UIBasePanel")
require("UI.UITweenCamera")
require("UI.Gashapon.UIGachaMainPanelView")
require("UI.Gashapon.TabDisplayItem")
require("UI.Gashapon.EventDropGunItem")
require("UI.Gashapon.UIGashaponItem")

UIGashaponMainPanel = class("UIGashaponMainPanel", UIBasePanel);
UIGashaponMainPanel.__index = UIGashaponMainPanel;

--UI路径
UIGashaponMainPanel.mMainNodePath = "Virtual Cameras/Position_1";
UIGashaponMainPanel.mPath_GashaponItem = "Gashapon/UIGashaponItem.prefab";
UIGashaponMainPanel.mPath_TabDisplayItem = "Gashapon/TabDisplayItem.prefab"
UIGashaponMainPanel.mPath_EventDropGunItem = "Gashapon/EventDropGunItem.prefab"

--UI控件
UIGashaponMainPanel.mView = nil;
UIGashaponMainPanel.mIPadCameraNode = nil;
UIGashaponMainPanel.mMainCameraNode = nil;
UIGashaponMainPanel.mCamera = nil;

UIGashaponMainPanel.mTempItemRoot = nil;
UIGashaponMainPanel.mCanvas = nil;

UIGashaponMainPanel.mGashaAirportPlayable = nil;

--逻辑参数
UIGashaponMainPanel.mTabDisplayItemList = nil;
UIGashaponMainPanel.mEventDropGunItemList = nil;
UIGashaponMainPanel.mGashaItemList = nil;
UIGashaponMainPanel.mGashaNetHandler = nil;
UIGashaponMainPanel.mData = nil;
UIGashaponMainPanel.mCurActivityId = 0;
UIGashaponMainPanel.mCurGachaData = 0;
UIGashaponMainPanel.mItemFlipSpeed = 0.5;
UIGashaponMainPanel.mItemMoveInSpeed = 10;
UIGashaponMainPanel.mTweenEase = CS.DG.Tweening.Ease.InOutSine;
UIGashaponMainPanel.mTweenExpo = CS.DG.Tweening.Ease.InOutCirc;
UIGashaponMainPanel.mItemSpace = 195;
UIGashaponMainPanel.mDiamond2TicketRate = 1;
UIGashaponMainPanel.mSwipeBeginPosX = 0;

--UIGashaponMainPanel.GACHA_ONE_TICKET_ID = 3;
--UIGashaponMainPanel.GACHA_TEN_TICKET_ID = 4;

UIGashaponMainPanel.mCacheBackgoundSprite = {};
UIGashaponMainPanel.mCacheBannerSprite = {};
UIGashaponMainPanel.mCacheDescSprite = {};

UIGashaponMainPanel.mCountDownTimer = nil;

UIGashaponMainPanel.mSkipAnimItem = nil;
UIGashaponMainPanel.mAnimTimer = nil;
UIGashaponMainPanel.mVolume = nil;

function UIGashaponMainPanel:ctor()
    UIGashaponMainPanel.super.ctor(self);
end

function UIGashaponMainPanel.Open()
    UIGashaponMainPanel.OpenUI(UIDef.UIGashaponMainPanel);
end

function UIGashaponMainPanel.Close()
    UIManager.CloseUIByChangeScene(UIDef.UIGashaponMainPanel);
end

function UIGashaponMainPanel.Init(root, data)

    UIGashaponMainPanel.super.SetRoot(UIGashaponMainPanel, root);
    self = UIGashaponMainPanel;

    self.mData = data;	
	self.mCamera = UIUtils.FindTransform("Main Camera");	
    self.mView = UIGachaMainPanelView;
    self.mView:InitCtrl(root);
	self.mCanvas = UIUtils.FindTransform("Canvas");
	
	self:SetCameraRoot();
	
	self.mTabDisplayItemList = List:New(TabDisplayItem);
	self.mGashaItemList = List:New(UIGashaponItem);
	self.mEventDropGunItemList = List:New(EventDropGunItem);
	
	MessageSys:AddListener(120001,self.OnGetGashapon);
	MessageSys:AddListener(5000,self.UpdateView);
	MessageSys:AddListener(120005,self.OnSwitchByActivityID);
	
	UIUtils.GetListener(self.mView.mBtn_Close.gameObject).onClick = self.OnReturnClick;
	UIUtils.GetListener(self.mView.mBtn_GetTen.gameObject).onClick = self.OnTenTimeClicked;
	UIUtils.GetListener(self.mView.mBtn_GetOne.gameObject).onClick = self.OnOneTimeClicked;
	UIUtils.GetListener(self.mView.mBtn_Shop.gameObject).onClick = self.OnShopClicked;
	UIUtils.GetListener(self.mView.mBtn_OpenGachaList.gameObject).onClick = self.OnGachaListClicked;

	
	self.UpdateView();
	self:InitActivity();
	self:InitAnimations();
	
	UIGashaponMainPanel.mVolume = CS.UnityEngine.GameObject.Find("Global Volume"):GetComponent("Volume");

end

------------------------------抽卡前置动画----------------------------------------
function UIGashaponMainPanel:InitSkipItem(msg)
	UIGashaponMainPanel.mSkipAnimItem = instantiate(UIUtils.GetGizmosPrefab("Gashapon/UIGachaSkipItem.prefab",self));
	UIGashaponMainPanel.mSkipAnimItem.transform:SetParent(self.mCanvas,false);
	local skipBtn = UIGashaponMainPanel.mSkipAnimItem.transform:Find("Root/Btn_Skip");

	local listener = UIUtils.GetButtonListener(skipBtn.gameObject);
	listener.onClick = self.OnSkipAnimClicked;
	listener.param = msg;
end

function UIGashaponMainPanel:RemoveSkipItem()
	local skipBtn = UIGashaponMainPanel.mSkipAnimItem.transform:Find("Root/Btn_Skip");
	local listener = UIUtils.GetButtonListener(skipBtn.gameObject);
	listener.onClick = nil;

	if(UIGashaponMainPanel.mSkipAnimItem ~= nil) then
		gfdestroy(UIGashaponMainPanel.mSkipAnimItem);
	end
end

function UIGashaponMainPanel.OnSkipAnimClicked(obj)
	self = UIGashaponMainPanel;
	local eventTrigger = getcomponent(obj, typeof(CS.ButtonEventTriggerListener));
	local msg = eventTrigger.param;
	self.mAnimTimer:Stop()
	UIGashaponMainPanel.ShowResultPanel(msg);
	UIGashaponMainPanel.mSkipAnimItem = nil;
end


function UIGashaponMainPanel:InitAnimations()
	local anims = CS.UnityEngine.GameObject.FindGameObjectWithTag("Player").transform;
	self.mGashaAirportPlayable = anims:Find("GachaTimeline"):GetComponent("PlayableDirector");
	self.mGashaAirportPlayable:Stop();
	setactive(self.mGashaAirportPlayable.gameObject, false);
end

function UIGashaponMainPanel:PlayAirportAnim(msg)
	NetCmdAchieveData:GashaponStart();
	setactive(self.mGashaAirportPlayable.transform, true);
	self.mGashaAirportPlayable:Play();
	self.HidePanel();
	self:InitSkipItem(msg);
	setactive(self.mView.mVideoBgCanvas,false);
	
	if(UIGachaResultPanel ~= nil and UIGachaResultPanel.mView ~= nil) then
		setactive(UIGachaResultPanel.mView:GetRoot().gameObject,false);
	end
	self.mAnimTimer = TimerSys:DelayCall(16.1, self.ShowResultPanel, msg);
	GuideManager.IsPlayAnim = true;
end

function UIGashaponMainPanel.ShowResultPanel(msg)
	if(UIGachaResultPanel == nil or UIGachaResultPanel.mView == nil) then
		UICommonGetGunPanel.OpenGetGunPanel(msg.Content, function ()
			UIManager.OpenUIByParam(UIDef.UIGachaResultPanel, msg);
		end, nil, true)
		UIGashaponMainPanel.mVolume.enabled = false;
	else
		setactive(UIGachaResultPanel.mView:GetRoot().gameObject,true);
		UICommonGetGunPanel.OpenGetGunPanel(msg.Content, function ()
			UIGachaResultPanel.OnGetGashapon(msg);
		end, nil, true)
	end
	
	UIGashaponMainPanel.HidePanel();
	setactive(self.mView.mVideoBgCanvas,true);
	UIGashaponMainPanel:RemoveSkipItem();
	setactive(self.mGashaAirportPlayable.gameObject, false);

	GuideManager.IsPlayAnim = false;
end

function UIGashaponMainPanel.OnGachaListClicked(obj)
	self = UIGashaponMainPanel;
	local item = UIGachaDropDetailItem.New();
	local obj=item:InitCtrl(self.mView:GetRoot());
	item:InitData(UIGashaponMainPanel.mCurGachaData);
end

------------------------------商城跳转----------------------------------------
function UIGashaponMainPanel:OnBuyTicketClicked()
	self = UIGashaponMainPanel;
	local tag = NetCmdStoreData:GetStoreGoodById(3).tag;
	QuickStorePurchase.RedirectToStoreTag(tag,self);
end

function UIGashaponMainPanel:OnBuyDiamondClicked()
	self = UIGashaponMainPanel;
	local tag = 1;
	QuickStorePurchase.RedirectToStoreTag(tag,self);
end
----------------------------------------------------------------------------------

function UIGashaponMainPanel:InitActivity()
	local curActivity = GashaponNetCmdHandler:GetCurGachaActivity();
	local prefab = UIUtils.GetGizmosPrefab(self.mPath_TabDisplayItem,self);
	
	for i = 0,curActivity.Count-1 do
		local data = curActivity[i];	
		local instObj = instantiate(prefab);
		local item = TabDisplayItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(data);
		
		UIUtils.AddListItem(instObj, self.mView.mLayout_TabList.transform);
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_GachaEventBtn.gameObject);
        itemBtn.onClick = self.OnActivityTabClicked;
        itemBtn.param = item;
        itemBtn.paramData = nil;	
		
		self.mTabDisplayItemList:Add(item);
	end
	
	self.OnActivityTabClicked(self.mTabDisplayItemList[1].mBtn_GachaEventBtn.gameObject);
	
end

function UIGashaponMainPanel.OnSwitchByActivityID(msg)
	self = UIGashaponMainPanel
	local paramArray = msg.Sender
	local gachaID = tonumber(paramArray[0])
	for i=1,self.mTabDisplayItemList:Count() do
		local gachaItem = self.mTabDisplayItemList[i]
		if gachaItem.mEventData.GachaID == gachaID then
			self.OnActivityTabClicked(gachaItem.mBtn_GachaEventBtn.gameObject)
			return
		end
	end
end

function UIGashaponMainPanel.OnActivityTabClicked(gameObj)
	self = UIGashaponMainPanel;
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		self:UnAllSelectEventTab();
		local item = eventTrigger.param;
		item:SetSelect(true);
		self:SetEventData(item.mEventData);
	end
end

function UIGashaponMainPanel:SetEventData(data)
	self:ClearAllEventDropGunItem();
	
	self.mCurActivityId = data.GachaID;
	self.mCurGachaData = data;

	local backgound = self.mCacheBackgoundSprite[data.ActivityId];
	if(backgound == nil) then
		backgound = UIUtils.GetIconSprite("Gashapon/Res",data.Background);
		self.mCacheBackgoundSprite[data.ActivityId] = backgound;
	end
	self.mView.mImage_Background.sprite = backgound;
	
	local banner = self.mCacheBannerSprite[data.ActivityId];
	if(banner == nil) then
		banner = UIUtils.GetIconSprite("Gashapon/Res",data.Banner);
		self.mCacheBannerSprite[data.ActivityId] = banner;
	end	
	
	
	if(self.mCountDownTimer ~= nil) then
		self.mCountDownTimer:Stop()
	end
	self.StartEventCountDown(data);
end

function UIGashaponMainPanel.StartEventCountDown(data)
	self = UIGashaponMainPanel;
	self.mCountDownTimer = TimerSys:DelayCall(1, self.StartEventCountDown, data);
	self.mView.mText_Lefttime.text = data.Remain;
end

function UIGashaponMainPanel:UnAllSelectEventTab()
	local count = self.mTabDisplayItemList:Count();
	for i = 1, count, 1 do
		local eventItem = self.mTabDisplayItemList[i];	
		eventItem:SetSelect(false);
	end
end

function UIGashaponMainPanel:ClearAllEventDropGunItem()
	local count = self.mEventDropGunItemList:Count();
	for i = 1, count, 1 do
		local eventItem = self.mEventDropGunItemList[i];	
		gfdestroy(eventItem:GetRoot().gameObject);
	end
	
	self.mEventDropGunItemList:Clear();
end

function UIGashaponMainPanel.UpdateView()
	self = UIGashaponMainPanel;
	self:CheckHasEnoughTicket();
end


function UIGashaponMainPanel.OnShow()
	self = UIGashaponMainPanel;
	--TimerSys:Add(CS.GF2.Timer.Timer(1, self.TweenCamera, nil));
end

function UIGashaponMainPanel:SetCameraRoot()
    self.mMainCameraNode = UIUtils.FindTransform(self.mMainNodePath);
end

function UIGashaponMainPanel.TweenCamera()
	self = UIGashaponMainPanel;
	UITweenCamera.TweenCamera(self.mCamera,self.mMainCameraNode,3);
end

function UIGashaponMainPanel.OnGetGashapon(msg)
	self = UIGashaponMainPanel;

	self:PlayAirportAnim(msg);
	
	CS.UILoadingMask.Instance:SetMask(false);
end

function UIGashaponMainPanel.OnTicketOpenSwipeBegin(swipeData)
	self = UIGashaponMainPanel;
	self.mSwipeBeginPosX = swipeData.StartPosition.x;
end

function UIGashaponMainPanel.OnTicketOpenSwipe(swipeData)
	self = UIGashaponMainPanel;
	
	local x = swipeData.StartPosition.x;
	local dir = swipeData.Direction;
	local count = self.mGashaItemList:Count();
	for i = 1, count, 1 do
		local gashaItem = self.mGashaItemList[i];	
		if(gashaItem.mIsFlipping == false and gashaItem.mIsFlipped == false) then
			if(gashaItem:CheckSwipeOpen(x,self.mSwipeBeginPosX,dir)) then
				self.FlipStart(gashaItem);
				self.FlipEnd(gashaItem);	
			end
		end
	end
end

UIGashaponMainPanel.mIsDrawClicked = false;

function UIGashaponMainPanel.OnOneTimeClicked(gameobj)
	self = UIGashaponMainPanel;

	if(UIGashaponMainPanel.mIsDrawClicked and gameobj ~= nil) then
		return;
	end
	local cost = GashaponNetCmdHandler:GetCachaCostOne();
	local ticket = NetCmdItemData:GetResItemCount(GashaponNetCmdHandler.GachaTicketID);
	if(ticket < cost) then
		local diamondCost = self.mDiamond2TicketRate;
		local num = cost;
		local ticketItem = TableData.GetItemData(GashaponNetCmdHandler.GachaTicketID);
		QuickStorePurchase.QuickPurchase(ticketItem.Goodsid,1,302, self, self.OnBuyTicketCallBack_1,self.DrawCancelled);
	else
		local msg = TableData.GetHintById(301);
		msg = UIUtils.StringFormat(msg,"1","1");
		MessageBoxPanel.ShowDoubleType(msg, self.DrawOneTime,self.DrawCancelled)
		UIGashaponMainPanel.mIsDrawClicked = true;
	end
end

function UIGashaponMainPanel.OnTenTimeClicked(gameobj)
	self = UIGashaponMainPanel;

	if(UIGashaponMainPanel.mIsDrawClicked and gameobj ~= nil) then
		return;
	end
	local cost = GashaponNetCmdHandler:GetCachaCostTen();
	local ticket = NetCmdItemData:GetResItemCount(GashaponNetCmdHandler.GachaTicketID);
	if(ticket < cost) then
		local num = cost - ticket;
		local diamondCost = self.mDiamond2TicketRate * num;
		local ticketItem = TableData.GetItemData(GashaponNetCmdHandler.GachaTicketID);
		QuickStorePurchase.QuickPurchase(ticketItem.Goodsid,num,302, self, self.OnBuyTicketCallBack_2,self.DrawCancelled);
	else
		local msg = TableData.GetHintById(301);
		msg = UIUtils.StringFormat(msg,"10","10");
		MessageBoxPanel.ShowDoubleType(msg, self.DrawTenTime,self.DrawCancelled)
		UIGashaponMainPanel.mIsDrawClicked = true;		
	end
end

function UIGashaponMainPanel:CheckHasEnoughTicket()
	local costOneTime = GashaponNetCmdHandler:GetCachaCostOne();
	local costTenTime = GashaponNetCmdHandler:GetCachaCostTen();
	local ticket = NetCmdItemData:GetResItemCount(CmdConst.ItemGachaTicket);
	if(ticket < costOneTime) then
		self.mView.mBtn_GetOne.interactable = false;
	else
		self.mView.mBtn_GetOne.interactable = true;
	end
	
	if(ticket < costTenTime) then
		self.mView.mBtn_GetTen.interactable = false;
	else
		self.mView.mBtn_GetTen.interactable = true;
	end
end

function UIGashaponMainPanel.DrawOneTime(param)
	self = UIGashaponMainPanel;
	GashaponNetCmdHandler:SendReqGachaOneTime(self.mCurActivityId);
	UIGashaponMainPanel.mIsDrawClicked = false;

	CS.UILoadingMask.Instance:SetMask(true);
end

function UIGashaponMainPanel.DrawTenTime(param)
	self = UIGashaponMainPanel;
	GashaponNetCmdHandler:SendReqGachaTenTime(self.mCurActivityId);
	UIGashaponMainPanel.mIsDrawClicked = false;

	CS.UILoadingMask.Instance:SetMask(true);
end

function UIGashaponMainPanel.BuyTicket(param)
	self = UIGashaponMainPanel;
	local num = param;
	
	NetCmdItemData:SendCmdRoleDiamondToItem(111, num, self.OnBuyTicketCallBack);
end

function UIGashaponMainPanel.OnBuyTicketCallBack_1(ret)
	self = UIGashaponMainPanel;
	
	if ret == CS.CMDRet.eSuccess then
		gfdebug("购买扭蛋券成功");
		self.OnOneTimeClicked(nil);
    else
		gfdebug("购买扭蛋券失败");
		MessageBox.Show("出错了", "购买扭蛋券失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
		UIGashaponMainPanel.mIsDrawClicked = false;
	end
end

function UIGashaponMainPanel.OnBuyTicketCallBack_2(ret)
	self = UIGashaponMainPanel;
	
	if ret == CS.CMDRet.eSuccess then
		gfdebug("购买扭蛋券成功");
		self.OnTenTimeClicked(nil);
    else
		gfdebug("购买扭蛋券失败");
		MessageBox.Show("出错了", "购买扭蛋券失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
		UIGashaponMainPanel.mIsDrawClicked = false;
	end
end

function UIGashaponMainPanel.DrawCancelled(param)
	self = UIGashaponMainPanel;
	gfdebug("DrawCancelled")
	UIGashaponMainPanel.mIsDrawClicked = false;
end


function UIGashaponMainPanel.OnItemClicked(gameObj)
	self = UIGashaponMainPanel;
	local btnTrigger = getcomponent(gameObj, typeof(CS.EventTriggerListener));
    if btnTrigger ~= nil then
        if btnTrigger.param ~= nil then
            local item = btnTrigger.param; 	
			
			if(item.mIsBeingLongPressed == true) then
				item.mIsBeingLongPressed = false;
				return;
			end		
			
			if(item.mIsFlipped == true) then
				return;
			end
			
			self.FlipStart(item);
			self.FlipEnd(item);			
		end
	end
end

function UIGashaponMainPanel.OnSkipFlipClicked(gameObj)
	self = UIGashaponMainPanel;
	
	local count = self.mGashaItemList:Count();
	for i = 1, count, 1 do
		local gashaItem = self.mGashaItemList[i];	
		if(gashaItem.mIsFlipped == false) then
			self.FlipStart(gashaItem);
			self.FlipEnd(gashaItem);
		end
	end
	
	TimerSys:DelayCall(0.5, self.mView.ShowConfirm, nil);
end


function UIGashaponMainPanel.PushNewItem(stcData)
	gfdebug("新："..stcData.id);
end

function UIGashaponMainPanel.HidePanel()	
	self = UIGashaponMainPanel;
	setactive(self.mUIRoot.gameObject, false);
end

function UIGashaponMainPanel.ShowPanel()	
	self = UIGashaponMainPanel;
	setactive(self.mUIRoot.gameObject, true);
end

function UIGashaponMainPanel.OnShopClicked(gameobj)
	self = UIGashaponMainPanel; 
	SceneSwitch:SwitchByID(19, {2})
end

function UIGashaponMainPanel.OnReturnClick(gameobj)	
	self = UIGashaponMainPanel;
	
	if(CS.SceneSys.Instance.IsLoading) then
		return;
	end
	self.Close();
	SceneSys:ReturnMain();
end

function UIGashaponMainPanel.OnRelease()
    self = UIGashaponMainPanel;
	gfdebug("OnRelease");
	MessageSys:RemoveListener(120001,self.OnGetGashapon);
	MessageSys:RemoveListener(5000,self.UpdateView);
	
	if(self.mCountDownTimer ~= nil) then
		self.mCountDownTimer:Stop()
	end
	
	self.mIsDrawClicked = false;
	self.mCacheBackgoundSprite = {};
	self.mCacheBannerSprite = {};
	self.mCacheDescSprite = {};
	
	self.mTabDisplayItemList:Clear();
	self.mEventDropGunItemList:Clear();
	NetCmdAchieveData:GashaponEnd();
end