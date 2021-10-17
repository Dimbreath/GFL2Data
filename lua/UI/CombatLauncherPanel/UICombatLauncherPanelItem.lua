require("UI.UIBaseCtrl")

UICombatLauncherPanelItem = class("UICombatLauncherPanelItem", UIBaseCtrl)
UICombatLauncherPanelItem.__index = UICombatLauncherPanelItem

function UICombatLauncherPanelItem:__InitCtrl()
	self.mBtn_Go = self:GetButton("BGImage/BottomPanel/Btn_Go")
	self.mBtn_Close = self:GetButton("Btn_Close")
	-- self.mBtn_RaidButton = self:GetButton("BGImage/BottomPanel/UI_Btn_RaidButton")
	self.mBtn_Watch = self:GetButton("BGImage/BottomPanel/Btn_Watch")
	self.mImage_SpecialMarkIcon = self:GetImage("BGImage/TopLayout/BG/Image_SpecialMarkIcon")
	self.mImage_StoryCover = self:GetImage("BGImage/TopLayout/BG/Image_StoryCover")
	self.mImage_Stamina_StaminaIcon = self:GetImage("BGImage/BottomPanel/Stamina/Image_StaminaIcon")
	self.mText_StageNameInfo = self:GetText("BGImage/TopLayout/Text_StageNameInfo")
	self.mText_StageNumber = self:GetText("BGImage/TopLayout/Text_StageNumber")
	self.mText_StageType = self:GetRectTransform("BGImage/TopLayout/StageType")
	self.mText_Stamina_StaminaCost = self:GetText("BGImage/BottomPanel/Stamina/Text_StaminaCost")
	self.mText_Recommend_RecommendedLevel = self:GetText("BGImage/TopLayout/Trans_StageInfo/UI_Recommend/Text_RecommendedLevel")
	self.mText_Times = self:GetText("BGImage/Trans_DailyTimes/Text_Times")
	self.mTrans_ChallengePanel = self:GetRectTransform("BGImage/Trans_ChallengePanel")
	self.mTrans_ChallengeLayout = self:GetRectTransform("BGImage/Trans_ChallengePanel/Trans_ChallengeLayout")
	self.mTrans_EnemyInfo = self:GetRectTransform("BGImage/Trans_EnemyInfo")
	self.mTrans_EnemyInfoLayout = self:GetRectTransform("BGImage/Trans_EnemyInfo/Trans_EnemyInfo/Trans_EnemyInfoLayout")
	self.mTrans_DropPanel = self:GetRectTransform("BGImage/Trans_DropPanel")
	--self.mTrans_LabelFirstDrop = self:GetRectTransform("BGImage/Trans_DropPanel/Trans_LabelFirstDrop")
	--self.mTrans_LabelNormalDrop = self:GetRectTransform("BGImage/Trans_DropPanel/Trans_LabelNormalDrop")
	self.mTrans_DropList = self:GetRectTransform("BGImage/Trans_DropPanel/Trans_DropList")
	self.mTrans_DropListLayout = self:GetRectTransform("BGImage/Trans_DropPanel/Trans_DropList/Trans_DropListLayout")
	self.mTrans_DailyTimes = self:GetRectTransform("BGImage/Trans_DailyTimes")
	self.mTrans_RaidButton_locked = self:GetRectTransform("BGImage/BottomPanel/UI_Btn_RaidButton/Trans_locked")
	self.mText_Describe = self:GetText("BGImage/Trans_DescribePanel/Text_Describe")
	self.mTrans_DescribePanel = self:GetRectTransform("BGImage/Trans_DescribePanel")
	-- self.mImage_RecommendBg = self:GetImage("BGImage/TopLayout/Trans_StageInfo/UI_Recommend/RecommendBg")
	self.mTrans_DropListNone = self:GetRectTransform("BGImage/Trans_DropPanel/Trans_DropList/Trans_NoDrop")
	self.mTrans_StageInfo = self:GetRectTransform("BGImage/TopLayout/Trans_StageInfo")
	self.mTrans_GoNow = self:GetButton("BGImage/BottomPanel/Btn_GotoNow")
    self.mTrans_CanBattle = self:GetRectTransform("BGImage/BottomPanel/Btn_Go/Trans_Can")
	self.mTrans_CantBattle = self:GetRectTransform("BGImage/BottomPanel/Btn_Go/Trans_Cant")
	self.mTrans_LockBattle = self:GetRectTransform("BGImage/BottomPanel/Btn_Go/Trans_Lock")
    self.mTrans_CantWatch = self:GetRectTransform("BGImage/BottomPanel/Btn_Watch/Trans_Cant")
    self.mTrans_CanWatch = self:GetRectTransform("BGImage/BottomPanel/Btn_Watch/Trans_Can")
    self.mTrans_LockWatch = self:GetRectTransform("BGImage/BottomPanel/Btn_Watch/Trans_Lock")
	self.mTrans_Finish = self:GetRectTransform("BGImage/BottomPanel/Btn_Fin")
	self.mTrans_AutoBattle = self:GetRectTransform("BGImage/BottomPanel/Trans_AutoBattle")
	self.mTrans_CanAutoBattle = self:GetRectTransform("BGImage/BottomPanel/Trans_AutoBattle/Trans_Can")
	self.mTrans_CantAutoBattle = self:GetRectTransform("BGImage/BottomPanel/Trans_AutoBattle/Trans_Cant")
