---
--- Created by Administrator.
--- DateTime: 18/9/8 16:50
---
require("UI.UIBasePanel")
require("UI.GarageMain.UIVehicleCardElementMainItem")
require("UI.UITweenCamera")

UIGarageMainPanel = class("UIGarageMainPanel", UIBasePanel);
UIGarageMainPanel.__index = UIGarageMainPanel;

--UI路径
UIGarageMainPanel.mPath_VehicleItem = "Garage/UIVehicleCardElementMain.prefab";
UIGarageMainPanel.mPath_UI_Star = "UICommonFramework/StarA.prefab";
UIGarageMainPanel.mMainNodePath = "Virtual Cameras/Position_1";

--UI控件
UIGarageMainPanel.mView = nil;
UIGarageMainPanel.mVehicleModel = nil;
UIGarageMainPanel.mVehicleModelRoot = nil;


--逻辑参数
UIGarageMainPanel.mCarrierItems = nil;
UIGarageMainPanel.mNetTeamHandle = nil;
UIGarageMainPanel.mNetCarrierHandler = nil;
UIGarageMainPanel.mNetPlayerHandle = nil;
UIGarageMainPanel.mCurrentSelectCarrier = nil;
UIGarageMainPanel.mCurrentLockCarrier = nil;
UIGarageMainPanel.EditModeType = gfenum({"Normal", "Dismantling", "Lock"},-1)
UIGarageMainPanel.mCurEditMode = UIGarageMainPanel.EditModeType.Normal;
UIGarageMainPanel.mVehicleTransPos = vectorzero;
UIGarageMainPanel.mSortType = nil;
UIGarageMainPanel.mSelectedRankType = nil;

UIGarageMainPanel.E3DModelType = gfenum({"eUnknown", "eGun", "eWeapon", "eEffect", "eVechicle"},-1)

function UIGarageMainPanel:ctor()
    UIGarageMainPanel.super.ctor(self);
end

function UIGarageMainPanel.Open()
    UIGarageMainPanel.OpenUI(UIDef.UIGarageMainPanel);
end

function UIGarageMainPanel.Close()
    UIManager.CloseUI(UIDef.UIGarageMainPanel);
end

function UIGarageMainPanel.Init(root, data)

    UIGarageMainPanel.super.SetRoot(UIGarageMainPanel, root);

    self = UIGarageMainPanel;

    self.mData = data;

    self.mView = UIGarageMainView;
    self.mView:InitCtrl(root);

	self.mNetCarrierHandler = CarrierTrainNetCmdHandler;
	self.mNetPlayerHandle = CS.PlayerNetCmdHandler.Instance;
	self.mCarrierItems = List:New(UIVehicleCardElementMainItem);
	
	self.mSelectedRankType = List:New(CS.System.Int32);
	
	UIUtils.GetListener(self.mView.mButton_UI_ButtonExit.gameObject).onClick = self.OnReturnClicked;
	UIUtils.GetListener(self.mView.mImage_UI_ButtonDismantlingMode.gameObject).onClick = self.OnDismantlingClick;
	UIUtils.GetListener(self.mView.mImage_UI_ButtonDismantlingComfirm.gameObject).onClick = self.OnDismantlingConfirmClick;
	UIUtils.GetListener(self.mView.mImage_UI_ButtonLockMode.gameObject).onClick = self.OnLockClick;
	UIUtils.GetListener(self.mView.mButton_UI_ButtonArrangePopup.gameObject).onClick = self.OnArrageClicked;
	UIUtils.GetListener(self.mView.mButton_UI_DetailButton.gameObject).onClick = self.OnDetailClicked;
	
	UIUtils.GetButtonListener(self.mView.mButton_UI_ButtonConfirm.gameObject).onClick = self.OnSortButtonClicked;
	UIUtils.GetButtonListener(self.mView.mBUtton_UI_ButtonReset.gameObject).onClick = self.OnResetSortClicked;

	self.mSortType = 1
	local listener = UIUtils.GetButtonListener(self.mView.mButton_UI_Sorting_Level.gameObject)
	listener.onClick = self.OnSortTypeClicked
	listener.param = 1

	listener = UIUtils.GetButtonListener(self.mView.mButton_UI_Sorting_BattlePower.gameObject)
	listener.onClick = self.OnSortTypeClicked
	listener.param = 2

	listener = UIUtils.GetButtonListener(self.mView.mButton_UI_Sorting_GettingOrder.gameObject)
	listener.onClick = self.OnSortTypeClicked
	listener.param = 3

	listener = UIUtils.GetButtonListener(self.mView.mButton_UI_Sorting_Star.gameObject)
	listener.onClick = self.OnSortTypeClicked
	listener.param = 4

	listener = UIUtils.GetButtonListener(self.mView.mButton_UI_Sorting_HP.gameObject)
	listener.onClick = self.OnSortTypeClicked
	listener.param = 5

	listener = UIUtils.GetButtonListener(self.mView.mButton_UI_Sorting_Team.gameObject)
	listener.onClick = self.OnSortTypeClicked
	listener.param = 6
	
	self:InitSortButton();
	
	self.mVehicleModelRoot = UIUtils.FindTransform("Vehicle");
	local vehicle_01 = UIUtils.FindTransform("Vehicle_01");
	self.mVehicleTransPos = vehicle_01.localPosition;
	setactive(vehicle_01,false);

	self:SetCameraRoot();
