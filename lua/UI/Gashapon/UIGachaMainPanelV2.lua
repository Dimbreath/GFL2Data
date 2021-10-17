require("UI.UIBasePanel")
require("UI.UITweenCamera")
require("UI.Gashapon.UIGachaMainPanelView")
require("UI.Gashapon.TabDisplayItem")
require("UI.Gashapon.EventDropGunItem")
require("UI.Gashapon.UIGashaponItem")
---@class UIGachaMainPanelV2
UIGachaMainPanelV2 = class("UIGachaMainPanelV2", UIBasePanel);
UIGachaMainPanelV2.__index = UIGachaMainPanelV2;

--UI路径
UIGachaMainPanelV2.mMainNodePath = "Virtual Cameras/Position_1";
UIGachaMainPanelV2.mPath_GashaponItem = "Gashapon/UIGashaponItem.prefab";
UIGachaMainPanelV2.mPath_TabDisplayItem = "Gashapon/TabDisplayItem.prefab"
UIGachaMainPanelV2.mPath_EventDropGunItem = "Gashapon/EventDropGunItem.prefab"

--UI控件
---@type UIGachaMainPanelV2View
UIGachaMainPanelV2.mView = nil;
UIGachaMainPanelV2.mIPadCameraNode = nil;
UIGachaMainPanelV2.mMainCameraNode = nil;
UIGachaMainPanelV2.mCamera = nil;

UIGachaMainPanelV2.mTempItemRoot = nil;
UIGachaMainPanelV2.mCanvas = nil;

UIGachaMainPanelV2.mGashaAirportPlayable = nil;

--逻辑参数
UIGachaMainPanelV2.mTabDisplayItemList = nil;
UIGachaMainPanelV2.mEventDropGunItemList = nil;
UIGachaMainPanelV2.mGashaItemList = nil;
UIGachaMainPanelV2.mGashaNetHandler = nil;
UIGachaMainPanelV2.mData = nil;
UIGachaMainPanelV2.mCurActivityId = 0;
UIGachaMainPanelV2.mCurGachaData = 0;
UIGachaMainPanelV2.mItemFlipSpeed = 0.5;
UIGachaMainPanelV2.mItemMoveInSpeed = 10;
UIGachaMainPanelV2.mTweenEase = CS.DG.Tweening.Ease.InOutSine;
UIGachaMainPanelV2.mTweenExpo = CS.DG.Tweening.Ease.InOutCirc;
UIGachaMainPanelV2.mItemSpace = 195;
UIGachaMainPanelV2.mDiamond2TicketRate = 1;
UIGachaMainPanelV2.mSwipeBeginPosX = 0;

--UIGachaMainPanelV2.GACHA_ONE_TICKET_ID = 3;
--UIGachaMainPanelV2.GACHA_TEN_TICKET_ID = 4;

UIGachaMainPanelV2.mCacheBackgroundSprite = {};
UIGachaMainPanelV2.mCacheBannerSprite = {};
UIGachaMainPanelV2.mCacheDescSprite = {};
UIGachaMainPanelV2.mEffectList = {};
UIGachaMainPanelV2.mShakeList = {};

UIGachaMainPanelV2.mCountDownTimer = nil;

UIGachaMainPanelV2.mSkipAnimItem = nil;
UIGachaMainPanelV2.mAnimTimer = nil;
UIGachaMainPanelV2.mVolume = nil;
UIGachaMainPanelV2.curTab = 1

function UIGachaMainPanelV2:ctor()
	UIGachaMainPanelV2.super.ctor(self);
end

function UIGachaMainPanelV2.Open()
	UIManager.OpenUI(UIDef.UIGashaponMainPanel);
end

function UIGachaMainPanelV2.Close()
	UIManager.CloseUIByChangeScene(UIDef.UIGashaponMainPanel);
end

