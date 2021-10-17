require("UI.UIBaseCtrl")
require("UI.GuildPanel.Item.UIGuildListItem")

UIJoinGuildItem = class("UIJoinGuildItem", UIGuildContentBase);
UIJoinGuildItem.__index = UIJoinGuildItem

UIJoinGuildItem.PrefabPath = "Guild/UIJoinGuildItem.prefab"
UIJoinGuildItem.Type = UIGuildGlobal.PanelType.JoinGuild

UIJoinGuildItem.curTag = 0
UIJoinGuildItem.tagList = {}
UIJoinGuildItem.guildList = nil
UIJoinGuildItem.guildItemList = nil
UIJoinGuildItem.guildName = ""
UIJoinGuildItem.guildNotice = ""
UIJoinGuildItem.searchMode = false

--- const
UIJoinGuildItem.mPath_UICommonItemS = "UICommonFramework/UICommonItemS.prefab"
--- const

function UIJoinGuildItem:ctor()
    UIJoinGuildItem.super.ctor(self)
    UIJoinGuildItem.tagList = {}
    UIJoinGuildItem.curTag = 0
    UIJoinGuildItem.tagList = {}
    UIJoinGuildItem.guildList = nil
    UIJoinGuildItem.guildItemList = nil
    UIJoinGuildItem.guildName = ""
    UIJoinGuildItem.guildNotice = ""
end

function UIJoinGuildItem:__InitCtrl()
    self.mTrans_GuildList = self:GetRectTransform("Con_Content/Con_FindGuild/Scroll_GuildList")
    self.mTrans_GuildListContent = self:GetRectTransform("Con_Content/Con_FindGuild")
    self.mTrans_CreateGuild = self:GetRectTransform("Con_Content/Con_CreateGuild")
    self.mTrans_RewardList = self:GetRectTransform("Con_Content/Con_CreateGuild/Con_Cost/Con_Reward")
    self.mTrans_ChangeName = self:GetRectTransform("Con_Content/Con_CreateGuild/Con_GuildName/Btn_Change")
    self.mTrans_ChangeNotice = self:GetRectTransform("Con_Content/Con_CreateGuild/Con_Notice/Btn_Change")
    self.mTrans_Submit = self:GetRectTransform("Con_Content/Con_CreateGuild/Btn_Submit")
    self.mText_GuildName = self:GetText("Con_Content/Con_CreateGuild/Con_GuildName/Image_Bg/Text_Content")
    self.mText_Notice = self:GetText("Con_Content/Con_CreateGuild/Con_Notice/Image_Bg/Text_Content")
    self.mTrans_ChangeNoticePanel = self:GetRectTransform("Con_ChangeNotice")
    self.mTrans_ChangeNamePanel = self:GetRectTransform("Con_ChangeName")
    self.mTrans_CloseChangeNotice = self:GetRectTransform("Con_ChangeNotice/MainPanel/BGPanel/ButtonPanel/Btn_Cancel")
    self.mTrans_CloseChangeName = self:GetRectTransform("Con_ChangeName/MainPanel/BGPanel/ButtonPanel/Btn_Cancel")
    self.mTrans_ConfirmChangeNotice = self:GetRectTransform("Con_ChangeNotice/MainPanel/BGPanel/ButtonPanel/Btn_Confirm")
    self.mTrans_ConfirmChangeName = self:GetRectTransform("Con_ChangeName/MainPanel/BGPanel/ButtonPanel/Btn_Confirm")
    self.mInput_ChangeNotice = self:GetInputField("Con_ChangeNotice/MainPanel/BGPanel/EnterPanel/InputField")
    self.mInput_ChangeName = self:GetInputField("Con_ChangeName/MainPanel/BGPanel/EnterPanel/InputField")
    self.mText_InputField = self:GetInputField("Con_Content/Con_FindGuild/UI_Trans_SearchPanel/EnterPanel/InputField")
    self.mTrans_CostItem = self:GetRectTransform("Con_Content/Con_CreateGuild/Con_Cost/Con_Reward")
    self.mTrans_Submit = self:GetRectTransform("Con_Content/Con_CreateGuild/Btn_Submit")
    self.mTrans_TopSearchPanel = self:GetRectTransform("Con_Content/Con_FindGuild/Trans_TopSearchPanel")
    self.mTrans_SearchPanel = self:GetRectTransform("Con_Content/Con_FindGuild/UI_Trans_SearchPanel")
    self.mBtn_SearchButton = self:GetButton("Con_Content/Con_FindGuild/Trans_TopSearchPanel/UI_Btn_SearchButton")
    self.mBtn_SearchPanel_Cancel = self:GetButton("Con_Content/Con_FindGuild/UI_Trans_SearchPanel/Btn_BGCloseButton")
    self.mBtn_SearchPanel_mBtn_SearchButton = self:GetButton("Con_Content/Con_FindGuild/UI_Trans_SearchPanel/UI_Btn_Search")
    self.mBtn_RefreshButton = self:GetButton("Con_Content/Con_FindGuild/UI_Trans_SearchPanel/UI_Btn_Search")
    self.mVirtualList = UIUtils.GetVirtualList(self.mTrans_GuildList)

    for i = 1, 3 do
        local obj = self:GetRectTransform("Con_TagList/Btn_Tag" .. i)
        local tag = self:InitTagItem(obj, i)
        if tag then
            self.tagList[i] = tag
        end
    end

    self.mText_Notice.text = ""
    self.mText_GuildName.text = ""
