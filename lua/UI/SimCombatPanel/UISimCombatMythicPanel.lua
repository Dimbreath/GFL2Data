require("UI.UIBasePanel")
require("UI.SimCombatPanel.UISimCombatMythicPanelView")

UISimCombatMythicPanel = class("UISimCombatMythicPanel", UIBasePanel)
UISimCombatMythicPanel.__index = UISimCombatMythicPanel

UISimCombatMythicPanel.mView = nil
UISimCombatMythicPanel.mData = nil
UISimCombatMythicPanel.mCombatLauncher = nil;
UISimCombatMythicPanel.mChooseBuff = nil;
UISimCombatMythicPanel.mGetBuffList = nil;
UISimCombatMythicPanel.mBossStageId = nil;
UISimCombatMythicPanel.mUICommonReceiveItem = nil;
UISimCombatMythicPanel.mMythicStageItemsTable = nil;
UISimCombatMythicPanel.mCanChooseBuffNum = nil;
UISimCombatMythicPanel.mTier = 0;

UISimCombatMythicPanel.enumDifficult = gfenum(
	{
		"simple",
		"normal",
		"difficult",
	}, -1)

UISimCombatMythicPanel.enumDifficultItem =
{
	"Trans_GrpSimple",
	"Trans_GrpNormal",
	"Trans_GrpDifficulty",
	"Trans_GrpBoss",
}

UISimCombatMythicPanel.StagesDifficulty = { "简单", "普通", "困难" }

function UISimCombatMythicPanel:ctor()
	UISimCombatMythicPanel.super.ctor(self)
end

function UISimCombatMythicPanel.Close()
	self = UISimCombatMythicPanel
	MessageSys:RemoveListener(CS.GF2.Message.UIEvent.GetMythicReward,self.ReqSimCombatMythicRewardCallback);
	UIManager.CloseUI(UIDef.UISimCombatMythicPanel)
end

function UISimCombatMythicPanel.Init(root)
	UISimCombatMythicPanel.super.SetRoot(UISimCombatMythicPanel, root)

	self = UISimCombatMythicPanel
	UISimCombatMythicPanel.mView = UISimCombatMythicPanelView.New()
	self.mView:InitCtrl(self.mUIRoot)

	self.mData = NetCmdSimulateBattleData:GetSimCombatMythicInfoData()
	MessageSys:AddListener(CS.GF2.Message.UIEvent.GetMythicReward,self.ReqSimCombatMythicRewardCallback);

end

function UISimCombatMythicPanel.OnInit()
	self = UISimCombatMythicPanel

	setactive(self.mView.mTrans_CombatLauncher.gameObject, false)

	UISimCombatMythicPanel.mCombatLauncher = nil

	UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
		UISimCombatMythicPanel:Close()
	end

	UIUtils.GetButtonListener(self.mView.mBtn_Home.gameObject).onClick = function()
		UIManager.JumpToMainPanel()
	end
	
	UIUtils.GetButtonListener(self.mView.mBtn_Buff.gameObject).onClick = function()
		UISimCombatMythicPanel:OnClickCurBuff()
	end

	UIUtils.GetButtonListener(self.mView.mBtn_RewardReview.gameObject).onClick = function()
		UISimCombatMythicPanel:OnClickReward()
	end

	UIUtils.GetButtonListener(self.mView.mBtn_Retry.gameObject).onClick = function()
		local hint = TableData.GetHintById(30018)
		MessageBox.Show("重新挑战", hint, nil, function() UISimCombatMythicPanel:OnClickRetry() end, nil)
	end

	UIUtils.GetButtonListener(self.mView.mBtn_Enchantment.gameObject).onClick = function()
		UISimCombatMythicPanel:OnClickEnhancement()
	end

	UIUtils.GetButtonListener(self.mView.mBtn_ChooseStagePanel_NextPhase.gameObject).onClick = function()
		UISimCombatMythicPanel:OnClickNextPhase()
	end

	UIUtils.GetButtonListener(self.mView.mBtn_ChallengeStartPanel_Start.gameObject).onClick = function(gObj)
		UISimCombatMythicPanel:ReqSimCombatMythicStart(false)
	end
	

end

