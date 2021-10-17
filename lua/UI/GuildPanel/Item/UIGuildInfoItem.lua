require("UI.UIBaseCtrl")
require("UI.GuildPanel.Item.UIMemberListItem")

UIGuildInfoItem = class("UIGuildInfoItem", UIGuildContentBase)
UIGuildInfoItem.__index = UIGuildInfoItem

UIGuildInfoItem.PrefabPath = "Guild/UIGuildInfoItem.prefab"
UIGuildInfoItem.Type = UIGuildGlobal.PanelType.GuildInfo

UIGuildInfoItem.avatarList = {}
UIGuildInfoItem.memberList = {}
UIGuildInfoItem.sortList = {}
UIGuildInfoItem.curSortIndex = 0
UIGuildInfoItem.curContent = 0
UIGuildInfoItem.contentList = {}
UIGuildInfoItem.openContentList = {}
UIGuildInfoItem.tagList = {}
UIGuildInfoItem.curTag = 0
UIGuildInfoItem.settingList = {}
UIGuildInfoItem.curSetting = -1
UIGuildInfoItem.curLevel = 0
UIGuildInfoItem.levelInfoList = nil
UIGuildInfoItem.flagDataList = nil
UIGuildInfoItem.flagList = {}
UIGuildInfoItem.curFlag = 0
UIGuildInfoItem.curMember = 0

function UIGuildInfoItem:ctor()
    UIGuildInfoItem.super.ctor(self)
end

