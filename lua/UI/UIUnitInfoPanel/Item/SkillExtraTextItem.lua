require("UI.UIBaseCtrl")
---@class SkillExtraTextItem : UIBaseCtrl

SkillExtraTextItem = class("SkillExtraTextItem", UIBaseCtrl)
SkillExtraTextItem.__index = SkillExtraTextItem

function SkillExtraTextItem:ctor()

end

function SkillExtraTextItem:__InitCtrl()
    self.mText_Desc = self:GetSelfText()
end

function SkillExtraTextItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("Combat/CombatSkillExtraTextItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function SkillExtraTextItem:SetData(data)
    if data then
        self.mText_Desc.text = TableData.GetHintById(data)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end