end

function UIJoinGuildItem:InitCtrl(parent)
    UIJoinGuildItem.super.InitCtrl(self, parent)

    UIUtils.GetButtonListener(self.mTrans_Submit.gameObject).onClick = function()
        self:OnSubmitClick()
    end

    UIUtils.GetButtonListener(self.mTrans_ChangeName.gameObject).onClick = function()
        self:OnChangeName()
    end

    UIUtils.GetButtonListener(self.mTrans_ChangeNotice.gameObject).onClick = function()
        self:OnChangeNotice()
    end

    UIUtils.GetButtonListener(self.mTrans_CloseChangeNotice.gameObject).onClick = function()
        self:OnCloseChangeNotice()
    end

    UIUtils.GetButtonListener(self.mTrans_CloseChangeName.gameObject).onClick = function()
        self:OnCloseChangeName()
    end

    UIUtils.GetButtonListener(self.mTrans_ConfirmChangeNotice.gameObject).onClick = function()
        self:OnConfirmNotice()
    end

    UIUtils.GetButtonListener(self.mTrans_ConfirmChangeName.gameObject).onClick = function()
        self:OnConfirmName()
    end

    UIUtils.GetButtonListener(self.mBtn_SearchButton.gameObject).onClick = function()
        self:OnClickSearch()
    end

    UIUtils.GetButtonListener(self.mBtn_SearchPanel_Cancel.gameObject).onClick = function()
        self:OnClickCloseSearch()
    end

    UIUtils.GetButtonListener(self.mBtn_RefreshButton.gameObject).onClick = function()
        self:OnRefreshRecommendList()
    end

    UIUtils.GetButtonListener(self.mBtn_SearchPanel_mBtn_SearchButton.gameObject).onClick = function()
        self:OnSearchGuild()
    end

    self:UpdateCreateItem()
end

function UIJoinGuildItem:OnRelease()
    UIJoinGuildItem.super.OnRelease(self)
    UIJoinGuildItem.curTag = 0
    UIJoinGuildItem.tagList = {}
    UIJoinGuildItem.guildList = nil
    UIJoinGuildItem.guildItemList = nil
    UIJoinGuildItem.guildName = ""
    UIJoinGuildItem.guildNotice = ""
    for _, tag in ipairs(UIJoinGuildItem.tagList) do
        tag.isFirstClick = false
    end
end

