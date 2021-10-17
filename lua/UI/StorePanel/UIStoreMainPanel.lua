require("UI.UIBasePanel")
require("UI.UITweenCamera")
require("UI.StorePanel.UIStoreMainPanelView")
require("UI.StorePanel.UIStoreConfirmPanelView")
require("UI.StoreCoin.StoreCoin")
require("UI._TagButtonItem.UI_TagButtonItem")

UIStoreMainPanel = class("UIStoreMainPanel", UIBasePanel);
UIStoreMainPanel.__index = UIStoreMainPanel;

--UI路径
UIStoreMainPanel.m3DCanvasRootPath = "FormationCameraRoot/3DFormationCanvas";
UIStoreMainPanel.mPath_GoodsItem = "Store/UIStoreGoodsItem.prefab";
UIStoreMainPanel.mPath_GoodsItem_Big = "Store/UIStoreDiamondItem.prefab";
UIStoreMainPanel.mPath_GoodsItem_Skin = "Store/UIStoreSkinItem.prefab";
UIStoreMainPanel.mPath_ConfirmPanel = "Store/UIStoreConfirmPanel.prefab"
UIStoreMainPanel.mPath_StoreCoin = "Store/StoreCoin.prefab"

--UI控件
UIStoreMainPanel.mView = nil;

--逻辑参数
UIStoreMainPanel.mData = nil;
UIStoreMainPanel.mTagButtons = nil;
UIStoreMainPanel.mCurTagIndex = 1;
UIStoreMainPanel.mStoreItems = {};
UIStoreMainPanel.mIsBubbling = false;
UIStoreMainPanel.mIsLeveling = false;

UIStoreMainPanel.mTagTimer = nil;
UIStoreMainPanel.mItemTimer = nil;

UIStoreMainPanel.LevelDuringAnim = 0;

UIStoreMainPanel.mGoodDatas = nil;
UIStoreMainPanel.mStcGelinaId = 1001;
UIStoreMainPanel.mCurCurrencyId = 1;
UIStoreMainPanel.mSpecialTagDataDict = nil;

UIStoreMainPanel.mRTCamera = nil;

UIStoreMainPanel.E3DModelType = gfenum({"eUnkown", "eGun", "eWeapon", "eEffect", "eVechicle"},-1)

UIStoreMainPanel.mTweenEase = CS.DG.Tweening.Ease.InOutSine;
UIStoreMainPanel.mTweenExpo = CS.DG.Tweening.Ease.InOutCirc;
UIStoreMainPanel.mTweenCirc = CS.DG.Tweening.Ease.OutCirc;

UIStoreMainPanel.mGelinaData = nil;
UIStoreMainPanel.mGelinaObj = nil;
UIStoreMainPanel.mModelRoot = nil;
UIStoreMainPanel.mGunModel = nil;

function UIStoreMainPanel:ctor()
    UIStoreMainPanel.super.ctor(self);
end

function UIStoreMainPanel.Open()
    UIStoreMainPanel.OpenUI(UIDef.UIStoreMainPanel);
end

function UIStoreMainPanel.Close()
	self = UIStoreMainPanel;
    UIManager.CloseUI(UIDef.UIStoreMainPanel);
end

function UIStoreMainPanel.OnHide()
	if(UIMainStorePanel.mGunModel ~= nil) then
		setactive(UIMainStorePanel.mGunModel.transform,false);
	end
end

function UIStoreMainPanel.OnShow()
	if(UIMainStorePanel.mGunModel ~= nil) then
		setactive(UIMainStorePanel.mGunModel.transform,true);
	end

	UIMainStorePanel.mIsOpeningStorePanel = false;
end

function UIStoreMainPanel.Init(root, data)
	self = UIStoreMainPanel;
    self.mData = data;	
	self.mView = UIStoreMainPanelView;
    self.mView:InitCtrl(root);
end

function UIStoreMainPanel.OnInit()
	self = UIStoreMainPanel;
	
	if(QuickStorePurchase.mCurRedirectTag ~= 0) then
		self.mCurTagIndex = QuickStorePurchase.mCurRedirectTag;
		QuickStorePurchase.mCurRedirectTag = 0;
	else
		self.mCurTagIndex = NetCmdStoreData:GetStoreStartTag();
	end

	self.mTagButtons = List:New();
	self.mGelinaData = NetCmdNpcData:GetNpcDataById(self.mStcGelinaId);

	self:InitGelina();
	self:InitTagButtons();
	self:InitStoreItems();
	self:InitBubble();
	self.HideAffectionBar();

	UIUtils.GetListener(self.mView.mBtn_Return.gameObject).onClick = self.OnReturnClick;
	UIUtils.GetButtonListener(self.mView.mBtn_TouchArea.gameObject).onClick = self.OnTouchGelina;

	MessageSys:AddListener(130001,self.OnUpdateAffection);
	MessageSys:AddListener(130002,self.OnRefreshGelina);
