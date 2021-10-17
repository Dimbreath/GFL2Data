---@class UIChatPanel : UIBasePanel
UIChatPanel = class("UIChatPanel", UIBasePanel)
UIChatPanel.__index = UIChatPanel

UIChatPanel.uid = nil
UIChatPanel.mView = nil
UIChatPanel.isShowEmoji = false
UIChatPanel.isShowMore = false
UIChatPanel.chatTypeList = {}
UIChatPanel.curTab = nil
UIChatPanel.curFriend = nil
UIChatPanel.emojiList = nil
UIChatPanel.moreList = nil
UIChatPanel.chatItemList = nil
UIChatPanel.worldItemList = nil
UIChatPanel.systemItemList = nil
UIChatPanel.friendList = {}
UIChatPanel.friendDataList = {}
UIChatPanel.curChatData = nil
UIChatPanel.curMessageContent = nil
UIChatPanel.cacheInput = {}
UIChatPanel.maxIndex = 0
UIChatPanel.newMessageCount  = 0
UIChatPanel.worldChatTimer = nil
UIChatPanel.lastSpeakTime = 0
UIChatPanel.needRefreshAni = false
UIChatPanel.isSelfSend = false
UIChatPanel.needShowWorld = true

UIChatPanel.RedPointType = {RedPointConst.Chat}

function UIChatPanel:ctor()
    UIChatPanel.super.ctor(self)
end

function UIChatPanel.Close()
    if UIChatPanel.isShowMore then
        UIChatPanel:OnClickMoreList()
        return
    end
    UIChatPanel.DelayCloseUI()
end

function UIChatPanel.DelayCloseUI()
    UIChatPanel.mView.mAnimator:SetTrigger("Fadeout")
    TimerSys:DelayCall(0.3, function ()
        UIManager.CloseUI(UIDef.UIChatPanel)
    end)
end

function UIChatPanel.OnRelease()
    UIChatPanel.uid = nil
    UIChatPanel.mView = nil
    UIChatPanel.isShowEmoji = false
    UIChatPanel.isShowMore = false
    UIChatPanel.chatTypeList = {}
    UIChatPanel.curTab = nil
    UIChatPanel.curFriend = nil
    UIChatPanel.emojiList = nil
    UIChatPanel.moreList = nil
    UIChatPanel.chatItemList = nil
    UIChatPanel.worldItemList = nil
    UIChatPanel.systemItemList = nil
    UIChatPanel.friendList = {}
    UIChatPanel.friendDataList = {}
    UIChatPanel.curChatData = nil
    UIChatPanel.curMessageContent = nil
    UIChatPanel.cacheInput = {}
    UIChatPanel.maxIndex = 0
    UIChatPanel.newMessageCount  = 0
    UIChatPanel.lastSpeakTime = 0
    UIChatPanel.needRefreshAni = false
    UIChatPanel.isSelfSend = false
    UIChatPanel.needShowWorld = true

    if UIChatPanel.worldChatTimer then
        UIChatPanel.worldChatTimer:Stop()
        UIChatPanel.worldChatTimer = nil
    end

    UIChatGlobal.MaxWidth = 0

    MessageSys:RemoveListener(CS.GF2.Message.ChatEvent.UpdateChatList, UIChatPanel.UpdateMessageList)
    MessageSys:RemoveListener(CS.GF2.Message.ChatEvent.UpdateWorldChatList, UIChatPanel.UpdateWorldMessageList)
    MessageSys:RemoveListener(CS.GF2.Message.ChatEvent.UpdateSystemChatList, UIChatPanel.UpdateSystemMessageList)
    MessageSys:RemoveListener(CS.GF2.Message.ChatEvent.UpdateChatRedPoint, UIChatPanel.UpdateChatRedPoint)
    MessageSys:RemoveListener(CS.GF2.Message.FriendEvent.FriendDel, UIChatPanel.DeleteFriend)
    MessageSys:RemoveListener(CS.GF2.Message.FriendEvent.FriendChangeMark, UIChatPanel.RefreshRoleInfo)
    MessageSys:RemoveListener(CS.GF2.Message.ChatEvent.AddChatChannel, UIChatPanel.AddChatChannel)
