---
--- Created by Lile
--- DateTime: 18/11/19 15:50
---
require("UI.UIBasePanel")
require("UI.UITweenCamera")
require("UI.Gashapon.UIGachaResultPanelV2View")
require("UI.Gashapon.UIFrontLayerCanvasView")
require("UI.Gashapon.Item.UIGashaponCardDisplayItemV2")

UIGachaResultPanelV2 = class("UIGachaResultPanelV2", UIBasePanel);
UIGachaResultPanelV2.__index = UIGachaResultPanelV2;

--UI路径
UIGachaResultPanelV2.mMainNodePath = "Virtual Cameras/Position_1";
UIGachaResultPanelV2.mPath_GashaponItem = "Gashapon/GashaponCardDisplayItemV2.prefab";
UIGachaResultPanelV2.m3DCanvasRootPath = "3DCameraRoot/3DFormationCanvas";

--UI控件
UIGachaResultPanelV2.mView = nil;
UIGachaResultPanelV2.mFrontView = nil;
UIGachaResultPanelV2.mIPadCameraNode = nil;
UIGachaResultPanelV2.mMainCameraNode = nil;
UIGachaResultPanelV2.mCamera = nil;

UIGachaResultPanelV2.mTempItemRoot = nil;
UIGachaResultPanelV2.mCanvas = nil;

UIGachaResultPanelV2.Trans_FronLayerLayout = nil;

--卡牌参数
UIGachaResultPanelV2.mItemFlipSpeed = 0.5;  --翻卡时长（秒）
UIGachaResultPanelV2.mItemMoveInSpeed = 10; --卡牌移入速度
UIGachaResultPanelV2.mItemSpace = 195;      --卡牌间距

--逻辑参数
UIGachaResultPanelV2.mGashaItemList = nil;
UIGachaResultPanelV2.mGashaNetHandler = nil;
UIGachaResultPanelV2.mData = nil;
UIGachaResultPanelV2.mCurActivityId = 0;

UIGachaResultPanelV2.mTweenEase = CS.DG.Tweening.Ease.InOutSine;
UIGachaResultPanelV2.mTweenExpo = CS.DG.Tweening.Ease.InOutCirc;
UIGachaResultPanelV2.mActivityId = 0;
UIGachaResultPanelV2.mDiamond2TicketRate = 1;
UIGachaResultPanelV2.mSwipeBeginPosX = 0;
UIGachaResultPanelV2.mIsPlayingAnim = false;

UIGachaResultPanelV2.mEffectScale = 1;
UIGachaResultPanelV2.mCacheBackgoundSprite = {};
UIGachaResultPanelV2.mCacheBannerSprite = {};
UIGachaResultPanelV2.mCacheDescSprite = {};
UIGachaResultPanelV2.mAnimsQueue = nil;
UIGachaResultPanelV2.mCurAnim = nil;
UIGachaResultPanelV2.mCurFilpItem = nil;

UIGachaResultPanelV2.TempAnimObj = nil;

UIGachaResultPanelV2.OnAnimCompleteCallback = nil;

function UIGachaResultPanelV2:ctor()
    UIGachaResultPanelV2.super.ctor(self);
end

function UIGachaResultPanelV2.Open()
	UIManager.OpenUI(UIDef.UIGachaResultPanel);
end

function UIGachaResultPanelV2.Close()
	UIGachaMainPanelV2.Open()
    UIManager.CloseUI(UIDef.UIGachaResultPanel);
end

function UIGachaResultPanelV2.Init(root, data)
	self = UIGachaResultPanelV2;
	
	UIGachaResultPanelV2.super.SetRoot(UIGachaResultPanelV2, root);

	self.mData = data;
    self:SetRoot(root);
end

function UIGachaResultPanelV2.OnInit()
	self = UIGachaResultPanelV2;
	
	self.mCurActivityId = UIGachaMainPanelV2.mCurActivityId;
	
	self.mView = UIGachaResultPanelV2View;
    self.mView:InitCtrl(self.mUIRoot);
		
	self.mGashaItemList = List:New(UIGashaponCardDisplayItemV2);
	self.mAnimsQueue = List:New(CS.System.Int32);

	--UIUtils.GetListener(self.mView.mBtn_GetTen.gameObject).onClick = self.OnTenTimeClicked;
	--UIUtils.GetListener(self.mView.mBtn_GetOne.gameObject).onClick = self.OnOneTimeClicked;
	--UIUtils.GetListener(self.mView.mBtn_Close.gameObject).onClick = self.OnConfirmItem;
	self.OnGetGashapon(self.mData)

	local ticketItem = nil
	local itemCount = 0
	for i = 0, NetCmdItemData:GetUserDropCache().Count - 1 do
		local item = NetCmdItemData:GetUserDropCache()[i]
		ticketItem = TableData.GetItemData(item.ItemId);
		itemCount = itemCount + item.ItemNum
	end
	self.mView.mImg_Icon.sprite = IconUtils.GetItemIconSprite(ticketItem.id)
	self.mView.mText_Name.text = ticketItem.name.str
	self.mView.mText_Num.text = itemCount
