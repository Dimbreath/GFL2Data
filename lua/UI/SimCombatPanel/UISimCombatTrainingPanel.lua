require("UI.UIBasePanel")
require("UI.SimCombatPanel.UISimCombatTrainingPanelView")
require("UI.SimCombatPanel.Item.SimCombatTrainingListItem")
require("UI.CombatLauncherPanel.UICombatLauncherPanelItem")

UISimCombatTrainingPanel = class("UISimCombatTrainingPanel", UIBasePanel)
UISimCombatTrainingPanel.__index = UISimCombatTrainingPanel

UISimCombatTrainingPanel.mView = nil

--- dataList
UISimCombatTrainingPanel.stageDataList = {}

UISimCombatTrainingPanel.curStage = nil
UISimCombatTrainingPanel.lastIndex = 0
UISimCombatTrainingPanel.combatLauncher = nil
UISimCombatTrainingPanel.maxLevel = 0
UISimCombatTrainingPanel.nowLevelItem = nil
UISimCombatTrainingPanel.isPlayAni = false

UISimCombatTrainingPanel.itemsTab = nil;

function UISimCombatTrainingPanel:ctor()
    UISimCombatTrainingPanel.super.ctor(self)
end

function UISimCombatTrainingPanel.Open()
    self = UISimCombatTrainingPanel
end

function UISimCombatTrainingPanel.Close()
    self = UISimCombatTrainingPanel
    UIManager.CloseUI(UIDef.SimTrainingListPanel)
end

function UISimCombatTrainingPanel.Hide()
    self = UISimCombatTrainingPanel
    self:Show(false)
end

function UISimCombatTrainingPanel.Init(root, data)
    self = UISimCombatTrainingPanel

    UISimCombatTrainingPanel.super.SetRoot(UISimCombatTrainingPanel, root)

    UISimCombatTrainingPanel.mData = data

    UISimCombatTrainingPanel.mView = UISimCombatTrainingPanelView
    UISimCombatTrainingPanel.mView:InitCtrl(root)

    --- dataList
    UISimCombatTrainingPanel.stageDataList = {}

    UISimCombatTrainingPanel.curStage = nil
    UISimCombatTrainingPanel.combatLauncher = nil
    UISimCombatTrainingPanel.itemsTab = nil
    
    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function(gObj)
        UISimCombatTrainingPanel:onClickExit()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Info.gameObject).onClick = function()
       UISimCombatTrainingPanel:OnClickRewardInfo()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommanderCenter.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Return.gameObject).onClick = function()
        UISimCombatTrainingPanel:OnReturnCurrentLevel()
    end
end

function UISimCombatTrainingPanel.OnInit()
    self = UISimCombatTrainingPanel
    self:InitData()

    NetCmdStageRecordData:RequestStageRecordByType(CS.GF2.Data.StageType.TowerStage, function (ret)
        if ret == CS.CMDRet.eSuccess then
            UISimCombatTrainingPanel:UpdatePanel()
            UISimCombatTrainingPanel:SetEnableMask(false)
        end
    end)

    local data = TableData.listSimCombatEntranceDatas:GetDataById(3)
    self.mView.mText_Title.text = data.name.str
end


function UISimCombatTrainingPanel.OnShow()
    self = UISimCombatTrainingPanel
    self:PlayListFadeIn()
end

function UISimCombatTrainingPanel.OnRelease()
    self = UISimCombatTrainingPanel

    --- dataList
    UISimCombatTrainingPanel.stageDataList = {}

    UISimCombatTrainingPanel.curStage = nil
    UISimCombatTrainingPanel.combatLauncher = nil
    UISimCombatTrainingPanel.isPlayAni = false
end

function UISimCombatTrainingPanel.ClearUIRecordData()
    UIBattleIndexPanel.currentType = -1
    UIChapterInfoPanel.curDiff = 1
end

