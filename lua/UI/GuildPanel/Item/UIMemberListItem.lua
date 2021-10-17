require("UI.UIBaseCtrl")

UIMemberListItem = class("UIMemberListItem", UIBaseCtrl)
UIMemberListItem.__index = UIMemberListItem

UIMemberListItem.StarList = {}
UIMemberListItem.playerInfo = nil
UIMemberListItem.guildInfo = nil
UIMemberListItem.selfTitle = nil
UIMemberListItem.isSetting = false

function UIMemberListItem:ctor()
    UIMemberListItem.super.ctor(self)
    UIMemberListItem.StarList = {}
    UIMemberListItem.playerInfo = nil
    UIMemberListItem.guildInfo = nil
    UIMemberListItem.selfTitle = nil
    UIMemberListItem.isSetting = false
end

function UIMemberListItem:__InitCtrl()
    self.mBtn_PlayerAvatar = self:GetButton("Trans_PlayerPanel/UI_Btn_PlayerAvatar")
    self.mBtn_Setting = self:GetRectTransform("Con_Setting/Btn_Setting")
    self.mBtn_MakeOver = self:GetRectTransform("Con_Setting/Con_SettingList/Btn_MakeOver")
    self.mBtn_Appoint = self:GetRectTransform("Con_Setting/Con_SettingList/Btn_Appoint")
    self.mBtn_Cancel = self:GetRectTransform("Con_Setting/Con_SettingList/Btn_Cancel")
    self.mBtn_Exit = self:GetRectTransform("Con_Setting/Con_SettingList/Btn_Exit")
    self.mBtn_Refuse = self:GetRectTransform("UI_Trans_ApplicationPanel/Btn_RefuseButton")
    self.mBtn_Pass = self:GetRectTransform("UI_Trans_ApplicationPanel/Btn_PassButton")
    self.mImage_PlayerAvatar_AvatarImage = self:GetImage("Trans_PlayerPanel/UI_Btn_PlayerAvatar/RoundMask/Image_AvatarImage")
    self.mImage_avatarImage = self:GetImage("Trans_PlayerPanel/UI_Trans_AssistPanel/Trans_ChrCardList/UIBarrackChrCardItem/UI_unlock/avatar/Image_avatarImage")
    self.mImage_Gun_rank = self:GetImage("Trans_PlayerPanel/UI_Trans_AssistPanel/Trans_ChrCardList/UIBarrackChrCardItem/UI_unlock/Image_rank")
    self.mImage_unlock_rankHalf = self:GetImage("Trans_PlayerPanel/UI_Trans_AssistPanel/Trans_ChrCardList/UIBarrackChrCardItem/UI_unlock/Image_rank/Image_rankHalf")
    self.mImage_unlock_skillicon = self:GetImage("Trans_PlayerPanel/UI_Trans_AssistPanel/Trans_ChrCardList/UIBarrackChrCardItem/UI_unlock/Skill/Image_skillicon")
    self.mText_Name = self:GetText("Trans_PlayerPanel/Text_Name")
    self.mText_Added = self:GetText("Trans_PlayerPanel/UI_Trans_AddPanel/Btn_AddButton/Text_Added")
    self.mText_Title = self:GetText("Trans_PlayerPanel/Text_Title")
    self.mText_Level = self:GetText("Trans_PlayerPanel/Text_Level")
    self.mText_LastLoginTime = self:GetText("Trans_PlayerPanel/Trans_LastLogin/Text_LastLoginTime")
    self.mText_unlock_LevelNum = self:GetText("Trans_PlayerPanel/UI_Trans_AssistPanel/Trans_ChrCardList/UIBarrackChrCardItem/UI_unlock/level/Text_LevelNum")
    self.mTrans_PlayerPanel = self:GetRectTransform("Trans_PlayerPanel")
    self.mTrans_AssistPanel = self:GetRectTransform("Trans_PlayerPanel/UI_Trans_AssistPanel")
    self.mTrans_AssistPanel_ChrCardList = self:GetRectTransform("Trans_PlayerPanel/UI_Trans_AssistPanel")
    self.mTrans_Skill = self:GetRectTransform("Trans_PlayerPanel/UI_Trans_AssistPanel/Trans_ChrCardList/UIBarrackChrCardItem/UI_unlock/Skill")
    self.mTrans_Online = self:GetRectTransform("Trans_PlayerPanel/Trans_Online")
    self.mTrans_Setting = self:GetRectTransform("Con_Setting")
    self.mTrans_ApplicationPanel = self:GetRectTransform("UI_Trans_ApplicationPanel")

    for i = 1, UIGuildGlobal.MaxRank do
        local star = self:GetRectTransform("Trans_PlayerPanel/UI_Trans_AssistPanel/Trans_ChrCardList/UIBarrackChrCardItem/UI_unlock/Trans_ConStars/UIWeaponStar" .. i)
        table.insert(self.StarList, star)
    end
