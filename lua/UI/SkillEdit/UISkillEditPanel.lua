require("UI.UIBasePanel")
--require("UI.UIBaseView")
require("UI.SkillEdit.UICoreItem")
require("UI.SkillEdit.UICoreSpace")
require("UI.SkillEdit.UISkillEditView")
require("UI.SkillEdit.UICurSkillItem")

UISkillEditPanel = class("UISkillEditPanel", UIBasePanel);
UISkillEditPanel.__index = UISkillEditPanel;

UISkillEditPanel.mNetSkillCoreHandle = nil;

--UI控件
UISkillEditPanel.mView = nil;

--UI路径
UISkillEditPanel.mPath_CoreItem = "SkillEdit/UICoreItem.prefab";
UISkillEditPanel.mPath_CoreSpace = "SkillEdit/UICoreSpace.prefab";
UISkillEditPanel.mPath_SkillItem = "SkillEdit/UICurSkillItem.prefab";

--逻辑参数
UISkillEditPanel.mCoreItems = nil;
UISkillEditPanel.mCoreSpaces = nil;
UISkillEditPanel.mDict_CoreSpaceInfo = nil;
UISkillEditPanel.mList_CoreSpaceTrans = nil;
UISkillEditPanel.mIsShowActiveSkill = true;
UISkillEditPanel.mDict_CorePassInfo = nil; 
UISkillEditPanel.Instance = nil;
UISkillEditPanel.mSelectedItem = nil;

--核心数据
UISkillEditPanel.mStcCoreData = {};
UISkillEditPanel.mPlayerCoreData = {};
UISkillEditPanel.mCurGunCode = 0;
UISkillEditPanel.mMaxActiveCoreEquip = 2;
UISkillEditPanel.mGunData = nil;

UISkillEditPanel.mBarId = 0;
--构造
function UISkillEditPanel:ctor()
    UISkillEditPanel.super.ctor(self);
end

function UISkillEditPanel.Init(root, data)
	UISkillEditPanel.super.SetRoot(UISkillEditPanel, root);
	self = UISkillEditPanel;
	UISkillEditPanel.Instance = self;
	
	self.mNetSkillCoreHandle = CS.NetCmdCoreData.Instance;
	
	self.mGunData = data;
	self.mCurGunCode = data.id;
	
	self.mBarId = TableData.GetSkillBarIdByGunLevel(self.mGunData.level,self.mGunData.stc_gun_id);
	self.mIsShowActiveSkill = true;
	self.mView = UISkillEditView;
	self.mView:InitCtrl(root);
	
	self:InitCoreData();	
	self:InitCoreGrid(self.mBarId);
	self:InitCoreItems();
	
	UIUtils.GetListener(self.mView.mButton_UI_Return.gameObject).onClick = self.OnReturnClick;
	UIUtils.GetListener(self.mView.mButton_UI_ActiveSkill.gameObject).onClick = self.OnShowActiveSkill;
	UIUtils.GetListener(self.mView.mButton_UI_PositiveSkill.gameObject).onClick = self.OnShowPositiveSkill;
	UIUtils.GetListener(self.mView.mButton_UI_ConfirmButton.gameObject).onClick = self.OnConfirmClicked;
	UIUtils.GetListener(self.mView.mButton_UI_ClearButton.gameObject).onClick = self.OnClearClicked;
	
	MessageSys:AddListener(11002,self.UpdateCoreSelection);
	MessageSys:AddListener(11005,self.DragCoreClicked);
	--MessageSys:AddListener(11006,self.RotateCoreByClickIndex);
end

function UISkillEditPanel.Open()
    self = UISkillEditPanel;
	self.mNetSkillCoreHandle = CS.NetCmdCoreData.Instance;
	
    UIManager.OpenUI(UIDef.UISkillEditPanel);
end

function UISkillEditPanel:InitCoreData ()
	local list = TableData.GetCoreDataList();
	local count = list.Length; 
	
	for i = 0, count-1, 1 do
		local coreData = list[i];
		self.mStcCoreData[coreData.id] = coreData;
	end
	
	local playCores = self.mNetSkillCoreHandle.CoreData;	
	local iter = playCores:GetEnumerator() 	
    while iter:MoveNext() do 
		local k = iter.Current.Key;
		local v = iter.Current.Value;
		self.mPlayerCoreData[k] = v;
	end
