
require("UI.UIBasePanel")
require("UI.CombatPreparationPanel.UICombatPreparationPanelView")
require("UI.CombatPreparationPanel.UICombatPreparation_EnemyUnitMarkItem")
require("UI.CombatPreparationPanel.UICombatPreparation_GunSlotItem")
require("UI.CombatPreparationPanel.UICombatPreparation_EnemyUnitMarkItem")
require("UI.CombatPreparationPanel.UICombatGunPreparationItem")
require("UI.CombatPreparationPanel.UICombatPreparationSkillItem")
require("UI.CombatPreparationPanel.UICombatStageTaskItem")
require("UI.CombatPreparationPanel.GunModelCtr")
require("UI.CombatPreparationPanel.UIEnemyGrid")
require("UI.CombatPreparationPanel.PreparationNameplate")

UICombatPreparationPanel = class("UICombatPreparationPanel", UIBasePanel);
UICombatPreparationPanel.__index = UICombatPreparationPanel;
local self = UICombatPreparationPanel;

--UI路径

UICombatPreparationPanel.mPath_PreparationNameplate = "Combat/PreparationNameplate.prefab";

UICombatPreparationPanel.mPath_StageTaskItem = "CombatPreparation/UICombatStageTaskItem.prefab";
UICombatPreparationPanel.mPath_SkillItem = "CombatPreparation/UICombatPreparationSkillItem.prefab";
UICombatPreparationPanel.mPath_GunPreparationItem = "CombatPreparation/UICombatGunPreparationItem.prefab";
UICombatPreparationPanel.mPath_EnemyUnitMarkItem = "CombatPreparation/UICombatPreparation_EnemyUnitMarkItem.prefab";
UICombatPreparationPanel.mPath_PlayerUnitMarkItem = "CombatPreparation/UICombatPreparation_PlayerUnitMarkItem.prefab";
UICombatPreparationPanel.mPath_GunSlotItem = "CombatPreparation/UICombatPreparation_GunSlotItem.prefab";
UICombatPreparationPanel.mTransferEffectName = "commonskill_Transfer_01_Down";
UICombatPreparationPanel.mTransferUpEffectName = "commonskill_Transfer_01_Up";
UICombatPreparationPanel.mSwapEmptyEffectName = "Character_Swap_Empty";
UICombatPreparationPanel.mSwapReadyEffectName = "Character_Swap_Ready";
UICombatPreparationPanel.DutyTypeTag = {"Icon/Duty/Combat_GunDuty_1","Icon/Duty/Combat_GunDuty_2","Icon/Duty/Combat_GunDuty_3","Icon/Duty/Combat_GunDuty_4"}
UICombatPreparationPanel.EnemyClass = {"CombatLauncher/Res/CombatPreparation_TypeTag_Member","CombatLauncher/Res/CombatPreparation_TypeTag_Elite","CombatLauncher/Res/CombatPreparation_TypeTag_Boss"}
--UI控件
UICombatPreparationPanel.mView = nil;
UICombatPreparationPanel.mCanvas = nil;
UICombatPreparationPanel.mMainCamera = nil;
--数据
UICombatPreparationPanel.mStageData = nil;
UICombatPreparationPanel.mStageConfig = nil;
UICombatPreparationPanel.mLastCameraPosition = nil;
UICombatPreparationPanel.UnitMarkItems = {};

UICombatPreparationPanel.GunSlotItemPool = {};
UICombatPreparationPanel.Filter = {};
UICombatPreparationPanel.previewIcon = nil;
UICombatPreparationPanel.gunInfoShowing = false;
UICombatPreparationPanel.selectGunData = nil;
UICombatPreparationPanel.OnGridGuns = {};
UICombatPreparationPanel.GunBirthPoints = {};
UICombatPreparationPanel.CameraAdjustCount = 0;
UICombatPreparationPanel.startupTime = 0;
UICombatPreparationPanel.IsNeedCountdown = false;


UICombatPreparationPanel.UIOperationsEnabled = true;
UICombatPreparationPanel.CameraOperationsEnabled = true;
UICombatPreparationPanel.DragingGunCardID = nil;
UICombatPreparationPanel.mEmBattleHelper = nil;

UICombatPreparationPanel.mOldSocre = 0;

UICombatPreparationPanel.mLastGrid = nil;
UICombatPreparationPanel.mSceneScanLine = nil;

UICombatPreparationPanel.mStagePlayersData = nil;

UICombatPreparationPanel.m_InitFinished = false;
UICombatPreparationPanel.m_MyGunHp =nil;

function UICombatPreparationPanel:ctor()
	UICombatPreparationPanel.super.ctor(self);
end

function UICombatPreparationPanel.Open()
	UIManager.OpenUI(UIDef.UICombatPreparationPanel);
end

function UICombatPreparationPanel.Close()
	UIManager.CloseUI(UIDef.UICombatPreparationPanel);
end

function UICombatPreparationPanel.LoadAsset()

	self.EmbattleTokensPrefab = ResSys:GetEmbattleTokensObj("Character_Token");
	self.BaseEnemyPrefab = ResSys:GetEmbattleTokensObj("Base_Enemy");
	self.TokensHeadIconPrefab = ResSys:GetEmbattleTokensObj("PreparationUIRoot");

	self.TransferUpEffectPrefab = ResSys:GetBattleEffect(self.mTransferUpEffectName,false);
	self.TransferEffectPrefab = ResSys:GetBattleEffect(self.mTransferEffectName,false);
	self.SwapEmptyEffectPrefab = ResSys:GetBattleEffect(self.mSwapEmptyEffectName,false);
	self.SwapReadyEffectPrefab = ResSys:GetBattleEffect(self.mSwapReadyEffectName,false);


	self.DutyTypeTagSprites = {};
	for k,v in ipairs(self.DutyTypeTag)do
		self.DutyTypeTagSprites[k] = CS.ResSys.Instance:GetSprite(v);
	end

	self.CharacterHeadSprites = {};
	self.SpritesCache = {};
end

function UICombatPreparationPanel.UnloadAsset()

	ResourceManager:UnloadAsset(self.EmbattleTokensPrefab);
	ResourceManager:UnloadAsset(self.BaseEnemyPrefab);
	ResourceManager:UnloadAsset(self.TokensHeadIconPrefab);


	ResourceManager:UnloadAsset(self.TransferUpEffectPrefab);
	ResourceManager:UnloadAsset(self.TransferEffectPrefab);
	ResourceManager:UnloadAsset(self.SwapEmptyEffectPrefab);
	ResourceManager:UnloadAsset(self.SwapReadyEffectPrefab);


	for k,v in ipairs(self.DutyTypeTag)do
		ResourceManager:UnloadAsset(self.DutyTypeTagSprites[k]);
	end


	for k,v in pairs(self.CharacterHeadSprites)do
		ResourceManager:UnloadAsset(v);
	end
	self.CharacterHeadSprites = {};

	for k,v in pairs(self.SpritesCache)do
		ResourceManager:UnloadAsset(v);
	end
	self.SpritesCache = {};

end

--头像获取
function UICombatPreparationPanel.GetCharacterHeadSprite(code)
	if self.CharacterHeadSprites[code] == nil then
		self.CharacterHeadSprites[code] = ResSys:GetCharacterHeadIcon(code);
	end
	return self.CharacterHeadSprites[code];
end

--图片获取
function UICombatPreparationPanel.GetSprite(fileName)
	if self.SpritesCache[fileName] == nil then
		self.SpritesCache[fileName] = ResSys:GetSprite(fileName);
	end
	return self.SpritesCache[fileName];
end


