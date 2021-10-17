require("UI.UIBasePanel")
require("UI.PVP.UINRTPVPPanelView")
require("UI.PVP.Item.NRTPVPOpponentItem")
require("UI.PVP.Item.UIPVPGradeUpItem")
require("UI.PVP.Item.UIPVPSettleItem")

UINRTPVPPanel = class("UINRTPVPPanel", UIBasePanel)
UINRTPVPPanel.__index = UINRTPVPPanel

UINRTPVPPanel.pvpData = nil
UINRTPVPPanel.pvpMarchData = nil
UINRTPVPPanel.pvpHistoryData = nil
UINRTPVPPanel.curBtn = nil
UINRTPVPPanel.pvpLevelChangePanel = nil
UINRTPVPPanel.timer = nil
UINRTPVPPanel.countDownTime = 0
UINRTPVPPanel.opponentList = {}
UINRTPVPPanel.reqHistoryListFlag = false
UINRTPVPPanel.checkStep = 0
UINRTPVPPanel.isHide = false

function UINRTPVPPanel:ctor()
    UINRTPVPPanel.super.ctor(self)
end

function UINRTPVPPanel.Close()
    UIManager.CloseUI(UIDef.UINRTPVPPanel)
end

function UINRTPVPPanel.OnRelease()
    self = UINRTPVPPanel
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end

    if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
    end

    self.pvpData = nil
    self.pvpMarchData = nil
    self.pvpHistoryData = nil
    self.curBtn = nil
    self.pvpLevelChangePanel = nil
    self.timer = nil
    self.countDownTime = 0
    self.opponentList = {}
    self.reqHistoryListFlag = false

    -- MessageSys:RemoveListener(CS.GF2.Message.ModelDataEvent.StaminaChange,self.OnStaminaChange);
end


function UINRTPVPPanel.Init(root)
    UINRTPVPPanel.super.SetRoot(UINRTPVPPanel, root)

    self = UINRTPVPPanel
    self.pvpData = NetCmdPvPData.PvpInfo
    self.pvpMarchData = NetCmdPvPData.PvpMarchInfo
    self.pvpCost = TableData.GlobalSystemData.PvpCost
    self.isHide = false

    self.mView = UINRTPVPPanelView.New()
    self.mView:InitCtrl(root)

    self:InitVirtualList()
    self:InitTypeButton()

    -- MessageSys:AddListener(CS.GF2.Message.ModelDataEvent.StaminaChange, self.OnStaminaChange)
end

function UINRTPVPPanel:InitVirtualList()
    self.mView.mVirtualList.itemProvider = function()
        local item = self:HistoryProvider()
        return item
    end

    self.mView.mVirtualList.itemRenderer = function(index, renderDataItem)
        self:HistoryRenderer(index, renderDataItem)
    end
end

function UINRTPVPPanel:HistoryProvider()
    local itemView = NRTPVPOpponentItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView.mUIRoot.gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UINRTPVPPanel:HistoryRenderer(index, renderDataItem)
    local itemData = self.pvpHistoryData[index]
    local item = renderDataItem.data
    item:SetData(itemData, UIPVPGlobal.PVPBattleType.Revenge)

    UIUtils.GetButtonListener(item.mBtn_Revenge.gameObject).onClick = function()
        self:OnStartPVP(item)
    end
end

function UINRTPVPPanel:InitTypeButton()
    for _, button in ipairs(self.mView.buttonList) do
        UIUtils.GetButtonListener(button.obj).onClick = function()
            self:OnClickTitleButton(button)
        end

        if button.type == UIPVPGlobal.ButtonType.Challenge then
            self:OnClickTitleButton(button)
        end
    end
end