end

function UIStoreMainPanel.OnDataUpdate(data)
	self = UIStoreMainPanel
	self.mData = data

	self.OnConfirmGotoBuyDiamond(self.mData[1])
end


function UIStoreMainPanel:InitTagButtons()

	local storeTagList = TableData.listStoreTagDatas;
	local defaultSelect = nil;

	self.mTagButtons = List:New();
	for i = 0, self.mView.mHLayout_ButtonTab.transform.childCount-1 do
		local obj = self.mView.mHLayout_ButtonTab.transform:GetChild(i);
		gfdestroy(obj);
	end

	for i= 0, storeTagList.Count - 1 do
		local data = storeTagList[i];
		local hide = (data.Type ~= CS.GF2.Data.StoreTagType.Shop);

		if(hide == false) then
			local item = StoreTabBtnItem.New();
			item:InitCtrl(self.mView.mHLayout_ButtonTab.transform);
			item:InitData(data);
			local listener = UIUtils.GetButtonListener(item.mBtn_Tab.gameObject);
			listener.onClick = self.OnTagButtonClicked;
			listener.param = data.id;

			self.mTagButtons:Add(item);

			if(i == 0) then
				defaultSelect = item.mUIRoot.gameObject;
			end

			if(self.mCurTagIndex == data.id) then
				defaultSelect = item.mUIRoot.gameObject;
			end
		end
	end

	self.OnTagButtonClicked(defaultSelect);       

end


function UIStoreMainPanel:InitStoreItems()
	local prefab_s = UIUtils.GetGizmosPrefab(self.mPath_GoodsItem,self);
	local prefab_b = UIUtils.GetGizmosPrefab(self.mPath_GoodsItem_Big,self);
	local prefab_k = UIUtils.GetGizmosPrefab(self.mPath_GoodsItem_Skin,self);

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
		gfdebug(goods.tag)
		if(goods.tag == self.mCurTagIndex) then

			local item = nil;
			local instObj = nil;		
			
			if(goods.ShowType == 0) then
				instObj = instantiate(prefab_s);
				item = UIStoreGoodsItem.New();
				UIUtils.AddListItem(instObj, self.mView.mLayout_ListSmall_DetailList.transform);
			elseif(goods.ShowType == 1) then
				instObj = instantiate(prefab_b);
				item = UIStoreDiamondItem.New();
				UIUtils.AddListItem(instObj, self.mView.mHLayout_ListBig_DetailList.transform);
			else
				instObj = instantiate(prefab_k);
				item = UIStoreSkinItem.New();
				UIUtils.AddListItem(instObj, self.mView.mHLayout_ListBig_DetailList.transform);
			end

			item:InitCtrl(instObj.transform);
			item:InitData(goods);
			
			if(goods.remain_times ~= 0 or goods.limit == 0) then
				local itemBtn = UIUtils.GetButtonListener(item.mBtn_Main.gameObject);
				itemBtn.onClick = self.OnGoodsItemClicked;
				itemBtn.param = item;
				itemBtn.paramData = nil;
			end		

			self.mStoreItems[goods.id] = item;
		
		end
	end
	
	
	self.RefreshStoreItemsByTag();

end

function UIStoreMainPanel:InitResources()
	setactive(self.mView.mTrans_StoreCoinList,false);
end

function UIStoreMainPanel:InitBubble()
	local bubble = self.mView.mTrans_AffectionBubble.gameObject;
	if(NetCmdStoreData:CanTouchGelina(self.mStcGelinaId) == true) then
		setactive(bubble,true);
		CS.UITweenManager.PlayFadeTweens(bubble.transform,0.0,1.0,0.3,false,nil,self.mTweenExpo);
	end

	self.SetAffectionBar();
end


function UIStoreMainPanel.RefreshStoreItemsByTag()
	self = UIStoreMainPanel;
	local tagType = NetCmdStoreData:GetStoreTagType(self.mCurTagIndex);
	
	if(tagType ~= 0) then
		setactive(self.mView.mTrans_ListBig.gameObject, true);
		setactive(self.mView.mTrans_ListSmall.gameObject, false);
	else
		setactive(self.mView.mTrans_ListBig.gameObject, false);
		setactive(self.mView.mTrans_ListSmall.gameObject, true);
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


function UIStoreMainPanel.StartStoreItemCountDown()
	self = UIStoreMainPanel;

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


function UIStoreMainPanel.OnTagButtonClicked(gameObj)
	self = UIStoreMainPanel;
	
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
end