end

function UIGarageMainPanel.OnInit()
	
end

function UIGarageMainPanel:InitSortButton()
    for i = 1, #self.mView.mSortRankTypeList do
        local listener = UIUtils.GetButtonListener(self.mView.mSortRankTypeList[i].gameObject)
        listener.onClick = self.OnSortRankTypeClick;
        listener.paramIndex = i;
        listener.paramData = self.mView.mMaxRank - (i - 1);
    end
end

function UIGarageMainPanel:InitVehicleItems()
	
	self:ClearCarrierItems();
	setactive(self.mView.mImage_UI_ButtonDismantlingComfirm,false);

    local prefab = UIUtils.GetGizmosPrefab(self.mPath_VehicleItem,self);
	
    for i = 1, CarrierTrainNetCmdHandler.CarrierCount do
        local carrier = CarrierTrainNetCmdHandler:GetCarrier(i - 1);
        local prefabInst = instantiate(prefab);
        local carrierItem = UIVehicleCardElementMainItem.New();
        carrierItem:InitCtrl(prefabInst.transform);

        --UIUtils.AddListItem(prefabInst, self.mView.mGridLayoutGroup_UI_VehcicleCardListLayout.transform);
        carrierItem:SetCarriedItemData(carrier);
		
		local carrierBtn = UIUtils.GetButtonListener(carrierItem.mUIRoot.gameObject);
        carrierBtn.onClick = self.OnCarrierItemClick;
        carrierBtn.param = carrierItem;
        carrierBtn.paramData = carrier;

        self.mCarrierItems:Add(carrierItem);
    end
	
	self.SortCarrierItems();
	
	for i = 1, self.mCarrierItems:Count(), 1 do
		local item = self.mCarrierItems[i];
		UIUtils.AddListItem(item:GetRoot(), self.mView.mGridLayoutGroup_UI_VehcicleCardListLayout.transform);
	end
	
	local defaultSelectIndex = 1;
	for i = 1, self.mCarrierItems:Count(),1 do
		local item = self.mCarrierItems[i];
		if(item:IsActive()) then
			defaultSelectIndex = i;
			break;
		end	
	end
	self.mCarrierItems[defaultSelectIndex]:SetNormalSelected(true);				
	self.mCurrentSelectCarrier = self.mCarrierItems[defaultSelectIndex];
end

