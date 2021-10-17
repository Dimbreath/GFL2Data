require("UI.UIBasePanel")

---@class UIAchievementSubPanel : UIBasePanel
UIAchievementSubPanel = class("UIAchievementSubPanel")
UIAchievementSubPanel.__index = UIAchievementSubPanel
---@type UIAchievementSubPanelView
UIAchievementSubPanel.mView = nil

function UIAchievementSubPanel:ctor(root)
    self = UIAchievementSubPanel
    self.mUIRoot = root;
    self.mLeftTabViewList = List:New()

    self.mView = UIAchievementSubPanelView.New()
    self.mView:InitCtrl(self.mUIRoot)
    self:InitAllList()
end

function UIAchievementSubPanel.Show()
    self = UIAchievementSubPanel
    for _, item in ipairs(self.mLeftTabViewList) do
        item:RefreshData()
    end
    self.mView.mText_Num.text = NetCmdAchieveData:GetTotalPoints()
end

function UIAchievementSubPanel:InitAllList()
    self.mView.mText_Num.text = NetCmdAchieveData:GetTotalPoints()
    for i = 0, TableData.listAchievementTagDatas.Count - 1 do
        local data = TableData.listAchievementTagDatas[i]
        ---@type UIAchievementAllItem
        local item = UIAchievementAllItem.New()
        item:InitCtrl(self.mView.mContent_AchievementAll)
        item:SetData(data)
        self.mLeftTabViewList:Add(item)
        UIUtils.GetListener(item.mBtn.gameObject).onClick = function()
            UIManager.OpenUIByParam(UIDef.UIAchievementPanel, data.id);
        end
    end
end