function UIGachaMainPanelV2.Init(root, data)

	UIGachaMainPanelV2.super.SetRoot(UIGachaMainPanelV2, root);
	self = UIGachaMainPanelV2;
	if data ~= nil and data.Length ~= nil and data.Length > 0 then
		self.mData = data[0];
	else
		self.mData = data;
	end
	self.mCamera = UIUtils.FindTransform("Main Camera");
	self.mView = UIGachaMainPanelV2View;
	self.mView:InitCtrl(root);
	self.mCanvas = UIUtils.FindTransform("Canvas");
	self.mBg = self.mCanvas:Find("Image")
	self.mGacha = UIUtils.FindTransform("Gacha");
	if self.mSpecialAvatar == nil then
		self.mSpecialAvatar = self.mGacha:Find("Timeline/Mayling_dorm/c_Mayling_dorm_EX");
		self.mEffectSound = self.mGacha:Find("Audio/EffectSound"):GetComponent("AudioAutoPlayer")
	end

	self:SetCameraRoot();

	self.mTabDisplayItemList = List:New(TabDisplayItem);
	self.mGashaItemList = List:New(UIGashaponItem);
	self.mEventDropGunItemList = List:New(EventDropGunItem);

	MessageSys:AddListener(120001,self.OnGetGashapon);
	MessageSys:AddListener(5000,self.UpdateView);
	MessageSys:AddListener(2020, self.UpdateView)
	MessageSys:AddListener(120005,self.OnSwitchByActivityID);

	UIUtils.GetButtonListener(self.mView.mBtn_Back.gameObject).onClick=self.OnReturnClick
	--UIUtils.GetListener(self.mView.mBtn_Back.gameObject).onClick = self.OnReturnClick;
	UIUtils.GetListener(self.mView.mBtn_Home.gameObject).onClick = function()
		UIGachaMainPanelV2.mSpecialAvatar = nil
		UIGachaMainPanelV2.curTab = 1
		UIManager.JumpToMainPanel();
	end
	UIUtils.GetListener(self.mView.mBtn_OrderTen.gameObject).onClick = self.OnTenTimeClicked;
	UIUtils.GetListener(self.mView.mBtn_OrderOne.gameObject).onClick = self.OnOneTimeClicked;
	UIUtils.GetListener(self.mView.mBtn_Shop.gameObject).onClick = self.OnShopClicked;
	UIUtils.GetListener(self.mView.mBtn_OpenGachaList.gameObject).onClick = self.OnGachaListClicked;

	self.mView.mText_Confirm.text = TableData.GetHintById(107007)
	self.mView.mText_Id.text = TableData.GetHintById(107001)
	self.mView.mText_OrderOneName.text = TableData.GetHintById(107009)
	self.mView.mText_OrderTenName.text = TableData.GetHintById(107010)
	self.mView.mText_1.text = TableData.GetHintById(107002)
	self.mView.mText_2.text = TableData.GetHintById(107005)
	self.mView.mText_DateTitle.text = TableData.GetHintById(107006)
	self.mView.mText_Details.text = TableData.GetHintById(107004)

	self.UpdateView();
	self:InitActivity();
	self:InitAnimations();
end

function UIGachaMainPanelV2.OnInit()
	self=UIGachaMainPanelV2
	self:RegistrationKeyboard(KeyCode.Escape,self.mView.mBtn_Back)
end



------------------------------抽卡前置动画----------------------------------------
function UIGachaMainPanelV2:InitSkipItem(msg)
	UIGachaMainPanelV2.mSkipAnimItem = instantiate(UIUtils.GetGizmosPrefab("Gashapon/GashaponSkipPanelV2.prefab",self));
	UIGachaMainPanelV2.mSkipAnimItem.transform:SetParent(self.mCanvas,false);
	UIUtils.GetButtonListener(UIGachaMainPanelV2.mSkipAnimItem.transform:Find("Btn_BgSkip")).onClick = function()
		self.OnSkipAnimClicked(msg)
	end
	UIUtils.GetButtonListener(UIGachaMainPanelV2.mSkipAnimItem.transform:Find("Btn_IconSkip")).onClick = function()
		self.mAnimTimer:Stop()
		if UIGachaMainPanelV2.mEffectSound then
			UIGachaMainPanelV2.mEffectSound:StopAudio()
		end
		setactive(UIGachaMainPanelV2.mBg, true)
		UIGachaMainPanelV2:RemoveSkipItem();
		UIManager.OpenUIByParam(UIDef.UIGachaResultPanel, msg);
		GuideManager.IsPlayAnim = false;
		UIGachaMainPanelV2.Close()
	end
