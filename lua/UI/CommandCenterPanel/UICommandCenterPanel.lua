require("UI.UIBasePanel")
require("UI.CommandCenterPanel.UICommandCenterPanelView")
require("UI.UniTopbar.UIUniTopBarPanel")
---@class UICommandCenterPanel : UIBasePanel
UICommandCenterPanel = class("UICommandCenterPanel", UIBasePanel)
UICommandCenterPanel.__index = UICommandCenterPanel

UICommandCenterPanel.mView = nil
UICommandCenterPanel.checkStep = 0
UICommandCenterPanel.bCanClick = true
UICommandCenterPanel.mTrans_Background = nil
UICommandCenterPanel.isPlayAni = false
UICommandCenterPanel.chatTimer = nil
UICommandCenterPanel.chatRefreshTime = 0
UICommandCenterPanel.chatSpeed = 45
UICommandCenterPanel.chatDelay = 4
UICommandCenterPanel.autoRoll = nil
UICommandCenterPanel.bannerList = {}
UICommandCenterPanel.indicatorList = {}

UICommandCenterPanel.RedPointType =
{
    RedPointConst.ChapterReward,
    RedPointConst.Daily,
    RedPointConst.Mails,
    RedPointConst.Notice,
    RedPointConst.Achievement
}

UICommandCenterPanel.CheckQueue =
{
    None = 0,
    NickName = 1,
    Reconnection = 2,
    Poster = 3,
    Notice = 4,
    CheckIn = 5,
    Unlock = 6,
    Guide = 7,
    Finish = 8,
}

function UICommandCenterPanel.Init(root, data)
    UICommandCenterPanel.super.SetRoot(UICommandCenterPanel, root)

    UICommandCenterPanel.mView = UICommandCenterPanelView.New()
    UICommandCenterPanel.mView:InitCtrl(root)
    UICommandCenterPanel.chatRefreshTime = TableData.GlobalSystemData.ChatRefreshCd

    UICommandCenterPanel.mShowSceneObj = true

    UICommandCenterPanel:SetMaskEnable(true)
end

function UICommandCenterPanel.OnInit()
    self = UICommandCenterPanel

    self:InitRedPointObj()
    self:InitButtonGroup()
    self:InitBanner()
    self:InitKeyCode()

    MessageSys:AddListener(CS.GF2.Message.UIEvent.ConversationMsg, UICommandCenterPanel.ConversationMessage)
    MessageSys:AddListener(CS.GF2.Message.UIEvent.ConversationEndMsg, UICommandCenterPanel.ConversationEndMessage)
    MessageSys:AddListener(CS.GF2.Message.CampaignEvent.ResInfoUpdate, UICommandCenterPanel.RefreshInfo)
    MessageSys:AddListener(CS.GF2.Message.UIEvent.SystemUnlockEvent, UICommandCenterPanel.SystemUnLock)

    --- RedPoint
    RedPointSystem:GetInstance():AddRedPointListener(RedPointConst.Chapters, self.mView.mItem_Battle.transRedPoint, nil, self.mView.mItem_Battle.systemId)
    RedPointSystem:GetInstance():AddRedPointListener(RedPointConst.Daily, self.mView.mItem_DailyTask.transRedPoint, nil, self.mView.mItem_DailyTask.systemId)
    RedPointSystem:GetInstance():AddRedPointListener(RedPointConst.Notice, self.mView.mItem_Post.transRedPoint, nil, self.mView.mItem_Post.systemId)
    RedPointSystem:GetInstance():AddRedPointListener(RedPointConst.Mails, self.mView.mItem_Mail.transRedPoint, nil, self.mView.mItem_Mail.systemId)
    RedPointSystem:GetInstance():AddRedPointListener(RedPointConst.Barracks, self.mView.mItem_Barrack.transRedPoint, nil, self.mView.mItem_Barrack.systemId)
    RedPointSystem:GetInstance():AddRedPointListener(RedPointConst.Achievement, self.mView.mItem_PlayerInfo.transRedPoint, nil, self.mView.mItem_PlayerInfo.systemId)
    RedPointSystem:GetInstance():AddRedPointListener(RedPointConst.Chat, self.mView.mItem_Chat.transRedPoint, nil, self.mView.mItem_PlayerInfo.systemId)
    RedPointSystem:GetInstance():AddRedPointListener(RedPointConst.UAV, self.mView.mItem_UAV.transRedPoint, nil, self.mView.mItem_UAV.systemId)
    RedPointSystem:GetInstance():AddRedPointListener(RedPointConst.Friend, self.mView.mItem_Friend.transRedPoint, nil, self.mView.mItem_Friend.systemId)

    self:UpdateRedPoint()

    self:UpdatePlayerInfo()

    -- TimerSys:DelayCall(2, function ()
    --     CS.GuideManager.Instance:PauseGuide()
    -- end)

    -- TimerSys:DelayCall(5, function ()
    --     CS.GuideManager.Instance:UnPauseGuide()
    -- end)
