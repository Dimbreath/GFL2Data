require("UI.UIBasePanel")
require("UI.SimCombatPanel.UISimCombatWeeklyPanelView")

UISimCombatWeeklyPanel = class("UISimCombatWeeklyPanel", UIBasePanel)
UISimCombatWeeklyPanel.__index = UISimCombatWeeklyPanel

UISimCombatWeeklyPanel.mView = nil
UISimCombatWeeklyPanel.mData = nil
UISimCombatWeeklyPanel.stageList = {}
UISimCombatWeeklyPanel.combatLauncher = nil
UISimCombatWeeklyPanel.curStage = nil
UISimCombatWeeklyPanel.time = 0
UISimCombatWeeklyPanel.timeData = nil
UISimCombatWeeklyPanel.timer = nil
UISimCombatWeeklyPanel.isOpen = true
UISimCombatWeeklyPanel.isFristEnter = false

UISimCombatWeeklyPanel.lastUnlockStage = 0
UISimCombatWeeklyPanel.bossStage = nil
UISimCombatWeeklyPanel.enemyList1 = {}
UISimCombatWeeklyPanel.enemyList2 = {}
UISimCombatWeeklyPanel.timeStr = {}

--- const
UISimCombatWeeklyPanel.OpenTimeText = "{0}:{1}:{2}"
UISimCombatWeeklyPanel.TimeText = "{0}{1}"
UISimCombatWeeklyPanel.Monster_Whole = "Monster_Whole_"
--- const

function UISimCombatWeeklyPanel:ctor()
    UISimCombatWeeklyPanel.super.ctor(self)
end

function UISimCombatWeeklyPanel.Close()
    self = UISimCombatWeeklyPanel
    self:CloseAni()
    UIManager.CloseUI(UIDef.UISimCombatWeeklyPanel)
end

function UISimCombatWeeklyPanel:CloseAni()
    if self.mView.mAnimator then
        self.mView.mAnimator:SetTrigger("SimCombatWeekly_FadeOut")
    end
end

function UISimCombatWeeklyPanel.Init(root)
    UISimCombatWeeklyPanel.super.SetRoot(UISimCombatWeeklyPanel, root)

    self = UISimCombatWeeklyPanel
    self.mView = UISimCombatWeeklyPanelView.New()
    self.mView:InitCtrl(self.mUIRoot)

    self.mData = NetCmdSimulateBattleData:GetSimCombatWeeklyData()
    self.timeStr = self:InitTimeStr()
    self.mHideFlag = true
end

function UISimCombatWeeklyPanel.OnInit()
    self = UISimCombatWeeklyPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Start.gameObject).onClick = function()
        UISimCombatWeeklyPanel:StartWeekly()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Return.gameObject).onClick = function()
        UISimCombatWeeklyPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Gun.gameObject).onClick = function()
        UISimCombatWeeklyPanel:OpenGun()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Affix.gameObject).onClick = function()
        UISimCombatWeeklyPanel:OpenAffix()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Buff.gameObject).onClick = function()
        UISimCombatWeeklyPanel:OpenBuff()
    end

    UIUtils.GetButtonListener(self.mView.mItem_Close.btnStore.gameObject).onClick = function()
        UISimCombatWeeklyPanel:OpenStore()
    end

    UIUtils.GetButtonListener(self.mView.mItem_Level.btnStore.gameObject).onClick = function()
        UISimCombatWeeklyPanel:OpenStore()
    end

    UIUtils.GetButtonListener(self.mView.mItem_Level.btnRank.gameObject).onClick = function()
        UISimCombatWeeklyPanel:OpenRankList()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Home.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end
end

function UISimCombatWeeklyPanel.OnShow()
    self = UISimCombatWeeklyPanel
    self:UpdatePanel()
    setactive(self.mView.mUIRoot, true)
end

function UISimCombatWeeklyPanel.OnHide()
    self = UISimCombatWeeklyPanel
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

function UISimCombatWeeklyPanel.OnRelease()
    self = UISimCombatWeeklyPanel
    if UISimCombatWeeklyPanel.timer then
        UISimCombatWeeklyPanel.timer:Stop()
        UISimCombatWeeklyPanel.timer = nil
    end
    UISimCombatWeeklyPanel.stageList = {}
    UISimCombatWeeklyPanel.combatLauncher = nil
    UISimCombatWeeklyPanel.curStage = nil
    UISimCombatWeeklyPanel.time = 0
    UISimCombatWeeklyPanel.timeData = nil
    UISimCombatWeeklyPanel.lastUnlockStage = 0
    UISimCombatWeeklyPanel.bossStage = nil
    UISimCombatWeeklyPanel.enemyList1 = {}
    UISimCombatWeeklyPanel.enemyList2 = {}
    UISimCombatWeeklyPanel.isFristEnter = false

    UISimCombatWeeklyPanel:ReleaseTimers()
