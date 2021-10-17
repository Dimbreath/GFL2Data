require("UI.UIBaseView")

UICharacterDetailPanelView = class("UICharacterDetailPanelView", UIBaseView);
UICharacterDetailPanelView.__index = UICharacterDetailPanelView

function UICharacterDetailPanelView.ctor()
    UICharacterDetailPanelView.super.ctor(self)
end

function UICharacterDetailPanelView:__InitCtrl()
    self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
    self.mBtn_CommandCenter = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))
    self.mBtn_PowerInfo = self:GetButton("Trans_power/Btn_PowerInfoButton")
    self.mBtn_GunList = self:GetButton("Root/GrpBottom/Trans_GrpBtnSwitchIcon/Grp_BtnChrChoose")
    self.mBtn_CurGun = self:GetButton("Root/GrpBottom/Trans_GrpBtnSwitchHead/BtnHead/Btn_Head")

    self.mBtn_CloseCharacterList = self:GetButton("Root/Trans_ChrList/Btn_Close")

    self.mBtn_Duty = self:GetButton("Root/Trans_ChrList/GrpElementScreen/BtnScreen/Btn_Screen")
    self.mImage_DutyIcon = self:GetImage("Root/Trans_ChrList/GrpElementScreen/BtnScreen/Btn_Screen/Img_Icon")
    self.mImage_GunHead = self:GetImage("Root/GrpBottom/Trans_GrpBtnSwitchHead/BtnHead/Btn_Head/GrpHead/Img_ChrHead")
    self.mText_GunName = self:GetText("Root/GrpBottom/Trans_GrpBtnSwitchHead/BtnChrName/Text_Name")

    self.mTrans_Tabs = self:GetRectTransform("Root/GrpLeft/GrpDetailsList/Content")
    self.mTrans_LevelUp = self:GetRectTransform("Root/GrpPowerUp/Trans_Overview")
    self.mTrans_Upgrade = self:GetRectTransform("Root/GrpPowerUp/Trans_StageUp")
    self.mTrans_Mental = self:GetRectTransform("Root/GrpPowerUp/Trans_Mental")
    self.mTrans_Equip = self:GetRectTransform("Root/GrpPowerUp/Trans_Equip")
    self.mTrans_Weapon = self:GetRectTransform("Root/GrpPowerUp/Trans_Weapon")
    self.mTrans_Mask = self:GetRectTransform("Trans_Mask")
    self.mText_Power = self:GetText("Trans_power/Text_powerText")
    self.mTrans_SwitchContent = self:GetRectTransform("Root/GrpBottom")
    self.mText_CurGunName = self:GetText("Trans_switch/UI_Trans_current/Text_CharacterName")
    self.mTrans_RawImage = self:GetRectTransform("Root/GrpPowerUp/Trans_Overview/SwipeController")
    self.mTrans_CharacterList = self:GetRectTransform("Root/Trans_ChrList/GrpChrList/Viewport/Content")
    self.mTrans_Character = self:GetRectTransform("Root/Trans_ChrList")
    self.mTrans_GunList = self:GetRectTransform("Root/GrpBottom/Trans_GrpBtnSwitchIcon")
    self.mTrans_CurGun = self:GetRectTransform("Root/GrpBottom/Trans_GrpBtnSwitchHead")

    self.mTrans_DutyContent = self:GetRectTransform("Root/Trans_ChrList/GrpElementScreen/Trans_GrpScreenList")

    self.mTrans_SortContent = self:GetRectTransform("Root/Trans_ChrList/GrpScreen/BtnScreen")
    self.mTrans_SortList = self:GetRectTransform("Root/Trans_ChrList/GrpScreen/Trans_GrpScreenList")

    self.mTrans_Switch = self:GetRectTransform("Root/GrpArrow")
    local obj = self:InstanceUIPrefab("UICommonFramework/ComBtnArrow3ItemV2.prefab", self.mTrans_Switch, true)
    self.mBtn_PreGun = UIUtils.GetButton(obj, "BtnLeft/Btn_Left")
    self.mBtn_NextGun = UIUtils.GetButton(obj, "BtnRight/Btn_Right")
end

function UICharacterDetailPanelView:InitCtrl(root)
    self:SetRoot(root);

    self:__InitCtrl();
end