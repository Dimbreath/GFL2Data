--region *.lua
--Date

List = {}
List.__index = List
 
function List:New(t)
    local o = {itemType = t}
    setmetatable(o, self)
    return o
end
 
function List:Add(item)
    table.insert(self, item)
end
 
function List:Clear()
    local count = self:Count()
    for i=count,1,-1 do
        table.remove(self)
    end
end
 
function List:Contains(item)
    local count = self:Count()
    for i=1,count do
        if self[i] == item then
            return true
        end
    end
    return false
end

function List:Count()
    return #self
end

function List:Find(predicate)
    if (predicate == nil or type(predicate) ~= 'function') then
        print('predicate is invalid!')
        return
    end
    local count = self:Count()
    for i=1,count do
        if predicate(self[i]) then 
            return self[i] 
        end
    end
    return nil
end
 
function List:ForEach(action)
    if (action == nil or type(action) ~= 'function') then
        print('action is invalid!')
        return
    end
    local count = self:Count()
    for i=1,count do
        action(self[i])
    end
end
 
function List:IndexOf(item)
    local count = self:Count()
    for i=1,count do
        if self[i] == item then
            return i
        end
    end
    return 0
end
 
function List:LastIndexOf(item)
    local count = self:Count()
    for i=count,1,-1 do
        if self[i] == item then
            return i
        end
    end
    return 0
end
 
function List:Insert(index, item)
    table.insert(self, index, item)
end
 
function List:ItemType()
    return self.itemType
end
 
function List:Remove(item)
    local idx = self:LastIndexOf(item)
    if (idx > 0) then
        table.remove(self, idx)
        self:Remove(item)
    end
end
 
function List:RemoveAt(index)
    table.remove(self, index)
end
 
function List:Sort(comparison)
    gfwarning("sort begin!")
    if (comparison ~= nil and type(comparison) ~= 'function') then
        print('comparison is invalid')
        return
    end
    if comparison == nil then
        gfwarning("sort by default!")
        table.sort(self)
    else
        gfwarning("sort by func")
        table.sort(self, comparison)
    end
end

--endregion