function UIGuildInfoItem:__InitCtrl()
    self.mBtn_MemberInfo = self:GetButton("Con_Content/Con_Info/Con_Member")
    self.mBtn_Apply = self:GetButton("Trans_ManagerEnter/Btn_Apply")
    self.mBtn_Setting = self:GetButton("Trans_ManagerEnter/Btn_Apply/Btn_Setting")
    self.mBtn_Save = self:GetButton("Con_Content/UI_Con_Management/Bottom/Btn_Save")
    self.mBtn_RefuseAll = self:GetButton("Con_Content/UI_Con_Management/Bottom/Btn_RefuseAll")
    self.mBtn_Exit = self:GetButton("Con_Content/Con_Info/Btn_Exit")
    self.mBtn_LevelInfo = self:GetButton("Btn_GuildInfoButton/Btn_GuildLevelInfo")
    self.mBtn_EditFlag = self:GetButton("Btn_GuildInfoButton/Btn_EditFlag")
    self.mBtn_SaveFlag= self:GetButton("Con_Content/UI_Con_FlagEditPanel/Bottom/Btn_Save")
    self.mBtn_ChangeNotice = self:GetButton("Con_Content/Con_Info/Con_Notice/Btn_ChangeNotice")
    self.mImage_Icon = self:GetImage("Btn_GuildInfoButton/Image_Flag")
    self.mText_GuildName = self:GetText("Btn_GuildInfoButton/Text_GuildName")
    self.mText_Progress = self:GetText("Btn_GuildInfoButton/Text_Progress")
    self.mText_IDText = self:GetText("Btn_GuildInfoButton/Text_IDText")
    self.mText_GuildLevel = self:GetText("Btn_GuildInfoButton/Text_GuildLevel")
    self.mSlider_Exp = self:GetSlider("Btn_GuildInfoButton/Scrollbar")
    self.mText_Notice = self:GetText("Con_Content/Con_Info/Con_Notice/Text_Notice")
    self.mText_JoinWay = self:GetText("Con_Content/Con_Info/Con_JoinWay/Image_BG/Text_Content")
    self.mText_Leader = self:GetText("Con_Content/Con_Info/Con_Leader/Image_BG/Text_Content")
    self.mText_CreateTime = self:GetText("Con_Content/Con_Info/Con_CreateTime/Image_BG/Text_Content")
    self.mText_MemberNum = self:GetText("Con_Content/Con_Info/Con_MemberNum/Image_BG/Text_Content")
    self.mTrans_MemberList = self:GetRectTransform("Con_Content/Con_Info/Con_Member/Con_MemberList")
    self.mTrans_AvatarTemp = self:GetRectTransform("Con_Content/Con_Info/Con_Member/Con_Avatar")
    self.mTrans_Info = self:GetRectTransform("Con_Content/Con_Info")
    self.mTrans_List = self:GetRectTransform("Con_Content/Con_List")
    self.mTrans_Member = self:GetRectTransform("Con_Content/UI_Con_Member")
    self.mTrans_Apply = self:GetRectTransform("Con_Content/UI_Con_Management")
    self.mTrans_Setting = self:GetRectTransform("Con_Content/UI_Con_Management/UI_Con_SettingPanel")
    self.mText_MemberList_MemberNum = self:GetText("Con_Content/UI_Con_Member/Con_MemberNum/Text_Num")
    self.mSlider_Level = self:GetSlider("Con_Content/UI_Con_Management/UI_Con_SettingPanel/Scrollbar")
    self.mText_Level = self:GetText("Con_Content/UI_Con_Management/UI_Con_SettingPanel/Scrollbar/LevelLimit/Text_LevelLimit")
    self.mTrans_Manager = self:GetRectTransform("Trans_ManagerEnter")
    self.mTrans_LevelInfo = self:GetRectTransform("Con_Content/UI_Con_GuildLevelInfo")
    self.mTrans_LevelInfoList = self:GetRectTransform("Con_Content/UI_Con_GuildLevelInfo/Con_LevelInfoList")
    self.mTrans_ChangeFlag = self:GetRectTransform("Con_Content/UI_Con_FlagEditPanel")
    self.mTrans_FlagList = self:GetRectTransform("Con_Content/UI_Con_FlagEditPanel/Con_FLagList/List")
    self.mTrans_FlagTemp = self:GetRectTransform("Con_Content/UI_Con_FlagEditPanel/Con_FLagList/UIGuildFlagItem")
    self.mTrans_NoticeChange = self:GetRectTransform("UI_Trans_PostEditPanel")
    self.mBtn_ChangeCancel = self:GetButton("UI_Trans_PostEditPanel/MainPanel/BGPanel/ButtonPanel/Btn_Cancel")
    self.mBtn_ChangeConfirm = self:GetButton("UI_Trans_PostEditPanel/MainPanel/BGPanel/ButtonPanel/Btn_Confirm")
    self.mInput_Notice = self:GetInputField("UI_Trans_PostEditPanel/MainPanel/BGPanel/EnterPanel/InputField")
    self.mBtn_Join = self:GetButton("Con_Content/Con_Info/Btn_Join")

    self.mVirtualList = UIUtils.GetVirtualList(self.mTrans_List)
    self.mLevelInfoList = UIUtils.GetVirtualList(self.mTrans_LevelInfoList)

    for i = 1, 2 do
        local sort = self:GetRectTransform("Con_Content/UI_Con_Member/Trans_SortPanel/UI_Btn_Sort" .. i)
        self:InitSortButton(sort, i)
    end

    self.levelInfoList = TableData.listGuildLevelDatas:GetList()
    self.flagDataList = TableData.listGuildFlagDatas:GetList()
    self:InitApplyTag()
    self:InitApplySetting()
end

