require("UI.UIBaseCtrl")
---@class UICommonPlayerAvatarItem : UIBaseCtrl

UICommonPlayerAvatarItem = class("UICommonPlayerAvatarItem", UIBaseCtrl)
UICommonPlayerAvatarItem.__index = UICommonPlayerAvatarItem

function UICommonPlayerAvatarItem:ctor()
    self.data = nil
end

function UICommonPlayerAvatarItem:__InitCtrl()
    self.mBtn_Avatar = self:GetSelfButton()
    self.mImage_Avatar = self:GetImage("GrpPlayerAvatar/Img_Avatar")
    self.mTrans_Lock = self:GetRectTransform("Trans_GrpLock")
    self.mTrans_Black = self:GetRectTransform("Trans_GrpSelBlack")
end

function UICommonPlayerAvatarItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComPlayerAvatarItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonPlayerAvatarItem:SetData(avatar)
    self.mImage_Avatar.sprite = IconUtils.GetPlayerAvatar(avatar)
end

function UICommonPlayerAvatarItem:SetLockState(isLock)
    setactive(self.mTrans_Lock, isLock)
end

function UICommonPlayerAvatarItem:SetBlackState(isBlack)
    setactive(self.mTrans_Black, isBlack)
end
