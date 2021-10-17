---
--- Created by Lile
--- DateTime: 26/12/19 16:21

require("UI.UIBasePanel")
require("UI.UITweenCamera")
require("UI.StorePanel.UIStorePanelView")
require("UI.StorePanel.Item.UIGoodsItem")
require("UI.StorePanel.UIStoreConfirmPanelView")
require("UI.StorePanel.UIStoreSkinPanel");
require("UI.StorePanel.Item.UIStoreTagItem");
require("UI.StorePanel.Item.UIStoreAdvertisementItem")
require("UI.StorePanel.Item.Trans_AdvertisementPageItem")

UIMainStorePanel = class("UIMainStorePanel", UIBasePanel);
UIMainStorePanel.__index = UIMainStorePanel;

--UI路径
UIMainStorePanel.m3DCanvasRootPath = "FormationCameraRoot/3DFormationCanvas";
UIMainStorePanel.mPath_StoreAdvItem = "Store/UIStoreAdvertisementItem.prefab";
UIMainStorePanel.mPath_StoreTagItem = "Store/UIStoreTagItem.prefab";
UIMainStorePanel.mPath_ConfirmPanel = "Store/UIStoreConfirmPanel.prefab"
UIMainStorePanel.mModelRootPath = "ModelRoot";

--UI控件
UIMainStorePanel.mView = nil;
UIMainStorePanel.mConfirmView = nil;
UIMainStorePanel.mPageView = nil;

--逻辑参数
UIMainStorePanel.mMaxNumPerPurchase = 999;
UIMainStorePanel.E3DModelType = gfenum({"eUnkown", "eGun", "eWeapon", "eEffect", "eVechicle"},-1)
UIMainStorePanel.mData = nil;
UIMainStorePanel.mTagButtons = {};
UIMainStorePanel.mCurTagIndex = 1;
UIMainStorePanel.mStoreItems = {};
UIMainStorePanel.mGelinaData = nil;
UIMainStorePanel.mGelinaObj = nil;
UIMainStorePanel.mModelRoot = nil;
UIMainStorePanel.mIsBubbling = false;

UIMainStorePanel.mTweenEase = CS.DG.Tweening.Ease.InOutSine;
UIMainStorePanel.mTweenExpo = CS.DG.Tweening.Ease.InOutCirc;
UIMainStorePanel.mTweenCirc = CS.DG.Tweening.Ease.OutCirc;

UIMainStorePanel.mLevelDuringAnim = 0;
UIMainStorePanel.mPageItems = {};

--UIMainStorePanel.mGoodDatas = nil;

--已经生成的模型
UIMainStorePanel.mModelObjects = nil;
--已经生成的模型ID
UIMainStorePanel.mSelectedGunId = nil;
UIMainStorePanel.mSelectedGunList = nil;
UIMainStorePanel.mStcGelinaId = 1001;
--UIMainStorePanel.mRTCamera = nil;

UIMainStorePanel.mTagTimers = {};

UIMainStorePanel.mCharacterSelfShadowSettings = nil;

function UIMainStorePanel:ctor()
    UIMainStorePanel.super.ctor(self);
end

function UIMainStorePanel.Open()
    UIMainStorePanel.OpenUI(UIDef.UIMainStorePanel);
end

function UIMainStorePanel.Close()
    UIManager.CloseUI(UIDef.UIMainStorePanel);
end

function UIMainStorePanel.Init(root, data)
	self = UIMainStorePanel;
	self.mData = data;
	
	self.mView = UIMainStorePanelView;
    self.mView:InitCtrl(root);
end

