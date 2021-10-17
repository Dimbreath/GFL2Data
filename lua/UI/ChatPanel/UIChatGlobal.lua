UIChatGlobal = {}
UIChatGlobal.MaxWidth = 0
UIChatGlobal.MaxNameWidth = 0

UIChatGlobal.ChatType =
{
    System = 1,
    World = 2,
    Friend = 3,
}

UIChatGlobal.SystemType =
{
    Gun = 1,
    Weapon = 2,
    Upgrade = 3,
    Mental = 4,
    WeaponLv = 5,
    EquipLv = 6,
}

UIChatGlobal.PlayerOperation =
{
    Delete = 1,
    BlackList = 2,
    Report = 3,
}

UIChatGlobal.SystemIdList = {SystemList.ChatChannelSystem, SystemList.ChatChannelWorld}


function UIChatGlobal:CalculateMaxWidth(width)
    if UIChatGlobal.MaxWidth <= 0 then
        local width = width - 24 - 35 -82 - 82 - 13 - 17
        UIChatGlobal.MaxWidth = width
        return width
    end
    return UIChatGlobal.MaxWidth
end

function UIChatGlobal.CalculateNameMaxWidth(width)
    if UIChatGlobal.MaxNameWidth <= 0 then
        local width = math.floor(width) - 82 -8
        UIChatGlobal.MaxNameWidth = width
        return width
    end
    return UIChatGlobal.MaxNameWidth
end