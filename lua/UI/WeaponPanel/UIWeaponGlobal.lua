UIWeaponGlobal = {}

UIWeaponGlobal.WeaponLvRichText = "<size=56>{0}</size>/{1}"
UIWeaponGlobal.WeaponLvRichText2 = "Lv.{0}/{1}"
UIWeaponGlobal.WeaponEnhanceLvRichText = "<color=#ed6015><size=84>{0}</size></color>/{1}"
UIWeaponGlobal.MaxStar = 5
UIWeaponGlobal.MaxMaterialCount = 5
UIWeaponGlobal.WeaponMaxSlot = 4
UIWeaponGlobal.MaxBreakCount = 1

UIWeaponGlobal.WeaponModel = nil

UIWeaponGlobal.ReplaceSortType =
{
    Level = 1,
    Rank = 2,
    Time = 3,
    Element = 4,
}

UIWeaponGlobal.MaterialSortType =
{
    Level = 1,
    Rank = 2,
    Time = 3,
}

UIWeaponGlobal.ReplaceSortCfg =
{
    {"level", "rank", "element", "stcId", "id"},
    {"rank", "level", "element", "stcId", "id"},
    {"id"},
    {"element", "rank", "level", "stcId", "id"},
}

UIWeaponGlobal.WeaponPartsSortCfg =
{
    {"affixLevel", "rank", "attributeOrder", "stcId", "id"},
    {"rank", "affixLevel", "attributeOrder", "stcId", "id"},
    {"id"},
    {"attributeOrder", "rank", "affixLevel", "stcId", "id"},
}

UIWeaponGlobal.MaterialSortCfg =
{
    {"level", "rank", "stcId", "id"},
    {"rank", "level", "stcId", "id"},
    {"id"},
}


UIWeaponGlobal.SkillType =
{
    NormalSkill = 1,
    BuffSkill = 2
}

UIWeaponGlobal.ContentType =
{
    Info = 1,
    Replace = 2,
    Enhance = 3
}

UIWeaponGlobal.MaterialType =
{
    Item = 1,
    Weapon =  2
}

UIWeaponGlobal.WeaponPanelTab =
{
    Info = 1,
    Enhance = 2,
    WeaponPart = 3,
}

UIWeaponGlobal.WeaponPartPanelTab =
{
    Info = 1,
    Enhance = 2,
}


UIWeaponGlobal.SystemIdList =
{
    0,
    0,
    SystemList.GundetailWeaponpart,
}


UIWeaponGlobal.WeaponTabHint = {102016, 102006, 40026}
UIWeaponGlobal.WeaponPartTabHint = {102016, 40027}

function UIWeaponGlobal:GetWeaponSimpleData(data)
    if data then
        local weapon = {}
        weapon.id = data.id
        weapon.stcId = data.stc_id
        weapon.level = data.Level
        weapon.icon = data.ResCode
        weapon.rank = data.Rank
        weapon.maxLevel = data.CurMaxLv
        weapon.element = data.Element
        weapon.isLock = data.IsLocked
        weapon.slotList = data.slotList
        weapon.partList = data.partList
        weapon.gunId = data.gun_id
        weapon.breakTimes = data.BreakTimes
        weapon.isSelect = false
        weapon.stcData = data.StcData

        return weapon
    end
    return nil
end

function UIWeaponGlobal:GetWeaponPartSimpleData(data)
    if data then
        local part = {}
        part.id = data.id
        part.stcId = data.stcId
        part.name = data.name
        part.affixSkill = data.affixSkill
        part.affixLevel = data.affixLevel
        part.attributeOrder = data.attributeOrder
        part.icon = data.icon
        part.rank = data.rank
        part.type = data.type
        part.weaponId = data.equipWeapon
        part.isLock = data.IsLocked
        part.isMaxLv = not data.isCanLevelUp
        part.isCanCalibration = data.isCanCalibration
        part.isSelect = false

        return part
    end
    return nil
end

function UIWeaponGlobal:GetMaterialSimpleData(data, type)
    if data then
        local item = {}
        item.type = type
        if item.type == UIWeaponGlobal.MaterialType.Item then
            local count = NetCmdItemData:GetItemCount(data)
            if count <= 0 then
                return nil
            end
            local itemData = TableData.listItemDatas:GetDataById(data)
            item.id = data
            item.stcId = data
            item.rank = itemData.rank
            item.level = itemData.rank    --- 没有level只是方便统一排序
            item.offerExp = itemData.args[0]
            item.costCoin = itemData.args[1]
            item.count = count
            item.isBreakItem = false
        elseif item.type == UIWeaponGlobal.MaterialType.Weapon then
            item.id = data.id
            item.stcId = data.stc_id
            item.level = data.Level
            item.icon = data.ResCode
            item.rank = data.Rank
            item.offerExp = data:GetWeaponOfferExp()
            item.costCoin = data:GetChipCash()
            item.count = 1
        end
        item.selectCount = 0
        return item
    end
    return nil
end