end

function UICommandCenterPanel:InitBanner()
    local count = PostInfoConfig.BannerDataList.Count
    if count == 0 then
        return;
    end
    self.mView.slideShow:StopTimer()
    for i = 1, #self.bannerList do
        self.mView.slideShow:PopLayoutElement()
    end
    self.bannerList = {}
    if count > 2 then
        for i = 0, count - 1 do
            local indicatorObj = instantiate(UIUtils.GetGizmosPrefab("CommandCenter/CommandCenterIndicatorItemV2.prefab", self))
            CS.LuaUIUtils.SetParent(indicatorObj, self.mView.parentIndicator.gameObject);
            table.insert(self.indicatorList, indicatorObj)
            local start = math.floor((count + 1) / 2)
            local current = start + i
            if current >= count then
                current = current - count
            end
            self:InstantiateBanner(PostInfoConfig.BannerDataList[current])
        end
        self.mView.slideShow.startingIndex = math.floor(count / 2);
    elseif count == 2 then
        self:InstantiateBanner(PostInfoConfig.BannerDataList[0])
        self:InstantiateBanner(PostInfoConfig.BannerDataList[1])
        for i = 0, count - 1 do
            local indicatorObj = instantiate(UIUtils.GetGizmosPrefab("CommandCenter/CommandCenterIndicatorItemV2.prefab", self))
            CS.LuaUIUtils.SetParent(indicatorObj, self.mView.parentIndicator.gameObject);
            table.insert(self.indicatorList, indicatorObj)
            self:InstantiateBanner(PostInfoConfig.BannerDataList[i])
        end
        self.mView.slideShow.startingIndex = 2
    else
        self:InstantiateBanner(PostInfoConfig.BannerDataList[0])
        for i = 0, count - 1 do
            local indicatorObj = instantiate(UIUtils.GetGizmosPrefab("CommandCenter/CommandCenterIndicatorItemV2.prefab", self))
            CS.LuaUIUtils.SetParent(indicatorObj, self.mView.parentIndicator.gameObject);
            table.insert(self.indicatorList, indicatorObj)
            self:InstantiateBanner(PostInfoConfig.BannerDataList[i])
        end
        self:InstantiateBanner(PostInfoConfig.BannerDataList[0])
        self.mView.slideShow.startingIndex = 1
        self.mView.slideShow:SetData(1)
    end
    self.mView.slideShow:SetData(count)
end

function UICommandCenterPanel:InstantiateBanner(data)
    local bannerObj = instantiate(UIUtils.GetGizmosPrefab("CommandCenter/CommandcenterBanneItemV2.prefab", self))
    local img = bannerObj.transform:Find("Img_Banner"):GetComponent("Image")
    setactive(img.gameObject, false)
    CS.LuaUtils.DownloadTextureFromUrl(data.pic_url, function(tex)
        setactive(img.gameObject, true)
        img.sprite = CS.UIUtils.TextureToSprite(tex)
    end)
    local button = bannerObj:GetComponent("Button")
    if data.type_id == 0 and data.extra ~= "" then
        UIUtils.GetButtonListener(button.gameObject).onClick = function()
            if string.match(data.extra, "{uid}") then
                local text = string.gsub(data.extra, "{uid}", AccountNetCmdHandler:GetUID())
                local strings = string.split(text, "?")
                CS.GF2.ExternalTools.Browsers.BrowserHandler.Show(strings[1] .. "?token=" .. string.gsub(CS.AesUtils.Encode(strings[2]), "-", ""));
            else
                CS.GF2.ExternalTools.Browsers.BrowserHandler.Show(data.extra)
            end
        end
    elseif data.type_id > 0 and data.jump_id > 0 then
        UIUtils.GetButtonListener(button.gameObject).onClick = function()
            SceneSwitch:SwitchByID(data.jump_id, {data.jump_arg})
        end
    end
    self.mView.slideShow:PushLayoutElement(bannerObj, data.delay)
    table.insert(self.bannerList, bannerObj)
