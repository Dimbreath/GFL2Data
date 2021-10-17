require("UI.UIBaseCtrl")
---@class UICommonSkillItem : UIBaseCtrl

UICommonSkillItem = class("UICommonSkillItem", UIBaseCtrl)
UICommonSkillItem.__index = UICommonSkillItem

function UICommonSkillItem:ctor()
    self.skillData = nil
end

function UICommonSkillItem:__InitCtrl()
    self.mImage_SkillIcon =self:GetImage("GrpNor/Img_Icon")
    self.mBtn_Skill = self:GetSelfButton()
end

function UICommonSkillItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComBtnSkillItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonSkillItem:SetData(skillId)
    local data = TableData.listBattleSkillDatas:GetDataById(skillId)
    self.skillData = data
    self.mImage_SkillIcon.sprite = IconUtils.GetSkillIconSprite(data.icon)
end

function UICommonSkillItem:SetSelected(value)
    self.mBtn_Skill.interactable = (not value)
end