function UIGarageMainPanel:InitVechicleInfo()
	if(self.mVehicleModel ~= nil) then
		gfdestroy(self.mVehicleModel.gameObject);
	end
	

	local data = self.mCurrentSelectCarrier.mCarrierData;
	local stcData = self.mCurrentSelectCarrier.mStcCarrierData;
	local stcPrefixData = self.mCurrentSelectCarrier.mStcCarrierPrefixData;
	
	self.mView.mImage_UI_Rank.sprite = IconUtils.GetRaritySprite("Rarity_"..stcData.rank);
	self.mView.mText_UI_Name.text = stcData.name;
	self.mView.mText_UI_Prefix.text = stcPrefixData.name;

	self:ClearStars();
	local starCount = data.star;
	local prefab = UIUtils.GetGizmosPrefab(self.mPath_UI_Star,self);
	for i = 1, starCount, 1 do 
		local prefabInst = instantiate(prefab);
		UIUtils.AddListItem(prefabInst, self.mView.mImage_UI_Stars.transform);
	end
	
	self.mVehicleModel = UIUtils.GetModel(self.E3DModelType.eVechicle, stcData.id, CS.EGetModelUIType.eFormation);
	 
	if self.mVehicleModel == nil then
        print("模型空！")
    else
		setparent(self.mVehicleModelRoot,self.mVehicleModel.transform);
        self.mVehicleModel.transform.localPosition = self.mVehicleTransPos;
        self.mVehicleModel.transform.localRotation = CS.Quaternion.identity;
    end
end

function UIGarageMainPanel:SetCameraRoot()
    self.mMainNode = UIUtils.FindTransform(self.mMainNodePath);
end

function UIGarageMainPanel:TweenCamera()
	UITweenCamera.TweenCamera(self.mView.mCamera,self.mMainNode,0.5);
end

function UIGarageMainPanel.OnShow()
    self = UIGarageMainPanel;
	self:TweenCamera();
	
	self.mCurEditMode = UIGarageMainPanel.EditModeType.Normal;
	self:ExitDismantlingMode();
	self:ExitLockMode();
	
	--需要更新当前选中的对象的信息(数据发生变化，需要更新lua本地的数据)
	if self.mCurrentSelectCarrier ~= nil then
		if self.mCurrentSelectCarrier.mCarrierData ~= nil then
			local curData = CarrierNetCmdHandler:GetCarrierByID(self.mCurrentSelectCarrier.mCarrierData.id);
			if curData ~= self.mCurrentSelectCarrier.mCarrierData then
				self.mCurrentSelectCarrier:SetCarriedItemData(curData);
			end
		end
	end

	self:InitVehicleItems();
	self:InitVechicleInfo();
end

function UIGarageMainPanel.OnDismantlingClick(gameObj)
	self = UIGarageMainPanel;
	if self.mCurEditMode == UIGarageMainPanel.EditModeType.Dismantling then
		self.mCurEditMode = UIGarageMainPanel.EditModeType.Normal;
		self:ExitDismantlingMode();
	else
		self:ExitLockMode();
		self:EnterDismantlingMode();
		self.mCurEditMode = UIGarageMainPanel.EditModeType.Dismantling;
		setactive(self.mView.mImage_UI_ButtonDismantlingModeActived.gameObject, true);
	end
end

function UIGarageMainPanel:EnterDismantlingMode()
	for i = 1, self.mCarrierItems:Count() do
        if self.mCarrierItems[i].mIsLock then
			setactive(self.mCarrierItems[i].mUIRoot,false);
		end
    end
end

function UIGarageMainPanel:ExitDismantlingMode()
	for i = 1, self.mCarrierItems:Count() do
		setactive(self.mCarrierItems[i].mUIRoot,true);
    end
	
	setactive(self.mView.mImage_UI_ButtonDismantlingModeActived.gameObject, false);
	self:UnSelectAllDismantlingItems();
	setactive(self.mView.mImage_UI_ButtonDismantlingComfirm,false);
end

function UIGarageMainPanel.OnLockClick(gameObj)
	self = UIGarageMainPanel;
	if self.mCurEditMode == UIGarageMainPanel.EditModeType.Lock then
		self.mCurEditMode = UIGarageMainPanel.EditModeType.Normal;
		self:ExitLockMode();
	else
		self:ExitDismantlingMode();
		self.mCurEditMode = UIGarageMainPanel.EditModeType.Lock;
		setactive(self.mView.mImage_UI_ButtonLockModeActived.gameObject, true);
		self:ShowItemLockFrames();
	end