function UICombatPreparationPanel.Init(root, data)
	self.m_InitFinished = false;
	UICombatPreparationPanel.super.SetRoot(UICombatPreparationPanel, root);
	self.banGunCount = 0;
	self.AssistantGunCount = 0;
	self.UIOperationsEnabled = true;
	self.IsAssistantMode = false;
	self.CameraOperationsEnabled = true;

	self.mEmBattleHelper = data[0];
	self.mStageData = data[1];
	self.mStageRecord = data[2];
	self.mGoalCtr =nil;

	self.mMythicBuffCtr =nil;
	self.mMythicEnchantmentCtr =nil;

	self.isDefense = data[3];
	self.isPvP = self.mStageData.type == 9;

	if not self.isDefense then
		self.mBattleStage = data[4];
	else
		self.mBattleStage = nil;
	end

	if self.isPvP and not self.isDefense then
		self.mPvpFormation = data[5];
	else
		self.mPvpFormation = nil;
	end

	self.GunSlotItemPrefab = UIUtils.GetGizmosPrefab(self.mPath_GunSlotItem,self);
	self.mView = UICombatPreparationPanelView;
	self.mView:InitCtrl(root);
	self.mCanvas = GameObject.Find("Canvas");
	self.mMainCamera = CS.LuaUIUtils.GetCamera(GameObject.Find("MainCamera").transform);
	self.mStageConfig =  TableData.GetStageConfigData(self.mStageData.stage_config);
	self.GunSlotItemPool = {};
	self.CameraAdjustCount = 0;

	self.necessaryGunListCount = 0;
	self.necessaryGunList = {};
	for i =0, self.mStageConfig.necessaryGunList.Length - 1 do
		if self.mStageConfig.necessaryGunList[i] ~= 0 then
			self.necessaryGunList[self.mStageConfig.necessaryGunList[i]] = true;
			self.necessaryGunListCount = self.necessaryGunListCount + 1;
		end
	end

	self.banGunList = {};
	for i =0, self.mStageConfig.banGunList.Length - 1 do
		if self.mStageConfig.banGunList[i] ~= 0 then
			self.banGunList[self.mStageConfig.banGunList[i]] = true;
		end
	end

	self.recommendedGunList = {};
	for i =0, self.mStageConfig.recommendedGunList.Length - 1 do
		if self.mStageConfig.recommendedGunList[i] ~= 0 then
			self.recommendedGunList[self.mStageConfig.recommendedGunList[i]] = true;
		end
	end


	self.LoadAsset();

	local helper =  CS.EmbattleTouchHelper.Instance;
	helper:Init();
	helper.onBeginDrag = self.onWorldBeginDrag;
	helper.onDrag = self.onWorldDrag;
	helper.onEndDrag = self.onWorldEndDrag;
	helper.onCancelDrag = self.onWorldCancelDrag;
	helper.onClick = self.onWorldClick;
	self.EmbattleTouchHelper = helper;
	local cameraController = CS.EmbattleCameraController.Instance;
	--cameraController.onClickGround = self.onClickGround;
	cameraController.onTouchBegin = self.onCameraOperationBegin;
	cameraController.onTouchEnd = self.onCameraOperationEnd;
	--任意点击事件
	MessageSys:AddListener(CS.GF2.Message.UIEvent.UserTapScreen,self.HideSkillDetail);
	--转场动画消息
	MessageSys:AddListener(CS.GF2.Message.UIEvent.StartTransitions,self.OnStartTransitions);
	MessageSys:AddListener(CS.GF2.Message.UIEvent.CameraRotateBtnEnable,self.OnCameraRotateBtnEnable);

	MessageSys:AddListener(CS.GF2.Message.UIEvent.EmbattleCameraRotate,self.OnEmbattleCameraRotate);

	--角色详情
	UIUtils.GetButtonListener(self.mView.mBtn_PlayerUnitInfo_InformationBtn.gameObject).onClick = self.OnInformationBtnClick
	UIUtils.GetButtonListener(self.mView.mBtn_EnemyUnitInfo_InformationBtn.gameObject).onClick = self.OnEnemyInformationBtnClick


	--筛选按钮;
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_BackBtn.gameObject).onClick = self.OnSwitchBtnClick
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_SwitchButton.gameObject).onClick = self.OnSwitchBtnClick

	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_Vanguard.gameObject).onClick = self.OnBtnVanguardClick;
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_Spearhead.gameObject).onClick = self.OnBtnSpearheadClick;
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_Annihilator.gameObject).onClick = self.OnBtnAnnihilatorClick;
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_Specialist.gameObject).onClick = self.OnBtnSpecialistClick;

	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_RankR.gameObject).onClick = self.OnBtnRankRClick;
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_RankSR.gameObject).onClick = self.OnBtnRankSRClick;
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_RankSSR.gameObject).onClick = self.OnBtnRankSSRClick;


	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_Duty1.gameObject).onClick = self.OnBtnElement1Click;
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_Duty2.gameObject).onClick = self.OnBtnElement2Click;
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_Duty3.gameObject).onClick = self.OnBtnElement3Click;
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_Duty4.gameObject).onClick = self.OnBtnElement4Click;
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_Duty5.gameObject).onClick = self.OnBtnElement5Click;
	UIUtils.GetButtonListener(self.mView.mBtn_FilterPanel_Duty6.gameObject).onClick = self.OnBtnElement6Click;

	UIUtils.GetButtonListener(self.mView.mBtn_BattleStart.gameObject).onClick = self.OnBtnBattleStartClick;
	UIUtils.GetButtonListener(self.mView.mBtn_DeployConfirm.gameObject).onClick = self.OnBtnDeployConfirmClick;

	UIUtils.GetListener(self.mView.mBtn_ViewControl_ButtonLeft.gameObject).onDown = self.OnCameraLeftBtnDown;
	UIUtils.GetListener(self.mView.mBtn_ViewControl_ButtonRight.gameObject).onDown = self.OnCameraRightBtnDown;
	UIUtils.GetListener(self.mView.mBtn_ViewControl_ButtonLeft.gameObject).onUp = self.OnCameraLeftBtnUp;
	UIUtils.GetListener(self.mView.mBtn_ViewControl_ButtonRight.gameObject).onUp = self.OnCameraRightBtnUp;

	self.mView.mScrollCircle.OnDragBegin = function(isleft)
		if isleft then
			self.OnCameraLeftBtnDown();
		else
			self.OnCameraRightBtnDown();
		end
	end

	self.mView.mScrollCircle.OnDragEnd = function(isleft)
		if isleft then
			self.OnCameraLeftBtnUp();
		else
			self.OnCameraRightBtnUp();
		end
		self.SetUIOperationsEnabled(false);
	end

	self.mView.mScrollCircle.OnPressDown = function()
		self.SetUIOperationsEnabled(false);
	end

	self.mView.mScrollCircle.OnPressUp = function()
		self.SetUIOperationsEnabled(true);
	end

	self.DutyFilter = 0;
	self.RankFilter = 0;
	self.ElementFilter = 0;

	setactive(self.mView.mTrans_PlayerUnitInfo.gameObject, false);

	--临时退出游戏按钮
	UIUtils.GetButtonListener(self.mView.mBtn_FakeButton.gameObject).onClick = self.OnExitBattleClick;

	self.mView.mToggle_RepeatSweep.onValueChanged:AddListener(self.OnSetAutoBattleMode);
	self.mView.mToggle_FriendHelp.onValueChanged:AddListener(self.OnFriendHelpClick);


	self.mAssistantUIDMap = {};
	self.mAssistantGunMap = {};

	self.AssistantCostItemID = TableData.GlobalSystemData.CommissionTimesArgs[0];
	self.AssistantCostItemCount = TableData.GlobalSystemData.CommissionTimesArgs[1];

	local AssistantAvailableStagetype = TableData.GlobalSystemData.AssistantAvailableStagetype;
	self.AssistantAvailable = false;
	for i = 0,AssistantAvailableStagetype.Count - 1 do
		if self.mStageData.type == AssistantAvailableStagetype[i] then
			self.AssistantAvailable = true;
		end
	end

	MessageSys:AddListener(CS.GF2.Message.UIEvent.AssistantSingleGun,self.StageUsableGunCmdCallBack);
	if self.AssistantAvailable then
		MessageSys:AddListener(CS.GF2.Message.UIEvent.AssistantRespond,self.OnAssistantRespond);

		PlayerNetCmdHandler:RequestAssistantRandom();
		setactive(self.mView.mToggle_FriendHelp.gameObject, true);
		self.mView.mText_AssistantCost.text = self.AssistantCostItemCount;
	else
		setactive(self.mView.mToggle_FriendHelp.gameObject, false);
		--[[setactive(self.mView.mTrans_BtnBGImage.gameObject, false);--]]
	end

	--虚拟列表优化体验
	local virtualList = UIUtils.GetVirtualList(self.mView.mTrans_GunSlot);
	virtualList.itemProvider = self.GunItemProvider;
	virtualList.itemRenderer = self.GunItemRenderer;
	self.mVirtualList = virtualList;

	--防止预设关闭相机按钮，进界面就打开
	self.SetCameraOperationsEnabled(true);
end

--初始化面板
function UICombatPreparationPanel.OnInit()
	gfdebug("UICombatPreparationPanel.OnInit()");
	self.mLastCameraPosition = self.mMainCamera.transform.position;
	self.mLastCameraOrthographicSize = self.mMainCamera.orthographicSize;
	self.startupTime = CS.UnityEngine.Time.realtimeSinceStartup;
	self.IsNeedCountdown = TableData.listStagePreparationCountdownDatas:GetDataById(self.mStageData.Type).preparation_countdown > 0;
	--self.UnitMarkItems = {};
	self.skillCtrls = {};
	self.enemyInfos = {};
	self.enemyRoles = {};

	self.lineUpGuns = {};

	self.lineUpGunList = {};

	self.OnGridGuns = {};
	self.StageTaskItems = {};
	self.GunBirthPoints = {};
	self.last_selected_lineUpGun = nil;
	self.last_selected_gunCard = nil;
	local gun_birth_points_str = self.isDefense and self.mStageConfig.defend_birth_points or self.mStageConfig.gun_birth_points;
	local gun_birth_points = string.split(gun_birth_points_str,"|");
	for _,point in ipairs(gun_birth_points) do
		local data = string.split(point,":");
		local grid_id = tonumber(data[1]);
		table.insert(self.GunBirthPoints,grid_id);
	end

	self.PvpEnemyGunMap = {};

	self.lineUpCount = 0;

	self.C2SStageUsableGunsCmd(self.mStageData.id)

	setactive(self.mView.mBtn_BattleStart.gameObject, not self.isDefense);
	setactive(self.mView.mBtn_DeployConfirm.gameObject,  self.isDefense);
	setactive(self.mView.mToggle_RepeatSweep.gameObject,not  self.isDefense and not self.isPvP );
	self.EnemyHpBars = {};

	local nameplatePrefab = UIUtils.GetGizmosPrefab(self.mPath_PreparationNameplate,self);
	local size = GlobalData.slg_preparation_icon_size;
	self.slg_preparation_icon_Scale = Vector3(size,size,size);
	if not self.isDefense then
		--创建敌人图标
		if self.isPvP then
			local _defend_birth_points = self.mStageConfig.defend_birth_points;
			local defend_birth_points = string.split(_defend_birth_points,"|");
			local  DefendGunBirthPoints = {};
			for _,point in ipairs(defend_birth_points) do
				local data = string.split(point,":");
				local grid_id = tonumber(data[1]);
				local r = string.split(data[2],",");
				table.insert(DefendGunBirthPoints,{grid_id = grid_id,angle = tonumber(r[2])});
			end

			for idx = 0,self.mPvpFormation.Count - 1 do
				local fullGun = self.mPvpFormation[idx];
				local grid_id = tonumber(DefendGunBirthPoints[idx + 1].grid_id);
				local grid = CS.GridManager.Instance:GetGridByID(grid_id);
				local gundata = TableData.GetGunData(fullGun.id);
				local role_template = TableData.GetRoleTemplateData(gundata.role_template_id);
				local MCfg = TableData.GetGunModelData(role_template.model_code);
				local modelObj = CS.SceneObjManager.Instance:GetRoleModelInstance(MCfg);
				setlayer(modelObj,GFUtils.EnemyLayer,true);
				modelObj.transform.position = grid.pos;
				modelObj.transform.rotation = CS.UnityEngine.Quaternion.Euler(0,DefendGunBirthPoints[idx + 1].angle,0);
				self.enemyInfos[tonumber(grid_id)] = self.CreatEnemyEffect(0,tonumber(grid_id),grid.pos,1);
				table.insert(self.enemyRoles,{cfg = MCfg,obj = modelObj});

				self.AddHpBar(nameplatePrefab,gundata.duty,gundata.element,grid.pos);
				self.PvpEnemyGunMap[grid_id] = fullGun;
			end
		else
			--print(self.mStageConfig.initial_enemies)
			for idx = 0,self.mStageConfig.initialEnemyCell.Length - 1 do
				local enemy_info_cell = self.mStageConfig.initialEnemyCell[idx];
				local grid_id = enemy_info_cell.gridId;
				local enemy_id = enemy_info_cell.enemyId;
				local direction = enemy_info_cell.direction;
				local element_id = enemy_info_cell.elementId;
				local grid = CS.GridManager.Instance:GetGridByID(tonumber(grid_id));
				local enemyData = TableData.GetEnemyData(enemy_id);
				local MCfg = TableData.GetGunModelData(enemyData.model_code);
				local modelObj = CS.SceneObjManager.Instance:GetRoleModelInstance(MCfg);
				modelObj.transform.position = grid.pos;
				setlayer(modelObj,GFUtils.EnemyLayer,true);
				modelObj.transform.rotation = CS.UnityEngine.Quaternion.Euler(0,direction.y,0);
				self.enemyInfos[tonumber(grid_id)] = self.CreatEnemyEffect(enemy_id,tonumber(grid_id),grid.pos,enemyData.occupy_size);
				table.insert(self.enemyRoles,{cfg = MCfg,obj = modelObj});
				self.AddHpBar(nameplatePrefab,enemyData.duty,element_id,grid.pos,enemyData.rank);
			end
		end
	end
	gfdebug("UICombatPreparationPanel.OnInit() create preview icon");


	gfdebug("UICombatPreparationPanel.UpdateGunList");
	--创建人形列表

	gfdebug("UICombatPreparationPanel.UpdateIconPosition");

	--挂机
	if(AFKBattleManager.IsInAutoMode) then
		AFKBattleManager:OpenAutoPanel();
	end

	if(AFKBattleManager:CheckCanAuto(self.mStageData)) then
		setactive(self.mView.mTrans_Lock.gameObject,false);
	else
		setactive(self.mView.mTrans_Lock.gameObject,true);
	end
	--战场扫描

	self.mSceneScanLine = CS.SceneScan.GetSceneScanLine();
	UIUtils.GetButtonListener(self.mView.BattleScanBtn.gameObject).onClick = self.OnBattleScanClick;
	self.SwitchBattleScanState(false);

	self.m_InitFinished = true;
	self.OnUpdate();
