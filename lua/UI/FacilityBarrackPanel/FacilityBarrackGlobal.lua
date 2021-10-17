FacilityBarrackGlobal = {}

FacilityBarrackGlobal.MaxMentalNode = 4
FacilityBarrackGlobal.UnLockRichText = "{0}<size=32>/{1}</size>"
FacilityBarrackGlobal.ItemCountRichText = "<color=#333333>{0}</color>/{1}"
FacilityBarrackGlobal.ItemCountNotEnoughText = "<color=#FF5E41>{0}</color>/{1}"
FacilityBarrackGlobal.RomaIconPrefix = "Img_Mental_number_"
FacilityBarrackGlobal.E3DModelType = gfenum({"eUnkown", "eGun", "eWeapon", "eEffect", "eVechicle"},-1)

FacilityBarrackGlobal.UIModel = nil
FacilityBarrackGlobal.SortTypeName = "SortType"

FacilityBarrackGlobal.GunSortType =
{
    Level = 1,
    Rank = 2,
    Time = 3,
    Fight = 4
}

FacilityBarrackGlobal.GunSortCfg =
{
    {"level", "rank", "id"},
    {"rank", "level", "id"},
    {"uuid", "id"},
    {"fightingCapacity", "rank", "level", "id"}
}

FacilityBarrackGlobal.PowerUpName =
{
    "LevelUp",
    "Mental",
    "Equip",
    "Weapon",
    "Upgrade",
}

FacilityBarrackGlobal.PowerUpType =
{
    LevelUp = 1,
    Mental = 2,
    Equip = 3,
    Weapon = 4,
    Upgrade = 5,
}

FacilityBarrackGlobal.SystemList =
{
    LevelUp = 1,
    Upgrade = 2,
    Mental = 4,
    Weapon = 32,
    Equip = 16,
}

FacilityBarrackGlobal.ShowAttribute =
{
    "pow",
    "max_hp",
    "physical_shield",
    "magical_shield"
}

FacilityBarrackGlobal.ShowSKillAttr =
{
    "potential_total_value",
    "potential_cost",
    "cd_time",
    "skill_points"
}

FacilityBarrackGlobal.PressType =
{
    Plus = 1,
    Minus = 2,
}

FacilityBarrackGlobal.MentalUpgradeType =
{
    NodeUpgrade = 1,
    RankBreak = 2,
    RankMax = 3
}

FacilityBarrackGlobal.SortHint = {101001, 101002, 101003, 101007}

FacilityBarrackGlobal.SortType =
{
    sortType = FacilityBarrackGlobal.GunSortType.Time,
    isAscend = true,
}

function FacilityBarrackGlobal:GetLockGunData(id)
    local gun = {}
    local gunData = NetCmdTeamData:GetLockGunData(id)
    gun.id = id
    gun.uuid = GFUtils.GetLongMaxValue()
    gun.level = 0
    gun.rank = gunData.rank
    gun.fightingCapacity = gunData.fightingCapacity

    return gun
end

function FacilityBarrackGlobal:GetGunMaxLevel(rankNum)
    local level = 0
    if rankNum then
        level = TableData.GlobalSystemData.MentalRankLevellimit[rankNum]
    end
    return level
end

function FacilityBarrackGlobal:GetPressParam()
    local data = string.split(TableData.GlobalConfigData.GunLevelUpItemAddSpeed, ":")
    return tonumber(data[1]), tonumber(data[2])
end

function FacilityBarrackGlobal:IsMainProp(str)
    for _, prop in ipairs(FacilityBarrackGlobal.ShowAttribute) do
        if prop == str then
            return true
        end
    end
    return false
end

function FacilityBarrackGlobal:GetSystemIsUnlock(data, index)
    if data then
        local pram = data & index
        return not (pram == 0)
    end
end

function FacilityBarrackGlobal:SetSortType(sortType)
    if sortType then
        FacilityBarrackGlobal.SortType.sortType = sortType.sortType
        FacilityBarrackGlobal.SortType.isAscend = sortType.isAscend
    end
end

function FacilityBarrackGlobal:SaveSortType()
    local sortType = tostring(FacilityBarrackGlobal.SortType.sortType)
    local isAscend = tostring(FacilityBarrackGlobal.SortType.isAscend and 1 or 0)
    local str = sortType .. "," .. isAscend

    CS.GameSettingConfig.SetString(FacilityBarrackGlobal.SortTypeName, str)
end

function FacilityBarrackGlobal:ParseSortType()
    local str = CS.GameSettingConfig.GetString(FacilityBarrackGlobal.SortTypeName)
    if str ~= "" then
        local strArr = string.split(str, ",")
        FacilityBarrackGlobal.SortType.sortType = tonumber(strArr[1])
        FacilityBarrackGlobal.SortType.isAscend = tonumber(strArr[2]) == 1 and true or false
    end
end

function FacilityBarrackGlobal:GetSortFunc(startIndex ,sortCfg, isAscend)
    isAscend = isAscend ~= false and true or false
    local tArrRefer   = sortCfg
    local tLength     = #tArrRefer
    --无需组排序或者参数有误
    if tLength == 0 or startIndex < 1 or startIndex > tLength then
        return nil
    end
    local function compareFunction(a1, a2, index)
        if index <= tLength then
            local attrName = tArrRefer[index]
            if index <= tLength then
                if a1[attrName] < a2[attrName] then
                    return isAscend
                elseif a1[attrName] > a2[attrName] then
                    return not isAscend
                else
                    return compareFunction(a1, a2, index + 1)
                end
            else
                return false
            end
        end
        return false
    end
    return function (a1, a2)
        return compareFunction(a1, a2, startIndex)
    end
end