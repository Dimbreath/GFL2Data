require("UI.UIBasePanel")

UIChapterRewardPanel = class("UIChapterRewardPanel", UIBasePanel)
UIChapterRewardPanel.__index = UIChapterRewardPanel

UIChapterPanel.chapterId = 0

function UIChapterRewardPanel:ctor()
    UIChapterRewardPanel.super.ctor(self)
end

function UIChapterRewardPanel.Close()
    self = UIChapterRewardPanel
    UIManager.CloseUI(UIDef.UIChapterRewardPanel)
end

function UIChapterRewardPanel.OnRelease()
    self = UIChapterRewardPanel
end

function UIChapterRewardPanel.Init(root, data)
    self = UIChapterRewardPanel

    self.mIsPop = true
    self.chapterId = data

    UIChapterRewardPanel.super.SetRoot(UIChapterRewardPanel, root)

    UIChapterRewardPanel.mView = UIChapterRewardPanelView.New()
    UIChapterRewardPanel.mView:InitCtrl(root)
end

function UIChapterRewardPanel.OnInit()
    self = UIChapterRewardPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UIChapterRewardPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CloseBg.gameObject).onClick = function()
        UIChapterRewardPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Receive.gameObject).onClick = function()
        UIChapterRewardPanel:OnReceiveItem()
    end

    self:UpdatePanel()
end

function UIChapterRewardPanel:UpdatePanel()
    local storyCount = NetCmdDungeonData:GetCanChallengeStoryList(self.chapterId).Count
    local chatperData = TableData.listChapterDatas:GetDataById(self.chapterId)
    local receiveCount = 0
    local finishCount = 0

    for i, reward in ipairs(self.mView.rewardList) do
        local state = NetCmdDungeonData:GetCurStateByChapterID(self.chapterId, i)
        local stars = NetCmdDungeonData:GetCurStarsByChapterID(self.chapterId)
        local itemList = chatperData["chapter_reward_" .. i]
        setactive(reward.obj, itemList ~= nil and itemList.Count > 0)
        if itemList ~= nil and itemList.Count > 0 then
            local limit = storyCount * i
            reward.txtNum.text = stars .. "/" .. limit
            setactive(reward.transUnFinish, state == UIChapterGlobal.RewardState.UnFinish)
            setactive(reward.transReceive, state == UIChapterGlobal.RewardState.Receive)
            setactive(reward.transFinish, state == UIChapterGlobal.RewardState.Finish)
            receiveCount = state == UIChapterGlobal.RewardState.Receive and receiveCount + 1 or receiveCount

            if state == UIChapterGlobal.RewardState.Finish then
                finishCount = finishCount + 1
            end

            for _, item in ipairs(reward.itemList) do
                item:SetItemData(nil)
            end

            local count = 1
            for itemId, itemNum in pairs(chatperData["chapter_reward_" .. i]) do
                if count <= #reward.itemList then
                    reward.itemList[count]:SetItemData(itemId, itemNum)
                else
                    local item = UICommonItem.New()
                    item:InitCtrl(reward.transItemList)
                    item:SetItemData(itemId, itemNum)

                    table.insert(reward.itemList, item)
                end

                count = count + 1
            end
        end
    end

    setactive(self.mView.mTrans_Receive, receiveCount > 0)
    setactive(self.mView.mTrans_Lock, receiveCount <= 0 and finishCount < 3)
    setactive(self.mView.mTrans_Unlock, finishCount >= 3)
end

function UIChapterRewardPanel:OnReceiveItem()
    NetCmdDungeonData:CheckCanGetReward(self.chapterId, function ()
        self:TakeQuestRewardCallBack()
    end)
end

function UIChapterRewardPanel:TakeQuestRewardCallBack()
    self:UpdatePanel()
    UIManager.OpenUIByParam(UIDef.UICommonReceivePanel)
    MessageSys:SendMessage(CS.GF2.Message.UIEvent.RefreshChapterInfo, nil)
end