end

function UICommandCenterPanel:InitButtonGroup()
    UIUtils.GetButtonListener(self.mView.mBtn_PlayerInfo.gameObject).onClick      = function() UICommandCenterPanel:OnClickPlayerInfo() end

    UIUtils.GetButtonListener(self.mView.mItem_Chat.btn.gameObject).onClick       = function() UICommandCenterPanel:OnClickChat() end
    UIUtils.GetButtonListener(self.mView.mItem_Chat.btnIcon.gameObject).onClick   = function() UICommandCenterPanel:OnClickChat() end

    UIUtils.GetButtonListener(self.mView.mItem_DailyTask.btn.gameObject).onClick  = function() UICommandCenterPanel:OnClickDailyQuest() end
    UIUtils.GetButtonListener(self.mView.mItem_Friend.btn.gameObject).onClick     = function() UICommandCenterPanel:OnClickFriend() end
    UIUtils.GetButtonListener(self.mView.mItem_Post.btn.gameObject).onClick       = function() UICommandCenterPanel:OnClickPost() end
    UIUtils.GetButtonListener(self.mView.mItem_Mail.btn.gameObject).onClick       = function() UICommandCenterPanel:OnClickMail() end

    UIUtils.GetButtonListener(self.mView.mItem_Archives.btn.gameObject).onClick   = function() UICommandCenterPanel:OnClickArchives() end
    UIUtils.GetButtonListener(self.mView.mItem_Guild.btn.gameObject).onClick      = function() UICommandCenterPanel:OnClickGuild() end
    UIUtils.GetButtonListener(self.mView.mItem_UAV.btn.gameObject).onClick        = function() UICommandCenterPanel:OnClickUAV() end
    UIUtils.GetButtonListener(self.mView.mItem_Repository.btn.gameObject).onClick = function() UICommandCenterPanel:OnClickRepository() end
    UIUtils.GetButtonListener(self.mView.mItem_Exchange.btn.gameObject).onClick   = function() UICommandCenterPanel:OnClickExchangeStore() end

    UIUtils.GetButtonListener(self.mView.mItem_Dorm.btn.gameObject).onClick       = function() UICommandCenterPanel:OnClickDorm() end
    UIUtils.GetButtonListener(self.mView.mItem_PVP.btn.gameObject).onClick        = function() UICommandCenterPanel:OnClickPVP() end
    UIUtils.GetButtonListener(self.mView.mItem_Gacha.btn.gameObject).onClick      = function() UICommandCenterPanel:OnClickGacha() end
    UIUtils.GetButtonListener(self.mView.mItem_Barrack.btn.gameObject).onClick    = function() UICommandCenterPanel:OnClickBarrack() end
    UIUtils.GetButtonListener(self.mView.mItem_Battle.btn.gameObject).onClick     = function() UICommandCenterPanel:OnClickBattle() end

    --- 员工路口相关
    UIUtils.GetButtonListener(self.mView.mBtn_OpenTemporaryPanel.gameObject).onClick  = self.OnTemporaryOpenClicked
    UIUtils.GetButtonListener(self.mView.mBtn_CloseTemporaryPanel.gameObject).onClick = self.OnTemporaryCloseClicked
    UIUtils.GetButtonListener(self.mView.mBtn_StageList.gameObject).onClick  = self.OnStageListClicked
    UIUtils.GetButtonListener(self.mView.mBtn_AVG2.gameObject).onClick       = self.OnAVGTestClicked
    UIUtils.GetButtonListener(self.mView.mBtn_LogOut.gameObject).onClick     = self.OnLogOutClicked
    UIUtils.GetButtonListener(self.mView.mBtn_Jump360.gameObject).onClick    = self.OnJump360
    UIUtils.GetButtonListener(self.mView.mBtn_VideoTest.gameObject).onClick  = self.PlayTestVideo
    UIUtils.GetButtonListener(self.mView.mBtn_Achievement.gameObject).onClick = self.OnAchievementClicked
end