function UISimCombatMythicPanel.OnShow()
	
	self = UISimCombatMythicPanel
	self:ReqSimCombatMythicInfo();
	if self.mCombatLauncher ~= nil then
		if self.mCombatLauncher.raycaster then
			self.mCombatLauncher.raycaster.enabled = true
		end
	end
	--self:UpdatePanel();
end

function UISimCombatMythicPanel.OnRelease()
	UISimCombatMythicPanel.mView = nil
	UISimCombatMythicPanel.mData = nil
	UISimCombatMythicPanel.mCombatLauncher = nil;
	UISimCombatMythicPanel.mChooseBuff = nil;
	UISimCombatMythicPanel.mGetBuffList = nil;
	UISimCombatMythicPanel.mBossStageId = nil;
	UISimCombatMythicPanel.mUICommonReceiveItem = nil;
	UISimCombatMythicPanel.mMythicStageItemsTable = nil;
end

function UISimCombatMythicPanel.ClearUIRecordData()
	UIBattleIndexPanel.currentType = -1
	UIChapterInfoPanel.curDiff = 1
end

function UISimCombatMythicPanel:UpdatePanel()
	if self.mView == nil then
		return;
	end

	local mythicMainDatasList = TableData.listSimCombatMythicMainDatas:GetList();

	if  NetCmdSimulateBattleData:GetCombatMythicTierFinishNum() == 2 and self.mData.Rewards == false then
		NetCmdSimulateBattleData:ReqSimCombatMythicReward();
	end

	setactive( self.mView.mBtn_ChallengeStartPanel_Start.transform.parent.gameObject,false);
	if self.mData.Tier == 0 then
		setactive( self.mView.mBtn_ChallengeStartPanel_Start.transform.parent.gameObject,true);
	end

	
	self.mTier = self.mData.Tier == 0 and 1 or self.mData.Tier;

	self:ShowStages();
	self:ShowPhases();
	self:ChooseBuff();
	self:ShowBoss();
	
	
	local mythicMainData = TableData.listSimCombatMythicMainDatas:GetDataById(self.mTier);
	if mythicMainData ~= nil then
		self.mView.mImage_Bg.sprite = IconUtils.GetMythicIcon(mythicMainData.image_bg)
		self.mView.mImage_SceneBg.sprite = IconUtils.GetMythicIcon(mythicMainData.image_theme)
	end
	
	setactive(self.mView.mText_Title.gameObject, true)
	setactive(self.mView.mBtn_Retry.transform.gameObject, true)
	
	
	if NetCmdSimulateBattleData:GetCombatMythicTierFinishNum()  == 0 then --未开始
		setactive( self.mView.mBtn_ChallengeStartPanel_Start.transform.parent.gameObject,true);

		setactive(self.mView.mBtn_Retry.transform.parent.gameObject, false)
		setactive(self.mView.mText_Title.gameObject, false)
		--setactive(self.mView.mTrans_BossPanel.gameObject, false)
	end

	if NetCmdSimulateBattleData:GetCombatMythicTierFinishNum()  == 2  then --结束
		self.mTier = self.mTier +1;
		setactive( self.mView.mBtn_ChallengeStartPanel_Start.transform.parent.gameObject,false);
		if self.mData.Rewards == true and self.mData.Tier ~= mythicMainDatasList.Count then
			--非最后一层
			--self.ReqSimCombatMythicStart()
			setactive(self.mView.mBtn_ChallengeStartPanel_Start.transform.parent.gameObject,true);
			setactive(self.mView.mBtn_Retry.transform.parent.gameObject, false)
			--setactive(self.mView.mTrans_BossPanel.gameObject, false)
		end
	end

	local hint = TableData.GetHintById(103034)
	self.mView.mText_Layer.text = string_format(hint, self.mTier);
	self.mView.mText_LayerNum.text = tonumber(self.mTier);
	if NetCmdSimulateBattleData:GetCombatMythicTierFinishNum() ==2 and self.mData.Tier == mythicMainDatasList.Count and self.mData.Rewards == true then
		setactive(self.mView.mTrans_Left.gameObject, false)
		setactive(self.mView.mTrans_Right.gameObject, false)
		setactive(self.mView.mTrans_FinishedPanel.gameObject, true)

		local hint = TableData.GetHintById(103034)
		self.mView.mText_FinishLayerNum.text = string_format(hint,self.mData.Tier)
	end
end

