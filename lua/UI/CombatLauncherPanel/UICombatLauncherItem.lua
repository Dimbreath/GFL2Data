require("UI.UIBaseCtrl")

UICombatLauncherItem = class("UICombatLauncherItem", UIBaseCtrl)
UICombatLauncherItem.__index = UICombatLauncherItem

UICombatLauncherItem.LauncherType =
{
	Chapter       = 1,     --- 章节
	SimCombat     = 2,     --- 模拟作战
	Training      = 3,     --- 爬塔本
	Weekly        = 4,     --- 周常本
	Story         = 5,     --- 剧情点
	HideStory     = 6,     --- 隐藏关卡
}

function UICombatLauncherItem:ctor()
	self.type = 0
	self.stageData = nil
	self.stageRecord = nil
	self.stageConfig = nil
	self.storyData = nil
	self.customData = nil
	self.costItemNum = 0
	self.topCurrency = nil
	self.canBattle = true
	self.isFirst = false

	self.enemyList = {}
	self.dropList = {}
	self.firstDropList = {}
	self.challengeList = {}
	self.mTier = 0
	self.mPhase = 0
	self.mDifficult = 0
end

function UICombatLauncherItem:__InitCtrl()
	self.mBtn_Start = self:GetButton("Root/GrpRight/GrpAction/BtnStart/Btn_Start")
	self.mBtn_Close = self:GetButton("Root/Btn_Close")
	self.mBtn_Raid = self:GetButton("Root/GrpRight/GrpAction/Trans_BtnRaid/ComBtn3ItemV2")
	self.mBtn_CantRaid = self:GetButton("Root/GrpRight/GrpAction/Trans_BtnRaidLocked/ComBtn4DisabledItemV2")

	self.mTrans_Desc = self:GetRectTransform("Root/GrpRight/GrpEmenyInfoRewardList/Viewport/Content/Trans_GrpTextDescription")
	self.mTrans_Num = self:GetRectTransform("Root/GrpRight/GrpTextTittle/GrpLayer")
	self.mText_Name = self:GetText("Root/GrpRight/GrpTextTittle/GrpText/Text_NameLayer")
	self.mText_Num = self:GetText("Root/GrpRight/GrpTextTittle/GrpLayer/Text_NumLayer")
	self.mText_Level = self:GetText("Root/GrpRight/GrpTextTittle/GrpText/Text_Level")
	self.mText_Desc = self:GetText("Root/GrpRight/GrpEmenyInfoRewardList/Viewport/Content/Trans_GrpTextDescription/TextDescription")
	self.mText_CostHint = self:GetText("Root/GrpRight/GrpConsume/GrpConsume/Text")

	self.mTrans_ChallengeContent = self:GetRectTransform("Root/GrpRight/GrpEmenyInfoRewardList/Viewport/Content/Trans_GrpTextTarget")
	self.mTrans_EnemyContent = self:GetRectTransform("Root/GrpRight/GrpEmenyInfoRewardList/Viewport/Content/GrpTextEnemy")
	self.mTrans_DropContent = self:GetRectTransform("Root/GrpRight/GrpEmenyInfoRewardList/Viewport/Content/GrpTextItem")
	self.mTrans_FirstDropContent = self:GetRectTransform("Root/GrpRight/GrpEmenyInfoRewardList/Viewport/Content/Trans_GrpFirstTextItem")
	self.mTrans_FirstDropList = self:GetRectTransform("Root/GrpRight/GrpEmenyInfoRewardList/Viewport/Content/Trans_ItemFirstDropList")

	self.mTrans_ChallengeList = self:GetRectTransform("Root/GrpRight/GrpEmenyInfoRewardList/Viewport/Content/Trans_TargetList")
	self.mTrans_EnemyList = self:GetRectTransform("Root/GrpRight/GrpEmenyInfoRewardList/Viewport/Content/EnemyInfoList/Content")
	self.mTrans_DropList = self:GetRectTransform("Root/GrpRight/GrpEmenyInfoRewardList/Viewport/Content/ItemDropList/Content")
	self.mTrans_FirstDropListContent = self:GetRectTransform("Root/GrpRight/GrpEmenyInfoRewardList/Viewport/Content/Trans_ItemFirstDropList/Content")

	self.mTrans_Start = self:GetRectTransform("Root/GrpRight/GrpAction/BtnStart")
	self.mTrans_Lock = self:GetRectTransform("Root/GrpRight/GrpAction/Trans_Locked")
	self.mTrans_UnLock = self:GetRectTransform("Root/GrpRight/GrpAction/Trans_UnLocked")
	self.mText_LockDesc = self:GetText("Root/GrpRight/GrpAction/Trans_Locked/Text_Name")
	self.mText_UnLockDesc = self:GetText("Root/GrpRight/GrpAction/Trans_UnLocked/Text_Name")
	self.mText_BattleHint = self:GetText("Root/GrpRight/GrpAction/BtnStart/Btn_Start/Root/GrpText/Text_Name")

	self.mTrans_Stamina = self:GetRectTransform("Root/GrpRight/GrpConsume")
	self.mImage_StaminaIcon = self:GetImage("Root/GrpRight/GrpConsume/GrpConsume/Img_Icon")
	self.mText_StaminaCost = self:GetText("Root/GrpRight/GrpConsume/GrpConsume/Text_Describe")

	self.mTrans_RaidBattle = self:GetRectTransform("Root/GrpRight/GrpAction/Trans_BtnRaid")
	self.mTrans_LockRaidBattle = self:GetRectTransform("Root/GrpRight/GrpAction/Trans_BtnRaidLocked")

	self.mTrans_TopCurrency = self:GetRectTransform("Root/GrpTop/GrpCurrency")

	UIUtils.GetButtonListener(self.mBtn_CantRaid.gameObject).onClick = function()
		UIUtils.PopupHintMessage(233)
	end
