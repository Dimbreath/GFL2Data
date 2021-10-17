print("Load Main.lua")
require("Data.DataInit")
require("Data.StageCfg.Stage_10101")
require("Data.StageCfg.Stage_1026")
require("Data.StageCfg.Stage_1027")
require("Data.StageCfg.Stage_1029")
require("Data.StageCfg.Stage_1030")
require("Data.StageCfg.Stage_1031")
require("Data.StageCfg.Stage_5001")
require("Data.StageCfg.Stage_5002")
require("Data.StageCfg.Stage_5004")
require("Data.StageCfg.Stage_5007")
require("Data.StageCfg.Stage_5008")
require("Lib.class")
require("Lib.Console")
require("Lib.Dictionary")
require("Lib.FuncTools")
require("Lib.GFLib")
require("Lib.List")
require("Lib.TableTools")
require("NetCmd.LuaNullClientCmd")
require("NetCmd.LuaRes_roleInfo")
require("NetCmd.NetLib")
require("NetCmd.Patch")
require("perf.memory")
require("perf.profiler")
require("Sample.UIItemSample")
require("Sample.UIPanelSample")
require("Sample.UIViewSample")
require("UI.ColorUtils")
require("UI.GlobalConfig")
require("UI.UIBaseCtrl")
require("UI.UIBasePanel")
require("UI.UIBaseView")
require("UI.UICNWords")
require("UI.UIDef")
require("UI.UIManager")
require("UI.UITweenCamera")
require("UI.UIUtils")
require("UI.AchievementListItem.UIAchievementListItem")
require("UI.AchievementPanel.UIAchievementPanel")
require("UI.AchievementPanel.UIAchievementPanelV2")
require("UI.AchievementPanel.UIAchievementPanelV2View")
require("UI.AchievementPanel.UIAchievementPanelView")
require("UI.AchievementPanel.Item.UIAchievementItemV2")
require("UI.AchievementPanel.Item.UIAchievementLeftTabItemV2")
require("UI.AdjutantPanel.UIAdjutantListItem")
require("UI.AdjutantPanel.UIAdjutantPanel")
require("UI.AdjutantPanel.UIAdjutantPanelView")
require("UI.AdjutantPanel.UIAdjutantSkinIconItem")
require("UI.AdjutantPanel.UIAdjutantTypeListItem")
require("UI.AdjutantPanel.AdjutantItem.UIAdjutantItem")
require("UI.ArchivesPanel.UIArchivesPanelView")
require("UI.ArchivesPanel.Item.UIArchivesCampInfoDetailItem")
require("UI.ArchivesPanel.Item.UIArchivesCampInfoEnteranceItem")
require("UI.AutoMax.UIAutoMaxComfirm_EnemyVehicleSlotItem")
require("UI.AutoMax.UIAutoMaxComfirm_PlayerVehicleSlotItem")
require("UI.AutoMax.UIAutoMaxConfirmPanel")
require("UI.AutoMax.UIAutoMaxConfirmPanelView")
require("UI.AutoMax.UIAutoMaxPanel")
require("UI.AutoMax.UIAutoMaxPanelView")
require("UI.AutoMax.UIAutoMaxPerfomancePanelView")
require("UI.AutoMax.UIAutoMaxPerformance_EnemyTeamInfoItem")
require("UI.AutoMax.UIAutoMaxPerformance_PlayerTeamInfoItem")
require("UI.AutoMax.UIAutoMaxResultPanelView")
require("UI.AutoMax.UIAutoMaxRewardItemItem")
require("UI.AutoMax.UIAutoMaxSettlementPanelView")
require("UI.AutoMax.UIAutoMaxSettlementVehicleInfoItem")
require("UI.AutoMax.UIAutoMaxSettlement_EnemyVehicleSlotItem")
require("UI.AutoMax.UIAutoMaxSettlement_PlayerVehicleSlotItem")
require("UI.AutoMax.UIAutoMaxSettlement_RewardItemItem")
require("UI.AutoMax.UIAutoMaxTurnDetailItem")
require("UI.AutoMax.UIAutoMaxTurnDetail_EnemySlotItem")
require("UI.AutoMax.UIAutoMaxTurnDetail_PlayerSlotItem")
require("UI.AutoMax.UIAutoMaxTurnDetail_TurnItem")
require("UI.AVG.UIAvgDialogueBoxPanel")
require("UI.BattleIndexPanel.UIBattleIndexPanel")
require("UI.BattleIndexPanel.UIBattleIndexPanelView")
require("UI.BattleIndexPanel.Content.UIChapterInfoPanel")
require("UI.BattleIndexPanel.Content.UISimCombatInfoPanel")
require("UI.BattleIndexPanel.Item.BattleIndexListItem")
require("UI.BattleIndexPanel.Item.UIBattleIndexLine")
require("UI.BattleIndexPanel.Item.UIHardChapterItem")
require("UI.BattleIndexPanel.Item.UIMainChapterItem")
require("UI.BattleIndexPanel.Item.UISimCombatItem")
require("UI.BattleSettlementPanel.UIChallengeAwardItem")
require("UI.BattleSettlementPanel.UIGunInformationItem")
require("UI.BattleSettlementPanel.UIIntegralItem")
require("UI.BattleSettlementPanel.UISettlementAwardItem")
require("UI.BattleSettlementTask.UIBattleSettlementTask")
require("UI.Campaign.UICampaignMissionPanel")
require("UI.Campaign.UICampaignMissionView")
require("UI.Campaign.UIDispatchPanel")
require("UI.Campaign.UIDispatchView")
require("UI.Campaign.UIMaintainPanel")
require("UI.Campaign.UIMaintainView")
require("UI.Campaign.UIRepairConfirmPanel")
require("UI.Campaign.UIRepairConfirmView")
require("UI.Campaign.UITeamInfoPanel")
require("UI.Campaign.UITeamInfoView")
require("UI.Campaign.Item.MaintainViewItem")
require("UI.Campaign.Item.UICampaignMissionItem")
require("UI.Campaign.Item.UIDispatchTeamItem")
require("UI.Carrier.UICarrierItem")
require("UI.Carrier.UICarrierSelectionPanel")
require("UI.Carrier.UICarrierSelectionView")
require("UI.CarrierPart.UICarrierPartDetailMaterialItem")
require("UI.CarrierPart.UICarrierPartDetailPanel")
require("UI.CarrierPart.UICarrierPartDetailPanelView")
require("UI.CarrierPart.UICarrierPartDetailPropertyItem")
require("UI.CarrierPart.UICarrierPartDetailSelectMaterialItem")
require("UI.CarrierPart.UICarrierPartSelectionPanelView")
require("UI.ChapterPanel.UIChapterGlobal")
require("UI.ChapterPanel.UIChapterHardPanel")
require("UI.ChapterPanel.UIChapterHardPanelView")
require("UI.ChapterPanel.UIChapterPanel")
require("UI.ChapterPanel.UIChapterPanelView")
require("UI.ChapterPanel.UIChapterRewardPanel")
require("UI.ChapterPanel.UIChapterRewardPanelView")
require("UI.ChapterPanel.Item.UIChapterLineItem")
require("UI.ChapterPanel.Item.UIChapterRewardItem")
require("UI.ChapterPanel.Item.UIChapterStageItem")
require("UI.ChapterPanel.Item.UIStoryStageHardItem")
require("UI.ChapterPanel.Item.UIStoryStageItem")
require("UI.ChapterSelect.UIChapterSelect3DView")
require("UI.ChapterSelect.UIChapterSelectChapterItem")
require("UI.ChapterSelect.UIChapterSelectPanel")
require("UI.ChapterSelect.UIChapterSelectView")
require("UI.Character.ChrEquipSuitDropdownItemV2")
require("UI.Character.ChrEquipSuitListItemV2")
require("UI.Character.UICharacterInfoItem")
require("UI.Character.UICharacterItem")
require("UI.Character.UICharacterSelectionPanel")
require("UI.Character.UICharacterSelectionView")
require("UI.Character.UIComStageItemV2")
require("UI.Character.UIPropertyExpandedItem")
require("UI.Character.UIPropertyExpandedItemView")
require("UI.Character.UIPropertyFoldItem")
require("UI.Character.Item.UIChrInfoBtnItemV2")
require("UI.Character.Item.UIChrInfoItemV2")
require("UI.Character.Item.UISkillIconCtrl")
require("UI.Character.Item.UIUnitPropertyItemV2")
require("UI.CharacterPowerUpPanel.UICharacterPowerUpPanel")
require("UI.CharacterPowerUpPanel.UICharacterPowerUpPanelView")
require("UI.CharacterSelectionItem.CharacterSelectionItem")
require("UI.CharacterSettlementItem.CharacterSettlementItem")
require("UI.CharacterSkinPanel.UICharacterSkinPanel")
require("UI.CharacterSkinPanel.UICharacterSkinPanelView")
require("UI.ChatPanel.UIChatGlobal")
require("UI.ChatPanel.UIChatPanel")
require("UI.ChatPanel.UIChatPanelView")
require("UI.ChatPanel.Data.ChatTabData")
require("UI.ChatPanel.Item.UIChatContentItem")
require("UI.ChatPanel.Item.UIChatListItem")
require("UI.ChatPanel.Item.UIChatSystemItem")
require("UI.ChatPanel.Item.UIChatTabItem")
require("UI.CombatLauncherPanel.UICombatLauncherItem")
require("UI.CombatLauncherPanel.UICombatLauncherPanelItem")
require("UI.CombatLauncherPanel.Item.RaidAndAutoBattleBtnItem")
require("UI.CombatLauncherPanel.Item.UICombatLauncherChallengeItem")
require("UI.CombatLauncherPanel.Item.UICombatLauncherDropListItem")
require("UI.CombatLauncherPanel.Item.UICombatLauncherEnemyInfoItem")
require("UI.CombatLauncherPanel.Item.UICommonEnemyItem")
require("UI.CombatLoadingPanel.UICombatLoadingPanelView")
require("UI.CombatPreparationPanel.GunModelCtr")
require("UI.CombatPreparationPanel.PreparationNameplate")
require("UI.CombatPreparationPanel.UICombatGunPreparationItem")
require("UI.CombatPreparationPanel.UICombatPreparationPanel")
require("UI.CombatPreparationPanel.UICombatPreparationPanelView")
require("UI.CombatPreparationPanel.UICombatPreparationSkillItem")
require("UI.CombatPreparationPanel.UICombatPreparation_EnemyUnitMarkItem")
require("UI.CombatPreparationPanel.UICombatPreparation_GunSlotItem")
require("UI.CombatPreparationPanel.UICombatPreparation_PlayerUnitMarkItem")
require("UI.CombatPreparationPanel.UICombatStageTaskItem")
require("UI.CombatPreparationPanel.UIEnemyGrid")
require("UI.CombatStageStepItem.UICombatStageStepItem")
require("UI.CombatTacticSkillPanel.CombatTacticSkillPanelView")
require("UI.CommandCenterPanel.UICommandCenterPanel")
require("UI.CommandCenterPanel.UICommandCenterPanelView")
require("UI.CommanderCustomMadePanel.UICommanderCustomMadePanel")
require("UI.CommanderCustomMadePanel.UICommanderCustomMadePanelView")
require("UI.CommanderCustomMadePanel.item.UIColorPickerItem")
require("UI.CommanderCustomMadePanel.item.UICostumeItem")
require("UI.CommanderCustomMadePanel.item.UICustomItem")
require("UI.CommanderCustomMadePanel.item.UIExpressionItem")
require("UI.CommanderCustomMadePanel.item.UILocationPickerItem")
require("UI.CommanderCustomMadePanel.item.UIPresetColorItem")
require("UI.CommanderCustomMadePanel.item.UITemplateItem")
require("UI.CommanderInfoPanel.UIChangeAutographPanel")
require("UI.CommanderInfoPanel.UIChangeAutographPanelView")
require("UI.CommanderInfoPanel.UICommanderInfoPanel")
require("UI.CommanderInfoPanel.UICommanderInfoPanelV2")
require("UI.CommanderInfoPanel.UICommanderInfoPanelV2View")
require("UI.CommanderInfoPanel.UICommanderInfoPanelView")
require("UI.CommanderInfoPanel.Content.UIAchievementSubPanel")
require("UI.CommanderInfoPanel.Content.UIAchievementSubPanelView")
require("UI.CommanderInfoPanel.Content.UISettingSubPanel")
require("UI.CommanderInfoPanel.Content.UISettingSubPanelView")
require("UI.CommanderInfoPanel.Item.UIAchievementAllItem")
require("UI.CommanderInfoPanel.Item.UIPlayerInfoItem")
require("UI.CommanderInfoPanel.Item.UISupportGunItem")
require("UI.Common.CommonHintManager")
require("UI.Common.HalfDetailViewItem")
require("UI.Common.HeadViewItem")
require("UI.Common.PropertyItemD")
require("UI.Common.PropertyItemS")
require("UI.Common.RewardItem")
require("UI.Common.UICommonDutyItem")
require("UI.Common.UICommonElementItem")
require("UI.Common.UICommonEquipBrief")
require("UI.Common.UICommonGetWayItem")
require("UI.Common.UICommonGetWayTitleItem")
require("UI.Common.UICommonGrpItem")
require("UI.Common.UICommonHintItem")
require("UI.Common.UICommonHintTipsItem")
require("UI.Common.UICommonItem")
require("UI.Common.UICommonItemL")
require("UI.Common.UICommonItemList")
require("UI.Common.UICommonItemS")
require("UI.Common.UICommonLeftTabItemV2")
require("UI.Common.UICommonPlayerAvatarItem")
require("UI.Common.UICommonPropertyItem")
require("UI.Common.UICommonReceiveItem")
require("UI.Common.UICommonReceivePanel")
require("UI.Common.UICommonReceivePanelView")
require("UI.Common.UICommonReceiveTipsItem")
require("UI.Common.UICommonSettingButtonItem")
require("UI.Common.UICommonSettingDropDownItem")
require("UI.Common.UICommonSettingItem")
require("UI.Common.UICommonSoldGetItem")
require("UI.Common.UICommonSoldToGetItem")
require("UI.Common.UICommonStageItem")
require("UI.Common.UICommonTabButtonItem")
require("UI.Common.UICommonWeaponBrief")
require("UI.Common.UICommonWeaponInfoItem")
require("UI.Common.UIComTabBtn1Item")
require("UI.Common.UIEquipFullMessageView")
require("UI.Common.UIEquipOverViewItem")
require("UI.Common.UIExtendedPanel")
require("UI.Common.UIGetWayView")
require("UI.Common.UILoadingMaskPanelView")
require("UI.Common.UIMsgBosItemlistItem")
require("UI.Common.UISkillDetailPanel")
require("UI.Common.UIUniTopbar")
require("UI.CommonGetGunPanel.UICommonGetGunPanel")
require("UI.CommonGetGunPanel.UICommonGetGunPanelView")
require("UI.CommonLevelUpPanel.UICommonBreakSucPanel")
require("UI.CommonLevelUpPanel.UICommonBreakSucPanelView")
require("UI.CommonLevelUpPanel.UICommonLevelUpPanel")
require("UI.CommonLevelUpPanel.UICommonLevelUpPanelView")
require("UI.CommonLevelUpPanel.UICommonLvUpPanel")
require("UI.CommonLevelUpPanel.Data.CommonLvUpData")
require("UI.CommonLevelUpPanel.Item.LevelUpProperty")
require("UI.CommonReadmePanel.UICommonReadmePanel")
require("UI.CommonReadmePanel.UICommonReadmePanelView")
require("UI.CommonReadmePanel.UITutorialInfoPanel")
require("UI.CommonReadmePanel.UITutorialInfoPanelView")
require("UI.CompleteTaskItem.UICompleteTaskItem")
require("UI.DailyCheckInPanel.UIDailyCheckInPanel")
require("UI.DailyCheckInPanel.UIDailyCheckInPanelView")
require("UI.DailyCheckInPanel.Item.UICheckInItem")
require("UI.DailyQuestPanel.UIDailyQuestPanel")
require("UI.DailyQuestPanel.UIDailyQuestPanelView")
require("UI.DailyQuestPanel.Item.UIDailyQuestListItem")
require("UI.DailyQuestPanel.Item.UIDailyRewardItem")
require("UI.DailyQuestPanel.Item.UIQuestRewardDialog")
require("UI.DailyQuestPanel.Item.UIQuestRewardItem")
require("UI.DailyQuestPanel.Item.UIQuestTypeItem")
require("UI.DailyQuestPanel.Item.UIRookieQuestItem")
require("UI.DailyQuestPanel.Item.UIWeeklyQuestListItem")
require("UI.DismantlingResult.UIDismantlingResult")
require("UI.DismantlingResult.UIDismantlingResultItem")
require("UI.Dorm.Btn_CharacterSlotsItem")
require("UI.Dorm.FavorGainItem")
require("UI.Dorm.UIDormCharacterSelectPanel")
require("UI.Dorm.UIDormCharacterSelectPanelView")
require("UI.Dorm.UIDormFavorabilityPanelV2")
require("UI.Dorm.UIDormFavorabilityPanelV2View")
require("UI.Dorm.UIDormPopItem")
require("UI.Dorm.UIDormSkinChangePanel")
require("UI.Dorm.UIDormSkinChangePanelView")
require("UI.DormBarItem.UIDormBarItem")
require("UI.DormCharacterSkinPanel.UIDormCharacterSkinPanel")
require("UI.DormCharacterSkinPanel.UIDormCharacterSkinPanelView")
require("UI.DormItemChangePanel.UIDormItemChangePanel")
require("UI.DormItemChangePanel.UIDormItemChangePanelView")
require("UI.DormMainPanel.UIDormMainPanel")
require("UI.DormMainPanel.UIDormMainPanelView")
require("UI.DormNodeItem.UIDormNodeItem")
require("UI.DormSelectItem.UIDormSelectItem")
require("UI.DoUpgradePanel.UIDoUpgradePanel")
require("UI.EnemyInfoPanel.UIBuffItem")
require("UI.EnemyInfoPanel.UIEnemyInfoPanel")
require("UI.EnemyInfoPanel.UIEnemyInfoPanelView")
require("UI.EnemyInfoPanel.UISkillItem")
require("UI.EquipPanel.UICharacterEquipPanel")
require("UI.EquipPanel.UICharacterEquipPanelView")
require("UI.EquipPanel.UIEquipGlobal")
require("UI.EquipPanel.UIEquipPanel")
require("UI.EquipPanel.UIEquipPanelView")
require("UI.EquipPanel.Content.UIEquipEnhanceContent")
require("UI.EquipPanel.Content.UIEquipEnhanceView")
require("UI.EquipPanel.Item.UIEquipMaterialItem")
require("UI.EquipPanel.Item.UIEquipMaterialItemS")
require("UI.EquipPanel.Item.UIEquipSetItem")
require("UI.EquipPanel.Item.UIEquipSortContent")
require("UI.EquipPanel.Item.UIEquipSuitDropdownItem")
require("UI.ExpeditionPanel.UIExpeditionPanel")
require("UI.ExpeditionPanel.UIExpeditionPanelView")
require("UI.ExpeditionSettlementPanel.UIExpeditionSettlementPanel")
require("UI.ExpeditionSettlementPanel.UIExpeditionSettlementPanelView")
require("UI.ExpeditionTaskItem.UIExpeditionTaskItem")
require("UI.ExpeditionTaskPanel.UIExpeditionTaskPanel")
require("UI.ExpeditionTaskPanel.UIExpeditionTaskPanelView")
require("UI.ExpeditionTeamDispatchItem.UIExpeditionTeamDispatchItem")
require("UI.ExpeditionTypeItem.UIExpeditionTypeItem")
require("UI.FacilityBarrackPanel.FacilityBarrackGlobal")
require("UI.FacilityBarrackPanel.UICharacterDetailPanel")
require("UI.FacilityBarrackPanel.UICharacterDetailPanelView")
require("UI.FacilityBarrackPanel.UIFacilityBarrackPanel")
require("UI.FacilityBarrackPanel.UIFacilityBarrackPanelView")
require("UI.FacilityBarrackPanel.Content.UIBarrackContentBase")
require("UI.FacilityBarrackPanel.Content.UIEquipContetn")
require("UI.FacilityBarrackPanel.Content.UIGunInfoContent")
require("UI.FacilityBarrackPanel.Content.UILevelUpContent")
require("UI.FacilityBarrackPanel.Content.UIMentalContent")
require("UI.FacilityBarrackPanel.Content.UIModelToucher")
require("UI.FacilityBarrackPanel.Content.UISkillContent")
require("UI.FacilityBarrackPanel.Content.UISkillUpConfirm")
require("UI.FacilityBarrackPanel.Content.UIUpgradeContent")
require("UI.FacilityBarrackPanel.Content.UIWeaponContent")
require("UI.FacilityBarrackPanel.Item.UIBarrackBriefItem")
require("UI.FacilityBarrackPanel.Item.UIBarrackCardDisplayItem")
require("UI.FacilityBarrackPanel.Item.UIBarrackChrCardItem")
require("UI.FacilityBarrackPanel.Item.UIBarrackMainTabItem")
require("UI.FacilityBarrackPanel.Item.UIBarrackTabItem")
require("UI.FacilityBarrackPanel.Item.UIGunExpItem")
require("UI.FacilityBarrackPanel.Item.UIGunSortItem")
require("UI.FacilityBarrackPanel.Item.UISkillDetailItem")
require("UI.FacilityLvUp.UIBaseCollectResResultPanel")
require("UI.FacilityLvUp.UIBaseCollectResResultView")
require("UI.FacilityLvUp.UIBaseResourceDetailPanel")
require("UI.FacilityLvUp.UIBaseResourceDetailPanelView")
require("UI.FacilityLvUp.UIFacilityLvUpPanel")
require("UI.FacilityLvUp.UIFacilityLvUpPanelView")
require("UI.FacilityLvUp.Item.BaseResourceItem")
require("UI.FacilityLvUp.Item.FacilityLvUpLine")
require("UI.FacilityLvUp.Item.FacilityLvUpListItem")
require("UI.FacilityLvUp.Item.FacilityLvUpNode")
require("UI.FacilityLvUp.Item.FacilityLvUpReqItem")
require("UI.FacilityLvUp.Item.ResFacilityListItem")
require("UI.Formation.UIFormationCarrierItem")
require("UI.Formation.UIFormationDetailItem")
require("UI.Formation.UIFormationGunListItem")
require("UI.Formation.UIFormationMemberItem")
require("UI.Formation.UIFormationPanel")
require("UI.Formation.UIFormationSelectItem")
require("UI.Formation.UIFormationTeammateItem")
require("UI.Formation.UIFormationTeamTipItem")
require("UI.Formation.UIFormationView")
require("UI.Formation.UI_TeamSelTempPanel")
require("UI.Formation.UI_TeamSelTempView")
require("UI.FriendPanel.UIFriendBlackListPanel")
require("UI.FriendPanel.UIFriendBlackListPanelView")
require("UI.FriendPanel.UIFriendGlobal")
require("UI.FriendPanel.UIFriendPanel")
require("UI.FriendPanel.UIFriendPanelView")
require("UI.FriendPanel.UIPlayerInfoPanel")
require("UI.FriendPanel.UIPlayerInfoPanelView")
require("UI.FriendPanel.Item.UIFriendBlackItem")
require("UI.FriendPanel.Item.UIFriendInfoItem")
require("UI.FriendPanel.Item.UIFriendsListItem")
require("UI.FriendPanel.Item.UIFriendSortItem")
require("UI.FriendPanel.Item.UIFriendTabItem")
require("UI.GarageMain.UIGarageMainPanel")
require("UI.GarageMain.UIGarageMainView")
require("UI.GarageMain.UIVehicleCardElementMainItem")
require("UI.GarageVechicleDetail.UIGaragePreviewPartItem")
require("UI.GarageVechicleDetail.UIGarageVechicleDetailPanel")
require("UI.GarageVechicleDetail.UIGarageVechicleDetailView")
require("UI.GarageVechicleDetail.UIPartListElementItem")
require("UI.GarageVechicleDetail.UIPartSlotItem")
require("UI.GarageVechicleDetail.UIPrefixTypeItem")
require("UI.GarageVechicleDetail.UIPropertyCompareItem")
require("UI.Gashapon.BtnTabDisplayItem")
require("UI.Gashapon.CardDisplayItem")
require("UI.Gashapon.EventDropGunItem")
require("UI.Gashapon.GachaEventItem")
require("UI.Gashapon.TabDisplayItem")
require("UI.Gashapon.UIFrontLayerCanvasView")
require("UI.Gashapon.UIGachaDisplayPanelView")
require("UI.Gashapon.UIGachaDropDetailItem")
require("UI.Gashapon.UIGachaItemRateItem")
require("UI.Gashapon.UIGachaMainPanelV2")
require("UI.Gashapon.UIGachaMainPanelV2View")
require("UI.Gashapon.UIGachaMainPanelView")
require("UI.Gashapon.UIGachaResultPanel")
require("UI.Gashapon.UIGachaResultPanelV2")
require("UI.Gashapon.UIGachaResultPanelV2View")
require("UI.Gashapon.UIGachaResultPanelView")
require("UI.Gashapon.UIGachaShoppingDetailPanel")
require("UI.Gashapon.UIGachaShoppingDetailPanelView")
require("UI.Gashapon.UIGachaSkipItem")
require("UI.Gashapon.UIGashaponFrontLayerItem")
require("UI.Gashapon.UIGashaponItem")
require("UI.Gashapon.UIGashaponItemNew")
require("UI.Gashapon.UIGashaponMainPanel")
require("UI.Gashapon.UIGashaponMainView")
require("UI.Gashapon.Item.GashaponChrUpItemV2")
require("UI.Gashapon.Item.GashaponDialogLeftTabItemV2")
require("UI.Gashapon.Item.GashaponOddsDeatailsItemV2")
require("UI.Gashapon.Item.GashaponOddsPublicityItemV2")
require("UI.Gashapon.Item.UIGachaLeftTabItemV2")
require("UI.Gashapon.Item.UIGashaponCardDisplayItemV2")
require("UI.Gashapon.Item.UILimitGachaLeftTabItemV2")
require("UI.GetChapterRewardItem.GetChapterRewardItem")
require("UI.GetWayPanel.UIGetWayPanel")
require("UI.GetWayPanel.UIGetWayPanelView")
require("UI.GuildPanel.UIGuildGlobal")
require("UI.GuildPanel.UIGuildPanel")
require("UI.GuildPanel.UIGuildPanelView")
require("UI.GuildPanel.Item.UIGuildContentBase")
require("UI.GuildPanel.Item.UIGuildDonationItem")
require("UI.GuildPanel.Item.UIGuildInfoItem")
require("UI.GuildPanel.Item.UIGuildLevelInfoItem")
require("UI.GuildPanel.Item.UIGuildListItem")
require("UI.GuildPanel.Item.UIGuildMainItem")
require("UI.GuildPanel.Item.UIGuildQuestItem")
require("UI.GuildPanel.Item.UIGuildWelfareItem")
require("UI.GuildPanel.Item.UIJoinGuildItem")
require("UI.GuildPanel.Item.UIMemberListItem")
require("UI.LevelUpRewardPanel.GetRewardItem")
require("UI.LevelUpRewardPanel.UnlockItem")
require("UI.Logic.CommonGunUtils")
require("UI.LoginPanel.UILoginPanelView")
require("UI.MadMax.UIMaxPanel")
require("UI.MadMax.UIMaxPanelView")
require("UI.MailPanel.UIMailPanel")
require("UI.MailPanel.UIMailPanelView")
require("UI.MailPanel.Item.UIMailListItem")
require("UI.MailPanel.Item.UIMailTipsItem")
require("UI.MailPanelV2.UIMailPanelV2")
require("UI.MailPanelV2.UIMailPanelV2View")
require("UI.MailPanelV2.Item.UIMailLeftTabItemV2")
require("UI.MaxPanelNew.UIMaxPanelNew")
require("UI.MaxPanelNew.UIMaxPanelNewView")
require("UI.MemoryChipPanel.UIMemoryChipPanel")
require("UI.MemoryChipPanel.UIMemoryChipPanelView")
require("UI.MemoryChipPanel.item.UIChipConsumeItem")
require("UI.MessageBox.MessageBoxPanel")
require("UI.MessageBox.Data.MessageContent")
require("UI.MotherBasePanel.UIMotherBasePanelView")
require("UI.Nameplate.Nameplate")
require("UI.OldDailyQuestPanel.UIOldDailyQuestPanelView")
require("UI.OrderSLGSelectPanel.UIOrderSLGSelectPanelView")
require("UI.PageTutorialPanel.UIPageTutorialPanelView")
require("UI.PanelItemHowToGet.UIHowToGetInfoItem")
require("UI.PanelItemHowToGet.UIHowToGetTypeItem")
require("UI.PanelItemHowToGet.UIPanelItemHowToGetView")
require("UI.PlayerHeadInforItem.PlayerHeadInforItem")
require("UI.PosterPanel.UIPosterPanel")
require("UI.PosterPanel.UIPosterPanelView")
require("UI.PostPanel.UIPostPanel")
require("UI.PostPanel.UIPostPanelView")
require("UI.PostPanel.item.UIPostContentTemplete_ButtonItem")
require("UI.PostPanel.item.UIPostContentTemplete_ImageItem")
require("UI.PostPanel.item.UIPostContentTemplete_ItemListItem")
require("UI.PostPanel.item.UIPostContentTemplete_TextItem")
require("UI.PostPanel.item.UIPostListItem")
require("UI.PostPanelV2.UIPostPanelV2")
require("UI.PostPanelV2.UIPostPanelV2View")
require("UI.PostPanelV2.item.UIPostLeftTabItemV2")
require("UI.PostPanelV2.item.UIPostRightBannerItemV2")
require("UI.PostPanelV2.item.UIPostRightButtonItemV2")
require("UI.PostPanelV2.item.UIPostRightItemV2")
require("UI.PostPanelV2.item.UIPostRightTextDescriptionItemV2")
require("UI.PostPanelV2.item.UIPostRightTextTitleItemV2")
require("UI.PostPanelV2.item.UIPostTopTabItemV2")
require("UI.PreparationRoot.PreparationUIRoot")
require("UI.PVP.UINRTPVPPanel")
require("UI.PVP.UINRTPVPPanelView")
require("UI.PVP.UIPVPGlobal")
require("UI.PVP.Item.NRTPVPGunItem")
require("UI.PVP.Item.NRTPVPOpponentItem")
require("UI.PVP.Item.UIPVPGradeUpItem")
require("UI.PVP.Item.UIPVPSettleItem")
require("UI.QuicklyBuyPanelItem.UIQuickCorePanelItemView")
require("UI.QuicklyBuyPanelItem.UIQuicklyBuyPanelItemView")
require("UI.RaidAndAutoBattle.UIAutoBattleEndPanel")
require("UI.RaidAndAutoBattle.UIAutoBattleEndPanelView")
require("UI.RaidAndAutoBattle.UIAutoBattlePanel")
require("UI.RaidAndAutoBattle.UIAutoBattlePreSetPanel")
require("UI.RaidAndAutoBattle.UIAutoBattlePreSetView")
require("UI.RaidAndAutoBattle.UIAutoBattleView")
require("UI.RaidAndAutoBattle.UIRaidDuringPanel")
require("UI.RaidAndAutoBattle.UIRaidPanel")
require("UI.RaidAndAutoBattle.UIRaidPanelView")
require("UI.RaidAndAutoBattle.UIRaidReceivePanel")
require("UI.RaidAndAutoBattle.UIRaidReceivePanelView")
require("UI.RankingPanel.UIRankingGlobal")
require("UI.RankingPanel.UIRankingPanel")
require("UI.RankingPanel.UIRankingPanelView")
require("UI.RankingPanel.Item.UIRankingItem")
require("UI.RedPoint.RadPointSystem")
require("UI.RedPoint.RedPointConst")
require("UI.RedPoint.RedPointNode")
require("UI.RepositoryPanel.UIRepositoryGlobal")
require("UI.RepositoryPanel.UIRepositoryPanel")
require("UI.RepositoryPanel.UIRepositoryPanelView")
require("UI.RepositoryPanel.Content.UIRepositoryBasePanel")
require("UI.RepositoryPanel.Content.UIRepositoryEquipOverViewPanel")
require("UI.RepositoryPanel.Content.UIRepositoryEquipPanel")
require("UI.RepositoryPanel.Content.UIRepositoryGunCorePanel")
require("UI.RepositoryPanel.Content.UIRepositoryItemPanel")
require("UI.RepositoryPanel.Content.UIRepositoryWeaponPanel")
require("UI.RepositoryPanel.Item.UISlotTypeItem")
require("UI.RepositoryPanelV2.UIRepositoryDecomposePanelV2")
require("UI.RepositoryPanelV2.UIRepositoryDecomposePanelV2View")
require("UI.RepositoryPanelV2.UIRepositoryPanelV2")
require("UI.RepositoryPanelV2.UIRepositoryPanelV2View")
require("UI.RepositoryPanelV2.Item.UIRepositoryListItemV2")
require("UI.ShootMessageSkillItem.ShootMessageSkillItemView")
require("UI.SimCombatPanel.UISimCombatEquipPanel")
require("UI.SimCombatPanel.UISimCombatEquipPanelView")
require("UI.SimCombatPanel.UISimCombatExpPanel")
require("UI.SimCombatPanel.UISimCombatExpPanelView")
require("UI.SimCombatPanel.UISimCombatGoldPanel")
require("UI.SimCombatPanel.UISimCombatGoldPanelView")
require("UI.SimCombatPanel.UISimCombatMythicPanel")
require("UI.SimCombatPanel.UISimCombatMythicPanelView")
require("UI.SimCombatPanel.UISimCombatRunesPanel")
require("UI.SimCombatPanel.UISimCombatRunesPanelView")
require("UI.SimCombatPanel.UISimCombatTeachingPanel")
require("UI.SimCombatPanel.UISimCombatTeachingPanelView")
require("UI.SimCombatPanel.UISimCombatTeachingRewardPanel")
require("UI.SimCombatPanel.UISimCombatTeachingRewardPanelView")
require("UI.SimCombatPanel.UISimCombatTrainingPanel")
require("UI.SimCombatPanel.UISimCombatTrainingPanelView")
require("UI.SimCombatPanel.UISimCombatWeeklyPanel")
require("UI.SimCombatPanel.UISimCombatWeeklyPanelView")
require("UI.SimCombatPanel.Item.SimCombatEquipItem")
require("UI.SimCombatPanel.Item.SimCombatRuneItem")
require("UI.SimCombatPanel.Item.SimCombatTrainingListItem")
require("UI.SimCombatPanel.Item.UISimCombatExpChapterSelListItemV2")
require("UI.SimCombatPanel.Item.UISimCombatGoldChapterSelListItemV2")
require("UI.SimCombatPanel.Item.UISimCombatMythicBuffItem")
require("UI.SimCombatPanel.Item.UISimCombatMythicRewardItem")
require("UI.SimCombatPanel.Item.UISimCombatTabButtonItem")
require("UI.SimCombatPanel.Item.UISimCombatTeachingChapterItemV2")
require("UI.SimCombatPanel.Item.UISimCombatTeachingLevelItemV2")
require("UI.SimCombatPanel.Item.UISimCombatTeachingRewardItemV2")
require("UI.SimCombatPanel.Item.UI_Btn_MythicStage")
require("UI.SimCombatPanel.MythicCombat.SimCombatMythicAffixDialog")
require("UI.SimCombatPanel.MythicCombat.SimCombatMythicAffixDialogView")
require("UI.SimCombatPanel.MythicCombat.SimCombatMythicBuffDialogV2")
require("UI.SimCombatPanel.MythicCombat.SimCombatMythicBuffDialogV2View")
require("UI.SimCombatPanel.MythicCombat.SimCombatMythicBuffSelPanel")
require("UI.SimCombatPanel.MythicCombat.SimCombatMythicBuffSelPanelV2View")
require("UI.SimCombatPanel.MythicCombat.SimCombatMythicRewardDialogV2")
require("UI.SimCombatPanel.MythicCombat.SimCombatMythicRewardDialogV2View")
require("UI.SimpleMessageBox.SimpleMessageBoxPanel")
require("UI.SkillCoreDetail.UISkillCoreDetailPanel")
require("UI.SkillCoreDetail.UISkillCoreDetailView")
require("UI.SkillCoreDetail.UISkillCoreSelectionPanel")
require("UI.SkillCoreDetail.UISkillCoreSelectionPanelView")
require("UI.SkillCoreDetail.item.SkillPUmatItem")
require("UI.SkillEdit.UICoreItem")
require("UI.SkillEdit.UICoreOverviewSpace")
require("UI.SkillEdit.UICoreSpace")
require("UI.SkillEdit.UICurSkillItem")
require("UI.SkillEdit.UISkillEditPanel")
require("UI.SkillEdit.UISkillEditView")
require("UI.SkinIconItem.UISkinIconItem")
require("UI.SkinOption.SkinOptionView")
require("UI.StoreCoin.StoreCoin")
require("UI.StoreExchangePanel.UIStoreExchangePanel")
require("UI.StoreExchangePanel.UIStoreExchangePanelView")
require("UI.StoreExchangePanel.UIStoreExchangeTopBarPanel")
require("UI.StoreExchangePanel.UIStoreExchangeTopBarPanelView")
require("UI.StoreExchangePanel.Item.ExchangeGoodsItem")
require("UI.StoreExchangePanel.Item.ExchangeTagItem")
require("UI.StorePanel.QuickStorePurchase")
require("UI.StorePanel.StoreBuyPanelView")
require("UI.StorePanel.StoreTabBtnItem")
require("UI.StorePanel.UICommonLackToBuyView")
require("UI.StorePanel.UIMainStorePanel")
require("UI.StorePanel.UIMainStorePanelView")
require("UI.StorePanel.UIStoreConfirmPanelView")
require("UI.StorePanel.UIStoreDiamondItem")
require("UI.StorePanel.UIStoreExchangePriceChangeDialog")
require("UI.StorePanel.UIStoreExchangePriceChangeDialogView")
require("UI.StorePanel.UIStoreGoodsItem")
require("UI.StorePanel.UIStoreMainPanel")
require("UI.StorePanel.UIStoreMainPanelView")
require("UI.StorePanel.UIStorePanel")
require("UI.StorePanel.UIStorePanelView")
require("UI.StorePanel.UIStoreSkinItem")
require("UI.StorePanel.UIStoreSkinPanel")
require("UI.StorePanel.UIStoreSkinPanelView")
require("UI.StorePanel.Item.StoreLackToBuyCoin")
require("UI.StorePanel.Item.Trans_AdvertisementPageItem")
require("UI.StorePanel.Item.UIGoodsItem")
require("UI.StorePanel.Item.UIGoodsItem_Big")
require("UI.StorePanel.Item.UIStoreAdvertisementItem")
require("UI.StorePanel.Item.UIStoreExchangePriceInfoItem")
require("UI.StorePanel.Item.UIStoreTagItem")
require("UI.Tips.TipsManager")
require("UI.Tips.UIComAccessItem")
require("UI.Tips.UIComItemDetailsPanelV2View")
require("UI.Tips.UIItemDetailPanelView")
require("UI.Tips.UITipsPanel")
require("UI.TopBannerPanel.UITopBannerPanel")
require("UI.TopBannerPanel.UITopBannerPanelView")
require("UI.TopBannerPanel.Item.UIBannerTextItem")
require("UI.UAVPanel.UAVAttributeItem")
require("UI.UAVPanel.UAVBreakDialogContent")
require("UI.UAVPanel.UAVChrSkillDescriptionItem")
require("UI.UAVPanel.UAVChrWeaponEquipInfoItem")
require("UI.UAVPanel.UAVContrastDialog")
require("UI.UAVPanel.UAVFuelGetDialogContent")
require("UI.UAVPanel.UAVFuelNotEnougContent")
require("UI.UAVPanel.UAVLevelUpBreakPanel")
require("UI.UAVPanel.UAVLevelUpBreakPanelView")
require("UI.UAVPanel.UAVPartsItem")
require("UI.UAVPanel.UAVPartsListItem")
require("UI.UAVPanel.UAVPartsSkillUpDialogContent")
require("UI.UAVPanel.UAVSkillInfoDialogContent")
require("UI.UAVPanel.UAVTacticSkillItem")
require("UI.UAVPanel.UAVUtility")
require("UI.UAVPanel.UIUAVContentBase")
require("UI.UAVPanel.UIUavExpItem")
require("UI.UAVPanel.UIUAVLevelUpContent")
require("UI.UAVPanel.UIUAVPanel")
require("UI.UAVPanel.UIUAVPanelView")
require("UI.UICharacterPropPanel.UICharacterPropPanel")
require("UI.UICharacterPropPanel.UICharacterPropPanelView")
require("UI.UICommonDisplayPanel.UICommonAffixDisplayPanel")
require("UI.UICommonDisplayPanel.UICommonAffixDisplayPanelView")
require("UI.UICommonDisplayPanel.UICommonBuffDisplayPanel")
require("UI.UICommonDisplayPanel.UICommonBuffDisplayPanelView")
require("UI.UICommonDisplayPanel.UICommonGunDisplayPanel")
require("UI.UICommonDisplayPanel.UICommonGunDisplayPanelView")
require("UI.UICommonDisplayPanel.Item.UICommonSkillItem")
require("UI.UICommonGetPanel.UICommonGetPanel")
require("UI.UICommonGetPanel.UICommonGetView")
require("UI.UICommonModifyPanel.UICommonAvatarModifyPanel")
require("UI.UICommonModifyPanel.UICommonAvatarModifyPanelView")
require("UI.UICommonModifyPanel.UICommonModifyPanel")
require("UI.UICommonModifyPanel.UICommonModifyPanelView")
require("UI.UICommonModifyPanel.UICommonSelfModifyPanel")
require("UI.UICommonModifyPanel.UICommonSelfModifyPanelView")
require("UI.UICommonModifyPanel.UICommonSignModifyPanel")
require("UI.UICommonModifyPanel.UICommonSignModifyPanelView")
require("UI.UICommonUnlockPanel.UICommonUnlockPanel")
require("UI.UICommonUnlockPanel.UICommonUnlockPanelView")
require("UI.UIGuideWindows.UIGuideIndicatorItemV2")
require("UI.UIGuideWindows.UIGuideWindows")
require("UI.UIGuideWindows.UIGuideWindowsView")
require("UI.UIMixPanel.UIMixConfirmPanel")
require("UI.UIMixPanel.UIMixConfirmPanelView")
require("UI.UIMixPanel.UIMixListItem")
require("UI.UIMixPanel.UIMixPanel")
require("UI.UIMixPanel.UIMixPanelView")
require("UI.UINickNamePanel.UINickNamePanel")
require("UI.UINickNamePanel.UINickNamePanelView")
require("UI.UISysGuideWindow.UISysGuideWindow")
require("UI.UIUnitInfoPanel.UIUnitInfoPanel")
require("UI.UIUnitInfoPanel.UIUnitInfoPanelView")
require("UI.UIUnitInfoPanel.Item.SkillExtraTextItem")
require("UI.UIUnitInfoPanel.Item.UIUnitInfoSkillItem")
require("UI.UniTopbar.UITopResourceBar")
require("UI.UniTopbar.UIUniTopBarPanel")
require("UI.UniTopbar.UIUniTopbarView")
require("UI.UniTopbar.Item.ResourcesCommonItem")
require("UI.UniTopbar.Item.UISystemCommonItem")
require("UI.WeaponPanel.UIWeaponGlobal")
require("UI.WeaponPanel.UIWeaponPanel")
require("UI.WeaponPanel.UIWeaponPanelView")
require("UI.WeaponPanel.UIWeaponPartCailbrationSucPanel")
require("UI.WeaponPanel.UIWeaponPartPanel")
require("UI.WeaponPanel.UIWeaponPartPanelView")
require("UI.WeaponPanel.UIWeaponSkillInfoPanel")
require("UI.WeaponPanel.UIWeaponSkillInfoPanelView")
require("UI.WeaponPanel.Content.UIWeaponBreakContent")
require("UI.WeaponPanel.Content.UIWeaponBreakContentView")
require("UI.WeaponPanel.Content.UIWeaponEnhanceContent")
require("UI.WeaponPanel.Content.UIWeaponEnhanceContentView")
require("UI.WeaponPanel.Content.UIWeaponListContent")
require("UI.WeaponPanel.Content.UIWeaponPartsReplaceContent")
require("UI.WeaponPanel.Item.UIBarrackWeaponInfoItem")
require("UI.WeaponPanel.Item.UIBarrackWeaponPartInfoItem")
require("UI.WeaponPanel.Item.UIWeaponDetailItem")
require("UI.WeaponPanel.Item.UIWeaponMaterialItem")
require("UI.WeaponPanel.Item.UIWeaponMaterialItemS")
require("UI.WeaponPanel.Item.UIWeaponPartItem")
require("UI.WeaponPanel.Item.UIWeaponPartSortItem")
require("UI.WeaponPanel.Item.UIWeaponReplaceItem")
require("UI.WeaponPanel.Item.UIWeaponSkillItem")
require("UI.WeaponPanel.Item.UIWeaponSoltItem")
require("UI.WeaponPanel.Item.UIWeaponSortItem")
require("UI._TagButtonItem.UI_TagButtonItem")
require("xlua.util")