end
------------------------------------------预部署镜像数据修改-------------------------
--刷新阵型
function UICombatPreparationPanel.UpdateFormation()

	local lineUpGunsData;
	if self.isDefense then
		lineUpGunsData = NetCmdPvPData.DefendLineup;
		self.lineUpLimit = self.mStageConfig.defend_gun_limit;
	else
		self.mStagePlayersData = NetCmdTeamData:GetStagePlayersDataByType(self.mStageData.type);
		if self.mStagePlayersData ~= nil and self.mStagePlayersData.lineUp ~= nil then
			lineUpGunsData = self.mStagePlayersData.lineUp;
		end
		self.lineUpLimit = self.mStageConfig.gun_limit;
	end

	local lineUpGunsTableLength = 0;--阵型数据长度
	local lineUpGunsTable = {};--裁剪后的阵型数据
	local GunBirthPointCount = #self.GunBirthPoints;--本关出生点位数
	local realLineUpGunsCount = 0;--真实有效的单位数
	--按出生点位数裁剪阵型数据
	if lineUpGunsData ~= nil then
		for i = 0, lineUpGunsData.Length - 1 do
			if i < GunBirthPointCount then
				lineUpGunsTable[i] = lineUpGunsData[i];
				lineUpGunsTableLength = lineUpGunsTableLength + 1;
				if lineUpGunsTable[i] > 0 then
					realLineUpGunsCount = realLineUpGunsCount + 1;
				end
			end
		end
	end

	--计算未上阵的强制单位
	local necessaryGunsTable = {};
	local necessaryGunsTableLength = 0;
	for i =0, self.mStageConfig.necessaryGunList.Length - 1 do
		if self.mStageConfig.necessaryGunList[i] > 0 then
			local flag = true;
			if lineUpGunsTableLength > 0 then
				for n = 0,lineUpGunsTableLength - 1 do
					if lineUpGunsTable[n] == self.mStageConfig.necessaryGunList[i] then
						flag = false;
						break;
					end
				end
			end
			if flag then
				necessaryGunsTable[necessaryGunsTableLength] = self.mStageConfig.necessaryGunList[i];
				necessaryGunsTableLength = necessaryGunsTableLength + 1;
			end
		end
	end



	--将未上阵的强制单位塞进阵容，人数未满优先空位，否则替换不强制单位
	for i = 0,necessaryGunsTableLength - 1 do
		if realLineUpGunsCount < self.lineUpLimit then
			local flag = false;
			local necessaryGunsIndex = 0;
			for i = 0,lineUpGunsTableLength - 1 do
				if lineUpGunsTable[i] == 0 then
					flag = true;
					necessaryGunsIndex = i;
					break;
				end
			end
			if not flag then
				necessaryGunsIndex = lineUpGunsTableLength;
				lineUpGunsTableLength = lineUpGunsTableLength + 1;
			end
			lineUpGunsTable[necessaryGunsIndex] = necessaryGunsTable[i];
			realLineUpGunsCount = realLineUpGunsCount + 1;
		else
			for i = 0,lineUpGunsTableLength - 1 do
				if lineUpGunsTable[i] ~= nil and lineUpGunsTable[i] > 0 and not self.necessaryGunList[lineUpGunsTable[i]] then
					lineUpGunsTable[i] = necessaryGunsTable[i];
					break;
				end
			end
		end
	end

	lineUpGunsData = nil;

	--创建预览图标
	local instObj = instantiate(self.EmbattleTokensPrefab);
	local ctr = GunModelCtr.New();
	ctr:InitCtrl(instObj,self.TokensHeadIconPrefab,self.mView.mTrans_HpBarRoot.transform);
	ctr:SetSelected(true);
	instObj.transform.localScale = Vector3.one;
	self.previewIcon = ctr;
	ctr:SetVisible(false);
	gfdebug("UICombatPreparationPanel.OnInit() create preview icon");

	--已上阵列表
	self.lineUpGunList = {};
	self.lineUpGunIDList = {};
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_GunPreparationItem,self);
	for i = 1,self.lineUpLimit do
		local instObj = instantiate(itemPrefab);
		local ctr = UICombatGunPreparationItem.New();
		ctr:InitCtrl(instObj.transform);
		UIUtils.AddListItem(instObj,self.mView.mTrans_PreparationGunSlot_PreparationListLayout.transform);
		table.insert(self.lineUpGunList,ctr);
	end

	--创建上阵人形图标
	gfdebug("UICombatPreparationPanel.OnInit() create gun");
	self.lineUpCount = 0;
	for i = 0, lineUpGunsTableLength - 1 do
		if self.GunBirthPoints[i + 1] ~= nil and lineUpGunsTable[i] ~= nil and lineUpGunsTable[i] > 0 then
			if self.lineUpCount < self.lineUpLimit and self.GetRoleHpByGunId(lineUpGunsTable[i]) ~= 0 then

				local instObj = instantiate(self.EmbattleTokensPrefab);
				local ctr = GunModelCtr.New();
				ctr:InitCtrl(instObj, self.TokensHeadIconPrefab, self.mView.mTrans_HpBarRoot.transform);
				ctr:InitData(lineUpGunsTable[i], self.GunBirthPoints[i + 1], 0, self.mStageData.type);
				instObj.transform.localScale = Vector3.one;
				self.lineUpGuns[ctr.grid_id] = ctr;
				self.lineUpCount = self.lineUpCount + 1;
				table.insert(self.lineUpGunIDList, lineUpGunsTable[i]);
			end
		end
	end

end

-- 单个gun 数据
function UICombatPreparationPanel.StageUsableGunCmdCallBack(msg)
	local informationPanel = CS.LuaUtils.EnumToInt(CS.GF2.UI.enumUIPanel.UICombatUnitInformationPanelNew);
	if msg.Content ~= nil then
		self.selectGunData = msg.Content;
		UIManager.OpenUIByParam(informationPanel, self.selectGunData);
	else
		print("StageUsableGunCmdCallBack ")
	end
end

-----------------------------------消息---------------------------------------------
-- 请求当前玩家数据
function UICombatPreparationPanel.C2SStageUsableGunsCmd(stageId)
	PlayerNetCmdHandler:C2SStageUsableGunsCmd(stageId,self.S2CStageUsableGunsCmdOnCallBack)
end


function UICombatPreparationPanel.S2CStageUsableGunsCmdOnCallBack()
	self.m_MyGunHp = {};
	local playerHps = NetCmdSimulateBattleData:GetStagePlayerHpsByType(self.mStageData.type)
	if playerHps ~= nil and playerHps.Count > 0 then
		for k, v in pairs(playerHps) do
			local curRoleHp = { gunId = k, hp = v };
			table.insert(self.m_MyGunHp, curRoleHp)
		end
	end
	self.UpdateFormation();
	self.UpdateGunList();
end



-------------------------------------------------------------------------------------

function UICombatPreparationPanel.GetRoleHpByGunId(gunId)
    local value = 0;
    local gunData = NetCmdTeamData:GetMyGun(self.mStageData.type,gunId)
    if gunData ~= nil then
        value = gunData.max_hp;
    end
	
	for k, v in pairs(self.m_MyGunHp) do
		if v.gunId == gunId then
			value = v.hp;
			break;
		end
	end
	return value;
end

function UICombatPreparationPanel.OnBattleScanClick()
	self.SwitchBattleScanState(self.mSceneScanLine~=nil and not self.mSceneScanLine:IsActive());
end

function UICombatPreparationPanel.SwitchBattleScanState(active)
	local finalState = CS.SceneScan.SwitchBattleScanState(self.mSceneScanLine,active);
	setactive(self.mView.BattleScanBtnOn.gameObject,not finalState);
	setactive(self.mView.BattleScanBtnOff.gameObject,finalState)
	setactive(self.mView.BattleScanInfoPlane.gameObject,finalState)
end

--虚拟列表子物体创建
function UICombatPreparationPanel.GunItemProvider()
	local instObj = instantiate(self.GunSlotItemPrefab);
	local item = UICombatPreparation_GunSlotItem.New();
	item:InitCtrl(instObj.transform);

	local renderDataItem = CS.RenderDataItem();
	renderDataItem.renderItem = instObj;
	renderDataItem.data = item;
	table.insert(self.GunSlotItemPool,item);
	return renderDataItem;
end

--虚拟列表子物体赋值
function UICombatPreparationPanel.GunItemRenderer(index,renderDataItem)
	local gunData = self.mShowingGunList[index + 1];
	local item = renderDataItem.data;
	item:InitData(gunData.data,gunData.necessary,gunData.recommended,gunData.userData,self.mStageData.type);
end

--敌人血条创建
function UICombatPreparationPanel.AddHpBar(nameplatePrefab,duty,element,pos,rank)
	local instObj = instantiate(nameplatePrefab);
	local ctr = PreparationNameplate.New();
	ctr:InitCtrl(instObj.transform);
	ctr:InitData(duty,element,pos + Vector3(0,1.5,0),rank);
	UIUtils.AddListItem(instObj,self.mView.mTrans_HpBarRoot.transform);
	table.insert(self.EnemyHpBars,ctr);
end


function UICombatPreparationPanel.InsertGunData(GunList,gunData,userData)
	if self.banGunList[gunData.id] == true then
		self.banGunCount = self.banGunCount + 1;

		self.DutyFilter = 0;
		self.RankFilter = 0;
		self.ElementFilter = 0;
	elseif (self.DutyFilter == 0 or self.DutyFilter == gunData.TabGunData.duty) and (self.RankFilter == 0 or self.RankFilter == gunData.TabGunData.rank) and ( self.ElementFilter == 0 or self.ElementFilter == gunData.TabGunData.element)then
		local isOnGrid = false;
		local uid =  0;
		if userData ~= nil then
			uid = userData.Uid;
		end
		for _,ctr in pairs(self.lineUpGuns) do
			print("InsertGunData " .. uid .." ctr.uid = "..ctr.uid);
			if ctr.gun_id == gunData.id and ctr.uid == uid then
				isOnGrid = true;
				break;
			end
		end
		if not isOnGrid then
			local necessary = self.necessaryGunList[gunData.id] == true;
			local recommended = self.recommendedGunList[gunData.id] == true;
			local score = gunData.battle_power;
			table.insert(GunList,{ data = gunData,score = score,necessary = necessary,recommended = recommended,userData = userData});
		end
	end
end

function UICombatPreparationPanel.BuildGunList(GunList, AssistantGunList, originGunList)
	for k, v in pairs(originGunList) do
		local curGun = v;
		if curGun.uid ~= nil and curGun.uid > 0 then
			-- 助战
			local simpleGunData = NetCmdTeamData:GetAssistant(self.mStageData.type, curGun.uid, curGun.id);
			if simpleGunData ~= nil then
				local userdata = { Uid = simpleGunData.uid, Name = simpleGunData.name }
				self.InsertGunData(AssistantGunList, simpleGunData, userdata);
			end
		else

			--自己的人形
			local gunData = NetCmdTeamData:GetMyGun(self.mStageData.type,curGun.id)
			if gunData ~= nil then
				self.InsertGunData(GunList, gunData);
			end

		end
	end
end