function UISimCombatMythicPanel:ShowStages()
	
	setactive(self.mView.mTrans_ChooseStagePanel.gameObject, false)
	setactive(self.mView.mBtn_Retry.transform.parent.gameObject, true)
	setactive(self.mView.mTrans_GrpImgScene.transform.gameObject, true)
	
	local chooseStagePanelContent = self.mView.mTrans_ChooseStagePanel:Find("GrpDifficultySelLIst")
	clearallchild(chooseStagePanelContent);
	local mythicPlanData = TableData.listSimCombatMythicPlanDatas:GetDataById(self.mData.PlanId, true);
	if mythicPlanData == nil then
		return ;
	end


	setactive(self.mView.mBtn_ChooseStagePanel_NextPhase.transform.parent.gameObject,false)
	self.mMythicStageItemsTable = {};
	local curPhaseStages = string.split(mythicPlanData.StagePlan, ";");
	if #curPhaseStages >= self.mData.PhaseId then
		if curPhaseStages[self.mData.PhaseId + 1] ~= "" then

			setactive(self.mView.mTrans_ChooseStagePanel.gameObject, true)
			local stages = string.split(curPhaseStages[self.mData.PhaseId + 1], ",");
			setactive(self.mView.mBtn_ChooseStagePanel_NextPhase.transform.parent.gameObject,true)
			setactive(self.mView.mTrans_GrpImgScene.transform.gameObject, false)
			for i = 1, #stages do

				local obj = instantiate(UIUtils.GetGizmosPrefab("SimCombat/SimCombatMythicDifficultySelItemV2.prefab",self),chooseStagePanelContent);
				setactive(obj, true);
				local isPass = false;
				
				for k, v in pairs(self.mData.PhaseStages) do
					if tonumber(k) == tonumber(stages[i]) then
						isPass = true;
						setactive(obj.transform:Find("Btn_Icon/Trans_GrpCompleted"),true);
					end
				end
				if isPass == false then
					table.insert(self.mMythicStageItemsTable, obj);
					UIUtils.GetButtonListener(obj.transform:Find("Btn_Icon").gameObject).onClick = function()
						UIUtils.GetButton(obj.transform:Find("Btn_Icon").gameObject).interactable = false;
						self:OnClickStage(tonumber(stages[i]));
					end
				end
				local curStageData = TableData.listSimCombatMythicStageDatas:GetDataById(tonumber(stages[i]));
				if curStageData ~= nil then
					local curMithicStageData = TableData.listStageDatas:GetDataById(tonumber(curStageData.Stage))
					obj.transform:Find("GrpDifficultyState/Text_Difficulty"):GetComponent("Text").text = UISimCombatMythicPanel.StagesDifficulty[curStageData.Difficulty]
					local difficultItem =  "Btn_Icon/GrpIcon/".. UISimCombatMythicPanel.enumDifficultItem[curStageData.Difficulty];
					
					setactive(obj.transform:Find(difficultItem),true)

					for i = 1,3 do
						local difficultStage =  "GrpStage/GrpStage".. i.."/Trans_On";
						if(i<= curStageData.Difficulty) then
							setactive(obj.transform:Find(difficultStage),true)
						else
							setactive(obj.transform:Find(difficultStage),false)
						end
					end
				end

			end

			--没buff,且挑战完
			if self.mData.PhaseStages.Count == #stages and self.mData.PhaseBuffs.Count == 0 then
				self:OnClickNextPhase();
			end

		end
	end

	--显示boss关卡
	if #curPhaseStages == self.mData.PhaseId + 1 then
		local stages = string.split(curPhaseStages[self.mData.PhaseId + 1], ",");
		if stages[1] == "" then
			--setactive(self.mView.mTrans_BossPanel.gameObject, true)
			setactive(self.mView.mTrans_ChooseStagePanel.gameObject, true)
			setactive(self.mView.mBtn_ChooseStagePanel_NextPhase.transform.parent.gameObject,true)
			setactive(self.mView.mTrans_GrpImgScene.transform.gameObject, false)
			
			local mythicMainData = TableData.listSimCombatMythicMainDatas:GetDataById(self.mTier);
			if mythicMainData ~= nil then

				setactive(self.mView.mTrans_ChooseStagePanel.gameObject, true)
				self.mBossStageId = mythicMainData.BossStage;
				local obj = instantiate(UIUtils.GetGizmosPrefab("SimCombat/SimCombatMythicDifficultySelItemV2.prefab",self),chooseStagePanelContent);
				setactive(obj, true);

				UIUtils.GetButtonListener(obj.transform:Find("Btn_Icon").gameObject).onClick = function()
					self:OnClickStageBoss(self.mBossStageId);
				end
				obj.transform:Find("GrpDifficultyState/Text_Difficulty"):GetComponent("Text").text = "Boss";
				 
			end
			
		end
	end


