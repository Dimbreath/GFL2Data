require("UI.UIBasePanel")
require("UI.SimCombatPanel.UISimCombatExpPanelView")
require("UI.SimCombatPanel.Item.SimCombatEquipItem")
require("UI.SimCombatPanel.Item.UISimCombatTabButtonItem")
require("UI.CombatLauncherPanel.UICombatLauncherPanelItem")
---@class UISimCombatExpPanel : UIBasePanel
UISimCombatExpPanel = class("UISimCombatExpPanel", UIBasePanel)
UISimCombatExpPanel.__index = UISimCombatExpPanel
---@type UISimCombatExpPanelView
UISimCombatExpPanel.mView = nil

--- dataList
UISimCombatExpPanel.typeData = nil
UISimCombatExpPanel.stageDataList = {}
--- objList
UISimCombatExpPanel.stageList = {}

UISimCombatExpPanel.curLabel = nil
UISimCombatExpPanel.curStage = nil
UISimCombatExpPanel.lastIndex = 0
---@type UICombatLauncherItem
UISimCombatExpPanel.combatLauncher = nil


function UISimCombatExpPanel:ctor()
    UISimCombatExpPanel.super.ctor(self)
end

function UISimCombatExpPanel.Open()
    self = UISimCombatExpPanel
end

function UISimCombatExpPanel.Close()
    self = UISimCombatExpPanel
    UIManager.CloseUI(UIDef.UISimCombatExpPanel)
end

function UISimCombatExpPanel.Hide()
    self = UISimCombatExpPanel
    self:Show(false)
end

function UISimCombatExpPanel.Init(root, data)
    self = UISimCombatExpPanel

    UISimCombatExpPanel.super.SetRoot(UISimCombatExpPanel, root)

    UISimCombatExpPanel.mData = data

    UISimCombatExpPanel.mView = UISimCombatExpPanelView
    UISimCombatExpPanel.mView:InitCtrl(root)

    --- dataList
    UISimCombatExpPanel.typeData = nil
    UISimCombatExpPanel.stageDataList = {}
    --- objList
    UISimCombatExpPanel.stageList = {}

    UISimCombatExpPanel.curLabel = nil
    UISimCombatExpPanel.curStage = nil
    UISimCombatExpPanel.combatLauncher = nil

    -- UIUtils.GetButtonListener(self.mView.mBtn_CloseLaunch.gameObject).onClick = function(gObj)
    --     UISimCombatExpPanel:onClickCloseLauncher()
    -- end

    UIUtils.GetButtonListener(self.mView.mBtn_Back.gameObject).onClick = function(gObj)
        UISimCombatExpPanel:onClickExit()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Home.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Description.gameObject).onClick = function()
        SimpleMessageBoxPanel.ShowByParam("test", "test");
    end

    MessageSys:AddListener(2020, self.RefreshTimes)
end

function UISimCombatExpPanel.OnInit()
    self = UISimCombatExpPanel

    self:InitData()

    NetCmdStageRecordData:RequestStageRecordByType(CS.GF2.Data.StageType.ResourceStage, function (ret)
        if ret == CS.CMDRet.eSuccess then
            UISimCombatExpPanel:UpdatePanel()
        end
    end)
end

function UISimCombatExpPanel.ClearUIRecordData()
    UIBattleIndexPanel.currentType = -1
    UIChapterInfoPanel.curDiff = 1
end

function UISimCombatExpPanel:InitData()
    self.typeData = NetCmdSimulateBattleData:GetSimulateLabelByType(7)[0]

    for i = 0, TableData.listSimCombatExpDatas.Count - 1 do
        local data = TableData.listSimCombatExpDatas[i]
        if data then
            if self.stageDataList[data.sim_type] == nil then
                self.stageDataList[data.sim_type] = {}
            end
            table.insert(self.stageDataList[data.sim_type], data)
        end
    end

    local data = TableData.listSimCombatEntranceDatas:GetDataById(1)
    --self.mView.mText_Title.text = data.name.str
end

function UISimCombatExpPanel:UpdatePanel()
    self:UpdateStageList(16)
end