end

function UIGachaMainPanelV2:RemoveSkipItem()
	if(UIGachaMainPanelV2.mSkipAnimItem ~= nil) then
		gfdestroy(UIGachaMainPanelV2.mSkipAnimItem);
	end
end

function UIGachaMainPanelV2.OnSkipAnimClicked(msg)
	self = UIGachaMainPanelV2;
	self.mAnimTimer:Stop()
	UIGachaMainPanelV2.ShowResultPanel(msg);
	UIGachaMainPanelV2.mSkipAnimItem = nil;
end


function UIGachaMainPanelV2:InitAnimations()
	--local anims = CS.UnityEngine.GameObject.FindGameObjectWithTag("Player").transform;
	--self.mGashaAirportPlayable = anims:Find("GachaTimeline"):GetComponent("PlayableDirector");
	local anims = CS.UnityEngine.GameObject.Find("Gacha").transform;
	self.mGashaAirportPlayable = anims:Find("Timeline"):GetComponent("PlayableDirector");
	self.mGashaAirportPlayable:Stop();
	self.sceneTrans = CS.UnityEngine.GameObject.Find("Scene"):GetComponent("GachaTransform");
	setactive(self.mGashaAirportPlayable.gameObject, false);
end

function UIGachaMainPanelV2:PlayAirportAnim(msg)
	NetCmdAchieveData:GashaponStart();
	setactive(self.mGashaAirportPlayable.transform, true);
	self.mGashaAirportPlayable:Play();
	setactive(self.mBg, false)
	local gachainfos = msg.Content;
	local count = gachainfos.Length;
	setactive(self.sceneTrans.tenTimesContainerParent.gameObject, count > 1)
	setactive(self.sceneTrans.onceContainerParent.gameObject, count == 1)
	for i = 1, #self.mEffectList do
		ResourceManager:DestroyInstance(self.mEffectList[i])
	end
	for i = 1, #self.mShakeList do
		ResourceManager:DestroyInstance(self.mShakeList[i])
	end
	self.mEffectList = {}
	self.mShakeList = {}
	local hasRank6 = false
	for i = 0, count - 1 do
		local info = gachainfos[i];
		local mStcData = TableData.GetItemData(info.ItemId);
		local effect = nil;
		local shake = nil;
		if(mStcData.rank >= 5) then
			hasRank6 = true
			effect = ResSys:GetBattleEffect("Other/gacha_glow_golden");
			shake = ResSys:GetBattleEffect("Other/gacha_shake_02");
			shake.transform:Find("shake"):GetComponent("CameraShakeTimelineHelper").VirtualCamera = self.sceneTrans.camera
		elseif (mStcData.rank > 3) then
			effect = ResSys:GetBattleEffect("Other/gacha_glow_purple");
			shake = ResSys:GetBattleEffect("Other/gacha_shake_02");
			shake.transform:Find("shake"):GetComponent("CameraShakeTimelineHelper").VirtualCamera = self.sceneTrans.camera
		else
			effect = ResSys:GetBattleEffect("Other/gacha_glow_blue");
		end
		if count == 1 then
			CS.LuaUIUtils.SetParent(effect.gameObject, self.sceneTrans.onceEffectTrans.gameObject, false)
			effect:GetComponent("ChangeMaterialOnEnable").Rank = mStcData.rank
			if shake then
				CS.LuaUIUtils.SetParent(shake.gameObject, self.sceneTrans.onceShakeTrans.gameObject, false)
				shake.transform.localPosition = vectorzero;
				table.insert(self.mShakeList, shake)
			end
		else
			CS.LuaUIUtils.SetParent(effect.gameObject, self.sceneTrans.tenTimesEffectTrans[i].gameObject, false)
			effect:GetComponent("ChangeMaterialOnEnable").Rank = mStcData.rank
			if shake then
				CS.LuaUIUtils.SetParent(shake.gameObject, self.sceneTrans.tenTimesShakeTrans[i].gameObject, false)
				shake.transform.localPosition = vectorzero;
				table.insert(self.mShakeList, shake)
			end
		end
		effect:GetComponent("UIAudioComponent").IsPreload = false
		table.insert(self.mEffectList, effect)
		effect.transform.localPosition = vectorzero;
	end
	setactive(self.mSpecialAvatar, hasRank6)
	if hasRank6 then
		self.mEffectSound:InitAudio(10001)
	else
		self.mEffectSound:InitAudio(10002)
	end
	self.HidePanel();
	self:InitSkipItem(msg);

	if(UIGachaResultPanel ~= nil and UIGachaResultPanel.mView ~= nil) then
		setactive(UIGachaResultPanel.mView:GetRoot().gameObject,false);
	end
	self.mAnimTimer = TimerSys:DelayCall(14, self.ShowResultPanel, msg);
	GuideManager.IsPlayAnim = true;