end

function UIGarageMainPanel:ExitLockMode()
	setactive(self.mView.mImage_UI_ButtonLockModeActived.gameObject, false);
	self:UnSelectAllLockItems();
end

function UIGarageMainPanel.OnCarrierItemClick(gameobj)
	self = UIGarageMainPanel;
    local btnTrigger = getcomponent(gameobj, typeof(CS.ButtonEventTriggerListener));
    if btnTrigger ~= nil then
        if btnTrigger.param ~= nil then
            local carrierItem = btnTrigger.param; 
			local carrier = btnTrigger.paramData;
			if self.mCurEditMode == UIGarageMainPanel.EditModeType.Normal then
				self:UnSelectAllItems();
				carrierItem:SetNormalSelected(true);
				
				self.mCurrentSelectCarrier = carrierItem;
				self:InitVechicleInfo();
			end
			
			if self.mCurEditMode == UIGarageMainPanel.EditModeType.Dismantling then
				local v = not carrierItem.mIsDismantling;
				carrierItem:SetDismantling(v);
				
				self:ShowOrHideConfirmBtn();
			end
			
			if self.mCurEditMode == UIGarageMainPanel.EditModeType.Lock then
				local v = not carrierItem.mIsLock;
				self.mCurrentLockCarrier = carrierItem;
				carrierItem:SetLock(v,self.CmdLockCallback);
			end
        end
    end
end

function UIGarageMainPanel.OnDismantlingConfirmClick()
	self = UIGarageMainPanel;
	local dismantlingIds = {};
	local dismantlingData = {};
	local bShowWarning = false;
	local income = 0;
	local j = 1;
	for i = 1, self.mCarrierItems:Count() do
        if self.mCarrierItems[i].mIsDismantling == true then
			local data = self.mCarrierItems[i].mCarrierData;
			dismantlingIds[j] = data.id;
			dismantlingData[j] = data;
			if(data.level > 1 or data.star > 1) then
				bShowWarning = true;
			end
			
			j = j + 1;
		end
    end
	
	income = self.mNetCarrierHandler:GetDismantlingIncome(dismantlingData);
	
	self.mView:ShowMessage(income,bShowWarning, self.OnDoDismantling,dismantlingIds);
end;

function UIGarageMainPanel.OnDoDismantling(data)
    self = UIGarageMainPanel;
    if data ~= nil then
		self.mNetCarrierHandler:ReqCarrierDismantling(data,self.CmdDismantlingCallback);
    end
	
	self.mView:HideMessage();
end

function UIGarageMainPanel.OnArrageClicked(gameObj)
	local obj = self.mView.mImage_UI_ButtonArrangePopupActived.gameObject;
	local v = not obj.activeSelf;
	setactive(obj,v);
	setactive(self.mView.mImage_UI_FilterPanel.gameObject,v);
end

function UIGarageMainPanel.OnDetailClicked(gameObj)

	self = UIGarageMainPanel;
	UISystem:ShowUI(UIDef.UIGarageMainPanel, false);
	UIGarageVechicleDetailPanel:SetCurCarrier(self.mCurrentSelectCarrier.mCarrierData);
	UISystem:OpenUI(UIDef.UIGarageVechicleDetailPanel);
end

function UIGarageMainPanel.OnSortRankTypeClick(gameObject)
	self = UIGarageMainPanel;
    local btnListener = getcomponent(gameObject, typeof(CS.ButtonEventTriggerListener));
    if btnListener ~= nil then
        local index = btnListener.paramIndex;
        local rank = btnListener.paramData;
        if self.mSelectedRankType:Contains(rank) then
            self.mSelectedRankType:Remove(rank);
			print("已经移除稀有度：" ..rank);
        else
            self.mSelectedRankType:Add(rank);
        end

        self.mView:SetRankState(index, rank);

        for i = 1, self.mSelectedRankType:Count() do
            print("已经加入的稀有度：" ..self.mSelectedRankType[i]);
        end
    end