end

function UIMemberListItem:InitCtrl()
    local obj = instantiate(UIUtils.GetGizmosPrefab("Guild/UIMemberListItem.prefab",self))
    self:SetRoot(obj.transform)
    self:__InitCtrl()

    UIUtils.GetButtonListener(self.mBtn_Setting.gameObject).onClick = function()
        self:OpenSettingContent()
    end

    UIUtils.GetButtonListener(self.mBtn_Refuse.gameObject).onClick = function()
        self:OnClickApprove(false)
    end

    UIUtils.GetButtonListener(self.mBtn_Pass.gameObject).onClick = function()
        self:OnClickApprove(true)
    end

    UIUtils.GetButtonListener(self.mBtn_MakeOver.gameObject).onClick = function()
        self:OnClickOperation(UIGuildGlobal.GuildOperation.MakeOver)
    end

    UIUtils.GetButtonListener(self.mBtn_Appoint.gameObject).onClick = function()
        self:OnClickOperation(UIGuildGlobal.GuildOperation.Appoint)
    end

    UIUtils.GetButtonListener(self.mBtn_Cancel.gameObject).onClick = function()
        self:OnClickOperation(UIGuildGlobal.GuildOperation.Cancel)
    end

    UIUtils.GetButtonListener(self.mBtn_Exit.gameObject).onClick = function()
        self:OnClickOperation(UIGuildGlobal.GuildOperation.Exit)
    end
end

function UIMemberListItem:SetData(data, isApply, selfTitle, curMember)
    if not data then
        return
    end

    self.playerInfo = isApply and data or data.roleData
    self.guildInfo = isApply and nil or data
    self.selfTitle = selfTitle
    self.mImage_PlayerAvatar_AvatarImage.sprite = UIUtils.GetIconSprite("Icon/PlayerAvatar", self.playerInfo.Icon)
    self.mText_Level.text = self.playerInfo.Level
    if self.playerInfo.Mark == nil or self.playerInfo.Mark == "" then
        self.mText_Name.text = self.playerInfo.Name .. self.playerInfo.UID
    else
        self.mText_Name.text = self.playerInfo.Mark
    end
    setactive(self.mText_Title.gameObject, not isApply)
    if not isApply then
        self.mText_Title.text = UIGuildGlobal:GetTitleType(self.guildInfo.title)
    end

    setactive(self.mTrans_Online, self.playerInfo.IsOnline)
    setactive(self.mText_LastLoginTime.gameObject, not self.playerInfo.IsOnline)
    if not self.playerInfo.IsOnline then
        self.mText_LastLoginTime.text = self.playerInfo.LastLoginTime
    end

    local canOperation = UIGuildGlobal:CanOperation(selfTitle, self.guildInfo.title)

    setactive(self.mTrans_Setting.gameObject, not isApply and canOperation)
    setactive(self.mTrans_ApplicationPanel.gameObject, isApply)
    setactive(self.mTrans_AssistPanel_ChrCardList.gameObject, not isApply)
    if not isApply then
        self.isSetting = self.playerInfo.UID == curMember
        self:PlaySelectAni(false)
        self:UpdateAssistGun()
        self:UpdateSettingBtn(canOperation)
    end
end

function UIMemberListItem:OpenSettingContent()
    self.isSetting = not self.isSetting
    self:PlaySelectAni(true)
end