end

function UIChatPanel.Init(root, data)
    UIChatPanel.super.SetRoot(UIChatPanel, root)

    self = UIChatPanel
    self.mView = UIChatPanelView.New()
    self.mView:InitCtrl(self.mUIRoot)
    self.mIsPop = true
    self.uid = data[1]
    self.needShowWorld = data[2]
    if self.needShowWorld == nil then
        self.needShowWorld = true
    end

    MessageSys:AddListener(CS.GF2.Message.ChatEvent.UpdateChatList, UIChatPanel.UpdateMessageList)
    MessageSys:AddListener(CS.GF2.Message.ChatEvent.UpdateWorldChatList, UIChatPanel.UpdateWorldMessageList)
    MessageSys:AddListener(CS.GF2.Message.ChatEvent.UpdateSystemChatList, UIChatPanel.UpdateSystemMessageList)
    MessageSys:AddListener(CS.GF2.Message.ChatEvent.UpdateChatRedPoint, UIChatPanel.UpdateChatRedPoint)
    MessageSys:AddListener(CS.GF2.Message.FriendEvent.FriendDel, UIChatPanel.DeleteFriend)
    MessageSys:AddListener(CS.GF2.Message.FriendEvent.FriendChangeMark, UIChatPanel.RefreshRoleInfo)
    MessageSys:AddListener(CS.GF2.Message.ChatEvent.AddChatChannel, UIChatPanel.AddChatChannel)
end

function UIChatPanel.OnInit()
    self = UIChatPanel

    UIUtils.GetButtonListener(self.mView.mBtn_BgClose.gameObject).onClick = function()
        UIChatPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UIChatPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Emoji.gameObject).onClick = function()
        UIChatPanel:OnClickEmojiList()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Send.gameObject).onClick = function()
        UIChatPanel:SendMessage()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_More.gameObject).onClick = function()
        UIChatPanel:OnClickMoreList()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_NewMessage.gameObject).onClick = function()
        UIChatPanel:OnClickNewMessage()
    end

    UIUtils.GetUIBlockHelper(self.mView.mUIRoot, self.mView.mTrans_EmojiList, function ()
        UIChatPanel:OnClickEmojiList()
    end)

    UIUtils.GetUIBlockHelper(self.mView.mUIRoot, self.mView.mTrans_MoreList, function ()
        UIChatPanel:OnClickMoreList()
    end)

    UIChatGlobal:CalculateMaxWidth(UIChatPanel.mView.mTrans_ListContent.rect.width)
    UIChatGlobal.CalculateNameMaxWidth(UIChatPanel.mView.mTrans_LeftContent.rect.width)

    self:InitVirtualFriendList()
    self:InitFriendList()
    self:InitMessageContent()
    self:InitChatType()

    if self.uid then
        self:UpdateFriendList()
        local friend = self:GetCurFriend(self.uid)
        if friend then
            self.curTab = friend
        end
    else
        self:UpdateFriendList()
        if NetCmdChatData.PlayerCurTab[0] == UIChatGlobal.ChatType.Friend then
            local friend = self:GetCurFriend(NetCmdChatData.PlayerCurTab[1])
            if friend then
                self.curTab = friend
            else
                if AccountNetCmdHandler:CheckSystemIsUnLock(UIChatGlobal.SystemIdList[2]) then
                    self.curTab = self.chatTypeList[2]
                else
                    self.curTab = self.chatTypeList[1]
                end
            end
        else
            if AccountNetCmdHandler:CheckSystemIsUnLock(UIChatGlobal.SystemIdList[2]) then
                self.curTab = self.chatTypeList[NetCmdChatData.PlayerCurTab[0]]
            else
                self.curTab = self.chatTypeList[1]
            end
        end
    end