end

function UISkillEditPanel:InitCoreItems() 
	self.mCoreItems = List:New(UICoreItem);
	self.mDict_CorePassInfo = {};
	local prefab = UIUtils.GetGizmosPrefab(self.mPath_CoreItem,self);
	for k,v in pairs(self.mPlayerCoreData) do
				       
		local itemId = k;
		local itemStcId = v.stc_id;
		local itemType = self.mStcCoreData[itemStcId].type;
		local itemPosition = v.position;
		local itemGunId = v.gun_id;	
		if self:GunCoreFilter(self.mStcCoreData[itemStcId],itemGunId,itemPosition) then			
			local instObj = instantiate(prefab);
			local item = UICoreItem.New();
			item:InitCtrl(instObj.transform);
			item:SetData(v,self.mStcCoreData[itemStcId]);
			item:SetDragCallBack(self.OnDragBegin,self.OnDragEnd,self.OnRotate);
			
			if self:IsCoreEquippedByOther(itemGunId,itemPosition) then
				item:SetEquippedByOther();
			end
			
			 -- 0未装备或移除，1装备成功，2装备重叠或异常.
			 -- -1未装备，其他为起始格子序号
			 -- 核心StcId
			 -- 核心旋转方向
			self.mDict_CorePassInfo[itemId] = {0,-1,itemStcId,0};
			
			if itemPosition ~= "" and itemGunId == self.mCurGunCode then
				local timerSys = TimerSys:DelayCall(0.1, self.SetupEquippedCoreItem, item);
			end
			
			self.mCoreItems:Add(item);		
			--instObj.transform.parent = self.mView.mImage_UI_CoreList.transform;
			setparent(self.mView.mImage_UI_CoreList.transform, instObj.transform);
			instObj.transform.localScale = vectorone;
		
		end
    end
	
	self:UpdateCoreItems();
end

function UISkillEditPanel:IsCoreEquippedByOther (itemGunId,itemPosition)
	if itemGunId ~= self.mCurGunCode and itemPosition ~= "" then
		return true;
	end
	return false;
end

function UISkillEditPanel:GunCoreFilter (stcCoreData,gunId,pos)	
	--只显示对应类型
	local typeCodes = stcCoreData:GetGunTypeCodes();
	local curGunType = TableData.GetGunData(self.mGunData.stc_gun_id).typeInt;

	for i = 0,typeCodes.Length-1, 1 do
		if typeCodes[i] == 1 and curGunType == i+1 then
			return true;
		end
	end
	
	return false;
end

function UISkillEditPanel.SetupEquippedCoreItem (item)
	local v = item:InitEquippedCore(self.mDict_CoreSpaceInfo,self.mList_CoreSpaceTrans,item.mStartIndex,item.mCoreDir);
	if v ~= nil then
		self.mDict_CoreSpaceInfo = v.mDictSpaceInfo;
		self.mDict_CorePassInfo[v.mCoreId] = {v.mReturnCode,v.mStartIndex,v.mStcCoreId,v.mCoreDir};
	end
	
	self:SetSkillItems();
end


--0未激活，1已激活未占领，>1 已被核心(id)占领
function UISkillEditPanel:InitCoreGrid(barId)
	self.mDict_CoreSpaceInfo = {};
	
	local coreBarShape = TableData.GetSkillBarShapeArrayById(barId);
	local length = coreBarShape.Length;
	for i = 1, length, 1 do
		self.mDict_CoreSpaceInfo[i] = coreBarShape[i-1]; 
	end

	self.mCoreSpaces = List:New(UICoreSpace);
	self.mList_CoreSpaceTrans = List:New();
	local prefab = UIUtils.GetGizmosPrefab(self.mPath_CoreSpace,self);
	for i = 1, 36, 1 do			
		local instObj = instantiate(prefab);
		local item = UICoreSpace.New();
		item:InitCtrl(instObj.transform);
		item:InitGrid(self.mDict_CoreSpaceInfo[i]);
		
		self.mCoreSpaces:Add(item);
		self.mList_CoreSpaceTrans:Add(instObj.transform);
		
		--instObj.transform:SetParent(self.mView.mImage_UI_Area.transform,false);
		setparent(self.mView.mImage_UI_Area.transform, instObj.transform);
	end
end