function UINRTPVPPanel.OnInit()
    self = UINRTPVPPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UINRTPVPPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommandCenter.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_DefenseSetting.gameObject).onClick = function()
        UINRTPVPPanel:OnDefenseClick()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_RefreshMarchList.gameObject).onClick = function()
        UINRTPVPPanel:OnClickRefreshMatchList()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_RankList.gameObject).onClick = function()
        UINRTPVPPanel:OnClickRankList()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_SystemInfo.gameObject).onClick = function()
        UINRTPVPPanel:OnClickReadMe()
    end

    self:UpdatePanel()

    self.checkStep = 0
    setactive(self.mView.mTrans_Mask, true)
    self:PVPCheckQueue()
end

function UINRTPVPPanel.OnShow()
    self = UINRTPVPPanel
    if self.isHide then
        self:UpdateListPanel()
        self.isHide = false
    end
end

function UINRTPVPPanel.OnHide()
    self = UINRTPVPPanel
    self.isHide = true
end

function UINRTPVPPanel:PVPCheckQueue()
    self.checkStep = self.checkStep + 1
    if self.checkStep == UIPVPGlobal.CheckQueue.None then
        return
    elseif self.checkStep == UIPVPGlobal.CheckQueue.WeeklySettle then
        self:CheckPVPWeeklySettle()
    elseif self.checkStep == UIPVPGlobal.CheckQueue.RankChange then
        self:CheckPvpLevelIsChange()
    elseif self.checkStep == UIPVPGlobal.CheckQueue.RefreshMatchList then
        self:CheckCanAutoRefreshMatchList()
    elseif self.checkStep == UIPVPGlobal.CheckQueue.KickOut then
        self:CheckKickOut()
    elseif self.checkStep == UIPVPGlobal.CheckQueue.Finish then
        setactive(self.mView.mTrans_Mask, false)
    end
end

function UINRTPVPPanel:CheckPVPWeeklySettle()
    if NetCmdPvPData.weeklySettle then
        local item = UIPVPSettleItem.New()
        item:InitCtrl(self.mUIRoot)
        item:SetData(NetCmdPvPData.weeklySettle.Reward)
    else
        self:PVPCheckQueue()
    end
end

function UINRTPVPPanel:CheckPvpLevelIsChange()
    if NetCmdPvPData.PvpLevelChangeFlag then
        if self.pvpLevelChangePanel == nil then
            self.pvpLevelChangePanel = UIPVPGradeUpItem.New()
            self.pvpLevelChangePanel:InitCtrl(self.mUIRoot)
        end
        local lastLevel = NetCmdPvPData.LastPvpLevel
        local currentLevel = self.pvpData.level

        self.pvpLevelChangePanel:SetData(currentLevel, lastLevel)
    else
        self:PVPCheckQueue()
    end
end

function UINRTPVPPanel:CheckCanAutoRefreshMatchList()
    if self.pvpMarchData == nil then   --- 如果呀，如果后端没有给到匹配的数据的话，前端自己发消息刷一下吧
        NetCmdPvPData:ReqRefreshMatch(false, function ()
            self:OnRefreshMatchCallBack()
            self:PVPCheckQueue()
        end)
        return
    end

    if self.pvpMarchData.isAllWin then
        local hint = TableData.GetHintById(228)
        local content = MessageContent.New(hint, MessageContent.MessageType.SingleBtn, function ()
            NetCmdPvPData:ReqRefreshMatch(false, function ()
                self:OnRefreshMatchCallBack()
                self:PVPCheckQueue()
            end)
        end)
        TimerSys:DelayCall(0.5, function () MessageBoxPanel.Show(content) end)
    else
        self:PVPCheckQueue()
    end
end

function UINRTPVPPanel:CheckKickOut()
    local time = NetCmdPvPData.PVPLastTime
    if time <= 0 then
        if self.closeTimer ~= nil then
            self.closeTimer:Stop()
            self.closeTimer = nil
        end
        local hint = TableData.GetHintById(226)
        local content = MessageContent.New(hint, MessageContent.MessageType.SingleBtn, UINRTPVPPanel.Close)
        MessageBoxPanel.Show(content)
    else
        self.closeTimer = TimerSys:DelayCall(time, function()
            local hint = TableData.GetHintById(226)
            local content = MessageContent.New(hint, MessageContent.MessageType.SingleBtn, UINRTPVPPanel.Close)
            MessageBoxPanel.Show(content)
        end)
        self:PVPCheckQueue()
    end