function UICommandCenterPanel:InitKeyCode()
    self:RegistrationKeyboard(KeyCode.Return, self.mView.mItem_Chat.btn)
    self:RegistrationKeyboard(KeyCode.L, self.mView.mItem_DailyTask.btn)
    self:RegistrationKeyboard(KeyCode.U, self.mView.mItem_Friend.btn)
    self:RegistrationKeyboard(KeyCode.O, self.mView.mItem_Post.btn)
    self:RegistrationKeyboard(KeyCode.M, self.mView.mItem_Mail.btn)
    -- self:RegistrationKeyboard(KeyCode.R, self.mView.mItem_Chat.btn)
    self:RegistrationKeyboard(KeyCode.K, self.mView.mItem_Guild.btn)
    self:RegistrationKeyboard(KeyCode.V, self.mView.mItem_UAV.btn)
    self:RegistrationKeyboard(KeyCode.B, self.mView.mItem_Repository.btn)
    self:RegistrationKeyboard(KeyCode.E, self.mView.mItem_Exchange.btn)
    self:RegistrationKeyboard(KeyCode.S, self.mView.mItem_Dorm.btn)
    self:RegistrationKeyboard(KeyCode.P, self.mView.mItem_PVP.btn)
    self:RegistrationKeyboard(KeyCode.G, self.mView.mItem_Gacha.btn)
    self:RegistrationKeyboard(KeyCode.C, self.mView.mItem_Barrack.btn)
end

function UICommandCenterPanel.Close()
    UIManager.CloseUI(UIDef.UICommandCenterPanel)
end

function UICommandCenterPanel.OnShow()
    self = UICommandCenterPanel
    self.isPlayAni = true
    CS.ResUpdateSys.Instance:ForceDownloadUpdatePostData()

    self:UpdateSystemUnLockInfo()
    self:UpdateRedPointByType(RedPointConst.Achievement)
    self:InitChatContent()
    setactive(self.mView.mTrans_Conversation,false)
end

function UICommandCenterPanel.OnHide()
    self = UICommandCenterPanel
    if self.chatTimer then
        self.chatTimer:Stop()
    end
end

function UICommandCenterPanel.OnRelease()
    self = UICommandCenterPanel
    self.mView.slideShow:StopTimer()
    for i = 1, #self.bannerList do
        self.mView.slideShow:PopLayoutElement()
    end
    self.bannerList = {}
    for i = 1, #self.indicatorList do
        gfdestroy(self.indicatorList[i])
    end
    self.indicatorList = {}

    self.mView = nil
    self.ModelPoint = nil
    self.checkStep = 0
    self.isPlayAni = false
    self.autoRoll = nil
    if self.chatTimer then
        self.chatTimer:Stop()
        self.chatTimer = nil
    end

    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.ConversationMsg, UICommandCenterPanel.ConversationMessage)
    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.ConversationEndMsg, UICommandCenterPanel.ConversationEndMessage)
    MessageSys:RemoveListener(CS.GF2.Message.CampaignEvent.ResInfoUpdate, UICommandCenterPanel.RefreshInfo)
    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.SystemUnlockEvent, UICommandCenterPanel.SystemUnLock)
    -- MessageSys:RemoveListener(65106, UICommandCenterPanel.UavBreakRedPoint)
    -- MessageSys:RemoveListener(65107, UICommandCenterPanel.UavarmUnlockRedPoint)
    -- MessageSys:RemoveListener(65108, UICommandCenterPanel.UavarmLevelUpRedPoint)

    RedPointSystem:GetInstance():RemoveRedPointListener(RedPointConst.Chapters)
    RedPointSystem:GetInstance():RemoveRedPointListener(RedPointConst.Daily)
    RedPointSystem:GetInstance():RemoveRedPointListener(RedPointConst.Notice)
    RedPointSystem:GetInstance():RemoveRedPointListener(RedPointConst.Mails)
    RedPointSystem:GetInstance():RemoveRedPointListener(RedPointConst.Barracks)
    RedPointSystem:GetInstance():RemoveRedPointListener(RedPointConst.Achievement)
    RedPointSystem:GetInstance():RemoveRedPointListener(RedPointConst.Chat)
    RedPointSystem:GetInstance():RemoveRedPointListener(RedPointConst.UAV)
    RedPointSystem:GetInstance():RemoveRedPointListener(RedPointConst.Friend)

    self:UnRegistrationKeyboard(nil)
end

