require("UI.UIBaseCtrl")
---@class UIFriendBlackItem : UIBaseCtrl

UIFriendBlackItem = class("UIFriendBlackItem", UIBaseCtrl)
UIFriendBlackItem.__index = UIFriendBlackItem

function UIFriendBlackItem:ctor()
    self.playerData = nil
    self.avatarInfo = nil
end

function UIFriendBlackItem:__InitCtrl()
    self.mBtn_Remove = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/BtnBlackList"))
    self.mTrans_Avatar = self:GetRectTransform("GrpPlayerAvatar")
    self.mText_Name = self:GetText("GrpCenterText/Text_PlayerName")
    self.mText_Level = self:GetText("GrpCenterText/Text_Level")

    UIUtils.GetButtonListener(self.mBtn_Remove.gameObject).onClick = function()
        self:RemoveBlackList()
    end
end

function UIFriendBlackItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComBlackListItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
    self:InitInfo()
end

function UIFriendBlackItem:InitInfo()
    if self.avatarInfo == nil then
        self.avatarInfo = UICommonPlayerAvatarItem.New()
        self.avatarInfo:InitCtrl(self.mTrans_Avatar)

        UIUtils.GetButtonListener(self.avatarInfo.mBtn_Avatar.gameObject).onClick = function()
            self:OnClickPlayerInfo()
        end
    end
end

function UIFriendBlackItem:SetData(data)
    self.playerData = data
    self.avatarInfo:SetData(self.playerData.Icon)
    self.mText_Name.text = self.playerData.Name
    self.mText_Level.text = GlobalConfig.LVText .. self.playerData.Level
end


function UIFriendBlackItem:RemoveBlackList()
    if self.playerData.IsBlack then
        NetCmdFriendData:SetUnsetBlackList(self.playerData.UID, function (ret)
            self:OnBlackListCallback(ret)
        end)
    end
end

function UIFriendBlackItem:OnBlackListCallback(ret)
    if ret == CS.CMDRet.eSuccess then
        UIUtils.PopupPositiveHintMessage(100047)
        MessageSys:SendMessage(CS.GF2.Message.FriendEvent.FriendListChange,nil)
    end
end

function UIFriendBlackItem:OnClickPlayerInfo()
    if self.playerData then
        UIPlayerInfoPanel.OpenByParam(self.playerData)
    end
end