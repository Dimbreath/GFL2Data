 require("UI.UIBaseView")

UIChapterRewardPanelView = class("UIChapterRewardPanelView", UIBaseView)
UIChapterRewardPanelView.__index = UIChapterRewardPanelView

function UIChapterRewardPanelView:ctor()
    self.rewardList = {}
end

function UIChapterRewardPanelView:__InitCtrl()
    self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_CloseBg = self:GetButton("Root/GrpBg/Btn_Close")
    self.mBtn_Receive = self:GetButton("Root/GrpDialog/GrpAction/Trans_CanReceive/Btn_Receive")

    self.mTrans_Lock = self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_Locked")
    self.mTrans_Unlock = self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_UnLocked")
    self.mTrans_Receive = self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_CanReceive")

    for i = 1, 3 do
        local obj = self:GetRectTransform("Root/GrpDialog/GrpCenter/TargetList/StoryChapterRewardItemV2" .. i)
        local item = self:InitReward(obj)
        table.insert(self.rewardList, item)
    end
end

function UIChapterRewardPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end

function UIChapterRewardPanelView:InitReward(obj)
    if obj then
        local reward = {}
        reward.obj = obj
        reward.txtNum = UIUtils.GetText(obj, "GrpCollectNum/GrpText/Text_Num")
        reward.transFinish = UIUtils.GetRectTransform(obj, "GrpState/Trans_TextCompleted")
        reward.transUnFinish = UIUtils.GetRectTransform(obj, "GrpState/Trans_TextUnCompleted")
        reward.transReceive = UIUtils.GetRectTransform(obj, "GrpState/Trans_TextCanCompleted")
        reward.transItemList = UIUtils.GetRectTransform(obj, "GrpReward/Content")

        reward.itemList = {}

        return reward
    end
end