function UISimCombatExpPanel:UpdateStageList(tagId)
    local stage = self.stageDataList[tagId]
    if not next(stage) then
        return
    end

    local prefab = nil
    if #self.stageList < #stage then
        prefab = UIUtils.GetGizmosPrefab("SimCombat/SimCombatExpChapterSelListItemV2.prefab",self);
    end

    for _, item in ipairs(self.stageList) do
        item:SetData(nil)
    end

    for i, data in ipairs(stage) do
        local item = nil

        if i <= #self.stageList then
            item = self.stageList[i]
        else
            if prefab then
                local obj = instantiate(prefab)
                item = UISimCombatExpChapterSelListItemV2.New()
                UIUtils.AddListItem(obj, self.mView.mContent_Details.transform)
                item:InitCtrl(obj.transform)
                if(i % 2 == 1) then
                    item.mTrans_Root.localPosition = Vector3(0,-140,0);
                end
                table.insert(self.stageList, item)
            end
        end
        item:SetData(data, self.typeData, (i == #stage))
        UIUtils.GetButtonListener(item.mBtn_Equip.gameObject).onClick = function(gObj)
            self:OnClickStage(item)
        end

        if item.isUnLock then
            self.lastIndex = item.mData.sequence
        end
    end

    self:RefreshTimes()
    --setactive(self.stageList[tonumber(self.lastIndex)].mTrans_Now, true)
end

function UISimCombatExpPanel.RefreshTimes()
    self = UISimCombatExpPanel

    local itemData = TableData.GetItemData(self.typeData.item_id)
    local maxLimit = TableData.listItemLimitDatas:GetDataById(self.typeData.item_id, true)
    if itemData then
        self.ticketCount = NetCmdItemData:GetItemCountById(self.typeData.item_id)
    end

    -- self.mView.mText_Remaining.text = TableData.GetHintDataById(103005).chars.str;
    if self.ticketCount == nil or self.ticketCount == 0 then
        self.mView.mText_Num.text = "<color=red>" .. self.ticketCount .. "</color>/" .. maxLimit.init_num;
    else
        self.mView.mText_Num.text = self.ticketCount .. "/" .. maxLimit.init_num;
    end

    if self.combatLauncher ~= nil then
        self.combatLauncher:RefreshTimes(self.ticketCount)
    end
end

function UISimCombatExpPanel:OnClickStage(item)
    if item then
        if self.curStage and self.curStage.mData.id == item.mData.id then
            return
        end

        local record = NetCmdStageRecordData:GetStageRecordById(item.stageData.id)
        self:ShowStageInfo(item.stageData, record, item)
    end
end

function UISimCombatExpPanel:ShowStageInfo(stageData, stageRecord, item)
    if self.curStage then
        self.curStage:UpdateState(false)
    end
    item:UpdateState(true)
    self.curStage = item

    if self.combatLauncher == nil then
        self:InitCombatLauncher()
    end
    self.combatLauncher:InitSimCombatResourceData(stageData, stageRecord, item.mData, item.isUnLock, self.ticketCount)
    setactive(self.mView.mTrans_CombatLauncher.gameObject, true)
    UITopResourceBar.UpdateParent(self.combatLauncher.mTrans_TopCurrency)
end

function UISimCombatExpPanel:InitCombatLauncher()
    ---@type UICombatLauncherItem
    local item = UICombatLauncherItem.New()
    item:InitCtrl(self.mView.mTrans_CombatLauncher.gameObject, 4)
    self.combatLauncher = item
    UIUtils.GetButtonListener(item.mBtn_Close.gameObject).onClick = function(gObj)
        UISimCombatExpPanel:onClickCloseLauncher()
    end
end

function UISimCombatExpPanel:onClickCloseLauncher()
    if self.combatLauncher == nil then
        return
    end
    if self.curStage then
        self.curStage:UpdateState(false)
        self.curStage = nil
    end
    UITopResourceBar.UpdateParent(self.mView.mTrans_TopCurrency)
    self.combatLauncher:PlayAniWithCallback(function ()
        setactive(self.mView.mTrans_CombatLauncher.gameObject, false)
    end)
end

function UISimCombatExpPanel:onClickExit()
    UISimCombatExpPanel.Close()
end

function UISimCombatExpPanel.OnRelease()
    self = UISimCombatExpPanel;

    --- dataList
    UISimCombatExpPanel.typeData = nil
    UISimCombatExpPanel.stageDataList = {}
    --- objList
    UISimCombatExpPanel.stageList = {}

    UISimCombatExpPanel.curLabel = nil
    UISimCombatExpPanel.curStage = nil
    if UISimCombatExpPanel.combatLauncher ~= nil then
        UISimCombatExpPanel.combatLauncher:OnRelease()
    end
    UISimCombatExpPanel.combatLauncher = nil
    MessageSys:RemoveListener(2020, self.RefreshTimes)
end

function UISimCombatExpPanel.OnUpdateTop()
    self = UISimCombatExpPanel;
    if self.combatLauncher ~= nil then
        if self.combatLauncher.raycaster then
            self.combatLauncher.raycaster.enabled = true
        end
        if self.mView.mTrans_CombatLauncher.gameObject.activeSelf then
            UITopResourceBar.UpdateParent(self.combatLauncher.mTrans_TopCurrency)
        end
    end
end