end


function UIGachaResultPanelV2.OnGetGashapon(msg)
	self = UIGachaResultPanelV2;
	local prefab = UIUtils.GetGizmosPrefab(self.mPath_GashaponItem, self);

	local resultList = {}
	local gachainfos = msg.Content;
	local count = gachainfos.Length;
	for i = 0, count - 1 do
		table.insert(resultList, gachainfos[i]);
	end

	table.sort(resultList, function (a, b)
		local data1 = TableData.listItemDatas:GetDataById(a.ItemId)
		local data2 = TableData.listItemDatas:GetDataById(b.ItemId)
		if data1.type == data1.type then
			if data1.rank == data2.rank then
				return data1.id > data2.id
			end
			return data1.rank > data2.rank
		end
		return data1.type < data1.type
	end)
	local isOneTime = false;
	if(count == 1) then
		isOneTime = true;
	end
	for i = 1, count do
		local info = resultList[i];

		local instObj = instantiate(prefab);
		local item = UIGashaponCardDisplayItemV2.New();
		item:InitCtrl(instObj.transform, i);
		if(isOneTime == false) then
			item:SetIndex(i+1);
			--setactive(self.mView.mTrans_BtnGetOne.gameObject,false);
			--setactive(self.mView.mTrans_BtnGetTen.gameObject,true);
		else
			item:SetIndex(0);
			--setactive(self.mView.mTrans_BtnGetOne.gameObject,true);
			--setactive(self.mView.mTrans_BtnGetTen.gameObject,false);
		end
		item:InitData(info);		
		UIUtils.AddListItem(instObj, self.mView.mContent_Card.transform);
		
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

function UIGachaResultPanelV2.OnMoveInAnimEnd(  )
	self = UIGachaResultPanelV2;
	self.mIsPlayingAnim = false;
	GuideManager.IsPlayAnim = false;
end

------------------------------抽卡动画----------------------------------------

function UIGachaResultPanelV2:PlayGetGunAnim(stcGunId,callback, item)
	self.OnAnimCompleteCallback = callback;
	self.mCurFilpItem = item;
	
	self.HidePanel();
	self.mAnimsQueue:Add(stcGunId);
	self.PlayAnimQueue(stcGunId);
	
	setactive(self.mView.mBtn_SkipFlipBtn.gameObject,false);
end

function UIGachaResultPanelV2.PlayAnimQueue(stcGunId)
	self = UIGachaResultPanelV2;
	
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
			
		self.mCurAnim = UIGachaResultPanelV2.TempAnimObj:GetComponent("Animation");
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

UIGachaResultPanelV2.mIsDrawClicked = false;

function UIGachaResultPanelV2.OnOneTimeClicked(gameobj)
	self = UIGachaResultPanelV2;

	if(UIGachaResultPanelV2.mIsDrawClicked and gameobj ~= nil) then
		return;
	end
	local cost = GashaponNetCmdHandler:GetCachaCostOne();
	local ticket = NetCmdItemData:GetResItemCount(GashaponNetCmdHandler.GachaTicketID);
	if(ticket < cost) then
		local diamondCost = self.mDiamond2TicketRate;
		local num = cost;
		
		local ticketItem = TableData.GetItemData(GashaponNetCmdHandler.GachaTicketID);
		QuickStorePurchase.QuickPurchase(ticketItem.Goodsid,1,107012, self, self.OnBuyTicketCallBack_1,self.DrawCancelled);
	else
		local msg = TableData.GetHintById(107011);
		msg = string_format(msg,"1", TableData.GetItemData(GashaponNetCmdHandler.GachaTicketID).name.str,"1");
		--MessageBox.Show("注意", msg, MessageBox.ShowFlag.eNone, nil, self.DrawOneTime, self.DrawCancelled);
		MessageBoxPanel.ShowDoubleType(msg, self.DrawOneTime,self.DrawCancelled)
		UIGachaResultPanelV2.mIsDrawClicked = true;
	end

	--UIGachaResultPanelV2.mIsDrawClicked = true;
