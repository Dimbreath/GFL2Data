require("UI.UIBaseCtrl")
require("UI.GuildPanel.Item.UIGuildDonationItem")

UIGuildMainItem = class("UIGuildMainItem", UIGuildContentBase)
UIGuildMainItem.__index = UIGuildMainItem

UIGuildMainItem.PrefabPath = "Guild/UIGuildMainPanel.prefab"
UIGuildMainItem.Type = UIGuildGlobal.PanelType.GuildMain

UIGuildMainItem.donationList = {}
UIGuildMainItem.questList = {}
UIGuildMainItem.buffList = {}
UIGuildMainItem.welfareList = nil
UIGuildMainItem.showBuffId = 0
UIGuildMainItem.time = 0

function UIGuildMainItem:ctor()
    UIGuildMainItem.super.ctor(self)
end

function UIGuildMainItem:__InitCtrl()
    self.mText_GuildName = self:GetText("Btn_GuildInfoButton/Text_GuildName")
    self.mText_Progress = self:GetText("Btn_GuildInfoButton/Text_Progress")
    self.mText_IDText = self:GetText("Btn_GuildInfoButton/Text_IDText")
    self.mText_GuildLevel = self:GetText("Btn_GuildInfoButton/Text_GuildLevel")
    self.mSlider_Exp = self:GetSlider("Btn_GuildInfoButton/Scrollbar")
    self.mBtn_GuildQuest = self:GetRectTransform("GuildQuest/Trans_Btn_GotoQuest")
    self.mBtn_GuildInfo = self:GetRectTransform("Btn_GuildInfoButton")
    self.mBtn_GuildDonation = self:GetRectTransform("Trans_Btn_GotoDonation")
    self.mBtn_GuildBuff = self:GetRectTransform("Trans_Btn_GotoBuff")
    self.mTrans_Quest = self:GetRectTransform("Trans_GuildQuestPanel")
    self.mTrans_Donation = self:GetRectTransform("Trans_GuildDonationPanel")
    self.mTrans_Welfare = self:GetRectTransform("Trans_GuildWelfarePanel")
    self.mTrans_DonationList = self:GetRectTransform("Trans_GuildDonationPanel/DonationList/Trans_DonationList")
    self.mText_LeftTime = self:GetText("Trans_GuildDonationPanel/Text_LeftTImes")
    self.mText_DonationTime = self:GetText("Trans_Btn_GotoDonation/Text_DonationTimes")
    self.mTrans_QuestList = self:GetRectTransform("Trans_GuildQuestPanel/QuestList/Trans_QuestList")
    self.mImage_Flag = self:GetImage("Btn_GuildInfoButton/Image_Flag")
    self.mImage_Degree = self:GetImage("GuildQuest/Trans_Btn_GotoQuest/MissionCompletion/Image_Degree")
    self.mText_Percent = self:GetText("GuildQuest/Trans_Btn_GotoQuest/MissionCompletion/Text_Percent")
    self.mTrans_QuestClear = self:GetRectTransform("GuildQuest/Trans_Btn_GotoQuest/Trans_MissionClear")
    self.mBtn_GotoShop = self:GetButton("Trans_Btn_GotoShop")
    self.mTrans_WelfareList = self:GetRectTransform("Trans_GuildWelfarePanel/WelfareList/Trans_WelfareList")
    self.mText_BuffAmount = self:GetText("Trans_Btn_GotoBuff/Text_BuffAmount")
    self.mText_LastTime = self:GetText("Trans_Btn_GotoBuff/Text_LeftTime")
    self.mTrans_BuffList = self:GetRectTransform("Con_BuffList")
    self.mTrans_BuffListContent = self:GetRectTransform("Con_BuffList/content")
    self.mTrans_BuffTemp = self:GetRectTransform("Con_BuffList/Con_Buff")
    self.mText_BuffLeftTime = self:GetText("Trans_Btn_GotoBuff/Text_LeftTime")
    self.mTrans_NoBuff = self:GetRectTransform("Trans_Btn_GotoBuff/Trans_NoWelfare")
    self.mText_MissionDesc = self:GetText("GuildQuest/Trans_Btn_GotoQuest/Text_MissionDescription")
    self.mTrans_MissionRedPoint = self:GetRectTransform("GuildQuest/Trans_Btn_GotoQuest/Trans_MissionRedPoint")
    -- self.mSlider_Time = self:GetSlider("Scrollbar")
    self.mPageScroll = UIUtils.GetPageScroll(self.mTrans_BuffList)
