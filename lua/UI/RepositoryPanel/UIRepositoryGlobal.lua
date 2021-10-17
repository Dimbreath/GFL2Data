UIRepositoryGlobal = {}

UIRepositoryGlobal.PanelType =
{
    ItemPanel = 1,
    EquipOverViewPanel = 2,
    WeaponPanel = 3,
    GunCore = 4,
    EquipPanel = 5,
}

UIRepositoryGlobal.TabType =
{
    Item = 1,
    Equip = 2,
    Weapon = 3,
    GunCore = 4,
}

UIRepositoryGlobal.SortType =
{
    Rank = 1,
    Level = 2,
    Id = 3
}

UIRepositoryGlobal.FiltrateType =
{
    Two = 2,
    Three = 3,
    Four = 4
}

UIRepositoryGlobal.TAB_CFG =
{
    {"rank", "level", "stcId", "id"},
    {"level", "rank", "stcId", "id"},
    {"id"},
}

UIRepositoryGlobal.EQUIP_SORT_CFG =
{
    {"rank", "level", "stcId", "id"},
    {"level", "rank", "stcId", "id"},
    {"id"},
}

UIRepositoryGlobal.WEAPON_SORT_CFG =
{
    {"Rank", "Level", "stc_id", "id"},
    {"Level", "Rank", "stc_id", "id"},
    {"id"},
}

UIRepositoryGlobal.GUNCORE_SORT_CFG =
{
    {"id"},
}

UIRepositoryGlobal.SystemIdList =
{
    0,
    CS.GF2.Data.SystemList.StorageEquip:GetHashCode(),
    CS.GF2.Data.SystemList.StorageWeapon:GetHashCode(),
    CS.GF2.Data.SystemList.StorageCore:GetHashCode()
}

UIRepositoryGlobal.CurrentCountText = "<color=#EE590F><size=38>{0}</size></color>/{1}"
UIRepositoryGlobal.DisassembleCountText = "<size=38>{0}</size>/{1}"

function UIRepositoryGlobal:GetSimpleWeaponData(weaponData)
    local data = {}
    data.id = weaponData.id
    data.stcId = weaponData.stc_id
    data.icon = weaponData.ResCode
    data.level = weaponData.Level
    data.rank = weaponData.Rank
    data.isEquip = weaponData.IsEquipped
    data.gunId = weaponData.gun_id
    data.isLock = weaponData.IsLocked
    data.soldItem = self:GetSoldOutItem(weaponData.StcData.sold_get)
    data.isChoose = false
    return data
end

function UIRepositoryGlobal:GetSimpleEquipData(equipData)
    local data = {}
    data.id = equipData.id
    data.stcId = equipData.stcId
    data.icon = equipData.TableData.res_code
    data.level = equipData.level
    data.rank = equipData.rank
    data.isEquip = equipData.IsEquipped
    data.gunId = equipData.gun_id
    data.isLock = equipData.locked
    data.category = equipData.category
    data.soldItem = self:GetSoldOutItem(equipData.TableData.sold_get)
    data.isChoose = false
    return data
end

function UIRepositoryGlobal:GetSoldOutItem(sold_get)
    local itemList = {}
    if sold_get then
        for itemId, itemCount in pairs(sold_get) do
            local item = {}
            item.id = itemId
            item.count = itemCount
            table.insert(itemList, item)
        end
    end
    return itemList
end

function UIRepositoryGlobal:IsHighRank(rank)
    return rank >= 5 or rank == 1
end

function UIRepositoryGlobal:GetRepositorySystemId(tabIndex)
    if tabIndex == UIRepositoryGlobal.TabType.Equip then
        return CS.GF2.Data.SystemList.StorageWeapon
    elseif tabIndex == UIRepositoryGlobal.TabType.Weapon then
        return CS.GF2.Data.SystemList.StorageEquip
    end
end

--- isAscend 是否升序
function UIRepositoryGlobal:GetSortFunction(tabIndex ,startIndex ,isAscend)
    isAscend = isAscend ~= false and true or false
    local tArrRefer   = UIRepositoryGlobal.TAB_CFG[tabIndex]
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


function UIRepositoryGlobal:GetWeaponSortFunction(tabIndex ,startIndex ,isAscend)
    isAscend = isAscend ~= false and true or false
    local tArrRefer   = UIRepositoryGlobal.WEAPON_SORT_CFG[tabIndex]
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

function UIRepositoryGlobal:GetEquipSortFunction(tabIndex ,startIndex ,isAscend)
    isAscend = isAscend ~= false and true or false
    local tArrRefer   = UIRepositoryGlobal.EQUIP_SORT_CFG[tabIndex]
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