function UIGuildInfoItem:InitCtrl(parent)
    UIGuildInfoItem.super.InitCtrl(self, parent)

    UIUtils.GetButtonListener(self.mBtn_MemberInfo.gameObject).onClick = function()
        self:OnClickMemberList()
    end

    UIUtils.GetButtonListener(self.mBtn_Apply.gameObject).onClick = function()
        self:OnClickApplyContent(UIGuildGlobal.GuildApplyTag.ApplyList)
    end

    UIUtils.GetButtonListener(self.mBtn_Setting.gameObject).onClick = function()
        self:OnClickApplyContent(UIGuildGlobal.GuildApplyTag.Setting)
    end

    UIUtils.GetButtonListener(self.mBtn_Save.gameObject).onClick = function()
        self:OnClickSave()
    end

    UIUtils.GetButtonListener(self.mBtn_Exit.gameObject).onClick = function()
        self:OnClickExit()
    end

    UIUtils.GetButtonListener(self.mBtn_LevelInfo.gameObject).onClick = function()
        self:OnClickLevelInfo()
    end

    UIUtils.GetButtonListener(self.mBtn_EditFlag.gameObject).onClick = function()
        self:OnClickChangeFlag()
    end

    UIUtils.GetButtonListener(self.mBtn_SaveFlag.gameObject).onClick = function()
        self:OnClickSaveFlag()
    end

    UIUtils.GetButtonListener(self.mBtn_ChangeNotice.gameObject).onClick = function()
        self:OnClickChangeNotice()
    end

    UIUtils.GetButtonListener(self.mBtn_ChangeCancel.gameObject).onClick = function()
        self:OnClickChangeCancel()
    end

    UIUtils.GetButtonListener(self.mBtn_ChangeConfirm.gameObject).onClick = function ()
        self:OnClickChangeConfirm()
    end

    UIUtils.GetButtonListener(self.mBtn_RefuseAll.gameObject).onClick = function()
        self:OnClickReuseAll()
    end

    UIUtils.GetButtonListener(self.mBtn_Join.gameObject).onClick = function()
        self:OnClickJoinGuild()
    end
end

function UIGuildInfoItem:OnRelease()
    UIGuildInfoItem.super.OnRelease(self)
    UIGuildInfoItem.avatarList = {}
    UIGuildInfoItem.memberList = {}
    UIGuildInfoItem.sortList = {}
    UIGuildInfoItem.curSortIndex = 0
    UIGuildInfoItem.curContent = 0
    UIGuildInfoItem.contentList = {}
    UIGuildInfoItem.openContentList = {}
    UIGuildInfoItem.tagList = {}
    UIGuildInfoItem.curTag = 0
    UIGuildInfoItem.settingList = {}
    UIGuildInfoItem.curSetting = -1
    UIGuildInfoItem.curLevel = 0
    UIGuildInfoItem.levelInfoList = nil
    UIGuildInfoItem.flagDataList = nil
    UIGuildInfoItem.flagList = {}
    UIGuildInfoItem.curFlag = 0
    UIGuildInfoItem.curMember = 0

    MessageSys:RemoveListener(CS.GF2.Message.GuildEvent.ApproveResult, handler(self, self.OnGetApproveResult))
    MessageSys:RemoveListener(CS.GF2.Message.GuildEvent.UpdateGuildMemberList, handler(self, self.OnUpdateMemberList))
end

function UIGuildInfoItem:UpdatePanel(data, parent)
    if data and parent then
        UIGuildInfoItem.super.UpdatePanel(self, data, parent)
        if self.mData then
            self.mData = data[1]
            self.isSearch = data[2]
            local icon = TableData.GetGuildFlagByID(self.mData.flag)
            self.mImage_Icon.sprite = IconUtils.GetFlagIcon(icon)
            self.mText_GuildName.text = self.mData.name
            self.mText_GuildLevel.text = self.mData.level
            self.mText_IDText.text = self.mData.id
            self.mText_Notice.text = self.mData.notice == "" and UIGuildGlobal.NoticeTip or self.mData.notice
            self.mText_Leader.text = self.mData.leaderName
            self.mText_JoinWay.text = UIGuildGlobal:GetJoinCondition(self.mData.applyType, self.mData.applyLevel)
            self.mText_CreateTime.text = self.mData:TranslateTime()
            self.mText_MemberNum.text = UIGuildGlobal:GetMemberNum(self.mData.level, self.mData.memberCount)

            self:UpdateGuildExp()
            self:UpdateManagerList()

            self.mBtn_MemberInfo.interactable = (not data[2])
            self.mBtn_Join.interactable = true

            self:OpenContentByType(UIGuildGlobal.SubPanelType.GuildInfo)
            setactive(self.mTrans_List.gameObject, false)
        end
    end
end