--- 进游顺序检查
function UICommandCenterPanel:CommanderCheckQueue()
    self.checkStep = self.checkStep + 1
    if self.checkStep == UICommandCenterPanel.CheckQueue.None then
        return
    elseif self.checkStep == UICommandCenterPanel.CheckQueue.NickName then
        self:NickPlayerName()
    elseif self.checkStep == UICommandCenterPanel.CheckQueue.Reconnection then
        self:CheckReconnectBattle()
    elseif self.checkStep == UICommandCenterPanel.CheckQueue.Poster then
        self:CheckPoster()
    elseif self.checkStep == UICommandCenterPanel.CheckQueue.Notice then
        self:CheckNotice()
    elseif self.checkStep == UICommandCenterPanel.CheckQueue.CheckIn then
        self:CheckDailyCheckIn()
    elseif self.checkStep == UICommandCenterPanel.CheckQueue.Unlock then
        self:CheckUnlock()
    elseif self.checkStep == UICommandCenterPanel.CheckQueue.Guide then
        self:CheckGuide()
    elseif self.checkStep == UICommandCenterPanel.CheckQueue.Finish then
        self:SetMaskEnable(false)

        MessageSys:SendMessage(CS.GF2.Message.CommonEvent.PlayDefaultConversation,nil)
    end
end

function UICommandCenterPanel:NickPlayerName()
    if not AccountNetCmdHandler:GetRecordFlag(GlobalConfig.RecordFlag.NameModified) then
        UIManager.OpenUIByParam(UIDef.UINickNamePanel, function () self:CommanderCheckQueue() end)
    else
        self:CommanderCheckQueue()
    end
end

function UICommandCenterPanel:CheckReconnectBattle()
    if AccountNetCmdHandler:CheckNeedReconnectBattle(function ()
        self:CommanderCheckQueue()
    end) then
    else
        self:CommanderCheckQueue()
    end
end

function UICommandCenterPanel:CheckPoster()
    if PostInfoConfig.CanShowPost() then
        UIPosterPanel.Open(function() self:CommanderCheckQueue() end)
    else
        self:CommanderCheckQueue()
    end
end

function UICommandCenterPanel:CheckNotice()
    if not (self:CheckSystemIsLock(SystemList.Notice)) then
        if PostInfoConfig.CanShowNotice() then
            UIPostPanelV2.Open(function() self:CommanderCheckQueue() end)
        else
            self:CommanderCheckQueue()
        end
    else
        self:CommanderCheckQueue()
    end
end

function UICommandCenterPanel:CheckDailyCheckIn()
    if not NetCmdCheckInData:IsChecked() then
        CS.NetCmdTimerData.Instance.m_IsNextDay = false
    end
    if not (self:CheckSystemIsLock(SystemList.Checkin)) and not NetCmdCheckInData:IsChecked() then
        NetCmdCheckInData:SendGetDailyCheckInCmd(self.SendCheckInCallback)
    else
        UICommandCenterPanel:CommanderCheckQueue()
    end
end

function UICommandCenterPanel:CheckGuide()
    NetCmdTutorialData:SendTutorialInfo(self.OnTutorialInfoCallback)
end

function UICommandCenterPanel:CheckUnlock()
    if not AccountNetCmdHandler:ContainsUnlockId(UIDef.UICommandCenterPanel) then
        UICommandCenterPanel:CommanderCheckQueue()
    else
        if AccountNetCmdHandler.tempUnlockList.Count > 0 then
            for i = 0, AccountNetCmdHandler.tempUnlockList.Count - 1 do
                local unlockData = TableData.listUnlockDatas:GetDataById(AccountNetCmdHandler.tempUnlockList[i])
                if unlockData.interface_id == UIDef.UICommandCenterPanel then
                    UICommonUnlockPanel.Open(unlockData, function()
                        UICommandCenterPanel:CheckUnlock()
                    end )
                    return
                end
            end
        end
        UICommandCenterPanel:CommanderCheckQueue()
    end
end

function UICommandCenterPanel.SendCheckInCallback(ret)
    self = UICommandCenterPanel
    if(NetCmdCheckInData:IsChecked()) then
        UICommandCenterPanel:CommanderCheckQueue()
    else
        UIManager.OpenUIByParam(UIDef.UIDailyCheckInPanel, function ()
            UICommandCenterPanel:CommanderCheckQueue()
        end)
    end
end

function UICommandCenterPanel.OnTutorialInfoCallback(ret)
    self = UICommandCenterPanel

    CS.GuideManager.Instance:StartOrResumeGuide(1)
    self:CommanderCheckQueue()
end

--- 刷新基础信息
function UICommandCenterPanel.RefreshInfo()
    UICommandCenterPanel:UpdatePlayerInfo()
    UICommandCenterPanel:UpdateSystemUnLockInfo()
end