UIStoreMainPanel.IsConfirmPanelOpening = false;
function UIStoreMainPanel.OnGoodsItemClicked(gameObj)
	self = UIStoreMainPanel;

	if(UIStoreMainPanel.IsConfirmPanelOpening == true) then
		return;
	end
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		UIStoreMainPanel.IsConfirmPanelOpening = true;
		local item = eventTrigger.param;
		self:OpenConfirmPanel(item.mData);
	end
end

function UIStoreMainPanel.OnSkinClicked(gameObj)
	self = UIStoreMainPanel;
	self.mGelinaData = NetCmdNpcData:GetNpcDataById(self.mStcGelinaId);
	UIManager.OpenUIByParam(UIDef.UIStoreSkinPanel, {self.mGelinaData, 2});
end


----------------------------------好感度面板逻辑-------------------------------------------
function UIStoreMainPanel.OnTouchGelina(gameObj)
	self = UIStoreMainPanel;	
	
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

function UIStoreMainPanel.SetAffectionBar()
	self = UIStoreMainPanel;	
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
	
	self.mView.mText_AffectionDialog.text = npcData:GetRandomConversation();
	self.mView.mImage_AffectionFilledBar.fillAmount = next_scale;
	self.mView.mText_Level.text = lv;
end

function UIStoreMainPanel.HideAffectionBar()
	self = UIStoreMainPanel;
	CS.UITweenManager.PlayFadeTweensWithDelay(self.mView.mTrans_AffectionBar.transform,1.0,0.0,0.3,1,false,self.TweenCallback,UIStoreMainPanel.mTweenExpo);
	CS.UITweenManager.PlayFadeTweensWithDelay(self.mView.mTrans_Dialog.transform,1.0,0.0,0.3,1,false,self.TweenCallback,UIStoreMainPanel.mTweenExpo);

end

function UIStoreMainPanel.HideBubble()
	self = UIStoreMainPanel;
	
	local bubble = self.mView.mTrans_AffectionBubble.gameObject;
	CS.UITweenManager.PlayFadeTweens(bubble.transform,1.0,0.0,1.0,false,nil,self.mTweenExpo);
	
	if(NetCmdStoreData:CanTouchGelina(self.mStcGelinaId)) then
		setactive(bubble,true);
		CS.UITweenManager.PlayFadeTweensWithDelay(bubble.transform,0.0,1.0,0.3,2.0,false,self.TweenCallback,self.mTweenExpo);
	else
		setactive(bubble,false);
	end	
end

function UIStoreMainPanel.TouchGelinaCallback(ret)
	self = UIStoreMainPanel;
	
	if ret == CS.CMDRet.eSuccess then
		local bubble = self.mView.mTrans_AffectionBubble.gameObject;		
		self.HideBubble();
	else
		gfdebug("触摸格林娜失败");
	end	
end

function UIStoreMainPanel.TweenCallback()
	self = UIStoreMainPanel;
	self.mIsBubbling = false;
end


function UIStoreMainPanel.OnUpdateAffection(msg)
	self = UIStoreMainPanel;
	local npcData = msg.Content;
	self.UpdateAffectionBar(npcData);	
end

function UIStoreMainPanel.OnRefreshGelina(msg)
	self = UIMainStorePanel;
	local bubble = self.mView.mTrans_AffectionBubble.gameObject;
	if(NetCmdStoreData:CanTouchGelina(self.mStcGelinaId) == true) then
		setactive(bubble,true);
		CS.UITweenManager.PlayFadeTweens(bubble.transform,0.0,1.0,0.3,false,nil,self.mTweenExpo);
	end
end

function UIStoreMainPanel.UpdateAffectionBar(npcData)
	self = UIStoreMainPanel;

	setactive(self.mView.mTrans_AffectionBar.gameObject,true);
	CS.UITweenManager.KillTween(self.mView.mTrans_AffectionBar.transform);
	CS.UITweenManager.PlayFadeTweens(self.mView.mTrans_AffectionBar.transform,0.0,1.0,0.3,false,nil,UIStoreMainPanel.mTweenExpo);
	CS.UITweenManager.PlayFadeTweens(self.mView.mTrans_Dialog.transform,0.0,1.0,0.3,false,nil,UIStoreMainPanel.mTweenExpo);

	self.mView.mText_AffectionDialog.text = npcData:GetRandomConversation();
	
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
	
	UIStoreMainPanel.LevelDuringAnim = prevLv;
	self.mView.mText_Level.text = prevLv;

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

	if(self.mView.mImage_AffectionFilledBar.gameObject.activeInHierarchy == false) then
		return;
	end

	CS.ProgressBarAnimationHelper.Play(self.mView.mImage_AffectionFilledBar,start_level,end_level,duration,
    function (curLv)
        UIStoreMainPanel.mView.mText_Level.text = curLv;
    end,
    function ()
		print("over");
		UIStoreMainPanel.mIsLeveling = false;
		UIStoreMainPanel.HideAffectionBar();
    end);
	
