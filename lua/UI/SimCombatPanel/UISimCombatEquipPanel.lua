require("UI.UIBasePanel")
require("UI.SimCombatPanel.UISimCombatEquipPanelView")
require("UI.SimCombatPanel.Item.SimCombatEquipItem")
require("UI.SimCombatPanel.Item.UISimCombatTabButtonItem")
require("UI.CombatLauncherPanel.UICombatLauncherPanelItem")

UISimCombatEquipPanel = class("UISimCombatEquipPanel", UIBasePanel)
UISimCombatEquipPanel.__index = UISimCombatEquipPanel

UISimCombatEquipPanel.mView = nil

--- dataList
UISimCombatEquipPanel.typeDataList = nil
UISimCombatEquipPanel.stageDataList = {}
--- objList
UISimCombatEquipPanel.labelList = {}
UISimCombatEquipPanel.stageList = {}

UISimCombatEquipPanel.curLabel = nil
UISimCombatEquipPanel.curStage = nil
UISimCombatEquipPanel.lastIndex = 0
UISimCombatEquipPanel.combatLauncher = nil
UISimCombatEquipPanel.curLabelId = -1


function UISimCombatEquipPanel:ctor()
    UISimCombatEquipPanel.super.ctor(self)
end

function UISimCombatEquipPanel.Open()
    self = UISimCombatEquipPanel
end

function UISimCombatEquipPanel.Close()
    self = UISimCombatEquipPanel
    UIManager.CloseUI(UIDef.UISimCombatEquipPanel)
end

function UISimCombatEquipPanel.Hide()
    self = UISimCombatEquipPanel
    self:Show(false)
end

function UISimCombatEquipPanel.Init(root, data)
    self = UISimCombatEquipPanel

    UISimCombatEquipPanel.super.SetRoot(UISimCombatEquipPanel, root)

    UISimCombatEquipPanel.mData = data

    UISimCombatEquipPanel.mView = UISimCombatEquipPanelView
    UISimCombatEquipPanel.mView:InitCtrl(root)

    --- dataList
    UISimCombatEquipPanel.typeDataList = nil
    UISimCombatEquipPanel.stageDataList = {}
    --- objList
    UISimCombatEquipPanel.labelList = {}
    UISimCombatEquipPanel.stageList = {}

    UISimCombatEquipPanel.curLabel = nil
    UISimCombatEquipPanel.curStage = nil
    if UISimCombatEquipPanel.combatLauncher ~= nil then
        UISimCombatEquipPanel.combatLauncher:OnRelease()
    end
    UISimCombatEquipPanel.combatLauncher = nil

    -- UIUtils.GetButtonListener(self.mView.mBtn_CloseLaunch.gameObject).onClick = function(gObj)
    --     UISimCombatEquipPanel:onClickCloseLauncher()
    -- end

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function(gObj)
        UISimCombatEquipPanel:onClickExit()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommanderCenter.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end
end

function UISimCombatEquipPanel.OnInit()
    self = UISimCombatEquipPanel

    self:InitData()

    NetCmdStageRecordData:RequestStageRecordByType(CS.GF2.Data.StageType.EquipStage, function (ret)
        if ret == CS.CMDRet.eSuccess then
            UISimCombatEquipPanel:UpdatePanel()
        end
    end)
end

function UISimCombatEquipPanel.OnRelease()
    self = UISimCombatEquipPanel

    --- dataList
    UISimCombatEquipPanel.typeDataList = nil
    UISimCombatEquipPanel.stageDataList = {}
    --- objList
    UISimCombatEquipPanel.labelList = {}
    UISimCombatEquipPanel.stageList = {}

    UISimCombatEquipPanel.curLabel = nil
    UISimCombatEquipPanel.curStage = nil

    if UISimCombatEquipPanel.combatLauncher ~= nil then
        UISimCombatEquipPanel.combatLauncher:OnRelease()
    end
    UISimCombatEquipPanel.combatLauncher = nil
end

function UISimCombatEquipPanel.ClearUIRecordData()
    UISimCombatEquipPanel.curLabelId = -1
    UIBattleIndexPanel.currentType = -1
    UIChapterInfoPanel.curDiff = 1
end

function UISimCombatEquipPanel:InitData()
    self.typeDataList = NetCmdSimulateBattleData:GetSimulateLabelByType(1)

    for i = 0, TableData.listSimCombatDatas.Count - 1 do
        local data = TableData.listSimCombatDatas[i]
        if data then
            if self.stageDataList[data.sim_type] == nil then
                self.stageDataList[data.sim_type] = {}
            end
            table.insert(self.stageDataList[data.sim_type], data)
        end
    end

    --- sort
    for _, item in ipairs(self.stageDataList) do
        if next(item) then
            table.sort(item, function (a, b)
                return tonumber(a.sequence) < tonumber(b.sequence)
            end)
        end
    end

    local data = TableData.listSimCombatEntranceDatas:GetDataById(1)
    --self.mView.mText_Title.text = data.name.str
end

function UISimCombatEquipPanel:UpdatePanel()
    self:UpdateLabel()
end