end

function UIGachaResultPanelV2.OnTenTimeClicked(gameobj)
	self = UIGachaResultPanelV2;

	if(UIGachaResultPanelV2.mIsDrawClicked and gameobj ~= nil) then
		return;
	end
	local cost = GashaponNetCmdHandler:GetCachaCostTen();
	local ticket = NetCmdItemData:GetResItemCount(GashaponNetCmdHandler.GachaTicketID);
	if(ticket < cost) then
		local num = cost - ticket;
		local diamondCost = self.mDiamond2TicketRate * num;
		local ticketItem = TableData.GetItemData(GashaponNetCmdHandler.GachaTicketID);
		QuickStorePurchase.QuickPurchase(ticketItem.Goodsid,num,107012, self, self.OnBuyTicketCallBack_2,self.DrawCancelled);
	else
		local msg = TableData.GetHintById(107011);
		msg = string_format(msg,"10", TableData.GetItemData(GashaponNetCmdHandler.GachaTicketID).name.str,"10");
		--MessageBox.Show("注意", msg, MessageBox.ShowFlag.eNone, nil, self.DrawTenTime, self.DrawCancelled);
		MessageBoxPanel.ShowDoubleType(msg, self.DrawTenTime,self.DrawCancelled)
		UIGachaResultPanelV2.mIsDrawClicked = true;	
	end

	--UIGachaResultPanelV2.mIsDrawClicked = true;
end

