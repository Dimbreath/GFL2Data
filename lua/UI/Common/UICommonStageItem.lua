require("UI.UIBaseCtrl")
---@class UICommonStageItem : UIBaseCtrl

UICommonStageItem = class("UICommonStageItem", UIBaseCtrl)
UICommonStageItem.__index = UICommonStageItem

function UICommonStageItem:ctor(maxNum)
    self.maxNum = maxNum
    self.stageList = {}
end

function UICommonStageItem:__InitCtrl()
    for i = 1, GlobalConfig.MaxStar do
        local stage = {}
        local obj = self:GetRectTransform("GrpStage" .. i)
        stage.obj = obj
        stage.bgObj = self:GetRectTransform("GrpBg/ImgBg" .. i)
        stage.transOn = UIUtils.GetRectTransform(obj, "Trans_On")

        setactive(stage.obj, i <= self.maxNum)
        table.insert(self.stageList, stage)
    end
end

function UICommonStageItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComStage2ItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonStageItem:SetData(stageNum)
    local num = math.min(stageNum, self.maxNum)
    for i, stage in ipairs(self.stageList) do
        setactive(stage.transOn, i <= num)
    end
end

function UICommonStageItem:ResetMaxNum(maxNum)
    self.maxNum = maxNum

    for i, stage in ipairs(self.stageList) do
        setactive(stage.obj, i <= self.maxNum)
        setactive(stage.bgObj, i <= self.maxNum)
    end
end