function UIGuildInfoItem:OpenContentByType(type)
    if self.curContent ~= UIGuildGlobal.SubPanelType.GuildInfo then
        self:CloseContent()
    end

    UIGuildInfoItem.super.OpenContentByType(self, type)
    local title = self.isSearch and UIGuildGlobal.GuildTitleType.None or NetCmdGuildData:GetSelfMemberData().title
    setactive(self.mTrans_List.gameObject, type == UIGuildGlobal.SubPanelType.MemberList)
    setactive(self.mTrans_Manager.gameObject, type == UIGuildGlobal.SubPanelType.GuildInfo and UIGuildGlobal:IsManager(title))
    setactive(self.mBtn_EditFlag.gameObject, UIGuildGlobal:IsManager(title))
    setactive(self.mBtn_Exit.gameObject, title ~= UIGuildGlobal.GuildTitleType.None)
    setactive(self.mBtn_Join.gameObject, title == UIGuildGlobal.GuildTitleType.None)
    setactive(self.mBtn_LevelInfo.gameObject, title ~= UIGuildGlobal.GuildTitleType.None)
    setactive(self.mBtn_ChangeNotice.gameObject, title ~= UIGuildGlobal.GuildTitleType.None)
end

function UIGuildInfoItem:RefreshPanel()
    UIGuildInfoItem.super.RefreshPanel(self)
    local title = self.isSearch and UIGuildGlobal.GuildTitleType.None or NetCmdGuildData:GetSelfMemberData().title
    setactive(self.mTrans_Manager.gameObject, self.curContent == UIGuildGlobal.SubPanelType.GuildInfo and UIGuildGlobal:IsManager(title))
    setactive(self.mBtn_EditFlag.gameObject, UIGuildGlobal:IsManager(title))
    setactive(self.mBtn_Exit.gameObject, title ~= UIGuildGlobal.GuildTitleType.None)
    setactive(self.mBtn_Join.gameObject, title == UIGuildGlobal.GuildTitleType.None)
    setactive(self.mBtn_LevelInfo.gameObject, title ~= UIGuildGlobal.GuildTitleType.None)
    setactive(self.mBtn_ChangeNotice.gameObject, title ~= UIGuildGlobal.GuildTitleType.None)
    self.mText_MemberNum.text = UIGuildGlobal:GetMemberNum(self.mData.level, self.mData.memberCount)
    self.mText_JoinWay.text = UIGuildGlobal:GetJoinCondition(self.mData.applyType, self.mData.applyLevel)
    self:UpdateGuildExp()
    self:UpdateManagerList()
end

function UIGuildInfoItem:CloseContent()
    setactive(self.mTrans_List, false)
    for _, tag in ipairs(self.tagList) do
        tag.isFirstClick = true
    end
    return UIGuildInfoItem.super.CloseContent(self)
end

function UIGuildInfoItem:InitContent()
    UIGuildInfoItem.super.InitContent(self)
    self.contentList[UIGuildGlobal.SubPanelType.GuildInfo] = self.mTrans_Info
    self.contentList[UIGuildGlobal.SubPanelType.MemberList] = self.mTrans_Member
    self.contentList[UIGuildGlobal.SubPanelType.Apply] = self.mTrans_Apply
    self.contentList[UIGuildGlobal.SubPanelType.LevelInfo] = self.mTrans_LevelInfo
    self.contentList[UIGuildGlobal.SubPanelType.ChangeFlag] = self.mTrans_ChangeFlag
end

--- Info
function UIGuildInfoItem:UpdateManagerList()
    for _, item in ipairs(self.avatarList) do
        setactive(item.obj, false)
    end

    local managerList = self.mData:GetManagerList()
    local item = nil
    for i = 0, managerList.Count - 1 do
        local member = managerList[i]
        if i + 1 > #self.avatarList then
            item = self:CreateManagerItem()
            table.insert(self.avatarList, item)
        else
            item = self.avatarList[i + 1]
        end
        self:UpdateManagerItem(item, member)
    end
end

