UIGuildGlobal = {}

UIGuildGlobal.LevelStringTemp = "{0}/{1}"
UIGuildGlobal.TimeStringTemp = "{0}:{1}:{2}"

UIGuildGlobal.MaxRank = 6
UIGuildGlobal.TimeLoop = 5

UIGuildGlobal.TagType =
{
    FindGuild = 1,
    InviteGuild = 2,
    CreateGuild = 3
}

UIGuildGlobal.PanelType =
{
    JoinGuild = 1,
    GuildMain = 2,
    GuildInfo = 3,
}

UIGuildGlobal.MainSubPanelType =
{
    Info = 1,
    Quest = 2,
    Donation = 3,
    Buff = 4
}

UIGuildGlobal.SubPanelType =
{
    GuildInfo = 1,
    MemberList = 2,
    Apply = 3,
    LevelInfo = 4,
    ChangeFlag = 5,
}


UIGuildGlobal.GuildApplyType =
{
    Direct = 0,
    PermNormal = 1,
    PermHigh = 2,
    OnlyInvite = 3,
}

UIGuildGlobal.GuildTitleType =
{
    None = -1,
    TitleNone = 0,
    Leader = 1,
    SubLeader = 2,
    Normal = 3
}

UIGuildGlobal.GuildApplyTag =
{
    Setting = 1,
    ApplyList = 2,
}

UIGuildGlobal.SortType =
{
    Level = 1,
    Time = 2,
}

UIGuildGlobal.GuildApproveRes = {
    Accept = 0,
    Reject = 1,
    TimeNotArrived = 2,
    GuildFull = 3,
    GuildDismiss  = 4,
    NoAccess = 5,
    Passed = 6,
    OtherGuild = 7
}

UIGuildGlobal.UserDealGuildInvitation = {
    Accept = 0,
    Reject = 1,
    TimeNotArrived = 2,
    GuildFull = 3,
    GuildDismiss = 4,
}

UIGuildGlobal.GuildOperation =
{
    MakeOver = 1,
    Cancel = 2,
    Appoint = 3,
    Exit = 4
}

UIGuildGlobal.WelfareType =
{
    Buff = 1,
    Item = 2,
}

UIGuildGlobal.UIMoveInPosX = 0
UIGuildGlobal.UIMoveOutPosX = 560
UIGuildGlobal.TweenExpo = CS.DG.Tweening.Ease.InOutCirc
UIGuildGlobal.LeaderLimit = 3
UIGuildGlobal.OrangeColor = CS.GF2.UI.UITool.StringToColor("FF8601")
UIGuildGlobal.GreenColor = CS.GF2.UI.UITool.StringToColor("65B73C")
UIGuildGlobal.EnLockHint = "UNLOCK AT Lv.{0}"
UIGuildGlobal.NoticeTip = "暂无公告"

function UIGuildGlobal:GetJoinCondition(type, level)
    local hint = nil
    if type == UIGuildGlobal.GuildApplyType.Direct then
        hint = TableData.GetHintById(60027)
    elseif type == UIGuildGlobal.GuildApplyType.PermNormal or type == UIGuildGlobal.GuildApplyType.PermHigh then
        hint = TableData.GetHintById(60026)
    elseif type == UIGuildGlobal.GuildApplyType.OnlyInvite then
        hint = TableData.GetHintById(60028)
    end

    if level and level > 0 then
        local levelHint = TableData.GetHintById(60029)
        if hint then
            hint = hint .. "," .. string_format(levelHint, level)
        else
            hint = string_format(levelHint, level)
        end
    end
    return hint
end

function UIGuildGlobal:GetTitleType(type)
    local hint = 0
    if type == UIGuildGlobal.GuildTitleType.TitleNone then
        hint = ""
        return hint
    elseif type == UIGuildGlobal.GuildTitleType.Leader then
        hint = 60041
    elseif type == UIGuildGlobal.GuildTitleType.SubLeader then
        hint = 60042
    elseif type == UIGuildGlobal.GuildTitleType.Normal then
        hint = 60043
    end

    return TableData.GetHintById(hint)
end

function UIGuildGlobal:GetMemberNum(level, count)
    if level and level > 0 then
        local tableData = TableData.listGuildLevelDatas:GetDataById(level)
        return string_format(UIGuildGlobal.LevelStringTemp, count, tableData.member_limit)
    end
end

function UIGuildGlobal:GetApplyResult(type)
    local hint = 0   -- hint id
    if type == UIGuildGlobal.GuildApproveRes.Accept then  -- Success
        hint = 60044
    elseif type == UIGuildGlobal.GuildApproveRes.Reject then  -- Reject
        hint = 60045
    elseif type == UIGuildGlobal.GuildApproveRes.TimeNotArrived then  -- TimeNotArrived
        hint = 60035
    elseif type == UIGuildGlobal.GuildApproveRes.NoAccess then  -- NoAccess
        hint = 0
    elseif type == UIGuildGlobal.GuildApproveRes.Passed then  -- Passed
        hint = 0
    elseif type == UIGuildGlobal.GuildApproveRes.OtherGuild then  -- OtherGuild
        hint = 60036
    elseif type == UIGuildGlobal.GuildApproveRes.GuildFull then  -- GuildFull
        hint = 60034
    elseif type == UIGuildGlobal.GuildApproveRes.GuildDismiss then  -- GuildDismiss
        hint = 60037
    end
    return TableData.GetHintById(hint)
end

function UIGuildGlobal:GetItemLockHint(level)
    local chHint = ""
    local enHint = ""
    local hint = TableData.GetHintById(60030)
    chHint = string_format(hint, level)
    enHint = string_format(UIGuildGlobal.EnLockHint, level)
    return chHint, enHint
end

--- p1 操作者   p2 被操作者
function UIGuildGlobal:CanOperation(p1, p2)
    if p1 == nil or p2 == nil then
        return false
    end
    return p1 < p2
end

function UIGuildGlobal:IsManager(title)
    if title == UIGuildGlobal.GuildTitleType.SubLeader or title == UIGuildGlobal.GuildTitleType.Leader then
        return true
    end
    return false
end

function UIGuildGlobal:GetTimeText(td)
    local hour = td.dd > 0 and td.hh + 24 * td.dd or td.hh
    return string_format(UIGuildGlobal.TimeStringTemp,
            hour < 10 and "0" .. hour or hour,
            td.mm < 10 and "0" .. td.mm or td.mm,
            td.ss < 10 and "0" .. td.ss or td.ss)
end

function UIGuildGlobal:FormatDiffUnixTime2Tb(diffUnixTime)
    if diffUnixTime and diffUnixTime >= 0 then
        local tb = {}
        tb.dd = math.floor(diffUnixTime / 60 / 60 / 24)
        tb.hh = math.floor(diffUnixTime / 3600) % 24
        tb.mm = math.floor(diffUnixTime / 60) % 60
        tb.ss = math.floor(diffUnixTime % 60)
        return tb
    end
end

function UIGuildGlobal:PopupHintMessage(hintId)
    local hint = TableData.GetHintById(hintId)
    if hint == nil then
        hint = ""
    end
    CS.PopupMessageManager.PopupString(hint)
end

function UIGuildGlobal:GetTitleColor(title)
    if title == UIGuildGlobal.GuildTitleType.Leader then
        return UIGuildGlobal.OrangeColor
    elseif title == UIGuildGlobal.GuildTitleType.SubLeader then
        return UIGuildGlobal.GreenColor
    end
end
