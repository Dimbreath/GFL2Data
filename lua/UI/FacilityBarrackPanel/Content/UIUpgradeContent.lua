UIUpgradeContent = class("UIUpgradeContent", UIBarrackContentBase)
UIUpgradeContent.__index = UIUpgradeContent

UIUpgradeContent.PrefabPath = "Character/ChrStageUpPanelV2.prefab"

function UIUpgradeContent:ctor(obj)
    self.rankList = {}
    self.curRank = nil
    self.canUpgrade = false
    self.isItemEnough = false
    self.costItem = nil
    UIUpgradeContent.super.ctor(self, obj)
end

function UIUpgradeContent:__InitCtrl()
    self.mBtn_Upgrade = self:GetButton("Root/GrpRight/GrpAction/BtnTrans_OK/Btn_PowerUp")
    self.mText_Name = self:GetText("Root/GrpRight/Text_Name")
    self.mText_Desc = self:GetText("Root/GrpRight/GrpDescribe/Viewport/Content/Text_Describe")
    self.mTrans_CostTitle = self:GetRectTransform("Root/GrpRight/GrpConsume")
    self.mTrans_CostItem = self:GetRectTransform("Root/GrpRight/GrpItem/ComItemV2")
    self.mTrans_Activate = self:GetRectTransform("Root/GrpRight/GrpAction/Trans_UnLocked")
    self.mTrans_UpgradeLock = self:GetRectTransform("Root/GrpRight/GrpAction/Trans_Locked")

    self.mText_Hint = self:GetText("Root/GrpRight/GrpAction/Trans_Locked/Text_Name")

    self.animator = UIUtils.GetAnimator(self.mUIRoot, "Root")

    for i = 1, TableData.GlobalSystemData.GunMaxGrade do
        local line = nil
        local obj = self:GetRectTransform("Root/GrpStage/Viewport/Content/GrpStageUp/StageUp".. i)
        if i < TableData.GlobalSystemData.GunMaxGrade then
            line = self:GetRectTransform("Root/GrpStage/Viewport/Content/GrpLine/Line" .. i + 1)
        end
        local rank = self:InitRank(obj, line, i)

        table.insert(self.rankList, rank)
    end

    UIUtils.GetButtonListener(self.mBtn_Upgrade.gameObject).onClick = function()
        self:OnUpgradeClick()
    end

    self:InitCostItem()
end

function UIUpgradeContent:InitRank(obj, line, index)
    local rank = {}
    if obj then
        rank.index = index
        rank.obj = obj
        rank.btnUpgrade = UIUtils.GetButton(obj, "ComBarrackStageUp/Btn_GrpState")
        rank.transCanUnlock = UIUtils.GetRectTransform(obj, "ComBarrackStageUp/Btn_GrpState/GrpContent/GrpNor/GrpBg/Trans_ImgCanUnlock")
        rank.transUnlock = UIUtils.GetRectTransform(obj, "ComBarrackStageUp/Btn_GrpState/GrpContent/GrpNor/GrpBg/Trans_ImgUnlock")
        rank.transLock = UIUtils.GetRectTransform(obj, "ComBarrackStageUp/Btn_GrpState/GrpContent/GrpNor/GrpBg/Trans_ImgLocked")
        rank.transSelect = UIUtils.GetRectTransform(obj, "ComBarrackStageUp/Btn_GrpState/GrpContent/GrpSel")
        rank.transEffect = UIUtils.GetRectTransform(obj, "ChrStageUpPanelV2_Effect01")
        rank.transRedPoint = UIUtils.GetRectTransform(obj, "ComBarrackStageUp/Btn_GrpState/GrpContent/Trans_RedPoint")
    end
    
    if line then
        rank.tranLine = line
        rank.transLineLock = UIUtils.GetRectTransform(line, "Trans_GrpLocked")
        rank.transLineUnlock = UIUtils.GetRectTransform(line, "Trans_GrpUnlocked")
    end

    setactive(rank.transSelect, false)
    return rank
end

function UIUpgradeContent:InitCostItem()
    if self.costItem == nil then
        self.costItem = UICommonItem.New()
        self.costItem:InitCtrl(self.mTrans_CostItem)
    end
end

