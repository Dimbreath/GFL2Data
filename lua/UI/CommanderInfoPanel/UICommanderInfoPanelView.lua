require("UI.UIBaseView")

UICommanderInfoPanelView = class("UICommanderInfoPanelView", UIBaseView);
UICommanderInfoPanelView.__index = UICommanderInfoPanelView

--@@ GF Auto Gen Block Begin
UICommanderInfoPanelView.mBtn_CommanderName_Renaming = nil;
UICommanderInfoPanelView.mBtn_CommanderUID_Copy = nil;
UICommanderInfoPanelView.mBtn_CommanderBirthday_Change = nil;
UICommanderInfoPanelView.mBtn_CommanderAutograph_Change = nil;
UICommanderInfoPanelView.mBtn_Head = nil;
UICommanderInfoPanelView.mBtn_SettingsListItem1_Sel = nil;
UICommanderInfoPanelView.mBtn_SettingsListItem2_Sel = nil;
UICommanderInfoPanelView.mBtn_SettingsListItem3_Sel = nil;
UICommanderInfoPanelView.mBtn_Exit = nil;
UICommanderInfoPanelView.mBtn_Center = nil;
UICommanderInfoPanelView.mBtn_Service = nil;
UICommanderInfoPanelView.mBtn_InfoDisplayItem1_Sel = nil;
UICommanderInfoPanelView.mBtn_InfoDisplayItem2_Sel = nil;
UICommanderInfoPanelView.mBtn_Close = nil;
UICommanderInfoPanelView.mBtn_CommandCenter = nil;
UICommanderInfoPanelView.mImage_Head_Frame = nil;
UICommanderInfoPanelView.mImage_Head_Head = nil;
UICommanderInfoPanelView.mImage_Fill = nil;
UICommanderInfoPanelView.mImage_VolumeListItem1_Fill = nil;
UICommanderInfoPanelView.mImage_VolumeListItem2_Fill = nil;
UICommanderInfoPanelView.mImage_VolumeListItem3_Fill = nil;
UICommanderInfoPanelView.mText_CommanderName_PlayerName = nil;
UICommanderInfoPanelView.mText_CommanderUID_UID = nil;
UICommanderInfoPanelView.mText_CommanderBirthday_Birthday = nil;
UICommanderInfoPanelView.mText_CommanderAutograph_Autograph = nil;
UICommanderInfoPanelView.mText_PlayerLV = nil;
UICommanderInfoPanelView.mText_ExpNumTotal = nil;
UICommanderInfoPanelView.mText_ExpNumNow = nil;
UICommanderInfoPanelView.mText_CN = nil;
UICommanderInfoPanelView.mText_EN = nil;
UICommanderInfoPanelView.mText_VolumeListItem1_Num = nil;
UICommanderInfoPanelView.mText_VolumeListItem2_Num = nil;
UICommanderInfoPanelView.mText_VolumeListItem3_Num = nil;
UICommanderInfoPanelView.mSlider_Exp = nil;
UICommanderInfoPanelView.mSlider_VolumeListItem1_Line = nil;
UICommanderInfoPanelView.mSlider_VolumeListItem2_Line = nil;
UICommanderInfoPanelView.mSlider_VolumeListItem3_Line = nil;
UICommanderInfoPanelView.mTrans_PersonalDetails = nil;
UICommanderInfoPanelView.mTrans_Settings = nil;
UICommanderInfoPanelView.mTrans_SettingsListItem1_Normal = nil;
UICommanderInfoPanelView.mTrans_SettingsListItem1_Selected = nil;
UICommanderInfoPanelView.mTrans_SettingsListItem2_Normal = nil;
UICommanderInfoPanelView.mTrans_SettingsListItem2_Selected = nil;
UICommanderInfoPanelView.mTrans_SettingsListItem3_Normal = nil;
UICommanderInfoPanelView.mTrans_SettingsListItem3_Selected = nil;
UICommanderInfoPanelView.mTrans_ContentSound = nil;
UICommanderInfoPanelView.mTrans_PictureQuality = nil;
UICommanderInfoPanelView.mTrans_Account = nil;
UICommanderInfoPanelView.mTrans_InfoDisplayItem1_Normal = nil;
UICommanderInfoPanelView.mTrans_InfoDisplayItem1_Selected = nil;
UICommanderInfoPanelView.mTrans_InfoDisplayItem2_Normal = nil;
UICommanderInfoPanelView.mTrans_InfoDisplayItem2_Selected = nil;

