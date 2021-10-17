--- 一些常用配置的配置

GlobalConfig = {}

--- ID类
GlobalConfig.StaminaId    = 101     --- 体力ID
GlobalConfig.PVPTicketId  = 102     --- pvp门票
GlobalConfig.DiamondId    = 1
GlobalConfig.CoinId       = 2
GlobalConfig.MaxStaminaId = 6
GlobalConfig.TrainingTicket = 9

--- 常量定义
GlobalConfig.MaxChallenge = 3
GlobalConfig.MaxStar = 6
GlobalConfig.GunMaxStar = 5
GlobalConfig.MaxEquipCount = 3
--无人机突破所用材料
GlobalConfig.UavBreakMatNum=1
--通过Content形式加载的UI界面sortingOrder设置为5，由UI组确定
GlobalConfig.ContentPrefabOrder=5

GlobalConfig.IsOpenStagePanelByJumpUI=false
--- 文本定义
GlobalConfig.LVText = "Lv."

--- 物品类型
GlobalConfig.ItemType =
{
    Resource      = 1,
    GunType       = 4,
    EquipmentType = 5,
    StaminaType   = 6,
    Weapon        = 8,
    GunCore       = 12,
    Packages      = 13,
    EquipPackages = 16,
    WeaponPart    = 17
}

--- RecordFlag
GlobalConfig.RecordFlag =
{
    NotFirstGacha = 0,
    NameModified  = 1,
}

--- StoryType
GlobalConfig.StoryType =
{
    Normal = 1,
    Story  = 2,
    Hide   = 3,
    Hard   = 4,
    Branch = 11,
}

--- SortHintCfg
GlobalConfig.SortType =
{
    Level     = 1,
    Rank      = 2,
    Time      = 3,
    Prop      = 4,
    Quality   = 5,
}


function GlobalConfig.GetCostHintStr(costNum)
    if costNum then
        return string_format(TableData.GetHintById(804), costNum)
    end
end

function GlobalConfig.GetCostNotEnoughStr(itemId)
    if itemId then
        local itemData = TableData.listItemDatas:GetDataById(itemId)
        if itemData then
            local hint = string_format(TableData.GetHintById(225), itemData.name.str)
            return hint
        end
    end
    return ""
end