end

function UISimCombatWeeklyPanel:UpdatePanel()
    self.isOpen = NetCmdSimulateBattleData:IsWeeklyOpen()
    if self.isOpen then
        if self.mData ~= nil and self.mData.weeklyId > 0 then
            self:UpdateWeeklyPanel()
        else
            self:UpdateWeeklyOpenContent()
        end
        self:InitTime()
    else
        self:UpdateWeeklyCloseContent()
    end
end

function UISimCombatWeeklyPanel:StartWeekly()
    if self.mData == nil or self.mData.weeklyId <= 0 then
        NetCmdSimulateBattleData:ReqSimCombatWeeklyStart(function (ret)
            if ret == CS.CMDRet.eSuccess then
                self.isFristEnter = true
                self.mData = NetCmdSimulateBattleData:GetSimCombatWeeklyData()
                self:UpdatePanel()
            end
        end)
    end
end

function UISimCombatWeeklyPanel:UpdateWeeklyOpenContent()
    self.mView.mItem_Open.txtName.text = self.mData.circulationData.name.str
    self.mView.mItem_Open.txtDesc.text = self.mData.circulationData.des.str
    self:UpdateBossAvatar()
    self:PlaySwitchByIndex(self.mView.mItem_Open.index)

    setactive(self.mView.mItem_Level.gameObject, false)
    setactive(self.mView.mItem_Open.gameObject, true)
    setactive(self.mView.mItem_Close.gameObject, false)
end

function UISimCombatWeeklyPanel:UpdateWeeklyCloseContent()
    local id = self.mData:GetNextCirculationData()
    local data = TableData.listSimCombatWeeklyCycleDatas:GetDataById(id)
    self.mView.mItem_Close.txtName.text = data.name.str
    self.mView.mItem_Close.txtDesc.text = data.des.str

    for i = 0, data.boss_id.Length - 1 do
        local enemyId = data.boss_id[i]
        local enemyData = TableData.GetEnemyData(enemyId)

        local item = self.enemyList2[i + 1]
        if item == nil then
            item = UICommonEnemyItem.New()
            item:InitCtrl(self.mView.mItem_Close.transBoss)
            table.insert(self.enemyList2, item)
        end

        item:SetData(enemyData)
        item:EnableLv(false)

        UIUtils.GetButtonListener(item.mBtn_OpenDetail.gameObject).onClick = function()
            self:OnClickEnemy(enemyId)
        end
    end

    local enemyData = TableData.GetEnemyData(data.boss_id[0])
    if enemyData then
        local iconName = UISimCombatWeeklyPanel.Monster_Whole .. enemyData.character_pic .. "_Shadow"
        self.mView.mImage_BossAvatar.sprite = IconUtils.GetPlayerAvatar(iconName)
    end

    self:InitOpenTime()
    self:PlaySwitchByIndex(self.mView.mItem_Close.index)

    setactive(self.mView.mItem_Level.gameObject, false)
    setactive(self.mView.mItem_Open.gameObject, false)
    setactive(self.mView.mItem_Close.gameObject, true)
end

function UISimCombatWeeklyPanel:UpdateWeeklyPanel()
    setactive(self.mView.mItem_Level.gameObject, false)
    NetCmdStageRecordData:RequestStageRecordByType(CS.GF2.Data.StageType.WeeklyStage, function (ret)
        if ret == CS.CMDRet.eSuccess then
            self:InitStageList()
            self:UpdateWeeklyInfo()
            setactive(self.mView.mItem_Level.gameObject, true)
            setactive(self.mView.mItem_Open.gameObject, false)
            setactive(self.mView.mItem_Close.gameObject, false)
        end
    end)
end

function UISimCombatWeeklyPanel:UpdateBossAvatar()
    local enemyData = TableData.GetEnemyData(self.mData.circulationData.boss_id[0])
    local iconName = UISimCombatWeeklyPanel.Monster_Whole .. enemyData.character_pic
    if enemyData then
        if self.bossStage then
            iconName = (self.bossStage.index <= self.lastUnlockStage) and iconName or iconName .. "_Shadow"
            setactive(self.mView.mTrans_BossLock, self.bossStage.index > self.lastUnlockStage)
        else
            iconName = iconName .. "_Shadow"
            setactive(self.mView.mTrans_BossLock, true)
        end

        self.mView.mImage_BossAvatar.sprite = IconUtils.GetPlayerAvatar(iconName)
    end
