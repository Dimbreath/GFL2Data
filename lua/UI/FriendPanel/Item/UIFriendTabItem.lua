require("UI.UIBaseCtrl")
---@class UIFriendTabItem : UIBaseCtrl

UIFriendTabItem = class("UIFriendTabItem", UIBaseCtrl)
UIFriendTabItem.__index = UIFriendTabItem

function UIFriendTabItem:ctor()
    self.tagId = 0
    self.transEmpty = nil
    self.transList = nil
    self.virtualList = nil
    self.isFirstClick = true
end

function UIFriendTabItem:__InitCtrl()
    self.mBtn_Select = self:GetSelfButton()
    self.mText_Name = self:GetText("Root/GrpText/Text_Name")
    self.mImage_Icon = self:GetImage("Root/GrpIcon/Img_Icon")
    self.mTrans_RedPoint = self:GetRectTransform("Root/Trans_RedPoint")
end

function UIFriendTabItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComBtn5ItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIFriendTabItem:SetData(tagId, transList, virtualList, transEmpty)
    self.tagId = tagId
    self.transList = transList
    self.virtualList = virtualList
    self.transEmpty = transEmpty

    self.mText_Name.text = UIFriendGlobal:GetTagNameById(self.tagId)
    self.mImage_Icon.sprite = UIFriendGlobal:GetTagIconById(self.tagId)
    self.fadeManager = UIUtils.GetRectTransform(virtualList,"Viewport/Content"):GetComponent("MonoScrollerFadeManager")
end

function UIFriendTabItem:SetSelect(isSelcet)
    self.mBtn_Select.interactable = not isSelcet
end

function UIFriendTabItem:EnableEmpty(enable)
    if self.transEmpty then
        setactive(self.transEmpty, enable)
    end
end

function UIFriendTabItem:EnableTransList(enable)
    if self.transList then
        if self.fadeManager and enable then
            self.fadeManager:InitFade()
        end
        setactive(self.transList, enable)
    end
end

function UIFriendTabItem:SetIsFristClick(isFirst)
    self.isFirstClick = isFirst
end

function UIFriendTabItem:InitRedPoint()
    self:InstanceUIPrefab("UICommonFramework/ComRedPointItemV2.prefab", self.mTrans_RedPoint, true)
end