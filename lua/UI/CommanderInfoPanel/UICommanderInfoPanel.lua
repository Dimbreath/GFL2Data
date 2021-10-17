require("UI.UIBasePanel")


UICommanderInfoPanel = class("UICommanderInfoPanel", UIBasePanel)
UICommanderInfoPanel.__index = UICommanderInfoPanel

UICommanderInfoPanel.mView = nil
UICommanderInfoPanel.mData = nil



function UICommanderInfoPanel:ctor()
	UICommanderInfoPanel.super.ctor(self)
end

function UICommanderInfoPanel.Open()
	UIManager.OpenUI(UIDef.UICommanderInfoPanel)
end

function UICommanderInfoPanel.Close() 
	UIManager.CloseUI(UIDef.UICommanderInfoPanel)
end

function UICommanderInfoPanel.Init(root,data)
	self = UICommanderInfoPanel
	UICommanderInfoPanel.super.SetRoot(UICommanderInfoPanel, root)
	--self.mIsPop = true
	self.mData = data

end

function UICommanderInfoPanel.OnInit()
	self = UICommanderInfoPanel

	self.mView = UICommanderInfoPanelView.New()
	self.mView:InitCtrl(self.mUIRoot)

	UIUtils.GetListener(self.mView.mBtn_Close.gameObject).onClick = function()
		UICommanderInfoPanel:OnClose();
	end

	UIUtils.GetListener(self.mView.mBtn_CommandCenter.gameObject).onClick = function()
		CS.BattlePerformSetting.RefreshGraphicSetting();
		UIManager.JumpToMainPanel();
	end

	UIUtils.GetListener(self.mView.mBtn_CommanderUID_Copy.gameObject).onClick = function()
		UICommanderInfoPanel:OnClickCopyUid();
	end

	UIUtils.GetListener(self.mView.mBtn_CommanderUID_Copy2.gameObject).onClick = function()
		UICommanderInfoPanel:OnClickCopyUid();
	end

	UIUtils.GetListener(self.mView.mBtn_CommanderAutograph_Change.gameObject).onClick = function()
		UICommanderInfoPanel:OnClickChangeSign();
	end

	UIUtils.GetListener(self.mView.mBtn_InfoDisplayItem1_Sel.gameObject).onClick = function()
		UICommanderInfoPanel:RefreshCommanderInfo();
	end

	UIUtils.GetListener(self.mView.mBtn_InfoDisplayItem2_Sel.gameObject).onClick = function()
		UICommanderInfoPanel:RefreshSetting();
	end

	UIUtils.GetListener(self.mView.mBtn_InfoDisplayItem3_Sel.gameObject).onClick = function()
		UICommanderInfoPanel:RefreshCharmInfo();
	end

	UIUtils.GetListener(self.mView.mBtn_SettingsListItem1_Sel.gameObject).onClick = function()
		UICommanderInfoPanel:OnClickSetSound();
	end

	UIUtils.GetListener(self.mView.mBtn_SettingsListItem2_Sel.gameObject).onClick = function()
		UICommanderInfoPanel:OnClickSetGraphic();
	end

	UIUtils.GetListener(self.mView.mBtn_SettingsListItem3_Sel.gameObject).onClick = function()
		UICommanderInfoPanel:OnClickSetAccout();
	end

	UIUtils.GetListener(self.mView.mBtn_SettingsListItem4_Sel.gameObject).onClick = function()
		UICommanderInfoPanel:OnClickSetOther();
	end

	UIUtils.GetListener(self.mView.mBtn_Exit.gameObject).onClick = function()
		UICommanderInfoPanel:OnClickLogOut();
	end


	UIUtils.GetListener(self.mView.mBtn_Center.gameObject).onClick = function()
		UICommanderInfoPanel:OnClickUserCenter();
	end
	
	UIUtils.GetListener(self.mView.mBtn_Service.gameObject).onClick = function()
		UICommanderInfoPanel:OnClickCustomerCenter();
	end

	self.mView.mToggle_Man.onValueChanged:AddListener(function (isOn) UICommanderInfoPanel:OnToggleMan(isOn) end);
	self.mView.mToggle_Women.onValueChanged:AddListener(function (isOn) UICommanderInfoPanel:OnToggleWoman(isOn) end);

	self.mView.mToggle_AvgNo.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnToggleAvgNo(value) end);
	self.mView.mToggle_AvgYes.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnToggleAvgYes(value) end);

	self.mView.mToggle_Chinese.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnToggleChinese(value) end);
	self.mView.mToggle_Japan.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnToggleJapan(value) end);
	self.mView.mToggle_English.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnToggleEnglish(value) end);
	
	self.mView.mSlider_VolumeListItem1_Line.onValueChanged:AddListener(function (ptc) UICommanderInfoPanel:OnValueChangeBgMusic(ptc) end);
	self.mView.mSlider_VolumeListItem2_Line.onValueChanged:AddListener(function (ptc) UICommanderInfoPanel:OnValueChangeSound(ptc) end);
	self.mView.mSlider_VolumeListItem3_Line.onValueChanged:AddListener(function (ptc) UICommanderInfoPanel:OnValueChangeVoice(ptc) end);

	self.mView.mDropDownAllQuality:ClearOptions()
	self.mView.mDropDownAllQuality.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("自定义"));
	self.mView.mDropDownAllQuality.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("省电"));
	self.mView.mDropDownAllQuality.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("流畅"));
	self.mView.mDropDownAllQuality.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("高"));
	self.mView.mDropDownAllQuality.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("非常高"));
	
	
	self.mView.mDropDownRender:ClearOptions()
	self.mView.mDropDownRender.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("省电"));
	self.mView.mDropDownRender.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("流畅"));
	self.mView.mDropDownRender.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("精致"));
	self.mView.mDropDownRender.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("高清"));
	self.mView.mDropDownRender.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("极致"));



	self.mView.mDropPostProcess:ClearOptions()
	self.mView.mDropPostProcess.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("关"));
	self.mView.mDropPostProcess.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("低"));
	self.mView.mDropPostProcess.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("中"));
	self.mView.mDropPostProcess.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("高"));
	
	
	self.mView.mDropDownFPS:ClearOptions()
	self.mView.mDropDownFPS.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("30"));
	self.mView.mDropDownFPS.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("60"));

	self.mView.mDropDownBloom:ClearOptions()
	self.mView.mDropDownBloom.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("关"));
	self.mView.mDropDownBloom.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("开"));

	

	self.mView.mDropDownAntiAliasing:ClearOptions()
	self.mView.mDropDownAntiAliasing.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("关"));
	self.mView.mDropDownAntiAliasing.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("低"));
	self.mView.mDropDownAntiAliasing.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("中"));
	self.mView.mDropDownAntiAliasing.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("高"));
	


	self.mView.mDropDownOutline:ClearOptions()
	self.mView.mDropDownOutline.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("关"));
	self.mView.mDropDownOutline.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("低"));
	self.mView.mDropDownOutline.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("中"));
	self.mView.mDropDownOutline.options:Add(CS.UnityEngine.UI.Dropdown.OptionData("高"));
	


	MessageSys:AddListener(CS.GF2.Message.UIEvent.RefreshSgin, function()
			UICommanderInfoPanel:RefreshPanel()
		end)

	self:RefreshCommanderInfo()


	self:UpdatePanel()