--更新人形列表
function UICombatPreparationPanel.UpdateGunList(animation,gun_id)
	--经过筛选排序
	local GunList = {};
	self.banGunCount = 0;
	local AssistantGunList = {};

	if self.mStagePlayersData~=nil and self.mStagePlayersData.otherGun.Count > 0 then
		local otherGun = self.mStagePlayersData.otherGun;
		self.BuildGunList(GunList,AssistantGunList,otherGun);
	else
		print("NetCmdTeamData.GunCount == 0 ???!!!")
	end

	if self.mStagePlayersData~=nil and self.mStagePlayersData.lineUpGuns ~= nil then
		local lineUpGuns = self.mStagePlayersData.lineUpGuns;
		self.BuildGunList(GunList,AssistantGunList,lineUpGuns);
	end

	local function testSort(a,b)
		local v_a = self.necessaryGunList[a.data.id] == true and 10 or 0;
		v_a = v_a + (self.recommendedGunList[a.data.id] == true and 1 or 0);

		local v_b = self.necessaryGunList[b.data.id] == true and 10 or 0;
		v_b = v_b + (self.recommendedGunList[b.data.id] == true and 1 or 0);

		if v_a == v_b then
			if a.score == b.score then
				if tonumber(a.data.level) == tonumber(b.data.level) then
					return tonumber(a.data.id)< tonumber(b.data.id)
				else
					return tonumber(a.data.level)> tonumber(b.data.level)
				end
			else
				return a.score > b.score;
			end
		else
			return v_a > v_b;
		end
	end
	table.sort(GunList,testSort);
	table.sort(AssistantGunList,testSort);

	self.mShowingGunList = self.IsAssistantMode and AssistantGunList or GunList;
	self.UpdateGumNum();
	setactive(self.mView.mTrans_NoGunBG.gameObject,#self.mShowingGunList == 0);

	self.mVirtualList.numItems = #self.mShowingGunList;
	self.mVirtualList:Refresh();
	if animation then
		self.mVirtualList.normalizedPosition = Vector2.zero;
	end
	self.UpdateStageTaskList();
end

--释放资源
function UICombatPreparationPanel.OnRelease()
	self.UnloadAsset();
	self.m_InitFinished = false;
	self.EmbattleTokensPrefab = nil;
	self.TokensHeadIconPrefab = nil;
	self.TransferEffectPrefab = nil;
	self.TransferUpEffectPrefab = nil;
	self.SwapEmptyEffectPrefab = nil;
	self.SwapReadyEffectPrefab = nil;
	self.BaseEnemyPrefab = nil;
	self.selecteEnemyData = nil;
	self.mGoalCtr = nil;
	self.mMythicBuffCtr = nil;
	self.mMythicEnchantmentCtr = nil;
	self.mStagePlayersData = nil;
	self.last_selected_lineUpGun = nil;
	self.last_selected_gunCard = nil;
	self.m_MyGunHp = nil;
	if self.SwapEmptyEffect ~= nil then
		gfdestroy(self.SwapEmptyEffect);
		self.SwapEmptyEffect = nil;
	end
	if self.SwapReadyEffect ~= nil then
		gfdestroy(self.SwapReadyEffect);
		self.SwapReadyEffect = nil;
	end
	CS.EmbattleTouchHelper.Instance:Uninit();
	self.EmbattleTouchHelper = nil;
	self.RecycleEnemyModel();

	--移除预览模型
	self.previewIcon:OnDestroy();
	self.previewIcon =nil;

	for grid_id,model in pairs(self.lineUpGuns)do
		model:OnDestroy();
	end
	self.lineUpGuns = {};

	for i,ctr in pairs(self.EnemyHpBars) do
		gfdestroy(ctr.gameObject);
	end

	for _,ctr in pairs(self.enemyInfos)do
		gfdestroy(ctr.gameObject);
	end
	self.enemyInfos = {};
	MessageSys:RemoveListener(CS.GF2.Message.UIEvent.UserTapScreen,self.HideSkillDetail);
	MessageSys:RemoveListener(CS.GF2.Message.UIEvent.StartTransitions,self.OnStartTransitions);
	MessageSys:RemoveListener(CS.GF2.Message.UIEvent.CameraRotateBtnEnable,self.OnCameraRotateBtnEnable);
	MessageSys:RemoveListener(CS.GF2.Message.UIEvent.EmbattleCameraRotate,self.OnEmbattleCameraRotate);

	if self.AssistantAvailable then
		MessageSys:RemoveListener(CS.GF2.Message.UIEvent.AssistantRespond,self.OnAssistantRespond);
	end
	MessageSys:RemoveListener(CS.GF2.Message.UIEvent.AssistantSingleGun,self.StageUsableGunCmdCallBack);
	local cameraController = CS.EmbattleCameraController.Instance;
	if cameraController ~= nil then
		cameraController.onClickGround = nil;
		cameraController.onTouchBegin = nil
		cameraController.onTouchEnd = nil;
	end
end

--回收敌人模型
function UICombatPreparationPanel.RecycleEnemyModel()
	for _,data in ipairs(self.enemyRoles) do
		CS.SceneObjManager.Instance:RecycleRoleModelInstance(data.cfg,data.obj);
	end
	self.enemyRoles = {};
end



--面板每帧更新血条位置 信标头像更新
function UICombatPreparationPanel.OnUpdate()
	local CameraPos = self.mMainCamera.transform.position;
	for i,ctr in pairs(self.EnemyHpBars) do
		ctr:UpdatePosition();
		ctr:UpdateScale(CameraPos)
	end
	for _,item in pairs(self.lineUpGuns)do
		item:UpdateHeadPosition(CameraPos);
	end
	if self.previewIcon~=nil then
		self.previewIcon:UpdateHeadPosition(CameraPos);
	end
	self.CheckCountDown();
end

function UICombatPreparationPanel.CheckCountDown()
	setactive(self.mView.mTrans_TimeCountDown,self.IsNeedCountdown);
	if(self.IsNeedCountdown~= true) then return end
	local countDown = TableData.listStagePreparationCountdownDatas:GetDataById(self.mStageData.Type).preparation_countdown;
	local timeLeft = countDown - (CS.UnityEngine.Time.realtimeSinceStartup - self.startupTime);
	if (timeLeft <= 0) then
		UISystem:ClearAllUIStacks();
		self.Close()
		SceneSys:OpenSceneByName("CommandCenter")
	else
		minutes = CS.UnityEngine.Mathf.FloorToInt(timeLeft / 60);
		seconds = CS.UnityEngine.Mathf.FloorToInt(timeLeft % 60);
		self.mView.mText_TimeCountDown.text = string.format("%02d:%02d", minutes, seconds);
	end
end

--创建敌人特效
function UICombatPreparationPanel.CreatEnemyEffect(enemy_id,grid_id,pos,occupy_size)


	--local occupyGrids = CS.GridUtils.LuaGetOccupyGridsId(grid_id, enemyData.occupy_size);

	local instObj = instantiate(self.BaseEnemyPrefab);
	local ctr = UIEnemyGrid.New();
	ctr:InitCtrl(instObj);
	ctr:InitData(enemy_id,grid_id,pos,occupy_size);

	--for i = 1, occupyGrids.Count do
	--if(occupyGrids[i - 1] ~= grid_id) then
	--local grid = CS.GridUtils._GetGridByGridID(occupyGrids[i - 1])
	--local instObj = instantiate(self.BaseEnemyPrefab);
	--local ctr = UIEnemyGrid.New();
	--ctr:InitCtrl(instObj);
	--ctr:InitData(enemy_id,occupyGrids[i - 1],grid.pos);
	--end
	--end

	return ctr;
end

--播放场景指代物传送特效
function UICombatPreparationPanel.playTransferEffect(pos,duration)
	local instObj = instantiate(self.TransferEffectPrefab);
	self.mEmBattleHelper:PlayGridBorderAnimator(pos);
	instObj.transform.localScale = Vector3.one;
	instObj.transform.position = pos;
	if duration == nil then
		duration = 3;
	end
	gf_delay_destroy(instObj,duration);
end

--播放消失特效
function UICombatPreparationPanel.playTransferUpEffect(pos,duration)
	local instObj = instantiate(self.TransferUpEffectPrefab);
	instObj.transform.localScale = Vector3.one;
	instObj.transform.position = pos;
	if duration == nil then
		duration = 3;
	end
	gf_delay_destroy(instObj,duration);
end


--顶部上阵列表点击
function UICombatPreparationPanel.OnTopLineUpGunClicked(gun_id)
	if not self.m_InitFinished then
		return;
	end
	if self.DragingGunCardID == nil and self.DragingGunModel == nil then--拖动卡牌中不响应
		for k,ctr in pairs(self.lineUpGuns) do
			if ctr.gun_id == gun_id then
				CS.EmbattleCameraController.Instance:MoveToGrid(ctr.grid_id);
				self.last_selected_lineUpGun = ctr;
				break;
			end
		end
		self.selectLineUpGun(self.last_selected_lineUpGun.grid_id);
		self.ShowGunInfo(self.last_selected_lineUpGun.data);
		self.selectGunCard();
		self.last_selected_gunCard = nil
		CS.GF2.Audio.AudioUtils.PlayByID(5900001);
	end
end

--顶部显示上阵列表移除
function UICombatPreparationPanel.TopLineUpGunListRemove(gun_id)
	for k,id in ipairs(self.lineUpGunIDList)do
		if id == gun_id then
			table.remove(self.lineUpGunIDList,k);
			break;
		end
	end
end


function UICombatPreparationPanel.AssistantHasLineUp()
	for _,item in pairs(self.lineUpGuns)do
		print("item.uid = " .. tostring(item.uid));
		if item.uid ~= nil and item.uid ~= 0 then
			--已经有好友人形了
			return true;
		end
	end
	return false;
end

function UICombatPreparationPanel.GunHasLineUp(gun_id)
	for _,ctr in pairs(self.lineUpGuns)do
		if ctr.gun_id == gun_id then
			--已经上过该人形
			return true;
		end
	end
	return false;
end

--顶部显示上阵列表增加
function UICombatPreparationPanel.TopLineUpGunListAdd(gun_id)
	print("TopLineUpGunListAdd " ..gun_id )
	table.insert(self.lineUpGunIDList,gun_id);
end

--玩家点击场景元素
function UICombatPreparationPanel.onWorldBeginDrag(grid,world_pos)
	if not self.m_InitFinished then
		return;
	end
	if self.UIOperationsEnabled then
		self.last_pre_swap_grid_id = 0;
		self.DragingGunModel = self.lineUpGuns[grid.ID];
		local res =  self.DragingGunModel  ~= nil ;
		if res then
			CS.GF2.Audio.AudioUtils.PlayByID(5900001);
			self.SetCameraOperationsEnabled(false);
			self.SetUIOperationsEnabled(false);
		end
		--res = res or self.enemyInfos[grid.ID] ~= nil or self.isBirthPoint(grid.ID);
		return res;
	else
		return false;
	end
end

--玩家开始拖动场景元素
function UICombatPreparationPanel.onWorldDrag(grid,world_pos)
	if not self.m_InitFinished then
		return;
	end
	if self.DragingGunModel  ~= nil then
		local position = grid.pos;
		position.y = position.y + 0.1;
		world_pos.y = position.y;
		self.DragingGunModel:SetPosition(world_pos,position);
		--self.DragingGunModel.gameObject.transform.position = position;

		if self.last_selected_lineUpGun == nil or self.DragingGunModel.grid_id ~= self.last_selected_lineUpGun.grid_id then
			--选中拖动中的模型
			self.last_selected_lineUpGun = self.DragingGunModel;
			self.selectLineUpGun(self.DragingGunModel.grid_id);
			self.ShowGunInfo(self.DragingGunModel.data);
			--取消卡片选中
			self.last_selected_gunCard = nil
			self.selectGunCard();
		end

		if self.last_pre_swap_grid_id ~= grid.ID and self.lineUpGuns[self.last_pre_swap_grid_id] ~= nil then
			--上一次临时交换的模型归位
			setactive(self.lineUpGuns[self.last_pre_swap_grid_id].gameObject,true);
			self.last_pre_swap_grid_id = 0;
		end
		if self.lineUpGuns[grid.ID] ~= nil and self.last_pre_swap_grid_id ~= grid.ID  and grid.ID ~= self.DragingGunModel.grid_id then
			--模型叠加，临时交换位置
			if self.lineUpGuns[self.last_pre_swap_grid_id] ~= nil then
				setactive(self.lineUpGuns[self.last_pre_swap_grid_id].gameObject,true);
			end
			self.last_pre_swap_grid_id = grid.ID;
			setactive(self.lineUpGuns[grid.ID].gameObject,false);
		end
		if self.lineUpGuns[grid.ID] ~= nil then
			if self.SwapReadyEffect == nil then
				self.SwapReadyEffect = instantiate(self.SwapReadyEffectPrefab);
				self.SwapReadyEffect.transform.localScale = Vector3.one;
			end
			local grid = CS.GridManager.Instance:GetGridByID(self.DragingGunModel.grid_id);
			self.SwapReadyEffect.transform.position = grid.pos;
			setactive(self.SwapReadyEffect,true);
		else
			if self.SwapReadyEffect ~= nil then
				setactive(self.SwapReadyEffect,false);
			end
		end
		if self.SwapEmptyEffect == nil then
			self.SwapEmptyEffect = instantiate(self.SwapEmptyEffectPrefab);
			self.SwapEmptyEffect.transform.localScale = Vector3.one;
		end
		local grid = CS.GridManager.Instance:GetGridByID(self.DragingGunModel.grid_id);
		self.SwapEmptyEffect.transform.position = grid.pos;
		setactive(self.SwapEmptyEffect,true);
	end
end

--玩家取消场景拖动操作
function UICombatPreparationPanel.onWorldCancelDrag()
	if not self.m_InitFinished then
		return;
	end
	self.SetCameraOperationsEnabled(true);
	self.SetUIOperationsEnabled(true);

	if self.DragingGunModel  ~= nil then
		CS.GF2.Audio.AudioUtils.PlayByID(5900001);
		if self.SwapEmptyEffect ~= nil then
			setactive(self.SwapEmptyEffect,false);
		end
		if self.SwapReadyEffect ~= nil then
			setactive(self.SwapReadyEffect,false);
		end
		if self.lineUpGuns[self.last_pre_swap_grid_id] ~= nil then
			--上一次临时交换的模型归位
			setactive(self.lineUpGuns[self.last_pre_swap_grid_id].gameObject,true);
			self.last_pre_swap_grid_id = 0;
		end
		self.DragingGunModel:InitGrid(self.DragingGunModel.grid_id);
		self.HideGunInfo();
	end
end

--玩家结束拖动场景元素
function UICombatPreparationPanel.onWorldEndDrag(grid,world_pos)
	if not self.m_InitFinished then
		return;
	end
	self.SetCameraOperationsEnabled(true);
	self.SetUIOperationsEnabled(true);
	if self.DragingGunModel  ~= nil then
		CS.GF2.Audio.AudioUtils.PlayByID(5900001);
		if self.SwapEmptyEffect ~= nil then
			setactive(self.SwapEmptyEffect,false);
		end
		if self.SwapReadyEffect ~= nil then
			setactive(self.SwapReadyEffect,false);
		end
		if self.lineUpGuns[self.last_pre_swap_grid_id] ~= nil then
			--上一次临时交换的模型归位
			setactive(self.lineUpGuns[self.last_pre_swap_grid_id].gameObject,true);
			self.last_pre_swap_grid_id = 0;
		end

		if self.lineUpGuns[grid.ID] ~= nil then
			--交换人形
			if not self.swapPositions(grid.ID) then
				self.last_selected_lineUpGun:InitGrid(self.last_selected_lineUpGun.grid_id);
			end
			self.last_selected_lineUpGun = nil;
			self.selectLineUpGun(0);
		elseif self.isBirthPoint(grid.ID) then
			--改变位置
			self.movePositions(grid.ID);
		else
			--下阵
			self.TopLineUpGunListRemove(self.DragingGunModel.gun_id);
			self.DragingGunModel:OnDestroy();
			self.lineUpGuns[self.DragingGunModel.grid_id] = nil;
			self.DragingGunModel = nil;

			self.last_selected_lineUpGun = nil;
			self.selectLineUpGun(0);
			self.lineUpCount = self.lineUpCount - 1;
			self.UpdateGunList();
		end

		self.HideGunInfo();
	end
	self.DragingGunModel = nil;
end

--玩家点击场景元素
function UICombatPreparationPanel.onWorldClick(grid,world_pos)
	if not self.m_InitFinished then
		return;
	end
	self.SetCameraOperationsEnabled(true);
	self.SetUIOperationsEnabled(true);
	print("onWorldClick 1");
	if self.enemyInfos[grid.ID] ~= nil then
		print("onWorldClick 2");
		--点击敌人显示详情，取消人形选中
		self.last_selected_lineUpGun = nil;
		self.selectLineUpGun(0);
		self.ShowEnemyInfo(grid.ID,self.mStageData.stage_class);
		self.ShowEnemySelectedEffect(grid.ID);
		self.HideGunInfo();
		--点击敌人音效
		CS.GF2.Audio.AudioUtils.PlayByID(5900001);
	elseif self.lineUpGuns[grid.ID] ~= nil then
		self.HideEnemyInfo();
		if self.last_selected_lineUpGun == nil then
			--CS.GF2.Audio.AudioUtils.PlayByID(5900001);
			if self.last_selected_gunCard == nil then
				--选中上阵人形
				self.last_selected_lineUpGun = self.lineUpGuns[grid.ID];
				self.selectLineUpGun(grid.ID);
				self.ShowGunInfo(self.last_selected_lineUpGun.data);
			else
				--卡牌替换上阵模型
				self.HideGunInfo();
				if self.last_selected_gunCard.uid == 0 or not self.AssistantHasLineUp() or self.lineUpGuns[grid.ID].uid ~= 0 then
					if not self.GunHasLineUp(self.last_selected_gunCard.data.id) or self.last_selected_gunCard.data.id == self.lineUpGuns[grid.ID].gun_id then
						if self.GetRoleHpByGunId(self.last_selected_gunCard.data.id) == 0 then
							local hint = TableData.GetHintById(6013);
							CS.PopupMessageManager.PopupString(hint);
						else
							self.TopLineUpGunListRemove(self.lineUpGuns[grid.ID].gun_id);
							self.TopLineUpGunListAdd(self.last_selected_gunCard.data.id);
							self.lineUpGuns[grid.ID]:InitGun(self.last_selected_gunCard.data.id,self.last_selected_gunCard.uid);
							self.playTransferEffect(self.lineUpGuns[grid.ID].gameObject.transform.position);
							self.UpdateGunList();
						end

					else
						self.GunHasLineUpTip();
					end
				else
					self.AssistantHasLineUpTip();
				end
			end
		else
			--交换位置
			if self.swapPositions(grid.ID) then
				self.HideGunInfo();
			end
		end
	elseif self.isBirthPoint(grid.ID) then
		self.HideEnemyInfo();
		CS.GF2.Audio.AudioUtils.PlayByID(5900001);
		print("onWorldClick isBirthPoint");
		if self.last_selected_gunCard == nil then
			print("onWorldClick isBirthPoint 1");
			--改变位置
			self.movePositions(grid.ID);
		else
			print("onWorldClick isBirthPoint 2");
			--卡牌上阵
			if self.lineUpCount < self.lineUpLimit then
				if self.last_selected_gunCard.uid == 0 or not self.AssistantHasLineUp() then
					if not self.GunHasLineUp(self.last_selected_gunCard.data.id) then
						if self.GetRoleHpByGunId(self.last_selected_gunCard.data.id) == 0 then
							local hint = TableData.GetHintById(6013);
							CS.PopupMessageManager.PopupString(hint);
						else
							self.TopLineUpGunListAdd(self.last_selected_gunCard.data.id);
							local instObj = instantiate(self.EmbattleTokensPrefab);
							local ctr = GunModelCtr.New();
							ctr:InitCtrl(instObj,self.TokensHeadIconPrefab,self.mView.mTrans_HpBarRoot.transform);
							ctr:InitData(self.last_selected_gunCard.data.id,grid.ID,self.last_selected_gunCard.uid,self.mStageData.type);
							instObj.transform.localScale = Vector3.one;
							self.lineUpGuns[ctr.grid_id] = ctr;
							self.lineUpCount = self.lineUpCount + 1;
							self.UpdateGunList();
							self.playTransferEffect(ctr.gameObject.transform.position);
						end
					else
						self.GunHasLineUpTip();
					end
				else
					self.AssistantHasLineUpTip();
				end
			else
				--提示人数已满
				self.FullLineUpTip();
			end
		end
		self.HideGunInfo();
	else
		self.onClickGround();
	end
	self.selectGunCard();
	self.last_selected_gunCard = nil
	self.DragingGunModel = nil;
end

--点击地板
function UICombatPreparationPanel.onClickGround(world_pos)
	if not self.m_InitFinished then
		return;
	end
	--print("onClickGround");
	--取消选中卡片及人形
	self.selectLineUpGun(0);
	self.last_selected_lineUpGun = nil;
	self.selectGunCard();
	self.last_selected_gunCard = nil
	if self.mView.mTrans_EnemyUnitInfo.gameObject.activeSelf == true or self.mView.mTrans_PlayerUnitInfo.gameObject.activeSelf == true then
		--取消人形选中
		CS.GF2.Audio.AudioUtils.PlayByID(5900004);
	else
		--点击地面音效
		CS.GF2.Audio.AudioUtils.PlayByID(5900005);
	end
	self.HideGunInfo();
	self.HideEnemyInfo();
end


--卡片开始拖动
function UICombatPreparationPanel.PreviewIconDragBegin(card,pos)
	if not self.m_InitFinished then
		return;
	end
	--可能出现两根手指都拖动了同一个卡牌的情况要注意
	print("PreviewIconDragBegin data.uid = "..card.uid);
	if self.DragingGunCardID == nil or card.data.id == self.DragingGunCardID then --确保同时只能拖动一张卡片
		CS.GF2.Audio.AudioUtils.PlayByID(5900001);
		self.onGunCardClick(card);
		self.SetCameraOperationsEnabled(false);
		--setactive(self.previewIcon.gameObject,true);
		self.previewIcon:SetVisible(true);
		self.previewIcon:InitGun(card.data.id,card.uid);
		mLastGrid = self.EmbattleTouchHelper:ScreenToGrid(pos.x,pos.y);
		local position = mLastGrid.pos;
		position.y = position.y + 0.1;
		self.previewIcon.mUIRoot.position = position;
		self.DragingGunCardID = card.data.id;
		self.UpdateBattleStart();
		return true;
	else
		return false;
	end
end

--卡片拖动中
function UICombatPreparationPanel.PreviewIconDrag(pos)
	if not self.m_InitFinished then
		return;
	end
	local grid = self.EmbattleTouchHelper:ScreenToGrid(pos.x,pos.y);
	if not grid.AllBlock and  not grid.HalfBlock then
		mLastGrid = grid;
	end
	local position = mLastGrid.pos;
	position.y = position.y + 0.1;
	local worldPos = self.EmbattleTouchHelper:ScreenToWorld(pos.x,pos.y);
	worldPos.y = position.y;
	self.previewIcon:SetPosition(worldPos,position);
end

--卡片拖动结束
function UICombatPreparationPanel.PreviewIconDragEnd(card,pos)
	if not self.m_InitFinished then
		return;
	end
	CS.GF2.Audio.AudioUtils.PlayByID(5900001);
	self.SetCameraOperationsEnabled(true);
	--setactive(self.previewIcon.gameObject,false);
	self.previewIcon:SetVisible(false);
	local grid = self.EmbattleTouchHelper:ScreenToGrid(pos.x,pos.y);

	if self.lineUpGuns[grid.ID] ~= nil then
		--卡牌替换上阵模型
		if card.uid == 0 or not self.AssistantHasLineUp() or self.lineUpGuns[grid.ID].uid ~= 0 then
			if not self.GunHasLineUp(self.last_selected_gunCard.data.id) or self.last_selected_gunCard.data.id == self.lineUpGuns[grid.ID].gun_id then
				if self.GetRoleHpByGunId(self.last_selected_gunCard.data.id) == 0 then
					local hint = TableData.GetHintById(6013);
					CS.PopupMessageManager.PopupString(hint);
				else
					self.TopLineUpGunListRemove(self.lineUpGuns[grid.ID].gun_id);
					self.TopLineUpGunListAdd(self.last_selected_gunCard.data.id);
					self.lineUpGuns[grid.ID]:InitGun(self.last_selected_gunCard.data.id,self.last_selected_gunCard.uid);
					self.UpdateGunList();
					self.playTransferEffect(self.lineUpGuns[grid.ID].gameObject.transform.position);
				end
			else
				self.GunHasLineUpTip();
			end
		else
			self.AssistantHasLineUpTip();
		end
	elseif self.isBirthPoint(grid.ID) then
		--卡牌上阵
		if card.uid == 0 or not self.AssistantHasLineUp() then
			if self.lineUpCount < self.lineUpLimit then
				if not self.GunHasLineUp(self.last_selected_gunCard.data.id) then
					if self.GetRoleHpByGunId(self.last_selected_gunCard.data.id) == 0 then
						local hint = TableData.GetHintById(6013);
						CS.PopupMessageManager.PopupString(hint);
					else
						self.TopLineUpGunListAdd(self.last_selected_gunCard.data.id);
						local instObj = instantiate(self.EmbattleTokensPrefab);
						local ctr = GunModelCtr.New();
						ctr:InitCtrl(instObj,self.TokensHeadIconPrefab,self.mView.mTrans_HpBarRoot.transform);
						ctr:InitData(card.data.id,grid.ID,card.uid,self.mStageData.type);
						instObj.transform.localScale = Vector3.one;
						self.lineUpGuns[ctr.grid_id] = ctr;
						self.lineUpCount = self.lineUpCount + 1;
						self.UpdateGunList();
						self.playTransferEffect(instObj.transform.position);
					end

				else
					self.GunHasLineUpTip();
				end
			else
				--提示人数已满
				self.FullLineUpTip();
			end
		else
			self.AssistantHasLineUpTip();
		end
	end
	self.DragingGunCardID = nil;
	self.last_selected_gunCard = nil;
	self.UpdateBattleStart();
	self.selectGunCard();
	self.HideGunInfo();
end

--助战人数上限提示
function UICombatPreparationPanel.AssistantHasLineUpTip()
	local hint = TableData.GetHintById(3006);
	CS.PopupMessageManager.PopupString(hint);
end

--重复上阵人形提示
function UICombatPreparationPanel.GunHasLineUpTip()
	local hint = TableData.GetHintById(3005);
	CS.PopupMessageManager.PopupString(hint);
end
--助战人数上限提示
function UICombatPreparationPanel.FullLineUpTip()
	local hint = TableData.GetHintById(3007);
	CS.PopupMessageManager.PopupString(hint);
end

--上阵的人形交换位置
function UICombatPreparationPanel.swapPositions(grid_a)
	local grid_b = self.last_selected_lineUpGun.grid_id;
	--print("swapPositions a = "..grid_a .." b = "..grid_b)
	if grid_a ~= grid_b then
		self.lineUpGuns[grid_a]:InitGrid(grid_b);
		self.last_selected_lineUpGun:InitGrid(grid_a);
		self.lineUpGuns[grid_b] = self.lineUpGuns[grid_a];
		self.lineUpGuns[grid_a] = self.last_selected_lineUpGun;
		self.playTransferEffect(self.lineUpGuns[grid_a].gameObject.transform.position);
		self.playTransferEffect(self.lineUpGuns[grid_b].gameObject.transform.position);

		--取消场景人形选中
		self.last_selected_lineUpGun = nil;
		self.selectLineUpGun(0);
		return true;
	end
	return false;
end

--移动选中点到新的出生点
function UICombatPreparationPanel.movePositions(grid_id)
	if self.last_selected_lineUpGun ~= nil then
		self.lineUpGuns[self.last_selected_lineUpGun.grid_id] = nil;
		self.last_selected_lineUpGun:InitGrid(grid_id);
		self.lineUpGuns[grid_id] = self.last_selected_lineUpGun;

		self.playTransferEffect(self.lineUpGuns[grid_id].gameObject.transform.position);
		--取消场景人形选中
		self.last_selected_lineUpGun = nil;
		self.selectLineUpGun(0);
	end
end


--上阵模型刷新选中表现
function UICombatPreparationPanel.selectLineUpGun(gridID)
	local gun_id = 0;
	for id,ctr in pairs(self.lineUpGuns)do
		if id == gridID then
			ctr:SetSelected(true);
			gun_id = ctr.gun_id;
		else
			ctr:SetSelected(false);
		end
	end
	for i,ctr in ipairs(self.lineUpGunList)do
		if ctr.data ~= nil then
			ctr:SetSelected(ctr.data.id == gun_id);
		end
	end
end

--判断格子点是否为出生点
function UICombatPreparationPanel.isBirthPoint(id)
	for _,grid_id in ipairs(self.GunBirthPoints)do
		if grid_id == id then
			return true;
		end
	end
	return false;
end

--人形列表点击
function UICombatPreparationPanel.onGunCardClick(card)
	if not self.m_InitFinished then
		return;
	end
	--卡片拖动中屏蔽其他卡片的点击
	if self.DragingGunCardID == nil or self.DragingGunCardID == card.data.id then
		if card.data ~= nil then
			CS.GF2.Audio.AudioUtils.PlayByID(5900001);
			--取消场景模型选中
			self.last_selected_lineUpGun = nil;
			self.selectLineUpGun(0);

			self.last_selected_gunCard = card;
			self.ShowGunInfo(card.data);
		else
			self.last_selected_gunCard = nil;
			self.HideGunInfo();
		end
		self.selectGunCard(card.data,card.uid);
	end
end


--人形列表刷新选中表现
function UICombatPreparationPanel.selectGunCard(gunData,uid)
	for _,item in ipairs(self.GunSlotItemPool) do
		if item.mUIRoot.gameObject.activeSelf then
			item:SetSelected(gunData ~= nil and item.data.id == gunData.id and item.uid == uid);
		end
	end
end

--好友助阵列表切换
function UICombatPreparationPanel.OnFriendHelpClick(value)
	self.IsAssistantMode = value;
	self.UpdateGunList();
	if value then
		self.mView.mToggle_RepeatSweep.isOn = false;
		self.mView.mToggle_RepeatSweep.interactable = false;
		AFKBattleManager.CurStep = CS.AFKBattleManager.EAutoStep.OnAutoOff;
		setactive(self.mView.mTrans_RepeatSweep_UnSelect.gameObject,true);
	else
		if not self.AssistantHasLineUp() then
			self.mView.mToggle_RepeatSweep.interactable = true;
			setactive(self.mView.mTrans_RepeatSweep_UnSelect.gameObject,false);
		end
	end
end

--筛选列表切换
function UICombatPreparationPanel.OnSwitchBtnClick(obj)
	local activeSelf = self.mView.mTrans_FilterPanel_FullFilter.gameObject.activeSelf;
	setactive(self.mView.mTrans_FilterPanel_FullFilter.gameObject, not activeSelf);
	setactive(self.mView.mTrans_FilterPanel_Filter.gameObject, activeSelf);
end

--尖兵
function UICombatPreparationPanel.OnBtnVanguardClick(obj)
	self.UpdateDutyFilterBtn(1);
end

--突进
function UICombatPreparationPanel.OnBtnSpearheadClick(obj)
	self.UpdateDutyFilterBtn(2);
end

--歼灭
function UICombatPreparationPanel.OnBtnAnnihilatorClick(obj)
	self.UpdateDutyFilterBtn(3);
end

--特勤
function UICombatPreparationPanel.OnBtnSpecialistClick(obj)
	self.UpdateDutyFilterBtn(4);
end

--人形列表筛选菜单更新
function UICombatPreparationPanel.UpdateDutyFilterBtn(value)
	if self.DutyFilter == value then
		self.DutyFilter = 0;
	else
		self.DutyFilter = value;
	end
	setactive(self.mView.mTrans_FilterPanel_Vanguard_Actived.gameObject, self.DutyFilter == 1);
	setactive(self.mView.mTrans_FilterPanel_Spearhead_Actived.gameObject, self.DutyFilter == 2);
	setactive(self.mView.mTrans_FilterPanel_Annihilator_Actived.gameObject, self.DutyFilter == 3);
	setactive(self.mView.mTrans_FilterPanel_Specialist_Actived.gameObject, self.DutyFilter == 4);
	self.UpdateGunList(true);
end

function UICombatPreparationPanel.OnBtnRankRClick(obj)
	self.UpdateRankFilterBtn(3);
end

function UICombatPreparationPanel.OnBtnRankSRClick(obj)
	self.UpdateRankFilterBtn(4);
end

function UICombatPreparationPanel.OnBtnRankSSRClick(obj)
	self.UpdateRankFilterBtn(5);
end


function UICombatPreparationPanel.UpdateRankFilterBtn(value)
	if self.RankFilter == value then
		self.RankFilter = 0;
	else
		self.RankFilter = value;
	end
	setactive(self.mView.mTrans_FilterPanel_RankR_Actived.gameObject, self.RankFilter == 3);
	setactive(self.mView.mTrans_FilterPanel_RankSR_Actived.gameObject, self.RankFilter == 4);
	setactive(self.mView.mTrans_FilterPanel_RankSSR_Actived.gameObject, self.RankFilter == 5);
	self.UpdateGunList(true);
end

function UICombatPreparationPanel.OnBtnElement1Click(obj)
	self.UpdateElementFilterBtn(1);
end

function UICombatPreparationPanel.OnBtnElement2Click(obj)
	self.UpdateElementFilterBtn(2);
end

function UICombatPreparationPanel.OnBtnElement3Click(obj)
	self.UpdateElementFilterBtn(3);
end

function UICombatPreparationPanel.OnBtnElement4Click(obj)
	self.UpdateElementFilterBtn(4);
end

function UICombatPreparationPanel.OnBtnElement5Click(obj)
	self.UpdateElementFilterBtn(5);
end

function UICombatPreparationPanel.OnBtnElement6Click(obj)
	self.UpdateElementFilterBtn(6);
end

function UICombatPreparationPanel.UpdateElementFilterBtn(value)
	if self.ElementFilter == value then
		self.ElementFilter = 0;
	else
		self.ElementFilter = value;
	end
	for i = 1,6 do
		setactive(self.mView["mTrans_FilterPanel_Duty"..i.."_Actived"].gameObject, self.ElementFilter == i);
	end
	self.UpdateGunList(true);
end

--相机旋转操作相关
function UICombatPreparationPanel.OnCameraLeftBtnDown(obj)
	if self.CameraOperationsEnabled then
		CS.EmbattleCameraController.Instance:RotateCamera(true,true);
		self.SetUIOperationsEnabled(false);
		setactive(self.mView.mImage_LeftBtnImageON,true);
		setactive(self.mView.mImage_LeftBtnImageOFF,false);
		UIUtils.SetAlpha(self.mView.mImage_LeftBtnBGImage,1);
	end
end

function UICombatPreparationPanel.OnCameraLeftBtnUp(obj)
	if self.CameraOperationsEnabled then
		CS.EmbattleCameraController.Instance:RotateCamera(true,false);
		self.SetUIOperationsEnabled(true);
		setactive(self.mView.mImage_LeftBtnImageON,false);
		setactive(self.mView.mImage_LeftBtnImageOFF,true);
		UIUtils.SetAlpha(self.mView.mImage_LeftBtnBGImage,0.75);
	end
end

function UICombatPreparationPanel.OnCameraRightBtnDown(obj)
	if self.CameraOperationsEnabled then
		CS.EmbattleCameraController.Instance:RotateCamera(false,true);
		self.SetUIOperationsEnabled(false);
		setactive(self.mView.mImage_RightBtnImageON,true);
		setactive(self.mView.mImage_RightBtnImageOFF,false);
		UIUtils.SetAlpha(self.mView.mImage_RightBtnBGImage,1);
	end
end

function UICombatPreparationPanel.OnCameraRightBtnUp(obj)
	if self.CameraOperationsEnabled then
		CS.EmbattleCameraController.Instance:RotateCamera(false,false);
		self.SetUIOperationsEnabled(true);
		setactive(self.mView.mImage_RightBtnImageON,false);
		setactive(self.mView.mImage_RightBtnImageOFF,true);
		UIUtils.SetAlpha(self.mView.mImage_RightBtnBGImage,0.75);
	end
end

--设置卡牌UI操作是否禁用
function UICombatPreparationPanel.SetUIOperationsEnabled(value)
	self.UIOperationsEnabled = value;
	for _,item in ipairs(self.GunSlotItemPool) do
		if item.mUIRoot.gameObject.activeSelf then
			item:SetEnabled(value);
		end
	end
	self.UpdateBattleStart();
end

function UICombatPreparationPanel.UpdateBattleStart()
	self.mView.mBtn_BattleStart.interactable = self.lineUpCount > 0 and self.UIOperationsEnabled and self.DragingGunCardID == nil;
	local canNotStart = self.lineUpCount <= 0 or not self.UIOperationsEnabled or self.DragingGunCardID ~= nil;
	setactive(self.mView.mTrans_ImageUnable.gameObject,canNotStart);
	setactive(self.mView.mTrans_Image.gameObject,not canNotStart);
end


--设置相机操作是否禁用
function UICombatPreparationPanel.SetCameraOperationsEnabled(value)
	self.CameraOperationsEnabled = value;
	CS.EmbattleCameraController.Instance:SetEnabled(value);
	if not value then
		setactive(self.mView.mTrans_ViewControl.gameObject,false);
		setactive(self.mView.mTrans_RockerControl.gameObject,false);
	else
		local cameraBtnRotateModeEnable = CS.BattlePerformSetting.cameraBtnRotateModeEnable;
		setactive(self.mView.mTrans_ViewControl.gameObject,cameraBtnRotateModeEnable);
		setactive(self.mView.mTrans_RockerControl.gameObject,not cameraBtnRotateModeEnable);
	end
end

function UICombatPreparationPanel.OnEmbattleCameraRotate(msg)
	local angle = CS.EmbattleCameraController.Instance.angle_y;

	for _,item in pairs(self.lineUpGuns)do
		item:AdjustGridRotation(-angle);
	end
end

--旋转按钮模式变更
function UICombatPreparationPanel.OnCameraRotateBtnEnable()
	self.SetCameraOperationsEnabled(self.CameraOperationsEnabled);
end


--相机操作开始 禁用卡牌操作
function UICombatPreparationPanel.onCameraOperationBegin()
	self.SetUIOperationsEnabled(false);
end

--相机操作结束 解禁相关功能
function UICombatPreparationPanel.onCameraOperationEnd()
	self.SetUIOperationsEnabled(true);
	self.SetCameraOperationsEnabled(true);
end


--上场人数详情
function UICombatPreparationPanel.UpdateGumNum()

	self.mView.mText_GunCount.text = self.lineUpLimit;
	self.mView.mText_GunNowCount.text = self.lineUpCount;

	self.UpdateBattleStart();
	for idx, ctr in ipairs(self.lineUpGunList) do
		local curRoleHp = self.GetRoleHpByGunId(self.lineUpGunIDList[idx])
		if idx <= self.lineUpCount and curRoleHp ~= 0 then
			ctr:initData(self.lineUpGunIDList[idx]);
		else
			ctr:SetEmpty();
		end
	end
	local score = 0;
	for _,item in pairs(self.lineUpGuns)do
		-- guns
		score = score + NetCmdTeamData:GetGunFightingCapacityByID(tonumber(item.gun_id));
	end
	--self.mView.mText_BattlePower.text = score;
	--使用数字滚动动效
	local tweenNumber = getcomponent(self.mView.mText_BattlePower.transform, typeof(CS.TweenNumber));
	if tweenNumber ~= nil then
		tweenNumber.NumberFrom = mOldSocre;
		tweenNumber.NumberTo = score;
		tweenNumber:Play();
	end
	mOldSocre = score;

	setactive(self.mView.mTrans_AssistantCost.gameObject, self.AssistantHasLineUp());
end


function UICombatPreparationPanel.ShowEnemySelectedEffect(grid_id)
	for _,ctr in pairs(self.enemyInfos)do
		ctr:SetSelected(ctr.grid_id == grid_id);
	end
end



--展示敌人详情
function UICombatPreparationPanel.ShowEnemyInfo(grid_id,stage_class)
	setactive(self.mView.mTrans_EnemyUnitInfo.gameObject, true);
	if self.isPvP and not self.isDefense then
		local data =  self.PvpEnemyGunMap[grid_id];
		local sprite = self.GetCharacterHeadSprite(data.TabGunData.code);
		self.mView.mImage_EnemyUnitInfo_Avatar.sprite = sprite;

		self.mView.mImage_EnemyUnitInfo_EnemytypeBGImage.sprite = self.DutyTypeTagSprites[data.TabGunData.duty];
		self.mView.mText_EnemyUnitInfo_NamebgImage_Name.text = data.TabGunData.name.str;
		self.mView.mText_EnemyUnitInfo_LevelBGImage_Level.text = data.level;
		self.mView.mText_EnemyUnitInfo_BloodImagebg_Blood.text = data.max_hp.."/"..data.max_hp;
		self.selecteEnemyGunData = data;
	else
		local enemyData = TableData.GetEnemyData(self.enemyInfos[grid_id].enemy_id);
		local sprite = self.GetCharacterHeadSprite(enemyData.character_pic);
		self.mView.mImage_EnemyUnitInfo_Avatar.sprite = sprite;

		local levelPropertyData = TableData.GetLevelPropertyDataByGroupAndLevel(enemyData.property_group,stage_class+enemyData.add_level);
		self.mView.mText_EnemyUnitInfo_NamebgImage_Name.text = enemyData.name.str;
		self.mView.mText_EnemyUnitInfo_LevelBGImage_Level.text =  stage_class + enemyData.add_level;
		self.mView.mText_EnemyUnitInfo_BloodImagebg_Blood.text = levelPropertyData.max_hp;
		self.selecteEnemyData = enemyData;
	end
end

--展示人形详情
function UICombatPreparationPanel.ShowGunInfo(data)
	self.HideEnemyInfo();
	setactive(self.mView.mTrans_PlayerUnitInfo.gameObject, true);

	self.mView.mImage_PlayerUnitInfo_GuntypeBGImage.sprite = self.DutyTypeTagSprites[data.TabGunData.duty];
	local sprite = self.GetCharacterHeadSprite(data.TabGunData.code);
	self.mView.mImage_PlayerUnitInfo_Avatar.sprite = sprite;

	self.mView.mText_PlayerUnitInfo_NamebgImage_Name.text = data.TabGunData.name.str;
	self.mView.mText_PlayerUnitInfo_LevelBGImage_Level.text = data.level;
	self.mView.mText_PlayerUnitInfo_BloodImagebg_Blood.text = data.max_hp;

	local playerHps = NetCmdSimulateBattleData:GetStagePlayerHpsByType(self.mStageData.type)
	if playerHps ~= nil and playerHps.Count>0 then
		for k, v in pairs(playerHps) do
			if k == data.id and data.max_hp ~= 0 then
				self.mView.mImage_PlayerUnitInfo_BloodImagebg_BloodProgressImage.fillAmount = v / data.max_hp
			end
		end
	end


	for _,ctr in pairs(self.skillCtrls)do
		setactive(ctr.mUIRoot.gameObject, false);
	end
	--技能
	local showSkillList = {};
	--普攻

	if data.NormalAttackSkill ~= nil then
		table.insert(showSkillList,data.NormalAttackSkill);
	end

	if data.ActiveSkill ~= nil then
		table.insert(showSkillList,data.ActiveSkill);
	end

	if data.SpecialSkill ~= nil then
		table.insert(showSkillList,data.SpecialSkill);
	end

	if data.TalentSkill ~= nil then
		table.insert(showSkillList,data.TalentSkill);
	end

	local WeaponData = data.WeaponData;
	if WeaponData ~= nil then
		if WeaponData.BuffSkill ~= nil then
			table.insert(showSkillList,WeaponData.BuffSkill);
		end
		if WeaponData.Skill ~= nil then
			table.insert(showSkillList,WeaponData.Skill);
		end
	end

	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_SkillItem,self);
	for idx,skillData in ipairs(showSkillList)do
		local ctr = self.skillCtrls[idx];
		if ctr == nil then
			local instObj = instantiate(itemPrefab);
			ctr = UICombatPreparationSkillItem.New();
			ctr:InitCtrl(instObj.transform);
			UIUtils.AddListItem(instObj,self.mView.mHLayout_PlayerUnitInfo_Skill_SkillList.transform);
			self.skillCtrls[idx] = ctr;
		end
		setactive(ctr.mUIRoot.gameObject, true);
		ctr:InitSkill(skillData);
	end

	self.selectGunData = data;