end

function UISimCombatMythicPanel:ShowPhases()
	--self.mData.PhaseId
	if(NetCmdSimulateBattleData:GetCombatMythicTierFinishNum() == 1) then
		setactive(self.mView.mBtn_ChooseStagePanel_NextPhase.transform.parent.gameObject,true)  --未开始
	else
		setactive(self.mView.mBtn_ChooseStagePanel_NextPhase.transform.parent.gameObject,false)
	end
	
	if self.mData.PhaseStages.Count > 0 then
		setactive(self.mView.mText_Title.gameObject, true)
		
		self.mView.mBtn_ChooseStagePanel_NextPhase.interactable = true
	else
		self.mView.mBtn_ChooseStagePanel_NextPhase.interactable = false
		
		setactive(self.mView.mText_Title.gameObject, false)
	end
	
	for i = 1, 5 do
		local passTransName = "Root/GrpRight/GrpProgress/GrpStage/GrpStage" .. i.."/Trans_GrpCompleted";
		local passTrans = self.mView:GetRectTransform(passTransName);
		local noPassTransName = "Root/GrpRight/GrpProgress/GrpStage/GrpStage" .. i.."/Trans_GrpUnCompleted";
		local noPassTrans = self.mView:GetRectTransform(noPassTransName);

		local rightTransName = "Root/GrpRight/GrpProgress/GrpStage/GrpStage" .. i.."/Trans_GrpCompleted/GrpIcon/Trans_ImgIconRight";
		local rightTrans = self.mView:GetRectTransform(rightTransName);
		setactive(rightTrans.gameObject, false)
		
		setactive(passTrans.gameObject, false)
		if i < self.mData.PhaseId + 1 then
			setactive(passTrans.gameObject, true)
			setactive(noPassTrans.gameObject, false)
		else
			setactive(noPassTrans.gameObject, true)
		end
	end

	if (self.mData.PhaseId > 0) then
		local leftTransName = "Root/GrpRight/GrpProgress/GrpStage/GrpStage1/Trans_GrpCompleted/GrpIcon/Trans_ImgIconLeft";
		local leftTrans = self.mView:GetRectTransform(leftTransName);
		setactive(leftTrans.gameObject, false)

		local leftTransName = "Root/GrpRight/GrpProgress/GrpStage/GrpStage1/Trans_GrpUnCompleted/GrpIcon/Trans_ImgIconLeft";
		local leftTrans = self.mView:GetRectTransform(leftTransName);
		setactive(leftTrans.gameObject, false)

		local rightTransName = "Root/GrpRight/GrpProgress/GrpStage/GrpStage" .. self.mData.PhaseId .. "/Trans_GrpCompleted/GrpIcon/Trans_ImgIconRight";
		local rightTrans = self.mView:GetRectTransform(rightTransName);
		setactive(rightTrans.gameObject, true)
	else
		local leftTransName = "Root/GrpRight/GrpProgress/GrpStage/GrpStage1/Trans_GrpUnCompleted/GrpIcon/Trans_ImgIconLeft";
		local leftTrans = self.mView:GetRectTransform(leftTransName);
		setactive(leftTrans.gameObject, true)
		
	end

	
	
end

function UISimCombatMythicPanel:ChooseBuff()

	if self.mData.PhaseBuffs.Count == 0 then
		return ;
	end
	self.mCanChooseBuffNum = self.mData.BuffSelectNum;
	local params = {self.mData.PhaseBuffs,self.mCanChooseBuffNum};
	UIManager.JumpUIByParam(UIDef.SimCombatMythicBuffSelPanel,params)
	
end


