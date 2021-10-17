require("UI.UIBasePanel")
require("UI.GuildPanel.UIGuildPanelView")
require("UI.GuildPanel.Item.UIGuildContentBase")
require("UI.GuildPanel.Item.UIJoinGuildItem")
require("UI.GuildPanel.Item.UIGuildMainItem")
require("UI.GuildPanel.Item.UIGuildInfoItem")
require("UI.GuildPanel.UIGuildGlobal")

UIGuildPanel = class("UIGuildPanel", UIBasePanel)
UIGuildPanel.__index = UIGuildPanel

UIGuildPanel.mView = nil
UIGuildPanel.curContent = 0
UIGuildPanel.guildData = nil
UIGuildPanel.contentList = {}
UIGuildPanel.openContentList = {}
UIGuildPanel.currencyItemList = nil

function UIGuildPanel:ctor()
    UIGuildPanel.super.ctor(self)
end

function UIGuildPanel.Open()
    UIGuildPanel.OpenUI(UIDef.UIGuildPanel)
end

function UIGuildPanel.Close()
    UIManager.CloseUI(UIDef.UIGuildPanel)
end

function UIGuildPanel.Init(root)
    UIGuildPanel.super.SetRoot(UIGuildPanel, root)
end

function UIGuildPanel.OnInit()
    self = UIGuildPanel

    self.mView = UIGuildPanelView.New()
    self.mView:InitCtrl(self.mUIRoot)

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UIGuildPanel:OnReturn()
    end

    MessageSys:AddListener(CS.GF2.Message.GuildEvent.RecommendGuildsData, UIGuildPanel.UpdateRecommendGuildList)
    MessageSys:AddListener(CS.GF2.Message.GuildEvent.GuildQuited, UIGuildPanel.OnGuildQuited)
    MessageSys:AddListener(CS.GF2.Message.GuildEvent.GuildCreated, UIGuildPanel.CreateGuildCallback)
    MessageSys:AddListener(CS.GF2.Message.GuildEvent.ApproveResult, UIGuildPanel.OnGetApproveResult)
    MessageSys:AddListener(CS.GF2.Message.GuildEvent.UpdateGuildMemberList, UIGuildPanel.OnUpdateMemberList)
    MessageSys:AddListener(CS.GF2.Message.GuildEvent.SearchedGuildData, UIGuildPanel.OnSearchCallback)
    MessageSys:AddListener(CS.GF2.Message.GuildEvent.InviteResult, UIGuildPanel.OnInviteCallback)
    MessageSys:AddListener(CS.GF2.Message.GuildEvent.JoinedGuildData, UIGuildPanel.OnGetJoinedGuildData)
    MessageSys:AddListener(CS.GF2.Message.GuildEvent.RefreshGuildData, UIGuildPanel.OnRefreshGuildData)

    self:UpdatePanel()
end

function UIGuildPanel.onShow()
    self = UIGuildPanel
end

function UIGuildPanel.OnRelease()
    self = UIGuildPanel
    for _, content in pairs(UIGuildPanel.contentList) do
        content:OnRelease()
    end

    UIGuildPanel.curContent = 0
    UIGuildPanel.guildData = nil
    UIGuildPanel.contentList = {}
    UIGuildPanel.openContentList = {}
    UIGuildPanel.currencyItemList = nil

    MessageSys:RemoveListener(CS.GF2.Message.GuildEvent.GuildQuited, UIGuildPanel.OnGuildQuited)
    MessageSys:RemoveListener(CS.GF2.Message.GuildEvent.GuildCreated, UIGuildPanel.CreateGuildCallback)
    MessageSys:RemoveListener(CS.GF2.Message.GuildEvent.RecommendGuildsData, UIGuildPanel.UpdateRecommendGuildList)
    MessageSys:RemoveListener(CS.GF2.Message.GuildEvent.ApproveResult, UIGuildPanel.OnGetApproveResult)
    MessageSys:RemoveListener(CS.GF2.Message.GuildEvent.UpdateGuildMemberList, UIGuildPanel.OnUpdateMemberList)
    MessageSys:RemoveListener(CS.GF2.Message.GuildEvent.SearchedGuildData, UIGuildPanel.OnSearchCallback)
    MessageSys:RemoveListener(CS.GF2.Message.GuildEvent.InviteResult, UIGuildPanel.OnInviteCallback)
    MessageSys:RemoveListener(CS.GF2.Message.GuildEvent.JoinedGuildData, UIGuildPanel.OnGetJoinedGuildData)
    MessageSys:RemoveListener(CS.GF2.Message.GuildEvent.RefreshGuildData, UIGuildPanel.OnRefreshGuildData)
end

function UIGuildPanel:UpdatePanel()
    local isJoinGuild = NetCmdGuildData:IsInGuild()
    if isJoinGuild then
        self.guildData = NetCmdGuildData:GetCurGuildData()
        self:OpenContentByType(UIGuildGlobal.PanelType.GuildMain, self.guildData)
        self:UpdateGuildItem()
    else
        self:OpenContentByType(UIGuildGlobal.PanelType.JoinGuild, self.guildData)
    end
    setactive(self.mView.mTrans_TopBar, isJoinGuild)
end