function UICommandCenterPanel:UpdatePlayerInfo()
    self.mView.mText_PlayerName.text = AccountNetCmdHandler:GetName()
    self.mView.mImage_PlayerAvatar.sprite = IconUtils.GetPlayerAvatar(AccountNetCmdHandler:GetAvatar())
    self.mView.mText_PlayerLevel.text = GlobalConfig.LVText .. AccountNetCmdHandler:GetLevel()
    self.mView.mImage_PlayerExp.fillAmount = AccountNetCmdHandler:GetExpPct()
    self:UpdateStageInfo()
end

function UICommandCenterPanel:UpdateStageInfo()
    local storyData = NetCmdDungeonData:GetCurrentStory()
    if storyData then
        local data = TableData.GetStorysByChapterID(storyData.chapter)
        local total = data.Count * 3
        local stars = NetCmdDungeonData:GetCurStarsByChapterID(storyData.chapter) + NetCmdDungeonData:GetFinishChapterStoryCountByChapterID(storyData.chapter) * 3
        self.mView.mItem_Battle.txtPercent.text = tostring(math.ceil((stars / total) * 100)) .. "%"
        self.mView.mItem_Battle.txtLevel.text = storyData.code
    end
end

--- 看板娘交互
function UICommandCenterPanel.ConversationMessage(msg)
    self = UICommandCenterPanel
    setactive(self.mView.mTrans_Conversation,true)
    setactive(self.mView.mText_Conversation.gameObject, msg.Content ~= nil)
    if msg.Content then
        self.mView.mText_Conversation.text=msg.Content.str
    end

end

function UICommandCenterPanel.ConversationEndMessage(msg)
    self = UICommandCenterPanel
    if self.mView.mDialogAnimator then
        self.mView.mDialogAnimator:SetTrigger("Fadeout")
    end

    TimerSys:DelayCall(0.5, function ()
        if UICommandCenterPanel.mView.mTrans_Conversation then
            setactive(UICommandCenterPanel.mView.mTrans_Conversation,false)
        end
    end)
end

--- 聊天
function UICommandCenterPanel:InitChatContent()
    if self.chatTimer then
        self.chatTimer:Stop()
    end
    self.autoRoll = CS.LuaDOTweenUtils.SetChatRoll(self.mView.mItem_Chat.chatContent, UICommandCenterPanel.chatSpeed, UICommandCenterPanel.chatDelay)
    self:UpdateChatContent()
    self.chatTimer = TimerSys:DelayCall(UICommandCenterPanel.chatRefreshTime, function ()
        self:UpdateChatContent()
    end, nil, -1)
end

function UICommandCenterPanel:UpdateChatContent()
    local data = NetCmdChatData:GetTopMessageInPool()
    if self.mView.mItem_Chat.animator and self.mView.mItem_Chat.txtAnimator then
        if data then
            if not self.mView.mItem_Chat.chatIsOn then
                self.mView.mItem_Chat.animator:SetBool("OnOff", true)
                self.mView.mItem_Chat.chatIsOn = true
            end
            self.mView.mItem_Chat.txtAnimator:SetTrigger("Switch")
            self.mView.mItem_Chat.txtContent.text = data.message
            if self.autoRoll then
                self.autoRoll:ResetAndStart()
            end
        else
            self.mView.mItem_Chat.animator:SetBool("OnOff", false)
            self.mView.mItem_Chat.chatIsOn = false
        end
    end
end

--- 按钮事件

--- 玩家详情
function UICommandCenterPanel:OnClickPlayerInfo()
    self:CallWithAniDelay(function ()
        UIManager.OpenUI(UIDef.UICommanderInfoPanel)
    end)
end

--- 聊天
function UICommandCenterPanel:OnClickChat()
    UIManager.OpenUIByParam(UIDef.UIChatPanel, {nil, true})
end

--- 每日任务
function UICommandCenterPanel:OnClickDailyQuest()
    if TipsManager.NeedLockTips(SystemList.Quest) then
        return
    end

    self:CallWithAniDelay(function ()
        UIManager.OpenUI(UIDef.UIDailyQuestPanel)
    end)
end

--- 好友
function UICommandCenterPanel:OnClickFriend()
    if TipsManager.NeedLockTips(SystemList.Friend) then
        return
    end

    self:CallWithAniDelay(function ()
        UIManager.OpenUI(UIDef.UIFriendPanel)
    end)
end

--- 公告
function UICommandCenterPanel:OnClickPost()
    if TipsManager.NeedLockTips(SystemList.Notice) then
        return
    end
    UIManager.OpenUI(UIDef.UIPostPanelV2)
end