function UIUpgradeContent:SetData(data, parent)
    UIUpgradeContent.super.SetData(self, data, parent)
    if self.curRank then
        self.curRank.btnUpgrade.interactable = true
        setactive(self.curRank.transSelect, false)
    end
    self.isMaxUpgrade = self.mData.maxUpgrade == self.mData.upgrade
    self.curRank = nil
    self:OnEnable(true)
    self:EnableModel(false)

    self:UpdateContent()
end

function UIUpgradeContent:UpdateContent()
    for i, rank in ipairs(self.rankList) do
        if i <= self.mData.maxUpgrade + 1 then
            self:UpdateRank(rank, self.mData.TabGunData.grade[i - 1])
            if self.isMaxUpgrade then
                if rank.index == self.mData.maxUpgrade then
                    self:OnClickRank(rank)
                end
            else
                if rank.index == self.mData.upgrade + 1 then
                    self:OnClickRank(rank)
                    setactive(rank.transRedPoint, self.isItemEnough)
                end
            end
        end
        setactive(rank.obj, i <= self.mData.maxUpgrade + 1)
    end
end

function UIUpgradeContent:UpdateRank(item, skillId)
    if item and skillId then
        item.isActivate = item.index <= self.mData.upgrade
        item.isLock = item.index > self.mData.upgrade + 1
        item.isCanUpgrade = item.index == self.mData.upgrade + 1
        setactive(item.transUnlock, item.isActivate)
        setactive(item.transCanUnlock, item.isCanUpgrade)
        setactive(item.transLock, item.isLock)
        setactive(item.transEffect, false)
        setactive(item.transRedPoint, false)
        if item.tranLine then
            setactive(item.transLineLock, not item.isActivate)
            setactive(item.transLineUnlock, item.isActivate)
        end

        UIUtils.GetButtonListener(item.btnUpgrade.gameObject).onClick = function()
            self:OnClickRank(item)
        end
    end
end

function UIUpgradeContent:OnClickRank(item)
    if self.curRank then
        if self.curRank.index == item.index then
            return
        else
            self.curRank.btnUpgrade.interactable = true
        end
        setactive(self.curRank.transSelect, false)
    end
    setactive(item.transSelect, true)
    self.curRank = item
    self.curRank.btnUpgrade.interactable = false
    self:UpdateRankInfo(item)
end

function UIUpgradeContent:UpdateRankInfo(item)
    if item then
        if item.index > 1 then
            self.costItem:SetItemData(self.mData.TabGunData.core_item_id, self:GetCostNumByUpgrade(item.index - 1), true,true)
        end

        local gunGradeData = TableData.listGunGradeDatas:GetDataById(self.mData.TabGunData.grade[item.index - 1])
        self.mText_Name.text = gunGradeData.name.str
        self.mText_Desc.text = gunGradeData.description.str

        self.mText_Hint.text = string_format(TableData.GetHintById(30029), self.mData.upgrade + 1)

        self.isItemEnough = self.costItem:IsItemEnough()
        setactive(self.mTrans_Activate, item.isActivate)
        setactive(self.mTrans_UpgradeLock, item.isLock)
        setactive(self.mBtn_Upgrade.gameObject, item.isCanUpgrade)
        setactive(self.mTrans_CostItem, item.index > 1)
        setactive(self.mTrans_CostTitle, item.index > 1)

        self.canUpgrade = self.isItemEnough and item.isCanUpgrade and (not self.isMaxUpgrade)
    end
end

function UIUpgradeContent:OnUpgradeClick()
    if self.curRank then
        if self.canUpgrade then
            NetCmdTrainGunData:SendCmdUpgradeGun(self.mData.id, function ()
                self:UpgradeCallback()
            end)
        else
            if not self.isItemEnough then
                UIUtils.PopupHintMessage(40005)
            end
        end
    end
end

function UIUpgradeContent:UpgradeCallback()
    if self.curRank then
        self.curRank.btnUpgrade.interactable = true
        setactive(self.curRank.transSelect, false)
    end
    local curRank = self.curRank
    self.isMaxUpgrade = self.mData.maxUpgrade == self.mData.upgrade
    self.curRank = nil
    self:RefreshGun()
    setactive(curRank.transEffect, true)
    TimerSys:DelayCall(2, function()
        setactive(curRank.transEffect, false)
    end)
end

function UIUpgradeContent:GetCostNumByUpgrade(upgrade)
    if upgrade < 0 then
        return 0
    end
    return TableData.GlobalSystemData.CharacterUpgradeCost[upgrade - 1]
end