end

function UICombatLauncherItem:InitCtrl(parent, sort)
	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComDetailsPanelV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()

	if sort then
		self:AddCanvas(sort)
		self.raycaster = UIUtils.GetGraphicRaycaster(self.mUIRoot)
	end
end

function UICombatLauncherItem:InitData(stageData, stageRecord, isCanBattle)
	self.stageData = stageData
	self.stageRecord = stageRecord
	self.canBattle = isCanBattle
	self.isFirst = self.stageData.first_reward.Count > 0 and self.stageRecord.first_pass_time <= 0
	self.stageConfig = TableData.GetStageConfigData(self.stageData.stage_config)
	if self.stageData.cost_item > 0 then
		self.costItemNum = NetCmdItemData:GetItemCountById(self.stageData.cost_item)
	else
		self.costItemNum = 0
	end
end

function UICombatLauncherItem:InitSimTutorialData(teachingData, stageRecord, isCanBattle)
	self.stageData = teachingData.StageData
	self.stageRecord = stageRecord
	self.canBattle = isCanBattle
	self.isFirst = not teachingData.IsCompleted
	self.stageConfig = TableData.GetStageConfigData(self.stageData.stage_config)
	if self.stageData.cost_item > 0 then
		self.costItemNum = NetCmdItemData:GetItemCountById(self.stageData.cost_item)
	else
		self.costItemNum = 0
	end
end

function UICombatLauncherItem:InitChapterData(stageData, stageRecord, storyData, isCanBattle)
	if storyData.type == GlobalConfig.StoryType.Hide then
		self.type = UICombatLauncherItem.LauncherType.HideStory
	elseif storyData.type == GlobalConfig.StoryType.Story then
		self.type = UICombatLauncherItem.LauncherType.Story
	else
		self.type = UICombatLauncherItem.LauncherType.Chapter
	end
	self.storyData = storyData
	self:InitData(stageData, stageRecord, isCanBattle)

	if self.canBattle then
		if storyData.type == GlobalConfig.StoryType.Hard and NetCmdDungeonData:DailyTimes(self.storyData.id) == storyData.daily_times then
			self.canBattle = false
			self.mText_LockDesc.text = TableData.GetHintById(103001)
		end
	else
		self.mText_LockDesc.text = TableData.GetHintById(24)
	end


	setactive(self.mTrans_Start, self.canBattle)
	setactive(self.mTrans_Lock, not self.canBattle)
	setactive(self.mTrans_UnLock, false)

	self:UpdatePanel()

	UIUtils.GetButtonListener(self.mBtn_Start.gameObject).onClick = function()
		self:OnBtnGoClick()
	end

	UIUtils.GetButtonListener(self.mBtn_Raid.gameObject).onClick = function()
		self:OnRaidClick()
	end