end

function UISimCombatWeeklyPanel:UpdateWeeklyInfo()
    if self.bossStage then
        self.mView.mItem_Level.txtPoint.text = self.mData:GetPointByIndex(self.bossStage.index)
        self.mView.mItem_Level.txtTimes.text = self.mData:GetStageTime(self.bossStage.index)
    end
    self.mView.mItem_Level.txtName.text = self.mData.circulationData.name.str
    self.mView.mItem_Level.txtDesc.text = self.mData.circulationData.des.str
    self.mView.mItem_Level.txtTitle.text = self.mData.weeklyData.type_name.str

    for i = 0, self.mData.circulationData.boss_id.Length - 1 do
        local enemyId = self.mData.circulationData.boss_id[i]
        local enemyData = TableData.GetEnemyData(enemyId)

        local item = self.enemyList1[i + 1]
        if item == nil then
            item = UICommonEnemyItem.New()
            item:InitCtrl(self.mView.mItem_Level.transBoss)
            table.insert(self.enemyList1, item)
        end

        item:SetData(enemyData)
        item:EnableLv(false)

        UIUtils.GetButtonListener(item.mBtn_OpenDetail.gameObject).onClick = function()
            self:OnClickEnemy(enemyId)
        end
    end

    self:UpdateBossAvatar()
    self:PlaySwitchByIndex(self.mView.mItem_Level.index)
end

function UISimCombatWeeklyPanel:OnClickEnemy(enemyId)
    UIUnitInfoPanel.Open(UIUnitInfoPanel.ShowType.Enemy, enemyId, 1)
end

function UISimCombatWeeklyPanel:InitStageList()
    if self.mData.weeklyData then
        local index = self.mData.finishedStageIndex < 0 and 0 or self.mData.finishedStageIndex
        local record = NetCmdStageRecordData:GetStageRecordById(self.mData.weeklyData.stage_list[index])
        self.lastUnlockStage = self:GetLastUnLockIndex(record)

        for i = 0, self.mData.weeklyData.stage_list.Count - 1 do
            local item = self.stageList[i + 1]
            if item == nil then
                local obj = self:InstanceUIPrefab("SimCombat/SimCombatWeeklyLevelSelListItemV2.prefab", self.mView.mItem_Level.transStageList, true)
                local stageItem = self:InitStageItem(obj, i)
                item = stageItem
                table.insert(self.stageList, stageItem)
            end

            local stageId = self.mData.weeklyData.stage_list[i]
            local stageData = TableData.listStageDatas:GetDataById(stageId)
            self:UpdateStageItem(item, stageData)
        end
    end
end

function UISimCombatWeeklyPanel:InitStageItem(obj, index)
    if obj then
        local stage = {}
        stage.obj = obj
        stage.data = nil
        stage.isLock = true
        stage.index = index
        stage.btnStage = UIUtils.GetButton(obj)
        stage.txtNum = UIUtils.GetText(obj, "Root/GrpTopLeft/Text_Num")
        stage.txtName = UIUtils.GetText(obj, "Root/GrpSimCombat/Text_Chapter")
        stage.transBoss = UIUtils.GetRectTransform(obj, "Root/GrpSimCombat/Trans_ImgBossIcon")
        stage.transLocked = UIUtils.GetRectTransform(obj, "Root/GrpState/Trans_GrpLocked")
        stage.transNow = UIUtils.GetRectTransform(obj, "Root/GrpState/Trans_GrpNow")
        stage.transFinish = UIUtils.GetRectTransform(obj, "Root/GrpState/Trans_GrpFinish")
        stage.txtRandomId = UIUtils.GetText(obj, "Root/GrpBottomLeft/Text1")

        UIUtils.GetButtonListener(stage.btnStage.gameObject).onClick = function()
            local record = NetCmdStageRecordData:GetStageRecordById(stage.data.id)
            self:OnClickStage(stage, index, record)
        end

        return stage
    end
end