end

--@@ GF Auto Gen Block End

--UI路径
UICombatLauncherPanelItem.mPath_EnemyInfoItem = "CombatLauncher/UICombatLauncher_EnemyInfoItem.prefab"
UICombatLauncherPanelItem.mPath_ChallengeItem = "CombatLauncher/UICombatLauncher_ChallengeItem.prefab"
UICombatLauncherPanelItem.mPath_DropListItem = "UICommonFramework/UICommonItemS.prefab"
--数据
UICombatLauncherPanelItem.mStageData = nil
UICombatLauncherPanelItem.mStageRecord = nil
UICombatLauncherPanelItem.mStageConfig = nil
UICombatLauncherPanelItem.mStoryData = nil

UICombatLauncherPanelItem.mIsHard = false
UICombatLauncherPanelItem.mType = 0
UICombatLauncherPanelItem.mCanBattle = true

UICombatLauncherPanelItem.mTier =0; --秘境层级
UICombatLauncherPanelItem.mPhase =0; --秘境阶段
UICombatLauncherPanelItem.mDifficult =0; --秘境难度

UICombatLauncherPanelItem.NormalColor = CS.GF2.UI.UITool.StringToColor("09A0EB")
UICombatLauncherPanelItem.HardColor = CS.GF2.UI.UITool.StringToColor("FF1940")

UICombatLauncherPanelItem.LauncherType =
{
	Chapter = 1,    --- 章节
	SimCombat = 2,  --- 模拟作战
	Training = 3,   --- 爬塔本
	Weekly = 4,     --- 周常本
	Story = 5,      --- 剧情点
}

function UICombatLauncherPanelItem:InitCtrl(root, sort)
	self:SetRoot(root)
	self:__InitCtrl()

	if sort then
		self:AddCanvas(sort)
	end
end

function UICombatLauncherPanelItem:InitChapterData(stageData, stageRecord, storyData, isHard, isCanBattle)
	self.mType = storyData.type == GlobalConfig.StoryType.Story and UICombatLauncherPanelItem.LauncherType.Story or UICombatLauncherPanelItem.LauncherType.Chapter
	self.mStageData = stageData
	self.mStoryData = storyData
	self.mStageRecord = stageRecord
	self.mIsHard = isHard
	self.mCanBattle = isCanBattle
	self.mStageConfig = TableData.GetStageConfigData(self.mStageData.stage_config)
	self.isFirst = self.mStageRecord.first_pass_time <= 0

	self.mText_StageNumber.text = storyData.code
	self.mText_StageNameInfo.text = storyData.name.str
	setactive(self.mImage_SpecialMarkIcon.gameObject, storyData.type ~= GlobalConfig.StoryType.Story)
	setactive(self.mImage_StoryCover.gameObject, storyData.type == GlobalConfig.StoryType.Story)
	setactive(self.mBtn_Watch.gameObject, storyData.type == GlobalConfig.StoryType.Story)
	setactive(self.mBtn_Go.gameObject, storyData.type ~= GlobalConfig.StoryType.Story)
	setactive(self.mText_StageType.gameObject, storyData.type == GlobalConfig.StoryType.Normal)
	if storyData.type == GlobalConfig.StoryType.Story then
		self.mImage_StoryCover.sprite = ResSys:GetChapterMapBG(storyData.cover)

		UIUtils.GetButtonListener(self.mBtn_Watch.gameObject).onClick = function()
			self:OnBtnWatch()
		end

        setactive(self.mTrans_CanWatch, self.mCanBattle)
        setactive(self.mTrans_CantWatch, not self.mCanBattle)
        setactive(self.mTrans_LockWatch, not self.mCanBattle)
	else
		UIUtils.GetButtonListener(self.mBtn_Go.gameObject).onClick = function()
			self:OnBtnGoClick()
		end
        setactive(self.mTrans_CanBattle, self.mCanBattle)
        setactive(self.mTrans_CantBattle, not self.mCanBattle)
        setactive(self.mTrans_LockBattle, not self.mCanBattle)
	end
	self:InitPanel()

	setactive(self.mUIRoot,true)