end

function UIChatPanel.OnShow()
    self = UIChatPanel
    self:OnClickTab(self.curTab)
    if self.curTab.type == UIChatGlobal.ChatType.Friend then
        self.mView.mFriendList:RefreshWithIndex(self.curTab.index + 1)
    end
end

--- 页签相关
function UIChatPanel:InitChatType()
    --- 常驻两个系统和世界
    setactive(self.mView.mTrans_TabContent, self.needShowWorld)
    if self.needShowWorld then
        for i = 1, 2 do
            local item = UIChatTabItem.New()
            local data = self:InitChatTabData(i, item)
            item:InitCtrl(self.mView.mTrans_TabList)
            if AccountNetCmdHandler:CheckSystemIsUnLock(data.systemId) then
                item:SetData(i, nil, 100112 - i)
            else
                item:SetData(nil)
            end

            UIUtils.GetButtonListener(item.mBtn_Tab.gameObject).onClick = function()
                self:OnClickTab(data)
            end

            table.insert(self.chatTypeList, data)
        end
    end
end

function UIChatPanel:InitChatTabData(type, item)
    local data = ChatTabData.New(type, nil)
    data:SetItem(item)
    data:SetSystemId(UIChatGlobal.SystemIdList[type])
    return data
end

function UIChatPanel:OnClickTab(item)
    self.uid = item.uid
    if self.curTab then
        if self.curTab.type == UIChatGlobal.ChatType.Friend then
            self.mView.mFriendList:RefreshItem(self.curTab.index)
        else
            self.curTab:SetSelect(false)
        end
    end
    self:CacheInputMessage()
    self.curTab = item
    if self.curTab.type == UIChatGlobal.ChatType.Friend then
        self.mView.mFriendList:RefreshItem(self.curTab.index)
    else
        self.curTab:SetSelect(true)
    end

    self:UpdateContent()
end

function UIChatPanel:UpdateContent()
    setactive(self.mView.mTrans_SystemChat, self.curTab.type == UIChatGlobal.ChatType.System)
    setactive(self.mView.mTrans_WorldChat, self.curTab.type == UIChatGlobal.ChatType.World)
    setactive(self.mView.mTrans_SpeechOn, self.curTab.type ~= UIChatGlobal.ChatType.System)
    setactive(self.mView.mTrans_SpeechOff, self.curTab.type == UIChatGlobal.ChatType.System)
    setactive(self.mView.mTrans_FriendChat, self.curTab.type == UIChatGlobal.ChatType.Friend)

    self:UpdateMessageContentByType(self.curTab.type)
    self:UpdateInputMessage()

    NetCmdChatData.PlayerCurTab[0] = self.curTab.type
    NetCmdChatData.PlayerCurTab[1] = self.curTab.uid
    self.newMessageCount  = 0
    self.needRefreshAni = false
    setactive(self.mView.mTrans_NewMessage, self.newMessageCount > 0)

    if self.isShowEmoji then
        self:OnClickEmojiList()
    end

    if self.isShowMore then
        self:OnClickMoreList()
    end
end

--- 表情相关
function UIChatPanel:InitEmojiPanel()
    self.emojiList = {}
    local list = TableData.listChatDatas:GetList()
    for i = 0, list.Count - 1 do
        local emoji = {}
        local emojiObj = self:InstanceUIPrefab("Chat/ChatEmojiItemV2.prefab", self.mView.mTrans_EmojiContent, true)
        local emojiData = list[i]

        emoji.obj = emojiObj
        emoji.data = emojiData
        emoji.imgIcon = UIUtils.GetImage(emojiObj, "GrpIcon/Img_Icon")
        emoji.btnEmoji = UIUtils.GetButton(emojiObj)

        emoji.imgIcon.sprite = IconUtils.GetEmojiIcon(emojiData.icon)
        UIUtils.GetButtonListener(emoji.btnEmoji.gameObject).onClick = function()
            self:OnClickEmoji(emoji)
        end

        table.insert(self.emojiList, emoji)
    end
