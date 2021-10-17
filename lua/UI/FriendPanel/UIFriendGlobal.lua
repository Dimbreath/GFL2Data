UIFriendGlobal = {}

UIFriendGlobal.PanelTag =
{
    FriendList = 1,
    ApplyFriend = 2,
    AddFriend = 3,
}

UIFriendGlobal.PanelTopTab =
{
    UIFriendGlobal.PanelTag.FriendList,
    UIFriendGlobal.PanelTag.ApplyFriend,
    UIFriendGlobal.PanelTag.AddFriend
}

UIFriendGlobal.FriendListSortType =
{
    OnlineTime = 1,
    RelationshipTime = 2,
    Level = 3,
    GunLevel = 4,
    GunProp = 5,
}

UIFriendGlobal.FriendListSortCfg =
{
    {"IsOnlineUint", "GetOnlineOrOfflineTime", "UID"},
    {"ID"},
    {"Level", "UID"},
    {"GunLevel", "GunRank", "GunProp", "UID"},
    {"GunProp", "GunLevel", "GunRank", "UID"},
}

UIFriendGlobal.StringLength = 10
UIFriendGlobal.TagIconPath = "BtnFunction"
UIFriendGlobal.OnlineColor = ColorUtils.StringToColor("60BF8A")
UIFriendGlobal.OfflineColor = ColorUtils.StringToColor("333333")

UIFriendGlobal.FriendListTextMaxWidth = 0
UIFriendGlobal.ApplyListTextMaxWidth = 0
UIFriendGlobal.AddListTextMaxWidth = 0

function UIFriendGlobal:GetTagNameById(tagId)
    local hintId = 0
    if tagId == UIFriendGlobal.PanelTag.FriendList then
        hintId = 100010
    elseif tagId == UIFriendGlobal.PanelTag.ApplyFriend then
        hintId = 100011
    elseif tagId == UIFriendGlobal.PanelTag.AddFriend then
        hintId = 100012
    end

    return TableData.GetHintById(hintId)
end

function UIFriendGlobal:GetTagIconById(tagId)
    local spriteName = ""
    if tagId == UIFriendGlobal.PanelTag.FriendList then
        spriteName = "Icon_Btn_FriendList"
    elseif tagId == UIFriendGlobal.PanelTag.ApplyFriend then
        spriteName = "Icon_Btn_FriendApply"
    elseif tagId == UIFriendGlobal.PanelTag.AddFriend then
        spriteName ="Icon_Btn_FriendAdd"
    end

    return IconUtils.GetIconV2(UIFriendGlobal.TagIconPath, spriteName)
end

function UIFriendGlobal.OnGetApproveResult(msg)
    local result = msg.Content
    local hint = nil
    if result == 0 then
        hint = 100042
        UIUtils.PopupPositiveHintMessage(hint)
    elseif result == 1 then
        hint = 100043
        UIUtils.PopupPositiveHintMessage(hint)
    elseif result == 2 then
        hint = 100044
        UIUtils.PopupHintMessage(hint)
    elseif result == 3 then
        hint = 100045
        UIUtils.PopupHintMessage(hint)
    else
        hint = 60022
        UIUtils.PopupHintMessage(hint)
    end
end

function UIFriendGlobal:GetTextMaxWidth(parent, buttonCount)
    local parentWidth = parent.rect.width
    return parentWidth - 80 - 96 - 328 - ((70 + (buttonCount - 1) * 16) * buttonCount) - 52 - 14 * 3
end

function UIFriendGlobal:GetTextMaxWidthByType(type)
    if type == UIFriendGlobal.PanelTag.FriendList  then
        return UIFriendGlobal.FriendListTextMaxWidth
    elseif type == UIFriendGlobal.PanelTag.ApplyFriend then
        return UIFriendGlobal.ApplyListTextMaxWidth
    elseif type == UIFriendGlobal.PanelTag.AddFriend then
        return UIFriendGlobal.AddListTextMaxWidth
    end
end