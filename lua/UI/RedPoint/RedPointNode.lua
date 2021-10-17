RedPointNode = class("RedPointNode")
RedPointNode.__index = RedPointNode

function RedPointNode:ctor()
    self.nodeName = nil
    self.fullName = nil
    self.pointNum = 0
    self.parent = nil
    self.onNumChangeCallback = nil
    self.objRedPoint = nil
    self.txtRedNum = nil
    self.dicChild = {}
    self.systemId = nil
end

function RedPointNode:SetRedPointObj(obj)
    if obj then
        local isUnlock = true
        if self.systemId then
            isUnlock = AccountNetCmdHandler:CheckSystemIsUnLock(self.systemId)
        end
        self.objRedPoint = obj.gameObject
        setactive(self.objRedPoint, self.pointNum > 0 and isUnlock)
    end
end

function RedPointNode:SetRedPointNum(rpNum)
    if #self.dicChild > 0 then
        return
    end
    self.pointNum = rpNum
    self:NotifyPointNumChange()
    if self.parent ~= nil then
        self.parent:ChangePreRedPointNum()
    end
end

function RedPointNode:ChangePreRedPointNum()
    local num = 0
    for _, value in pairs(self.dicChild) do
        num = value.pointNum + num
    end

    self.pointNum = num
    self:NotifyPointNumChange()
    if self.parent ~= nil then
        self.parent:ChangePreRedPointNum()
    end
end

function RedPointNode:NotifyPointNumChange()
    if self.objRedPoint then
        local isUnlock = true
        if self.systemId then
            isUnlock = AccountNetCmdHandler:CheckSystemIsUnLock(self.systemId)
        end
        setactive(self.objRedPoint, self.pointNum > 0 and isUnlock)
    end
    if self.onNumChangeCallback ~= nil then
        self.onNumChangeCallback(self)
    end
end

function RedPointNode:GetRedPointNum()
    return self.pointNum
end