end

function UICombatLauncherItem:InitSimCombatResourceData(stageData, stageRecord, simData, isCanBattle, ticketCount)
	self.type = UICombatLauncherItem.LauncherType.SimCombat
	self.simData = simData
	self:InitData(stageData, stageRecord, isCanBattle)
	local sequence = simData.id % 100

	self.mText_Num.text = sequence < 10 and ("0" .. sequence) or sequence
	if not self.canBattle then
		self.mText_LockDesc.text = TableData.GetHintById(24)
	else
		if simData.unlock_level > AccountNetCmdHandler:GetLevel() then
			self.canBattle = false
			self.mText_LockDesc.text = string_format(TableData.GetHintById(103006), simData.unlock_level)
		else
			if ticketCount == 0 then
				self.canBattle = false
				self.mText_LockDesc.text = TableData.GetHintById(103007)
			end
		end
	end

	setactive(self.mTrans_Start, self.canBattle)
	setactive(self.mTrans_Lock, not self.canBattle)
	setactive(self.mTrans_UnLock, false)

	self:UpdatePanel()

	UIUtils.GetButtonListener(self.mBtn_Start.gameObject).onClick = function()
		self:OnBtnGoClick()
	end
end

function UICombatLauncherItem:RefreshTimes(ticketCount)
	if ticketCount == 0 then
		self.canBattle = false
		self.mText_LockDesc.text = TableData.GetHintById(103007)
	end
	setactive(self.mTrans_Start, self.canBattle)
	setactive(self.mTrans_Lock, not self.canBattle)
	setactive(self.mTrans_UnLock, false)

	self:UpdatePanel()
end

function UICombatLauncherItem:InitSimCombatData(stageData, stageRecord, simData, isCanBattle)
	self.type = UICombatLauncherItem.LauncherType.SimCombat
	self.simData = simData
	self:InitData(stageData, stageRecord, isCanBattle)
	local sequence = 0;
	if simData.sequence == nil then
		sequence = simData.id % 100
	else
		sequence = tonumber(simData.sequence)
	end
	self.mText_Num.text = sequence < 10 and ("0" .. sequence) or sequence
	self.mText_LockDesc.text = TableData.GetHintById(24)

	setactive(self.mTrans_Start, isCanBattle)
	setactive(self.mTrans_Lock, not isCanBattle)
	setactive(self.mTrans_UnLock, false)

	self:UpdatePanel()

	UIUtils.GetButtonListener(self.mBtn_Start.gameObject).onClick = function()
		self:OnBtnGoClick()
	end
end

function UICombatLauncherItem:InitSimCombatMythicData(stageData, stageRecord, simData, isCanBattle, tier, phase,difficult)
	self.mTier = tier;
	self.mPhase = phase;
	self.mDifficult = difficult
	self.type = UICombatLauncherItem.LauncherType.SimCombat
	self.simData = simData
	self:InitData(stageData, stageRecord, isCanBattle)
	local sequence = 0;
	--[[	if simData.sequence == nil then
	sequence = simData.id % 100
	else
	sequence = tonumber(simData.sequence)
	end]]
	--self.mText_Num.text = sequence < 10 and ("0" .. sequence) or sequence
	self.mText_LockDesc.text = TableData.GetHintById(24)

	setactive(self.mTrans_Start, isCanBattle)
	setactive(self.mTrans_Lock, not isCanBattle)
	setactive(self.mTrans_UnLock, false)

	self:UpdatePanel()

	UIUtils.GetButtonListener(self.mBtn_Start.gameObject).onClick = function()
		self:OnBtnGoClick()
	end
end

