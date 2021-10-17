require("UI.UIBaseView")

UICombatPreparationPanelView = class("UICombatPreparationPanelView", UIBaseView);
UICombatPreparationPanelView.__index = UICombatPreparationPanelView

--@@ GF Auto Gen Block Begin
UICombatPreparationPanelView.mBtn_BattleStart = nil;
UICombatPreparationPanelView.mBtn_PlayerUnitInfo_InformationBtn = nil;
UICombatPreparationPanelView.mBtn_EnemyUnitInfo_InformationBtn = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_SwitchButton = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_Duty1 = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_Duty2 = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_Duty3 = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_Duty4 = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_Duty5 = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_Duty6 = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_RankR = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_RankSR = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_RankSSR = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_BackBtn = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_Vanguard = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_Spearhead = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_Annihilator = nil;
UICombatPreparationPanelView.mBtn_FilterPanel_Specialist = nil;
UICombatPreparationPanelView.mBtn_FakeButton = nil;
UICombatPreparationPanelView.mBtn_ViewControl_ButtonLeft = nil;
UICombatPreparationPanelView.mBtn_ViewControl_ButtonRight = nil;
UICombatPreparationPanelView.mBtn_DeployConfirm = nil;
UICombatPreparationPanelView.mImage_ScreenMaskbg = nil;
UICombatPreparationPanelView.mImage_ScreenMaskImage = nil;
UICombatPreparationPanelView.mImage_ScreenMask = nil;
UICombatPreparationPanelView.mImage_PlayerUnitInfo_GuntypeBGImage = nil;
UICombatPreparationPanelView.mImage_PlayerUnitInfo_typeBGImage = nil;
UICombatPreparationPanelView.mImage_PlayerUnitInfo_BloodImagebg_BloodProgressImage = nil;
UICombatPreparationPanelView.mImage_PlayerUnitInfo_BloodImagebg_BloodProgressSign = nil;
UICombatPreparationPanelView.mImage_PlayerUnitInfo_SkillInfo_SkillUnitInfoBG = nil;
UICombatPreparationPanelView.mImage_PlayerUnitInfo_SkillInfo_SkillInfluenceRange_SkillInfluenceRange = nil;
UICombatPreparationPanelView.mImage_PlayerUnitInfo_SkillInfo_ShootRangebg_ShootRangeIcon = nil;
UICombatPreparationPanelView.mImage_PlayerUnitInfo_SkillInfo_SkillCD_SkillCD = nil;
UICombatPreparationPanelView.mImage_EnemyUnitInfo_EnemytypeBGImage = nil;
UICombatPreparationPanelView.mImage_EnemyUnitInfo_typeBGImage = nil;
UICombatPreparationPanelView.mImage_EnemyUnitInfo_BloodImagebg_BloodProgressImage = nil;
UICombatPreparationPanelView.mImage_EnemyUnitInfo_BloodImagebg_BloodProgressSign = nil;
UICombatPreparationPanelView.mImage_EnemyUnitInfo_SkillInfo_SkillUnitInfoBG = nil;
UICombatPreparationPanelView.mImage_EnemyUnitInfo_SkillInfo_SkillInfluenceRange_SkillInfluenceRange = nil;
UICombatPreparationPanelView.mImage_EnemyUnitInfo_SkillInfo_ShootRangebg_ShootRangeIcon = nil;
UICombatPreparationPanelView.mImage_EnemyUnitInfo_SkillInfo_SkillCD_SkillCD = nil;
UICombatPreparationPanelView.mText_GunCount = nil;
UICombatPreparationPanelView.mText_GunNowCount = nil;
UICombatPreparationPanelView.mText_BattlePower = nil;
UICombatPreparationPanelView.mText_PlayerUnitInfo_LevelBGImage_Level = nil;
UICombatPreparationPanelView.mText_PlayerUnitInfo_NamebgImage_Name = nil;
UICombatPreparationPanelView.mText_PlayerUnitInfo_BloodImagebg_Blood = nil;
UICombatPreparationPanelView.mText_PlayerUnitInfo_SkillInfo_SkillType_SkillType = nil;
UICombatPreparationPanelView.mText_PlayerUnitInfo_SkillInfo_SkillName = nil;
UICombatPreparationPanelView.mText_PlayerUnitInfo_SkillInfo_SkillInformation = nil;
UICombatPreparationPanelView.mText_PlayerUnitInfo_SkillInfo_SkillInfluenceRange_SkillInfluenceRangeText = nil;
UICombatPreparationPanelView.mText_PlayerUnitInfo_SkillInfo_ShootRangebg_ShootRange = nil;
UICombatPreparationPanelView.mText_PlayerUnitInfo_SkillInfo_SkillCD_SkillCDText = nil;
UICombatPreparationPanelView.mText_EnemyUnitInfo_LevelBGImage_Level = nil;
UICombatPreparationPanelView.mText_EnemyUnitInfo_NamebgImage_Name = nil;
UICombatPreparationPanelView.mText_EnemyUnitInfo_BloodImagebg_Blood = nil;
UICombatPreparationPanelView.mText_EnemyUnitInfo_SkillInfo_SkillType_SkillType = nil;
UICombatPreparationPanelView.mText_EnemyUnitInfo_SkillInfo_SkillName = nil;
UICombatPreparationPanelView.mText_EnemyUnitInfo_SkillInfo_SkillInformation = nil;
UICombatPreparationPanelView.mText_EnemyUnitInfo_SkillInfo_SkillInfluenceRange_SkillInfluenceRangeText = nil;
UICombatPreparationPanelView.mText_EnemyUnitInfo_SkillInfo_ShootRangebg_ShootRange = nil;
UICombatPreparationPanelView.mText_EnemyUnitInfo_SkillInfo_SkillCD_SkillCDText = nil;
UICombatPreparationPanelView.mHLayout_PlayerUnitInfo_Skill_SkillList = nil;
UICombatPreparationPanelView.mHLayout_PlayerUnitInfo_Buff_BuffList = nil;
UICombatPreparationPanelView.mHLayout_EnemyUnitInfo_Skill_SkillList = nil;
UICombatPreparationPanelView.mHLayout_EnemyUnitInfo_Buff_BuffList = nil;
UICombatPreparationPanelView.mTrans_UnitMarks = nil;
UICombatPreparationPanelView.mTrans_GunListLayout = nil;
UICombatPreparationPanelView.mTrans_PreparationGunSlot_Text = nil;
UICombatPreparationPanelView.mTrans_PreparationGunSlot_PreparationListLayout = nil;
UICombatPreparationPanelView.mTrans_Lock = nil;
UICombatPreparationPanelView.mTrans_On = nil;
UICombatPreparationPanelView.mTrans_Image = nil;
UICombatPreparationPanelView.mTrans_ImageUnable = nil;
UICombatPreparationPanelView.mTrans_Preview = nil;
UICombatPreparationPanelView.mTrans_PlayerUnitInfo = nil;
UICombatPreparationPanelView.mTrans_PlayerUnitInfo_Skill = nil;
UICombatPreparationPanelView.mTrans_PlayerUnitInfo_SkillInfo = nil;
UICombatPreparationPanelView.mTrans_PlayerUnitInfo_SkillInfo_HighLyerSkillList = nil;
UICombatPreparationPanelView.mTrans_PlayerUnitInfo_Buff = nil;
UICombatPreparationPanelView.mTrans_EnemyUnitInfo = nil;
UICombatPreparationPanelView.mTrans_EnemyUnitInfo_Skill = nil;
UICombatPreparationPanelView.mTrans_EnemyUnitInfo_SkillInfo = nil;
UICombatPreparationPanelView.mTrans_EnemyUnitInfo_SkillInfo_HighLyerSkillList = nil;
UICombatPreparationPanelView.mTrans_EnemyUnitInfo_Buff = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_Filter = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_FullFilter = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_Duty1_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_Duty2_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_Duty3_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_Duty4_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_Duty5_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_Duty6_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_RankR_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_RankSR_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_RankSSR_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_Vanguard_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_Spearhead_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_Annihilator_Actived = nil;
UICombatPreparationPanelView.mTrans_FilterPanel_Specialist_Actived = nil;
UICombatPreparationPanelView.mTrans_TaskTitle_Task1_StageTaskList = nil;
UICombatPreparationPanelView.mTrans_TaskTitle_Task2_StageTaskList = nil;
UICombatPreparationPanelView.mTrans_TaskTitle_Task3_StageTaskList = nil;
UICombatPreparationPanelView.mTrans_ViewControl = nil;
UICombatPreparationPanelView.mTrans_RockerControl = nil;