end

function UIGachaMainPanelV2.ShowResultPanel(msg)
	if UIGachaMainPanelV2.mEffectSound then
		UIGachaMainPanelV2.mEffectSound:StopAudio()
	end
	setactive(UIGachaMainPanelV2.mBg, true)
	if(UIGachaResultPanel == nil or UIGachaResultPanel.mView == nil) then
		UICommonGetGunPanel.OpenGetGunPanel(msg.Content, function ()
			UIManager.OpenUIByParam(UIDef.UIGachaResultPanel, msg);
			UIGachaMainPanelV2.Close()
		end, nil, true)
		--UIGachaMainPanelV2.mVolume.enabled = false;
	else
		setactive(UIGachaResultPanel.mView:GetRoot().gameObject,true);
		UICommonGetGunPanel.OpenGetGunPanel(msg.Content, function ()
			UIGachaResultPanel.OnGetGashapon(msg);
		end, nil, true)
	end

	UIGachaMainPanelV2.HidePanel();
	--setactive(self.mView.mVideoBgCanvas,true);
	UIGachaMainPanelV2:RemoveSkipItem();
	setactive(self.mGashaAirportPlayable.gameObject, false);

	GuideManager.IsPlayAnim = false;
end

function UIGachaMainPanelV2.OnShopClicked(obj)
	UIManager.OpenUI(UIDef.UIGachaShoppingDetailPanel)
	--[[self = UIGachaMainPanelV2;
	local item = UIGachaDropDetailItem.New();
	local obj=item:InitCtrl(self.mView:GetRoot());
	item:InitData(UIGachaMainPanelV2.mCurGachaData);
	]]
end

------------------------------商城跳转----------------------------------------
function UIGachaMainPanelV2:OnBuyTicketClicked()
	self = UIGachaMainPanelV2;
	local tag = NetCmdStoreData:GetStoreGoodById(3).tag;
	QuickStorePurchase.RedirectToStoreTag(tag,self);
end

function UIGachaMainPanelV2:OnBuyDiamondClicked()
	self = UIGachaMainPanelV2;
	local tag = 1;
	QuickStorePurchase.RedirectToStoreTag(tag,self);
end
----------------------------------------------------------------------------------