function UICombatLauncherItem:InitSimTrainingData(stageData, stageRecord, simData, maxLevel)
	self.type = UICombatLauncherItem.LauncherType.Training
	self:InitData(stageData, stageRecord, true)

	self.mText_Num.text = tonumber(simData.id) < 10 and ("0" .. simData.id) or simData.id
	self.mText_LockDesc.text = TableData.GetHintById(24)
	self.mText_UnLockDesc.text = TableData.GetHintById(25)

	local isLock = simData.id > maxLevel + 1
	local isUnLock = simData.id <= maxLevel
	local isCurrent = simData.id == maxLevel + 1

	setactive(self.mTrans_Start, isCurrent)
	setactive(self.mTrans_UnLock, isUnLock)
	setactive(self.mTrans_Lock, isLock)

	self:UpdatePanel()

	UIUtils.GetButtonListener(self.mBtn_Start.gameObject).onClick = function()
		self:OnBtnGoClick()
	end
end

function UICombatLauncherItem:InitSimTeachingData(teachingData, stageRecord,isCanBattle)
	self.type = UICombatLauncherItem.LauncherType.SimCombat
	self:InitSimTutorialData(teachingData, stageRecord,isCanBattle)

	-- self.mText_Num.text = tonumber(simData.id) < 10 and ("0" .. simData.id) or simData.id
	-- self.mText_LockDesc.text = TableData.GetHintById(24)
	-- self.mText_UnLockDesc.text = TableData.GetHintById(25)

	-- local isLock = simData.id > maxLevel + 1
	-- local isUnLock = simData.id <= maxLevel
	-- local isCurrent = simData.id == maxLevel + 1

	-- setactive(self.mTrans_Start, isCurrent)
	-- setactive(self.mTrans_UnLock, isUnLock)
	-- setactive(self.mTrans_Lock, isLock)

	self:UpdatePanel()

	UIUtils.GetButtonListener(self.mBtn_Start.gameObject).onClick = function()
		self:OnBtnGoClick()
	end
end

function UICombatLauncherItem:InitSimWeeklyData(stageData, stageRecord, weeklyId)
	self.type = UICombatLauncherItem.LauncherType.Weekly
	self.customData = weeklyId
	self:InitData(stageData, stageRecord, true)

	self:UpdatePanel()

	UIUtils.GetButtonListener(self.mBtn_Start.gameObject).onClick = function()
		self:OnBtnGoClick()
	end
end

function UICombatLauncherItem:UpdatePanel()
	self.mText_Name.text = self.stageData.name.str
	self.mText_Level.text = self.stageData.recommanded_playerlevel
	self.mText_Desc.text = self.stageData.synopsis.str
	if self.type == UICombatLauncherItem.LauncherType.Story then
		self.mText_BattleHint.text = TableData.GetHintById(27)
	else
		self.mText_BattleHint.text = TableData.GetHintById(26)
	end


	setactive(self.mTrans_Num, self.type == UICombatLauncherItem.LauncherType.Training)
	setactive(self.mTrans_EnemyContent, self.type ~= UICombatLauncherItem.LauncherType.Story)
	setactive(self.mTrans_ChallengeContent,  self.stageData.challenge_list.Count > 0)
	setactive(self.mTrans_EnemyList, self.type ~= UICombatLauncherItem.LauncherType.Story)
	setactive(self.mTrans_ChallengeList, self.type ~= UICombatLauncherItem.LauncherType.Story and self.type ~= UICombatLauncherItem.LauncherType.Training and self.type ~= UICombatLauncherItem.LauncherType.HideStory)
	setactive(self.mTrans_Desc, true)

	self:UpdateChallengeList()
	self:UpdateEnemyList()
	self:UpdateDropItemList()
	self:UpdateStaminaInfo()
	self:UpdateRaidBattle()
	--self:UpdateTopStamina()
end

function UICombatLauncherItem:UpdateStaminaInfo()

	if self.stageData.cost_item > 0 then
		self.costItemNum = NetCmdItemData:GetItemCountById(self.stageData.cost_item)
	else
		self.costItemNum = 0
	end
	
	setactive(self.mTrans_Stamina,  self.stageData.cost_item > 0 and self.stageData.stamina_cost > 0)
	if self.stageData.cost_item > 0 then
		self.mImage_StaminaIcon.sprite = IconUtils.GetItemIconSprite(self.stageData.cost_item)
		self.mText_StaminaCost.text = self.stageData.stamina_cost
		self.mText_StaminaCost.color = self.costItemNum < self.stageData.stamina_cost and ColorUtils.RedColor or ColorUtils.BlackColor
		self.mText_CostHint.color =  self.costItemNum < self.stageData.stamina_cost and ColorUtils.RedColor or ColorUtils.BlackColor
	end