function UISimCombatMythicPanel:GetCurBuffLevel(buffId)
	local result = 0;
	for i = 0, self.mData.TotalBuffs.Count - 1 do
		if buffId ==  self.mData.TotalBuffs[i] then
			result = self.mData.BuffLevel[i];
			break;
		end
	end
	return result;
end


function UISimCombatMythicPanel:ShowBoss()
	clearallchild(self.mView.mTrans_Boss.transform)
	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComEnemyInfoItemV2.prefab", self))

	local mythicMainData = TableData.listSimCombatMythicMainDatas:GetDataById(self.mTier);
	if mythicMainData ~= nil then
		local enemyData = TableData.listEnemyDatas:GetDataById(mythicMainData.boss_id);

		local stageData = TableData.listStageDatas:GetDataById(tonumber(mythicMainData.BossStage));
		local bossLevel = 0;
		if stageData ~= nil then
			bossLevel = enemyData.add_level + stageData.stage_class;
		end
	
		UIUtils.GetImage(obj,"GrpEnemyIcon/ImgBg/Img_EnemyIcon").sprite =  IconUtils.GetEnemyCharacterHeadSprite(enemyData.character_pic)
		UIUtils.GetText(obj,"GrpLevel/Text_Level").text = tostring(bossLevel)
		UIUtils.GetButtonListener(obj).onClick = function(obj)
			UIUnitInfoPanel.Open(UIUnitInfoPanel.ShowType.Enemy, mythicMainData.boss_id,bossLevel)
		end

	end

	CS.LuaUIUtils.SetParent(obj.gameObject,self.mView.mTrans_Boss.gameObject, false)
	obj.transform.sizeDelta = CS.UnityEngine.Vector2(100,100);
	--self.mView.mTrans_Boss
end
------------------------------------------------------消息----------------------------------------------

function UISimCombatMythicPanel:ReqSimCombatMythicInfo()
	self = UISimCombatMythicPanel
	NetCmdSimulateBattleData:ReqSimCombatMythicInfo(self.ReqSimCombatMythicInfoCallback)
end

function UISimCombatMythicPanel:ReqSimCombatMythicInfoCallback()
	self = UISimCombatMythicPanel
	self.mData = NetCmdSimulateBattleData:GetSimCombatMythicInfoData()
	self:UpdatePanel()
end

function UISimCombatMythicPanel:ReqSimCombatMythicStart(isReStart)
	self = UISimCombatMythicPanel
	NetCmdSimulateBattleData:ReqSimCombatMythicStart(isReStart,self.ReqSimCombatMythicInfoCallback)
end

function UISimCombatMythicPanel:ReqSimCombatMythicNextPhaseCallback()
	self = UISimCombatMythicPanel
	self.ReqSimCombatMythicInfo();
end

function UISimCombatMythicPanel:ReqSimCombatMythicSelectBuffCallback()
	self = UISimCombatMythicPanel
	self.ReqSimCombatMythicInfo();
end

--领取奖励成功
function UISimCombatMythicPanel.ReqSimCombatMythicRewardCallback()
	self = UISimCombatMythicPanel
	local mythicMainData = TableData.listSimCombatMythicMainDatas:GetDataById(self.mData.Tier);
	if mythicMainData ~= nil and mythicMainData.RewardList ~= nil then

		local rewardTab = {}
		for k, v in pairs(mythicMainData.RewardList) do
			local rewardItem = {["ItemId"] =k,["ItemNum"] =v }
			table.insert(rewardTab,rewardItem)
		end
		
			UIManager.OpenUIByParam(UIDef.UICommonReceivePanel, {rewardTab, function()
				UISimCombatMythicPanel:CloseTakeQuestRewardCallBack()
			end, {}})
--[[			self.mUICommonReceiveItem= UICommonReceiveItem.New()
			self.mUICommonReceiveItem:InitCtrl(self.mUIRoot)
			UIUtils.GetButtonListener(self.mUICommonReceiveItem.mBtn_Confirm.gameObject).onClick= function()
				UISimCombatMythicPanel:CloseTakeQuestRewardCallBack()
			end]]

		--self.mUICommonReceiveItem:SetData(mythicMainData.RewardList)
	end


end

-----------------------------------------------------按钮响应----------------------------------------------
function UISimCombatMythicPanel:CloseTakeQuestRewardCallBack()
	self = UISimCombatMythicPanel
	
	self:ReqSimCombatMythicInfo();