function UISimCombatTrainingPanel:InitData()
    for i = 0, TableData.listAdvancedTrainingDatas.Count - 1 do
        local data = TableData.listAdvancedTrainingDatas[i]
        if data then
            table.insert(self.stageDataList, data)
        end
    end
end

function UISimCombatTrainingPanel:UpdatePanel()
    self.maxLevel = NetCmdSimulateBattleData:GetAdvancedMaxLevel()
    self.mView.mText_CurrentLevel.text = self.maxLevel < 10 and "0" .. self.maxLevel or self.maxLevel
    self.mView.mText_TotalLevel.text = #self.stageDataList
    self:InitTrainingList()
    self:InitRewardList()
end

function UISimCombatTrainingPanel:OnClickStage(item)
    if item then
        if UISimCombatTrainingPanel.curStage and UISimCombatTrainingPanel.curStage.mData.id == item.mData.id then
            return
        end
        local record = NetCmdStageRecordData:GetStageRecordById(item.stageData.id)
        self:ShowStageInfo(item.stageData, record, item)

        --setactive(self.mView.mTrans_TraningInfo, false)
        for k ,v in ipairs(self.itemsTab) do
            if v == item.mObj then
                UIUtils.GetButton(v,"Trans_Btn_GrpCompleted").interactable = false;
                UIUtils.GetButton(v,"Trans_Btn_GrpNow").interactable = false;
                UIUtils.GetButton(v,"Trans_Btn_GrpLocked").interactable = false;
            else
                UIUtils.GetButton(v,"Trans_Btn_GrpCompleted").interactable = true;
                UIUtils.GetButton(v,"Trans_Btn_GrpNow").interactable = true;
                UIUtils.GetButton(v,"Trans_Btn_GrpLocked").interactable = true;
            end
        end
        
    end
end

function UISimCombatTrainingPanel:ShowNowTraining()
    if self.nowLevelItem then
        self.curStage = nil
        self:OnClickStage(self.nowLevelItem)
        self.isPlayAni = false
        self:SetEnableMask(self.isPlayAni)
    end
end

function UISimCombatTrainingPanel:OnClickRewardInfo()
--[[    local str = TableData.GetHintById(209)
    MessageBox.Show("", str, MessageBox.ShowFlag.eMidBtn, nil, nil, nil);]]
    UIManager.OpenUIByParam(UIDef.UICommonReadmePanel, UIDef.SimTrainingListPanel)
end

function UISimCombatTrainingPanel:InitTrainingList()
    self.mView.mVirtualList.itemProvider = function()
        local item = self:TrainingProvider()
        return item
    end

    self.mView.mVirtualList.itemRenderer = function(index, renderDataItem)
        self:TrainingRenderer(index, renderDataItem)
    end

    self:UpdateTrainingPanel()
end

function UISimCombatTrainingPanel:TrainingProvider()
    local itemView = SimCombatTrainingListItem.New()
    itemView:InitCtrl(self.mView.mTrans_TrainingList.transform)
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView.mUIRoot.gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UISimCombatTrainingPanel:TrainingRenderer(index, renderDataItem)
    local itemData = self.stageDataList[index + 1]
    local item = renderDataItem.data
    item:SetData(itemData, self.maxLevel)

    if self.maxLevel + 1 == item.mData.id then
        self.nowLevelItem = item
    end

    item:SetButtonCallback(function() self:OnClickStage(item) end)

    if item.isUnLock then
        self.lastIndex = item.mData.sequence
    end

    table.insert(self.itemsTab,item.mObj);
end

function UISimCombatTrainingPanel:UpdateTrainingPanel()
    
    self.itemsTab = {}
    self.mView.mVirtualList.numItems = #self.stageDataList
    self.mView.mVirtualList:Refresh()

    TimerSys:DelayCall(0.5, function ()
        self.mView.mVirtualList:ScrollToPos(self.maxLevel + 1, false)
    end)
end