function UIGachaMainPanelV2:InitActivity()
	local curActivity = GashaponNetCmdHandler:GetCurGachaActivity();

	for i = 0,curActivity.Count-1 do
		local data = curActivity[i];
		local leftTab
		if (data.Type == 1 or data.Type == 2) then
			---@type UIGachaLeftTabItemV2
			leftTab = UIGachaLeftTabItemV2.New()
		else
			---@type UIGachaLeftTabItemV2
			leftTab = UILimitGachaLeftTabItemV2.New()
		end
		leftTab:InitCtrl(self.mView.mContent_LeftTab)
		leftTab:SetData(data)

		UIUtils.GetButtonListener(leftTab.mBtn_GachaEventBtn.gameObject).onClick = function()
			UIGachaMainPanelV2.OnActivityTabClicked(i + 1);
		end
		if data.GachaID == self.mData then
			self.curTab = i + 1
		end
		self.mTabDisplayItemList:Add(leftTab);
	end

	self.OnActivityTabClicked(self.curTab);
end

function UIGachaMainPanelV2.OnSwitchByActivityID(msg)
	self = UIGachaMainPanelV2
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

function UIGachaMainPanelV2.OnActivityTabClicked(index)
	self = UIGachaMainPanelV2;
	local item = self.mTabDisplayItemList[index]
	self.curTab = index
	self:UnAllSelectEventTab();
	item:SetSelect(true);
	self:SetEventData(item.mEventData);
	self.mView.mAnimator:Play("GrpAvatar_FadeIn", 2, 0)
	self:RefreshText()
end

function UIGachaMainPanelV2:SetEventData(data)
	self:ClearAllEventDropGunItem();

	self.mCurActivityId = data.GachaID;
	self.mCurGachaData = data;

	local banner = self.mCacheBannerSprite[data.ActivityId];
	if(banner == nil) then
		banner = IconUtils.GetAtlasV2("GashaponPic",data.Banner);
		self.mCacheBannerSprite[data.ActivityId] = banner;
	end
	self.mView.mImage_Banner.sprite = banner;

	self.mView.mText_Title.text = data.Name;
	local pickUp = ""
	setactive(self.mView.mTrans_ChrAttribute1, false)
	setactive(self.mView.mTrans_ChrAttribute2, false)
	setactive(self.mView.mTrans_WeaponAttribute1, false)
	setactive(self.mView.mTrans_WeaponAttribute2, false)
	for i = 0, data.SSRPickUpList.Count - 1 do
		if data.SSRPickUpList[i].Type == 4 then
			local gunData = TableData.GetGunData(tonumber(data.SSRPickUpList[i].args[0]))
			local dutyData = TableData.listGunDutyDatas:GetDataById(gunData.duty)
			if i == 0 then
				setactive(self.mView.mTrans_ChrAttribute1, true)
				self.mView.mText_PickUpChr1Name.text = gunData.name.str
				pickUp = pickUp .. gunData.name.str
				self.mView.mImg_DutyIcon1.sprite = IconUtils.GetGunTypeSprite(dutyData.icon)
				local rank = TableData.GlobalSystemData.QualityStar[gunData.rank - 1];
				for i = 1, #self.mView.mChrStarList1 do
					setactive(self.mView.mChrStarList1[i], false);
				end

				for i = 1, rank do
					setactive(self.mView.mChrStarList1[i], true);
				end
			else
				setactive(self.mView.mTrans_ChrAttribute2, true)
				self.mView.mText_PickUpChr2Name.text = gunData.name.str
				pickUp = "," .. pickUp .. gunData.name.str
				self.mView.mImg_DutyIcon2.sprite = IconUtils.GetGunTypeSprite(dutyData.icon)
				local rank = TableData.GlobalSystemData.QualityStar[gunData.rank - 1];
				for i = 1, #self.mView.mChrStarList2 do
					setactive(self.mView.mChrStarList2[i], false);
				end

				for i = 1, rank do
					setactive(self.mView.mChrStarList2[i], true);
				end
			end
		elseif data.SSRPickUpList[i].type == 8 then
			local weaponData = TableData.listGunWeaponDatas:GetDataById(tonumber(data.SSRPickUpList[i].args[0]))
			local elementData = TableData.listLanguageElementDatas:GetDataById(weaponData.element)
			if i == 0 then
				setactive(self.mView.mTrans_WeaponAttribute1, true)
				self.mView.mText_PickUpWeapon1Name.text = weaponData.name.str
				pickUp = pickUp .. weaponData.name.str
				self.mView.mImg_ElementIcon1.sprite = IconUtils.GetElementIcon(elementData.icon)
				local rank = TableData.GlobalSystemData.QualityStar[weaponData.rank];
				for i = 1, #self.mView.mWeaponStarList1 do
					setactive(self.mView.mWeaponStarList1[i], false);
				end

				for i = 1, rank do
					setactive(self.mView.mWeaponStarList1[i], true);
				end
			else
				setactive(self.mView.mTrans_WeaponAttribute2, true)
				self.mView.mText_PickUpWeapon2Name.text = weaponData.name.str
				pickUp = "," .. pickUp .. weaponData.name.str
				self.mView.mImg_ElementIcon2.sprite = IconUtils.GetElementIcon(elementData.icon)
				local rank = TableData.GlobalSystemData.QualityStar[weaponData.rank];
				for i = 1, #self.mView.mWeaponStarList2 do
					setactive(self.mView.mWeaponStarList2[i], false);
				end

				for i = 1, rank do
					setactive(self.mView.mWeaponStarList2[i], true);
				end
			end
		end
	end
	setactive(self.mView.mTrans_Date, data.StartTimeStamp ~= 0 or data.EndTimeStamp ~= 0)
	setactive(self.mView.mTrans_Chr, data.Type == 1 or data.Type == 3)
	setactive(self.mView.mTrans_Weapon, data.Type == 2 or data.Type == 4)
	self.mView.mText_Time.text = data.Start .. "-" .. data.End
	self.mView.mText_LeftTime.text = TableData.GetHintReplaceById(107008, data.RemainGachaTimes)
	--self.mView.mText_Title.text = pickUp .. TableData.GetHintById(107003);

	local ticketItem = TableData.GetItemData(GashaponNetCmdHandler.GachaTicketID)
	self.mView.mImg_TenIcon.sprite = IconUtils.GetItemIconSprite(ticketItem.id)
	self.mView.mText_TenNum.text = "x10"
	self.mView.mImg_OneIcon.sprite = IconUtils.GetItemIconSprite(ticketItem.id)
	self.mView.mText_OneNum.text = "x1"
	self:RefreshText()

	--if(self.mCountDownTimer ~= nil) then
	--	self.mCountDownTimer:Stop()
	--end
	--self.StartEventCountDown(data);