end

function UISimCombatMythicPanel:OnClickCurBuff()
	self = UISimCombatMythicPanel
	local params = {self.mData.TotalBuffs,self.mData.BuffLevel};
	UIManager.JumpUIByParam(UIDef.SimCombatMythicBuffDialogV2,params)
	
end

function UISimCombatMythicPanel:OnClickReward()

	UIManager.JumpUIByParam(UIDef.SimCombatMythicRewardDialogV2,self.mTier)

end

function UISimCombatMythicPanel:OnClickRetry()
	self:ReqSimCombatMythicStart(true)
end

function UISimCombatMythicPanel:OnClickBossPreview()
	--todo
end

function UISimCombatMythicPanel:OnClickEnhancement()

	UIManager.JumpUIByParam(UIDef.SimCombatMythicAffixDialog,self.mTier)
	
end

function UISimCombatMythicPanel:OnClickNextPhase()
	NetCmdSimulateBattleData:ReqSimCombatMythicNextPhase(self.ReqSimCombatMythicNextPhaseCallback)
end

function UISimCombatMythicPanel:OnClickCloseBuffList()
	setactive(self.mView.mTrans_BuffListPanel, false);

end

function UISimCombatMythicPanel:OnClickCloseEnhantmentList()
	setactive(self.mView.mTrans_EnchantmentPanel, false);
end

function UISimCombatMythicPanel:OnClickCloseRewardList()
	setactive(self.mView.mTrans_GetRewardPanel, false);

end


function UISimCombatMythicPanel:OnClickGetBuff()

	if self.mGetBuffList == nil then
		UIGuildGlobal:PopupHintMessage(30022) --提示至少选中1个
		return;
	end

	if self.mGetBuffList ~= nil and #self.mGetBuffList == 2 and self.mCanChooseBuffNum == 1 then
		UIGuildGlobal:PopupHintMessage(30022) --提示至少选中1个
		return ;
	end

	if self.mGetBuffList ~= nil and #self.mGetBuffList ==1 and self.mCanChooseBuffNum == 2 then
		UIGuildGlobal:PopupHintMessage(30023) --提示至少选中2个
		return;
	end

	NetCmdSimulateBattleData:ReqSimCombatMythicBuffSelect(self.mGetBuffList, self.ReqSimCombatMythicSelectBuffCallback)
end

function UISimCombatMythicPanel:OnClickGetBuffHint()
	if self.mCanChooseBuffNum == 2 then
		UIGuildGlobal:PopupHintMessage(30023) --提示至少选中3个
		return;
	end

	if  self.mCanChooseBuffNum == 1 then
		UIGuildGlobal:PopupHintMessage(30022) --提示至少选中1个
		return ;
	end
end

-----------------------------------------------单个关卡item----------------------------------------------------

function UISimCombatMythicPanel:OnClickStage(stageId)

	--print("   stageId    "..self.mStageId)
	local mythicStageData = TableData.listSimCombatMythicStageDatas:GetDataById(tonumber(stageId));
	if mythicStageData == nil then
		return ;
	end
	if self.mCombatLauncher == nil then
		self:InitCombatLauncher();
	end
	setactive(self.mView.mTrans_CombatLauncher.gameObject, true)
	local stageData = TableData.listStageDatas:GetDataById(tonumber(mythicStageData.Stage));
	local record = NetCmdStageRecordData:GetStageRecordById(mythicStageData.Stage)

	local mythicEnchantment = {};

	local mythicMainData = TableData.listSimCombatMythicMainDatas:GetDataById(self.mTier);
	if mythicMainData ~= nil then
		for i = 0, mythicStageData.Difficulty - 1 do
			table.insert(mythicEnchantment, mythicMainData.Enchantment[i])
		end
	end
	NetCmdSimulateBattleData.EnchantmentList = mythicEnchantment;
	NetCmdSimulateBattleData.MythicStageId = stageId;
	local data = TableData.listSimCombatMythicStageDatas:GetDataById(stageId)
	if data then
		--self.mData.Tier
		--self.mData.PhaseId
		self.mCombatLauncher:InitSimCombatMythicData(stageData, record, data, true, self.mData.Tier, self.mData.PhaseId, mythicStageData.Difficulty);
	end
	--self.mCombatLauncher:InitSimCombatMythicData(stageData, record, true, self.mData.Tier, self.mData.PhaseId, mythicStageData.Difficulty);