function UISimCombatTrainingPanel:ShowStageInfo(stageData, stageRecord, item)
    UISimCombatTrainingPanel.curStage = item

    if self.combatLauncher == nil then
        self:InitCombatLauncher()
    end
    self.combatLauncher:InitSimTrainingData(stageData, stageRecord, item.mData, self.maxLevel)
    setactive(self.mView.mTrans_CombatLauncher.gameObject, true)
    UITopResourceBar.UpdateParent(self.combatLauncher.mTrans_TopCurrency)
end

function UISimCombatTrainingPanel:InitCombatLauncher()
    local item = UICombatLauncherItem.New()
    item:InitCtrl(self.mView.mTrans_CombatLauncher.gameObject)
    self.combatLauncher = item
    UIUtils.GetButtonListener(item.mBtn_Close.gameObject).onClick = function(gObj)
        UITopResourceBar.UpdateParent(self.mView.mTrans_TopCurrency)
        self:onClickCloseLauncher()
    end
end

function UISimCombatTrainingPanel:onClickCloseLauncher()
    if self.combatLauncher == nil then
        return
    end
    if UISimCombatTrainingPanel.curStage then
        UISimCombatTrainingPanel.curStage = nil
    end
    setactive(self.mView.mTrans_CombatLauncher.gameObject, false)

    for k, v in ipairs(self.itemsTab) do
        UIUtils.GetButton(v, "Trans_Btn_GrpCompleted").interactable = true;
        UIUtils.GetButton(v, "Trans_Btn_GrpNow").interactable = true;
        UIUtils.GetButton(v, "Trans_Btn_GrpLocked").interactable = true;
    end
    --setactive(self.mView.mTrans_TraningInfo, true)
end

function UISimCombatTrainingPanel:InitRewardList()
    local rewardList = self:GetRaidRewardList()
    if rewardList then
        for i, reward in ipairs(rewardList) do
            local item = UICommonItem.New()
            item:InitObj(self.mView.mTrans_RewardItem)
            item:SetItemData(reward.itemId, reward.num)
        end
    else
        setactive(self.mView.mTrans_RewardItem, false)
    end
end

function UISimCombatTrainingPanel:GetRaidRewardList()
    local count = NetCmdItemData:GetResItemCount(GlobalConfig.TrainingTicket)
    if count > 0 then
        if self.maxLevel <= 0 then
            return nil
        end
        local data = TableData.listAdvancedTrainingDatas:GetDataById(self.maxLevel)
        if data then
            local rewardList = {}
            local strReward = data.unlock_raid_reward
            for item, num in pairs(strReward) do
                local reward = {
                    itemId   = tonumber(item),
                    num      = tonumber(num),
                }
                table.insert(rewardList, reward)
            end
            return rewardList
        end
    end
    return nil
end

function UISimCombatTrainingPanel:onClickExit()
    UISimCombatTrainingPanel.Close()
end

function UISimCombatTrainingPanel:SetEnableMask(enable)
    if self.mView.mTrans_Mask then
        setactive(self.mView.mTrans_Mask.gameObject, enable)
    end
end

function UISimCombatTrainingPanel:OnReturnCurrentLevel()
    self.mView.mVirtualList:ScrollToPos(self.maxLevel + 1, true)
end

function UISimCombatTrainingPanel:PlayListFadeIn()
    self:SetEnableMask(true)
    DOTween.DoCanvasFade(self.mView.Scroll_TrainingList, 0, 1, 0.3, 0.5, function ()
        self:SetEnableMask(false)
    end)
end

function UISimCombatTrainingPanel.OnUpdateTop()
    self = UISimCombatTrainingPanel
    if self.combatLauncher ~= nil then
        if self.combatLauncher.raycaster then
            self.combatLauncher.raycaster.enabled = true
        end
        if self.mView.mTrans_CombatLauncher.gameObject.activeSelf then
            self.combatLauncher:UpdatePanel()
            UITopResourceBar.UpdateParent(self.combatLauncher.mTrans_TopCurrency)
        end
    end
end