end

function UIChatPanel:InitMorePanel()
    self.moreList = {}
    for i = 1, 2 do
        local more = {}
        local moreObj = self:InstanceUIPrefab("Chat/ChatMoreDropDownItemV2.prefab", self.mView.mTrans_MoreList, true)

        more.obj = moreObj
        more.tag = i
        more.btnMore = UIUtils.GetButton(moreObj)
        more.txtName = UIUtils.GetText(moreObj, "GrpText/Text_Name")

        more.txtName.text = TableData.GetHintById(100101 + i)

        UIUtils.GetButtonListener(more.btnMore.gameObject).onClick = function()
            self:OnClickMore(more.tag)
        end

        table.insert(self.moreList, more)
    end
end

function UIChatPanel:OnClickEmoji(emoji)
    if emoji == nil or emoji.data.id <= 0 then
        return
    end

    self.isSelfSend = true
    if self.curTab.type == UIChatGlobal.ChatType.Friend then
        NetCmdChatData:SendChat(self.curTab.uid, emoji.data.id, "", function ()
            self:OnClickEmojiList()
        end)
    elseif self.curTab.type == UIChatGlobal.ChatType.World then
        if self.curChatData.lastSpeakTime > 0 then
            UIUtils.PopupHintMessage(100108)
            return
        end
        NetCmdChatData:SendWorldChat("", emoji.data.id, function ()
            self:OnClickEmojiList()
        end)
    end
    self:UpdateSendButton(self.curTab.type)
end

function UIChatPanel:OnClickEmojiList()
    if self.isShowMore then
        self:OnClickMoreList()
    end
    self.isShowEmoji = not self.isShowEmoji
    setactive(self.mView.mTrans_EmojiList, self.isShowEmoji)
    if self.isShowEmoji then
        if self.emojiList == nil then
            self:InitEmojiPanel()
        end
    end
end

function UIChatPanel:OnCloseEmoji()
    if self.isShowEmoji then
        self:OnClickEmojiList()
    end
end

function UIChatPanel:OnCloseMore()
    if self.isShowMore then
        self:OnClickMoreList()
    end
end

--- 好友列表相关
function UIChatPanel:InitVirtualFriendList()
    self.mView.mFriendList.itemProvider = function() local item = self:ItemProvider() return item end
    self.mView.mFriendList.itemRenderer = function(index, renderData) self:ItemRenderer(index, renderData) end
end

function UIChatPanel:ItemProvider()
    ---@type UIChatTabItem
    local itemView = UIChatTabItem.New()
    local renderDataItem = CS.RenderDataItem()
    itemView:InitCtrl()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIChatPanel:ItemRenderer(index, renderData)
    local item = renderData.data
    local data = self.friendDataList[index + 1]
    item:SetFriend(UIChatGlobal.ChatType.Friend, data.friendData)
    if self.uid and self.uid > 0 then
        item.mBtn_Tab.interactable = not (data.uid == self.uid)
    else
        item.mBtn_Tab.interactable = true
    end

    UIUtils.GetButtonListener(item.mBtn_Tab.gameObject).onClick = function()
        self:OnClickTab(data)
    end
end

function UIChatPanel:InitFriendList()
    self:UpdateFriendDataList()
end

function UIChatPanel:UpdateFriendDataList()
    self.friendDataList = {}
    local friendList = NetCmdChatData:GetHaveChatFriend((self.uid == nil and 0 or self.uid))
    for i = 0, friendList.Count - 1 do
        local friendData = ChatTabData.New(UIChatGlobal.ChatType.Friend, friendList[i])
        friendData:SetIndex(i)
        table.insert(self.friendDataList, friendData)
    end
end

function UIChatPanel:UpdateFriendList()
    self.mView.mFriendList.numItems = #self.friendDataList
    self.mView.mFriendList:Refresh()
end

