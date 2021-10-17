require("UI.UIBaseCtrl")

SimCombatEquipItem = class("SimCombatEquipItem", UIBaseCtrl);
SimCombatEquipItem.__index = SimCombatEquipItem
--@@ GF Auto Gen Block Begin
function SimCombatEquipItem:__InitCtrl()
    self.mText_Name = self:GetText("Root/GrpTopLeft/Text")
    self.mText_Chapter = self:GetText("Root/GrpSimCombatLine/Trans_Text_Chapter")
    --self.mImage_ChooseIcon = self:GetImage("Con_Item/Trans_Now/Image_StageIcon")
    --self.mImage_Icon = self:GetImage("Con_Item/Image_StageIcon")
    --self.mTrans_LeftPoint = self:GetRectTransform("Con_Item/Trans_LeftPoint")
    --self.mTrans_RightPoint = self:GetRectTransform("Con_Item/Trans_RightPoint")
    --self.mTrans_RightLine = self:GetRectTransform("Con_Item/Trans_RightLine")
    --self.mTrans_LeftLine = self:GetRectTransform("Con_Item/Trans_LeftLine")
    --self.mTrans_Done = self:GetRectTransform("Con_Item/Trans_Done")
    self.mBtn_Equip = self:GetSelfButton();
    self.mTrans_Lock = self:GetRectTransform("Root/GrpState/Trans_GrpLocked")
    self.mTrans_UnLock = self:GetRectTransform("Root/GrpState/Trans_GrpUnlocked")
    --self.mTrans_Empty = self:GetRectTransform("Con_Empty")
    --self.mText_Desc = self:GetText("Con_Item/Text_Desc")
    --self.mTrans_Now = self:GetRectTransform("Root/GrpState/Trans_GrpNow")
    --self.mTrans_Choose = self:GetRectTransform("Con_Item/Trans_Choose")
    self.mTrans_challenge1 = self:GetRectTransform("Root/GrpStage/GrpStage1/Trans_On")
    self.mTrans_challenge2 = self:GetRectTransform("Root/GrpStage/GrpStage2/Trans_On")
    self.mTrans_challenge3 = self:GetRectTransform("Root/GrpStage/GrpStage3/Trans_On")

    self.mTrans_Root = self:GetRectTransform("Root")
    --setactive(self.mTrans_LeftLine, false)
end

--@@ GF Auto Gen Block End

SimCombatEquipItem.mData = nil
SimCombatEquipItem.stageData = nil
SimCombatEquipItem.isUnLock = false

SimCombatEquipItem.OrangeColor = Color(246 / 255, 113 / 255, 25 / 255, 255 / 255)
SimCombatEquipItem.WhiteColor = Color(1, 1, 1, 0.6)

function SimCombatEquipItem:InitCtrl(root)
    self:SetRoot(root);
    self:__InitCtrl();
    --self:InitLineImage()
end

function SimCombatEquipItem:InitLineImage()
    self.lineList = {}
    -- self.pointList = {}
    for i = 1, self.mTrans_RightLine.childCount do
        local obj = UIUtils.GetImage(self.mTrans_RightLine, "Image_RightLine" .. i)
        table.insert(self.lineList, obj)
    end

    for i = 1, self.mTrans_LeftLine.childCount do
        local obj = UIUtils.GetImage(self.mTrans_LeftLine, "Image_RightLine" .. i)
        table.insert(self.lineList, obj)
    end

    -- local leftPoint = UIUtils.GetImage(self.mTrans_LeftPoint, "Image_LeftLine")
    -- local rightPoint = UIUtils.GetImage(self.mTrans_RightPoint, "Image_LeftLine")
    -- table.insert(self.pointList, leftPoint)
    -- table.insert(self.pointList, rightPoint)
end

function SimCombatEquipItem:SetData(data, icon, isLastItem)
    if data then
        self.mData = data
        self.recordData = NetCmdStageRecordData:GetStageRecordById(data.stage_id)
        self.stageData = TableData.listStageDatas:GetDataById(data.stage_id)
        local index = tonumber(data.sequence)
        self.mText_Name.text = self.stageData.name.str
        self.mText_Chapter.text = self.stageData.code
        --self.mImage_Icon.sprite = IconUtils.GetSimCombatSprite(icon)
        --self.mImage_ChooseIcon.sprite = IconUtils.GetSimCombatSprite(icon)
        self:UpdateState(false)

        -- if index % 2 == 0 then
        --     self.mTrans_Empty.transform:SetAsFirstSibling()
        -- else
        --     self.mTrans_Empty.transform:SetAsLastSibling()
        -- end

        self.isUnLock = self:UpdateLockState()
        setactive(self.mTrans_Lock.gameObject, not self.isUnLock)
        setactive(self.mTrans_UnLock.gameObject, self.isUnLock)

        local isDone = NetCmdSimulateBattleData:CheckStageIsUnLock(self.mData.id)
        --setactive(self.mTrans_Done, isDone)

        --self:InitLine(isLastItem)
        --self:SetLineColor(isDone)
        self:UpdateChallenge()
        -- self:SetPointColor(self.isUnLock)
        --setactive(self.mTrans_Now, false)
        setactive(self.mUIRoot.gameObject, true)
    else
        setactive(self.mUIRoot.gameObject, false)
    end
end

function SimCombatEquipItem:UpdateState(isChoose)
    --setactive(self.mTrans_Choose.gameObject, isChoose)
    self.mBtn_Equip.interactable = not isChoose
end

function SimCombatEquipItem:SetLineColor(isComplete)
    local color = isComplete and SimCombatEquipItem.OrangeColor or SimCombatEquipItem.WhiteColor
    for _, v in ipairs(self.lineList) do
        v.color = color
    end
end

--function SimCombatEquipItem:SetPointColor(isComplete)
--    local color = isComplete and SimCombatEquipItem.OrangeColor or SimCombatEquipItem.WhiteColor
--    for _, v in ipairs(self.pointList) do
--        v.color = color
--    end
--end

function SimCombatEquipItem:UpdateLockState()
    if self.mData.unlock == 1 then
        return true
    elseif self.mData.unlock == 2 then
        return NetCmdSimulateBattleData:CheckStageIsUnLock(self.mData.unlock_detail)
    elseif self.mData.unlock == 3 then

    end
end

function SimCombatEquipItem:InitLine(isLastItem)
    --if index == 1 then
    --    setactive(self.mTrans_LeftPoint.gameObject, false)
    --    setactive(self.mTrans_RightPoint.gameObject,false)
    --else
    --    setactive(self.mTrans_LeftPoint.gameObject, isRight)
    --    setactive(self.mTrans_RightPoint.gameObject, not isRight)
    --end
    setactive(self.mTrans_RightLine.gameObject, not isLastItem)
end

function SimCombatEquipItem:UpdateChallenge()
    for i = 1, GlobalConfig.MaxChallenge do
        setactive(self["mTrans_challenge" .. i],  self.recordData ~= nil and self.recordData.complete_challenge.Length >= i)
    end
end