function UIGuildInfoItem:CreateManagerItem()
    local obj = instantiate(self.mTrans_AvatarTemp.gameObject)
    obj.transform:SetParent(self.mTrans_MemberList, false)
    local item = {}
    item.obj = obj
    item.imgAvatar = UIUtils.GetImage(obj, "RoundMask/Image_AvatarImage")
    item.textTitle = UIUtils.GetText(obj, "Image_Title/Text_Title")
    item.imgTitle = UIUtils.GetImage(obj, "Image_Title")

    return item
end

function UIGuildInfoItem:UpdateManagerItem(item, data)
    if item and data then
        item.imgAvatar.sprite = UIUtils.GetIconSprite("Icon/PlayerAvatar", data.roleData.Icon)
        item.textTitle.text = UIGuildGlobal:GetTitleType(data.title)
        item.imgTitle.color = UIGuildGlobal:GetTitleColor(data.title)

        setactive(item.obj, true)
    end
end

function UIGuildInfoItem:OnClickMemberList()
    NetCmdGuildData:SendGuildMemberInfo(function (ret)
        if ret == CS.CMDRet.eSuccess then
            self:OpenContentByType(UIGuildGlobal.SubPanelType.MemberList)
            self:InitMemberList(self.mData:GetMemberList())
            self:OnClickSort(UIGuildGlobal.SortType.Level)
            self.mText_MemberList_MemberNum.text = UIGuildGlobal:GetMemberNum(self.mData.level, self.mData.memberCount)
        end
    end)
end

function UIGuildInfoItem:UpdateGuildExp()
    local levelData = TableData.listGuildLevelDatas
    local curExp = 0
    local nextExp = 0
    if self.mData.level < levelData.Count then
        nextExp = levelData:GetDataById(self.mData.level).levelup_exp
        curExp = self.mData.exp
    end
    self.mText_Progress.text = string_format(UIGuildGlobal.LevelStringTemp, tostring(curExp), tostring(nextExp))
    self.mSlider_Exp.value = curExp / nextExp
end

function UIGuildInfoItem:OnClickExit()
    NetCmdGuildData:SendSocialQuitGuild()
end

function UIGuildInfoItem:OnClickLevelInfo()
    self:OpenContentByType(UIGuildGlobal.SubPanelType.LevelInfo)
    self:InitLevelInfoList(self.levelInfoList)
end

function UIGuildInfoItem:OnClickChangeNotice()
    setactive(self.mTrans_NoticeChange.gameObject, true)
    self.mInput_Notice.text = self.mData.notice
end

function UIGuildInfoItem:OnClickChangeCancel()
    setactive(self.mTrans_NoticeChange.gameObject, false)
    self.mInput_Notice.text = ""
end

function UIGuildInfoItem:OnClickChangeConfirm()
    local text = self.mInput_Notice.text
    if text == self.mData.notice then
        self:OnClickChangeCancel()
        return
    end
    NetCmdGuildData:SendSocialModNotice(text, function ()
        self.mData:SetNotice(text)
        self.mText_Notice.text = text
        self:OnClickChangeCancel()
    end)
end

function UIGuildInfoItem:OnClickJoinGuild()
    NetCmdGuildData:SendSocialApplyJoinGuild(self.mData.id, function ()
        IGuildGlobal:PopupHintMessage(60025)
        self.mBtn_Join.interactable = false
    end)
end
--- Info

--- MemberList
function UIGuildInfoItem:InitSortButton(obj, i)
    local button = {}
    button.transSelect = obj:Find("Trans_Select")
    button.imgArrow = obj:Find("Trans_Arrow"):GetComponent("Image")
    button.txtName = obj:Find("Text_SortText"):GetComponent("Text")
    button.isAscend = true
    button.isSelect = false

    local tempIndex = i
    UIUtils.GetButtonListener(obj.gameObject).onClick = function()
        self:OnClickSort(tempIndex)
    end

    table.insert(self.sortList, button)
end