end

function UICommanderInfoPanel.OnShow()
	self = UICommanderInfoPanel

	self.mView.mDropDownAllQuality.value = CS.BattlePerformSetting.AllQualityVale+1  --默认多一个自定义
	self.mView.mDropDownRender.value = CS.BattlePerformSetting.RenderQualityVale
	self.mView.mDropDownShodow.value = CS.BattlePerformSetting.ShadowValue
	self.mView.mDropPostProcess.value = CS.BattlePerformSetting.PostprocessingValue
	self.mView.mDropDownEffect.value = CS.BattlePerformSetting.EffectValue
	self.mView.mDropDownFPS.value = CS.BattlePerformSetting.FPSValue
	self.mView.mDropDownBloom.value = CS.BattlePerformSetting.BloomValue
	self.mView.mDropDownAntiAliasing.value = CS.BattlePerformSetting.AntiAliasingValue
	self.mView.mDropDownOutline.value = CS.BattlePerformSetting.OutlineValue
	
	self.mView.mDropDownAllQuality.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnDropDownAllQualityValueChange(value) end);
	self.mView.mDropDownRender.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnDropDownRenderValueChange(value) end);
	self.mView.mDropDownShodow.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnDropDownShodowValueChange(value) end);
	self.mView.mDropPostProcess.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnDropPostProcessValueChange(value) end);
	self.mView.mDropDownEffect.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnDropDownEffectValueChange(value) end);
	self.mView.mDropDownFPS.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnDropDownFPSValueChange(value) end);
	self.mView.mDropDownBloom.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnDropDownBloomValueChange(value) end);
	self.mView.mDropDownAntiAliasing.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnDropAntiAliasingValueChange(value) end);
	self.mView.mDropDownOutline.onValueChanged:AddListener(function (value) UICommanderInfoPanel:OnDropDownOutlineValueChange(value) end);
	