function UISkillEditPanel:SetSkillItems()
	local list = self:GetEquippedCores();
	local count = #list;
	
	self.mView:ReturnToCache();
	
	for i = 1, count, 1 do 
		local coreData = list[i][1];
		instObj = self.mView:GetCacheSkillItem(i);
		local item = UICurSkillItem.New();
		local level =  list[i][2].level;
		item:InitCtrl(instObj.transform);
		item:InitData(level,coreData);
		
		--instObj.transform.parent = self.mView.mSkillListRoot.transform;
		setparent(self.mView.mSkillListRoot.transform, instObj.transform);
	end
end

function UISkillEditPanel:GetEquippedCores()
	local dict = {};	
	local iter = self.mDict_CoreSpaceInfo:GetEnumerator() 
	
    while iter:MoveNext() do 
		local v = iter.Current.Value;
		if v ~= 0 and v ~=1 then
			local coreData = self.mPlayerCoreData[v];
			local stcId = 0;
			if coreData ~= nil then
				stcId = coreData.stc_id;
			end
			dict[v] = {self.mStcCoreData[stcId],coreData};
		end
	end
	
	local list = {};	
	
	local index = 1;
	for k,v in pairs(dict) do
		list[index] = v;
		index = index + 1;
	end
	
	table.sort(list, function(a,b)
		return a[1].type > b[1].type;
	end)
	
	return list;
end