function UIMainStorePanel.OnInit()	
    self = UIMainStorePanel;
	
	self.mGelinaData = NetCmdNpcData:GetNpcDataById(self.mStcGelinaId);
		
	self:InitTagButtons();
	self:InitAdvertisement();
	self:InitResources();
	self:InitGelina();
	self:InitBubble();
	
	UIUtils.GetButtonListener(self.mView.mBtn_Return.gameObject).onClick = self.OnReturnClick;
	UIUtils.GetButtonListener(self.mView.mBtn_SwitchToSkin.gameObject).onClick = self.OnSkinClicked;
	UIUtils.GetButtonListener(self.mView.mBtn_TouchArea.gameObject).onClick = self.OnTouchGelina;
	
	MessageSys:AddListener(130001,self.OnUpdateAffection);
	MessageSys:AddListener(130002,self.OnRefreshGelina);
	MessageSys:AddListener(1025,self.OnSwitchHandler)
	
	-- self.mRTCamera = UIUtils.FindTransform("Canvas/UIMainStorePanel(Clone)/RTCamera");
	-- self.mRTCamera.parent = nil;
	-- self.mRTCamera.position = Vector3(15.02,1.1,-10.21);

	if(QuickStorePurchase.mCurRedirectTag ~= 0) then
		self.mCurTagIndex = QuickStorePurchase.mCurRedirectTag;
		QuickStorePurchase.mCurRedirectTag = 0;

		TimerSys:DelayCall(0.01,function(idx) 
			UIMainStorePanel.ShowStorePanel(UIMainStorePanel.mCurTagIndex,true);
		end,0);
		
	else
		self.mCurTagIndex = NetCmdStoreData:GetStoreStartTag();
	end
end

UIMainStorePanel.mIsOpeningStorePanel = false;

function UIMainStorePanel.OnHide()
	if(UIMainStorePanel.mIsOpeningStorePanel == true) then
		return;
	end
	if(UIMainStorePanel.mGunModel ~= nil) then
		setactive(UIMainStorePanel.mGunModel.transform,false);
	end
end

function UIMainStorePanel.OnShow()
	if(UIMainStorePanel.mGunModel ~= nil) then
		setactive(UIMainStorePanel.mGunModel.transform,true);
	end
end

function UIMainStorePanel:InitAdvertisement()
	local prefab = UIUtils.GetGizmosPrefab(self.mPath_StoreAdvItem,self);
	
	for i = 1, 5, 1 do
		local instObj = instantiate(prefab);
		local item = UIStoreAdvertisementItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(nil);		
		UIUtils.AddListItem(instObj, self.mView.mTrans_AdvertisementList.transform);

		local pageItem = Trans_AdvertisementPageItem.New();
		pageItem:InitCtrl(self.mView.mTrans_AdvertisementPageList);
		pageItem:InitData(i);
		self.mPageItems[i] = pageItem;
	end
	self.mPageItems[1]:SetSelect(true);
	self.mPageView = self.mView.mTrans_AdvertisementList.transform.parent:GetComponent("PageView")
	self.mPageView:Init(5,self.OnPageChhanged);
end

function UIMainStorePanel.OnPageChhanged(page)
	self = UIMainStorePanel;
	for i = 1, #self.mPageItems do
		self.mPageItems[i]:SetSelect(false);
	end

	local index = #self.mPageItems - page;
	self.mPageItems[index]:SetSelect(true);
end


function UIMainStorePanel:InitTagButtons()
	
	local prefab = UIUtils.GetGizmosPrefab(self.mPath_StoreTagItem,self);
	local storeTagList = TableData.listStoreTagDatas:GetList();
	local index = 1;

	self.mTagButtons = {};
	for i = 0, self.mView.mTrans_TagList.transform.childCount-1 do
		local obj = self.mView.mTrans_TagList.transform:GetChild(i);
		gfdestroy(obj);
	end

	for i = 0, storeTagList.Count - 1, 1 do
		local hide = (storeTagList[i].Type ~= CS.GF2.Data.StoreTagType.Shop);
		
		if(hide == false) then
			local instObj = instantiate(prefab);
			local item = UIStoreTagItem.New();
			item:InitCtrl(instObj.transform);
			item:InitData(storeTagList[i]);
		
			local itemBtn = UIUtils.GetButtonListener(item.mUIRoot.gameObject);
			itemBtn.onClick = self.OnTagButtonClicked;
			itemBtn.param = item;
			itemBtn.paramData = nil;
		
			UIUtils.AddListItem(instObj, self.mView.mTrans_TagList.transform);
			
			self.mTagButtons[index] = {item.mBtn_TagButton};
		
			index = index + 1;
		end
	end
	
end


function UIMainStorePanel.StartTagCountDown(tagData)
	self = UIMainStorePanel;

	if(tagData.IsShowTime == false) then	
		UIMainStorePanel.RefreshTagButtons();
		return;
	end
	self.mTagTimers[tagData.tag] = TimerSys:DelayCall(1, self.StartTagCountDown, tagData);
end