function UIGuildInfoItem:OnClickSort(type)
    if type and type ~= 0 then
        if self.curSortIndex == type then
            self:OnClickChangeSortFunc()
            return
        end

        local curTag = self.sortList[self.curSortIndex]
        local chooseTag = self.sortList[type]
        if curTag then
            setactive(curTag.transSelect, false)
            curTag.imgArrow.color = UIFriendPanel.WhiteColor
            curTag.txtName.color = UIFriendPanel.WhiteColor
        end
        setactive(chooseTag.transSelect, true)
        chooseTag.imgArrow.color = UIFriendPanel.BlackColor
        chooseTag.txtName.color = UIFriendPanel.BlackColor
        self.curSortIndex = type

        self:SortListByType(chooseTag)
    end
end

function UIGuildInfoItem:OnClickChangeSortFunc()
    local curSort = self.sortList[self.curSortIndex]
    if curSort then
        curSort.isAscend = not curSort.isAscend
        curSort.imgArrow.transform.localEulerAngles = Vector3(0, 0, curSort.isAscend and 180 or 0)
        self:SortListByType(curSort)
    end
end

function UIGuildInfoItem:SortListByType(chooseTag)
    if self.curSortIndex == UIGuildGlobal.SortType.Level then
        table.sort(self.memberList, function (a1, a2)
            if a1.roleData.Level < a2.roleData.Level then
                return chooseTag.isAscend
            elseif a1.roleData.Level == a2.roleData.Level then
                return a1.roleData.UID < a2.roleData.UID
            else
                return not chooseTag.isAscend
            end
        end)
    elseif self.curSortIndex == UIGuildGlobal.SortType.Time then
        table.sort(self.memberList, function (a1, a2)
            if a1.roleData.LastLoginTimeInt < a2.roleData.LastLoginTimeInt then
                return chooseTag.isAscend
            elseif a1.roleData.LastLoginTimeInt == a2.roleData.LastLoginTimeInt then
                return a1.roleData.UID < a2.roleData.UID
            else
                return not chooseTag.isAscend
            end
        end)
    end
    self.mVirtualList:Refresh()
end
--- MemberList

--- Apply and Setting
function UIGuildInfoItem:InitApplyTag()
    for i = 1, 2 do
        local tag = {}
        local obj = self:GetRectTransform("Con_Content/UI_Con_Management/UI_Btn_Tag" .. i)
        tag.obj = obj
        tag.index = i
        tag.isFirstClick = true
        tag.transSelect = UIUtils.GetObject(obj, "Trans_Selected")

        UIUtils.GetButtonListener(obj.gameObject).onClick = function ()
            self:OnClickApplyTag(i)
        end

        self.tagList[i] = tag
    end
end

function UIGuildInfoItem:InitApplySetting()
    for i = 0, 3 do
        local setting = {}
        local obj = self:GetRectTransform("Con_Content/UI_Con_Management/UI_Con_SettingPanel/ApplysettingList/UI_Btn_SetOption" .. (i + 1))
        setting.obj = obj
        setting.index = i
        setting.transSelect = UIUtils.GetObject(obj, "Trans_Selected")

        UIUtils.GetButtonListener(obj.gameObject).onClick = function ()
            self:OnClickSettingTag(i)
        end

        self.settingList[i] = setting
    end

    self.mSlider_Level.minValue = 1
    self.mSlider_Level.maxValue = TableData.GlobalConfigData.CommanderLevel
    self.mSlider_Level.onValueChanged:AddListener(function(value)
        self:OnSliderLevelChange(value)
    end)
end

function UIGuildInfoItem:UpdateApplyContent()
    setactive(self.mTrans_Setting.gameObject, self.curTag == UIGuildGlobal.GuildApplyTag.Setting)
    setactive(self.mTrans_List.gameObject, self.curTag == UIGuildGlobal.GuildApplyTag.ApplyList)
    if self.curTag == UIGuildGlobal.GuildApplyTag.ApplyList then
        if  self.tagList[self.curTag].isFirstClick then
            NetCmdGuildData:SendSocialGetGuildApplication(function ()
                self.tagList[self.curTag].isFirstClick = false
                self:InitMemberList(NetCmdGuildData:GetUserApplicationList())
            end)
        else
            self:InitMemberList(NetCmdGuildData:GetUserApplicationList())
        end
    elseif self.curTag == UIGuildGlobal.GuildApplyTag.Setting then
        self:UpdateSettingContent()
    end
    setactive(self.mBtn_Save.gameObject, self.curTag == UIGuildGlobal.GuildApplyTag.Setting)
    setactive(self.mBtn_RefuseAll.gameObject, self.curTag == UIGuildGlobal.GuildApplyTag.ApplyList)