end

function UICommanderInfoPanel.OnRelease()
	self = UICommanderInfoPanel
	MessageSys:RemoveListener(CS.GF2.Message.UIEvent.RefreshSgin, function()
			UICommanderInfoPanel:RefreshPanel()
		end)


	UICommanderInfoPanel.mData = nil

end

function UICommanderInfoPanel:UpdatePanel()


end


function UICommanderInfoPanel:OnClose()
	CS.BattlePerformSetting.RefreshGraphicSetting();
	
	self.mView.mDropDownAllQuality.onValueChanged:RemoveListener(function (value) UICommanderInfoPanel:OnDropDownAllQualityValueChange(value) end);
	self.mView.mDropDownRender.onValueChanged:RemoveListener(function (value) UICommanderInfoPanel:OnDropDownRenderValueChange(value) end);
	self.mView.mDropDownShodow.onValueChanged:RemoveListener(function (value) UICommanderInfoPanel:OnDropDownShodowValueChange(value) end);
	self.mView.mDropPostProcess.onValueChanged:RemoveListener(function (value) UICommanderInfoPanel:OnDropPostProcessValueChange(value) end);
	self.mView.mDropDownEffect.onValueChanged:RemoveListener(function (value) UICommanderInfoPanel:OnDropDownEffectValueChange(value) end);
	self.mView.mDropDownFPS.onValueChanged:RemoveListener(function (value) UICommanderInfoPanel:OnDropDownFPSValueChange(value) end);
	self.mView.mDropDownBloom.onValueChanged:RemoveListener(function (value) UICommanderInfoPanel:OnDropDownBloomValueChange(value) end);
	self.mView.mDropDownAntiAliasing.onValueChanged:RemoveListener(function (value) UICommanderInfoPanel:OnDropAntiAliasingValueChange(value) end);
	self.mView.mDropDownOutline.onValueChanged:RemoveListener(function (value) UICommanderInfoPanel:OnDropDownOutlineValueChange(value) end);
	self:Close();
end

function UICommanderInfoPanel:RefreshPanel()
	self:RefreshCommanderInfo();
end

