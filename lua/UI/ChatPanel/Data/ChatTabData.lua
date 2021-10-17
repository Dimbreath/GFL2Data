ChatTabData = class("ChatTabData")
ChatTabData.__index = ChatTabData

function ChatTabData:ctor(type, friendData)
    self.type = type
    if friendData then
        self.uid = friendData.UID
    else
        self.uid = 0
    end
    self.friendData = friendData
    self.isSelect = false
    self.item = nil
    self.index = -1
    self.systemId = 0
end

function ChatTabData:SetItem(item)
    self.item = item
end

function ChatTabData:SetSelect(isSelect)
    self.isSelect = isSelect
    if self.item then
        self.item.mBtn_Tab.interactable = not isSelect
    end
end

function ChatTabData:SetIndex(index)
    self.index = index
end

function ChatTabData:SetSystemId(systemId)
    self.systemId = systemId
end

function ChatTabData:RefreshFriendData(friendData)
    self.friendData = friendData
    self.uid = friendData == nil and 0 or friendData.UID
end