end

function UIGuildInfoItem:UpdateSettingContent()
    self:OnClickSettingTag(self.mData.applyType)
    self.mSlider_Level.value = self.mData.applyLevel
    self.curLevel = self.mData.applyLevel
    self.mText_Level.text = string.format("%u", self.mData.applyLevel)
end

function UIGuildInfoItem:OnClickApplyTag(index)
    local tag = nil
    if self.curTag and self.curTag > 0 then
        tag = self.tagList[self.curTag]
        setactive(tag.transSelect, false)
    end
    tag = self.tagList[index]
    setactive(tag.transSelect, true)
    self.curTag = index

    self:UpdateApplyContent()
end

function UIGuildInfoItem:OnClickSettingTag(index)
    local setting = nil
    if self.curSetting and self.curSetting >= 0 then
        setting = self.settingList[self.curSetting]
        setactive(setting.transSelect, false)
    end
    setting = self.settingList[index]
    setactive(setting.transSelect, true)
    self.curSetting = index
end

function UIGuildInfoItem:OnClickSave()
    NetCmdGuildData:SendSocialEditApplyRequest(self.curLevel, self.curSetting, function ()
        self.mData:SetApplyLevelAndType(self.curSetting, self.curLevel)
        self:CloseContent()
    end)
end

function UIGuildInfoItem:OnClickApplyContent(type)
    self:OpenContentByType(UIGuildGlobal.SubPanelType.Apply)
    self:OnClickApplyTag(type)
end

function UIGuildInfoItem:OnSliderLevelChange(level)
    self.mText_Level.text = string.format("%u", tostring(level))
    self.curLevel = level
end

function UIGuildInfoItem:OnGetApproveResult(msg)
    if msg then
        local result = msg.Sender
        local hint = UIGuildGlobal:GetApplyResult(result)
        CS.PopupMessageManager.PopupString(hint)
    end
    self:UpdateApplyContent()
end

function UIGuildInfoItem:OnUpdateMemberList()
    self:RefreshList()
end

function UIGuildInfoItem:OnClickReuseAll()
    -- NetCmdGuildData:ResAllRejectApplication()
    NetCmdGuildData:SendAllGuildRejectApplication()
end
--- Apply and Setting


--- LevelInfo
function UIGuildInfoItem:InitLevelInfoList(list)
    self.mLevelInfoList.itemProvider = function()
        local item = self:LevelInfoItemProvider()
        return item
    end

    self.mLevelInfoList.itemRenderer = function(index, renderDataItem)
        self:LevelItemRenderer(index, renderDataItem)
    end

    self.mLevelInfoList.SkipAutoColumn = false
    self.mLevelInfoList.numItems = list.Count
    self.mLevelInfoList:AutoSetColumnCount(true)
    self.mLevelInfoList:Refresh()
end

function UIGuildInfoItem:LevelInfoItemProvider()
    local itemView = UIGuildLevelInfoItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView.mUIRoot.gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIGuildInfoItem:LevelItemRenderer(index, renderDataItem)
    local itemData = self.levelInfoList[index]
    local item = renderDataItem.data

    item:SetData(itemData, self.mData.level)
end
--- LevelInfo

--- Flag
function UIGuildInfoItem:UpdateFlagList()
    for _, item in ipairs(self.flagList) do
        setactive(item.obj, false)
    end

    for i = 0, self.flagDataList.Count - 1 do
        local item = nil
        local data = self.flagDataList[i]
        if i + 1 > #self.flagList then
            item = self:InitFlagItem()
            table.insert(self.flagList, item)
        else
            item = self.flagList[i + 1]
        end

        self:UpdateFlagItem(item, data, self.mData.flag)
    end