end

--打开更加详细的角色详情
function UICombatPreparationPanel.OnInformationBtnClick()
	local informationPanel = CS.LuaUtils.EnumToInt(CS.GF2.UI.enumUIPanel.UICombatUnitInformationPanelNew);
	local lineUpGun = NetCmdTeamData:GetLineUpGun(self.mStageData.type, self.selectGunData.id);
	if lineUpGun == nil then
		local gunUid = 0;
		if self.selectGunData.uid ~= nil then
			gunUid = self.selectGunData.uid
		end
		PlayerNetCmdHandler:C2SStageUsableGunCmd(self.mStageData.id, gunUid, self.selectGunData.id);
	else

		UIManager.OpenUIByParam(informationPanel, self.selectGunData);
	end

end

function UICombatPreparationPanel.OnEnemyInformationBtnClick()
	local informationPanel = CS.LuaUtils.EnumToInt(CS.GF2.UI.enumUIPanel.UICombatUnitInformationPanelNew);
	if self.isPvP and not self.isDefense then
		UIManager.OpenUIByParam(informationPanel,self.selecteEnemyGunData);
	else
		UIManager.OpenUIByParam(informationPanel,self.selecteEnemyData);
	end
end


--更新目标状态
function UICombatPreparationPanel.UpdateStageTaskList()
	if(self.mStageData.goal.str~="" and self.mGoalCtr==nil) then
		local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_StageTaskItem,self);
		local instObj = instantiate(itemPrefab);
		ctr = UICombatStageTaskItem.New();
		self.mGoalCtr = ctr;
		ctr:InitCtrl(instObj.transform);
		ctr:InitGoalData(self.mStageData.goal);
		UIUtils.AddListItem(instObj,self.mView.mTrans_TaskTitle_StageTaskList.transform);
	end

	local complete_challenge = {};
	if self.mStageRecord ~= nil then
		for i =0,self.mStageRecord.complete_challenge.Length - 1 do
			complete_challenge[self.mStageRecord.complete_challenge[i]] = true;
		end
	end
	--秘境特殊要求

	local count = 0;
	local MythicStageType = 12;
	if self.mStageData.type == MythicStageType and NetCmdSimulateBattleData.EnchantmentList~=nil  and self.mMythicBuffCtr==nil then
		local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_StageTaskItem, self);
		local instObj = instantiate(itemPrefab);
		ctr = UICombatStageTaskItem.New();
		ctr:InitCtrl(instObj.transform);
		self.mMythicBuffCtr =ctr;
		ctr:InitMythicBuffData(NetCmdSimulateBattleData.TotalBuffs,NetCmdSimulateBattleData.EnchantmentList);
		UIUtils.AddListItem(instObj, self.mView.mTrans_TaskTitle_StageTaskList.transform);

	end



	if self.mStageData.type == MythicStageType and NetCmdSimulateBattleData.TotalBuffs~=nil and self.mMythicEnchantmentCtr==nil then
		local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_StageTaskItem, self);
		local instObj = instantiate(itemPrefab);
		ctr = UICombatStageTaskItem.New();
		ctr:InitCtrl(instObj.transform);
		self.mMythicEnchantmentCtr =ctr;
		ctr:InitMythicEnchantmentData(NetCmdSimulateBattleData.TotalBuffs,NetCmdSimulateBattleData.EnchantmentList);
		UIUtils.AddListItem(instObj, self.mView.mTrans_TaskTitle_StageTaskList.transform);

	end


	for i = 0, self.mStageData.challenge_list.Count - 1 do
		local challenge_id = tonumber(self.mStageData.challenge_list[i]);
		if challenge_id ~= nil and challenge_id ~= 0 then
			count = count + 1;
			local ctr = self.StageTaskItems[count];
			if ctr  == nil then
				local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_StageTaskItem,self);
				local instObj = instantiate(itemPrefab);
				ctr = UICombatStageTaskItem.New();
				ctr:InitCtrl(instObj.transform);
				local isComplete = complete_challenge[i]  == true;
				ctr:InitData(challenge_id , isComplete);
				UIUtils.AddListItem(instObj,self.mView.mTrans_TaskTitle_StageTaskList.transform);
				self.StageTaskItems[count] = ctr;
			end
			ctr:UpdateState();
		end
	end

	if self.mMythicBuffCtr ~= nil then
		count = count + 1;
	end

	if self.mMythicEnchantmentCtr ~= nil then
		count = count + 1;
	end

	setactive(self.mView.mTrans_TaskTitle.gameObject, count > 0);
