require("UI.UIBaseCtrl")
---@class UIPlayerInfoItem : UIBaseCtrl

UIPlayerInfoItem = class("UIPlayerInfoItem", UIBaseCtrl)
UIPlayerInfoItem.__index = UIPlayerInfoItem

UIPlayerInfoItem.IconStr = "Icon_Character_"

UIPlayerInfoItem.ModifyType =
{
    Name = 1,
    Avatar = 2,
    BirthDay = 3,
    Sign = 4,
    AssistGun = 5,
}

function UIPlayerInfoItem:ctor()
    self.playerInfo = nil
    self.playerAvatar = nil
    self.supportList = nil
    self.stageItem = nil
    self.dutyItem = nil
end

function UIPlayerInfoItem:__InitCtrl()
    self.mBtn_ReName = self:GetButton("GrpCenter/GrpLeft/GrpPlayerInfo/GrpCenterText/GrpPlayerName/TextName/Trans_BtnModify/Trans_Btn_Remark")
    self.mBtn_Copy = self:GetButton("GrpCenter/GrpLeft/GrpUID/Btn_Copy")
    self.mBtn_BirthDayRemark = self:GetButton("GrpCenter/GrpLeft/GrpBirthDay/GrpTextBirthDay/Btn_Remark")
    self.mBtn_SignRemark = self:GetButton("GrpCenter/GrpLeft/GrpSign/Trans_BtnModify/Btn_Modify")
    self.mBtn_ChangeAssistant = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/GrpRight/Trans_BtnChangeAssitant"))
    self.mBtn_CheckIn = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/GrpRight/Trans_BtnCheckIn"))

    self.mTrans_BlackList = self:GetRectTransform("GrpAction/BtnLeft/Trans_BtnBlackList")
    self.mTrans_Report = self:GetRectTransform("GrpAction/BtnLeft/BtnReport")
    self.mTrans_Delete = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnFriendDelete")
    self.mTrans_Add = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnFriendAdd")
    self.mTrans_GuildInvite = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnGuildInvite")
    self.mTrans_BlackListRemove = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnBlackListRemove")
    self.mTrans_ChangeAssistant = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnChangeAssitant")
    self.mTrans_CheckIn = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnCheckIn")

    self.mTrans_Exp = self:GetRectTransform("GrpCenter/GrpLeft/GrpPlayerInfo/GrpCenterText/Trans_GrpEXP")
    self.mTrans_Avatar = self:GetRectTransform("GrpCenter/GrpLeft/GrpPlayerInfo/GrpPlayerAvatar")
    self.mTrans_Rename = self:GetRectTransform("GrpCenter/GrpLeft/GrpPlayerInfo/GrpCenterText/GrpPlayerName/TextName/Trans_BtnModify")
    self.mTrans_Remark = self:GetRectTransform("GrpCenter/GrpLeft/GrpPlayerInfo/GrpCenterText/GrpPlayerName/TextName/Trans_BtnRemark")
    self.mTrans_SignModify = self:GetRectTransform("GrpCenter/GrpLeft/GrpSign/Trans_BtnModify")
    self.mText_Name = self:GetText("GrpCenter/GrpLeft/GrpPlayerInfo/GrpCenterText/GrpPlayerName/TextName/Text_PlayerName")
    self.mText_RemakeName = self:GetText("GrpCenter/GrpLeft/GrpPlayerInfo/GrpCenterText/GrpPlayerName/Trans_Text_RemarksName")
    self.mText_BrithDay = self:GetText("GrpCenter/GrpLeft/GrpBirthDay/Text_BirthDay")
    self.mText_Achievement = self:GetText("GrpCenter/GrpLeft/GrpAchievement/Text_Num")
    self.mText_Level = self:GetText("GrpCenter/GrpLeft/GrpPlayerInfo/GrpCenterText/Text_Level")
    self.mText_GUID = self:GetText("GrpCenter/GrpLeft/GrpUID/Text_UID")
    self.mText_GuidName = self:GetText("GrpCenter/GrpLeft/GrpGuild/Text_GuildName")
    self.mText_Signature = self:GetText("GrpCenter/GrpLeft/GrpSign/GrpTextSign/Viewport/Content/Text_Sign")
    self.mText_AchieveNum = self:GetText("GrpCenter/GrpLeft/GrpAchievement/Text_Num")
    self.mText_Exp = self:GetText("GrpCenter/GrpLeft/GrpPlayerInfo/GrpCenterText/Trans_GrpEXP/Text_Exp")
    self.mTrans_StageContent = self:GetRectTransform("GrpCenter/GrpRight/GrpSupportChr/GrpStage")

    self.mImage_GunHalf = self:GetImage("GrpCenter/GrpRight/GrpSupportChr/GrpChrAvatar/Img_Avatar")
    self.mImage_GunIcon = self:GetImage("GrpCenter/GrpRight/GrpSupportChr/GrpChrIcon/Img_Icon")
    self.mText_GunName = self:GetText("GrpCenter/GrpRight/GrpSupportChr/GrpContent/GrpTextName/Text_Name")
    self.mText_GunLevel = self:GetText("GrpCenter/GrpRight/GrpSupportChr/GrpLvMental/GrpTextLv/Text_Lv")
    self.mImage_Mental = self:GetImage("GrpCenter/GrpRight/GrpSupportChr/GrpLvMental/GrpMental/GrpLevel/Img_Level")
    self.mTrans_Duty = self:GetRectTransform("GrpCenter/GrpRight/GrpSupportChr/GrpContent/GrpDuty")

    self.mTrans_Close = self:GetRectTransform("GrpCenter/GrpClose")

    if self.playerAvatar == nil then
        self.playerAvatar = UICommonPlayerAvatarItem.New()
        self.playerAvatar:InitCtrl(self.mTrans_Avatar)
    end

    if self.stageItem == nil then
        self.stageItem = UICommonStageItem.New(GlobalConfig.MaxStar)
        self.stageItem:InitCtrl(self.mTrans_StageContent)
    end

    if self.dutyItem == nil then
        self.dutyItem = UICommonDutyItem.New()
        self.dutyItem:InitCtrl(self.mTrans_Duty)
    end

    UIUtils.GetButtonListener(self.mBtn_Copy.gameObject).onClick = function()
        self:OnClickCopyUid()
    end

    UIUtils.GetButtonListener(self.playerAvatar.mBtn_Avatar.gameObject).onClick = function()
        self:OnCLickAvatar()
    end

    UIUtils.GetButtonListener(self.mBtn_ReName.gameObject).onClick = function()
        self:OnClickRemark()
    end

    UIUtils.GetButtonListener(self.mBtn_BirthDayRemark.gameObject).onClick = function()
        self:OnClickBirthDayRemark()
    end

    UIUtils.GetButtonListener(self.mBtn_SignRemark.gameObject).onClick = function()
        self:OnClickSignRemark()
    end

    UIUtils.GetButtonListener(self.mBtn_CheckIn.gameObject).onClick = function()
        self:OnClickCheckIn()
    end

    UIUtils.GetButtonListener(self.mBtn_ChangeAssistant.gameObject).onClick = function()
        self:OnClickAssistant()
    end

    setactive(self.mTrans_Exp, true)
    setactive(self.mTrans_Close, false)
    setactive(self.mBtn_BirthDayRemark.gameObject, false)
