require("UI.UIBaseCtrl")
---@class UIChatContentItem : UIBaseCtrl

UIChatContentItem = class("UIChatContentItem", UIBaseCtrl)
UIChatContentItem.__index = UIChatContentItem

function UIChatContentItem:ctor()
    self.messageData = nil
    self.userData = nil

    self.otherChat = nil
    self.selfChat = nil
end

function UIChatContentItem:__InitCtrl()
    self.mTrans_Time = self:GetRectTransform("Trans_GrpTime")
    self.mText_Time = self:GetText("Trans_GrpTime/GrpTime/Text_Time")
    self.mTrans_Other = self:GetRectTransform("Trans_GrpMessage/Trans_GrpPlayerOthers")
    self.mTrans_Self = self:GetRectTransform("Trans_GrpMessage/Trans_GrpPlayerSelf")
    self.mTrans_Message = self:GetRectTransform("Trans_GrpMessage")

    self.otherChat = self:InitChatContent(self.mTrans_Other)
    self.selfChat = self:InitChatContent(self.mTrans_Self)

    self.mLayoutElement = UIUtils.GetLayoutElemnt(self.mUIRoot)
    self.mLayout = UIUtils.GetLayoutGroup(self.mUIRoot)
end

function UIChatContentItem:InitChatContent(obj)
    local content = {}
    content.obj = obj
    content.imgAvatar = UIUtils.GetImage(obj, "GrpPlayerAvatar/Btn_PlayerAvatar/GrpPlayerAvatar/Img_Avatar")
    content.txtName = UIUtils.GetText(obj, "GrpName/Text_Name")
    content.transText = UIUtils.GetRectTransform(obj, "GrpChatBox/Trans_GrpText")
    content.txtContent = UIUtils.GetText(obj, "GrpChatBox/Trans_GrpText/Text_Content")
    content.transContent = UIUtils.GetRectTransform(obj, "GrpChatBox/Trans_GrpText/Text_Content")
    content.transEmoji = UIUtils.GetRectTransform(obj, "GrpChatBox/Trans_GrpEmoji")
    content.imgEmoji = UIUtils.GetImage(obj, "GrpChatBox/Trans_GrpEmoji/Img_Emoji")
    content.btnAvatar = UIUtils.GetButton(obj, "GrpPlayerAvatar/Btn_PlayerAvatar")

    UIUtils.GetButtonListener(content.btnAvatar.gameObject).onClick = function()
        self:OnClickPlayerInfo()
    end

    return content
end

function UIChatContentItem:InitCtrl(obj)
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIChatContentItem:SetData(messageData, userData)
    self.messageData = messageData
    self.userData = userData
    if messageData then
        local preferredHeight = -1
        self.mLayoutElement.preferredHeight = preferredHeight
        local bubble = messageData.active and self.selfChat or self.otherChat
        setactive(bubble.transEmoji, messageData.emoji > 0)
        setactive(bubble.transText, not(messageData.emoji > 0))
        if messageData.emoji > 0 then
            local emojiData = TableData.listChatDatas:GetDataById(messageData.emoji)
            if emojiData then
                bubble.imgEmoji.sprite = IconUtils.GetEmojiIcon(emojiData.icon)
            end
            preferredHeight = 150
        else
            bubble.txtContent.text = messageData.message
            local width = UIUtils.GetFontWidth(messageData.message, bubble.txtContent)
            -- local maxWidth = UIChatGlobal:CalculateMaxWidth(self.mTrans_Message.rect.width)
            local maxWidth = UIChatGlobal.MaxWidth
            if width <= maxWidth then
                preferredHeight = 72
            else
                local height = (math.ceil(width / maxWidth) - 1) * 24
                preferredHeight = 72 + height
            end
        end

        if userData then
            bubble.imgAvatar.sprite = IconUtils.GetPlayerAvatar(userData.Icon)
            bubble.txtName.text = (userData.Mark == "" or userData.Mark == nil) and userData.Name or userData.Mark
        end

        setactive(self.mTrans_Time, messageData.needShowTime)
        if messageData.needShowTime then
            self.mText_Time.text = messageData:TranslationTime()
            preferredHeight = preferredHeight + self.mTrans_Time.rect.height + self.mLayout.spacing
        end

        self.mLayoutElement.preferredHeight = preferredHeight
        setactive(self.selfChat.obj, messageData.active)
        setactive(self.otherChat.obj, not messageData.active)
    end
end

function UIChatContentItem:SetWorldData(messageData)
    if messageData then
        self.messageData = messageData
        self.userData = messageData.active and AccountNetCmdHandler:GetRoleInfoData() or messageData.user
        local bubble = messageData.active and self.selfChat or self.otherChat
        setactive(bubble.transEmoji, messageData.emoji > 0)
        setactive(bubble.transText, not(messageData.emoji > 0))

        local preferredHeight = -1
        self.mLayoutElement.preferredHeight = preferredHeight
        if messageData.emoji > 0 then
            local emojiData = TableData.listChatDatas:GetDataById(messageData.emoji)
            bubble.imgEmoji.sprite = IconUtils.GetEmojiIcon(emojiData.icon)
            preferredHeight = 150
        else
            bubble.txtContent.text = messageData.message
            local width = UIUtils.GetFontWidth(messageData.message, bubble.txtContent)
            local maxWidth = UIChatGlobal.MaxWidth
            if width <= maxWidth then
                preferredHeight = 72
            else
                local height = (math.ceil(width / maxWidth) - 1) * 24
                preferredHeight = 72 + height
            end
        end

        bubble.imgAvatar.sprite =  IconUtils.GetPlayerAvatar(self.userData.Icon)
        bubble.txtName.text = self.userData.Name

        setactive(self.mTrans_Time, messageData.needShowTime)
        if messageData.needShowTime then
            self.mText_Time.text = messageData:TranslationTime()
            preferredHeight = preferredHeight + self.mTrans_Time.rect.height + self.mLayout.spacing
        end

        self.mLayoutElement.preferredHeight = preferredHeight
        setactive(self.selfChat.obj, messageData.active)
        setactive(self.otherChat.obj, not messageData.active)
    end
end

function UIChatContentItem:OnClickPlayerInfo()
    if self.userData then
        if self.messageData.active then
            local userData = AccountNetCmdHandler:GetRoleInfoData()
            UIManager.OpenUIByParam(UIDef.UIPlayerInfoPanel, userData)
        else
            if self.userData.UID <= 0 then
               return
            end
            NetCmdFriendData:SendSocialFriendSearch(tostring(self.userData.UID), function ()
                local userData = NetCmdFriendData:GetCurSearchFriendData()
                if userData then
                    UIManager.OpenUIByParam(UIDef.UIPlayerInfoPanel, userData)
                end
            end)
        end
    end
end