UICombatPreparationPanelView.mText_TimeCountDown = nil;
UICombatPreparationPanelView.mTrans_TimeCountDown = nil;
UICombatPreparationPanelView.BattleScanBtn = nil;
UICombatPreparationPanelView.BattleScanBtnOn = nil;
UICombatPreparationPanelView.BattleScanBtnOff = nil;
UICombatPreparationPanelView.BattleScanInfoPlane = nil;

function UICombatPreparationPanelView:__InitCtrl()

	self.mBtn_BattleStart = self:GetButton("Btn_BattleStart");
	self.mBtn_PlayerUnitInfo_InformationBtn = self:GetImage("UI_Trans_PlayerUnitInfo/Btn_InformationBtn");
	self.mBtn_EnemyUnitInfo_InformationBtn = self:GetImage("UI_Trans_EnemyUnitInfo/Btn_InformationBtn");
	self.mBtn_FilterPanel_SwitchButton = self:GetButton("UI_FilterPanel/Trans_Filter/Btn_SwitchButton");
	self.mBtn_FilterPanel_Duty1 = self:GetButton("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty1");
	self.mBtn_FilterPanel_Duty2 = self:GetButton("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty2");
	self.mBtn_FilterPanel_Duty3 = self:GetButton("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty3");
	self.mBtn_FilterPanel_Duty4 = self:GetButton("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty4");
	self.mBtn_FilterPanel_Duty5 = self:GetButton("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty5");
	self.mBtn_FilterPanel_Duty6 = self:GetButton("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty6");
	self.mBtn_FilterPanel_RankR = self:GetButton("UI_FilterPanel/Trans_FullFilter/UI_Btn_RankR");
	self.mBtn_FilterPanel_RankSR = self:GetButton("UI_FilterPanel/Trans_FullFilter/UI_Btn_RankSR");
	self.mBtn_FilterPanel_RankSSR = self:GetButton("UI_FilterPanel/Trans_FullFilter/UI_Btn_RankSSR");
	self.mBtn_FilterPanel_BackBtn = self:GetButton("UI_FilterPanel/Trans_FullFilter/ImageBG/UI_Btn_BackBtn");
	self.mBtn_FilterPanel_Vanguard = self:GetButton("UI_FilterPanel/UI_Btn_Vanguard");
	self.mBtn_FilterPanel_Spearhead = self:GetButton("UI_FilterPanel/UI_Btn_Spearhead");
	self.mBtn_FilterPanel_Annihilator = self:GetButton("UI_FilterPanel/UI_Btn_Annihilator");
	self.mBtn_FilterPanel_Specialist = self:GetButton("UI_FilterPanel/UI_Btn_Specialist");
	self.mBtn_FakeButton = self:GetButton("Btn_FakeButton");
	self.mBtn_ViewControl_ButtonLeft = self:GetButton("UI_Trans_ViewControl/Btn_ButtonLeft");
	self.mBtn_ViewControl_ButtonRight = self:GetButton("UI_Trans_ViewControl/Btn_ButtonRight");

    self.mImage_RightBtnImageOFF = self:GetImage("UI_Trans_ViewControl/Btn_ButtonRight/RightBtnImageOFF");
    self.mImage_RightBtnImageON = self:GetImage("UI_Trans_ViewControl/Btn_ButtonRight/RightBtnImageON");
    self.mImage_RightBtnBGImage = self:GetImage("UI_Trans_ViewControl/Btn_ButtonRight/RightBtnBGImage");

    self.mImage_LeftBtnImageOFF = self:GetImage("UI_Trans_ViewControl/Btn_ButtonLeft/LeftBtnImageOFF");
    self.mImage_LeftBtnImageON = self:GetImage("UI_Trans_ViewControl/Btn_ButtonLeft/LeftBtnImageON");
    self.mImage_LeftBtnBGImage = self:GetImage("UI_Trans_ViewControl/Btn_ButtonLeft/LeftBtnBGImage");

	self.mBtn_DeployConfirm = self:GetButton("Btn_DeployConfirm");
	self.mImage_ScreenMaskbg = self:GetImage("Image_ScreenMaskbg");
	self.mImage_ScreenMaskImage = self:GetImage("Image_ScreenMaskImage");
	self.mImage_ScreenMask = self:GetImage("Image_ScreenMaskImage/Image_ScreenMask");
	self.mImage_PlayerUnitInfo_GuntypeBGImage = self:GetImage("UI_Trans_PlayerUnitInfo/UI_Image_GuntypeBGImage");
	self.mImage_PlayerUnitInfo_typeBGImage = self:GetImage("UI_Trans_PlayerUnitInfo/Image_typeBGImage");
	self.mImage_PlayerUnitInfo_BloodImagebg_BloodProgressImage = self:GetImage("UI_Trans_PlayerUnitInfo/UI_BloodImagebg/Image_BloodProgressImage");
	self.mImage_PlayerUnitInfo_BloodImagebg_BloodProgressSign = self:GetImage("UI_Trans_PlayerUnitInfo/UI_BloodImagebg/Image_BloodProgressSign");
	self.mImage_PlayerUnitInfo_SkillInfo_SkillUnitInfoBG = self:GetImage("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo/Image_SkillUnitInfoBG");
	self.mImage_PlayerUnitInfo_SkillInfo_SkillInfluenceRange_SkillInfluenceRange = self:GetImage("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo/UI_SkillInfluenceRange/Image_SkillInfluenceRange");
	self.mImage_PlayerUnitInfo_SkillInfo_ShootRangebg_ShootRangeIcon = self:GetImage("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo/UI_ShootRangebg/Image_ShootRangeIcon");
	self.mImage_PlayerUnitInfo_SkillInfo_SkillCD_SkillCD = self:GetImage("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo/UI_SkillCD/Image_SkillCD");
	self.mImage_EnemyUnitInfo_EnemytypeBGImage = self:GetImage("UI_Trans_EnemyUnitInfo/UI_Image_EnemytypeBGImage");
	self.mImage_EnemyUnitInfo_typeBGImage = self:GetImage("UI_Trans_EnemyUnitInfo/Image_typeBGImage");
	self.mImage_EnemyUnitInfo_BloodImagebg_BloodProgressImage = self:GetImage("UI_Trans_EnemyUnitInfo/UI_BloodImagebg/Image_BloodProgressImage");
	self.mImage_EnemyUnitInfo_BloodImagebg_BloodProgressSign = self:GetImage("UI_Trans_EnemyUnitInfo/UI_BloodImagebg/Image_BloodProgressSign");
	self.mImage_EnemyUnitInfo_SkillInfo_SkillUnitInfoBG = self:GetImage("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo/Image_SkillUnitInfoBG");
	self.mImage_EnemyUnitInfo_SkillInfo_SkillInfluenceRange_SkillInfluenceRange = self:GetImage("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo/UI_SkillInfluenceRange/Image_SkillInfluenceRange");
	self.mImage_EnemyUnitInfo_SkillInfo_ShootRangebg_ShootRangeIcon = self:GetImage("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo/UI_ShootRangebg/Image_ShootRangeIcon");
	self.mImage_EnemyUnitInfo_SkillInfo_SkillCD_SkillCD = self:GetImage("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo/UI_SkillCD/Image_SkillCD");
	self.mText_GunCount = self:GetText("GunCount/Text_GunCount");
	self.mText_GunNowCount = self:GetText("GunCount/Text_GunNowCount");
	self.mText_BattlePower = self:GetText("GunCount/BattlePower/Text_BattlePower");
	self.mText_PlayerUnitInfo_LevelBGImage_Level = self:GetText("UI_Trans_PlayerUnitInfo/UI_LevelBGImage/Text_Level");
	self.mText_PlayerUnitInfo_NamebgImage_Name = self:GetText("UI_Trans_PlayerUnitInfo/UI_NamebgImage/Text_Name");
	self.mText_PlayerUnitInfo_BloodImagebg_Blood = self:GetText("UI_Trans_PlayerUnitInfo/UI_BloodImagebg/Text_Blood");
	self.mText_PlayerUnitInfo_SkillInfo_SkillType_SkillType = self:GetText("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo/UI_SkillType/Text_SkillType");
	self.mText_PlayerUnitInfo_SkillInfo_SkillName = self:GetText("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo/Text_SkillName");
	self.mText_PlayerUnitInfo_SkillInfo_SkillInformation = self:GetText("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo/Text_SkillInformation");
	self.mText_PlayerUnitInfo_SkillInfo_SkillInfluenceRange_SkillInfluenceRangeText = self:GetText("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo/UI_SkillInfluenceRange/Text_SkillInfluenceRangeText");
	self.mText_PlayerUnitInfo_SkillInfo_ShootRangebg_ShootRange = self:GetText("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo/UI_ShootRangebg/Text_ShootRange");
	self.mText_PlayerUnitInfo_SkillInfo_SkillCD_SkillCDText = self:GetText("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo/UI_SkillCD/Text_SkillCDText");
	self.mText_EnemyUnitInfo_LevelBGImage_Level = self:GetText("UI_Trans_EnemyUnitInfo/UI_LevelBGImage/Text_Level");
	self.mText_EnemyUnitInfo_NamebgImage_Name = self:GetText("UI_Trans_EnemyUnitInfo/UI_NamebgImage/Text_Name");
	self.mText_EnemyUnitInfo_BloodImagebg_Blood = self:GetText("UI_Trans_EnemyUnitInfo/UI_BloodImagebg/Text_Blood");
	self.mText_EnemyUnitInfo_SkillInfo_SkillType_SkillType = self:GetText("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo/UI_SkillType/Text_SkillType");
	self.mText_EnemyUnitInfo_SkillInfo_SkillName = self:GetText("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo/Text_SkillName");
	self.mText_EnemyUnitInfo_SkillInfo_SkillInformation = self:GetText("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo/Text_SkillInformation");
	self.mText_EnemyUnitInfo_SkillInfo_SkillInfluenceRange_SkillInfluenceRangeText = self:GetText("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo/UI_SkillInfluenceRange/Text_SkillInfluenceRangeText");
	self.mText_EnemyUnitInfo_SkillInfo_ShootRangebg_ShootRange = self:GetText("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo/UI_ShootRangebg/Text_ShootRange");
	self.mText_EnemyUnitInfo_SkillInfo_SkillCD_SkillCDText = self:GetText("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo/UI_SkillCD/Text_SkillCDText");
	self.mHLayout_PlayerUnitInfo_Skill_SkillList = self:GetHorizontalLayoutGroup("UI_Trans_PlayerUnitInfo/UI_Trans_Skill/UI_HLayout_SkillList");
	self.mHLayout_PlayerUnitInfo_Buff_BuffList = self:GetHorizontalLayoutGroup("UI_Trans_PlayerUnitInfo/UI_Trans_Buff/UI_HLayout_BuffList");
	self.mHLayout_EnemyUnitInfo_Skill_SkillList = self:GetHorizontalLayoutGroup("UI_Trans_EnemyUnitInfo/UI_Trans_Skill/UI_HLayout_SkillList");
	self.mHLayout_EnemyUnitInfo_Buff_BuffList = self:GetHorizontalLayoutGroup("UI_Trans_EnemyUnitInfo/UI_Trans_Buff/UI_HLayout_BuffList");
	self.mTrans_UnitMarks = self:GetRectTransform("Trans_UnitMarks");
	self.mTrans_GunListLayout = self:GetRectTransform("GunSlot/GunSlotmask/Trans_GunListLayout");
	self.mTrans_PreparationGunSlot_Text = self:GetRectTransform("UI_PreparationGunSlot/ImageBG/Trans_Text");
	self.mTrans_PreparationGunSlot_PreparationListLayout = self:GetRectTransform("UI_PreparationGunSlot/Trans_PreparationListLayout");
	self.mTrans_Lock = self:GetRectTransform("UI_Trans_Other/Btn_RepeatSweep/Trans_Lock");
	self.mTrans_On = self:GetRectTransform("UI_Trans_Other/Btn_RepeatSweep/Trans_On");
	self.mTrans_Image = self:GetRectTransform("Btn_BattleStart/Trans_Image");
	self.mTrans_ImageUnable = self:GetRectTransform("Btn_BattleStart/Trans_ImageUnable");
	self.mTrans_Preview = self:GetRectTransform("Trans_Preview");
	self.mTrans_PlayerUnitInfo = self:GetRectTransform("UI_Trans_PlayerUnitInfo");
	self.mTrans_PlayerUnitInfo_Skill = self:GetRectTransform("UI_Trans_PlayerUnitInfo/UI_Trans_Skill");
	self.mTrans_PlayerUnitInfo_SkillInfo = self:GetRectTransform("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo");
	self.mTrans_PlayerUnitInfo_SkillInfo_HighLyerSkillList = self:GetRectTransform("UI_Trans_PlayerUnitInfo/UI_Trans_SkillInfo/UI_Trans_HighLyerSkillList");
	self.mTrans_PlayerUnitInfo_Buff = self:GetRectTransform("UI_Trans_PlayerUnitInfo/UI_Trans_Buff");
	self.mTrans_EnemyUnitInfo = self:GetRectTransform("UI_Trans_EnemyUnitInfo");
	self.mTrans_EnemyUnitInfo_Skill = self:GetRectTransform("UI_Trans_EnemyUnitInfo/UI_Trans_Skill");
	self.mTrans_EnemyUnitInfo_SkillInfo = self:GetRectTransform("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo");
	self.mTrans_EnemyUnitInfo_SkillInfo_HighLyerSkillList = self:GetRectTransform("UI_Trans_EnemyUnitInfo/UI_Trans_SkillInfo/UI_Trans_HighLyerSkillList");
	self.mTrans_EnemyUnitInfo_Buff = self:GetRectTransform("UI_Trans_EnemyUnitInfo/UI_Trans_Buff");
	self.mTrans_FilterPanel_Filter = self:GetRectTransform("UI_FilterPanel/Trans_Filter");
	self.mTrans_FilterPanel_FullFilter = self:GetRectTransform("UI_FilterPanel/Trans_FullFilter");
	self.mTrans_FilterPanel_Duty1_Actived = self:GetRectTransform("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty1/Trans_Actived");
	self.mTrans_FilterPanel_Duty2_Actived = self:GetRectTransform("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty2/Trans_Actived");
	self.mTrans_FilterPanel_Duty3_Actived = self:GetRectTransform("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty3/Trans_Actived");
	self.mTrans_FilterPanel_Duty4_Actived = self:GetRectTransform("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty4/Trans_Actived");
	self.mTrans_FilterPanel_Duty5_Actived = self:GetRectTransform("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty5/Trans_Actived");
	self.mTrans_FilterPanel_Duty6_Actived = self:GetRectTransform("UI_FilterPanel/Trans_FullFilter/UI_Btn_Duty6/Trans_Actived");
	self.mTrans_FilterPanel_RankR_Actived = self:GetRectTransform("UI_FilterPanel/Trans_FullFilter/UI_Btn_RankR/Trans_Actived");
	self.mTrans_FilterPanel_RankSR_Actived = self:GetRectTransform("UI_FilterPanel/Trans_FullFilter/UI_Btn_RankSR/Trans_Actived");
	self.mTrans_FilterPanel_RankSSR_Actived = self:GetRectTransform("UI_FilterPanel/Trans_FullFilter/UI_Btn_RankSSR/Trans_Actived");
	self.mTrans_FilterPanel_Vanguard_Actived = self:GetRectTransform("UI_FilterPanel/UI_Btn_Vanguard/Trans_Actived");
	self.mTrans_FilterPanel_Spearhead_Actived = self:GetRectTransform("UI_FilterPanel/UI_Btn_Spearhead/Trans_Actived");
	self.mTrans_FilterPanel_Annihilator_Actived = self:GetRectTransform("UI_FilterPanel/UI_Btn_Annihilator/Trans_Actived");
	self.mTrans_FilterPanel_Specialist_Actived = self:GetRectTransform("UI_FilterPanel/UI_Btn_Specialist/Trans_Actived");
	self.mTrans_TaskTitle_StageTaskList = self:GetRectTransform("UI_TaskTitle/TaskLayout");
	self.mTrans_TaskTitle = self:GetRectTransform("UI_TaskTitle");
	self.mTrans_ViewControl = self:GetRectTransform("UI_Trans_ViewControl");
    self.mTrans_RockerControl = self:GetRectTransform("UI_Trans_RockerControl");
	self.mTrans_NoGunBG = self:GetRectTransform("GunSlot/GunSlotmask/NoGunBG");
	self.mTrans_HpBarRoot = self:GetRectTransform("UI_HpBarRoot");
	self.mTrans_GunSlot = self:GetRectTransform("GunSlot");
	self.mText_AssistantCost  = self:GetText("UI_Trans_Other/Btn_FriendHelp/CoinBGImage/Text_AssistantCost");
	self.mTrans_AssistantCost = self:GetRectTransform("UI_Trans_Other/Btn_FriendHelp/CoinBGImage");
	--[[self.mTrans_BtnBGImage = self:GetRectTransform("BtnBGImage");--]]
	self.mImage_PlayerUnitInfo_Avatar = self:GetImage("UI_Trans_PlayerUnitInfo/UI_Portrait/Image_GunPortrait");
	self.mImage_EnemyUnitInfo_Avatar = self:GetImage("UI_Trans_EnemyUnitInfo/UI_Portrait/Image_GunPortrait");
	self.mText_TimeCountDown = self:GetText("UI_Trans_TimeCountDown/Text_Time");
	self.mTrans_TimeCountDown = self:GetRectTransform("UI_Trans_TimeCountDown");
    self.mTrans_FriendHelp_UnSelect = self:GetRectTransform("UI_Trans_Other/Btn_FriendHelp/UnSelect");
    self.mTrans_RepeatSweep_UnSelect = self:GetRectTransform("UI_Trans_Other/Btn_RepeatSweep/UnSelect");

	self.mScrollCircle = self:GetScrollCircle("UI_Trans_RockerControl/ViewControl/ViewControlBGImage");
	self.BattleScanBtn = self:GetButton("UI_BattleScan/Btn_BattleScan");
	self.BattleScanBtnOn = self:GetImage("UI_BattleScan/Btn_BattleScan/BGImage/SignON");
	self.BattleScanBtnOff = self:GetImage("UI_BattleScan/Btn_BattleScan/BGImage/SignOFF");;
	self.BattleScanInfoPlane = self:GetRectTransform("UI_BattleScan/Inf");

end

--@@ GF Auto Gen Block End

UICombatPreparationPanelView.mToggle_RepeatSweep = nil;
UICombatPreparationPanelView.mToggle_FriendHelp = nil;

function UICombatPreparationPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mToggle_RepeatSweep = self:GetToggle("UI_Trans_Other/Btn_RepeatSweep");
	self.mToggle_FriendHelp = self:GetToggle("UI_Trans_Other/Btn_FriendHelp");

	self.UI_Trans_Other = self:GetRectTransform("UI_Trans_Other");
	--测试分支关闭
	--setactive(self.UI_Trans_Other.gameObject,false);
end