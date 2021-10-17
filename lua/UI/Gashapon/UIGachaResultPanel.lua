---
--- Created by Lile
--- DateTime: 18/11/19 15:50
---
require("UI.UIBasePanel")
require("UI.UITweenCamera")
require("UI.Gashapon.UIGachaResultPanelView")
require("UI.Gashapon.UIFrontLayerCanvasView")
require("UI.Gashapon.CardDisplayItem")

UIGachaResultPanel = class("UIGachaResultPanel", UIBasePanel);
UIGachaResultPanel.__index = UIGachaResultPanel;

--UI路径
UIGachaResultPanel.mMainNodePath = "Virtual Cameras/Position_1";
UIGachaResultPanel.mPath_GashaponItem = "Gashapon/CardDisplayItem.prefab";
UIGachaResultPanel.m3DCanvasRootPath = "3DCameraRoot/3DFormationCanvas";

--UI控件
UIGachaResultPanel.mView = nil;
UIGachaResultPanel.mFrontView = nil;
UIGachaResultPanel.mIPadCameraNode = nil;
UIGachaResultPanel.mMainCameraNode = nil;
UIGachaResultPanel.mCamera = nil;

UIGachaResultPanel.mTempItemRoot = nil;
UIGachaResultPanel.mCanvas = nil;

UIGachaResultPanel.Trans_FronLayerLayout = nil;

--卡牌参数
UIGachaResultPanel.mItemFlipSpeed = 0.5;  --翻卡时长（秒）
UIGachaResultPanel.mItemMoveInSpeed = 10; --卡牌移入速度
UIGachaResultPanel.mItemSpace = 195;      --卡牌间距

--逻辑参数
UIGachaResultPanel.mGashaItemList = nil;
UIGachaResultPanel.mGashaNetHandler = nil;
UIGachaResultPanel.mData = nil;
UIGachaResultPanel.mCurActivityId = 0;

UIGachaResultPanel.mTweenEase = CS.DG.Tweening.Ease.InOutSine;
UIGachaResultPanel.mTweenExpo = CS.DG.Tweening.Ease.InOutCirc;
UIGachaResultPanel.mActivityId = 0;
UIGachaResultPanel.mDiamond2TicketRate = 1;
UIGachaResultPanel.mSwipeBeginPosX = 0;
UIGachaResultPanel.mIsPlayingAnim = false;

UIGachaResultPanel.mEffectScale = 1;
UIGachaResultPanel.mCacheBackgoundSprite = {};
UIGachaResultPanel.mCacheBannerSprite = {};
UIGachaResultPanel.mCacheDescSprite = {};
UIGachaResultPanel.mAnimsQueue = nil;
UIGachaResultPanel.mCurAnim = nil;
UIGachaResultPanel.mCurFilpItem = nil;

UIGachaResultPanel.TempAnimObj = nil;

UIGachaResultPanel.OnAnimCompleteCallback = nil;

function UIGachaResultPanel:ctor()
    UIGachaResultPanel.super.ctor(self);
end

function UIGachaResultPanel.Open()
    UIGachaResultPanel.OpenUI(UIDef.UIGachaResultPanel);
end

function UIGachaResultPanel.Close()
    UIManager.CloseUI(UIDef.UIGachaResultPanel);
	
	UIGashaponMainPanel.ShowPanel();
end

function UIGachaResultPanel.Init(root, data)
	self = UIGachaResultPanel;
	
	UIGachaResultPanel.super.SetRoot(UIGachaResultPanel, root);

	self.mData = data;
    self:SetRoot(root);
end