end

function UINRTPVPPanel:ShowSettleLevelChange()
    if self.pvpLevelChangePanel == nil then
        self.pvpLevelChangePanel = UIPVPGradeUpItem.New()
        self.pvpLevelChangePanel:InitCtrl(self.mUIRoot)
    end
    local lastLevel = NetCmdPvPData.settleLevel
    local currentLevel = NetCmdPvPData.weeklySettle.Rank.Level
    --- just a test
    --lastLevel = 5
    --currentLevel = 1

    self.pvpLevelChangePanel:SetDataBySettle(currentLevel, lastLevel)
end

function UINRTPVPPanel:UpdatePanel()
    if self.pvpData then
        self:UpdateRoleInfo()
    end

    self.mView.mText_Cost.text = string_format(UIPVPGlobal.TextCostRich, TableData.GlobalSystemData.PvpChallengelistRenewCost)
end

function UINRTPVPPanel:UpdateRoleInfo()
    local rankData = TableData.listNrtpvpLevelDatas:GetDataById(self.pvpData.maxLevel)
    local hint = TableData.GetHintById(303)
    self.mView.mText_Point.text = self.pvpData.point
    self.mView.mText_Rank.text = (self.pvpData.rank > 100 or self.pvpData.rank ~= 0) and self.pvpData.rank or hint
    self.mView.mImage_PlayerIcon.sprite = UIUtils.GetIconSprite("Icon/PlayerAvatar", AccountNetCmdHandler:GetAvatar())
    self.mView.mImage_Rank.sprite = IconUtils.GetPvpRankIcon(rankData.icon)
    self.mView.mText_PlayerLv.text = AccountNetCmdHandler:GetLevel()
    self.mView.mText_Attack.text = string.format("%.1f", self.pvpData.weekAtkRate * 100) .. "%"
    self.mView.mText_Defend.text = string.format("%.1f", self.pvpData.weekDefRate * 100) .. "%"
end

function UINRTPVPPanel:UpdateListPanel()
    if self.curBtn then
        if self.curBtn.type == UIPVPGlobal.ButtonType.Challenge then
            self:UpdateChallengePanel()
        elseif self.curBtn.type == UIPVPGlobal.ButtonType.History then
            self:ReqHistoryList()
            setactive(self.mView.mTrans_CanRefresh, false)
            setactive(self.mView.mTrans_CanNotRefresh, false)
        end

        setactive(self.mView.mBtn_RefreshMarchList.gameObject, self.curBtn.type == UIPVPGlobal.ButtonType.Challenge)
        setactive(self.mView.mTrans_HistoryList, self.curBtn.type == UIPVPGlobal.ButtonType.History)
        setactive(self.mView.mTrans_Challenge, self.curBtn.type == UIPVPGlobal.ButtonType.Challenge)
    end
end

function UINRTPVPPanel:UpdateChallengePanel()
    if self.pvpMarchData then
        self.mView.mTrans_ChallengeList.transform.localPosition = vectorone
        for i = 0, self.pvpMarchData.opponentList.Length - 1 do
            local item = nil
            local opponent = self.pvpMarchData.opponentList[i]
            if i + 1 <= #self.opponentList then
                item = self.opponentList[i + 1]
            else
                item = NRTPVPOpponentItem.New()
                item:InitCtrl(self.mView.mTrans_ChallengeList)
                table.insert(self.opponentList, item)
            end
            item:SetData(opponent, UIPVPGlobal.PVPBattleType.Challenge)
            UIUtils.GetButtonListener(item.mBtn_Challenge.gameObject).onClick = function()
                self:OnStartPVP(item)
            end
        end

        self.countDownTime = self.pvpMarchData.countDownTime
        if self.countDownTime > 0 then
            setactive(self.mView.mTrans_CanNotRefresh, true)
            setactive(self.mView.mTrans_CanRefresh, false)
            if self.timer == nil then
                self:UpdateCountDownTime()
            end
        else
            setactive(self.mView.mTrans_CanNotRefresh, false)
            setactive(self.mView.mTrans_CanRefresh, true)
        end
    end
