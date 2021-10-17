--region *.lua

require("UI.UIDef")

UIManager = {};
local this = UIManager;

UISystem = CS.UISystem.Instance;

UIManager.mUpdateUIs = nil;

UIManager.ModelPanel = {UIDef.UICharacterWeaponPanel, UIDef.UIWeaponPanel, UIDef.UICharacterDetailPanel, UIDef.UIWeaponPartCailbrationSucPanel}

function UIManager.Init()

	UIManager.mUpdateUIs = List:New("UpdateUIs");
	--UIDef type, lua script path, lua script name
	UISystem:AddDefine(UIDef.UIFormationPanel, "UIFormationPanel", "UIFormationPanel");
	UISystem:AddDefine(UIDef.UICarrierSelectionPanel, "UICarrierSelectionPanel", "UICarrierSelectionPanel");
	UISystem:AddDefine(UIDef.UICharacterSelectionPanel, "UICharacterSelectionPanel", "UICharacterSelectionPanel");
	UISystem:AddDefine(UIDef.UI_TeamSelTempPanel, "UI_TeamSelTempPanel", "UI_TeamSelTempPanel");
	UISystem:AddDefine(UIDef.UITeamInfoPanel, "UITeamInfoPanel", "UITeamInfoPanel");
	UISystem:AddDefine(UIDef.UIRepairConfirmPanel, "UIRepairConfirmPanel", "UIRepairConfirmPanel");
	UISystem:AddDefine(UIDef.UIDispatchPanel, "UIDispatchPanel", "UIDispatchPanel");
	UISystem:AddDefine(UIDef.UIMaxPanel,"UIMaxPanel","UIMaxPanel");
	UISystem:AddDefine(UIDef.UICampaignMissionPanel,"UICampaignMissionPanel","UICampaignMissionPanel");
	UISystem:AddDefine(UIDef.UIMaintainPanel,"UIMaintainPanel","UIMaintainPanel");
	UISystem:AddDefine(UIDef.UIAutoMaxPanel,"UIAutoMaxPanel","UIAutoMaxPanel");
	UISystem:AddDefine(UIDef.UIFacilityBarrackPanel,"Character/ChrCardMainPanelV2","UIFacilityBarrackPanel");
	UISystem:AddDefine(UIDef.UICharacterUpgradePanel,"Character/UICharacterUpgradePanel","UICharacterUpgradePanel");
	UISystem:AddDefine(UIDef.UISkillEditPanel,"UISkillEditPanel","UISkillEditPanel");
	UISystem:AddDefine(UIDef.UIGarageMainPanel,"GaragePanels/UIGarageMain","UIGarageMainPanel");
	UISystem:AddDefine(UIDef.UIGarageVechicleDetailPanel,"GaragePanels/UIGarageVechicleDetail","UIGarageVechicleDetailPanel");
	UISystem:AddDefine(UIDef.UIGashaponMainPanel,"Gashapon/GashaponMainPanelV2","UIGachaMainPanelV2");
	UISystem:AddDefine(UIDef.UIGachaResultPanel,"Gashapon/GashaponResultPanelV2","UIGachaResultPanelV2");
	UISystem:AddDefine(UIDef.UIRepositoryPanelV2,"Repository/RepositoryPanelV2","UIRepositoryPanelV2");
	UISystem:AddDefine(UIDef.UIRepositoryDecomposePanelV2,"Repository/RepositoryDecomposePanelV2","UIRepositoryDecomposePanelV2");
	UISystem:AddDefine(UIDef.UIMaxPanelNew,"UIMaxPanelNew","UIMaxPanelNew");
	UISystem:AddDefine(UIDef.UIFacilityLvUpPanel,"UIFacilityLvUpPanel","UIFacilityLvUpPanel");
	UISystem:AddDefine(UIDef.UISkillCoreDetailPanel,"SkillCore/UISkillCoreDetail","UISkillCoreDetailPanel");
	UISystem:AddDefine(UIDef.UISkillCoreSelectionPanel,"SkillCore/UISkillCoreSelectionPanel","UISkillCoreSelectionPanel");
	UISystem:AddDefine(UIDef.UIBaseResourceDetailPanel,"UIBaseResourceDetailPanel","UIBaseResourceDetailPanel");
	UISystem:AddDefine(UIDef.UIBaseCollectResResultPanel,"UIBaseCollectResResultPanel","UIBaseCollectResResultPanel");
	UISystem:AddDefine(UIDef.UISimCombatPanel,"UISimCombatPanel","UISimCombatPanel");
	UISystem:AddDefine(UIDef.UIMainStorePanel,"Store/UIMainStorePanel","UIMainStorePanel");
	UISystem:AddDefine(UIDef.UIStorePanel,"Store/UIStorePanel","UIStorePanel");
	UISystem:AddDefine(UIDef.UIStoreSkinPanel,"Store/UIStoreSkinPanel","UIStoreSkinPanel");
	UISystem:AddDefine(UIDef.UIDormPanel,"Dorm/UIDormPanel","UIDormPanel");
	UISystem:AddDefine(UIDef.UIDormRoomPanel,"Dorm/UIDormRoomPanel","UIDormRoomPanel");
	UISystem:AddDefine(UIDef.UIDatingResultPanel,"Dorm/UIDatingResultPanel","UIDatingResultPanel");
	UISystem:AddDefine(UIDef.UIEquipmentEnhancePanel,"EquipmentEnhancePanels/UIEquipmentEnhancePanel","UIEquipmentEnhancePanel");
	UISystem:AddDefine(UIDef.UIMailPanelV2,"Mail/MailPanelV2","UIMailPanelV2");
	UISystem:AddDefine(UIDef.UICarrierPartDetailPanel,"CarrierPart/UICarrierPartDetailPanel","UICarrierPartDetailPanel");
	UISystem:AddDefine(UIDef.UICommanderCustomMadePanel,"UICommanderCustomMadePanel","UICommanderCustomMadePanel");
	UISystem:AddDefine(UIDef.UIAutoMaxConfirmPanel,"AutoMax/UIAutoMaxConfirmPanel","UIAutoMaxConfirmPanel")
	UISystem:AddDefine(UIDef.UICommandCenterPanel,"CommandCenter/CommandCenterPanelV2","UICommandCenterPanel");
	UISystem:AddDefine(UIDef.UIAdjutantPanel,"Adjustant/UIAdjutantPanel","UIAdjutantPanel");
	UISystem:AddDefine(UIDef.UIPosterPanel,"Post/UIPosterPanel","UIPosterPanel");
	UISystem:AddDefine(UIDef.UIPostPanelV2,"Post/PostPanelV2","UIPostPanelV2");
	UISystem:AddDefine(UIDef.UICombatLauncherPanel,"CombatLauncher/UICombatLauncherPanel","UICombatLauncherPanel");
	UISystem:AddDefine(UIDef.UICombatPreparationPanel,"CombatPreparation/UICombatPreparationPanel","UICombatPreparationPanel");
	UISystem:AddDefine(UIDef.UIBattleSettlementPanel,"BattleSettlement/UIBattleSettlementPanel","UIBattleSettlementPanel");
	UISystem:AddDefine(UIDef.UITipsPanel,"UICommonFramework/ComItemDetailsPanelV2","UITipsPanel");
	UISystem:AddDefine(UIDef.UIChapterPanel,"story/StoryChapterPanelV2","UIChapterPanel");
	UISystem:AddDefine(UIDef.UIChapterHardPanel,"story/StoryChapterDifficultyPanelV2","UIChapterHardPanel");
	UISystem:AddDefine(UIDef.UIStoryPanel,"UIStoryPanel","UIStoryPanel");
	UISystem:AddDefine(UIDef.UIDoUpgradePanel,"UIDoUpgradePanel","UIDoUpgradePanel");
	UISystem:AddDefine(UIDef.UIGunLevelUpPanel,"Character/UIGunLevelUpPanel","UIGunLevelUpPanelNew");
	UISystem:AddDefine(UIDef.UIEquipmentDetailPanel,"EquipmentEnhancePanels/UIEquipmentDetailPanel","UIEquipmentDetailPanel");
	UISystem:AddDefine(UIDef.UIMentalCircuitPanel,"UIMentalCircuitPanel","UIMentalCircuitPanel");
	UISystem:AddDefine(UIDef.UIMemoryChipPanel,"MemoryChipPanels/UIMemoryChipPanel","UIMemoryChipPanel");
	UISystem:AddDefine(UIDef.UIEnemyInfoPanel,"SLG/UIEnemyInfoPanel","UIEnemyInfoPanel");
	UISystem:AddDefine(UIDef.UIDailyQuestPanel,"DailyQuest/QuestPanelV2","UIDailyQuestPanel");
	UISystem:AddDefine(UIDef.UICharacterEquipPanel,"Character/ChrEquipReplaceListPanelV2","UICharacterEquipPanel");
	UISystem:AddDefine(UIDef.SimTrainingListPanel,"SimCombat/TrainingListPanelV2","UISimCombatTrainingPanel")
	UISystem:AddDefine(UIDef.UIExpeditionPanel,"ExpeditionPanel/UIExpeditionPanel","UIExpeditionPanel")
	UISystem:AddDefine(UIDef.UIExpeditionTaskPanel,"ExpeditionPanel/UIExpeditionTaskPanel","UIExpeditionTaskPanel")
	UISystem:AddDefine(UIDef.UIExpeditionSettlementPanel,"ExpeditionPanel/UIExpeditionSettlementPanel","UIExpeditionSettlementPanel")
	UISystem:AddDefine(UIDef.UIGuildInformationPanel,"Guild/UIGuildInformationPanel","UIGuildInformationPanel")
	UISystem:AddDefine(UIDef.UIJoinGuildPanel,"Guild/UIJoinGuildPanel","UIJoinGuildPanel")
	UISystem:AddDefine(UIDef.UIGuildPanel,"Guild/UIGuildPanel","UIGuildPanel")
	UISystem:AddDefine(UIDef.UICommonGetPanel,"UICommonFramework/ComStaminaGetDialogV2","UICommonGetPanel")
	UISystem:AddDefine(UIDef.UIFriendPanel,"Friend/FriendPanelV2","UIFriendPanel")
	UISystem:AddDefine(UIDef.UIPlayerInfoPanel,"CommanderInfo/CommanderInfoCardDialogV2","UIPlayerInfoPanel")
	UISystem:AddDefine(UIDef.UIRepositoryListPanel,"RepositoryPanels/UIRepositoryListPanel","UIRepositoryListPanel");
	UISystem:AddDefine(UIDef.UICurrencyPanel,"CurrencyPanels/UICurrencyPanel","UICurrencyPanel")
	UISystem:AddDefine(UIDef.UICommanderInfoPanel,"CommanderInfo/CommanderInfoPanelV2","UICommanderInfoPanelV2")
	UISystem:AddDefine(UIDef.UIBattleIndexPanel, "BattleIndex/BattleIndexPanelV2", "UIBattleIndexPanel")
	UISystem:AddDefine(UIDef.UIUniTopBarPanel, "UICommonFramework/UIUniTopbar", "UIUniTopBarPanel", typeof(CS.UniTopBarPanelUI))
	UISystem:AddDefine(UIDef.UIAutoBattlePreSetPanel,"RaidAndAutoBattle/UIAutoBattlePreSet","UIAutoBattlePreSetPanel")
	UISystem:AddDefine(UIDef.UIAutoBattlePanel,"RaidAndAutoBattle/UIAutoBattle","UIAutoBattlePanel")
	UISystem:AddDefine(UIDef.UIAutoBattleEndPanel,"RaidAndAutoBattle/UIAutoBattleEndPanel","UIAutoBattleEndPanel")
	UISystem:AddDefine(UIDef.UIRaidPanel,"Raid/RaidDialogV2","UIRaidPanel")
	UISystem:AddDefine(UIDef.UIRaidDuringPanel,"Raid/RaidDuringPanelV2","UIRaidDuringPanel")
	UISystem:AddDefine(UIDef.UITopBannerPanel,"UICommonFramework/UITopBannerPanel","UITopBannerPanel")
	UISystem:AddDefine(UIDef.UIAchievementPanel,"CommanderInfo/AchievementPanelV2","UIAchievementPanelV2")
	UISystem:AddDefine(UIDef.UIDailyCheckInPanel,"CheckIn/CheckInPanelV2","UIDailyCheckInPanel")
	UISystem:AddDefine(UIDef.UISimCombatEquipPanel,"SimCombat/SimCombatEquipPanelV2","UISimCombatEquipPanel")
	UISystem:AddDefine(UIDef.UISimCombatRunesPanel,"SimCombat/SimCombatRunesPanelV2","UISimCombatRunesPanel")
	UISystem:AddDefine(UIDef.UISimCombatGoldPanel,"SimCombat/SimCombatGoldPanelV2","UISimCombatGoldPanel")
	UISystem:AddDefine(UIDef.UISimCombatExpPanel,"SimCombat/SimCombatExpPanelV2","UISimCombatExpPanel")
	UISystem:AddDefine(UIDef.UINRTPVPPanel, "PVP/UINRTPVPPanel", "UINRTPVPPanel")
	UISystem:AddDefine(UIDef.UICharacterDetailPanel, "Character/BarrackPowerUpPanelV2", "UICharacterDetailPanel")
	UISystem:AddDefine(UIDef.UICharacterWeaponPanel, "Weapon/UIWeaponPanel", "UICharacterWeaponPanel")
	UISystem:AddDefine(UIDef.UINewEquipmentDetailPanel, "EquipmentEnhancePanels/UIEquipmentDetailPanelNew", "UINewEquipmentDetailPanel")
	UISystem:AddDefine(UIDef.UIStoreExchangePanel, "StoreExchange/StoreExchangePanelV2", "UIStoreExchangePanel")
	UISystem:AddDefine(UIDef.UIStoreExchangeTopBarPanel, "UICommonFramework/UIUniTopbar", "UIStoreExchangeTopBarPanel")
	UISystem:AddDefine(UIDef.UIDormItemChangePanel, "Dorm/UIDormItemChangePanel", "UIDormItemChangePanel")
	UISystem:AddDefine(UIDef.UIDormMainPanel, "Dorm/UIDormMainPanel", "UIDormMainPanel")
	UISystem:AddDefine(UIDef.UICommonReadmePanel, "Readme/UICommonReadmePanel", "UICommonReadmePanel")
	UISystem:AddDefine(UIDef.UIChatPanel, "Chat/ChatPanelV2", "UIChatPanel")
	UISystem:AddDefine(UIDef.UISimCombatWeeklyPanel, "SimCombat/SimCombatWeeklyPanelV2", "UISimCombatWeeklyPanel")
	UISystem:AddDefine(UIDef.UIDormCharacterSkinPanel, "Dorm/UIDormCharacterSkinPanel", "UIDormCharacterSkinPanel")
	UISystem:AddDefine(UIDef.UIRankingPanel, "UICommonFramework/UIRankingPanel", "UIRankingPanel")
	UISystem:AddDefine(UIDef.UITutorialInfoPanel, "Readme/UITutoriaInfoPanel", "UITutorialInfoPanel")
	UISystem:AddDefine(UIDef.UIStoreMainPanel,"Store/UIStoreMainPanel","UIStoreMainPanel");
	UISystem:AddDefine(UIDef.UISimCombatMythicPanel, "SimCombat/SimCombatMythicPanelV2", "UISimCombatMythicPanel")
	UISystem:AddDefine(UIDef.UIWeaponPanel, "Character/ChrWeaponPowerUpPanelV2", "UIWeaponPanel")
	UISystem:AddDefine(UIDef.UIDormSkinChangePanel, "Dorm/UIDormSkinChangePanel", "UIDormSkinChangePanel")
	UISystem:AddDefine(UIDef.UIEquipPanel, "Character/ChrEquipPowerUpPanelV2", "UIEquipPanel")
	UISystem:AddDefine(UIDef.UICommonReceivePanel, "UICommonFramework/ComReceiveDialogV2", "UICommonReceivePanel")
	UISystem:AddDefine(UIDef.UICommonLevelUpPanel,"UICommonFramework/ComCommanderLvUpPanelV2","UICommonLevelUpPanel");
	UISystem:AddDefine(UIDef.UICommonUnlockPanel,"UICommonFramework/ComNewFunctionUnlockPanelV2","UICommonUnlockPanel");
	UISystem:AddDefine(UIDef.UISkillDetailPanel, "UICommonFramework/UISkillDetailPanel", "UISkillDetailPanel")
	UISystem:AddDefine(UIDef.MessageBoxPanel, "UICommonFramework/ComDialogV2", "MessageBoxPanel")
	UISystem:AddDefine(UIDef.SimpleMessageBoxPanel, "UICommonFramework/ComDescriptionDialogV2", "SimpleMessageBoxPanel")
	UISystem:AddDefine(UIDef.UICharacterPropPanel, "Character/ChrAttributeDetailsDialogV2", "UICharacterPropPanel")
	UISystem:AddDefine(UIDef.UIGetWayPanel,"UICommonFramework/UIGetWayPanel","UIGetWayPanel");
	UISystem:AddDefine(UIDef.UIMixPanel,"Character/ChrMentalComposePanelV2","UIMixPanel");
	UISystem:AddDefine(UIDef.UIUnitInfoPanel, "UICommonFramework/ComChrEnemyInfoDialogV2", "UIUnitInfoPanel")
	UISystem:AddDefine(UIDef.UIMixConfirmPanel, "Character/ChrMentalMetarialCosumePanelV2", "UIMixConfirmPanel")
	UISystem:AddDefine(UIDef.UINickNamePanel, "UICommonFramework/NickNamePanelV2", "UINickNamePanel")
	UISystem:AddDefine(UIDef.UIChangeAutographPanel, "CommanderInfo/UIChangeAutographPanel", "UIChangeAutographPanel")
	UISystem:AddDefine(UIDef.UICommonGetGunPanel, "Gashapon/GashaponChrWeaponDisplayPanelV2", "UICommonGetGunPanel")
	UISystem:AddDefine(UIDef.UIDormCharacterSelectPanel, "Dorm/UIDormCharacterSelectPanel", "UIDormCharacterSelectPanel")
	UISystem:AddDefine(UIDef.UIGuideWindows, "UICommonFramework/ComGuideDialogV2", "UIGuideWindows")
	UISystem:AddDefine(UIDef.UIWeaponSkillInfoPanel, "Character/ChrWeaponSkillInfoPanelV2", "UIWeaponSkillInfoPanel")
	UISystem:AddDefine(UIDef.UICommonLvUpPanel, "UICommonFramework/ComLevelUpSuccessfulPanelV2", "UICommonLvUpPanel")
	UISystem:AddDefine(UIDef.UICommonBreakSucPanel, "UAV/ComBreakthroughSuccessPanelV2", "UICommonBreakSucPanel")
	UISystem:AddDefine(UIDef.UIChapterRewardPanel, "story/StoryChapterRewardlDialogV2", "UIChapterRewardPanel")
	UISystem:AddDefine(UIDef.UISysGuideWindow, "UICommonFramework/ComGuideDialogV2", "UISysGuideWindow")
	UISystem:AddDefine(UIDef.UIFriendBlackListPanel, "Friend/FriendBlackListDialogV2", "UIFriendBlackListPanel")
	UISystem:AddDefine(UIDef.UICommonModifyPanel, "CommanderInfo/CommanderNameModifyDialogV2", "UICommonModifyPanel")
	UISystem:AddDefine(UIDef.UICommonSignModifyPanel, "CommanderInfo/CommanderSignModifyDialogV2", "UICommonSignModifyPanel")
	UISystem:AddDefine(UIDef.UICommonAvatarModifyPanel, "CommanderInfo/CommanderAvatarModifyDialogV2", "UICommonAvatarModifyPanel")
	UISystem:AddDefine(UIDef.UICommonSelfModifyPanel, "CommanderInfo/CommanderNameSelfModifyDialogV2", "UICommonSelfModifyPanel")
	UISystem:AddDefine(UIDef.SimCombatMythicRewardDialogV2, "SimCombat/SimCombatMythicRewardDialogV2", "SimCombatMythicRewardDialogV2")
	UISystem:AddDefine(UIDef.SimCombatMythicBuffDialogV2, "SimCombat/SimCombatMythicBuffDialogV2", "SimCombatMythicBuffDialogV2")
	UISystem:AddDefine(UIDef.SimCombatMythicAffixDialog, "SimCombat/SimCombatMythicAffixDialogV2", "SimCombatMythicAffixDialog")
	UISystem:AddDefine(UIDef.SimCombatMythicBuffSelPanel, "SimCombat/SimCombatMythicBuffSelPanelV2", "SimCombatMythicBuffSelPanel")
	UISystem:AddDefine(UIDef.UIRaidReceivePanel, "Raid/RaidReceiveDialogV2", "UIRaidReceivePanel")
	UISystem:AddDefine(UIDef.UIUAVPanel,"UAV/UAVPanelV2","UIUAVPanel")
	UISystem:AddDefine(UIDef.UIUAVSkillInfoDialogPanel,"UAV/UAVSkillInfoDialogV2","UAVSkillInfoDialogPanel")
	UISystem:AddDefine(UIDef.UIUAVFuelDialogPanel,"UAV/UAVFuelGetDialogV2","UAVFuelGetDialogPanel")
	UISystem:AddDefine(UIDef.UIUAVPartsSkillUpDialogPanel,"UAV/UAVPartsSkillUpDialogV2","UAVPartsSkillUpDialogPanel")

	UISystem:AddDefine(UIDef.UAVBreakDialogPanel,"UAV/UAVBreakDialogV2","UAVBreakDialogPanel")
	UISystem:AddDefine(UIDef.UAVLevelUpBreakPanel,"UICommonFramework/ComLevelUpSuccessfulPanelV2","UAVLevelUpBreakPanel")
	UISystem:AddDefine(UIDef.UAVFuelNotEnoughPanel,"UAV/UAVFuelNotEnoughDialogV2","UAVFuelNotEnoughPanel")

	UISystem:AddDefine(UIDef.UIStoreExchangePriceChangeDialog,"StoreExchange/StoreExchangePriceChangeDialogV2","UIStoreExchangePriceChangeDialog")
	UISystem:AddDefine(UIDef.UISimCombatTeachingPanel,"SimCombat/SimCombatTeachingPanelV2","UISimCombatTeachingPanel")
	UISystem:AddDefine(UIDef.UISimCombatTeachingRewardPanel,"SimCombat/SimCombatTeachingRewardDialogV2","UISimCombatTeachingRewardPanel")

	UISystem:AddDefine(UIDef.UICommonAffixDisplayPanel, "SimCombat/SimCombatMythicAffixDialogV2", "UICommonAffixDisplayPanel")
	UISystem:AddDefine(UIDef.UICommonBuffDisplayPanel, "SimCombat/SimCombatMythicBuffDialogV2", "UICommonBuffDisplayPanel")
	UISystem:AddDefine(UIDef.UICommonGunDisplayPanel, "SimCombat/SimcombatWeeklyUpChrDialogV2", "UICommonGunDisplayPanel")

	UISystem:AddDefine(UIDef.UIWeaponPartPanel, "Character/ChrWeaponPartsPowerUpPanelV2", "UIWeaponPartPanel")
	UISystem:AddDefine(UIDef.UIGachaShoppingDetailPanel,"Gashapon/GashaponProbabilityDetailsDialogV2","UIGachaShoppingDetailPanel")
	UISystem:AddDefine(UIDef.UIWeaponPartCailbrationSucPanel, "Character/ChrWeaponPartsPowerUpSuccessfulPanelV2", "UIWeaponPartCailbrationSucPanel")

	--10000以上做为临时面板，prefab不在UI目录下
	UISystem:AddDefine(UIDef.UIDormFavorabilityPanelV2, "lounge/_UI/UIPrefab/Dorm/DormFavorabilityPanelV2", "UIDormFavorabilityPanelV2")
	if (CS.UnityEngine.Screen.fullScreen and CS.GameRoot.Instance:IsPcdBiliSdkLogin()) then
		print("CS.UnityEngine.Screen.fullScreen:true");
		local oldResolution = CS.BattlePerformSetting.Resolution;
		local currentResolution = CS.UnityEngine.Screen.currentResolution;
		CS.GraphicsSettingsManager.Instance:SetScreenResolution(currentResolution.width, currentResolution.height, CS.UnityEngine.FullScreenMode.Windowed);
		function setResolution(msg)
			print("MessageSys:1090 set");
			CS.BattlePerformSetting.Resolution = oldResolution;
			CS.GF2.Message.MessageSys.Instance:RemoveListener(1090,setResolution);
		end
		CS.GF2.Message.MessageSys.Instance:AddListener(1090,setResolution);
	else
		print("CS.UnityEngine.Screen.fullScreen:false");
	end