end

--服务器异步返回好友助战列表
function UICombatPreparationPanel.OnAssistantRespond(msg)
	if msg.Sender ~= nil then
		self.mAssistantUIDMap = msg.Sender;
		self.mAssistantGunMap = msg.Content;
		self.AssistantGunCount = self.mAssistantUIDMap.Count;
	else
		print("OnAssistantRespond ")
	end
end

--任意操作 隐藏技能详情面板
function UICombatPreparationPanel.HideSkillDetail()
	local currentSelectedGameObject = CS.UnityEngine.EventSystems.EventSystem.current.currentSelectedGameObject;
	if currentSelectedGameObject~= self.mView.mImage_PlayerUnitInfo_SkillInfo_SkillUnitInfoBG.gameObject then
		setactive(self.mView.mTrans_PlayerUnitInfo_SkillInfo.gameObject, false);

		for k,skillCtr in pairs(self.skillCtrls)do
			if skillCtr.data ~= nil then
				skillCtr:SetSelected(false);
			end
		end
	end
end

--开始转场动画
function UICombatPreparationPanel.OnStartTransitions(msg)
	local duration = msg.Sender;
	for _,model in pairs(self.lineUpGuns)do
		self.playTransferUpEffect(model.gameObject.transform.position,duration);
		gfdestroy(model.gameObject);
	end
	self.lineUpGuns = {};