function UISkillEditPanel:CheckEquippedLimit (curStcCoreId,curCoreType)
	local list = self:GetEquippedCores();
	local activeCount = 0;
	
	for i = 1, #list, 1 do 
		if (list[i][1].type == 1 and curCoreType == 1) then
			activeCount = activeCount + 1;
		end
		
		if (list[i][1].id == curStcCoreId) then
			MessageBox.Show("注意", "有重复的核心！", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
			return true;
		end
	end
	
	if (activeCount >= 2) then
		MessageBox.Show("注意", "超过2个主动核心", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
		return true;
	end
	
	return false;
end

function UISkillEditPanel.OnDragBegin (coreId)
	local checkData = CS.DragCheckData();
	checkData.mStcCoreId = 0;
	checkData.mCoreId = coreId;
	checkData.mDictSpaceInfo = self.mDict_CoreSpaceInfo;
	checkData.mListSpaceRect = self.mList_CoreSpaceTrans;
	
	local v = CS.UICoreDragUtility.RemoveCoreSpace(checkData);
	if(v ~= nil) then
		self.mDict_CoreSpaceInfo = v.mDictSpaceInfo;
		self.mDict_CorePassInfo[v.mCoreId] = {v.mReturnCode,v.mStartIndex,v.mStcCoreId,v.mCoreDir};
	end
end

function UISkillEditPanel.OnDragEnd(parentTrans,data,stcData,coreId,dir)	
	local isReachLimit = self:CheckEquippedLimit(stcData.id,stcData.type);
	if(isReachLimit == true) then
		return nil;
	end
	
	local checkData = CS.DragCheckData();
	checkData.mStcCoreId = stcData.id;
	checkData.mCoreId = coreId;
	checkData.mCoreDir = dir;
	checkData.mDictSpaceInfo = self.mDict_CoreSpaceInfo;
	checkData.mListSpaceRect = self.mList_CoreSpaceTrans;
	
	local v = CS.UICoreDragUtility.CheckCoreShapeAndSpace(parentTrans,data,checkData);
	if(v ~= nil) then
		self.mDict_CoreSpaceInfo = v.mDictSpaceInfo;
		self.mDict_CorePassInfo[v.mCoreId] = {v.mReturnCode,v.mStartIndex,v.mStcCoreId,v.mCoreDir};
	end
	
	self:RecheckUnPassedCore(checkData.mCoreId);	
	self:SetSkillItems();
	return v;
end

function UISkillEditPanel.OnRotate (parentTrans,data,stcData,coreId,dir,startIndex)
	local checkData = CS.DragCheckData();
	checkData.mStcCoreId = stcData.id;
	checkData.mCoreId = coreId;
	checkData.mCoreDir = dir;
	checkData.mDictSpaceInfo = self.mDict_CoreSpaceInfo;
	checkData.mListSpaceRect = self.mList_CoreSpaceTrans;
	
	local v = CS.UICoreDragUtility.CalRotatePos(parentTrans,checkData,startIndex);
	if(v ~= nil) then
		self.mDict_CoreSpaceInfo = v.mDictSpaceInfo;
		self.mDict_CorePassInfo[v.mCoreId] = {v.mReturnCode,v.mStartIndex,v.mStcCoreId,v.mCoreDir};
	end
	self:RecheckUnPassedCore(checkData.mCoreId);	
	self:SetSkillItems();
	return v;
end

function UISkillEditPanel:RecheckUnPassedCore(excludeId)
	for k,v in pairs(self.mDict_CorePassInfo) do
		if v[1] == 2 and k ~= excludeId then
			local checkData = CS.DragCheckData();
			checkData.mStcCoreId = v[3];
			checkData.mCoreId = k;
			checkData.mCoreDir = v[4];
			checkData.mDictSpaceInfo = self.mDict_CoreSpaceInfo;
			checkData.mListSpaceRect = self.mList_CoreSpaceTrans;
	
			local v = CS.UICoreDragUtility.CheckCoreOverlay(checkData,v[2]);
			if(v ~= nil) then
				self.mDict_CoreSpaceInfo = v.mDictSpaceInfo;
				self.mDict_CorePassInfo[v.mCoreId] = {v.mReturnCode,v.mStartIndex,v.mStcCoreId,v.mCoreDir};
				
				if(v.mReturnCode == 1) then
					self:StopCoreItemBlink(v.mCoreId);
				end
			end		
		end
	end
end

function UISkillEditPanel:StopCoreItemBlink(coreId)
	local count = self.mCoreItems:Count();
	for i = 1, count, 1 do
		local coreItem = self.mCoreItems[i];
		if coreItem.mCoreId == coreId then
			coreItem:StopBlink();
		end
	end
end

function UISkillEditPanel.OnShowActiveSkill(gameobj)
	self.mIsShowActiveSkill = true;
	self:UpdateCoreItems();
	self:UpdateButtons();
end

function UISkillEditPanel.OnShowPositiveSkill(gameobj)
	self.mIsShowActiveSkill = false;
	self:UpdateCoreItems();
	self:UpdateButtons();
end

function UISkillEditPanel.OnConfirmClicked (gameobj)
	local coreArray = {};
	local i = 1;
	for k,v in pairs(self.mDict_CorePassInfo) do
		if v[1] == 1 then
			local core = CS.Cmd.GunSkillCorePosition();
			local posX = v[2] % 6;
			local posY = math.floor(v[2] / 6);
			core.core_id = k;
			core.position = CS.LanString(posX .. ":" .. posY);
			core.rotate = v[4];			
			coreArray[i] = core;
			
			i = i + 1;
		end
		
		if v[1] == 2 then
			MessageBox.Show("注意", "技能重叠或超出边界!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
			return;
		end
	end
	
	self.mNetSkillCoreHandle:SendReqSkillCoreSet(self.mCurGunCode,coreArray,self.SkillCoreSetCallback);
end

function UISkillEditPanel.OnClearClicked (gameobj)
	self = UISkillEditPanel;

	self.mDict_CorePassInfo = {};
	self.mDict_CoreSpaceInfo = {};
	
	local coreBarShape = TableData.GetSkillBarShapeArrayById(self.mBarId);
	local length = coreBarShape.Length;
	for i = 1, length, 1 do
		self.mDict_CoreSpaceInfo[i] = coreBarShape[i-1]; 
	end
	
	local count = self.mCoreItems:Count();
	for i = 1, count, 1 do
		local coreItem = self.mCoreItems[i];
		coreItem:ReturnToList();
	end
	self.mView:ReturnToCache();
end

function UISkillEditPanel.SkillCoreSetCallback (ret)
	if ret == CS.CMDRet.eSuccess then
		gfdebug("技能核心设置成功");
		self.mNetSkillCoreHandle:SendReqSkillCoreCmd();
		MessageBox.Show("成功", "技能核心设置成功", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
    else
		gfdebug("技能核心设置失败");
		MessageBox.Show("失败", "技能核心设置失败", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
	end
end

function UISkillEditPanel:UpdateButtons()
	self.mView:UpdateButton(self.mIsShowActiveSkill);
end

function UISkillEditPanel:UpdateCoreItems()
	local count = self.mCoreItems:Count();
	for i = 1, count, 1 do
		local coreItem = self.mCoreItems[i];
	
		if(self.mIsShowActiveSkill == true and coreItem.mStcData.type == 1) then
			setactive(coreItem.mUIRoot,true);
		end
		if(self.mIsShowActiveSkill == true and coreItem.mStcData.type == 2) then
			setactive(coreItem.mUIRoot,false);
		end
		if(self.mIsShowActiveSkill == false and coreItem.mStcData.type == 1) then
			setactive(coreItem.mUIRoot,false);
		end
		if(self.mIsShowActiveSkill == false and coreItem.mStcData.type == 2) then
			setactive(coreItem.mUIRoot,true);
		end
	end
end

function UISkillEditPanel.UpdateCoreSelection(msg)
	self = UISkillEditPanel;
	local selectCoreItem = msg.Sender;
	local selectedCoreId = msg.Sender.mCoreId;
	local count = self.mCoreItems:Count();
	for i = 1, count, 1 do
		local coreItem = self.mCoreItems[i];
		if coreItem.mCoreId ~= selectedCoreId then
			coreItem:SetSelected(false);
		end
	end
	
	if selectCoreItem.mStcData.type == 2 then
		self.OnShowPositiveSkill(nil);
	else
		self.OnShowActiveSkill(nil);
	end
	
	self.mSelectedItem = selectCoreItem;
	TimerSys:DelayCall(0.1, self.CenterOnSelectedItem, nil);

end

function UISkillEditPanel.DragCoreClicked(msg)
	self = UISkillEditPanel; 
	local index = CS.UICoreDragUtility.GetClickIndex(self.mList_CoreSpaceTrans);
	local coreId = 0; 
	
	for k,v in pairs(self.mDict_CorePassInfo) do
		if(v[2] ~= -1 and CS.UICoreDragUtility.IsIndexOccuppiedByCore(index,v[3],v[4],v[2],self.mList_CoreSpaceTrans)) then
			coreId = k;
		end	
	end
	
	local count = self.mCoreItems:Count();
	for i = 1, count, 1 do
		local coreItem = self.mCoreItems[i];
		if coreItem.mCoreId == coreId then
			if(coreItem.mIsCoreSelected == false) then
				coreItem:SetSelected(true);
				return;
			end
			
			if coreItem.mIsDrag == false then
				coreItem:RotateCore();
				return;
			end
			
		end
	end
end

function UISkillEditPanel.CenterOnSelectedItem()
	self = UISkillEditPanel;
	local target = self.mSelectedItem.mUIRoot.transform;
	local scrollRect = self.mView.mCoresScrollRect;
	local viewPort = self.mView.mCoresScrollRect.transform;
	local content = self.mView.mImage_UI_CoreList.transform;
	
	local normalizedPos = CS.UICoreDragUtility.CenterOnItem(target,scrollRect,viewPort,content);
	DOTween.TweenPosition(self.GetTweenPos, self.SetTweenPos, normalizedPos, FacilityBarrackData.mTweenCameraTime);
end

function UISkillEditPanel.GetTweenPos()
    return self.mView.mCoresScrollRect.normalizedPosition;
end

function UISkillEditPanel.SetTweenPos(position)
    self.mView.mCoresScrollRect.normalizedPosition = position;
end

function UISkillEditPanel:ClearSkillItems()
	self.mView:ClearSkillList();
end

function UISkillEditPanel:ClearData ()
	if self.mDict_CoreSpaceInfo ~= nil then
		self.mDict_CoreSpaceInfo = {};
	end
		
	if self.mList_CoreSpaceTrans ~= nil then
		self.mList_CoreSpaceTrans:Clear();
	end
end

function UISkillEditPanel.OnRelease()   
    self = UISkillEditPanel;
    self:ClearData();
end

function UISkillEditPanel.OnReturnClick(gameobj)
	MessageSys:RemoveListener(11002,self.UpdateCoreSelection);
	MessageSys:RemoveListener(11005,self.SelectCoreByClickIndex);
	--MessageSys:RemoveListener(11006,self.RotateCoreByClickIndex);
	MessageSys:SendMessage(11001,nil);
    UISkillEditPanel.Close();
end

function UISkillEditPanel.Close()
    UIManager.CloseUI(UIDef.UISkillEditPanel);
end