function UIGuildPanel:OpenContentByType(type, data)
    if self.curContent == type then
       return
    end
    if self.curContent > 0 and #self.openContentList > 0 then
        local type = self.openContentList[#self.openContentList]
        self.contentList[type]:OnEnable(false)
    end
    self:UpdateContent(type, data)
    table.insert(self.openContentList, type)
    self.curContent = type
end

function UIGuildPanel:OnReturn()
    if self.openContentList and self.openContentList[#self.openContentList] then
        local type = self.openContentList[#self.openContentList]
        if self.contentList[type] then
            if self.contentList[type]:CloseContent() then
                return
            else
                self.contentList[type]:OnEnable(false)
            end
        end
        table.remove(self.openContentList, #self.openContentList)
        if #self.openContentList <= 0 then
            self.curContent = 0
            self.Close()
        else
            type = self.openContentList[#self.openContentList]
            if self.contentList[type] then
                self.contentList[type]:OnEnable(true)
                self.curContent = type
                self.contentList[type]:RefreshPanel()
            end
        end
    end
end

function UIGuildPanel:ClearOpenList()
    for _, item in pairs(self.contentList) do
        item:ClearOpenList()
        item:OnEnable(false)
    end
    self.openContentList = {}
    self.curContent = 0
end

function UIGuildPanel:InitGuildItemList()
    self.currencyItemList = {}
    local list = TableData.GlobalSystemData.GuildCurrency
    for i = 0, list.Count - 1 do
        local itemId = list[i]
        local data = TableData.listItemDatas:GetDataById(itemId)
        if i + 1 > #self.currencyItemList then
            local item = self:InitGuildItem(data)
            table.insert(self.currencyItemList, item)
        end
    end
end

function UIGuildPanel:InitGuildItem(data)
    local obj = instantiate(self.mView.mTrans_ResItemTemp.gameObject)
    obj.transform:SetParent(self.mView.mTrans_ResList, false)
    local item = {}
    item.obj = obj
    item.data = data
    item.imgIcon = UIUtils.GetImage(obj, "Btn_ShowTips/Image_ResourceIcon")
    item.textNum = UIUtils.GetText(obj, "Text_Num")
    item.btnTips = UIUtils.GetObject(obj, "Btn_ShowTips")
    item.imgIcon.sprite = IconUtils.GetItemIconSprite(data.id)

    setactive(item.obj, true)

    return item
end

function UIGuildPanel:UpdateGuildItem()
    if self.currencyItemList == nil then
        self:InitGuildItemList()
    end

    for _, item in ipairs(self.currencyItemList) do
        local count = NetCmdGuildData:GetGuildItemCount(item.data.id)
        item.textNum.text = count

        TipsManager.Add(item.btnTips.gameObject, item.data, count, false)
    end
end

function UIGuildPanel:UpdateContent(type, data)
    if self.contentList[type] == nil then
        local content = nil
        if type == UIGuildGlobal.PanelType.JoinGuild then
            content = UIJoinGuildItem.New()
        elseif type == UIGuildGlobal.PanelType.GuildMain then
            content = UIGuildMainItem.New()
        elseif type == UIGuildGlobal.PanelType.GuildInfo then
            content = UIGuildInfoItem.New()
        end
        self.contentList[type] = content
        self.contentList[type]:InitCtrl(self.mView.mTrans_Content)
    end
    self.contentList[type]:UpdatePanel(data, self)
    self.contentList[type]:OnEnable(true)
end

function UIGuildPanel.CreateGuildCallback()
    self = UIGuildPanel
    self:ClearOpenList()
    self:UpdatePanel()
    printstack("创建公会")
end

function UIGuildPanel.OnGuildQuited()
    self = UIGuildPanel
    self:ClearOpenList()
    self:UpdatePanel()
end

function UIGuildPanel.UpdateRecommendGuildList()
    self = UIGuildPanel
    local content = self.contentList[UIGuildGlobal.PanelType.JoinGuild]
    if content then
        content:UpdateRecommendGuildList()
    end
end

function UIGuildPanel.OnUpdateMemberList()
    self = UIGuildPanel
    local content = self.contentList[UIGuildGlobal.PanelType.GuildInfo]
    if content then
        content:OnUpdateMemberList()
    end
end

function UIGuildPanel.OnGetApproveResult(msg)
    self = UIGuildPanel
    local content = self.contentList[UIGuildGlobal.PanelType.GuildInfo]
    if content then
        content:OnGetApproveResult(msg)
    end
end

function UIGuildPanel.OnSearchCallback()
    self = UIGuildPanel
    local data = NetCmdGuildData:GetSearchResult()
    if data then
        self:OpenContentByType(UIGuildGlobal.PanelType.GuildInfo, {data, true})
    else
        UIGuildGlobal:PopupHintMessage(60039)
    end
end

function UIGuildPanel.OnInviteCallback(msg)
    self = UIGuildPanel
    local content = self.contentList[UIGuildGlobal.PanelType.JoinGuild]
    if content then
        content:OnGetApproveResult(msg)
    end
end

function UIGuildPanel.OnGetJoinedGuildData()
    self = UIGuildPanel
    self:UpdatePanel()
end

function UIGuildPanel.OnRefreshGuildData()
    self = UIGuildPanel
    self:ClearOpenList()
    self:UpdatePanel()
end

