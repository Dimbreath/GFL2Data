require("UI.UIBaseCtrl")
---@class UIFriendInfoItem : UIBaseCtrl

UIFriendInfoItem = class("UIFriendInfoItem", UIBaseCtrl)
UIFriendInfoItem.__index = UIFriendInfoItem

UIFriendInfoItem.IconStr = "Icon_Character_"
UIFriendInfoItem.closeCallback = nil

UIFriendInfoItem.PanelType =
{
    None = 0,
    Self = 1,
    Friend = 2,
    Stranger = 3,
}

function UIFriendInfoItem:ctor()
    self.playerData = nil
    self.panelType = UIFriendInfoItem.PanelType.None
    self.playerAvatar = nil
    self.stageItem = nil
    self.dutyItem = nil
end

function UIFriendInfoItem:__InitCtrl()
    self.mBtn_Close = self:GetButton("GrpCenter/GrpClose/Btn_Close")

    self.mBtn_ReName = self:GetButton("GrpCenter/GrpLeft/GrpPlayerInfo/GrpCenterText/GrpPlayerName/TextName/Trans_BtnModify/Trans_Btn_Remark")
    self.mBtn_Remark = self:GetButton("GrpCenter/GrpLeft/GrpPlayerInfo/GrpCenterText/GrpPlayerName/TextName/Trans_BtnRemark/Btn_Remark")
    self.mBtn_Copy = self:GetButton("GrpCenter/GrpLeft/GrpUID/Btn_Copy")
    self.mBtn_BlackList = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/BtnLeft/Trans_BtnBlackList"))
    self.mBtn_Report = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/BtnLeft/BtnReport"))
    self.mBtn_Delete = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/GrpRight/Trans_BtnFriendDelete"))
    self.mBtn_Add = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/GrpRight/Trans_BtnFriendAdd"))
    self.mBtn_GuildInvite = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/GrpRight/Trans_BtnGuildInvite"))
    self.mBtn_BlackListRemove = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/GrpRight/Trans_BtnBlackListRemove"))

    self.mTrans_BlackList = self:GetRectTransform("GrpAction/BtnLeft/Trans_BtnBlackList")
    self.mTrans_Report = self:GetRectTransform("GrpAction/BtnLeft/BtnReport")
    self.mTrans_Delete = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnFriendDelete")
    self.mTrans_Add = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnFriendAdd")
    self.mTrans_GuildInvite = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnGuildInvite")
    self.mTrans_BlackListRemove = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnBlackListRemove")
    self.mTrans_ChangeAssistant = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnChangeAssitant")
    self.mTrans_CheckIn = self:GetRectTransform("GrpAction/GrpRight/Trans_BtnCheckIn")

    self.mTrans_BtnGroup = self:GetRectTransform("GrpAction")

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

    self.mImage_GunHalf = self:GetImage("GrpCenter/GrpRight/GrpSupportChr/GrpChrAvatar/Img_Avatar")
    self.mImage_GunIcon = self:GetImage("GrpCenter/GrpRight/GrpSupportChr/GrpChrIcon/Img_Icon")
    self.mText_GunName = self:GetText("GrpCenter/GrpRight/GrpSupportChr/GrpContent/GrpTextName/Text_Name")
    self.mText_GunLevel = self:GetText("GrpCenter/GrpRight/GrpSupportChr/GrpLvMental/GrpTextLv/Text_Lv")
    self.mImage_Mental = self:GetImage("GrpCenter/GrpRight/GrpSupportChr/GrpLvMental/GrpMental/GrpLevel/Img_Level")
    self.mTrans_StageContent = self:GetRectTransform("GrpCenter/GrpRight/GrpSupportChr/GrpStage")
    self.mTrans_Duty = self:GetRectTransform("GrpCenter/GrpRight/GrpSupportChr/GrpContent/GrpDuty")

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

    UIUtils.GetButtonListener(self.mBtn_Add.gameObject).onClick = function()
        self:OnClickAddFriend()
    end

    UIUtils.GetButtonListener(self.mBtn_Delete.gameObject).onClick = function()
        self:OnClickDelFriend()
    end

    UIUtils.GetButtonListener(self.mBtn_BlackList.gameObject).onClick = function()
        self:SetBlackList()
    end

    UIUtils.GetButtonListener(self.mBtn_BlackListRemove.gameObject).onClick = function()
        self:SetBlackList()
    end

    UIUtils.GetButtonListener(self.mBtn_Remark.gameObject).onClick = function()
        self:OnClickRemark()
    end
