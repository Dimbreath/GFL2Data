require("UI.UIBaseCtrl")
---@class UICommonElementItem : UIBaseCtrl

UICommonElementItem = class("UICommonElementItem", UIBaseCtrl)
UICommonElementItem.__index = UICommonElementItem

function UICommonElementItem:ctor()
    self.elementData = nil
end

function UICommonElementItem:__InitCtrl()
    self.mImage_Element = self:GetImage("Image_ElementIcon")
end

function UICommonElementItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComElementItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonElementItem:SetData(elementData)
    self.mImage_Element.sprite = IconUtils.GetElementIcon(elementData.icon)
end

