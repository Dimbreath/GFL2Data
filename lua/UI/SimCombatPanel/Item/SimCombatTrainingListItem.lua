require("UI.UIBaseCtrl")

SimCombatTrainingListItem = class("SimCombatTrainingListItem", UIBaseCtrl);
SimCombatTrainingListItem.__index = SimCombatTrainingListItem

function SimCombatTrainingListItem:ctor()
    self.buttonList = {}
    self.txtList = {}
end

function SimCombatTrainingListItem:__InitCtrl()
    self.mText_Num = self:GetText("Trans_Btn_GrpCompleted/GrpContent/GrpNor/GrpTextLayer/Text_Layer")
    self.mTrans_Complete = self:GetRectTransform("Trans_Btn_GrpCompleted")
    self.mTrans_Lock = self:GetRectTransform("Trans_Btn_GrpLocked")
    self.mTrans_Now = self:GetRectTransform("Trans_Btn_GrpNow")

    local btn1 = self:GetButton("Trans_Btn_GrpCompleted")
    local btn2 = self:GetButton("Trans_Btn_GrpNow")
    local btn3 = self:GetButton("Trans_Btn_GrpLocked")
    self.buttonList = {btn1, btn2, btn3}
    local txt1 = self:GetText("Trans_Btn_GrpNow/GrpContent/GrpNor/GrpTextLayer/Text_Layer")
    local txt2 = self:GetText("Trans_Btn_GrpCompleted/GrpContent/GrpNor/GrpTextLayer/Text_Layer")
    local txt3 = self:GetText("Trans_Btn_GrpLocked/GrpContent/GrpNor/GrpTextLayer/Text_Layer")
    self.txtList = {txt1, txt2, txt3}
end

SimCombatTrainingListItem.mData = nil
SimCombatTrainingListItem.stageData = nil
SimCombatTrainingListItem.isUnLock = false
SimCombatTrainingListItem.maxLevel = 0
SimCombatTrainingListItem.mObj = nil
--- const
SimCombatTrainingListItem.PrefabPath = "SimCombat/TrainingListItemV2.prefab"
--- const

function SimCombatTrainingListItem:InitCtrl(parent)
    local itemPrefab = UIUtils.GetGizmosPrefab(self.PrefabPath,self);
    local instObj = instantiate(itemPrefab)

    UIUtils.AddListItem(instObj.gameObject, parent.gameObject)

    self:SetRoot(instObj.transform)
    self:__InitCtrl()
    
    self.mObj = instObj;
end

function SimCombatTrainingListItem:SetData(data, maxLevel)
    if data then
        self.mData = data
        self.maxLevel = maxLevel
        self.stageData = TableData.listStageDatas:GetDataById(data.stage_id)
        for _, txt in ipairs(self.txtList) do
            txt.text = self.mData.id < 10 and (0 .. self.mData.id) or self.mData.id
        end
        self.isUnLock = self:UpdateLockState()
        setactive(self.mTrans_Lock.gameObject, self.maxLevel + 1 < self.mData.id)
        setactive(self.mTrans_Now.gameObject, self.maxLevel + 1 == self.mData.id)
        setactive(self.mTrans_Complete.gameObject, self.maxLevel >= self.mData.id)
        setactive(self.mUIRoot.gameObject, true)
    else
        setactive(self.mUIRoot.gameObject, false)
    end
end

function SimCombatTrainingListItem:UpdateLockState()
    if self.mData.id <= self.maxLevel + 1 then
        return true
    else
        return false
    end
end

function SimCombatTrainingListItem:SetButtonCallback(callback)
    if callback then
        for _, btn in ipairs(self.buttonList) do
            UIUtils.GetButtonListener(btn.gameObject).onClick = callback
        end
    end
end