function UIChatPanel:RemoveFriend(uid)
    local index = 0
    for i, v in ipairs(self.friendDataList) do
        if v.uid == uid then
            index = i
            table.remove(self.friendDataList, i)
            NetCmdChatData:RemoveChatFriend(uid)
            break
        end
    end
    self:RefreshFriendIndex()

    if index > 0 then
        if #self.friendDataList > 0 then
            if index > #self.friendDataList then
                self.uid = self.friendDataList[1].uid
            else
                self.uid = self.friendDataList[index].uid
            end
        else
            self.uid = nil
        end

        self:UpdateFriendList()
        local tab = nil
        if self.uid then
            tab = self:GetCurFriend(self.uid)
        else
            if self.needShowWorld then
                tab = self.chatTypeList[2]
            end
        end
        if tab == nil then
            self.DelayCloseUI()
        else
            self.curTab = tab
            self:OnClickTab(tab)
        end
    end
end

function UIChatPanel:RefreshFriendIndex()
    for i, friend in ipairs(self.friendDataList) do
        friend.index = (i - 1)
    end
end

function UIChatPanel:GetCurFriend(uid)
    if uid == nil then
        return nil
    end
    for i, friend in ipairs(self.friendDataList) do
        if friend.uid == uid then
            return friend
        end
    end
    return nil
end

--- 聊天相关
function UIChatPanel:InitMessageContent()
    self.mView.mWorldContent.itemUpdateCallback = function (srcObj, index)
        self:UpdateWorldItemCallback(srcObj, index)
    end

    self.mView.mFriendContent.itemUpdateCallback = function (srcObj, index)
        self:UpdateChatItemCallback(srcObj, index)
    end
    
    self.mView.mSystemContent.itemUpdateCallback = function(srcObj, index)
        self:UpdateSystemItemCallback(srcObj, index)
    end
end

function UIChatPanel:UpdateWorldItemCallback(srcObj, index)
    self.worldItemList = self.worldItemList or {}
    local data = self.curChatData.messageList[index]
    if data then
        local instanceId = srcObj:GetInstanceID()
        local item = self.worldItemList[instanceId]
        if not item then
            item = self:CreateBubbleItem(srcObj)
            self.worldItemList[instanceId] = item
        end
        item:SetWorldData(data)

        if index == self.curChatData.messageList.Count - 1 then
            self.newMessageCount  = 0
            setactive(self.mView.mTrans_NewMessage, false)
            if self.needRefreshAni then
                CS.LuaUIUtils.RefreshChatBubbleAni(srcObj, 0.2)
                self.needRefreshAni = false
            end
        end
    end
end

function UIChatPanel:UpdateChatItemCallback(srcObj, index)
    self.chatItemList = self.chatItemList or {}
    local data = self.curChatData.messageList[index]
    if data then
        local instanceId = srcObj:GetInstanceID()
        local item = self.chatItemList[instanceId]
        if not item then
            item = self:CreateBubbleItem(srcObj)
            self.chatItemList[instanceId] = item
        end
        local userData = data.active and AccountNetCmdHandler:GetRoleInfoData() or self.curFriend
        item:SetData(data, userData)

        if index == self.curChatData.messageList.Count - 1 then
            self.newMessageCount  = 0
            setactive(self.mView.mTrans_NewMessage, false)
            if self.needRefreshAni then
                CS.LuaUIUtils.RefreshChatBubbleAni(srcObj, 0.2)
                self.needRefreshAni = false
            end
        end
    end
end

function UIChatPanel:UpdateSystemItemCallback(srcObj, index)
    self.systemItemList = self.systemItemList or {}
    local data = self.curChatData.messageList[index]
    if data then
        local instanceId = srcObj:GetInstanceID()
        local item = self.systemItemList[instanceId]
        if not item then
            item = self:CreateSystemItem(srcObj)
            self.systemItemList[instanceId] = item
        end
        item:SetData(data)
    end
end