end

function UICombatLauncherPanelItem:InitSimCombatData(stageData, stageRecord, simData, isCanBattle)
	self.mType = UICombatLauncherPanelItem.LauncherType.SimCombat
	self.mStageData = stageData
	self.mStageRecord = stageRecord
	self.mIsHard = true
	self.mCanBattle = isCanBattle
	self.mStageConfig =  TableData.GetStageConfigData(self.mStageData.stage_config)
	self.isFirst = self.mStageRecord.first_pass_time <= 0

	setactive(self.mUIRoot,true)
	UIUtils.GetButtonListener(self.mBtn_Go.gameObject).onClick = function()
		self:OnBtnGoClick()
	end

	self.mText_StageNumber.text = tonumber(simData.sequence) < 10 and ("0" .. simData.sequence) or simData.sequence
	self.mText_StageNameInfo.text = self.mStageData.name.str

	setactive(self.mTrans_CanBattle, self.mCanBattle)
	setactive(self.mTrans_CantBattle, not self.mCanBattle)
	setactive(self.mTrans_LockBattle, not self.mCanBattle)

	self:InitPanel()
end

function UICombatLauncherPanelItem:InitSimCombatMythicData(stageData, stageRecord, isCanBattle, tier, phase, difficult)
	self.mType = UICombatLauncherPanelItem.LauncherType.SimCombat
	self.mStageData = stageData
	self.mStageRecord = stageRecord
	self.mIsHard = true
	self.mCanBattle = isCanBattle
	self.mStageConfig = TableData.GetStageConfigData(self.mStageData.stage_config)
	self.isFirst = self.mStageRecord.first_pass_time <= 0
	self.mTier = tier
	self.mPhase = phase
	self.mDifficult = difficult

	setactive(self.mUIRoot, true)
	UIUtils.GetButtonListener(self.mBtn_Go.gameObject).onClick = function()
		self:OnBtnGoClick()
	end

	--self.mText_StageNumber.text = tonumber(simData.sequence) < 10 and ("0" .. simData.sequence) or simData.sequence

	self.mText_StageNameInfo.text = self.mStageData.name.str

	setactive(self.mBtn_Go, self.mCanBattle)

	self:InitPanel()

end

function UICombatLauncherPanelItem:InitSimTrainingData(stageData, stageRecord, simData, canBattle, isFhinsh, goNowFun)
	self.mType = UICombatLauncherPanelItem.LauncherType.Training
	self.mStageData = stageData
	self.mStageRecord = stageRecord
	self.mIsHard = true
	self.mCanBattle = canBattle

	self.mStageConfig =  TableData.GetStageConfigData(self.mStageData.stage_config);
	self.isFirst = self.mStageRecord.first_pass_time <= 0;
	setactive(self.mUIRoot,true);
	if not canBattle then
		UIUtils.GetButtonListener(self.mTrans_GoNow.gameObject).onClick = function()
			goNowFun()
		end
	else
		UIUtils.GetButtonListener(self.mBtn_Go.gameObject).onClick = function()
			self:OnBtnGoClick();
		end
	end

	self.mText_StageNumber.text = tonumber(simData.id) < 10 and ("0" .. simData.id) or simData.id
	self.mText_StageNameInfo.text = self.mStageData.name.str

	setactive(self.mBtn_Go, self.mCanBattle and not isFhinsh)
	setactive(self.mTrans_GoNow, not self.mCanBattle and not isFhinsh)
	-- setactive(self.mTrans_Finish, isFhinsh)

	self:InitPanel();
