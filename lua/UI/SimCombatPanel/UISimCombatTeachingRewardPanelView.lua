require("UI.UIBaseView")

UISimCombatTeachingRewardPanelView = class("UISimCombatTeachingRewardPanelView", UIBaseView)
UISimCombatTeachingRewardPanelView.__index = UISimCombatTeachingRewardPanelView

function UISimCombatTeachingRewardPanelView:ctor()
    self.rewardList = {}
end

function UISimCombatTeachingRewardPanelView:__InitCtrl()
    self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_CloseBg = self:GetButton("Root/GrpBg/Btn_Close")

    self.mTrans_Content = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpAffixList/Viewport/Content")
end

function UISimCombatTeachingRewardPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end
