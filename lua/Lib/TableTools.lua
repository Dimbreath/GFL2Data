---
--- Created by InvsGhost.
--- DateTime: 2017/12/28 11:28
---

---      Config

---      Init
TableTools={}

---      Interfaces
function TableTools.FindInTable(key,Table)
    for i =1,#Table do
        if key == Table[i] then
            return i
        end
    end
    return nil
end

function TableTools.ReverseList(Table)
    local x={}
    local length = #Table
    for i=1,length do
        x[i]=Table[length-i+1]
    end
    return x
end

function TableTools.ShuffleList(Table)
    local ReadyList=Table
    local ResList={}
    for i=1,#Table do
        local p=math.random(#ReadyList)
        table.insert(ResList,ReadyList[p])
        table.remove(ReadyList,p)
    end
    return ResList
end

function TableTools.CreateEnum(tbl)
    local Enum  = {}
    for i = 1, #tbl do
        local key = tbl[i]
        Enum[key] = i
    end
    return Enum
end

function TableTools.GetEnumKey(Enum, value)
    for key, v in pairs(Enum) do
        if v == value then
            return key
        end
    end
    return nil
end

function TableTools.Split(s, sp)
    local res = {}

    if not s then return res end
    local temp = s
    local len = 0
    while true do
        len = string.find(temp, sp)
        if len ~= nil then
            local result = string.sub(temp, 1, len-1)
            temp = string.sub(temp, len+1)
            table.insert(res, result)
        else
            table.insert(res, temp)
            break
        end
    end

    return res
end
---      Procedure