end

function UIPlayerInfoItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("CommanderInfo/CommanderInfoCardItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIPlayerInfoItem:SetData(data)
    self.playerInfo = data
    self:UpdatePlayerInfo()
end

function UIPlayerInfoItem:UpdatePlayerInfo()
    self:UpdatePlayerName()
    self:UpdatePlayerMotto()
    self:UpdateAssistGun()
    self:UpdateBtnGroup()
    if self.playerInfo.GuildID <= 0 then
        self.mText_GuidName.text = TableData.GetHintById(100014)
        self.mText_GuidName.color = ColorUtils.GrayColor
    else
        self.mText_GuidName.text = self.playerInfo.GuildName
        self.mText_GuidName.color = ColorUtils.BlackColor
    end

    local curExp = self.playerInfo.Exp
    local maxExp = 0
    if self.playerInfo.Level < TableData.GlobalConfigData.CommanderLevel then
        local data = TableData.listPlayerLevelDatas:GetDataById(self.playerInfo.Level + 1)
        maxExp = data.exp
    else
        local data = TableData.listPlayerLevelDatas:GetDataById(TableData.GlobalConfigData.CommanderLevel)
        maxExp = data.exp
        curExp = data.exp
    end

    self.mText_BrithDay.text = self.playerInfo.BirthdayStr
    self.mText_GUID.text = self.playerInfo.UID
    self.mText_Level.text = GlobalConfig.LVText .. self.playerInfo.Level
    self.mText_Exp.text = curExp .. "/" .. maxExp
    self.mText_AchieveNum.text = NetCmdAchieveData:GetTotalPoints()

    self.playerAvatar:SetData(self.playerInfo.Icon)
end

function UIPlayerInfoItem:UpdatePlayerName()
    self.mText_Name.text = self.playerInfo.Name
end

function UIPlayerInfoItem:UpdatePlayerMotto()
    if self.playerInfo.PlayerMotto == nil or self.playerInfo.PlayerMotto == "" then
        self.mText_Signature.text = CS.LuaUIUtils.Unescape(TableData.GetHintById(100013))
        self.mText_Signature.color = ColorUtils.GrayColor
    else
        self.mText_Signature.text = self.playerInfo.PlayerMotto
        self.mText_Signature.color = ColorUtils.StringToColor("9B816A")
    end
end

function UIPlayerInfoItem:UpdateAssistGun()
    self.playerInfo:UpdateSelfAssistGun()
    local gunData = TableData.listGunDatas:GetDataById(self.playerInfo.AssistGunId)
    if gunData then
        local characterData = TableData.listGunCharacterDatas:GetDataById(gunData.character_id)
        local dutyData = TableData.listGunDutyDatas:GetDataById(gunData.duty)
        local avatar = IconUtils.GetCharacterHalfSprite(IconUtils.cCharacterAvatarType_Avatar, gunData.code)
        self.mImage_GunIcon.sprite = IconUtils.GetGunCharacterIcon(UIPlayerInfoItem.IconStr .. characterData.en_name)
        self.mImage_GunHalf.sprite = avatar
        self.mText_GunLevel.text = GlobalConfig.LVText .. self.playerInfo.GunLevel
        self.mText_GunName.text = gunData.name.str
        self:SetMental(self.playerInfo.AssistGunId)
        self.stageItem:SetData(self.playerInfo.GunUpgrade)
        self.dutyItem:SetData(dutyData)
    else
        gfdebug("策划说了不可能没有助战人形，看看这个ID是不是出了什么问题" .. self.playerInfo.AssistGunId)
    end
end

function UIPlayerInfoItem:SetMental(id)
    local rankNum = 0
    local mentalData = TableData.listMentalCircuitDatas:GetDataById(id)
    if self.playerInfo.GunMentalNode ~= nil then
        for i = 0, mentalData.rank_list.Count - 1 do
            if mentalData.rank_list[i] == self.playerInfo.GunMentalNode.Id then
                rankNum = i
            end
        end
    end

    self.mImage_Mental.sprite = IconUtils.GetMentalIcon(FacilityBarrackGlobal.RomaIconPrefix .. rankNum + 1)
end

function UIPlayerInfoItem:UpdateBtnGroup()
    setactive(self.mTrans_Add.gameObject, false)
    setactive(self.mTrans_Delete.gameObject, false)
    setactive(self.mTrans_BlackList.gameObject, false)
    setactive(self.mTrans_BlackListRemove.gameObject, false)
    setactive(self.mTrans_GuildInvite.gameObject, false)
    setactive(self.mTrans_ChangeAssistant, true)
    setactive(self.mTrans_CheckIn, AccountNetCmdHandler:CheckSystemIsUnLock(SystemList.Checkin))
end

function UIPlayerInfoItem:OnClickRemark()
    local defaultStr = ""
    if self.playerInfo.Name ~= nil and self.playerInfo.Name ~= "" then
        defaultStr = self.playerInfo.Name
    end
    UIManager.OpenUIByParam(UIDef.UICommonSelfModifyPanel, {function (strName)
        self:OnClickConfirm(strName, UIPlayerInfoItem.ModifyType.Name)
    end, defaultStr})
end

function UIPlayerInfoItem:OnCLickAvatar()
    local defaultStr = self.playerInfo.Portrait
    if self.playerInfo.Portrait ~= nil and self.playerInfo.Portrait ~= "" then
        defaultStr = self.playerInfo.Portrait
    end
    UIManager.OpenUIByParam(UIDef.UICommonAvatarModifyPanel, {function (strName)
        self:OnClickConfirm(strName, UIPlayerInfoItem.ModifyType.Avatar)
    end, defaultStr})
end

function UIPlayerInfoItem:OnClickBirthDayRemark()

end

function UIPlayerInfoItem:OnClickSignRemark()
    local defaultStr = ""
    if self.playerInfo.PlayerMotto ~= nil and self.playerInfo.PlayerMotto ~= "" then
        defaultStr = self.playerInfo.PlayerMotto
    end
    UIManager.OpenUIByParam(UIDef.UICommonSignModifyPanel, {function (strName)
        self:OnClickConfirm(strName, UIPlayerInfoItem.ModifyType.Sign)
    end, defaultStr})
end

function UIPlayerInfoItem:OnClickAssistant()
    if self.supportList == nil then
        self.supportList = UISupportGunItem.New()
        self.supportList:InitCtrl(UICommanderInfoPanelV2.mView.mTrans_SupChrReplace, function (strName)
            self:OnClickConfirm(strName, UIPlayerInfoItem.ModifyType.AssistGun)
        end)
    end
    self.supportList:SetData(self.playerInfo.AssistGunId)
    setactive(UICommanderInfoPanelV2.mView.mTrans_SupChrReplace, true)
end

function UIPlayerInfoItem:OnClickConfirm(strName, type)
    if type == UIPlayerInfoItem.ModifyType.Name then
        AccountNetCmdHandler:SendModNameReq(strName, function (ret)
            self:OnChangeNoteCallback(ret, type)
        end)
    elseif type == UIPlayerInfoItem.ModifyType.Sign then
        AccountNetCmdHandler:SendReqModPlayerMotto(strName, function (ret)
            self:OnChangeNoteCallback(ret, type)
        end)
    elseif type == UIPlayerInfoItem.ModifyType.Avatar then
        AccountNetCmdHandler:SendReqModPlayerPortrait(tonumber(strName), function (ret)
            self:OnChangeNoteCallback(ret, type)
        end)
    elseif type == UIPlayerInfoItem.ModifyType.AssistGun then
        AccountNetCmdHandler:SendReqSetAssistant(tonumber(strName), function (ret)
            self:OnChangeNoteCallback(ret, type)
        end)
    end
end

function UIPlayerInfoItem:OnChangeNoteCallback(ret, type)
    if ret == CS.CMDRet.eSuccess then
        if type == UIPlayerInfoItem.ModifyType.Name  then
            UIUtils.PopupPositiveHintMessage(7001)
            self:UpdatePlayerName()
        elseif type == UIPlayerInfoItem.ModifyType.Sign then
            UIUtils.PopupPositiveHintMessage(7001)
            self:UpdatePlayerMotto()
        elseif type == UIPlayerInfoItem.ModifyType.Avatar then
            self.playerAvatar:SetData(self.playerInfo.Icon)
        elseif type == UIPlayerInfoItem.ModifyType.AssistGun then
            self:UpdateAssistGun()
            self.supportList:SetData(self.playerInfo.AssistGunId)
        end
    else
        if type == UIPlayerInfoItem.ModifyType.Name or type == UIPlayerInfoItem.ModifyType.Sign then
            UIUtils.PopupHintMessage(60049)
        end
    end
end

function UIPlayerInfoItem:OnClickCheckIn()
    UIManager.OpenUIByParam(UIDef.UIDailyCheckInPanel)
end

function UIPlayerInfoItem:OnClickCopyUid()
    CS.UnityEngine.GUIUtility.systemCopyBuffer = self.playerInfo.UID
    UIUtils.PopupPositiveHintMessage(7002)
end