end

function UIFriendInfoItem:InitCtrl(parent, closeCallback)
    local obj = instantiate(UIUtils.GetGizmosPrefab("CommanderInfo/CommanderInfoCardItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()

    self.closeCallback = closeCallback
end

function UIFriendInfoItem:SetData(data)
    self.playerData = data.IsSelf and AccountNetCmdHandler:GetRoleInfoData() or data
    self.panelType = data.IsSelf and UIFriendInfoItem.PanelType.Self or ((data.IsFriend) and UIFriendInfoItem.PanelType.Friend or UIFriendInfoItem.PanelType.Stranger)

    self:UpdatePlayerInfo()
end

function UIFriendInfoItem:UpdatePlayerInfo()
    self:UpdatePlayerName()
    self:UpdateAssistGun()
    self:UpdateFriendContent()
    if self.playerData.GuildID <= 0 then
        self.mText_GuidName.text = TableData.GetHintById(100014)
        self.mText_GuidName.color = ColorUtils.GrayColor
    else
        self.mText_GuidName.text = self.playerData.GuildName
        self.mText_GuidName.color = ColorUtils.BlackColor
    end

    if self.playerData.PlayerMotto == nil or self.playerData.PlayerMotto == "" then
        self.mText_Signature.text = CS.LuaUIUtils.Unescape(TableData.GetHintById(100013))
        self.mText_Signature.color = ColorUtils.GrayColor
    else
        self.mText_Signature.text = self.playerData.PlayerMotto
        self.mText_Signature.color = ColorUtils.BlackColor
    end

    self.mText_BrithDay.text = self.playerData.BirthdayStr
    self.mText_GUID.text = self.playerData.UID
    self.mText_Level.text = GlobalConfig.LVText .. self.playerData.Level
    self.mText_Achievement.text = self.playerData.Achievement
    self.playerAvatar:SetData(self.playerData.Icon)
end

function UIFriendInfoItem:UpdatePlayerName()
    self.mText_Name.text = self.playerData.Name
    if self.panelType == UIFriendInfoItem.PanelType.Friend then
        if self.playerData.Mark == nil or self.playerData.Mark == "" then
            setactive(self.mText_RemakeName.gameObject, false)
        else
            self.mText_RemakeName.text = self.playerData.Mark
            setactive(self.mText_RemakeName.gameObject, true)
        end
    else
        setactive(self.mText_RemakeName.gameObject, false)
    end
end

function UIFriendInfoItem:UpdateAssistGun()
    if self.playerData.IsSelf then
        self.playerData:UpdateSelfAssistGun()
    end

    local gunData = TableData.listGunDatas:GetDataById(self.playerData.AssistGunId)
    if gunData then
        local characterData = TableData.listGunCharacterDatas:GetDataById(gunData.character_id)
        local dutyData = TableData.listGunDutyDatas:GetDataById(gunData.duty)
        local avatar = IconUtils.GetCharacterHalfSprite(IconUtils.cCharacterAvatarType_Avatar, gunData.code)
        self.mImage_GunIcon.sprite = IconUtils.GetGunCharacterIcon(UIFriendInfoItem.IconStr .. characterData.en_name)
        self.mImage_GunHalf.sprite = avatar
        self.mText_GunLevel.text = GlobalConfig.LVText .. self.playerData.GunLevel
        self.mText_GunName.text = gunData.name.str
        self:SetMental(self.playerData.AssistGunId)
        self.stageItem:SetData(self.playerData.GunUpgrade)
        self.dutyItem:SetData(dutyData)
    else
        gfdebug("策划说了不可能没有助战人形，看看这个ID是不是出了什么问题" .. self.playerData.AssistGunId)
    end
end

function UIFriendInfoItem:SetMental(id)
    local rankNum = 0
    local mentalData = TableData.listMentalCircuitDatas:GetDataById(id)
    if self.playerData.GunMentalNode ~= nil then
        for i = 0, mentalData.rank_list.Count - 1 do
            if mentalData.rank_list[i] == self.playerData.GunMentalNode.Id then
                rankNum = i
            end
        end
    end

    self.mImage_Mental.sprite = IconUtils.GetMentalIcon(FacilityBarrackGlobal.RomaIconPrefix .. rankNum + 1)
end

function UIFriendInfoItem:UpdateFriendContent()
    setactive(self.mTrans_Add.gameObject, not self.playerData.IsFriend and not self.playerData.IsBlack)
    setactive(self.mTrans_Delete.gameObject, self.playerData.IsFriend)
    setactive(self.mTrans_BlackList.gameObject, not self.playerData.IsBlack)
    setactive(self.mTrans_BlackListRemove.gameObject, self.playerData.IsBlack)
    setactive(self.mTrans_GuildInvite.gameObject, self.playerData.CanBeInvitedToGuild and AccountNetCmdHandler:CanInviteGuildMember())
    setactive(self.mTrans_SignModify, false)
    setactive(self.mTrans_Remark, self.panelType == UIFriendInfoItem.PanelType.Friend)
    setactive(self.mTrans_Rename, false)
    setactive(self.mTrans_BtnGroup, self.panelType == UIFriendInfoItem.PanelType.Friend or self.panelType == UIFriendInfoItem.PanelType.Stranger)
    setactive(self.mTrans_ChangeAssistant, false)
    setactive(self.mTrans_CheckIn, false)
end

function UIFriendInfoItem:OnClickAddFriend()
    NetCmdFriendData:SendSocialFriendApply(self.playerData.UID, function ()
        UIUtils.PopupPositiveHintMessage(100027)
        if self.closeCallback then
            self.closeCallback()
        end
    end)
end

function UIFriendInfoItem:OnClickDelFriend()
    MessageBoxPanel.ShowDoubleType(TableData.GetHintById(100028), function ()
        self:OnDeleteConfirmed()
    end)
end

function UIFriendInfoItem:OnDeleteConfirmed()
    NetCmdFriendData:SendSocialDeleteFriend(self.playerData.UID, function ()
        if self.closeCallback then
            self.closeCallback()
        end
    end)
end

function UIFriendInfoItem:SetBlackList()
    if self.playerData.IsBlack then
        NetCmdFriendData:SetUnsetBlackList(self.playerData.UID, function (ret)
            self:OnBlackListCallback(ret, false)
        end)
    else
        MessageBoxPanel.ShowDoubleType(TableData.GetHintById(100038), function ()
            NetCmdFriendData:SendSetBlackList(self.playerData.UID, function (ret)
                self:OnBlackListCallback(ret, true)
            end)
        end)
    end
end

function UIFriendInfoItem:OnBlackListCallback(ret, isSet)
    if ret == CS.CMDRet.eSuccess then
        if isSet then
            NetCmdFriendData:SetFriendBlackList(self.playerData)
        end
        MessageSys:SendMessage(CS.GF2.Message.FriendEvent.FriendListChange,nil)

        if self.closeCallback then
            self.closeCallback()
        end
    end
end

function UIFriendInfoItem:OnClickRemark()
    local defaultStr = ""
    if self.playerData.Mark ~= nil and self.playerData.Mark ~= "" then
        defaultStr = self.playerData.Mark
    end
    UIManager.OpenUIByParam(UIDef.UICommonModifyPanel, {function (strName)
        self:OnClickConfirm(strName)
    end, defaultStr})
end

function UIFriendInfoItem:OnClickConfirm(strName)
    NetCmdFriendData:SendSetFriendMark(self.playerData.UID, strName, function (ret)
        self:OnChangeNoteCallback(ret)
    end)
end

function UIFriendInfoItem:OnChangeNoteCallback(ret)
    if ret == CS.CMDRet.eSuccess then
        gfdebug("修改成功")
    else
        gfdebug("修改失败")
    end
    self:UpdatePlayerName()
    MessageSys:SendMessage(CS.GF2.Message.FriendEvent.FriendListChange, nil)
end


function UIFriendInfoItem:OnClickCopyUid()
    CS.UnityEngine.GUIUtility.systemCopyBuffer = self.playerData.UID
    UIUtils.PopupPositiveHintMessage(7002)
end