function UISimCombatWeeklyPanel:UpdateStageItem(item, data)
    if item == nil then
       return
    end
    setactive(item.obj, data ~= nil)
    if data then
        item.data = data
        item.isLock = item.index > self.lastUnlockStage
        item.txtName.text = data.name.str
        item.txtNum.text = data.code
        item.txtRandomId.text = UIChapterGlobal:GetRandomNum()
        setactive(item.transLocked, item.isLock)
        setactive(item.transNow, item.index == self.lastUnlockStage)
        setactive(item.transFinish, item.index < self.lastUnlockStage)
        setactive(item.transBoss, item.index == self.mData.weeklyData.stage_list.Count - 1)

        if item.index == self.mData.weeklyData.stage_list.Count - 1 then
            self.bossStage = item
        end
    end
end

function UISimCombatWeeklyPanel:OnClickStage(item, index, record)
    if item.isLock then
        UIUtils.PopupHintMessage(103015)
        return
    end
    if self.curStage then
        self.curStage.btnStage.interactable = true
    end
    item.btnStage.interactable = false
    self.curStage = item

    if self.combatLauncher == nil then
        self:InitCombatLauncher()
    end
    self.combatLauncher:InitSimWeeklyData(item.data, record, self.mData.weeklyId)
    setactive(self.mView.mTrans_CombatLauncher.gameObject, true)
end

function UISimCombatWeeklyPanel:InitCombatLauncher()
    local item = UICombatLauncherItem.New()
    item:InitCtrl(self.mView.mTrans_CombatLauncher.gameObject, 4)
    self.combatLauncher = item
    UIUtils.GetButtonListener(item.mBtn_Close.gameObject).onClick = function(gObj)
        self:OnClickCloseChapterInfoPanel()
    end
end

function UISimCombatWeeklyPanel:OnClickCloseChapterInfoPanel()
    if self.combatLauncher then
        self.combatLauncher:PlayAniWithCallback(function ()
            if self.curStage then
                self.curStage.btnStage.interactable = true
                self.curStage = nil
            end
            setactive(self.mView.mTrans_CombatLauncher, false)
        end)
    else
        if self.curStage then
            self.curStage.btnStage.interactable = true
            self.curStage = nil
        end
        setactive(self.mView.mTrans_CombatLauncher, false)
    end
end

function UISimCombatWeeklyPanel:OpenGun()
    UIManager.OpenUIByParam(UIDef.UICommonGunDisplayPanel, self.mData.circulationData.gun_id)
end

function UISimCombatWeeklyPanel:OpenAffix()
    UIManager.OpenUIByParam(UIDef.UICommonAffixDisplayPanel, self.mData.circulationData.stage_debuff)
end

function UISimCombatWeeklyPanel:OpenBuff()
    UIManager.OpenUIByParam(UIDef.UICommonBuffDisplayPanel, self.mData.circulationData.stage_buff)
end

function UISimCombatWeeklyPanel:InitTime()
    if self.mData == nil or self.mData.weeklyId < 0 then
        return
    end
    self.time = self.mData:GetLastTime()
    if self.time <= 0 then
        return
    end
    self.timeData = self:FormatDiffUnixTime2Tb(self.time)
    self:UpdateTimeText(self.timeData)

    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
    self.timer = TimerSys:DelayCall(1, self.UpdateTimeData, nil, -1)
end

function UISimCombatWeeklyPanel:InitOpenTime()
    if not self.isOpen then
        self.time = self.mData:LastOpenTime()
        if self.time <= 0 then
            return
        end
        self.timeData = self:FormatDiffUnixTime2Tb(self.time)
        self:UpdateOpenTimeText(self.timeData)

        if self.timer then
            self.timer:Stop()
            self.timer = nil
        end
        self.timer = TimerSys:DelayCall(1, self.UpdateOpenTimeData, nil, -1)
    end
end

function UISimCombatWeeklyPanel.UpdateTimeData()
    self = UISimCombatWeeklyPanel
    self.time = self.time - 1
    self.timeData.ss = self.timeData.ss - 1
    if self.time <= 0 then
        if self.timer then
            self.timer:Stop()
            self.timer = nil
        end
        MessageBoxPanel.ShowSingleType(TableData.GetHintById(226), function ()
            UISimCombatWeeklyPanel.Close()
        end)
        return
    end

    if self.timeData.dd <= 0 and self.timeData.hh <= 0 then
        self.timeData = self:FormatDiffUnixTime2Tb(self.time)
        self:UpdateTimeText(self.timeData)
    else
        if self.timeData.ss < 0 then
            self.timeData = self:FormatDiffUnixTime2Tb(self.time)
            self:UpdateTimeText(self.timeData)
        end
    end
