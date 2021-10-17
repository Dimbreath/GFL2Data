require("UI.UIBaseCtrl")
---@class UICommonDutyItem : UIBaseCtrl

UICommonDutyItem = class("UICommonDutyItem", UIBaseCtrl)
UICommonDutyItem.__index = UICommonDutyItem

function UICommonDutyItem:ctor()
    self.dutyData = nil
end

function UICommonDutyItem:__InitCtrl()
    self.mImage_Duyt = self:GetImage("Img_DutyIcon")
end

function UICommonDutyItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComDutyItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonDutyItem:SetData(dutyData)
    self.mImage_Duyt.sprite = IconUtils.GetGunTypeIcon(dutyData.icon)
end

