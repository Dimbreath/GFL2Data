require("UI.UIBaseView")

---@class UIAchievementSubPanelView : UIBaseView
UIAchievementSubPanelView = class("UIAchievementSubPanelView", UIBaseView);
UIAchievementSubPanelView.__index = UIAchievementSubPanelView


function UIAchievementSubPanelView:__InitCtrl()
    self.mText_Num = self:GetText("GrpAchievementPoint/GrpPoint/Text_Num");
    self.mContent_AchievementAll = self:GetGridLayoutGroup("GrpAchievementAllList/Viewport/Content");
    self.mList_AchievementAll = self:GetScrollRect("GrpAchievementAllList");
    self.mScrollbar_AchievementAll = self:GetScrollbar("GrpAchievementAllList/Scrollbar");
end


function UIAchievementSubPanelView:InitCtrl(root)

    self:SetRoot(root);

    self:__InitCtrl();
end