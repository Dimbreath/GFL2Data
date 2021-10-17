require("UI.UIBaseCtrl")

UIUnitInfoSkillItem = class("UIUnitInfoSkillItem", UIBaseCtrl)
UIUnitInfoSkillItem.__index = UIUnitInfoSkillItem

function UIUnitInfoSkillItem:ctor()
    self.skillData = nil
    self.skillIndex = 0
end

function UIUnitInfoSkillItem:__InitCtrl()
    self.mBtn_Choose = self:GetButton("Btn_Choose")

    self.mTrans_Select = self:GetRectTransform("UI_Trans_Sel")
    self.mTrans_UnSelect = self:GetRectTransform("UI_Trans_Unsel")

    self.mImage_SelectIcon = self:GetImage("UI_Trans_Sel/SkillIcon/Image_SkillIcon")
    self.mImage_UnSelectIcon = self:GetImage("UI_Trans_Unsel/Image_SkillIcon")
end

function UIUnitInfoSkillItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UIUnitInfoSkillItem.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIUnitInfoSkillItem:SetData(data, index)
    self.skillData = data
    if self.skillData then
        self.skillIndex = index
        self.mImage_SelectIcon.sprite = IconUtils.GetSkillIconSprite(self.skillData.icon)
        self.mImage_UnSelectIcon.sprite = IconUtils.GetSkillIconSprite(self.skillData.icon)

        self:SetSelect(false)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIUnitInfoSkillItem:SetSelect(select)
    setactive(self.mTrans_Select, select)
    setactive(self.mTrans_UnSelect, not select)
end

