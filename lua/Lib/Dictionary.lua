--region *.lua
--Date

Dictionary = {}
Dictionary.__index = Dictionary
 
function Dictionary:New(tk, tv)
    local o = {keyType = tk, valueType = tv}
    setmetatable(o, self)
    o.keyList = {}
    return o
end
 
function Dictionary:Add(key, value)
    if self[key] == nil then
        self[key] = value
        table.insert(self.keyList, key)
    else
        self[key] = value
    end
end
 
function Dictionary:Clear()
    local count = self:Count();
    for i=count,1,-1 do
        self[self.keyList[i]] = nil
        table.remove(self.keyList)
    end
end
 
function Dictionary:ContainsKey(key)
    local count = self:Count();
    for i=1,count do
        if self.keyList[i] == key then
            return true
        end
    end
    return false
end
 
function Dictionary:ContainsValue(value)
    local count = self:Count();
    for i=1,count do
        if self[self.keyList[i]] == value then
            return true
        end
    end
    return false
end


function Dictionary:GetValueByIndex(index)
    local count = self:Count();
    return self.keyList[iindex];
end


function Dictionary:Count()
    return #self.keyList;
end
 
function Dictionary:Iter()
    local i = 0
    local n = self:Count()
    return function ()
        i = i + 1
        if i <= n then
            return self.keyList[i]
        end
        return nil
    end
end
 
function Dictionary:Remove(key)
    if self:ContainsKey(key) then
        local count = self:Count()
        for i=1,count do
            if self.keyList[i] == key then
                table.remove(self.keyList, i)
                break
            end
        end
        self[key] = nil
    end
end
 
function Dictionary:KeyType()
    return self.keyType
end
 
function Dictionary:ValueType()
    return self.valueType
end
--endregion