end

function UICombatLauncherItem:UpdateRaidBattle()
	if self:IsResourceSimBat() then
		setactive(self.mTrans_LockRaidBattle,   self.canBattle and self.stageData.CanRaid and not AFKBattleManager:CheckCanRaidSim(self.stageData))
		setactive(self.mTrans_RaidBattle, self.canBattle and self.stageData.CanRaid and AFKBattleManager:CheckCanRaidSim(self.stageData))
		UIUtils.GetButtonListener(self.mBtn_Raid.gameObject).onClick = function()
			self:OnRaidClick()
		end
	elseif self.type ~= UICombatLauncherItem.LauncherType.Training then
		setactive(self.mTrans_LockRaidBattle,   self.canBattle and self.stageData.CanRaid and not AFKBattleManager:CheckCanRaid(self.stageData))
		setactive(self.mTrans_RaidBattle, self.canBattle and self.stageData.CanRaid and AFKBattleManager:CheckCanRaid(self.stageData))
		UIUtils.GetButtonListener(self.mBtn_Raid.gameObject).onClick = function()
			self:OnRaidClick()
		end
	else
		setactive(self.mTrans_LockRaidBattle,   false)
		setactive(self.mTrans_RaidBattle, false)
	end
end

function UICombatLauncherItem:UpdateChallengeList()
	for _, challenge in ipairs(self.challengeList) do
		challenge:SetData(nil)
	end

	local complete_challenge = {}
	for i =0, self.stageRecord.complete_challenge.Length - 1 do
		complete_challenge[self.stageRecord.complete_challenge[i]] = true
	end

	for i = 0, self.stageData.challenge_list.Count - 1 do
		local item = self.challengeList[i + 1]
		local challenge_id =  self.stageData.challenge_list[i]
		if item == nil then
			item = UICombatLauncherChallengeItem.New()
			item:InitCtrl(self.mTrans_ChallengeList.transform)

			table.insert(self.challengeList, item)
		end
		item:SetData(challenge_id, complete_challenge[i] or false)
	end
end

function UICombatLauncherItem:UpdateEnemyList()
	for _, enemy in ipairs(self.enemyList) do
		enemy:SetData(nil)
	end

	if self.stageConfig ~= nil then
		local config = self.stageConfig
		for i = 0, config.enemies.Length - 1 do
			local enemyId = config.enemies[i]
			local enemyData = TableData.GetEnemyData(enemyId)

			local item = self.enemyList[i + 1]
			if item == nil then
				item = UICommonEnemyItem.New()
				item:InitCtrl(self.mTrans_EnemyList)
				table.insert(self.enemyList, item)
			end

			if self.stageData.type == 12 then
				--秘境怪物等级特殊显示
				local mythicMainData = TableData.listSimCombatMythicMainDatas:GetDataById(self.mTier)
				local mythicBosslevel = 0
				if NetCmdSimulateBattleData:IsBossStage() then
					mythicBosslevel = tonumber(mythicMainData.LevelList[self.mPhase])
				else
					mythicBosslevel = tonumber(mythicMainData.LevelList[self.mPhase]) + TableData.GlobalSystemData.MythicLevelArgs[self.mDifficult - 1]
				end

				item:SetData(enemyData, mythicBosslevel - enemyData.add_level)
			else
				item:SetData(enemyData, self.stageData.stage_class)
			end

			UIUtils.GetButtonListener(item.mBtn_OpenDetail.gameObject).onClick = function()
				self:OnClickEnemy(enemyId)
			end
		end
	end
end

