require("UI.UIBaseCtrl")

LevelUpPropertyItem = class("LevelUpPropertyItem", UIBaseCtrl)
LevelUpPropertyItem.__index = LevelUpPropertyItem

function LevelUpPropertyItem:ctor()
    self.mData = nil
end

function LevelUpPropertyItem:__InitCtrl()
    self.mText_Name = self:GetText("Text_name")
    self.mText_BeforeValue = self:GetText("Text_NumBef")  
    self.mText_AfterValue = self:GetText("Text_NumAft")
end

function LevelUpPropertyItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/LevelUpPropertyItem.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function LevelUpPropertyItem:SetData(data)
    self.mData = data
    self.mText_Name.text = data.name
    self.mText_BeforeValue.text = data.beforeValue
    self.mText_AfterValue.text = data.afterValue
end

function LevelUpPropertyItem:SetDataByName(name, beforeValue, afterValue)
    self.mText_Name.text = name
    self.mText_BeforeValue.text = beforeValue
    self.mText_AfterValue.text = afterValue
end

