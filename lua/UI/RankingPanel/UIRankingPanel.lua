require("UI.UIBasePanel")
require("UI.RankingPanel.UIRankingPanelView")
require("UI.RankingPanel.Item.UIRankingItem")

UIRankingPanel = class("UIRankingPanel", UIBasePanel)
UIRankingPanel.__index = UIRankingPanel

UIRankingPanel.mView = nil
UIRankingPanel.type = nil
UIRankingPanel.rankList = nil
UIRankingPanel.playerInfo = nil
UIRankingPanel.gunList = nil
UIRankingPanel.gunItemList = {}

function UIRankingPanel:ctor()
    UIRankingPanel.super.ctor(self)
end

function UIRankingPanel.Close()
    self = UIRankingPanel
    UIManager.CloseUI(UIDef.UIRankingPanel)
end

function UIRankingPanel.Init(root, data)
    UIRankingPanel.super.SetRoot(UIRankingPanel, root)

    self = UIRankingPanel
    self.mView = UIRankingPanelView.New()
    self.mView:InitCtrl(self.mUIRoot)
    self.type = data[1]
    self.gunList = data[2]

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UIRankingPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommandCenter.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    MessageSys:AddListener(CS.GF2.Message.RankEvent.LeaderBoard, self.UpdateLeaderBoard)
    MessageSys:AddListener(CS.GF2.Message.RankEvent.RankUpdateEvent, self.UpdateRank)
end

function UIRankingPanel.OnInit()
    self = UIRankingPanel
    if self.type then
        if self.type == UIRankingGlobal.LeaderBoardType.NrtPvpLeaderBoardType then
            self.playerInfo = NetCmdPvPData.PvpInfo
        else
            self.playerInfo = NetCmdRankData:GetRankInfoByType(tonumber(self.type))
        end
        self:UpdatePlayerInfo()

        NetCmdRankData:ReqLeaderBoard(tonumber(self.type))
    end
end

function UIRankingPanel.OnShow()
    self = UIRankingPanel
end

function UIRankingPanel.OnRelease()
    self = UIRankingPanel

    UIRankingPanel.type = nil
    UIRankingPanel.rankList = nil
    UIRankingPanel.playerInfo = nil
    UIRankingPanel.gunList = nil
    UIRankingPanel.gunItemList = {}

    MessageSys:RemoveListener(CS.GF2.Message.RankEvent.LeaderBoard, self.UpdateLeaderBoard)
    MessageSys:RemoveListener(CS.GF2.Message.RankEvent.RankUpdateEvent, self.UpdateRank)
end

function UIRankingPanel.UpdateLeaderBoard()
    self = UIRankingPanel
    self.rankList = NetCmdRankData:GetRankList()
    self:UpdateRankList()
end

function UIRankingPanel:UpdatePlayerInfo()
    if self.type == UIRankingGlobal.LeaderBoardType.NrtPvpLeaderBoardType then
        self:UpdatePVPPlayerInfo()
    else
        self:UpdateNormalPlayerInfo()
    end
end

function UIRankingPanel:UpdateNormalPlayerInfo()
    if self.playerInfo then
        self.mView.mText_PlayerName.text = self.playerInfo.name
        self.mView.mText_PlayerLevel.text = self.playerInfo.level
        self.mView.mImage_Head.sprite = UIUtils.GetIconSprite("Icon/PlayerAvatar", self.playerInfo.icon)
        self.mView.mText_Point.text = self.playerInfo.points

        if self.playerInfo.rankType == 1 then
            local hint = TableData.GetHintById(70035)
            self.mView.mText_Ranking.text = string_format(hint, self.playerInfo.realRank)
        elseif self.playerInfo.rankType == 2 then
            local hint = TableData.GetHintById(70036)
            self.mView.mText_Ranking.text = string_format(hint, self.playerInfo.realRank)
        end
    else
        local roleData = AccountNetCmdHandler:GetRoleInfoData()
        self.mView.mText_PlayerName.text = roleData.Name
        self.mView.mText_PlayerLevel.text = roleData.Level
        self.mView.mImage_Head.sprite = UIUtils.GetIconSprite("Icon/PlayerAvatar", roleData.Icon)
        self.mView.mText_Point.text = 0
        local hint = TableData.GetHintById(70034)
        self.mView.mText_Ranking.text = hint
    end
end

function UIRankingPanel:UpdatePVPPlayerInfo()
    if self.playerInfo then
        local roleData = AccountNetCmdHandler:GetRoleInfoData()
        local hint = TableData.GetHintById(303)
        self.mView.mText_PlayerName.text = roleData.Name
        self.mView.mText_PlayerLevel.text = roleData.Level
        self.mView.mImage_Head.sprite = UIUtils.GetIconSprite("Icon/PlayerAvatar", roleData.Icon)
        self.mView.mText_Point.text = self.playerInfo.point
        self.mView.mText_Ranking.text = (self.playerInfo.rank > 100 or self.playerInfo.rank ~= 0) and self.playerInfo.rank or hint
        self:UpdateGunList(self.gunList)
    end
end

function UIRankingPanel:UpdateGunList(gunList)
    if gunList then
        for i = 1, #self.mView.gunItemList do
            local gunObj = self.mView.gunItemList[i]
            setactive(gunObj.transDetail.gameObject, i <= gunList.Count)
            setactive(gunObj.transUnSet.gameObject, i > gunList.Count)
            if i <= gunList.Count then
                local data = gunList[i - 1]
                if gunObj.gunDetail == nil then
                    local detail = NRTPVPGunItem.New()
                    detail:InitCtrl(gunObj.transDetail.transform)
                    gunObj.gunDetail = detail
                end
                gunObj.gunDetail:SetData(data)
            end
        end
    else
        for i = 1, #self.gunList do
            local gunObj = self.mView.gunItemList[i]
            setactive(gunObj.transDetail.gameObject, false)
            setactive(gunObj.transUnSet.gameObject, true)
        end
    end
end

function UIRankingPanel:UpdateRankList()
    self.mView.mVirtualList.itemProvider = function()
        local item = self:RankItemProvider()
        return item
    end

    self.mView.mVirtualList.itemRenderer = function(index, renderDataItem)
        self:RankItemRenderer(index, renderDataItem)
    end

    self.mView.mVirtualList.numItems = self.rankList.Count
    self.mView.mVirtualList:AutoSetColumnCount(true)
    self.mView.mVirtualList:Refresh()

    setactive(self.mView.mTrans_NoData, self.rankList.Count <= 0)
end

function UIRankingPanel:RankItemProvider()
    local itemView = UIRankingItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView.mUIRoot.gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIRankingPanel:RankItemRenderer(index, renderDataItem)
    local itemData = self.rankList[index]
    local item = renderDataItem.data

    item:SetData(itemData, index)
end

function UIRankingPanel.UpdateRank()
    self = UIRankingPanel
    self.playerInfo = NetCmdRankData:GetRankInfoByType(tonumber(self.type))
end