function UICommanderInfoPanel:RefreshCommanderInfo()

	setactive(self.mView.mTrans_PersonalDetails.gameObject,true)
	setactive(self.mView.mTrans_Settings.gameObject,false)
	setactive(self.mView.mTrans_CharmInfo.gameObject,false)
	setactive(self.mView.mTrans_InfoDisplayItem1_Normal.gameObject,false)
	setactive(self.mView.mTrans_InfoDisplayItem1_Selected.gameObject,true)

	setactive(self.mView.mTrans_InfoDisplayItem2_Normal.gameObject,true)
	setactive(self.mView.mTrans_InfoDisplayItem2_Selected.gameObject,false)

	self.mView.mText_CommanderName_PlayerName.text = AccountNetCmdHandler:GetName()
	self.mView.mText_PlayerLV.text =  AccountNetCmdHandler:GetLevel()
	self.mView.mText_CommanderUID_UID.text =  AccountNetCmdHandler:GetUID()
	self.mView.mText_CommanderUID_UID2.text =  AccountNetCmdHandler:GetUID()
	self.mView.mSlider_Exp.value = AccountNetCmdHandler:GetExpPct()
	self.mView.mText_ExpNumNow.text =  AccountNetCmdHandler:GetExpStr()

	local roleInfo = AccountNetCmdHandler:GetRoleInfoData();
	if roleInfo~=nil then
		self.mView.mText_CommanderAutograph_Autograph.text =roleInfo.PlayerMotto
		self.mView.mImage_Head_Head.sprite = UIUtils.GetIconSprite("Icon/PlayerAvatar", roleInfo.Icon)
	end


	--self.mView.mText_CN.text =  NetCmdIllustrationData.CurAdjutant.name

end

function UICommanderInfoPanel:RefreshSetting()
	setactive(self.mView.mTrans_PersonalDetails.gameObject,false)
	setactive(self.mView.mTrans_Settings.gameObject,true)
	setactive(self.mView.mTrans_CharmInfo.gameObject,false)

	setactive(self.mView.mTrans_InfoDisplayItem1_Normal.gameObject,true)
	setactive(self.mView.mTrans_InfoDisplayItem1_Selected.gameObject,false)

	setactive(self.mView.mTrans_InfoDisplayItem2_Normal.gameObject,false)
	setactive(self.mView.mTrans_InfoDisplayItem2_Selected.gameObject,true)

	setactive(self.mView.mTrans_SettingsListItem4_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem4_Normal.gameObject,true)
	
	self:OnClickSetSound();

	if AccountNetCmdHandler.Gender == 0 then
		self.mView.mToggle_Man.isOn = true;
		self.mView.mToggle_Women.isOn = false;
	else
		self.mView.mToggle_Women.isOn = true;
		self.mView.mToggle_Man.isOn = false;
	end

	if AccountNetCmdHandler.AvgRepetion == 0 then
		self.mView.mToggle_AvgNo.isOn = true;
		self:OnToggleAvgNo(true)
	else
		self.mView.mToggle_AvgYes.isOn = true;
		self:OnToggleAvgYes(true)
	end

	if AccountNetCmdHandler.AvgVoice == 0 then
		self.mView.mToggle_Chinese.isOn = true;
		self:OnToggleChinese(true)
	elseif AccountNetCmdHandler.AvgVoice == 1 then 
		self.mView.mToggle_Japan.isOn = true;
		self:OnToggleJapan(true)
	else
		self.mView.mToggle_English.isOn = true;
		self:OnToggleEnglish(true)	
	end
	
end


function UICommanderInfoPanel:RefreshCharmInfo()
	setactive(self.mView.mTrans_PersonalDetails.gameObject,false)
	setactive(self.mView.mTrans_Settings.gameObject,false)
	setactive(self.mView.mTrans_CharmInfo.gameObject,true)

	self.mView.mText_ChartText_0.text = TableData.listCharmDefinitionDatas[0].name.str;
	self.mView.mText_ChartText_1.text = TableData.listCharmDefinitionDatas[1].name.str;
	self.mView.mText_ChartText_2.text = TableData.listCharmDefinitionDatas[2].name.str;
	self.mView.mText_ChartText_3.text = TableData.listCharmDefinitionDatas[3].name.str;

	math.randomseed(os.time())

	local charms = NetCmdDormDataV2.CommanderCharm;
	self.mView.mCharm_RaderChart:SetValues({charms[0],charms[1],charms[2],charms[3]})
	