end

function UIGuildMainItem:InitCtrl(parent)
    UIGuildMainItem.super.InitCtrl(self, parent)

    UIUtils.GetButtonListener(self.mBtn_GuildInfo.gameObject).onClick = function()
        self:OnClickInfo()
    end

    UIUtils.GetButtonListener(self.mBtn_GuildQuest.gameObject).onClick = function()
        self:OnClickContent(UIGuildGlobal.MainSubPanelType.Quest)
    end

    UIUtils.GetButtonListener(self.mBtn_GuildDonation.gameObject).onClick = function()
        self:OnClickContent(UIGuildGlobal.MainSubPanelType.Donation)
    end

    UIUtils.GetButtonListener(self.mBtn_GuildBuff.gameObject).onClick = function()
        self:OnClickContent(UIGuildGlobal.MainSubPanelType.Buff)
    end

    UIUtils.GetButtonListener(self.mBtn_GotoShop.gameObject).onClick = function()
        self:OnClickGotoShop()
    end

    self:OpenContentByType(UIGuildGlobal.MainSubPanelType.Info)
    self:UpdatePanelByType()

    self.mPageScroll:InitPageScroll()
    self.mPageScroll:ResetData()
    self.mPageScroll:SetPageChangedCallback(handler(self, self.OnPageCallback))
    self.mPageScroll:AutoTurnPageInterval(UIGuildGlobal.TimeLoop)

    NetCmdGuildData:SendSocialGuildQuestInfo(function ()
        self:UpdateMainQuest()
    end)
end

function UIGuildMainItem:InitContent()
    UIGuildMainItem.super.InitContent(self)
    self.contentList[UIGuildGlobal.MainSubPanelType.Quest] = self.mTrans_Quest
    self.contentList[UIGuildGlobal.MainSubPanelType.Donation] = self.mTrans_Donation
    self.contentList[UIGuildGlobal.MainSubPanelType.Buff] = self.mTrans_Welfare
    self.contentList[UIGuildGlobal.MainSubPanelType.Info] = self.mUIRoot
end

function UIGuildMainItem:RefreshPanel()
    local icon = TableData.GetGuildFlagByID(self.mData.flag)
    self.mImage_Flag.sprite = IconUtils.GetFlagIcon(icon)
    self.mText_GuildLevel.text = self.mData.level
    self.mText_IDText.text = self.mData.id

    local percent = NetCmdGuildData:GetQuestPercent()
    self.mImage_Degree.fillAmount = percent
    self.mText_Percent.text = string.format("%u", percent)
    setactive(self.mTrans_QuestClear, percent >= 1)
    self:UpdateGuildExp()
    self:UpdateMainWelfareList()
    self:UpdateMainQuest()
end

function UIGuildMainItem:OnRelease()
    UIGuildMainItem.super.OnRelease(self)
    UIGuildMainItem.donationList = {}
    UIGuildMainItem.questList = {}
    UIGuildMainItem.buffList = {}
    UIGuildMainItem.showBuffId = 0
    UIGuildMainItem.time = 0
    if self.welfareList ~= nil then
        for _, item in ipairs(self.welfareList) do
            item:OnRelease()
        end
        UIGuildMainItem.welfareList = nil
    end

end

function UIGuildMainItem:UpdatePanel(guildData, parent)
    if guildData and parent then
        UIGuildMainItem.super.UpdatePanel(self, guildData, parent)
        if self.mData then
            local icon = TableData.GetGuildFlagByID(self.mData.flag)
            self.mImage_Flag.sprite = IconUtils.GetFlagIcon(icon)
            self.mText_GuildName.text = guildData.name
            self.mText_GuildLevel.text = guildData.level
            self.mText_IDText.text = guildData.id

            local percent = NetCmdGuildData:GetQuestPercent()
            self.mImage_Degree.fillAmount = percent
            self.mText_Percent.text = string.format("%u", percent)
            setactive(self.mTrans_QuestClear, percent >= 1)

            self:UpdateGuildExp()

            self:UpdateWelfareList()
            self:UpdateMainWelfareList()
        end
    end
end

function UIGuildMainItem:UpdateGuildExp()
    local levelData = TableData.listGuildLevelDatas
    local curExp = 0
    local nextExp = 0
    if self.mData.level < levelData.Count then
        nextExp = levelData:GetDataById(self.mData.level).levelup_exp
        curExp = self.mData.exp
    end
    self.mText_Progress.text = tostring(curExp) .. "/" .. tostring(nextExp)
    self.mSlider_Exp.value = curExp / nextExp