function UIMainStorePanel.RefreshTagButtons( )
	self = UIMainStorePanel;
	self:InitTagButtons();
end


function UIMainStorePanel:InitResources()
	setactive(self.mView.mTrans_StoreCoinList,false);
end

function UIMainStorePanel.BeginTagEffect()
	self = UIMainStorePanel;
	for i = 1, #self.mTagButtons do
		local t = 0.075 * i;
		local timer = TimerSys:DelayCall(t, self.FadeInEffect, self.mTagButtons[i][1].transform);	
	end
end

function UIMainStorePanel.FadeInEffect(t)
	self = UIMainStorePanel;
	CS.UITweenManager.PlayFadeTweens(t,0.0,1.0,0.5,false,nil,self.mTweenExpo);
end

function UIMainStorePanel.FadeOutEffect(t,callback)
	self = UIMainStorePanel;
	CS.UITweenManager.PlayFadeTweens(t,1.0,0.0,0.35,false,callback,self.mTweenExpo);
end

function UIMainStorePanel.OnUpdateResource(msg)
	self = UISkillCoreDetailPanel;	
	self:InitResources();
end

function UIMainStorePanel:InitGelina()
	self.mModelRoot = UIUtils.FindTransform(self.mModelRootPath);
	local modelId = TableData.GetGunCostumesData(self.mGelinaData.costume_id).model_config_id
	self:CreateModel(modelId);
end

function UIMainStorePanel:InitBubble()
	local bubble = self.mView.mTrans_AffectionBubble.gameObject;
	if(NetCmdStoreData:CanTouchGelina(self.mStcGelinaId) == true) then
		setactive(bubble,true);
		CS.UITweenManager.PlayFadeTweens(bubble.transform,0.0,1.0,0.3,false,nil,self.mTweenExpo);
	else
		setactive(bubble,false);
	end

	self.SetAffectionBar();
end


function UIMainStorePanel.OnTagButtonClicked(gameObj)
	self = UIMainStorePanel;

	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local item = eventTrigger.param;
		self.ShowStorePanel(item.mData.id,false);
	end
end

function UIMainStorePanel.ShowStorePanel(tag,isQuickPurchase)
	self = UIMainStorePanel;

	UIMainStorePanel.mIsOpeningStorePanel = true;
	local params = {tag,isQuickPurchase};
	UIManager.JumpUIByParam(UIDef.UIStorePanel, params);
end


function UIMainStorePanel.OnSkinClicked(gameObj)
	self = UIMainStorePanel;
	self.mGelinaData = NetCmdNpcData:GetNpcDataById(self.mStcGelinaId);
	UIManager.OpenUIByParam(UIDef.UIStoreSkinPanel, {self.mGelinaData, 2});
	
	UIMainStorePanel.HidePanel();
end

----------------------------------好感度面板逻辑-------------------------------------------
function UIMainStorePanel.OnTouchGelina(gameObj)
	self = UIMainStorePanel;	
			
	if(self.mIsBubbling == true) then
		return;
	end

	self.SetAffectionBar();
	setactive(self.mView.mTrans_AffectionBar.gameObject,true);
	-- setactive(self.mView.mBtn_SwitchToSkin.gameObject,true);

	CS.UITweenManager.PlayFadeTweens(self.mView.mTrans_AffectionBar.transform,0.0,1.0,0.3,false,nil,UIStorePanel.mTweenExpo);
	self.mIsBubbling = true;
	
	if(NetCmdStoreData:CanTouchGelina(self.mStcGelinaId) == false) then
		self.HideAffectionBar();
		return;
	end
	
	NetCmdStoreData:SendStoreTouchGelina(self.TouchGelinaCallback);	
end

function UIMainStorePanel.SetAffectionBar()
	self = UIMainStorePanel;	
	self.mGelinaData = NetCmdNpcData:GetNpcDataById(self.mStcGelinaId);
	
	local lv = self.mGelinaData.affection_lv;
	local affection = self.mGelinaData.affection;	
	local nextExp = TableData.GetAffectionByLevel(lv+1);
	local curExp = affection;
	local next_scale = curExp / nextExp;	
	self.mView.mImage_AffectionBar_AffectionFilledBar.fillAmount = next_scale;
	self.mView.mText_AffectionBar_Level.text = lv;
end

