CommonLvUpData = class("CommonLvUpData")
CommonLvUpData.__index = CommonLvUpData

function CommonLvUpData:ctor(fromLv, toLv, titleHint)
    self.fromLv = fromLv
    self.toLv = toLv
    self.breakLevel = nil
    self.attrList = {}
    self.titleHint = titleHint == nil and 102102 or titleHint
end

function CommonLvUpData:SetGunLvUpData(attrList)
    if attrList then
        for _, attr in ipairs(attrList) do
            if attr.mData and attr.upValue > 0 and attr.upValue ~= attr.value then
                local attrData = {}
                attrData.data = attr.mData
                attrData.value = attr.value
                attrData.upValue = attr.upValue
                attrData.isNew = false

                table.insert(self.attrList, attrData)
            end
        end
    end
end

function CommonLvUpData:SetWeaponLvUpData(attrList, breakLevel)
    self.breakLevel = breakLevel
    if attrList then
        for _, attr in ipairs(attrList) do
            if attr.mData and attr.upValue > 0 and attr.upValue ~= attr.value then
                local attrData = {}
                attrData.data = attr.mData
                attrData.value = attr.value
                attrData.upValue = attr.upValue
                attrData.isNew = false

                table.insert(self.attrList, attrData)
            end
        end
    end
end

function CommonLvUpData:SetEquipLvUpData(mainAttr, beforeAttrList, afterAttrList)
    if mainAttr then
        local attrData = {}
        attrData.data = mainAttr.mData
        attrData.value = mainAttr.value
        attrData.upValue = mainAttr.upValue
        attrData.isNew = false

        table.insert(self.attrList, attrData)
    end

    for i, prop in ipairs(afterAttrList) do
        if prop.mData then
            local beforeData = self:GetAttrById(prop.mData.id, beforeAttrList)
            if beforeData == nil then    --- 新属性
                local attrData = {}
                attrData.data = prop.mData
                attrData.value = prop.value
                attrData.upValue = 0
                attrData.isNew = true

                table.insert(self.attrList, attrData)
            else                          --- 旧属性
                if prop.value - beforeData.value > 0 then
                    local attrData = {}
                    attrData.data = prop.mData
                    attrData.value = beforeData.value
                    attrData.upValue = prop.value
                    attrData.isNew = false

                    table.insert(self.attrList, attrData)
                end
            end
        end

    end
end

function CommonLvUpData:SetWeaponPartLvUpData(attr, upValue)
    if attr then
        if attr.mData and upValue > 0 and upValue ~= attr.value then
            local attrData = {}
            attrData.data = attr.mData
            attrData.value = attr.value
            attrData.upValue = upValue
            attrData.isNew = false

            table.insert(self.attrList, attrData)
        end
    end
end

function CommonLvUpData:GetAttrById(id, attrList)
    for i, prop in ipairs(attrList) do
        if prop.mData and prop.mData.id == id then
            return prop
        end
    end
    return nil
end