end

function UIGarageMainPanel.OnSortButtonClicked(gameObj)
	self = UIGarageMainPanel;
	self:InitVehicleItems();
	self:InitVechicleInfo();
	self.OnArrageClicked(gameObj);
end


function UIGarageMainPanel.SortCarrierItems()
	self = UIGarageMainPanel
	
	gfdebug(self.mSortType)
	
	local function compByLevel(elem1,elem2)
		return elem1.mCarrierData.level>elem2.mCarrierData.level
	end

	---战斗效能公式没出
	local function compByPower(elem1,elem2)
		return false
	end
	---时间排序没出
	local function compByGotTime(elem1,elem2)
		return false
	end

	local function compByStar(elem1,elem2)
		return elem1.mCarrierData.star>elem2.mCarrierData.star
	end

	local function compByMaxHp(elem1,elem2)
		return elem1.mCarrierData.prop.max_hp>elem2.mCarrierData.prop.max_hp
	end

	local function compByTeamID(elem1,elem2)
		if elem1.mCarrierData.team_id==0 then
			return false
		end
		
		if elem2.mCarrierData.team_id==0 then
			return true;
		end

		return elem1.mCarrierData.team_id<elem2.mCarrierData.team_id
	end
	
	--数值排序
	if(self.mSortType==1)then	
		self.mCarrierItems:Sort(compByLevel)
	elseif(self.mSortType==2)then
		gferror("战斗效能排序暂时不可用");
	elseif(self.mSortType==3)then
		gferror("获取时间排序暂时不可用");
	elseif(self.mSortType==4)then
		self.mCarrierItems:Sort(compByStar)
	elseif(self.mSortType==5)then
		self.mCarrierItems:Sort(compByMaxHp)
	elseif(self.mSortType==6)then
		self.mCarrierItems:Sort(compByTeamID)
	end
	
	--类型显示隐藏
	
	for i = 1, self.mCarrierItems:Count() do
		local isContainsCondition = false;
		local carrierItem = self.mCarrierItems[i];
		local stcCarrierData = carrierItem.mStcCarrierData;

		if self.mSelectedRankType:Count() == 0 then
			isContainsCondition = true;
		else
			if self.mSelectedRankType:Count() > 0 then
				if self.mSelectedRankType:Contains(stcCarrierData.rank) then
					isContainsCondition = true;
				end
			end
		end

		if isContainsCondition then
			carrierItem:SetActive(true);
		else
			carrierItem:SetActive(false);
		end
	end
end


function UIGarageMainPanel.OnSortTypeClicked(gameObj)
	self = UIGarageMainPanel
	setactive(self.mView.mImage_UI_Cover_Level.gameObject,false)
	setactive(self.mView.mImage_UI_Cover_BattlePower.gameObject,false)
	setactive(self.mView.mImage_UI_Cover_GettingOrder.gameObject,false)
	setactive(self.mView.mImage_UI_Cover_Star.gameObject,false)
	setactive(self.mView.mImage_UI_Cover_HP.gameObject,false)
	setactive(self.mView.mImage_UI_Cover_Team.gameObject,false)

	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		self.mSortType = eventTrigger.param
	end
	
	if(self.mSortType==1)then
		setactive(self.mView.mImage_UI_Cover_Level.gameObject,true)
	elseif(self.mSortType==2)then
		setactive(self.mView.mImage_UI_Cover_BattlePower.gameObject,true)
		return
	elseif(self.mSortType==3)then
		setactive(self.mView.mImage_UI_Cover_GettingOrder.gameObject,true)
		return
	elseif(self.mSortType==4)then
		setactive(self.mView.mImage_UI_Cover_Star.gameObject,true)
	elseif(self.mSortType==5)then
		setactive(self.mView.mImage_UI_Cover_HP.gameObject,true)
	elseif(self.mSortType==6)then
		setactive(self.mView.mImage_UI_Cover_Team,true)
	end
end