function UIChatPanel:CreateBubbleItem(srcObj)
    if srcObj then
        local item = UIChatContentItem.New()
        item:InitCtrl(srcObj.transform)
        return item
    end
    return nil
end

function UIChatPanel:CreateSystemItem(srcObj)
    if srcObj then
        local item = UIChatSystemItem.New()
        item:InitCtrl(srcObj.transform)
        return item
    end
    return nil
end


function UIChatPanel:UpdateMessageContentByType(type)
    if type == UIChatGlobal.ChatType.World then
        self.curFriend = nil
        self.curMessageContent = self.mView.mWorldContent
    elseif type == UIChatGlobal.ChatType.Friend then
        self.curMessageContent = self.mView.mFriendContent
        self.curFriend = NetCmdFriendData:GetFriendDataById(self.curTab.uid)
        self:UpdateFriendInfo()
    elseif type == UIChatGlobal.ChatType.System then
        self.curFriend = nil
        self.curMessageContent = self.mView.mSystemContent
    end
    self:GetMessageDataByType(type, self.curTab.uid)
    self:UpdateSendButton(type)
end

function UIChatPanel:UpdateFriendInfo()
    self.mView.mText_FriendName.text = (self.curFriend.Mark == "" or self.curFriend.Mark == nil) and self.curFriend.Name or self.curFriend.Mark
end

function UIChatPanel:GetMessageDataByType(type, uid)
    if type == UIChatGlobal.ChatType.System then
        self.curChatData = NetCmdChatData:GetSystemChat()
        self:UpdateMessageContent()
    elseif type == UIChatGlobal.ChatType.World then
        self.curChatData = NetCmdChatData:GetWorldChat()
        self:UpdateMessageContent()
    elseif type == UIChatGlobal.ChatType.Friend then
        if uid == nil then
            self.curChatData = nil
            self:UpdateMessageContent()
            return
        end

        if NetCmdChatData:IsRecChatDetail(uid) then
            self.curChatData = NetCmdChatData:GetChatDataById(uid)
            if self.curChatData then
                self:UpdateMessageContent()

                --- 把这个人的消息全部标为已读
                NetCmdChatData:SendChatRead(uid)
                NetCmdChatData:ReadFriendAllMessage(uid)
                self:UpdateFriendRedPoint(uid)
            end
        else
            NetCmdChatData:SendGetChatDetail(uid, function (ret)
                if ret == CS.CMDRet.eSuccess then
                    self.curChatData = NetCmdChatData:GetChatDataById(uid)
                    if self.curChatData then
                        self:UpdateMessageContent()
                    end

                    --- 把这个人的消息全部标为已读
                    NetCmdChatData:SendChatRead(uid)
                    NetCmdChatData:ReadFriendAllMessage(uid)
                    self:UpdateFriendRedPoint(uid)
                end
            end)
        end
    end
end

function UIChatPanel:UpdateMessageContent(needToEnd)
    if self.curMessageContent then
        self.curMessageContent.inertia = false
        local messageCount = 0
        if self.curChatData then
            messageCount = self.curChatData.messageList.Count
            self.curMessageContent.totalCount = messageCount
            local scrollToEnd = (messageCount - 1 == self.curMessageContent.GetItemTypeEnd)
            if needToEnd ~= nil and needToEnd == false then
                if scrollToEnd or self.isSelfSend then
                    self.newMessageCount = 0
                    self.isSelfSend = false
                    self.curMessageContent:RefillCellsFromEnd()
                    TimerSys:DelayCall(0.1, function ()
                        if self.curMessageContent ~= nil then
                            self.curMessageContent.verticalNormalizedPosition = 1
                            self.curMessageContent.inertia = true
                        end
                    end)
                else
                    self.curMessageContent.inertia = true
                    setactive(self.mView.mTrans_NewMessage, self.newMessageCount > 0)
                end
            else
                self.curMessageContent:RefillCellsFromEnd()
                TimerSys:DelayCall(0.1, function ()
                    if self.curMessageContent ~= nil then
                        self.curMessageContent.verticalNormalizedPosition = 1
                        self.curMessageContent.inertia = true
                    end
                end)
            end
        end
    end