end


----------------------------------购买确认面板逻辑------------------------------------------
function UIStoreMainPanel:OpenConfirmPanel(data)
	UIStoreConfirmPanelView.OpenConfirmPanel(data,self.mView.mUIRoot,data.price_type,self.OnBuySuccess,self.OnConfirmGotoBuyDiamond);
	UIStoreConfirmPanelView.mObj.transform.localPosition = Vector3(0,0,-1500);
end

function UIStoreMainPanel.OnConfirmGotoBuyDiamond(tagId)
	self = UIStoreMainPanel;
	self.mCurTagIndex = tagId;
	self:InitTagButtons();
	self:RefreshStoreItemsByTag();
end

function UIStoreMainPanel.OnBuySuccess()
	self = UIStoreMainPanel;
	self.UpdateStoreGood();
end

function UIStoreMainPanel.UpdateStoreGood()
	self = UIStoreMainPanel;
	self.OnRefreshStoreGood(CS.CMDRet.eSuccess);
end

function UIStoreMainPanel.OnRefreshStoreGood(ret)
	self = UIStoreMainPanel;
	
	if ret == CS.CMDRet.eSuccess then
		gfdebug("刷新商品列表");
		self:ClearStoreItems();
		self:InitStoreItems();
	else
		gfdebug("刷新商品列表失败");
		MessageBox.Show("出错了", "刷新商品列表失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
	end
end

function UIStoreMainPanel:InitGelina()
	self.mModelRoot = UIUtils.FindTransform(self.mModelRootPath);
	local modelId = TableData.GetGunCostumesData(self.mGelinaData.costume_id).model_config_id
	self:CreateModel(modelId);
end


function UIStoreMainPanel:CreateModel(modelId)

    if self.mSelectedGunId == nil then
        self.mSelectedGunId = List:New(CS.System.Int32);
    end

    if self.mModelObjects == nil then
        self.mModelObjects = List:New(CS.UnityEngine.GameObject);
    end

    if not self.mSelectedGunId:Contains(modelId) then
        self.mSelectedGunId:Add(modelId);
        self.mGunModel = UIUtils.GetModelNoWeapon(self.E3DModelType.eGun, modelId, CS.EGetModelUIType.eFacility);	
		self.mGunModel.transform.position = Vector3(-7.64,-5.65,-6.24);
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

function UIStoreMainPanel:SetLookAtCharacter(obj)
	local obj = CS.UnityEngine.GameObject.Find("CharacterSelfShadowSettings");
	if(obj == nil) then
		return;
	end
	self.mCharacterSelfShadowSettings = obj:GetComponent("CharacterSelfShadowSettings");
	
	self.mCharacterSelfShadowSettings:SetLookAtCharacter(obj);
end

------------------------------------------------------------------------------------------------------

function UIStoreMainPanel:ClearTable()	
	self:ClearTimer();
	self.mTagButtons:Clear();

	for i = 1, self.mModelObjects:Count() do
		self.mModelObjects[i]:Destroy();
    end
    self.mModelObjects:Clear();
    self.mSelectedGunId:Clear();
	
end

function UIStoreMainPanel:ClearStoreItems()
	
	for k,v in pairs(self.mStoreItems) do
		gfdestroy(v.mUIRoot.gameObject);
	end
	
	self.mStoreItems = {};
end

function UIStoreMainPanel:ClearTimer()
	self.mTagTimer:Stop()
	self.mItemTimer:Stop()
	--TimerSys:Remove(self.mTagTimer);
	--TimerSys:Remove(self.mItemTimer);
end

function UIStoreMainPanel.Hide()
	self = UIStoreMainPanel;
	self:Show(false);
end

function UIStoreMainPanel.OnReturnClick(gameobj)	
    self = UIStoreMainPanel;
	self.Close();
end

function UIStoreMainPanel.OnRelease()
    self = UIStoreMainPanel;
	MessageSys:RemoveListener(130001,self.OnUpdateAffection);
	MessageSys:RemoveListener(130002,self.OnRefreshGelina);
	
	self.mCurTagIndex = NetCmdStoreData:GetStoreStartTag();
	self.mIsBubbling = false;
	self.mIsLeveling = false;
	self:ClearTable();
	self:ClearStoreItems();
	
	UIStoreMainPanel.mView = nil;
end