end



function UICommanderInfoPanel:OnClickCopyUid()
	CS.UnityEngine.GUIUtility.systemCopyBuffer = self.mView.mText_CommanderUID_UID.text
	UIGuildGlobal:PopupHintMessage(7002)
end

function UICommanderInfoPanel:OnClickChangeSign()
	UIManager.OpenUI(UIDef.UIChangeAutographPanel);
end


function UICommanderInfoPanel:OnClickSetSound()
	print("   OnClickSetSound   ")
	setactive(self.mView.mTrans_SettingsListItem1_Selected.gameObject,true)
	setactive(self.mView.mTrans_SettingsListItem1_Normal.gameObject,false)

	setactive(self.mView.mTrans_SettingsListItem2_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem2_Normal.gameObject,true)

	setactive(self.mView.mTrans_SettingsListItem3_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem3_Normal.gameObject,true)


	setactive(self.mView.mTrans_SettingsListItem4_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem4_Normal.gameObject,true)
	
	setactive(self.mView.mTrans_ContentSound.gameObject,true)
	setactive(self.mView.mTrans_PictureQuality.gameObject,false)
	setactive(self.mView.mTrans_Account.gameObject,false)
	setactive(self.mView.mTrans_Other.gameObject,false)


	self.mView.mSlider_VolumeListItem1_Line.value = CS.BattlePerformSetting.BGMVolumeValue
	self.mView.mSlider_VolumeListItem2_Line.value = CS.BattlePerformSetting.VolumeValue
	self.mView.mSlider_VolumeListItem3_Line.value = CS.BattlePerformSetting.VoiceValue

	self.mView.mText_VolumeListItem1_Num.text = FormatNum(math.floor(CS.BattlePerformSetting.BGMVolumeValue * 100));
	self.mView.mText_VolumeListItem2_Num.text = FormatNum(math.floor(CS.BattlePerformSetting.VolumeValue * 100));
	self.mView.mText_VolumeListItem3_Num.text = FormatNum(math.floor(CS.BattlePerformSetting.VoiceValue * 100));


end

function UICommanderInfoPanel:OnClickSetGraphic()

	print("   OnClickSetGraphic   ")
	setactive(self.mView.mTrans_SettingsListItem1_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem1_Normal.gameObject,true)

	setactive(self.mView.mTrans_SettingsListItem2_Selected.gameObject,true)
	setactive(self.mView.mTrans_SettingsListItem2_Normal.gameObject,false)

	setactive(self.mView.mTrans_SettingsListItem3_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem3_Normal.gameObject,true)

	setactive(self.mView.mTrans_SettingsListItem4_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem4_Normal.gameObject,true)

	setactive(self.mView.mTrans_ContentSound.gameObject,false)
	setactive(self.mView.mTrans_PictureQuality.gameObject,true)
	setactive(self.mView.mTrans_Account.gameObject,false)
	setactive(self.mView.mTrans_Other.gameObject,false)

	

end

function UICommanderInfoPanel:OnClickSetAccout()
	print("   OnClickSetAccout   ")

	setactive(self.mView.mTrans_SettingsListItem1_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem1_Normal.gameObject,true)

	setactive(self.mView.mTrans_SettingsListItem2_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem2_Normal.gameObject,true)

	setactive(self.mView.mTrans_SettingsListItem3_Selected.gameObject,true)
	setactive(self.mView.mTrans_SettingsListItem3_Normal.gameObject,false)

	setactive(self.mView.mTrans_SettingsListItem4_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem4_Normal.gameObject,true)
	
	setactive(self.mView.mTrans_ContentSound.gameObject,false)
	setactive(self.mView.mTrans_PictureQuality.gameObject,false)
	setactive(self.mView.mTrans_Account.gameObject,true)
	setactive(self.mView.mTrans_Other.gameObject,false)
end