end

function UIManager.OpenUIByParam(uiType, param)
	UISystem:OpenUI(uiType, param);
end

function UIManager.OpenUI(uiType)
	UISystem:OpenUI(uiType, nil);
end

function UIManager.JumpUI(uiType)
	UISystem:JumpUI(uiType)
end

function UIManager.JumpUIByParam(uiType, param)
	UISystem:JumpUI(uiType, param)
end

function UIManager.CloseUI(uiType)
	UISystem:CloseUI(uiType);
end

function UIManager.CloseUIByChangeScene(uiType)
	UISystem:CloseUI(uiType, false);
end

function UIManager.CloseUIByCallback(uiType, callback)
	UISystem:CloseUI(uiType, false, callback);
end

function UIManager.CloseUIAll()
	UISystem:CloseUIAll();
end

function UIManager.Set3DUICamera()
	UISystem:Set3DUICamera()
end

function UIManager.ClearUIStacks()
	UISystem:ClearUIStacks()
end

function UIManager.Update()
	for i = 1, UIManager.mUpdateUIs:Count() do
		UIManager.mUpdateUIs[i]:Update();
	end
end

function UIManager.RegisterUpdate(ui)
	if not UIManager.mUpdateUIs:Contains(ui) then
		UIManager.mUpdateUIs:Add(ui);
	end
end

function UIManager.UnregisterUpdate(ui)
	UIManager.mUpdateUIs:Remove(ui);
end

function UIManager.JumpToMainPanel()
	UISystem:JumpToMainPanel()
end

function UIManager.EnableFacilityBarrack(enable)
	UISystem:EnableFacilityBarrack(enable)
end

function UIManager.GetResourceBarSortOrder()
	return UISystem:GetResourceBarSortOrder()
end

function UIManager.GetTopPanelSortOrder()
	return UISystem:GetTopPanelSortOrder()
end

function UIManager.ChangeCacheUIData(uiDef, uiParam)
	UISystem:ChangeCacheUIData(uiDef, uiParam)
end

function UIManager.SetCharacterCameraScaleModelId(modelId)
	UISystem:SetCharacterCameraScaleModelId(modelId)
end

--- 不包含pop界面
function UIManager.GetTopPanelId()
	return UISystem:GetStackTopUIWithoutPop()
end

function UIManager.IsModelPanel()
	local id = UIManager.GetTopPanelId()
	for _, panelId in ipairs(UIManager.ModelPanel) do
		if id == panelId then
			return true
		end
	end
	return false
end
--endregion