function UIMemberListItem:UpdateAssistGun()
    local gunData = TableData.listGunDatas:GetDataById(self.playerInfo.AssistGunId)
    if gunData then
        local avatar = IconUtils.GetCharacterHeadSprite(gunData.code)
        self.mImage_avatarImage.sprite = avatar
        local color = TableData.GetGlobalGun_Quality_Color2(gunData.rank)
        self.mImage_Gun_rank.color = color
        self.mImage_unlock_rankHalf.color = color
        self.mText_unlock_LevelNum.text = self.playerInfo.GunLevel
        for i = 1, #self.StarList do
            setactive(self.StarList[i], i <= self.playerInfo.GunUpgrade)
        end
        local skillId = gunData.skill_talent + 1
        local skillData = TableData.listBattleSkillDatas:GetDataById(skillId)
        setactive(self.mTrans_Skill.gameObject, skillData ~= nil)
        if skillData then
            self.mImage_unlock_skillicon.sprite = IconUtils.GetSkillIconSprite(skillData.icon)
        end
    else
        gfdebug("策划说了不可能没有助战人形，看看这个ID是不是出了什么问题" .. self.playerInfo.AssistGunId)
    end
end

function UIMemberListItem:UpdateSettingBtn(canOperation)
    setactive(self.mBtn_MakeOver.gameObject,   canOperation and self.guildInfo.title == UIGuildGlobal.GuildTitleType.SubLeader)
    setactive(self.mBtn_Cancel.gameObject, canOperation and self.guildInfo.title == UIGuildGlobal.GuildTitleType.SubLeader)
    setactive(self.mBtn_Appoint.gameObject,  canOperation and self.guildInfo.title == UIGuildGlobal.GuildTitleType.Normal and (NetCmdGuildData:GetLeaderNum() < UIGuildGlobal.LeaderLimit))
    setactive(self.mBtn_Exit.gameObject, canOperation)
end

function UIMemberListItem:PlaySelectAni(needAni)
    local pos = self.isSetting and UIGuildGlobal.UIMoveInPosX or UIGuildGlobal.UIMoveOutPosX
    if needAni then
        CS.UITweenManager.PlayAnchoredPositionXTween(self.mTrans_Setting, pos, 0.5, nil, UIGuildGlobal.TweenExpo)
    else
        local temp = self.mTrans_Setting.anchoredPosition
        temp.x = pos
        self.mTrans_Setting.anchoredPosition = temp
    end
end

function UIMemberListItem:OnClickOperation(type)
    if type == UIGuildGlobal.GuildOperation.MakeOver then
        NetCmdGuildData:SendSocialGuildTransferLeader(self.playerInfo.UID, function (ret) self:OperationCallback(ret, type) end)
    elseif type == UIGuildGlobal.GuildOperation.Cancel or type == UIGuildGlobal.GuildOperation.Appoint then
        NetCmdGuildData:SendSocialGuildChangeVise(self.playerInfo.UID, function (ret) self:OperationCallback(ret, type) end)
    elseif type == UIGuildGlobal.GuildOperation.Exit then
        NetCmdGuildData:SendSocialGuildKickUser(self.playerInfo.UID, function (ret) self:OperationCallback(ret, type) end)
    end
end

function UIMemberListItem:OperationCallback(ret, type)
    if ret == CS.CMDRet.eSuccess then
        if type == UIGuildGlobal.GuildOperation.MakeOver then
            self.guildInfo:MakeOver()
        elseif type == UIGuildGlobal.GuildOperation.Cancel or type == UIGuildGlobal.GuildOperation.Appoint then
            self.guildInfo:AppointOrCancel()
        elseif type == UIGuildGlobal.GuildOperation.Exit then
            NetCmdGuildData:RemoveMember(self.playerInfo.UID)
        end

        NetCmdGuildData:UpdateManagerList()
        MessageSys:SendMessage(CS.GF2.Message.GuildEvent.UpdateGuildMemberList, nil)
    end
end

function UIMemberListItem:OnClickApprove(deal)
    NetCmdGuildData:SendSocialApproveGuildApplication(self.playerInfo.UID, deal)
end