function UIGarageMainPanel.OnResetSortClicked(gameObj)
	self = UIGarageMainPanel;
	setactive(self.mView.mImage_UI_Cover_Level.gameObject,true);
	setactive(self.mView.mImage_UI_Cover_BattlePower.gameObject,false);
	setactive(self.mView.mImage_UI_Cover_GettingOrder.gameObject,false);
	setactive(self.mView.mImage_UI_Cover_Star.gameObject,false);
	setactive(self.mView.mImage_UI_Cover_HP.gameObject,false);
	setactive(self.mView.mImage_UI_Cover_Team.gameObject,false);
	self.mSortType = 1;
    self.mSelectedRankType:Clear();
    self.mView:ResetSort();
	
	self:InitVehicleItems();
	self:InitVechicleInfo();
	self.OnArrageClicked(gameObj);
end


function UIGarageMainPanel.CmdDismantlingCallback (ret)
	self = UIGarageMainPanel;
	if ret == CS.CMDRet.eSuccess then
		gfdebug("载具拆解成功");
		self.mNetPlayerHandle:SendReqRoleCarrier(self.CmdReqRoleCarrierCallback);
		self.mCurEditMode = UIGarageMainPanel.EditModeType.Normal;
		self:ExitDismantlingMode();
    else
		gfdebug("载具拆解失败");
		MessageBox.Show("Error", "载具拆解失败");
	end
end

function UIGarageMainPanel.CmdReqRoleCarrierCallback (ret)
	self = UIGarageMainPanel;
	if ret == CS.CMDRet.eSuccess then
		gfdebug("获取载具成功");
		self:InitVehicleItems();
		self:InitVechicleInfo();
    else
		gfdebug("获取载具失败");
	end
end

function UIGarageMainPanel.CmdLockCallback (ret)
	self = UIGarageMainPanel;
	local curItem = self.mCurrentLockCarrier;
	
	if ret == CS.CMDRet.eSuccess then	
		curItem:DoLockOrUnlock();		
		gfdebug("载具锁定/解锁成功");
    else
		gfdebug("载具锁定/解锁失败");
		MessageBox.Show("Error", "载具锁定/解锁失败");
	end
end

function UIGarageMainPanel:ShowOrHideConfirmBtn()
	local isShow = false;
	
	for i = 1, self.mCarrierItems:Count() do
        if self.mCarrierItems[i].mIsDismantling == true then
			isShow = true;
		end
    end

	setactive(self.mView.mImage_UI_ButtonDismantlingComfirm,isShow);
end

function UIGarageMainPanel:ShowItemLockFrames()
	for i = 1, self.mCarrierItems:Count() do
        self.mCarrierItems[i]:ShowLockFrame();
    end
end

function UIGarageMainPanel:UnSelectAllItems()
	for i = 1, self.mCarrierItems:Count() do
        self.mCarrierItems[i]:SetNormalSelected(false);
    end
end

function UIGarageMainPanel:UnSelectAllDismantlingItems()
	for i = 1, self.mCarrierItems:Count() do
        self.mCarrierItems[i]:SetDismantling(false);
    end
end

function UIGarageMainPanel:UnSelectAllLockItems()
	for i = 1, self.mCarrierItems:Count() do
        self.mCarrierItems[i]:HideLockFrame();
    end
end


function UIGarageMainPanel:ClearCarrierItems()
    for i = 1, self.mCarrierItems:Count() do
        gfdestroy(self.mCarrierItems[i]:GetRoot());
    end

    self.mCarrierItems:Clear();
end

function UIGarageMainPanel:ClearStars()
	local tr = self.mView.mImage_UI_Stars.transform;
	local count = tr.childCount;
	for i = count - 1, 0, -1 do
		gfdestroy(tr:GetChild(i).gameObject);
	end
end

function UIGarageMainPanel:OnReturnClicked(gameobj)
	self = UIGarageMainPanel;
	self.Close();
    SceneSys:ReturnLast();
end

function UIGarageMainPanel.OnRelease()

    self = UIGarageMainPanel;
	self.mCarrierItems:Clear();
	self.mCurrentSelectCarrier = nil;
end