function UISimCombatEquipPanel:UpdateLabel()
    if self.typeDataList == nil then
        return
    end

    local label = self.typeDataList
    local tempCurLabel = nil
    local prefab = nil

    if #self.labelList < label.Count then
        prefab = UIUtils.GetGizmosPrefab("SimCombat/SimCombatEquipTabListItemV2.prefab",self);
    end

    for i = 0, label.Count - 1 do
        local data = label[i]
        local item = nil

        if i + 1 <= #self.labelList then
            item = self.labelList[i + 1]
        else
            if prefab then
                local obj = instantiate(prefab)
                item = UISimCombatTabButtonItem.New()
                UIUtils.AddListItem(obj, self.mView.mTrans_EquipType.transform)
                item:InitCtrl(obj.transform)
                UIUtils.GetButtonListener(item:GetSelfButton().gameObject).onClick = function(gObj)
                    self:OnClickLabel(item)
                end
                table.insert(self.labelList, item)
            end
        end
        item:SetName(data.id, data.label_name.str, "")

        if data.id == self.curLabelId then
            tempCurLabel = item
        end
    end
    --通过Jump方式跳转过来
    if self.mData~=nil then
        local simcombatdata=TableData.listSimCombatDatas:GetDataById(self.mData)
        local jumpLabel=simcombatdata.SimType
        if jumpLabel~=nil then
            self:OnClickLabel(self.labelList[jumpLabel],tonumber(simcombatdata.Sequence))
            return 
        end
    end
    

    if tempCurLabel then
        self:OnClickLabel(tempCurLabel)
    else
        self:OnClickLabel(self.labelList[1])
    end
end

function UISimCombatEquipPanel:OnClickLabel(item,jumpdata)
    if not item then
        return
    end

    if self.curLabel ~= nil then
        if item.tagId ~= self.curLabel.tagId then
            self.curLabel:SetItemState(false)
        else
            return
        end
    end
    item:SetItemState(true)
    self.curLabel = item
    self.curLabelId = item.tagId
    self:onClickCloseLauncher()

    --让动画效果切换完
    TimerSys:DelayCall(0.1,function(obj)
        self:UpdateStageList(self.curLabel.tagId)
        self.mView.mAnimator:SetTrigger("Next")
        if jumpdata~=nil then
            self.lastIndex=jumpdata
        end
        self.mView.mScroll:ScrollToCell(tonumber(self.lastIndex), 3500)
        if jumpdata~=nil then
            self:OnClickStage(self.stageList[jumpdata])
            UISystem:ClearPopUiParam()
        end
    end);

    
end

function UISimCombatEquipPanel:UpdateStageList(tagId)
    local stage = self.stageDataList[tagId]
    local labelData = self:GetLabelDataById(tagId)
    if not next(stage) then
        return
    end

    local prefab = nil
    if #self.stageList < #stage then
        prefab = UIUtils.GetGizmosPrefab("SimCombat/SimCombatEquipChapterSelListItemV2.prefab",self);
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
                item = SimCombatEquipItem.New()
                UIUtils.AddListItem(obj, self.mView.mTrans_EquipList.transform)
                item:InitCtrl(obj.transform)
                if(i % 2 == 1) then
                    item.mTrans_Root.localPosition = Vector3(0,-140,0);
                end
                table.insert(self.stageList, item)
            end
        end
        item:SetData(data, labelData.icon, (i == #stage))
        UIUtils.GetButtonListener(item.mBtn_Equip.gameObject).onClick = function(gObj)
            self:OnClickStage(item)
        end

        if item.isUnLock then
            self.lastIndex = item.mData.sequence
        end
    end

    --setactive(self.stageList[tonumber(self.lastIndex)].mTrans_Now, true)
end

function UISimCombatEquipPanel:OnClickStage(item)
    if item then
        if self.curStage and self.curStage.mData.id == item.mData.id then
            return
        end

        local record = NetCmdStageRecordData:GetStageRecordById(item.stageData.id)
        self:ShowStageInfo(item.stageData, record, item)
    end
end

function UISimCombatEquipPanel:ShowStageInfo(stageData, stageRecord, item)
    if self.curStage then
        self.curStage:UpdateState(false)
    end
    item:UpdateState(true)
    self.curStage = item

    if self.combatLauncher == nil then
        self:InitCombatLauncher()
    end
    self.combatLauncher:InitSimCombatData(stageData, stageRecord, item.mData, item.isUnLock)
    setactive(self.mView.mTrans_CombatLauncher.gameObject, true)
    UITopResourceBar.UpdateParent(self.combatLauncher.mTrans_TopCurrency)
end

function UISimCombatEquipPanel:InitCombatLauncher()
    local item = UICombatLauncherItem.New()
    item:InitCtrl(self.mView.mTrans_CombatLauncher.gameObject, 4)
    self.combatLauncher = item
    UIUtils.GetButtonListener(item.mBtn_Close.gameObject).onClick = function(gObj)
        UISimCombatEquipPanel:onClickCloseLauncher()
    end
end

function UISimCombatEquipPanel:onClickCloseLauncher()
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

function UISimCombatEquipPanel:GetLabelDataById(id)
    for i = 0, self.typeDataList.Count - 1 do
        if self.typeDataList[i].id == id then
            return self.typeDataList[i]
        end
    end
end

function UISimCombatEquipPanel:onClickExit()
    self.curLabelId = -1
    UISimCombatEquipPanel.Close()
end

function UISimCombatEquipPanel.OnUpdateTop()
    self = UISimCombatEquipPanel
    if self.combatLauncher ~= nil then
        if self.combatLauncher.raycaster then
            self.combatLauncher.raycaster.enabled = true
        end
        if self.mView.mTrans_CombatLauncher.gameObject.activeSelf then
            UITopResourceBar.UpdateParent(self.combatLauncher.mTrans_TopCurrency)
        end
    end
end