function UICommanderInfoPanel:OnClickSetOther()

	setactive(self.mView.mTrans_SettingsListItem1_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem1_Normal.gameObject,true)

	setactive(self.mView.mTrans_SettingsListItem2_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem2_Normal.gameObject,true)

	setactive(self.mView.mTrans_SettingsListItem3_Selected.gameObject,false)
	setactive(self.mView.mTrans_SettingsListItem3_Normal.gameObject,true)

	setactive(self.mView.mTrans_SettingsListItem4_Selected.gameObject,true)
	setactive(self.mView.mTrans_SettingsListItem4_Normal.gameObject,false)

	setactive(self.mView.mTrans_ContentSound.gameObject,false)
	setactive(self.mView.mTrans_PictureQuality.gameObject,false)
	setactive(self.mView.mTrans_Account.gameObject,false)
	setactive(self.mView.mTrans_Other.gameObject,true)
end


function UICommanderInfoPanel:OnValueChangeBgMusic(value)

	--CS.CriWareAudioController.SetBGMSoundVolume(value)

	CS.BattlePerformSetting.BGMVolumeValue = value;
	self.mView.mText_VolumeListItem1_Num.text = FormatNum(math.floor(value * 100));
end

function UICommanderInfoPanel:OnValueChangeSound(value)
	--CS.CriWareAudioController.SetSoundVolume(value)
	CS.BattlePerformSetting.VolumeValue = value;
	self.mView.mText_VolumeListItem2_Num.text = FormatNum(math.floor(value * 100));
end

function UICommanderInfoPanel:OnValueChangeVoice(value)
	--CS.CriWareAudioController.SetVoiceSoundVolueme(value)
	CS.BattlePerformSetting.VoiceValue = value;
	self.mView.mText_VolumeListItem3_Num.text = FormatNum(math.floor(value * 100));
end

function UICommanderInfoPanel:OnDropDownAllQualityValueChange(value)
	if value == 0 then
		return ;
	end
	value = value - 1
	
	CS.BattlePerformSetting.SetAllQualityValue(value); -- 设置全部变量

	self.mView.mDropDownRender.value = CS.BattlePerformSetting.RenderQualityVale
	self.mView.mDropDownShodow.value = CS.BattlePerformSetting.ShadowValue
	self.mView.mDropPostProcess.value = CS.BattlePerformSetting.PostprocessingValue
	self.mView.mDropDownEffect.value = CS.BattlePerformSetting.EffectValue
	--self.mView.mDropDownFPS.value = CS.BattlePerformSetting.FPSValue
	self.mView.mDropDownBloom.value = CS.BattlePerformSetting.BloomValue
	self.mView.mDropDownAntiAliasing.value = CS.BattlePerformSetting.AntiAliasingValue
	self.mView.mDropDownOutline.value = CS.BattlePerformSetting.OutlineValue

	CS.BattlePerformSetting.AllQualityVale = value;
	self.mView.mDropDownAllQuality.value = CS.BattlePerformSetting.AllQualityVale + 1
end


function UICommanderInfoPanel:OnDropDownRenderValueChange(value)
	CS.BattlePerformSetting.RenderQualityVale = value;

	self.mView.mDropDownAllQuality.value = 0;
	CS.BattlePerformSetting.AllQualityVale = -1;
end


function UICommanderInfoPanel:OnDropDownShodowValueChange(value)
	CS.BattlePerformSetting.ShadowValue = value;
	self.mView.mDropDownAllQuality.value = 0;
	CS.BattlePerformSetting.AllQualityVale = -1;
end

function UICommanderInfoPanel:OnDropPostProcessValueChange(value)
	CS.BattlePerformSetting.PostprocessingValue = value;
	self.mView.mDropDownAllQuality.value = 0;
	CS.BattlePerformSetting.AllQualityVale = -1;
end

function UICommanderInfoPanel:OnDropDownEffectValueChange(value)
	CS.BattlePerformSetting.EffectValue = value;
	self.mView.mDropDownAllQuality.value = 0;
	CS.BattlePerformSetting.AllQualityVale = -1;