end

function UIGachaMainPanelV2:RefreshText()
	local count = NetCmdItemData:GetItemCountById(GashaponNetCmdHandler.GachaTicketID)
	if(count < 1) then
		self.mView.mText_OneNum.color = ColorUtils.RedColor
	else
		self.mView.mText_OneNum.color = ColorUtils.BlackColor
	end
	if(count < 10) then
		self.mView.mText_TenNum.color = ColorUtils.RedColor
	else
		self.mView.mText_TenNum.color = ColorUtils.BlackColor
	end
end

function UIGachaMainPanelV2.StartEventCountDown(data)
	self = UIGachaMainPanelV2;
	self.mCountDownTimer = TimerSys:DelayCall(1, self.StartEventCountDown, data);
	self.mView.mText_LeftTime.text = data.Remain;
end

function UIGachaMainPanelV2:UnAllSelectEventTab()
	local count = self.mTabDisplayItemList:Count();
	for i = 1, count, 1 do
		local eventItem = self.mTabDisplayItemList[i];
		eventItem:SetSelect(false);
	end
end

function UIGachaMainPanelV2:ClearAllEventDropGunItem()
	local count = self.mEventDropGunItemList:Count();
	for i = 1, count, 1 do
		local eventItem = self.mEventDropGunItemList[i];
		gfdestroy(eventItem:GetRoot().gameObject);
	end

	self.mEventDropGunItemList:Clear();
end