end

function UICombatLauncherPanelItem:InitSimWeeklyData(stageData, stageRecord, weeklyId, index)
	self.mType = UICombatLauncherPanelItem.LauncherType.Weekly
	self.mStageData = stageData
	self.mStoryData = weeklyId
	self.mStageRecord = stageRecord
	self.mStageConfig = TableData.GetStageConfigData(self.mStageData.stage_config)

	self.isFirst = self.mStageRecord.first_pass_time <= 0
	setactive(self.mUIRoot,true)
	UIUtils.GetButtonListener(self.mBtn_Go.gameObject).onClick = function()
		self:OnBtnGoClick()
	end

	self.mText_StageNumber.text = index
	self.mText_StageNameInfo.text = self.mStageData.name.str

	setactive(self.mBtn_Go, self.mCanBattle)
	self:InitPanel()
end

function UICombatLauncherPanelItem:InitPanel()
	self:InitContentByType()
	self:InitEnemyInfoList()

	self.mText_Recommend_RecommendedLevel.text = self.mStageData.recommanded_playerlevel

	self.mImage_Stamina_StaminaIcon.sprite = IconUtils.GetItemIconSprite(self.mStageData.cost_item)
	self.mText_Stamina_StaminaCost.text = self.mStageData.stamina_cost
	self:UpdateStaminaInfo()

	self.mImage_SpecialMarkIcon.sprite = IconUtils.GetStageSpecialMarkIcon(self.mStageData.special_mark)
	-- self.mImage_RecommendBg.color = self.mIsHard and UICombatLauncherPanelItem.HardColor or UICombatLauncherPanelItem.NormalColor

	--setactive(self.mTrans_LabelNormalDrop.gameObject,not self.isFirst)
	--setactive(self.mTrans_LabelFirstDrop.gameObject, self.isFirst)
	self:InitDropList()

	--挂机
	setactive(self.mTrans_AutoBattle, self.mStageData.CanAuto)
	if self.mStageData.CanAuto then
		setactive(self.mTrans_CanAutoBattle.gameObject, AFKBattleManager:CheckCanAuto(self.mStageData))
		setactive(self.mTrans_CantAutoBattle.gameObject, not AFKBattleManager:CheckCanAuto(self.mStageData))
	end

	--扫荡
	--if self.mStageData.CanRaid then
	--	setactive(self.mBtn_RaidButton.gameObject, true)
	--	if (AFKBattleManager:CheckCanRaid(self.mStageData)) then
	--		setactive(self.mTrans_RaidButton_locked.gameObject,false)
	--	else
	--		setactive(self.mTrans_RaidButton_locked.gameObject,true)
	--	end
	--else
	--	setactive(self.mBtn_RaidButton.gameObject, false)
	--end
end

function UICombatLauncherPanelItem:UpdateStaminaInfo()
	local itemCount = NetCmdItemData:GetItemCountById(self.mStageData.cost_item)
	self.mText_Stamina_StaminaCost.color = itemCount < self.mStageData.stamina_cost and ColorUtils.RedColor or ColorUtils.WhiteColor
    if self.mType == UICombatLauncherPanelItem.LauncherType.Story then
        setactive(self.mTrans_CanWatch, itemCount >= self.mStageData.stamina_cost)
        setactive(self.mTrans_CantWatch, not self.mCanBattle or itemCount < self.mStageData.stamina_cost)
    elseif self.mType == UICombatLauncherPanelItem.LauncherType.Chapter then
        setactive(self.mTrans_CanBattle, itemCount >= self.mStageData.stamina_cost)
        setactive(self.mTrans_CantBattle, not self.mCanBattle or itemCount < self.mStageData.stamina_cost)
    end
end