end

function UISimCombatWeeklyPanel.UpdateOpenTimeData()
    self = UISimCombatWeeklyPanel
    self.time = self.time - 1
    self.timeData.ss = self.timeData.ss - 1
    if self.time <= 0 then
        if self.timer then
            self.timer:Stop()
            self.timer = nil
        end
        self:UpdatePanel()
        return
    end

    if self.timeData.ss < 0 then
        self.timeData = self:FormatDiffUnixTime2Tb(self.time)
    end
    self:UpdateOpenTimeText(self.timeData)
end

function UISimCombatWeeklyPanel:OpenRankList()

end

function UISimCombatWeeklyPanel.OnUpdateTop()
    self = UISimCombatWeeklyPanel
    if self.combatLauncher ~= nil then
        if self.combatLauncher.raycaster then
            self.combatLauncher.raycaster.enabled = true
        end
    end
end

function UISimCombatWeeklyPanel:OpenStore()
    SceneSwitch:SwitchByID(19, {6})
end

function UISimCombatWeeklyPanel:UpdateTimeText(td)
    local text = ""
    local showCount = 0
    if td then
        if td.dd > 0 and showCount < 2 then
            text = text .. string_format(UISimCombatWeeklyPanel.TimeText, td.dd, self.timeStr[1])
            showCount = showCount + 1
            if td.hh == 0 then
                td.hh = td.hh + 1
            end
        end
        if td.hh > 0 and showCount < 2 then
            text = text .. string_format(UISimCombatWeeklyPanel.TimeText, td.hh, self.timeStr[2])
            showCount = showCount + 1
            if td.mm == 0 then
               td.mm = td.mm + 1
            end
        end
        if td.mm > 0 and showCount < 2 then
            text = text .. string_format(UISimCombatWeeklyPanel.TimeText, td.mm, self.timeStr[3])
            showCount = showCount + 1
        end
        if td.ss >= 0 and showCount < 2 then
            text = text .. string_format(UISimCombatWeeklyPanel.TimeText, td.ss, self.timeStr[4])
            showCount = showCount + 1
        end

        if self.mData ~= nil and self.mData.weeklyId > 0 then
            self.mView.mItem_Level.txtTime.text = text
        else
            self.mView.mItem_Open.txtTime.text = text
        end
    end
end

function UISimCombatWeeklyPanel:UpdateOpenTimeText(td)
    local hour = td.dd > 0 and td.hh + 24 * td.dd or td.hh
    self.mView.mItem_Close.txtTime.text = string_format(UISimCombatWeeklyPanel.OpenTimeText,
            hour < 10 and "0" .. hour or hour,
            td.mm < 10 and "0" .. td.mm or td.mm,
            td.ss < 10 and "0" .. td.ss or td.ss)
end

function UISimCombatWeeklyPanel:GetLastUnLockIndex(record)
    local index = self.mData.finishedStageIndex < 0 and 0 or self.mData.finishedStageIndex
    if self.mData.finishedStageIndex >= 0 then
        if record and record.first_pass_time > 0 then
            index = index + 1
        end
    end
    return index
end

---------------------------- private -----------------------------
function UISimCombatWeeklyPanel:FormatDiffUnixTime2Tb(diffUnixTime)
    if diffUnixTime and diffUnixTime >= 0 then
        local tb = {}
        tb.dd = math.floor(diffUnixTime / 60 / 60 / 24)
        tb.hh = math.floor(diffUnixTime / 3600) % 24
        tb.mm = math.floor(diffUnixTime / 60) % 60
        tb.ss = math.floor(diffUnixTime % 60)
        return tb
    end
end

function UISimCombatWeeklyPanel:PlaySwitchByIndex(index)
    self:DelayCall(0.1, function ()
        if self.mView.mAnimator then
            self.mView.mAnimator:SetInteger("Switch", index)
            self.mView.mAnimator:SetBool("Open", index == 2)
            if self.isFristEnter then
                self.isFristEnter = false
                self.mView.mAnimator:Play(index == 2 and "On" or "Off", 3, 0)
            else
                self.mView.mAnimator:Play(index == 2 and "On" or "Off", 3, 1)
            end
        end
    end)
end

function UISimCombatWeeklyPanel:InitTimeStr()
    local str = {}
    for i = 0, 3 do
        local hint = TableData.GetHintById(53 - i)
        table.insert(str, hint)
    end

    return str
end