function UIGachaResultPanel.OnInit()
	self = UIGachaResultPanel;
	
	self.mCurActivityId = UIGashaponMainPanel.mCurActivityId;
	
	self.mView = UIGachaResultPanelView;
    self.mView:InitCtrl(self.mUIRoot);  
		
	self.mGashaItemList = List:New(CardDisplayItem);
	self.mAnimsQueue = List:New(CS.System.Int32);
		
	UIUtils.GetListener(self.mView.mBtn_GetTen.gameObject).onClick = self.OnTenTimeClicked;
	UIUtils.GetListener(self.mView.mBtn_GetOne.gameObject).onClick = self.OnOneTimeClicked;
	UIUtils.GetListener(self.mView.mBtn_Confirm.gameObject).onClick = self.OnConfirmItem;
	self.OnGetGashapon(self.mData)

end


function UIGachaResultPanel.OnGetGashapon(msg)
	self = UIGachaResultPanel;
	local prefab = UIUtils.GetGizmosPrefab(self.mPath_GashaponItem,self);
	
	local gachainfos = msg.Content;
	local count = gachainfos.Length;
		
	local isOneTime = false;
	if(count == 1) then
		isOneTime = true;
	end
	
	for i = 0, count-1, 1 do
		local info = gachainfos[i];	

		local instObj = instantiate(prefab);
		local item = CardDisplayItem.New();
		item:InitCtrl(instObj.transform);
		if(isOneTime == false) then
			item:SetIndex(i+1);
			setactive(self.mView.mTrans_BtnGetOne.gameObject,false);
			setactive(self.mView.mTrans_BtnGetTen.gameObject,true);
		else
			item:SetIndex(0);
			setactive(self.mView.mTrans_BtnGetOne.gameObject,true);
			setactive(self.mView.mTrans_BtnGetTen.gameObject,false);
		end
		item:InitData(info);		
		UIUtils.AddListItem(instObj, self.mView.mTrans_ListLayout.transform);
		
		local itemBtn = UIUtils.GetListener(item.mUIRoot.gameObject);

		---------暂时自动翻卡不能点击---------
        itemBtn.param = item;
        itemBtn.paramData = nil;	
		
		local longPress = CS.LongPressTriggerListener.Set(item.mUIRoot.gameObject,0.5,true);
		longPress.longPressStart = self.OnItemLongPressStart;
		longPress.longPressEnd = self.OnItemLongPressEnd;
        longPress.param = item;
        longPress.paramData = nil;
		
		self.mGashaItemList:Add(item);
	end

	self.mIsPlayingAnim = true;
	GuideManager.IsPlayAnim = true;

	local t = 0;		
	if isOneTime == false then
		t = 2.5;	
	else
		t = 1.0;	 	
	end

	TimerSys:DelayCall(t+0.1, self.OnMoveInAnimEnd, nil);
end

function UIGachaResultPanel.OnMoveInAnimEnd(  )
	self = UIGachaResultPanel;
	self.mIsPlayingAnim = false;
	GuideManager.IsPlayAnim = false;
end

------------------------------抽卡动画----------------------------------------

function UIGachaResultPanel:PlayGetGunAnim(stcGunId,callback, item)
	self.OnAnimCompleteCallback = callback;
	self.mCurFilpItem = item;
	
	self.HidePanel();
	self.mAnimsQueue:Add(stcGunId);
	self.PlayAnimQueue(stcGunId);
	
	setactive(self.mView.mBtn_SkipFlipBtn.gameObject,false);
end