function UIGachaMainPanelV2.UpdateView()
	self = UIGachaMainPanelV2;
	--self:CheckHasEnoughTicket();
	self:RefreshText()
end


function UIGachaMainPanelV2.OnShow()
	self = UIGachaMainPanelV2;
	--TimerSys:Add(CS.GF2.Timer.Timer(1, self.TweenCamera, nil));
end

function UIGachaMainPanelV2:SetCameraRoot()
	self.mMainCameraNode = UIUtils.FindTransform(self.mMainNodePath);
end

function UIGachaMainPanelV2.TweenCamera()
	self = UIGachaMainPanelV2;
	UITweenCamera.TweenCamera(self.mCamera,self.mMainCameraNode,3);
end

function UIGachaMainPanelV2.OnGetGashapon(msg)
	self = UIGachaMainPanelV2;

	self:PlayAirportAnim(msg);

	--CS.UILoadingMask.Instance:SetMask(false);
end

function UIGachaMainPanelV2.OnTicketOpenSwipeBegin(swipeData)
	self = UIGachaMainPanelV2;
	self.mSwipeBeginPosX = swipeData.StartPosition.x;
end

function UIGachaMainPanelV2.OnTicketOpenSwipe(swipeData)
	self = UIGachaMainPanelV2;

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

UIGachaMainPanelV2.mIsDrawClicked = false;

function UIGachaMainPanelV2.OnOneTimeClicked(gameobj)
	self = UIGachaMainPanelV2;

	if(UIGachaMainPanelV2.mIsDrawClicked and gameobj ~= nil) then
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
		MessageBox.Show(TableData.GetHintById(64), msg, nil, self.DrawOneTime,self.DrawCancelled)
		UIGachaMainPanelV2.mIsDrawClicked = true;
	end
end

function UIGachaMainPanelV2.OnTenTimeClicked(gameobj)
	self = UIGachaMainPanelV2;

	if(UIGachaMainPanelV2.mIsDrawClicked and gameobj ~= nil) then
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
		MessageBox.Show(TableData.GetHintById(64), msg, nil, self.DrawTenTime,self.DrawCancelled)
		UIGachaMainPanelV2.mIsDrawClicked = true;
	end
end

function UIGachaMainPanelV2:CheckHasEnoughTicket()
	local costOneTime = GashaponNetCmdHandler:GetCachaCostOne();
	local costTenTime = GashaponNetCmdHandler:GetCachaCostTen();
	local ticket = NetCmdItemData:GetResItemCount(CmdConst.ItemGachaTicket);
	if(ticket < costOneTime) then
		self.mView.mBtn_OrderOne.interactable = false;
	else
		self.mView.mBtn_OrderOne.interactable = true;
	end

	if(ticket < costTenTime) then
		self.mView.mBtn_OrderTen.interactable = false;
	else
		self.mView.mBtn_OrderTen.interactable = true;
	end
end

function UIGachaMainPanelV2.DrawOneTime(param)
	self = UIGachaMainPanelV2;
	UIGachaMainPanelV2.mView.mBtn_OrderOne.interactable = false
	UIGachaMainPanelV2.mView.mBtn_OrderTen.interactable = false
	GashaponNetCmdHandler:SendReqGachaOneTime(self.mCurActivityId, function(ret)
		UIGachaMainPanelV2.mIsDrawClicked = false;
	end);

	--CS.UILoadingMask.Instance:SetMask(true);
end

function UIGachaMainPanelV2.DrawTenTime(param)
	self = UIGachaMainPanelV2;
	UIGachaMainPanelV2.mView.mBtn_OrderOne.interactable = false
	UIGachaMainPanelV2.mView.mBtn_OrderTen.interactable = false
	GashaponNetCmdHandler:SendReqGachaTenTime(self.mCurActivityId, function(ret)
		UIGachaMainPanelV2.mIsDrawClicked = false;
	end);
	--CS.UILoadingMask.Instance:SetMask(true);
end