function UICombatLauncherPanelItem:InitContentByType()
	setactive(self.mTrans_ChallengePanel.gameObject, self.mType == UICombatLauncherPanelItem.LauncherType.Chapter or self.mType == UICombatLauncherPanelItem.LauncherType.SimCombat)
	setactive(self.mTrans_EnemyInfo.gameObject, self.mType ~= UICombatLauncherPanelItem.LauncherType.Story)
	setactive(self.mTrans_StageInfo, self.mType ~= UICombatLauncherPanelItem.LauncherType.Story)
	setactive(self.mTrans_DescribePanel.gameObject, self.mType == UICombatLauncherPanelItem.LauncherType.Story or self.mType == UICombatLauncherPanelItem.LauncherType.Training)

	--- 是章节Icon还是模拟作战Icon
	if self.mType == UICombatLauncherPanelItem.LauncherType.Chapter or self.mType == UICombatLauncherPanelItem.LauncherType.SimCombat then
		local challenge_list = self.mStageData.challenge_list
		if challenge_list.Count > 0 and self.mStageData.challenge_list ~= "" then
			self:InitChallengeList(challenge_list)
			setactive(self.mTrans_ChallengeLayout.gameObject, true)
		else
			setactive(self.mTrans_ChallengeLayout.gameObject, false)
		end
	elseif self.mType == UICombatLauncherPanelItem.LauncherType.Story or self.mType == UICombatLauncherPanelItem.LauncherType.Training then
		self.mText_Describe.text = self.mStageData.synopsis.str
	end

end

--敌人列表
function UICombatLauncherPanelItem:InitEnemyInfoList()
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_EnemyInfoItem,self)
	clearallchild(self.mTrans_EnemyInfoLayout.transform)
	if self.mStageConfig ~= nil then
		for idx = 0,self.mStageConfig.enemies.Length - 1 do
			local enemy_id = self.mStageConfig.enemies[idx]
			local enemyData = TableData.GetEnemyData(enemy_id)
			--local role_template = TableData.GetRoleTemplateData(enemyData.role_template_id)
			local instObj = instantiate(itemPrefab)
			local item = UICombatLauncherEnemyInfoItem.New()
			item:InitCtrl(instObj.transform)

			if self.mStageData.type == 12 then
				--秘境怪物等级特殊显示
				local mythicMainData = TableData.listSimCombatMythicMainDatas:GetDataById(self.mTier);
				--local curStageData = TableData.listSimCombatMythicStageDatas:GetDataById(tonumber(self.mPhase));
				local mythicBosslevel = 0;
				if NetCmdSimulateBattleData:IsBossStage() then
					mythicBosslevel = tonumber(mythicMainData.LevelList[self.mPhase]) --boss 关卡
				else
					mythicBosslevel = tonumber(mythicMainData.LevelList[self.mPhase]) + TableData.GlobalSystemData.MythicLevelArgs[self.mDifficult - 1]
				end

				item:InitData(enemyData, mythicBosslevel - enemyData.add_level)
			else
				item:InitData(enemyData, self.mStageData.stage_class)
			end
			

			UIUtils.GetButtonListener(item.mBtn_OpenDetail.gameObject).onClick = function()
				self:OnClickEnemy(enemy_id)
			end
			UIUtils.AddListItem(instObj,self.mTrans_EnemyInfoLayout.transform)
		end
	else
		gferror( "StageID:" .. self.mStageData.id .. "本关卡找不到对应的StageConfig 请确定是否生成配置并上传！")
	end
end

--挑战列表
function UICombatLauncherPanelItem:InitChallengeList(challenge_list)
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_ChallengeItem,self)
	clearallchild(self.mTrans_ChallengeLayout.transform)
	local complete_challenge = {}
	for i =0,self.mStageRecord.complete_challenge.Length - 1 do
		complete_challenge[self.mStageRecord.complete_challenge[i]] = true
	end

	for i = 0, challenge_list.Count - 1 do
		local challenge_id = challenge_list[i]
		local instObj = instantiate(itemPrefab)
		local item = UICombatLauncherChallengeItem.New()
		item:InitCtrl(instObj.transform)
		item:InitData(challenge_id,complete_challenge[i] or false)
		UIUtils.AddListItem(instObj,self.mTrans_ChallengeLayout.transform)
	end
end