end

function UIChatPanel:SendMessage()
    if self.curChatData.lastSpeakTime > 0 then
        UIUtils.PopupHintMessage(100108)
        return
    end

    local text = self.mView.mInput_Message.text
    if text == nil or text == "" then
        UIUtils.PopupHintMessage(100109)
        return
    end

    self.isSelfSend = true
    if self.curTab.type == UIChatGlobal.ChatType.Friend then
        NetCmdChatData:SendChat(self.curTab.uid, 0, text, function ()
            self.mView.mInput_Message.text = ""
        end)
    elseif self.curTab.type == UIChatGlobal.ChatType.World then
        NetCmdChatData:SendWorldChat(text, 0, function ()
            self.mView.mInput_Message.text = ""
        end)

        self:UpdateSendButton(self.curTab.type)
    end
end

function UIChatPanel:OnClickMoreList()
    self.isShowMore = not self.isShowMore
    setactive(self.mView.mTrans_MoreContent, self.isShowMore)
    if self.isShowMore then
        if self.moreList == nil then
            self:InitMorePanel()
        end
    end
end

function UIChatPanel:OnClickMore(tag)
    if self.curTab.type == UIChatGlobal.ChatType.Friend then
        if tag == UIChatGlobal.PlayerOperation.Delete then
            self:RemoveFriend(self.curTab.uid)
        elseif tag == UIChatGlobal.PlayerOperation.BlackList then
            local friendData = NetCmdFriendData:GetFriendDataById(self.curTab.uid)
            NetCmdFriendData:SendSetBlackList(self.curTab.uid, function ()
                NetCmdFriendData:SetFriendBlackList(friendData)
            end)
            self:RemoveFriend(self.curTab.uid)
        end
    end
end

function UIChatPanel:OnClickNewMessage()
    self.curMessageContent:RefillCellsFromEnd()
end

function UIChatPanel:UpdateUnreadNum()
    self.mView.mText_NewMessage.text = string_format(TableData.GetHintById(100105), self.newMessageCount)
end

function UIChatPanel.UpdateMessageList(msg)
    self = UIChatPanel
    if self.curTab == nil or self.curMessageContent == nil then
        return
    end
    if self.curTab.type == UIChatGlobal.ChatType.Friend then
        local uid = msg.Sender
        if uid and self.curFriend then
            if self.curFriend.UID == uid then
                self.curChatData = NetCmdChatData:GetChatDataById(uid)
                if self.curChatData then
                    self.newMessageCount  = self.newMessageCount + 1
                    self.needRefreshAni = (self.curMessageContent.totalCount == self.curMessageContent.GetItemTypeEnd)
                    self:UpdateMessageContent(false)
                    self:UpdateUnreadNum()

                    --- 把这个人的消息全部标为已读
                    NetCmdChatData:SendChatRead(uid)
                    NetCmdChatData:ReadFriendAllMessage(uid)
                end
            end
        end
    end
end

function UIChatPanel.UpdateWorldMessageList(msg)
    self = UIChatPanel
    if self.curTab == nil or self.curMessageContent == nil then
        return
    end
    if self.curTab.type == UIChatGlobal.ChatType.World then
        self.curChatData = NetCmdChatData:GetWorldChat()
        if self.curChatData then
            self.newMessageCount = self.newMessageCount + 1
            self.needRefreshAni = (self.curMessageContent.totalCount == self.curMessageContent.GetItemTypeEnd)
            self:UpdateMessageContent(false)
            self:UpdateUnreadNum()
        end
    end
end

function UIChatPanel.UpdateSystemMessageList(msg)
    self = UIChatPanel
    if self.curTab == nil or self.curMessageContent == nil then
        return
    end
    if self.curTab.type == UIChatGlobal.ChatType.System then
        self.curChatData = NetCmdChatData:GetSystemChat()
        if self.curChatData then
            self:UpdateMessageContent()
        end
    end