function UIGachaMainPanelV2.BuyTicket(param)
	self = UIGachaMainPanelV2;
	local num = param;

	NetCmdItemData:SendCmdRoleDiamondToItem(111, num, self.OnBuyTicketCallBack);
end

function UIGachaMainPanelV2.OnBuyTicketCallBack_1(ret)
	self = UIGachaMainPanelV2;

	if ret == CS.CMDRet.eSuccess then
		gfdebug("购买扭蛋券成功");
		self.OnOneTimeClicked(nil);
		self:RefreshText()
	else
		gfdebug("购买扭蛋券失败");
		MessageBox.Show("出错了", "购买扭蛋券失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
		UIGachaMainPanelV2.mIsDrawClicked = false;
	end
end

function UIGachaMainPanelV2.OnBuyTicketCallBack_2(ret)
	self = UIGachaMainPanelV2;

	if ret == CS.CMDRet.eSuccess then
		gfdebug("购买扭蛋券成功");
		self.OnTenTimeClicked(nil);
		self:RefreshText()
	else
		gfdebug("购买扭蛋券失败");
		MessageBox.Show("出错了", "购买扭蛋券失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
		UIGachaMainPanelV2.mIsDrawClicked = false;
	end
end

function UIGachaMainPanelV2.DrawCancelled(param)
	self = UIGachaMainPanelV2;
	gfdebug("DrawCancelled")
	UIGachaMainPanelV2.mIsDrawClicked = false;
end


function UIGachaMainPanelV2.OnItemClicked(gameObj)
	self = UIGachaMainPanelV2;
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

function UIGachaMainPanelV2.OnSkipFlipClicked(gameObj)
	self = UIGachaMainPanelV2;

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


function UIGachaMainPanelV2.PushNewItem(stcData)
	gfdebug("新："..stcData.id);
end

function UIGachaMainPanelV2.HidePanel()
	self = UIGachaMainPanelV2;
	setactive(self.mUIRoot.gameObject, false);
end

function UIGachaMainPanelV2.ShowPanel()
	self = UIGachaMainPanelV2;
	setactive(self.mUIRoot.gameObject, true);
end

function UIGachaMainPanelV2.OnGachaListClicked(gameobj)
	self = UIGachaMainPanelV2;
	SceneSwitch:SwitchByID(19, {3})
end

function UIGachaMainPanelV2.OnReturnClick()
	self = UIGachaMainPanelV2;

	if(CS.SceneSys.Instance.IsLoading or GuideManager.IsPlayAnim) then
		return;
	end
	UIGachaMainPanelV2.Close();
	UISystem:ClearUIStacks();
	self.mSpecialAvatar = nil
	UIGachaMainPanelV2.curTab = 1
	SceneSys:ReturnMain();
end

function UIGachaMainPanelV2.OnUpdateTop()
	self = UIGachaMainPanelV2;
	self:RefreshText()
end

function UIGachaMainPanelV2.OnRelease()
	self = UIGachaMainPanelV2;
	gfdebug("OnRelease");
	MessageSys:RemoveListener(120001,self.OnGetGashapon);
	MessageSys:RemoveListener(5000,self.UpdateView);
	MessageSys:RemoveListener(2020, self.UpdateView)
	if(self.mCountDownTimer ~= nil) then
		self.mCountDownTimer:Stop()
	end

	for i = 1, #self.mEffectList do
		ResourceManager:DestroyInstance(self.mEffectList[i])
	end
	for i = 1, #self.mShakeList do
		ResourceManager:DestroyInstance(self.mShakeList[i])
	end

	self.mIsDrawClicked = false;
	self.mCacheBackgroundSprite = {};
	self.mCacheBannerSprite = {};
	self.mCacheDescSprite = {};
	self.mEffectList = {}
	self.mShakeList = {}
	self.mSpecialAvatar = nil
	self.mBg = nil

	self.mTabDisplayItemList:Clear();
	self.mEventDropGunItemList:Clear();
	NetCmdAchieveData:GashaponEnd();
	self:UnRegistrationKeyboard(nil)
end