function UIGachaResultPanelV2.OnBuyTicketCallBack_1(ret)
	self = UIGachaResultPanelV2;
	
	if ret == CS.CMDRet.eSuccess then
		gfdebug("购买扭蛋券成功");
		self.OnOneTimeClicked(nil);
    else
		gfdebug("购买扭蛋券失败");
		MessageBox.Show("出错了", "购买扭蛋券失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);

		UIGachaResultPanelV2.mIsDrawClicked = false;
	end
end

function UIGachaResultPanelV2.OnBuyTicketCallBack_2(ret)
	self = UIGachaResultPanelV2;
	
	if ret == CS.CMDRet.eSuccess then
		gfdebug("购买扭蛋券成功");
		self.OnTenTimeClicked(nil);
    else
		gfdebug("购买扭蛋券失败");
		MessageBox.Show("出错了", "购买扭蛋券失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);

		UIGachaResultPanelV2.mIsDrawClicked = false;
	end
end

function UIGachaResultPanelV2:CheckHasEnoughTicket()
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

function UIGachaResultPanelV2.DrawCancelled(param)
	self = UIGachaResultPanelV2;
	gfdebug("DrawCancelled")
	UIGachaResultPanelV2.mIsDrawClicked = false;
end

function UIGachaResultPanelV2.DrawOneTime(param)
	self = UIGachaResultPanelV2;
	self:ClearGashaponItems();
	GashaponNetCmdHandler:SendReqGachaOneTime(self.mCurActivityId);
	--self.mView:ShowResultPanel();
	--self.mView.HideDrawButtons();

	UIGachaResultPanelV2.mIsDrawClicked = false;
end

function UIGachaResultPanelV2.DrawTenTime(param)
	self = UIGachaResultPanelV2;
	self:ClearGashaponItems();
	GashaponNetCmdHandler:SendReqGachaTenTime(self.mCurActivityId);
	--self.mView:ShowResultPanel();
	--self.mView.HideDrawButtons();

	UIGachaResultPanelV2.mIsDrawClicked = false;
end

-------------------------------翻卡逻辑---------------------------------------

function UIGachaResultPanelV2.OnTicketOpenSwipeBegin(swipeData)
	self = UIGachaResultPanelV2;
	self.mSwipeBeginPosX = swipeData.StartPosition.x;
end

function UIGachaResultPanelV2.OnTicketOpenSwipe(swipeData)
	self = UIGachaResultPanelV2;

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

function UIGachaResultPanelV2.OnItemClicked(gameObj)
	self = UIGachaResultPanelV2;

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

function UIGachaResultPanelV2.OnGunAnimComplete(item)
	self = UIGachaResultPanelV2;
	self.FlipStart(item);
	self.FlipEnd(item);	
	setactive(self.mView.mBtn_SkipFlipBtn.gameObject,true);
end


function UIGachaResultPanelV2.OnSkipFlipClicked(gameObj)
	self = UIGachaResultPanelV2;
	
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

function UIGachaResultPanelV2.OnAllGunAnimComplete(gameObj)
	self = UIGachaResultPanelV2;
	
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

function UIGachaResultPanelV2.OnConfirmItem(gameObj)
	self = UIGachaResultPanelV2;	
	self:ClearGashaponItems();
	self.Close();
end

function UIGachaResultPanelV2:ClearGashaponItems()
	for i = 1, self.mGashaItemList:Count() do
        --gfdestroy(self.mGashaItemList[i]:GetRoot());
		self.mGashaItemList[i]:StopTimer();
		self.mGashaItemList[i]:DestroySelf();
    end
    self.mGashaItemList:Clear();
end

function UIGachaResultPanelV2.OnItemLongPressStart(gameObj,eventData)
	local btnTrigger = getcomponent(gameObj, typeof(CS.LongPressTriggerListener));
    if btnTrigger ~= nil then
        if btnTrigger.param ~= nil then
			local item = btnTrigger.param; 	
			item:ShowGlow();
			item.mIsBeingLongPressed = true;
		end
	end
end

function UIGachaResultPanelV2.OnItemLongPressEnd(gameObj,eventData)
	local btnTrigger = getcomponent(gameObj, typeof(CS.LongPressTriggerListener));
    if btnTrigger ~= nil then
        if btnTrigger.param ~= nil then
			local item = btnTrigger.param; 	
			item:HideGlow();
		end
	end
end

function UIGachaResultPanelV2.FlipStart(item) 
	self = UIGachaResultPanelV2;
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

function UIGachaResultPanelV2.FlipEnd(item)
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

function UIGachaResultPanelV2.ShowCard(data)
	self = UIGachaResultPanelV2;
	local item = data;
	item:ShowCard();
	item:HideGlow();
	
	if self:CheckAllGashaponOpened() == true then
		self.ShowFinallyConfirm();
	end
end

function UIGachaResultPanelV2.ShowFrontLayer(data)
	self = UIGachaResultPanelV2;
	local item = data;
	item:ShowFrontLayer();
end

function UIGachaResultPanelV2.PushNewItem(stcData)
	gfdebug("新："..stcData.id);
end

function UIGachaResultPanelV2:ItemMoveIn(item, index, isSingle, speed)
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

function UIGachaResultPanelV2:CheckAllGashaponOpened()
	for i = 1, self.mGashaItemList:Count() do
        if self.mGashaItemList[i].mIsFlipped == false then
			return false;
		end 
    end	
	return true;
end


function UIGachaResultPanelV2.TweenPosition(data)
	self = UIGachaResultPanelV2;
	local trans = data[1];
	local from  = data[2];
	local to    = data[3];

	CS.UITweenManager.PlayLocalPositionTween(trans,from,to,0.5,nil,self.mTweenExpo);
end

function UIGachaResultPanelV2.HidePanel()	
	self = UIGachaResultPanelV2;
	setactive(self.mUIRoot.gameObject, false);
	setactive(UIGachaResultPanelV2.Trans_FronLayerLayout.gameObject,false);
end

function UIGachaResultPanelV2.ShowPanel()	
	self = UIGachaResultPanelV2;
	setactive(self.mUIRoot.gameObject, true);
	setactive(UIGachaResultPanelV2.Trans_FronLayerLayout.gameObject,true);
end

function UIGachaResultPanelV2.OnReturnClick(gameobj)	
    self = UIGachaResultPanelV2;
	self.Close();
	SceneSys:ReturnMain();
end

function UIGachaResultPanelV2.OnRelease()
    self = UIGachaResultPanelV2;
	gfdebug("OnRelease");
	--self.mView.HideDrawButtons();
	UIGachaResultPanelV2.mView = nil;
end

function UIGachaResultPanelV2.OnShow()
	self = UIGachaResultPanelV2;
	gfdebug("OnShow");
	--self.mView.HideDrawButtons();
	UIGachaMainPanelV2.HidePanel();
	UIUtils.GetListener(UIGachaResultPanelV2.mView.mBtn_Close.gameObject).onClick = UIGachaResultPanelV2.OnConfirmItem;
end

function UIGachaResultPanelV2.ShowFinallyConfirm()
	if(UIGachaResultPanelV2.mView ~= nil) then
		UIGachaResultPanelV2.mView.ShowConfirm();
	end
	--抽奖最后出口，必须通知抽奖结束
	NetCmdAchieveData:GashaponEnd();
end