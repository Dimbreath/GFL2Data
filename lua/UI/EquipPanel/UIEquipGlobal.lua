UIEquipGlobal = {}

UIEquipGlobal.MaxStar = 6
UIEquipGlobal.MaxMaterialCount = 5
UIEquipGlobal.EquipEnhanceLvRichText = "<color=#F16B1C><size=36>{0}</size></color>/{1}"
UIEquipGlobal.EquipLvRichText = "Lv.{0}/{1}"
UIEquipGlobal.EquipListPanelPrefab = "Character/ChrEquipPowerUpListPanelV2.prefab"

UIEquipGlobal.SortType =
{
    Level = 1,
    Rank = 2,
    Time = 3,
}

UIEquipGlobal.SortCfg =
{
    {"level", "rank", "stcId", "id"},
    {"rank", "level", "stcId", "id"},
    {"id"},
}

UIEquipGlobal.FiltrateType =
{
    Position = 1,
    Suit = 2,
}

UIEquipGlobal.MaterialType =
{
    Item = 1,
    Equip = 2,
}

UIEquipGlobal.EquipPanelTab =
{
    Info = 1,
    Enhance = 2,
}

UIEquipGlobal.EquipTabSort = {UIEquipGlobal.EquipPanelTab.Info, UIEquipGlobal.EquipPanelTab.Enhance}
UIEquipGlobal.EquipTabHint = {102016, 102006}

function UIEquipGlobal:GetMaterialSimpleData(data, type, index)
    if data then
        local item = {}
        item.type = type
        if item.type == UIEquipGlobal.MaterialType.Item then
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
        elseif item.type == UIEquipGlobal.MaterialType.Equip then
            item.id = data.id
            item.gunId = data.gun_id
            item.isLock = data.locked
            item.stcId = data.stcId
            item.level = data.level
            item.icon = data.icon
            item.rank = data.rank
            item.setId = data.setId
            item.category = data.category
            item.offerExp = data:GetEquipOfferExp()
            item.costCoin = data:GetCostCash()
            item.isEquipped = data.gun_id == 0 and 0 or 1
            item.count = 1
        end
        item.selectCount = 0
        return item
    end
    return nil
end

function UIEquipGlobal:GetEquipAngle(index)
    return Vector3(0, 0, -(index - 1) * (360 / GlobalConfig.MaxEquipCount))
end

function UIEquipGlobal:GetEquipSetList()
    local list = {}
    local setList = TableData.listEquipSetDatas
    for i = 0, setList.Count - 1 do
        table.insert(list, setList[i])
    end
    return list
end