end


function UISimCombatMythicPanel:OnClickStageBoss(stageId)
	if self.mCombatLauncher == nil then
		self:InitCombatLauncher();
	end
	setactive(self.mView.mTrans_CombatLauncher.gameObject, true)
	local stageData = TableData.listStageDatas:GetDataById(tonumber(stageId));
	local record = NetCmdStageRecordData:GetStageRecordById(tonumber(stageId))
	local mythicEnchantment = {};
	local mythicMainData = TableData.listSimCombatMythicMainDatas:GetDataById(self.mTier);
	if mythicMainData ~= nil then
		for i = 0, mythicMainData.Enchantment.Count - 1 do
			table.insert(mythicEnchantment, mythicMainData.Enchantment[i])
		end
	end
	NetCmdSimulateBattleData.EnchantmentList = mythicEnchantment;
	NetCmdSimulateBattleData.MythicStageId = stageId;

	--self.mData.Tier
	--self.mData.PhaseId
	self.mCombatLauncher:InitSimCombatMythicData(stageData, record, nil, true, self.mData.Tier, self.mData.PhaseId );

end



function UISimCombatMythicPanel:OnClickChooseBuff(chooseBuff)

	if chooseBuff[2] == 0 and self.mCanChooseBuffNum == 1 and #self.mGetBuffList ==1 then
		UIGuildGlobal:PopupHintMessage(30022) --提示至少选中1个
		return;
	end

	if chooseBuff[2] == 0 and self.mCanChooseBuffNum == 2 and #self.mGetBuffList ==2 then
		UIGuildGlobal:PopupHintMessage(30023) --提示至少选中2个
		return;
	end

	chooseBuff[2] = chooseBuff[2] + 1;
	--点击两次
	if chooseBuff[2] == 2 then
		chooseBuff[2] = 0;
		for i = #self.mGetBuffList, 1, -1 do
			if self.mGetBuffList[i] == chooseBuff[1] then
				table.remove(self.mGetBuffList, i)
				break ;
			end
		end

	elseif chooseBuff[2] == 1 then
		table.insert(self.mGetBuffList,chooseBuff[1]);
	end

	-- 默认三个buff
	for i = 1, #self.mChooseBuff do
		local buffChosenName = "UI_Trans_ChooseBuffPanel/Content/UI_Btn_ChooseBuff" .. tostring(i) .. "/Trans_Chosen"
		local buffChosen = self.mView:GetRectTransform(buffChosenName);
		--点击一次显示选择图标
		local clickChose = false;
		if self.mChooseBuff[i][2]== 1 then
			clickChose = true;
		end
		setactive(buffChosen.gameObject, clickChose)
	end

	local isInteractable = #self.mGetBuffList == self.mCanChooseBuffNum and true or false;
	setactive(self.mView.mBtn_ChooseBuffPanel_Confirm.gameObject,isInteractable);
	setactive(self.mView.mBtn_ChooseBuffPanel_ConfirmUnInteractable.gameObject,not isInteractable);
end

function UISimCombatMythicPanel:InitCombatLauncher()

	--local itemPrefab = UIUtils.GetGizmosPrefab("UICommonFramework/ComDetailsPanelV2.prefab", self);
	--local instObj = instantiate(itemPrefab);
	local item = UICombatLauncherItem.New();
	item:InitCtrl(self.mView.mTrans_CombatLauncher.transform);

	--CS.LuaUIUtils.SetParent(instObj, self.mView.mTrans_CombatLauncher.gameObject, true);
	self.mCombatLauncher = item

	UIUtils.GetButtonListener(item.mBtn_Close.gameObject).onClick = function(gObj)
		UISimCombatMythicPanel:OnClickCloseLauncher()
	end

end

function UISimCombatMythicPanel:OnClickCloseLauncher()
	if self.mCombatLauncher == nil then
		return
	end

	for i, data in ipairs(self.mMythicStageItemsTable) do
		UIUtils.GetButton(data.transform:Find("Btn_Icon").gameObject).interactable = true;
	end

	self.mCombatLauncher:PlayAniWithCallback(function ()
		setactive(self.mView.mTrans_CombatLauncher.gameObject, false)
	end)

end