function UICombatLauncherItem:UpdateDropItemList()
	local dropList = {}
	local firstDropList = {}

	for _, item in ipairs(self.dropList) do
		gfdestroy(item)
	end
	clearallchild(self.mTrans_DropList)

	for _, item in ipairs(self.firstDropList) do
		gfdestroy(item)
	end

	clearallchild(self.mTrans_FirstDropListContent)
	self.dropList = {}
	self.firstDropList = {}

	if self.isFirst then
		local prizes = self.stageData.first_reward
		local itemList = self:GetItemSort(prizes)
		for _, value in ipairs(itemList) do
			table.insert(firstDropList, {item_id = value, item_num = prizes[value], isFirst = true})
		end
	end

	local normalDropList = self.stageData.normal_drop_view_list
	for i = 0, normalDropList.Count - 1 do
		table.insert(dropList, {item_id = normalDropList[i], item_num = nil, isFirst = false})
	end

	for i, dropItem in ipairs(dropList) do
		local item  = self:GetAppropriateItem(dropItem.item_id, dropItem.item_num, dropItem.isFirst);
		table.insert(self.dropList, item)
		item:SetFirstDrop(dropItem.isFirst)
	end

	for i, dropItem in ipairs(firstDropList) do
		local item  = self:GetAppropriateItem(dropItem.item_id, dropItem.item_num, dropItem.isFirst);
		table.insert(self.firstDropList, item)
		--item:SetFirstDrop(dropItem.isFirst)
	end
	setactive(self.mTrans_FirstDropContent, self.isFirst)
	setactive(self.mTrans_FirstDropList, self.isFirst)
	setactive(self.mTrans_DropContent, #dropList > 0)
	setactive(self.mTrans_DropList, #dropList > 0)
end

function UICombatLauncherItem:GetAppropriateItem(itemId,itemNum, isFirst)

	local itemData = TableData.GetItemData(itemId)
	if itemData == nil then
		return nil;
	end

	local disableRaycaster = function() if self.raycaster then self.raycaster.enabled = false end end

	if itemData.type == 8 then --武器
		---@type UICommonWeaponInfoItem
		local weaponInfoItem = UICommonWeaponInfoItem.New()
		if isFirst then
			weaponInfoItem:InitCtrl(self.mTrans_FirstDropListContent)
		else
			weaponInfoItem:InitCtrl(self.mTrans_DropList)
		end
		weaponInfoItem:SetData(itemData.args[0], 0, disableRaycaster, true)

		return weaponInfoItem
	else
		---@type UICommonItem
		local itemView = UICommonItem.New();
		if isFirst then
			itemView:InitCtrl(self.mTrans_FirstDropListContent)
		else
			itemView:InitCtrl(self.mTrans_DropList)
		end
		if itemData.type == 5 then --模组
			local equipData = TableData.listGunEquipDatas:GetDataById(tonumber(itemData.args[0]))
			itemView:SetEquipData(itemData.args[0],0, nil,itemId)
		else
			itemView:SetItemData(itemId, itemNum, nil,nil,nil, nil, disableRaycaster)
		end

		return itemView;
	end
end

function UICombatLauncherItem:OnBtnGoClick()

	if self.type == UICombatLauncherItem.LauncherType.Training then
		--- 爬塔本判断门票
		if not TipsManager.CheckTrainingCountIsEnough(self.stageData.stamina_cost) then
			return
		elseif TipsManager.CheckRepositoryIsFull() then
			return
		end
	else
		--- 一般的模式判断体力
		if not TipsManager.CheckStaminaIsEnough(self.stageData.stamina_cost) then
			return
		elseif TipsManager.CheckRepositoryIsFull() then
			return
		end
	end

	if self.type == UICombatLauncherItem.LauncherType.Weekly then
		self:CheckFuelIsEnough(function() 
			SceneSys:OpenBattleSceneForWeekly(self.stageData, self.customData) end)
	elseif self.type == UICombatLauncherItem.LauncherType.Chapter or self.type == UICombatLauncherItem.LauncherType.SimCombat or self.type == UICombatLauncherItem.LauncherType.HideStory or self.type == UICombatLauncherItem.LauncherType.Training then
		if not self.canBattle then
			CS.PopupMessageManager.PopupString(TableData.GetHintById(608))
			return
		end
		if self.customData then
			UIChapterPanel.recordStoryId = self.customData.id
		end
		self:CheckFuelIsEnough(function()
			SceneSys:OpenBattleSceneForChapter(self.stageData, self.stageRecord)
		end)
	elseif self.type == UICombatLauncherItem.LauncherType.Story then
		if self.canBattle then
			CS.AVGController.PlayAVG(self.stageData.id, 1, function ()
					BattleNetCmdHandler:RequestStageStart(self.stageData.id, nil)
					if self.isFirst and self.stageData.first_reward.Count > 0 then
						NetCmdItemData:AddFirstDropDelegate()
					end
				end)
		end
	end
end

function UICombatLauncherItem:OnRaidClick()
	local data = self.stageData

	if not AFKBattleManager:CheckCanRaid(data) then
		local hint = TableData.GetHintById(606)
		CS.PopupMessageManager.PopupString(hint)
		return
	end
	if self.raycaster then
		self.raycaster.enabled = false
	end
	if self:IsResourceSimBat() and self.simData ~= nil then
		UIRaidPanel.Open(self.simData)
	else
		if self.storyData ~= nil then
			UIRaidPanel.Open(self.storyData)
		else
			UIRaidPanel.Open(data)
		end
	end
end

function UICombatLauncherItem:IsResourceSimBat()
	return self.type == UICombatLauncherItem.LauncherType.SimCombat and (self.stageData.type == 2 or self.stageData.type == 5 or self.stageData.type == 8);
end

function UICombatLauncherItem:OnClickEnemy(enemyId)
	if self.raycaster then
		self.raycaster.enabled = false
	end
	UIUnitInfoPanel.Open(UIUnitInfoPanel.ShowType.Enemy, enemyId, self.stageData.stage_class)
end

function UICombatLauncherItem:RefreshItemState()
	self.costItemNum = NetCmdItemData:GetItemCountById(self.stageData.cost_item)
	self.mText_StaminaCost.color = self.costItemNum < self.stageData.stamina_cost and ColorUtils.RedColor or ColorUtils.BlackColor
	self.mText_CostHint.color =  self.costItemNum < self.stageData.stamina_cost and ColorUtils.RedColor or ColorUtils.BlackColor
end

function UICombatLauncherItem:GetItemSort(prizes)
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

function UICombatLauncherItem:GetItemTypeOrder(type)
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

function UICombatLauncherItem:UpdateTopStamina()
	if self.topCurrency == nil then
		self.topCurrency = ResourcesCommonItem.New()
		self.topCurrency:InitCtrl(self.mTrans_TopCurrency)
		local itemData = TableData.GetItemData(self.stageData.cost_item)
		self.topCurrency:SetData({ id = itemData.id, jumpID = itemData.how_to_get })
		MessageSys:AddListener(9007, function() self:RefreshStamina()  end )
	else
		setactive(self.topCurrency.mUIRoot.gameObject, true)
	end
end

function UICombatLauncherItem:RefreshStamina()
	if self.topCurrency ~= nil then
		self.topCurrency:UpdateData()
	end
end

function UICombatLauncherItem:PlayAniWithCallback(callback)
	if self.topCurrency ~= nil then
		setactive(self.topCurrency.mUIRoot.gameObject, false)
	end
	UICombatLauncherItem.super.PlayAniWithCallback(self, callback)
end

function UICombatLauncherItem:OnRelease()
	if self.topCurrency ~= nil then
		MessageSys:RemoveListener(9007, self.RefreshStamina)
		self.topCurrency = nil
	end
end
--检查燃油是否足够
function UICombatLauncherItem:CheckFuelIsEnough(OpenBattleFunc)
	if(GuideManager.IsInGuide==false and self.stageData.BlockFunction=="") then
		local nowfuelnum=NetCmdItemData:GetResItemCount(23)
		local totalfuelnum=NetCmdItemData:GetResItemCount(24)
		if nowfuelnum<totalfuelnum and AccountNetCmdHandler.UAVHint==0 then
			self.FuelNotEnoughPanel=UAVFuelNotEnougContent.New()
			self.FuelNotEnoughPanel:InitCtrl(UISystem.rootCanvasTrans)
			self.FuelNotEnoughPanel:SetData(function()
				OpenBattleFunc()
				end,UISystem.rootCanvasTrans)
			return
		end
	end
	OpenBattleFunc()
end