--掉落列表
function UICombatLauncherPanelItem:InitDropList()
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_DropListItem,self)
	clearallchild(self.mTrans_DropListLayout.transform)
	local droplist = {}
	if self.isFirst then
		local prizes = self.mStageData.first_reward
		local itemList = self:GetItemSort(prizes)
		for _, value in ipairs(itemList) do
			table.insert(droplist,{item_id = value, item_num = prizes[value], isFirst = true})
		end
	end

	local normal_drop_list = self.mStageData.normal_drop_view_list
	for i = 0,normal_drop_list.Count - 1 do
		table.insert(droplist,{item_id = normal_drop_list[i],item_num = nil, isFirst = false})
	end

	for _, dropItem in ipairs(droplist) do
		local instObj = instantiate(itemPrefab)
		local item = UICommonItemS.New()
		item:InitCtrl(instObj.transform)
		item:InitData(dropItem.item_id, dropItem.item_num)
		item:SetFirstDrop(dropItem.isFirst)
		UIUtils.AddListItem(instObj,self.mTrans_DropListLayout.transform)
	end

    setactive(self.mTrans_DropListNone, #droplist <= 0)
	setactive(self.mTrans_DropListLayout, #droplist > 0)
end

--出击
function UICombatLauncherPanelItem:OnBtnGoClick(gameObj)
	if self.mType == UICombatLauncherPanelItem.LauncherType.Training then   --- 爬塔本判断门票
		if not TipsManager.CheckTrainingCountIsEnough(self.mStageData.stamina_cost) then
			return
		elseif TipsManager.CheckRepositoryIsFull() then
			return
		end
	else			--- 一般的模式判断体力
		if not TipsManager.CheckStaminaIsEnough(self.mStageData.stamina_cost) then
			return
		elseif TipsManager.CheckRepositoryIsFull() then
			return
		end
	end

	if self.mType == UICombatLauncherPanelItem.LauncherType.Weekly then
		SceneSys:OpenBattleSceneForWeekly(self.mStageData, self.mStoryData)
	else
		if self.mType == UICombatLauncherPanelItem.LauncherType.Chapter or self.mType == UICombatLauncherPanelItem.LauncherType.SimCombat then
			if not self.mCanBattle then
				CS.PopupMessageManager.PopupString(TableData.GetHintById(608))
				return
			end
            if self.mStoryData then
                UIChapterPanel.recordStoryId = self.mStoryData.id
            end
		end

		SceneSys:OpenBattleSceneForChapter(self.mStageData, self.mStageRecord)
	end
end

function UICombatLauncherPanelItem:OnBtnWatch()
	if self.mCanBattle then
		if self.mType == UICombatLauncherPanelItem.LauncherType.Story then
			CS.AVGController.PlayAVG(self.mStageData.id, 1, function ()
				BattleNetCmdHandler:RequestStageStart(self.mStageData.id, nil)
			end)
		end
	end
end

function UICombatLauncherPanelItem:OnClickEnemy(id)
	UIUnitInfoPanel.Open(UIUnitInfoPanel.ShowType.Enemy, id, self.mStageData.stage_class)
end

function UICombatLauncherPanelItem:Close()
	setactive(self.mUIRoot,false)
end

function  UICombatLauncherPanelItem.OnBoxConfirm()
	UIManager.OpenUIByParam(UIDef.UICommonGetPanel)
end

function UICombatLauncherPanelItem:GetItemSort(prizes)
	local itemIdList = {}
	if prizes then
		for key, v in pairs(prizes) do
			table.insert(itemIdList, key)
		end

		table.sort(itemIdList, function (a, b)
			local data1 = TableData.listItemDatas:GetDataById(a)
			local data2 = TableData.listItemDatas:GetDataById(b)
			local typeOrder1 = self:GetItemTypeOrder(data1.type)
			local typeOrder2 = self:GetItemTypeOrder(data2.type)
			if typeOrder1 == typeOrder2 then
				if data1.rank == data2.rank then
					return data1.id > data2.id
				end
				return data1.rank > data2.rank
			end
			return typeOrder1 < typeOrder2
		end)
	end

	return itemIdList
end

function UICombatLauncherPanelItem:GetItemTypeOrder(type)
	if type then
		local list = TableData.GlobalSystemData.LauncherItemType
		for i = 0, list.Length-1 do
			if list[i] == type then
				return i
			end
		end
	end
	return -1
end