end

function UIGuildMainItem:OnClickInfo()
    self.mParent:OpenContentByType(UIGuildGlobal.PanelType.GuildInfo, {self.mData, false})
end

function UIGuildMainItem:OnClickContent(type)
    self:OpenContentByType(type, true)
    self:UpdatePanelByType()
end

function UIGuildMainItem:OnPageCallback(index)
    if #self.buffDataList == 0 then
        return
    end
    self.time = 0
    self.mText_BuffAmount.text = string_format(UIGuildGlobal.LevelStringTemp, index, #self.buffDataList)
    self.showBuffId = self.buffDataList[index].id

    local buff = self:GetBuffItemById(self.showBuffId)
    self.mText_BuffLeftTime.text = buff.timeStr
end

function UIGuildMainItem:OnClickGotoShop()
    SceneSwitch:SwitchByID(19, { 0 })
end

function UIGuildMainItem:UpdateMainQuest()
    local list = NetCmdGuildData:GetGuildQuestList()
    if list then
        if list.Count == 0 then
            self.mText_MissionDesc.text = TableData.GetHintById(60033)
        else
            local quest = list[0]
            self.mText_MissionDesc.text = quest.tableData.description.str
            setactive(self.mTrans_MissionRedPoint, quest.isComplete)
        end
    end
end

function UIGuildMainItem:UpdatePanelByType()
    if self.curContent == UIGuildGlobal.MainSubPanelType.Info then
        self:UpdateInfo()
    elseif self.curContent == UIGuildGlobal.MainSubPanelType.Quest then
        NetCmdGuildData:SendSocialGuildQuestInfo(function ()
            self:UpdateQuestList()
        end)
    elseif self.curContent == UIGuildGlobal.MainSubPanelType.Donation then
        self:UpdateDonation()
    elseif self.curContent == UIGuildGlobal.MainSubPanelType.Buff then
        self:UpdateWelfareList()
    end
end

function UIGuildMainItem:UpdateInfo()
    self.mText_DonationTime.text = NetCmdGuildData.GuildDonationRemainTimes
end

function UIGuildMainItem:UpdateQuestList()
    local list = NetCmdGuildData:GetGuildQuestList()
    if list then
        for i = 0, list.Count - 1 do
            local data = list[i]
            local item = nil
            if #self.questList < i + 1 then
                item = UIGuildQuestItem.New()
                item:InitCtrl(self.mTrans_QuestList)
                table.insert(self.questList, item)
            else
                item = self.questList[i + 1]
            end
            item:SetData(data)

            UIUtils.GetButtonListener(item.mBtn_CompleteQuest.gameObject).onClick = function()
                self:OnTakeQuestRewardClick(item)
            end
        end
    end
end

function UIGuildMainItem:UpdateDonation()
    local list = NetCmdGuildData:GetGuildDonationCmdDataList()
    if list then
        for i = 0, list.Count - 1 do
            local data = list[i]
            local item = nil
            if #self.donationList < i + 1 then
                item = UIGuildDonationItem.New()
                item:InitCtrl(self.mTrans_DonationList)
                table.insert(self.donationList, item)
            else
                item = self.donationList[i + 1]
            end
            UIUtils.GetButtonListener(item.mBtn_Donation.gameObject).onClick = function()
                self:OnClickDonation(data.DonationId, data.IsEnough)
            end

            item:SetData(data)
        end
    end

    self.mText_DonationTime.text = NetCmdGuildData.GuildDonationRemainTimes
    self.mText_LeftTime.text = NetCmdGuildData.GuildDonationRemainTimes
end

function UIGuildMainItem:OnTakeQuestRewardClick(item)
    NetCmdGuildData:SendSocialGuildTakeReward(item.mData.tableData.id, function ()
        self:TakeQuestRewardCallBack(item.mData.tableData.guild_reward_list)
    end)
end

function UIGuildMainItem:TakeQuestRewardCallBack(reward)
    self:UpdateQuestList()

    if self.mUICommonReceiveItem == nil then
        self.mUICommonReceiveItem=UICommonReceiveItem.New()
        self.mUICommonReceiveItem:InitCtrl(self.mUIRoot)
        UIUtils.GetButtonListener(self.mUICommonReceiveItem.mBtn_Confirm.gameObject).onClick= function()
            self:CloseTakeQuestRewardCallBack()
        end
    end

    self.mUICommonReceiveItem:SetData(reward)
end

function UIGuildMainItem:CloseTakeQuestRewardCallBack()
    if self.mUICommonReceiveItem~=nil then
        self.mUICommonReceiveItem:SetData(nil)
    end
end

function UIGuildMainItem:OnClickDonation(id, IsEnough)
    local result = ""
    if NetCmdGuildData.GuildDonationRemainTimes <= 0 then
        result = 60032
    else
        if IsEnough then
            NetCmdGuildData:SendSocialGuildDonation(id, function ()
                self:UpdatePanelByType()
                self.mData:UpdateExpByDonation(id)
                NetCmdGuildData:AddGuildItemByDonation(id)
                self:UpdateGuildItem()
            end)
            return
        else
            result = 60031
        end
    end

    IGuildGlobal:PopupHintMessage(result)
end

function UIGuildMainItem:UpdateWelfareList()
    if self.welfareList == nil then
        self:InitWelfareList()
    else
        for _, item in ipairs(self.welfareList) do
            item:UpdateItem()
        end
    end
end

function UIGuildMainItem:InitWelfareList()
    self.welfareList = {}
    local list = TableData.listGuildWelfareDatas:GetList()
    for i = 0, list.Count - 1 do
        local data = list[i]
        local item = UIGuildWelfareItem.New()
        item:InitCtrl(self.mTrans_WelfareList)
        item:SetData(data, self.mData.level, self)

        table.insert(self.welfareList, item)
    end
end

function UIGuildMainItem:GetBuffItemById(id)
    for _, item in ipairs(self.welfareList) do
        if item.mData.id == id then
            return item
        end
    end
    return nil
end

--- Buff
function UIGuildMainItem:UpdateMainWelfareList()
    local list = NetCmdGuildData:GetBuffList()
    local buffList = {}

    for id, time in pairs(list) do
        local buff = {}
        buff.id = id
        buff.time = time
        table.insert(buffList, buff)
    end

    setactive(self.mTrans_NoBuff.gameObject, #buffList == 0)
    setactive(self.mText_BuffLeftTime.gameObject,not (#buffList == 0))
    for _, item in ipairs(self.buffList) do
        setactive(item.obj, false)
    end

    self.buffDataList = buffList
    self:InitBuffInfo( self.buffDataList, self.mTrans_BuffListContent, self.mTrans_BuffTemp)
    self.mPageScroll:ResetData()
    if #self.buffDataList > 0 then
        self.showBuffId = self.buffDataList[1].id
    end
    self.time = 0
    -- self.mSlider_Time.value = 0
    self.mText_BuffAmount.text = string_format(UIGuildGlobal.LevelStringTemp, #self.buffDataList == 0 and 0 or 1, #self.buffDataList)
end

function UIGuildMainItem:InitBuffInfo(data ,root, temp)
    for i = 1, #data do
        if i > #self.buffList then
            local page = nil
            local item = data[i]
            local obj = instantiate(temp)
            obj.transform:SetParent(root, false)
            obj.transform.localPosition = vectorzero
            obj.transform.localScale = vectorone
            setactive(obj, true)
            page = self:InitPageItem(obj, item, i)
            table.insert(self.buffList, page)
        else
            local page = self.buffList[i]
            setactive(page.obj, true)
        end
    end
end

function UIGuildMainItem:InitPageItem(obj, data, pageIndex)
    if not obj or not data then
        return nil
    end

    obj.name = "page_0" .. pageIndex
    local page = {}
    page.obj = obj
    page.index = pageIndex
    page.data = data
    page.txtName = UIUtils.GetText(obj, "Text_BuffName")
    page.imageIcon = UIUtils.GetImage(obj, "Image_BuffIcon")
    page.txtDescription = UIUtils.GetText(obj, "Text_BuffDescription")

    local tableData = TableData.listGuildWelfareDatas:GetDataById(data.id)
    page.txtName.text = tableData.name
    page.txtDescription.text = tableData.description
    page.imageIcon.sprite = IconUtils.GetWelfareIcon(tableData.icon)
    return page
end

function UIGuildMainItem:UpdateBuffTime(id, timeStr)
    if id == self.showBuffId then
        self.time = self.time + 1
        -- self.mSlider_Time.value = self.time / UIGuildGlobal.TimeLoop
        self.mText_BuffLeftTime.text = timeStr
    end
end