end

function UIGuildInfoItem:InitFlagItem()
    local obj = instantiate(self.mTrans_FlagTemp.gameObject)
    UIUtils.AddListItem(obj.transform, self.mTrans_FlagList.transform)
    local item = {}
    item.obj = obj
    item.data = nil
    item.transSelect = UIUtils.GetObject(obj, "Btn_Flag/UI_Trans_Selected")
    item.imageIcon = UIUtils.GetImage(obj, "Btn_Flag/Image_FlagIcon")
    item.btnFlag = UIUtils.GetObject(obj, "Btn_Flag")

    UIUtils.GetButtonListener(item.btnFlag.gameObject).onClick = function()
        self:OnClickFlag(item)
    end

    setactive(item.obj, true)
    return item
end

function UIGuildInfoItem:UpdateFlagItem(item, data, curFlag)
    if item and data then
        item.data = data
        item.imageIcon.sprite = IconUtils.GetFlagIcon(data.icon)
        setactive(item.transSelect, curFlag == data.id)

        setactive(item.obj, true)
    end
end

function UIGuildInfoItem:OnClickFlag(item)
    local flag = nil
    if self.curFlag > 0 then
        local flag = self.flagList[self.curFlag]
        setactive(flag.transSelect, false)
    end
    flag = self.flagList[item.data.id]
    setactive(flag.transSelect, true)
    self.curFlag = item.data.id
end

function UIGuildInfoItem:OnClickChangeFlag()
    self:OpenContentByType(UIGuildGlobal.SubPanelType.ChangeFlag)
    self.curFlag = self.mData.flag
    self:UpdateFlagList()
end

function UIGuildInfoItem:OnClickSaveFlag()
    NetCmdGuildData:SendSocialModFlag(self.curFlag, function ()
        self.mData:SetFlag(self.curFlag)
        local icon = TableData.GetGuildFlagByID(self.mData.flag)
        self.mImage_Icon.sprite = IconUtils.GetFlagIcon(icon)
    end)
end
--- Flag

--- List
function UIGuildInfoItem:InitMemberList(list)
    self.memberList = {}
    if list ~= nil and list.Count > 0 then
        for i = 0, list.Count - 1 do
            table.insert(self.memberList, list[i])
        end
    end

    self:UpdateMemberList(self.memberList)
end

function UIGuildInfoItem:UpdateMemberList(list)
    self.mVirtualList.itemProvider = function()
        local item = self:MemberItemProvider()
        return item
    end

    self.mVirtualList.itemRenderer = function(index, renderDataItem)
        self:MemberItemRenderer(index, renderDataItem)
    end

    self.mVirtualList.SkipAutoColumn = false
    self.mVirtualList.numItems = #list
    self.mVirtualList:AutoSetColumnCount(true)
    self.mVirtualList:Refresh()
end

function UIGuildInfoItem:MemberItemProvider()
    local itemView = UIMemberListItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView.mUIRoot.gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIGuildInfoItem:MemberItemRenderer(index, renderDataItem)
    local itemData = self.memberList[index + 1]
    local item = renderDataItem.data

    local title = NetCmdGuildData:GetSelfMemberData().title
    item:SetData(itemData, self.curContent == UIGuildGlobal.SubPanelType.Apply, title, self.curMember)
    if self.curContent == UIGuildGlobal.SubPanelType.Apply then
        UIUtils.GetButtonListener(item.mBtn_Setting.gameObject).onClick = function()
            self.curMember = item.playerInfo.UID
            item:OpenSettingContent()
        end
    end
end

function UIGuildInfoItem:RefreshList()
    self.curMember = 0
    self:InitMemberList(self.mData:GetMemberList())
    local chooseTag = self.sortList[self.curSortIndex]
    self:SortListByType(chooseTag)
    self.mText_MemberList_MemberNum.text = UIGuildGlobal:GetMemberNum(self.mData.level, self.mData.memberCount)
end
--- List