function UICommanderInfoPanelView:__InitCtrl()

	self.mBtn_CommanderName_Renaming = self:GetButton("Root/Trans_PersonalDetails/CommanderDetail/UI_CommanderName/Text_PlayerName/Btn_Renaming");
	self.mBtn_CommanderUID_Copy = self:GetButton("Root/Trans_PersonalDetails/CommanderDetail/UI_CommanderUID/Text_UID/Btn_Copy");
	self.mBtn_CommanderUID_Copy2 = self:GetButton("Root/Trans_Settings/Trans_Account/UI_CommanderUIDAccount/Text_UID/Btn_Copy");
	self.mBtn_CommanderBirthday_Change = self:GetButton("Root/Trans_PersonalDetails/CommanderDetail/UI_CommanderBirthday/Text_Birthday/Btn_Change");
	self.mBtn_CommanderAutograph_Change = self:GetButton("Root/Trans_PersonalDetails/CommanderDetail/UI_CommanderAutograph/Btn_Change");
	self.mBtn_Head = self:GetButton("Root/Trans_PersonalDetails/CommanderDetail/CommanderHead/UI_Btn_Head");
	self.mBtn_SettingsListItem1_Sel = self:GetButton("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem1/Btn_Sel");
	self.mBtn_SettingsListItem2_Sel = self:GetButton("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem2/Btn_Sel");
	self.mBtn_SettingsListItem3_Sel = self:GetButton("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem3/Btn_Sel");
	self.mBtn_SettingsListItem4_Sel = self:GetButton("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem4/Btn_Sel");
	self.mBtn_Exit = self:GetButton("Root/Trans_Settings/Trans_Account/Btn_Exit");
	self.mBtn_Center = self:GetButton("Root/Trans_Settings/Trans_Account/Btn_Center");
	self.mBtn_Service = self:GetButton("Root/Trans_Settings/Trans_Account/Btn_Service");
	self.mBtn_InfoDisplayItem1_Sel = self:GetButton("InfoDisplayIlst/Viewport/Content/UI_InfoDisplayItem1/Btn_Sel");
	self.mBtn_InfoDisplayItem2_Sel = self:GetButton("InfoDisplayIlst/Viewport/Content/UI_InfoDisplayItem2/Btn_Sel");
	self.mBtn_InfoDisplayItem3_Sel = self:GetButton("InfoDisplayIlst/Viewport/Content/UI_InfoDisplayItem3/Btn_Sel");
	self.mBtn_Close = self:GetButton("UICommonBackItem/Btn_Close");
	self.mBtn_CommandCenter = self:GetButton("UICommonBackItem/Btn_CommandCenter");
	self.mImage_Head_Frame = self:GetImage("Root/Trans_PersonalDetails/CommanderDetail/CommanderHead/UI_Btn_Head/Image_Frame");
	self.mImage_Head_Head = self:GetImage("Root/Trans_PersonalDetails/CommanderDetail/CommanderHead/UI_Btn_Head/Image_Head");
	self.mImage_Fill = self:GetImage("Root/Trans_PersonalDetails/CommanderDetail/CommanderExp/Slider_Exp/Fill Area/Image_Fill");
	self.mImage_VolumeListItem1_Fill = self:GetImage("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem1/Volume/SliderLine/Slider_Line/Fill Area/Image_Fill");
	self.mImage_VolumeListItem2_Fill = self:GetImage("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem2/Volume/SliderLine/Slider_Line/Fill Area/Image_Fill");
	self.mImage_VolumeListItem3_Fill = self:GetImage("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem3/Volume/SliderLine/Slider_Line/Fill Area/Image_Fill");
	self.mText_CommanderName_PlayerName = self:GetText("Root/Trans_PersonalDetails/CommanderDetail/UI_CommanderName/Text_PlayerName");
	self.mText_CommanderUID_UID = self:GetText("Root/Trans_PersonalDetails/CommanderDetail/UI_CommanderUID/Text_UID");
	self.mText_CommanderUID_UID2 = self:GetText("Root/Trans_Settings/Trans_Account/UI_CommanderUIDAccount/Text_UID");
	self.mText_CommanderBirthday_Birthday = self:GetText("Root/Trans_PersonalDetails/CommanderDetail/UI_CommanderBirthday/Text_Birthday");
	self.mText_CommanderAutograph_Autograph = self:GetText("Root/Trans_PersonalDetails/CommanderDetail/UI_CommanderAutograph/Text_Autograph");
	self.mText_PlayerLV = self:GetText("Root/Trans_PersonalDetails/CommanderDetail/CommanderLv/Text_PlayerLV");
	self.mText_ExpNumTotal = self:GetText("Root/Trans_PersonalDetails/CommanderDetail/CommanderExp/Text_ExpNumTotal");
	self.mText_ExpNumNow = self:GetText("Root/Trans_PersonalDetails/CommanderDetail/CommanderExp/Text_ExpNumTotal/Text_ExpNumNow");
	self.mText_CN = self:GetText("Root/Trans_PersonalDetails/AdjutantDetail/TextName/Text_CN");
	self.mText_EN = self:GetText("Root/Trans_PersonalDetails/AdjutantDetail/TextName/Text_EN");
	self.mText_VolumeListItem1_Num = self:GetText("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem1/Volume/Text_Num");
	self.mText_VolumeListItem2_Num = self:GetText("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem2/Volume/Text_Num");
	self.mText_VolumeListItem3_Num = self:GetText("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem3/Volume/Text_Num");
	self.mSlider_Exp = self:GetSlider("Root/Trans_PersonalDetails/CommanderDetail/CommanderExp/Slider_Exp");
	self.mSlider_VolumeListItem1_Line = self:GetSlider("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem1/Volume/SliderLine/Slider_Line");
	self.mSlider_VolumeListItem2_Line = self:GetSlider("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem2/Volume/SliderLine/Slider_Line");
	self.mSlider_VolumeListItem3_Line = self:GetSlider("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem3/Volume/SliderLine/Slider_Line");
	self.mTrans_PersonalDetails = self:GetRectTransform("Root/Trans_PersonalDetails");
	self.mTrans_Settings = self:GetRectTransform("Root/Trans_Settings");
	self.mTrans_SettingsListItem1_Normal = self:GetRectTransform("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem1/Trans_Normal");
	self.mTrans_SettingsListItem1_Selected = self:GetRectTransform("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem1/Trans_Selected");
	self.mTrans_SettingsListItem2_Normal = self:GetRectTransform("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem2/Trans_Normal");
	self.mTrans_SettingsListItem2_Selected = self:GetRectTransform("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem2/Trans_Selected");
	self.mTrans_SettingsListItem3_Normal = self:GetRectTransform("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem3/Trans_Normal");
	self.mTrans_SettingsListItem3_Selected = self:GetRectTransform("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem3/Trans_Selected");
	self.mTrans_SettingsListItem4_Normal = self:GetRectTransform("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem4/Trans_Normal");
	self.mTrans_SettingsListItem4_Selected = self:GetRectTransform("Root/Trans_Settings/SettingList/Viewport/Content/UI_SettingsListItem4/Trans_Selected");
	self.mTrans_ContentSound = self:GetRectTransform("Root/Trans_Settings/Trans_ContentSound");
	self.mTrans_PictureQuality = self:GetRectTransform("Root/Trans_Settings/Trans_PictureQuality");
	self.mTrans_Account = self:GetRectTransform("Root/Trans_Settings/Trans_Account");
	self.mTrans_InfoDisplayItem1_Normal = self:GetRectTransform("InfoDisplayIlst/Viewport/Content/UI_InfoDisplayItem1/Trans_Normal");
	self.mTrans_InfoDisplayItem1_Selected = self:GetRectTransform("InfoDisplayIlst/Viewport/Content/UI_InfoDisplayItem1/Trans_Selected");
	self.mTrans_InfoDisplayItem2_Normal = self:GetRectTransform("InfoDisplayIlst/Viewport/Content/UI_InfoDisplayItem2/Trans_Normal");
	self.mTrans_InfoDisplayItem2_Selected = self:GetRectTransform("InfoDisplayIlst/Viewport/Content/UI_InfoDisplayItem2/Trans_Selected");
	self.mTrans_Other = self:GetRectTransform("Root/Trans_Settings/Trans_Other");


	self.mDropDownAllQuality = self:GetDropDown("Root/Trans_Settings/Trans_PictureQuality/Content/QualityListItemMain/Dropdown");
	self.mDropDownRender = self:GetDropDown("Root/Trans_Settings/Trans_PictureQuality/Content/QualityListItem1/Dropdown");
	self.mDropDownShodow = self:GetDropDown("Root/Trans_Settings/Trans_PictureQuality/Content/QualityListItem2/Dropdown");
	self.mDropPostProcess = self:GetDropDown("Root/Trans_Settings/Trans_PictureQuality/Content/QualityListItem3/Dropdown");
	self.mDropDownEffect = self:GetDropDown("Root/Trans_Settings/Trans_PictureQuality/Content/QualityListItem4/Dropdown");
	self.mDropDownFPS = self:GetDropDown("Root/Trans_Settings/Trans_PictureQuality/Content/QualityListItem5/Dropdown");
	self.mDropDownBloom = self:GetDropDown("Root/Trans_Settings/Trans_PictureQuality/Content/QualityListItem6/Dropdown");
	self.mDropDownAntiAliasing = self:GetDropDown("Root/Trans_Settings/Trans_PictureQuality/Content/QualityListItem7/Dropdown");
	self.mDropDownOutline = self:GetDropDown("Root/Trans_Settings/Trans_PictureQuality/Content/QualityListItem8/Dropdown");
	self.mToggle_Man = self:GetToggle("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem4/GrpGender/Btn_Man");
	self.mToggle_Women = self:GetToggle("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem4/GrpGender/Btn_Woman");
	self.mToggle_AvgNo = self:GetToggle("Root/Trans_Settings/Trans_Other/Content/UI_Confirmtem1/GrpAction/Btn_No");
	self.mToggle_AvgYes = self:GetToggle("Root/Trans_Settings/Trans_Other/Content/UI_Confirmtem1/GrpAction/Btn_Yes");


	self.mTrans_CharmInfo = self:GetRectTransform("Root/UICharmInfoPanel");
	self.mCharm_AvatarImage =  self:GetImage("Root/UICharmInfoPanel/Content/AvatarImage");
	self.mCharm_RaderChart = self:GetRectTransform("Root/UICharmInfoPanel/Content/RadarBase/RaderChart"):GetComponent("SquareRadar");
	self.mText_ChartText_0 = self:GetText("Root/UICharmInfoPanel/Content/RadarBase/Text_0");
	self.mText_ChartText_1 = self:GetText("Root/UICharmInfoPanel/Content/RadarBase/Text_1");
	self.mText_ChartText_2 = self:GetText("Root/UICharmInfoPanel/Content/RadarBase/Text_2");
	self.mText_ChartText_3 = self:GetText("Root/UICharmInfoPanel/Content/RadarBase/Text_3");

	self.mToggle_Chinese = self:GetToggle("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem5/GrpSound/Btn_CN");
	self.mToggle_Japan = self:GetToggle("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem5/GrpSound/Btn_JP");
	self.mToggle_English = self:GetToggle("Root/Trans_Settings/Trans_ContentSound/Content/UI_VolumeListItem5/GrpSound/Btn_EN");
	
	
end

--@@ GF Auto Gen Block End

function UICommanderInfoPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end