function UIJoinGuildItem:UpdatePanel(data, parent)
    UIJoinGuildItem.super.UpdatePanel(self, data, parent)
    self:OnClickTag(UIGuildGlobal.TagType.FindGuild)
end

function UIJoinGuildItem:UpdatePanelByTag()
    if self.curTag <= 0 then
        return
    end
    local tag = self.tagList[self.curTag]
    if tag then
        setactive(self.mTrans_GuildListContent, self.curTag == UIGuildGlobal.TagType.FindGuild or self.curTag == UIGuildGlobal.TagType.InviteGuild)
        setactive(self.mTrans_CreateGuild, self.curTag == UIGuildGlobal.TagType.CreateGuild)
        setactive(self.mTrans_TopSearchPanel, self.curTag == UIGuildGlobal.TagType.FindGuild)
        if self.curTag == UIGuildGlobal.TagType.FindGuild then
            if tag.isFirstClick then
                NetCmdGuildData:SendSocialRecommendGuilds()
            else
                self:InitGuildList(NetCmdGuildData:GetRecommendList())
            end
        elseif self.curTag == UIGuildGlobal.TagType.InviteGuild then
            if tag.isFirstClick then
                NetCmdGuildData:SendSocialGetGuildInvitation(function (ret)
                    self:OnGuildListCallBack(ret)
                end)
            else
                self:InitGuildList(NetCmdGuildData:GetApplicationList())
            end
        elseif self.curTag == UIGuildGlobal.TagType.CreateGuild then

        end
    end
end

function UIJoinGuildItem:OnGuildListCallBack(ret)
    if ret == CS.CMDRet.eSuccess then
        self.tagList[self.curTag].isFirstClick = false
        if self.curTag == UIGuildGlobal.TagType.FindGuild then
            self:InitGuildList(NetCmdGuildData:GetRecommendList())
        elseif self.curTag == UIGuildGlobal.TagType.InviteGuild then
            self:InitGuildList(NetCmdGuildData:GetApplicationList())
        end
    end
end

function UIJoinGuildItem:UpdateRecommendGuildList()
    if self.curTag == UIGuildGlobal.TagType.FindGuild then
        self:OnGuildListCallBack(CS.CMDRet.eSuccess)
    end
end

function UIJoinGuildItem:InitTagItem(obj, index)
    local tag = nil
    if obj then
        tag = {}
        tag.obj = obj
        tag.index = index
        tag.isFirstClick = true
        tag.transSelect = UIUtils.GetObject(tag.obj, "UI_Btn_Selected")
        tag.transUnSelect =  UIUtils.GetObject(tag.obj,"UI_Btn_Unselected")

        UIUtils.GetButtonListener(tag.obj.gameObject).onClick = function()
            self:OnClickTag(index)
        end
    end
    return tag
end

function UIJoinGuildItem:OnClickTag(index)
    if index == self.curTag then
        return
    end
    local tag = self.tagList[self.curTag]
    if tag then
        setactive(tag.transSelect.gameObject, false)
        setactive(tag.transUnSelect.gameObject, true)
    end
    tag = self.tagList[index]
    if tag then
        setactive(tag.transSelect.gameObject, true)
        setactive(tag.transUnSelect.gameObject, false)
    end
    self.curTag = index

    self:UpdatePanelByTag()
end

function UIJoinGuildItem:OnChangeName()
    setactive(self.mTrans_ChangeNamePanel, true)
end

function UIJoinGuildItem:OnChangeNotice()
    setactive(self.mTrans_ChangeNoticePanel, true)
end

function UIJoinGuildItem:OnCloseChangeName()
    setactive(self.mTrans_ChangeNamePanel, false)
end

function UIJoinGuildItem:OnCloseChangeNotice()
    setactive(self.mTrans_ChangeNoticePanel, false)
end

function UIJoinGuildItem:OnConfirmName()
    if self.mInput_ChangeName.text == "" then
        UIGuildGlobal:PopupHintMessage(60038)
        return
    end
    self.guildName = self.mInput_ChangeName.text
    self.mText_GuildName.text = self.mInput_ChangeName.text
    setactive(self.mTrans_ChangeNamePanel, false)