function UIMainStorePanel.HideAffectionBar( )
	self = UIMainStorePanel;
	CS.UITweenManager.PlayFadeTweensWithDelay(self.mView.mTrans_AffectionBar.transform,1.0,0.0,0.3,1,false,self.TweenCallback,UIStorePanel.mTweenExpo);
end

function UIMainStorePanel.HideBubble()
	self = UIMainStorePanel;
	
	local bubble = self.mView.mTrans_AffectionBubble.gameObject;
	CS.UITweenManager.PlayFadeTweens(bubble.transform,1.0,0.0,1.0,false,nil,self.mTweenExpo);
	
	if(NetCmdStoreData:CanTouchGelina(self.mStcGelinaId)) then
		setactive(bubble,true);
		CS.UITweenManager.PlayFadeTweensWithDelay(bubble.transform,0.0,1.0,0.3,2.0,false,self.TweenCallback,self.mTweenExpo);
	else
		setactive(bubble,false);
	end	
end

function UIMainStorePanel.TouchGelinaCallback(ret)
	self = UIMainStorePanel;
	
	if ret == CS.CMDRet.eSuccess then
		local bubble = self.mView.mTrans_AffectionBubble.gameObject;		
		self.HideBubble();
	else
		gfdebug("触摸格林娜失败");
	end	
end

function UIMainStorePanel.TweenCallback()
	self = UIMainStorePanel;
	self.mIsBubbling = false;
end


function UIMainStorePanel.OnUpdateAffection(msg)
	self = UIMainStorePanel;
	local npcData = msg.Content;
	self.UpdateAffectionBar(npcData);	
end

function UIMainStorePanel.OnRefreshGelina(msg)
	self = UIMainStorePanel;
	local bubble = self.mView.mTrans_AffectionBubble.gameObject;
	if(NetCmdStoreData:CanTouchGelina(self.mStcGelinaId) == true) then
		setactive(bubble,true);
		CS.UITweenManager.PlayFadeTweens(bubble.transform,0.0,1.0,0.3,false,nil,self.mTweenExpo);
	end
end

function  UIMainStorePanel.OnSwitchHandler(msg)
	self = UIMainStorePanel
	if(msg.Sender==5)then
		local paramArray = msg.Content

		if(paramArray == nil or paramArray.Length == 0) then
			self.ShowStorePanel(1,false);
		else
			local tagID = paramArray[0]
			if tagID and tagID > 0 then
				self.ShowStorePanel(tagID,false);
			end
		end	
	end
end

function UIMainStorePanel.UpdateAffectionBar(npcData)
	self = UIMainStorePanel;
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
	
	local fromScale = Vector3(prev_scale,1.0,1.0);
	local toScale = Vector3(next_scale,1.0,1.0);
	local levelDelta = lv - prevLv;
	local fillBarTrans = self.mView.mImage_AffectionBar_AffectionFilledBar.transform;
	local t = 0.5;
	
	self.mLevelDuringAnim = prevLv;
	self.mView.mText_AffectionBar_Level.text = prevLv;
	
	local max_level = NetCmdStoreData:GetAffectionMaxLevel();
	local start_level = prevLv + prev_scale;
	local end_level = math.min(lv + next_scale,max_level+0.9999);
	local duration = math.max(2,lv - prevLv) / 2;

	if(self.mView.mImage_AffectionBar_AffectionFilledBar.gameObject.activeInHierarchy == false) then
		return;
	end

	CS.ProgressBarAnimationHelper.Play(self.mView.mImage_AffectionBar_AffectionFilledBar,start_level,end_level,duration,
    function (curLv)
        print(curLv);
        UIMainStorePanel.mView.mText_AffectionBar_Level.text = curLv;
    end,
    function ()
		print("over");
		UIMainStorePanel.HideAffectionBar();
	end);
end



function UIMainStorePanel.CurFillTweenScaleReset()
	self = UIMainStorePanel;
	
	self.mView.mImage_AffectionBar_AffectionFilledBar.transform.localScale = Vector3(0.0,1.0,1.0);
	self.mLevelDuringAnim = self.mLevelDuringAnim + 1;
	self.mView.mText_AffectionBar_Level.text = self.mLevelDuringAnim;
	
end


----------------------------------换皮肤面板逻辑-------------------------------------------

