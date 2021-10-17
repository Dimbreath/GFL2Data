require("UI.UIBaseCtrl")

UIGuildListItem = class("UIGuildListItem", UIBaseCtrl);
UIGuildListItem.__index = UIGuildListItem

UIGuildListItem.guildData = nil
UIGuildListItem.type = 0

function UIGuildListItem:ctor()
    UIGuildListItem.super.ctor(self)
end

function UIGuildListItem:__InitCtrl()
    self.mImage_Icon = self:GetImage("Btn_Flag")
    self.mText_Name = self:GetText("Text_Name")
    self.mText_UID = self:GetText("Text_UID")
    self.mText_Leader = self:GetText("Con_Info/Con_Leader/Text_Leader")
    self.mText_MemberNum = self:GetText("Con_Info/Con_MemberNum/Text_Num")
    self.mText_Setting = self:GetText("Con_Info/Con_Setting/Text_Setting")
    self.mText_Level = self:GetText("Con_Level/Text_Level")
    self.mTrans_AddPanel = self:GetRectTransform("UI_Trans_AddPanel")
    self.mTrans_ApplicationPanel = self:GetRectTransform("UI_Trans_ApplicationPanel")
    self.mBtn_Add = self:GetButton("UI_Trans_AddPanel/Btn_AddButton")
    self.mTrans_Refuse = self:GetRectTransform("UI_Trans_ApplicationPanel/Btn_RefuseButton")
    self.mTrans_Pass = self:GetRectTransform("UI_Trans_ApplicationPanel/Btn_PassButton")
    self.mBtn_Flag = self:GetButton("Btn_Flag")
end

function UIGuildListItem:InitCtrl()
    local obj = instantiate(UIUtils.GetGizmosPrefab("Guild/UIGuildListItem.prefab",self))
    self:SetRoot(obj.transform)
    self:__InitCtrl()

    UIUtils.GetButtonListener(self.mBtn_Add.gameObject).onClick = function()
        self:AddGuild()
    end

    UIUtils.GetButtonListener(self.mTrans_Refuse.gameObject).onClick = function()
        self:DealGuildInvitation(false)
    end

    UIUtils.GetButtonListener(self.mTrans_Pass.gameObject).onClick = function()
        self:DealGuildInvitation(true)
    end
end

function UIGuildListItem:SetData(guildData, type)
    self.guildData = guildData
    self.type = type
    if guildData then
        local icon = TableData.GetGuildFlagByID(guildData.flag)
        self.mImage_Icon.sprite = IconUtils.GetFlagIcon(icon)
        self.mText_Name.text = guildData.name
        self.mText_UID.text = "ID " .. guildData.id
        self.mText_Leader.text = guildData.leaderName
        self.mText_MemberNum.text = guildData.memberCount
        self.mText_Level.text = guildData.level
        self.mText_Setting.text = UIGuildGlobal:GetJoinCondition(guildData.applyType, guildData.applyLevel)

        self.mBtn_Add.interactable = AccountNetCmdHandler:CanApplyForGuild()
        setactive(self.mTrans_AddPanel, self.type == UIGuildGlobal.TagType.FindGuild)
        setactive(self.mTrans_ApplicationPanel, self.type == UIGuildGlobal.TagType.InviteGuild)
    end
end

function UIGuildListItem:AddGuild()
    if self.guildData.applyLevel > AccountNetCmdHandler:GetLevel() then
        local hint = TableData.GetHintById(60029)
        local str = string_format(hint, self.guildData.applyLevel)
        CS.PopupMessageManager.PopupString(str)
        return
    end
    
    NetCmdGuildData:SendSocialApplyJoinGuild(self.guildData.id, function () 
        self.mBtn_Add.interactable = false
        --if NetCmdGuildData:GetSelfMemberData().title ~= UIGuildGlobal.GuildTitleType.None then
        --    NetCmdGuildData:CreateSelfMemberData(false ,self.guildData.applyLevel, self.guildData.applyType)
        --    NetCmdGuildData:SendGuildInfo()
        --end
    end)
end

function UIGuildListItem:DealGuildInvitation(deal)
    NetCmdGuildData:SendSocialDealGuildInvitation(self.guildData.id, deal)
end