end

function UIChatPanel.UpdateChatRedPoint(msg)
    self = UIChatPanel
    self:UpdateFriendRedPoint(tonumber(msg.Sender))
end

function UIChatPanel.DeleteFriend(msg)
    self = UIChatPanel
    local uid = tonumber(msg.Sender)
    if uid == self.uid then
        UIUtils.PopupHintMessage(100048)
    end
    self:RemoveFriend(uid)
end

function UIChatPanel.AddChatChannel(msg)
    self = UIChatPanel
    local uid = tonumber(msg.Sender)
    local data = self:GetCurFriend(uid)
    if data == nil then
        local friendData = NetCmdFriendData:GetFriendDataById(uid)
        if friendData then
            local data = ChatTabData.New(UIChatGlobal.ChatType.Friend, friendData)
            table.insert(self.friendDataList, 1, data)

            self:RefreshFriendIndex()
            self:UpdateFriendList()
        end
    end
end

function UIChatPanel.RefreshRoleInfo(msg)
    self = UIChatPanel
    local uid = tonumber(msg.Sender)
    local data = self:GetCurFriend(uid)
    self.curFriend = NetCmdFriendData:GetFriendDataById(uid)
    self:UpdateFriendInfo()
    self.curMessageContent:RefreshCells()
    if data then
        data:RefreshFriendData(self.curFriend)
        self.mView.mFriendList:RefreshItem(data.index)
    end
end

--function UIChatPanel:RefreshFriendList()
--    self:UpdateFriendDataList()
--    self:UpdateFriendList()
--    self:UpdateFriendRedPoint()
--end

function UIChatPanel:UpdateFriendRedPoint(uid)
    local item = self:GetCurFriend(uid)
    if item then
        self.mView.mFriendList:RefreshItem(item.index)
    end
    self:UpdateRedPoint()
end

function UIChatPanel:UpdateSendButton(type)
    if self.worldChatTimer then
        self.lastSpeakTime = 0
        self.worldChatTimer:Stop()
    end
    if type == UIChatGlobal.ChatType.World then
        self.lastSpeakTime = self.curChatData.lastSpeakTime
        self.mView.mText_SendCD.text = (self.lastSpeakTime) .. "S"
        setactive(self.mView.mText_Send.gameObject, self.lastSpeakTime <= 0)
        setactive(self.mView.mText_SendCD.gameObject, self.lastSpeakTime > 0)
        if self.lastSpeakTime > 0 then
            self.worldChatTimer = TimerSys:DelayCall(1, function ()
                self.lastSpeakTime = self.lastSpeakTime - 1
                self.mView.mText_SendCD.text = (self.lastSpeakTime) .. "S"
                if self.lastSpeakTime <= 0 then
                    setactive(self.mView.mText_Send.gameObject, true)
                    setactive(self.mView.mText_SendCD.gameObject, false)
                end
            end, nil, self.lastSpeakTime)
        end
    else
        setactive(self.mView.mText_Send.gameObject, self.lastSpeakTime <= 0)
        setactive(self.mView.mText_SendCD.gameObject, self.lastSpeakTime > 0)
    end
end

----------------------------- private -----------------------------
function UIChatPanel:UpdateInputMessage()
    self.mView.mInput_Message.text = ""
    if self.curTab.type == UIChatGlobal.ChatType.World then
        self.mView.mInput_Message.text = self.cacheInput[0]
    end
    if self.cacheInput[self.curTab.uid] then
        self.mView.mInput_Message.text = self.cacheInput[self.curTab.uid]
    end
end

function UIChatPanel:CacheInputMessage()
    local text = self.mView.mInput_Message.text
    if text == nil or text == "" then
        return
    end
    if self.curTab then
        if self.curTab.type == UIChatGlobal.ChatType.World then
            self.cacheInput[0] = text
        else
            self.cacheInput[self.curTab.uid] = text
        end
    end
end


