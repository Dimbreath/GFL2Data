require("UI.UIBaseCtrl")
---@class UIChatTabItem : UIBaseCtrl

UIChatTabItem = class("UIChatTabItem", UIBaseCtrl)
UIChatTabItem.__index = UIChatTabItem

function UIChatTabItem:ctor()
    self.type = 0
    self.uid = 0
end

function UIChatTabItem:__InitCtrl()
    self.mBtn_Tab = self:GetSelfButton()

    self.mTrans_GroupIcon = self:GetRectTransform("Root/Trans_GrpIcon")
    self.mTrans_World = self:GetRectTransform("Root/Trans_GrpIcon/Trans_Img_WorldIcon")
    self.mTrans_System = self:GetRectTransform("Root/Trans_GrpIcon/Trans_Img_SystemIcon")
    self.mTrans_Player = self:GetRectTransform("Root/Trans_GrpPlayerAvatar")

    self.mText_Name = self:GetText("Root/Text_Name")
    self.mImage_Avatar = self:GetImage("Root/Trans_GrpPlayerAvatar/Img_Avatar")
    self.mTrans_RedPoint = self:GetRectTransform("Root/Trans_RedPoint")
end

function UIChatTabItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("Chat/ChatLeftTab1ItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIChatTabItem:SetData(type, uid, hintID)
    self.type = type
    self.uid = uid
    if type then
        if type == UIChatGlobal.ChatType.System or type == UIChatGlobal.ChatType.World then
            setactive(self.mTrans_System, type == UIChatGlobal.ChatType.System)
            setactive(self.mTrans_World, type == UIChatGlobal.ChatType.World)

            self.mText_Name.text = TableData.GetHintById(hintID)
        end

        setactive(self.mTrans_Player, false)
        setactive(self.mTrans_GroupIcon, true)
        setactive(self.mUIRoot, true)
    else
        self.mBtn_Tab.interactable = true
        setactive(self.mUIRoot, false)
    end
end

function UIChatTabItem:SetFriend(type, friendData, curUid)
    self.type = type
    if type and friendData then
        self.uid = friendData.UID
        local friendData = NetCmdFriendData:GetFriendDataById(self.uid)
        if friendData then
            local name = (friendData.Mark == "" or friendData.Mark == nil) and friendData.Name or friendData.Mark
            self.mText_Name.text = UIUtils.BreviaryText(name, self.mText_Name, UIChatGlobal.MaxNameWidth)
            self.mImage_Avatar.sprite = IconUtils.GetPlayerAvatar(friendData.Icon)
        end
        setactive(self.mTrans_RedPoint, friendData.hasUnreadMessage > 0)
        setactive(self.mTrans_Player, true)
        setactive(self.mTrans_GroupIcon, false)

        self:UpdateRedPoint()

        if curUid then
            self.mBtn_Tab.interactable = not (self.uid == curUid)
        end
        setactive(self.mUIRoot, true)
    else
        self.uid = nil
        self.mBtn_Tab.interactable = true
        setactive(self.mUIRoot, false)
    end
end

function UIChatTabItem:UpdateRedPoint()
    if self.uid then
        local friendData = NetCmdFriendData:GetFriendDataById(self.uid)
        if friendData then
            setactive(self.mTrans_RedPoint, friendData.hasUnreadMessage > 0)
        else
            setactive(self.mTrans_RedPoint, false)
        end
    end
end