end

function UINRTPVPPanel:UpdateCountDownTime()
    setactive(self.mView.mTrans_CanNotRefresh, true)
    setactive(self.mView.mTrans_CanRefresh, false)
    self.mView.mText_TimeDetail.text = CS.LuaUIUtils.GetTimeStringBySecond(self.countDownTime)
    local repeatCount = self.countDownTime
    self.timer = TimerSys:DelayCall(1, function ()
        if self.countDownTime > 0 then
            self.countDownTime = self.countDownTime - 1
            if self.countDownTime <= 0 then
                setactive(self.mView.mTrans_CanNotRefresh, false)
                setactive(self.mView.mTrans_CanRefresh, true)
                self.countDownTime = 0
                self.timer:Stop()
                self.timer = nil
            end
            self.mView.mText_TimeDetail.text = CS.LuaUIUtils.GetTimeStringBySecond(self.countDownTime)
        end
    end , nil, repeatCount)
end

function UINRTPVPPanel:UpdateHistoryPanel()
    if self.pvpHistoryData.Count <= 0 then
        setactive(self.mView.mTrans_NoHistoryData, true)
        return
    else
        setactive(self.mView.mTrans_NoHistoryData, false)
    end
    self.mView.mVirtualList.numItems = self.pvpHistoryData.Count
    self.mView.mVirtualList:Refresh()
end



function UINRTPVPPanel:OnStartPVP(item)
    if not item.isCanChallenge then
        return
    end

    if GlobalData.GetStaminaResourceItemCount(UIPVPGlobal.NrtPvpTicket) < self.pvpCost then
        printstack("门票不够，回家睡觉~")
        MessageBoxPanel.ShowItemNotEnoughMessage(UIPVPGlobal.NrtPvpTicket, self.OnTicketNeedGotoStoreClicked)
        return
    end

    if item.times >= TableData.GlobalSystemData.PvpBattleMax then
        local hint = TableData.GetHintById(229)
        local content = MessageContent.New(hint, MessageContent.MessageType.DoubleBtn, function () self:StartPVP(item) end)
        MessageBoxPanel.Show(content)
        return
    end

    printstack("id:" .. item.opponentId .. "           " .. "type:" .. item.type)
    self:StartPVP(item)
end

function UINRTPVPPanel:StartPVP(item)
    NetCmdPvPData:ReqNrtPvpLineUpDetail(item.type, item.opponentId, function (ret)
        if ret == CS.CMDRet.eSuccess then
            local defendGunList = item:GetDefendLineUpDetail()
            if defendGunList then
                local stageId = TableData.GlobalSystemData.PvpStageId
                local stageData = TableData.listStageDatas:GetDataById(stageId)

                SceneSys:OpenBattleSceneForPVP(stageData, item.opponentId, item.type, defendGunList)
            end
        end
    end)
end

function UINRTPVPPanel:OnDefenseClick()
    local stageId = TableData.GlobalSystemData.PvpStageId
    local stageData = TableData.listStageDatas:GetDataById(stageId)
    SceneSys:OpenBattleSceneForDefense(stageData)
end

function UINRTPVPPanel:OnClickTitleButton(button)
    if button.type == UIPVPGlobal.ButtonType.Jump then
        self:OnJumpToStore()
        return
    end

    if self.curBtn then
        if self.curBtn.type == button.type then
            return
        end
        setactive(self.curBtn.transSelect, false)
    end
    setactive(button.transSelect, true)
    self.curBtn = button

    self:UpdateListPanel()