function UIGachaResultPanel.PlayAnimQueue(stcGunId)
	self = UIGachaResultPanel;
	
	if(self.mCurAnim == nil) then
		if(stcGunId == nil) then
			self.ShowPanel();
			self.mCurAnim = nil;
			return;
		end	
	else
		if(self.mCurAnim.isPlaying) then
			return;
		end	
	end
	
	if(#self.mAnimsQueue > 0) then
		local stcGunId = self.mAnimsQueue[1];
			
		self.mCurAnim = UIGachaResultPanel.TempAnimObj:GetComponent("Animation");
		setactive(self.mCurAnim.gameObject, true);
		self.mCurAnim:Play();
	
		local clip = self.mCurAnim:GetClip("TempGachaGetGun");
		local t = clip.length + 0.1;
	
		TimerSys:DelayCall(t, self.PlayAnimQueue, nil);
		
		self.mAnimsQueue:RemoveAt(1);
		
	else
		self.ShowPanel();
		setactive(self.mCurAnim.gameObject, false);
		self.mCurAnim = nil;
		self.OnAnimCompleteCallback(self.mCurFilpItem);
		--setactive(self.mView.mBtn_SkipFlipBtn.gameObject,true);
	end
end

------------------------------点击抽卡----------------------------------------

UIGachaResultPanel.mIsDrawClicked = false;

function UIGachaResultPanel.OnOneTimeClicked(gameobj)
	self = UIGachaResultPanel;

	if(UIGachaResultPanel.mIsDrawClicked and gameobj ~= nil) then
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
		--MessageBox.Show("注意", msg, MessageBox.ShowFlag.eNone, nil, self.DrawOneTime, self.DrawCancelled);
		MessageBoxPanel.ShowDoubleType(msg, self.DrawOneTime,self.DrawCancelled)
		UIGachaResultPanel.mIsDrawClicked = true;
	end

	--UIGachaResultPanel.mIsDrawClicked = true;
end

function UIGachaResultPanel.OnTenTimeClicked(gameobj)
	self = UIGachaResultPanel;

	if(UIGachaResultPanel.mIsDrawClicked and gameobj ~= nil) then
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
		--MessageBox.Show("注意", msg, MessageBox.ShowFlag.eNone, nil, self.DrawTenTime, self.DrawCancelled);
		MessageBoxPanel.ShowDoubleType(msg, self.DrawTenTime,self.DrawCancelled)
		UIGachaResultPanel.mIsDrawClicked = true;	
	end

	--UIGachaResultPanel.mIsDrawClicked = true;
end

function UIGachaResultPanel.OnBuyTicketCallBack_1(ret)
	self = UIGachaResultPanel;
	
	if ret == CS.CMDRet.eSuccess then
		gfdebug("购买扭蛋券成功");
		self.OnOneTimeClicked(nil);
    else
		gfdebug("购买扭蛋券失败");
		MessageBox.Show("出错了", "购买扭蛋券失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);

		UIGachaResultPanel.mIsDrawClicked = false;
	end
end

function UIGachaResultPanel.OnBuyTicketCallBack_2(ret)
	self = UIGachaResultPanel;
	
	if ret == CS.CMDRet.eSuccess then
		gfdebug("购买扭蛋券成功");
		self.OnTenTimeClicked(nil);
    else
		gfdebug("购买扭蛋券失败");
		MessageBox.Show("出错了", "购买扭蛋券失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);

		UIGachaResultPanel.mIsDrawClicked = false;
	end
end

function UIGachaResultPanel:CheckHasEnoughTicket()
	local costOneTime = GashaponNetCmdHandler:GetCachaCostOne();
	local costTenTime = GashaponNetCmdHandler:GetCachaCostTen();
	local ticket = NetCmdItemData:GetResItemCount(GashaponNetCmdHandler.GachaTicketID);
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

function UIGachaResultPanel.DrawCancelled(param)
	self = UIGachaResultPanel;
	gfdebug("DrawCancelled")
	UIGachaResultPanel.mIsDrawClicked = false;
end

function UIGachaResultPanel.DrawOneTime(param)
	self = UIGachaResultPanel;
	self:ClearGashaponItems();
	GashaponNetCmdHandler:SendReqGachaOneTime(self.mCurActivityId);
	--self.mView:ShowResultPanel();
	self.mView.HideDrawButtons();

	UIGachaResultPanel.mIsDrawClicked = false;
end

function UIGachaResultPanel.DrawTenTime(param)
	self = UIGachaResultPanel;
	self:ClearGashaponItems();
	GashaponNetCmdHandler:SendReqGachaTenTime(self.mCurActivityId);
	--self.mView:ShowResultPanel();
	self.mView.HideDrawButtons();

	UIGachaResultPanel.mIsDrawClicked = false;
end

-------------------------------翻卡逻辑---------------------------------------

function UIGachaResultPanel.OnTicketOpenSwipeBegin(swipeData)
	self = UIGachaResultPanel;
	self.mSwipeBeginPosX = swipeData.StartPosition.x;
end

function UIGachaResultPanel.OnTicketOpenSwipe(swipeData)
	self = UIGachaResultPanel;

	if(self.mIsPlayingAnim == true) then
		gfdebug("self.mIsPlayingAnim == true")
		return;
	end
	
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

function UIGachaResultPanel.OnItemClicked(gameObj)
	self = UIGachaResultPanel;

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
			
			if(item.mStcData.type == 4) then
				self:PlayGetGunAnim(item.mStcData.id,self.OnGunAnimComplete,item);
			else			
				self.FlipStart(item);
				self.FlipEnd(item);	
			end
		end
	end
end

function UIGachaResultPanel.OnGunAnimComplete(item)
	self = UIGachaResultPanel;
	self.FlipStart(item);
	self.FlipEnd(item);	
	setactive(self.mView.mBtn_SkipFlipBtn.gameObject,true);
end


function UIGachaResultPanel.OnSkipFlipClicked(gameObj)
	self = UIGachaResultPanel;
	
	setactive(gameObj,false);
	local count = self.mGashaItemList:Count();
	
	if(count == 1 and self.mGashaItemList[1].mStcData.type ~= 4) then
		self.OnAllGunAnimComplete(nil);
		return;
	end
	
	local hasAnim = false;

	if(hasAnim == false) then
		self.OnAllGunAnimComplete(nil);
	end

end

function UIGachaResultPanel.OnAllGunAnimComplete(gameObj)
	self = UIGachaResultPanel;
	
	local count = self.mGashaItemList:Count();
	for i = 1, count, 1 do
		local gashaItem = self.mGashaItemList[i];	
		if(gashaItem.mIsFlipped == false) then
			
			self.FlipStart(gashaItem);
			self.FlipEnd(gashaItem);
		end	
	end
	
	TimerSys:DelayCall(0.5, self.ShowFinallyConfirm, nil);
end

function UIGachaResultPanel.OnConfirmItem(gameObj)
	self = UIGachaResultPanel;	
	self:ClearGashaponItems();	
	self.Close();
end

function UIGachaResultPanel:ClearGashaponItems()
	for i = 1, self.mGashaItemList:Count() do
        --gfdestroy(self.mGashaItemList[i]:GetRoot());
		self.mGashaItemList[i]:DestroySelf();
    end
    self.mGashaItemList:Clear();
end

function UIGachaResultPanel.OnItemLongPressStart(gameObj,eventData)
	local btnTrigger = getcomponent(gameObj, typeof(CS.LongPressTriggerListener));
    if btnTrigger ~= nil then
        if btnTrigger.param ~= nil then
			local item = btnTrigger.param; 	
			item:ShowGlow();
			item.mIsBeingLongPressed = true;
		end
	end
end

function UIGachaResultPanel.OnItemLongPressEnd(gameObj,eventData)
	local btnTrigger = getcomponent(gameObj, typeof(CS.LongPressTriggerListener));
    if btnTrigger ~= nil then
        if btnTrigger.param ~= nil then
			local item = btnTrigger.param; 	
			item:HideGlow();
		end
	end
end

function UIGachaResultPanel.FlipStart(item) 
	self = UIGachaResultPanel;
	local trans = item.mUIRoot.transform;
	local from = trans.localEulerAngles;
	local to = CS.UnityEngine.Vector3(0,90,0);
	local duration = self.mItemFlipSpeed/2;
	
	CS.UITweenManager.PlayRotationTween(item.mUIRoot.transform,vectorzero,to,duration,0,nil,self.mTweenExpo);
	
	if(item.mStcData.type == 4 or item.mStcData.type == 6) then
		local isFirstTime = NetCmdIllustrationData:IsFirstTime(tonumber(item.mStcData.args));
		if(isFirstTime == true) then
			self.PushNewItem(item.mStcData);
		end
	end
end

function UIGachaResultPanel.FlipEnd(item)
	local trans = item.mUIRoot.transform;
	local from = CS.UnityEngine.Vector3(0,90,0);
	local to = trans.localEulerAngles;
	local start = self.mItemFlipSpeed/2;
	local duration = self.mItemFlipSpeed/2;
	CS.UITweenManager.PlayRotationTween(item.mUIRoot.transform,vectorzero,to,duration,start,nil,self.mTweenExpo);
	
	TimerSys:DelayCall(self.mItemFlipSpeed/2, self.ShowCard, item);
	TimerSys:DelayCall(self.mItemFlipSpeed, self.ShowFrontLayer, item);

	item:ConvertChipAnim();
end

function UIGachaResultPanel.ShowCard(data)
	self = UIGachaResultPanel;
	local item = data;
	item:ShowCard();
	item:HideGlow();
	
	if self:CheckAllGashaponOpened() == true then
		self.ShowFinallyConfirm();
	end
end

function UIGachaResultPanel.ShowFrontLayer(data)
	self = UIGachaResultPanel;
	local item = data;
	item:ShowFrontLayer();
end

function UIGachaResultPanel.PushNewItem(stcData)
	gfdebug("新："..stcData.id);
end

function UIGachaResultPanel:ItemMoveIn(item, index, isSingle, speed)
	local from = CS.UnityEngine.Vector3(-1500,0,0);
	local to =  vectorzero;
	local delay = 0;
	if(isSingle == false) then
		local offset = index - 5.5;
		to = to + CS.UnityEngine.Vector3(self.mItemSpace * offset ,0,0);
		delay = (10.1 - index) / speed;	
	end
	
	local data = {};
	data[1] = item.mUIRoot.transform;
	data[2] = from;
	data[3] = to;
	
	TimerSys:DelayCall(delay + 0.5, self.TweenPosition, data);
end

function UIGachaResultPanel:CheckAllGashaponOpened()
	for i = 1, self.mGashaItemList:Count() do
        if self.mGashaItemList[i].mIsFlipped == false then
			return false;
		end 
    end	
	return true;
end


function UIGachaResultPanel.TweenPosition(data)
	self = UIGachaResultPanel;
	local trans = data[1];
	local from  = data[2];
	local to    = data[3];

	CS.UITweenManager.PlayLocalPositionTween(trans,from,to,0.5,nil,self.mTweenExpo);
end

function UIGachaResultPanel.HidePanel()	
	self = UIGachaResultPanel;
	setactive(self.mUIRoot.gameObject, false);
	setactive(UIGachaResultPanel.Trans_FronLayerLayout.gameObject,false);
end

function UIGachaResultPanel.ShowPanel()	
	self = UIGachaResultPanel;
	setactive(self.mUIRoot.gameObject, true);
	setactive(UIGachaResultPanel.Trans_FronLayerLayout.gameObject,true);
end

function UIGachaResultPanel.OnReturnClick(gameobj)	
    self = UIGachaResultPanel;
	self.Close();
	SceneSys:ReturnMain();
end

function UIGachaResultPanel.OnRelease()
    self = UIGachaResultPanel;
	gfdebug("OnRelease");
	self.mView.HideDrawButtons();
	UIGachaResultPanel.mView = nil;
	UIGashaponMainPanel.mVolume.enabled = true;

end

function UIGachaResultPanel.ShowFinallyConfirm()
	if(UIGachaResultPanel.mView ~= nil) then
		UIGachaResultPanel.mView.ShowConfirm();
	end
	--抽奖最后出口，必须通知抽奖结束
	NetCmdAchieveData:GashaponEnd();
end