end

--打开技能详情面板
function UICombatPreparationPanel.ShowSkillDetail(skillData,copyUI)
	clearallchild(self.mView.mTrans_PlayerUnitInfo_SkillInfo_HighLyerSkillList.transform);
	local ctr = instantiate(copyUI);
	setparent(self.mView.mTrans_PlayerUnitInfo_SkillInfo_HighLyerSkillList.transform,ctr.transform);
	ctr.transform.localScale = Vector3.one;
	ctr.transform.position = copyUI.transform.position;
	setactive(self.mView.mTrans_PlayerUnitInfo_SkillInfo.gameObject, true);
	self.mView.mText_PlayerUnitInfo_SkillInfo_SkillName.text = skillData.name;
	self.mView.mText_PlayerUnitInfo_SkillInfo_SkillType_SkillType.text = skillData:GetSkillTypeStr();
	self.mView.mText_PlayerUnitInfo_SkillInfo_SkillInfluenceRange_SkillInfluenceRangeText.text = CS.GF2.Battle.SkillUtils.GetSkillInfluenceRangeString(skillData);
	self.mView.mImage_PlayerUnitInfo_SkillInfo_SkillInfluenceRange_SkillInfluenceRange.sprite = CS.GF2.Battle.SkillUtils.GetSkillInfluenceRangeIcon(skillData);
	self.mView.mText_PlayerUnitInfo_SkillInfo_ShootRangebg_ShootRange.text = tostring(skillData.RangeTemp);
	self.mView.mText_PlayerUnitInfo_SkillInfo_SkillCD_SkillCDText.text = tostring(skillData.cd_time);
	self.mView.mText_PlayerUnitInfo_SkillInfo_SkillInformation.text = skillData.description;

	for k,skillCtr in pairs(self.skillCtrls)do
		if skillCtr.data ~= nil then
			skillCtr:SetSelected(skillData.id == skillCtr.data.id);
		end
	end