end

function UINRTPVPPanel:OnJumpToStore()
    if TipsManager.NeedLockTips(CS.GF2.Data.SystemList.ExchangestorePvp) then
        return
    else
        SceneSwitch:SwitchByID(19, {14})
        -- self.OnTicketNeedGotoStoreClicked()
    end
end

function UINRTPVPPanel:OnClickRefreshMatchList()
    if self.countDownTime > 0 then
        local itemData = TableData.listItemDatas:GetDataById(1)
        local itemCost = TableData.GlobalSystemData.PvpChallengelistRenewCost
        local hint = string_format(TableData.GetHintById(201), itemData.name.str, itemCost)

        local content = MessageContent.New(hint, MessageContent.MessageType.DoubleBtn, function ()
            self:RefreshMatchList(1, itemCost)
        end)

        MessageBoxPanel.Show(content)
    else
        local content = MessageContent.New(TableData.GetHintById(232), MessageContent.MessageType.DoubleBtn, function ()
            NetCmdPvPData:ReqRefreshMatch(false, function ()
                self:OnRefreshMatchCallBack()
            end)
        end)

        MessageBoxPanel.Show(content)
    end
end

function UINRTPVPPanel:RefreshMatchList(itemId, costNum)
    local resNum = NetCmdItemData:GetResItemCount(itemId)
    if resNum < costNum then
        MessageBoxPanel.ShowItemNotEnoughMessage(itemId, self.OnDiamondNeedGotoStoreClicked)
        return
    else
        NetCmdPvPData:ReqRefreshMatch(true, function ()
            self:OnRefreshMatchCallBack()
        end)
    end
end

function UINRTPVPPanel.OnDiamondNeedGotoStoreClicked(gameObj)
    self = UINRTPVPPanel
    SceneSwitch:SwitchByID(5, {1})
    -- QuickStorePurchase.RedirectToStoreTag(1)
end

function UINRTPVPPanel.OnTicketNeedGotoStoreClicked()
    SceneSwitch:SwitchByID(19, {3})
end

--- 只在切页签的时候第一次请求，其他时候只更新数据
function UINRTPVPPanel:ReqHistoryList()
    if not self.reqHistoryListFlag then
        NetCmdPvPData:ReqPvpHistory(function (ret)
            if ret == CS.CMDRet.eSuccess then
                self.reqHistoryListFlag = true
                self:InitHistoryList()
            end
        end)
    else
        self:UpdateHistoryPanel()
    end
end

function UINRTPVPPanel:OnRefreshMatchCallBack()
    printstack("刷新成功")
    self.pvpMarchData = NetCmdPvPData.PvpMarchInfo
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end

    self:UpdateListPanel()
end

function UINRTPVPPanel:InitHistoryList()
    self.pvpHistoryData = NetCmdPvPData.PvpHistoryInfo
    self:UpdateHistoryPanel()
end

function UINRTPVPPanel:OnClickRankList()
    local gunList = NetCmdPvPData:GetDefendLineupSimpleData()
    UIManager.OpenUIByParam(UIDef.UIRankingPanel, {UIRankingGlobal.LeaderBoardType.NrtPvpLeaderBoardType, gunList})
end

function UINRTPVPPanel:OnClickReadMe()
    UIManager.OpenUIByParam(UIDef.UICommonReadmePanel, UIDef.UINRTPVPPanel)
end

--function UINRTPVPPanel.OnStaminaChange(msg)
--    self = UINRTPVPPanel
--    local itemId = msg.Sender
--    if UIPVPGlobal.NrtPvpTicket == itemId then
--        for _, item in ipairs(self.opponentList) do
--            item:RefreshItem()
--        end
--    end
--end