end


function UICommanderInfoPanel:OnDropDownFPSValueChange(value)
	CS.BattlePerformSetting.FPSValue = value;
	self.mView.mDropDownAllQuality.value = 0;
	CS.BattlePerformSetting.AllQualityVale = -1;
end


function UICommanderInfoPanel:OnDropDownBloomValueChange(value)
	CS.BattlePerformSetting.BloomValue = value;
	self.mView.mDropDownAllQuality.value = 0;
	CS.BattlePerformSetting.AllQualityVale = -1;
end

function UICommanderInfoPanel:OnDropAntiAliasingValueChange(value)
	CS.BattlePerformSetting.AntiAliasingValue = value;
	self.mView.mDropDownAllQuality.value = 0;
	CS.BattlePerformSetting.AllQualityVale = -1;
end

function UICommanderInfoPanel:OnDropDownOutlineValueChange(value)
	CS.BattlePerformSetting.OutlineValue = value;
	self.mView.mDropDownAllQuality.value = 0;
	CS.BattlePerformSetting.AllQualityVale = -1;
end

function UICommanderInfoPanel:OnClickLogOut()
	self:Close();
	AccountNetCmdHandler:Logout()
end


function UICommanderInfoPanel:OnClickUserCenter()
	CS.GF2.SDK.PlatformLoginManager.Instance:UserCenter()
end

function UICommanderInfoPanel:OnClickCustomerCenter()
	CS.GF2.SDK.PlatformLoginManager.Instance:CustomerCenter()
end


function UICommanderInfoPanel:OnToggleMan(isOn)
	if isOn then
		self.mView.mToggle_Man:Select();
		self.mView.mToggle_Man.interactable = false;
		self.mView.mToggle_Women.interactable = true;
		AccountNetCmdHandler.Gender = 0;
	end
end

function UICommanderInfoPanel:OnToggleWoman(isOn)
	if isOn then
		self.mView.mToggle_Women:Select();
		self.mView.mToggle_Women.interactable = false;
		self.mView.mToggle_Man.interactable = true;
		AccountNetCmdHandler.Gender = 1;
	end
end

function UICommanderInfoPanel:OnToggleAvgNo(value)
	if (value == true) then
		self.mView.mToggle_AvgNo:Select();
		self.mView.mToggle_AvgNo.interactable = false;
		self.mView.mToggle_AvgYes.interactable = true;
		AccountNetCmdHandler.AvgRepetion = 0;
	end
end

function UICommanderInfoPanel:OnToggleAvgYes(value)
	if (value == true) then
		self.mView.mToggle_AvgYes:Select();
		self.mView.mToggle_AvgYes.interactable = false;
		self.mView.mToggle_AvgNo.interactable = true;
		AccountNetCmdHandler.AvgRepetion = 1;
	end

end

function UICommanderInfoPanel:OnToggleChinese(value)
	if (value == true) then
		self.mView.mToggle_Chinese:Select();
		self.mView.mToggle_Chinese.interactable = false;
		self.mView.mToggle_Japan.interactable = true;
		self.mView.mToggle_English.interactable = true;
		AccountNetCmdHandler.AvgVoice = 0;
	end
end

function UICommanderInfoPanel:OnToggleJapan(value)
	if (value == true) then
		self.mView.mToggle_Japan:Select();
		self.mView.mToggle_Chinese.interactable = true;
		self.mView.mToggle_Japan.interactable = false;
		self.mView.mToggle_English.interactable = true;
		AccountNetCmdHandler.AvgVoice = 1;
	end
end

function UICommanderInfoPanel:OnToggleEnglish(value)
	if (value == true) then
		self.mView.mToggle_English:Select();
		self.mView.mToggle_Chinese.interactable = true;
		self.mView.mToggle_Japan.interactable = true;
		self.mView.mToggle_English.interactable = false;
		AccountNetCmdHandler.AvgVoice = 2;
	end
end


 