end

function UIJoinGuildItem:OnConfirmNotice()
    self.guildNotice = self.mInput_ChangeNotice.text
    self.mText_Notice.text = self.mInput_ChangeNotice.text
    setactive(self.mTrans_ChangeNoticePanel, false)
end

function UIJoinGuildItem:OnSubmitClick()
    if self.guildName == "" then
        UIGuildGlobal:PopupHintMessage(60038)
        return
    end
    NetCmdGuildData:SendSocialCreateGuild(self.guildName, self.guildNotice)
end

function UIJoinGuildItem:OnClickSearch()
    setactive(self.mTrans_TopSearchPanel, false)
    setactive(self.mTrans_SearchPanel, true)
    self.searchMode = true
    self.mText_InputField:ActivateInputField()
end

function UIJoinGuildItem:OnRefreshRecommendList()
    NetCmdGuildData:SendSocialRecommendGuilds()
end

function UIJoinGuildItem:OnClickCloseSearch()
    setactive(self.mTrans_TopSearchPanel, true)
    setactive(self.mTrans_SearchPanel, false)
    self.mText_InputField.text = ""
    self.searchMode = false
end

function UIJoinGuildItem:UpdateCreateItem()
    local prefab =  UIUtils.GetGizmosPrefab(self.mPath_UICommonItemS, self)
    local str = TableData.GlobalConfigData.GuildCreationPrice
    if str then
        local strArr = string.split(str, ",")
        for _, itemGroup in ipairs(strArr) do
            local data = string.split(itemGroup, ":")
            local instObj = instantiate(prefab);
            local itemS = UICommonItemS.New()
            itemS:InitCtrl(instObj.transform)
            itemS:SetData(tonumber(data[1]),tonumber(data[2]))
            UIUtils.AddListItem(instObj, self.mTrans_CostItem.transform)
        end
    end
end

function UIJoinGuildItem:InitGuildList(list)
    self.guildList = {}
    if list ~= nil and list.Count > 0 then
        for i = 0, list.Count - 1 do
            table.insert(self.guildList, list[i])
        end
    end

    self:UpdateGuildList(self.guildList)
end

function UIJoinGuildItem:UpdateGuildList(list)
    self.mVirtualList.itemProvider = function()
        local item = self:GuildItemProvider()
        return item
    end

    self.mVirtualList.itemRenderer = function(index, renderDataItem)
        self:GuildItemRenderer(index, renderDataItem)
    end

    self.mVirtualList.SkipAutoColumn = false
    self.mVirtualList.numItems = #list
    self.mVirtualList:AutoSetColumnCount(true)
    self.mVirtualList:Refresh()
end

function UIJoinGuildItem:GuildItemProvider()
    local itemView = UIGuildListItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView.mUIRoot.gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIJoinGuildItem:GuildItemRenderer(index, renderDataItem)
    local itemData = self.guildList[index + 1]
    local item = renderDataItem.data

    item:SetData(itemData, self.curTag)

    UIUtils.GetButtonListener(item.mBtn_Flag.gameObject).onClick = function()
        self.mParent:OpenContentByType(UIGuildGlobal.PanelType.GuildInfo, {itemData, true})
    end
end

function UIJoinGuildItem:OnSearchGuild()
    local txt = self.mText_InputField.text

    if(txt == "") then
        MessageBox.Show("很遗憾", "玩家名或Id不能为空!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
        return
    end

    NetCmdGuildData:SendSocialSearchGuild(txt)
end

function UIJoinGuildItem:OnGetApproveResult(msg)
    if msg then
        local result = msg.Sender
        local hint = UIGuildGlobal:GetApplyResult(result)
        CS.PopupMessageManager.PopupString(hint)
    end
    self:InitGuildList(NetCmdGuildData:GetApplicationList())
end