--- 邮件
function UICommandCenterPanel:OnClickMail()
    if TipsManager.NeedLockTips(SystemList.Mail) then
        return
    end
    NetCmdMailData:SendReqRoleMailsCmd(function ()
        UIManager.OpenUI(UIDef.UIMailPanelV2)
    end)
end

--- 档案室
function UICommandCenterPanel:OnClickArchives()
    if TipsManager.NeedLockTips(SystemList.Archives) then
        return
    end
end

--- 公会
function UICommandCenterPanel:OnClickGuild()
    if TipsManager.NeedLockTips(SystemList.Guild) then
        return
    end

    self:CallWithAniDelay(function ()
        NetCmdGuildData:SendSocialGuild(function ()
            UIManager.OpenUI(UIDef.UIGuildPanel)
        end)
    end)
end

--- 机坪
function UICommandCenterPanel:OnClickUAV()
    if TipsManager.NeedLockTips(SystemList.Uav) then
        return
    end
    UIManager.OpenUI(UIDef.UIUAVPanel)
end

--- 仓库
function UICommandCenterPanel:OnClickRepository()
    if TipsManager.NeedLockTips(SystemList.Storage) then
        return
    end

    self:CallWithAniDelay(function ()
        UIManager.OpenUI(UIDef.UIRepositoryPanelV2)
    end)
    
end

--- 交换商店
function UICommandCenterPanel:OnClickExchangeStore()
    if TipsManager.NeedLockTips(SystemList.Exchangestore) then
        return
    end

    self:CallWithAniDelay(function ()
        UIManager.OpenUI(UIDef.UIStoreExchangePanel)
    end)
end

--- 休息室
function UICommandCenterPanel:OnClickDorm()
    if TipsManager.NeedLockTips(SystemList.Restroom) then
        return
    end

    self:CallWithAniDelay(function ()
        UIManager.OpenUI(UIDef.UIDormFavorabilityPanelV2)
    end)
end

--- PVP
function UICommandCenterPanel:OnClickPVP()
    if TipsManager.NeedLockTips(SystemList.Nrtpvp) then
        return
    end
    if not NetCmdPvPData.PVPIsOpen then
        CS.PopupMessageManager.PopupString(TableData.GetHintById(226))
        return
    end

    self:CallWithAniDelay(function ()
        NetCmdPvPData:RequestPVPInfo(function ()
            UIManager.OpenUI(UIDef.UINRTPVPPanel)
        end)
    end)
end

--- 扭蛋
function UICommandCenterPanel:OnClickGacha()
    if TipsManager.NeedLockTips(SystemList.Gacha) then
        return
    end
    self:CallWithAniDelay(function ()
        CS.UIMainPanel.EnterGashapon()
    end)
end

--- 军营
function UICommandCenterPanel:OnClickBarrack()
    if TipsManager.NeedLockTips(SystemList.Barrack) then
        return
    end
    self:CallWithAniDelay(function ()
        UIManager.OpenUI(UIDef.UIFacilityBarrackPanel)
    end)
end

--- 战役
function UICommandCenterPanel:OnClickBattle()
    if TipsManager.NeedLockTips(SystemList.Battle) then
        return
    end

    -----------据说是临时的，就这么写了------------

    if(UICommandCenterPanel.bCanClick == false) then
        return
    end

    local animator = self.mView.mAnimator
    animator:Play("FadeOut",-1,0)

    UICommandCenterPanel.ModelPoint = CS.UnityEngine.GameObject.Find("Model_Point").transform:GetChild(0)
    UICommandCenterPanel.ModelAnim = UICommandCenterPanel.ModelPoint:GetComponent("Animator")
    if UICommandCenterPanel.ModelAnim:GetCurrentAnimatorStateInfo(0):IsName("idle") then
        UICommandCenterPanel.ModelAnim:SetTrigger("move")
    end

    UICommandCenterPanel.mTrans_Background = CS.UnityEngine.GameObject.Find("Background")
    --UICommandCenterPanel.mTrans_Background.transform.localScale = vectorone

    self:PlayFadeOutEffect(UICommandCenterPanel.OpenCampaign)

    TimerSys:DelayCall(0.4,function(obj)
        setactive(UICommandCenterPanel.mUIRoot,false)
    end)

    UICommandCenterPanel.bCanClick = false
end

function UICommandCenterPanel.OpenCampaign()
    self = UICommandCenterPanel

    UIUniTopBarPanel:Show(false)

    UIManager.OpenUI(UIDef.UIBattleIndexPanel)
    UICommandCenterPanel.bCanClick = true

    --TimerSys:DelayCall(0.4,function(obj)
    --    UICommandCenterPanel.mTrans_Background.transform.localScale = vectorone
    --end)
