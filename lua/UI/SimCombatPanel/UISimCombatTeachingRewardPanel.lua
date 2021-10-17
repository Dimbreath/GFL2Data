require("UI.UIBasePanel")

UISimCombatTeachingRewardPanel = class("UISimCombatTeachingRewardPanel", UIBasePanel)
UISimCombatTeachingRewardPanel.__index = UISimCombatTeachingRewardPanel

UISimCombatTeachingRewardPanel.chapterId = 0
UISimCombatTeachingRewardPanel.labelList = {};

function UISimCombatTeachingRewardPanel:ctor()
    UISimCombatTeachingRewardPanel.super.ctor(self)
end

function UISimCombatTeachingRewardPanel.Close()
    self = UISimCombatTeachingRewardPanel
    UIManager.CloseUI(UIDef.UISimCombatTeachingRewardPanel)
end

function UISimCombatTeachingRewardPanel.OnRelease()
    self = UISimCombatTeachingRewardPanel

    self.labelList = {};
end

function UISimCombatTeachingRewardPanel.Init(root, data)
    self = UISimCombatTeachingRewardPanel

    self.mIsPop = true
    self.chapterId = data

    self.RedPointType = {RedPointConst.ChapterReward}

    UISimCombatTeachingRewardPanel.super.SetRoot(UISimCombatTeachingRewardPanel, root)

    UISimCombatTeachingRewardPanel.mView = UISimCombatTeachingRewardPanelView.New()
    UISimCombatTeachingRewardPanel.mView:InitCtrl(root)
end

function UISimCombatTeachingRewardPanel.OnInit()
    self = UISimCombatTeachingRewardPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UISimCombatTeachingRewardPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CloseBg.gameObject).onClick = function()
        UISimCombatTeachingRewardPanel.Close()
    end

    -- UIUtils.GetButtonListener(self.mView.mBtn_Receive.gameObject).onClick = function()
    --     UISimCombatTeachingRewardPanel:OnReceiveItem()
    -- end

    self:UpdatePanel()
end

function UISimCombatTeachingRewardPanel:UpdatePanel()
    local prefab = UIUtils.GetGizmosPrefab("SimCombat/SimCombatTeachingRewardItemV2.prefab",self);
    local list = NetCmdSimulateBattleData:GetSimBattleTeachingChapterList();


    for i=0, self.mView.mTrans_Content.childCount-1 do
        gfdestroy(self.mView.mTrans_Content:GetChild(i))
    end

    for i = 0, list.Count-1 do
        local data = list[i]
        local item = nil

        local obj = instantiate(prefab)
        item = UISimCombatTeachingRewardItemV2.New()
        UIUtils.AddListItem(obj, self.mView.mTrans_Content.transform)
        item:InitCtrl(obj.transform)
        UIUtils.GetButtonListener(item.mBtn_Receive.gameObject).onClick = function(gObj)
            self:OnReceiveItem(item)
        end
                
        item:SetData(data); 
    end
end

function UISimCombatTeachingRewardPanel:OnReceiveItem(item)
    NetCmdSimulateBattleData:ReqSimCombatTutorialTakeChapterReward(item.mData.StcData.id,function()
        self:TakeQuestRewardCallBack()
    end)
end

function UISimCombatTeachingRewardPanel:TakeQuestRewardCallBack()
    self:UpdatePanel()
    UIManager.OpenUIByParam(UIDef.UICommonReceivePanel)
    MessageSys:SendMessage(CS.GF2.Message.UIEvent.RefreshChapterInfo, nil)

    self:UpdateRedPoint()
    UISimCombatTeachingPanel:UpdateRewardRedPoint();
    UIBattleIndexPanel:UpdateRedPoint()
end