end

--隐藏人形详情面板
function UICombatPreparationPanel.HideGunInfo()
	setactive(self.mView.mTrans_PlayerUnitInfo.gameObject, false);
	if self.IsAssistantMode then
		self.UpdateGunList();
	end
end

--隐藏敌人详情面板
function UICombatPreparationPanel.HideEnemyInfo()
	setactive(self.mView.mTrans_EnemyUnitInfo.gameObject, false);
	for grid_id,ctr in pairs(self.enemyInfos)do
		ctr:SetSelected(false);
	end
end


--点击爱心
function UICombatPreparationPanel.OnSwitchFavouriteClick(obj)
	local favorite = self.selectGunData.favorite == 1 and 0 or 1;
	NetCmdTeamData:SendReqGunFavorite(self.selectGunData.id,favorite,self.SwitchFavouriteCallBack);
end

--爱心回调
function UICombatPreparationPanel.SwitchFavouriteCallBack(ret)
	self.UpdateGunList(false);
	local data = NetCmdTeamData:GetGunByID(self.selectGunData.id);
	setactive(self.mView.mTrans_PlayerUnitInfo_FavouriteActived.gameObject, data.favorite == 1);
	TimerSys:DelayCall(0.5,function(obj)
			setactive(self.mView.mTrans_PlayerUnitInfo.gameObject, false);
			self.gunInfoShowing = false;
		end);
end

--退出部署
function UICombatPreparationPanel.OnExitBattleClick(gameobj)
	if(AFKBattleManager.IsInAutoMode) then
		return;
	end
	if self.isDefense then
		local ExitEmbattle = function()
			--UICombatPreparationPanel.Close();
			UISystem:ClearUIStacks();
			SceneSys:ReturnMain();
		end
		MessageBox.Show("",TableData.GetHintById(3003),MessageBox.ShowFlag.eNone,nil,ExitEmbattle,nil,0)
	else
		AFKBattleManager.CurStep = CS.AFKBattleManager.EAutoStep.OnAutoOff;
		--CS.BattleNetCmdHandler.Instance:SendReqStageExitCmd(self.StageExitCallBack);
		local settingPanel = CS.LuaUtils.EnumToInt(CS.GF2.UI.enumUIPanel.BattleSettingPanel);
		UIManager.OpenUIByParam(settingPanel,false);
	end
end


function UICombatPreparationPanel.StageExitCallBack(ret)
	if ret == CS.CMDRet.eSuccess then
		print("战役退出成功");
	else
		print("战役退出失败");
	end
	SceneSys:ReturnMain();
end


--防御部署保存
function UICombatPreparationPanel.OnBtnDeployConfirmClick(obj)
	print("OnBtnDeployConfirmClick")
	if self.lineUpCount == 0 then
		local hint = TableData.GetHintById(3004);
		CS.PopupMessageManager.PopupString(hint);
		return;
	end
	local guns = {};
	for _,item in pairs(self.lineUpGuns)do
		-- guns
		local value = CS.StageUseGun();
		value.gun_id = item.gun_id;
		value.point_id = item.grid_id;
		print("gun_id =" ..value.gun_id .. "point_id =" .. value.point_id);
		table.insert(guns,value);
	end
	NetCmdPvPData:SaveDefend(guns,self.SaveDefendCallBack);
end

function UICombatPreparationPanel.SaveDefendCallBack(ret)
	if ret == CS.CMDRet.eSuccess then
		local hint = TableData.GetHintById(3002);
		CS.PopupMessageManager.PopupString(hint);
	else
		print("保存阵容失败!");
	end
end

--进入战斗
function UICombatPreparationPanel.OnBtnBattleStartClick(obj)

	if(AFKBattleManager.IsInAutoMode) then
		return;
	end
	if self.isPvP and not self.isDefense and NetCmdPvPData.IsDuringSettlement then
		MessageBox.Show("",GashaponNetCmdHandler:GetGachaItemType(226),MessageBox.ShowFlag.eMidBtn,nil,function()
				UISystem:ClearAllUIStacks();
				SceneSys:OpenSceneByName("CommandCenter");
			end ,nil,0);
		return;
	end

	if self.AssistantHasLineUp() and NetCmdItemData:GetResItemCount(self.AssistantCostItemID) < self.AssistantCostItemCount then
		local hint = TableData.GetHintById(3008);
		CS.PopupMessageManager.PopupString(hint);
		return;
	end

	local BattleStart = function()
		local guns = {};
		for _,item in pairs(self.lineUpGuns)do
			-- guns
			local value = CS.StageUseGun();
			value.gun_id = item.gun_id;
			value.point_id = item.grid_id;
			value.uid = item.uid;
			print("gun_id =" ..value.gun_id .. "point_id =" .. value.point_id .." uid = "..value.uid);
			table.insert(guns,value);
		end

		if(AFKBattleManager.IsInAutoPrepare) then
			AFKBattleManager:StartAutoRepeatBattle(self.mStageData,guns,self.mBattleStage);
			return;
		end
		self.mBattleStage:OnEmbattleOver(guns);
		CS.EmbattleCameraController.Instance:RotateCamera(true,false);
		CS.EmbattleCameraController.Instance:RotateCamera(false,false);

		--[[        if(CS.GuideManager.Instance:CheckPopUpGuide(8,self.mStageData.id)) then
		TimerSys:DelayCall(2,function()
		UIManager.OpenUIByParam(UIDef.UITutorialInfoPanel,self.mStageData.id, false);
		end)

		end]]
	end
	local necessaryGunFlag = true;
	for id,v in pairs(self.necessaryGunList) do
		local find = false;
		for _,item in pairs(self.lineUpGuns)do
			if item.gun_id == id then
				find = true;
				break;
			end
		end
		if not find then
			necessaryGunFlag = false;
			break;
		end
	end

	--print("进入战斗"..self.lineUpCount.." "..self.lineUpLimit.." "..NetCmdTeamData.GunCount.." "..self.AssistantGunCount.." "..self.banGunCount)
	if not necessaryGunFlag then
		local hint = TableData.GetHintById(50005);
		CS.PopupMessageManager.PopupString(hint);
	elseif self.lineUpCount < self.lineUpLimit and self.lineUpCount < NetCmdTeamData.GunCount - self.banGunCount then
		MessageBox.Show("",GashaponNetCmdHandler:GetGachaItemType(3001),MessageBox.ShowFlag.eNone,nil,BattleStart,nil,0);
	else
		BattleStart();
	end
end
------------------自动战斗------------------
function UICombatPreparationPanel.OnSetAutoBattleMode(value)
	self = UICombatPreparationPanel;

	if(AFKBattleManager:CheckCanAuto(self.mStageData) == false) then
		local hint = TableData.GetHintById(605);
		CS.PopupMessageManager.PopupString(hint)
		self.mView.mToggle_RepeatSweep.isOn = false;
		return;
	end

	if(value == true) then
		AFKBattleManager.CurStep = CS.AFKBattleManager.EAutoStep.OnPrepare;
		self.mView.mToggle_FriendHelp.isOn = false;
		self.mView.mToggle_FriendHelp.interactable = false;
		self.OnFriendHelpClick(false);
		setactive(self.mView.mTrans_FriendHelp_UnSelect.gameObject,true);
	else
		AFKBattleManager.CurStep = CS.AFKBattleManager.EAutoStep.OnAutoOff;
		setactive(self.mView.mTrans_FriendHelp_UnSelect.gameObject,false);
		self.mView.mToggle_FriendHelp.interactable = true;
	end
end

------------ 上阵人形目标筛选 ----------------
function UICombatPreparationPanel.ExcludeGunType(type)
	for k,ctr in pairs(self.lineUpGuns) do
		if ctr~= nil and ctr.data.TabGunData.duty == type then
			return false;
		end
	end
	return true;
end

function UICombatPreparationPanel.IncludeGunType(type)
	local res = false;
	for k,ctr in pairs(self.lineUpGuns) do
		if ctr.data.TabGunData.duty == type then
			res = true;
		end
	end
	return res;
end

function UICombatPreparationPanel.OnlySingleGunType(type)
	local res = false;
	for k,ctr in pairs(self.lineUpGuns) do
		if ctr.data.TabGunData.duty == type then
			res = true;
		else
			return false;
		end
	end
	return res;
end

function UICombatPreparationPanel.GunFewerThan(num)
	return self.lineUpCount <= num and self.lineUpCount > 0;
end