end


--- 商城
function UICommandCenterPanel.OnStoreClicked(gameobj)
    self = UICommandCenterPanel
    if TipsManager.NeedLockTips(SystemList.Store) then
        return
    end
    local params = {1,false}
    UIManager.OpenUIByParam(UIDef.UIStoreMainPanel,params)
end

--- 成就
function UICommandCenterPanel.OnAchievementClicked(gameobj)
    self = UICommandCenterPanel
    if TipsManager.NeedLockTips(SystemList.Achievement) then
        return
    end
    NetCmdAchieveData:SendReqAchievementCmd(UICommandCenterPanel.OpenAchievement)
end

function UICommandCenterPanel.OpenAchievement()
    self = UICommandCenterPanel
    UIManager.OpenUI(UIDef.UIAchievementPanel)
end

--- 系统功能解锁
function UICommandCenterPanel:UpdateSystemUnLockInfo()
    for i, item in ipairs(self.mView.systemList) do
        self:UpdateSystemUnLockInfoByItem(item)
    end
end

function UICommandCenterPanel:UpdateSystemUnLockInfoByItem(item)
    if item and item.systemId then
        local isLock = self:CheckSystemIsLock(item.systemId)
        if item.animator then
            item.animator:SetBool("LockState", not isLock)
        end
    end
end

function UICommandCenterPanel:CheckSystemIsLock(type)
    return not AccountNetCmdHandler:CheckSystemIsUnLock(type)
end

function UICommandCenterPanel.SystemUnLock()
    self = UICommandCenterPanel
    printstack("有新的系统解锁了奥")
    self:UpdateSystemUnLockInfo()
end

--- 其他
function UICommandCenterPanel:SetMaskEnable(enable)
    setactive(UICommandCenterPanel.mView.mTrans_Mask, enable)
end

function UICommandCenterPanel:EnableModelPoint(enable)
    setactive(self.ModelPoint, enable)
end

function UICommandCenterPanel:InitRedPointObj()
    for i, item in ipairs(self.mView.systemList) do
        if item.transRedPoint then
            self:InstanceUIPrefab("UICommonFramework/ComRedPointItemV2.prefab", item.transRedPoint, true)
        end
    end
end

function UICommandCenterPanel.OnUpdate()
    if not UICommandCenterPanel.isPlayAni then
        return
    end
    local state = UICommandCenterPanel.mView.mAnimator:GetCurrentAnimatorStateInfo(0)
    if state:IsName("FadeIn") and state.normalizedTime > 1 then
        UICommandCenterPanel.isPlayAni = false
        UICommandCenterPanel.checkStep = 0
        UICommandCenterPanel:SetMaskEnable(true)
        UICommandCenterPanel:CommanderCheckQueue()
    end
end

--- 员工入口相关
function UICommandCenterPanel.OnTemporaryOpenClicked(gameobj)
    self = UICommandCenterPanel
    setactive(self.mView.mTrans_TemporaryPanel,true)
end

function UICommandCenterPanel.OnTemporaryCloseClicked(gameobj)
    printstack("Close")
    self = UICommandCenterPanel
    setactive(self.mView.mTrans_TemporaryPanel,false)
end

function UICommandCenterPanel.OnStageListClicked(gameobj)
    self = UICommandCenterPanel
    self:PlayFadeInEffect(UICommandCenterPanel.OnStageList);
end

function UICommandCenterPanel.OnStageList(gameobj)
    CS.UIMainPanel.EnterStageList()
end

function UICommandCenterPanel.OnAVGTestClicked(gameobj)
    -- CS.UIMainPanel.EnterAVGEditor()
    CS.AVGController.Instance:InitializeData("101-10.xml", function ()
        printstack("AVG is End")
    end)
end

function UICommandCenterPanel.OnLogOutClicked(gameobj)
    AccountNetCmdHandler:Logout()
end

function UICommandCenterPanel.OnJump360()
    -- CS.SceneSys.Instance:Open360Image()
    CS.SceneSys.Instance:OpenDarkScene()
end

function UICommandCenterPanel.PlayTestVideo()
    --CS.CriWareVideoController.StartPlay("h264_movie.usm")

    CS.CriWareVideoController.StartPlay("main_bg.usm", CS.CriWareVideoType.eVideoPath, nil,true);
end