UIMainStorePanel.mGunModel = nil;
function UIMainStorePanel:CreateModel(modelId)

    if self.mSelectedGunId == nil then
        self.mSelectedGunId = List:New(CS.System.Int32);
    end

    if self.mModelObjects == nil then
        self.mModelObjects = List:New(CS.UnityEngine.GameObject);
    end

    if not self.mSelectedGunId:Contains(modelId) then
        self.mSelectedGunId:Add(modelId);
        self.mGunModel = UIUtils.GetModelNoWeapon(self.E3DModelType.eGun, modelId, CS.EGetModelUIType.eFacility);	
		self.mGunModel.transform.position = Vector3(-5.64,-5.65,-6.24);
		self.mGunModel.transform.localEulerAngles = Vector3(0,180,0);
		self.mGunModel.transform.localScale = Vector3(6,6,6);

		local animator = self.mGunModel.gameObject:GetComponent("Animator");    
		local modelConfigData = TableData.GetGunModelData(modelId);
		local costumeData = TableData.GetGunCostumesData(self.mGelinaData.costume_id);

		local str = modelConfigData.model .. "/" .. modelConfigData.model .. "_Costume0" .. costumeData.sequence;
		local controller = ResSys:GetCharacterNonbattleAnimController(str, modelConfigData.model .. "_Costume0" .. costumeData.sequence);
		animator.runtimeAnimatorController = controller;
		animator:SetBool("Walk", true);

		CS.UI3DModelManager.ChangeLayersRecursively(self.mGunModel.transform,"Friend");

        for i = 1, self.mModelObjects:Count() do
            setactive(self.mModelObjects[i].gameObject, false);
        end

        self.mModelObjects:Add(self.mGunModel);
    else
        for i = 1, self.mSelectedGunId:Count() do
            if self.mSelectedGunId[i] == modelId then
                self.mGunModel = self.mModelObjects[i];
                setactive(self.mModelObjects[i].gameObject, true);
            else
                setactive(self.mModelObjects[i].gameObject, false);
            end
        end
    end

	GFUtils.MoveToLayer(self.mGunModel.transform,CS.UnityEngine.LayerMask.NameToLayer("Friend"));
	self:SetLookAtCharacter(self.mGunModel.gameObject);
    return self.mGunModel;
end

function UIMainStorePanel:SetLookAtCharacter(obj)
	local obj = CS.UnityEngine.GameObject.Find("CharacterSelfShadowSettings");
	if(obj == nil) then
		return;
	end
	self.mCharacterSelfShadowSettings = obj:GetComponent("CharacterSelfShadowSettings");
	
	self.mCharacterSelfShadowSettings:SetLookAtCharacter(obj);
end

function UIMainStorePanel:ClearTable()
    for i = 1, self.mModelObjects:Count() do
		--gfdestroy(self.mModelObjects[i].gameObject);
		self.mModelObjects[i]:Destroy();
    end

    self.mModelObjects:Clear();

    self.mSelectedGunId:Clear();
	
	self:ClearTimer();
end

function UIMainStorePanel:ClearStoreItems()
	
	for k,v in pairs(self.mStoreItems) do
		local item = v;
		gfdestroy(v.mUIRoot.gameObject);
	end
	
	self.mStoreItems = {};
end

function UIMainStorePanel:ClearTimer()	
	for i = 1, #self.mTagTimers do
		self.mTagTimers[i]:Stop()
		-- TimerSys:Remove(self.mTagTimers[i]);
	end
end


function UIMainStorePanel.HidePanel()
	self = UIMainStorePanel;
	self:Show(false);
end

function UIMainStorePanel.ShowPanel()
	self = UIMainStorePanel;
	self:Show(true);
	self:InitBubble();
	self:InitResources();
end

function UIMainStorePanel.OnReturnClick(gameobj)	
	self = UIMainStorePanel;
	self.Close();
end

function UIMainStorePanel.OnRelease()
    self = UIMainStorePanel;
	MessageSys:RemoveListener(130001,self.OnUpdateAffection);
	MessageSys:RemoveListener(130002,self.OnRefreshGelina);
	
	self.mCurTagIndex = NetCmdStoreData:GetStoreStartTag();
	self.mIsBubbling = false;
	self:ClearTable();
	self.mPageItems = {};
	self.mTagButtons = {};

	--gfdestroy(self.mRTCamera);
	self.mGunModel:Destroy();
	self.mGunModel = nil;

end