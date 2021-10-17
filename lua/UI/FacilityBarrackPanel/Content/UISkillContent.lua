---@class UISkillContent : UIBarrackContentBase
UISkillContent = class("UISkillContent", UIBarrackContentBase)
UISkillContent.__index = UISkillContent

UISkillContent.PrefabPath = "Character/ChrSkillInfoPanelV2.prefab"

function UISkillContent:ctor(obj)
    self.skillList = {}
    self.attrList = {}
    self.curSkill = nil
    self.upgradeDetailList = {}
    self.skillDetailList = {}
    self.upgradeItemList = {}
    self.skillDetail = nil
	self.skillUpgradeEffectDuration = 0
	self.skillUpgradeTimers = {}

    self.costItem = nil
    self.isItemEnough = false

    UISkillContent.super.ctor(self, obj)
end

function UISkillContent:__InitCtrl()
    self.mBtn_LevelInfo = self:GetButton("Root/GrpDialog/GrpSkillOverall/Trans_GrpOff/ComBtn1ItemV2")
    self.mBtn_Goto = self:GetButton("Root/GrpDialog/GrpAction/BtnTrans_OK/Btn_PowerUp")
    self.mBtn_Left = self:GetButton("Root/GrpDialog/GrpSkillSwitch/ComBtnArrowItemV2/GrpLeft/Btn_Left")
    self.mBtn_Right = self:GetButton("Root/GrpDialog/GrpSkillSwitch/ComBtnArrowItemV2/GrpRight/Btn_Right")
    self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_BgClose = self:GetButton("Root/GrpBg/Btn_Close")
    self.mBtn_LevelInfoClose = self:GetButton("Root/GrpDialog/GrpSkillOverall/Trans_GrpOn/GrpBtnOn/ComBtn1ItemV2")
    self.mBtn_LevelInfoBgClose =self:GetButton("Root/GrpDialog/GrpSkillOverall/Trans_GrpOn/Btn_Close")

    self.mImage_Icon = self:GetImage("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpSkillIcon/GrpIcon/Img_Icon")
    self.mText_Name = self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpText/Text_Name")
    self.mText_Level = self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpLevel/Text_Level")
    self.mItem_DeepUse = self:InitAttribute("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpText/GrpDeepUse", 1)
    self.mItem_DeepConsume = self:InitAttribute("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpText/GrpDeepConsume", 2)
    self.mItem_CD = self:InitAttribute("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpText/GrpCD", 3)
    self.mItem_Point = self:InitAttribute("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpText/GrpPoint", 4)
    self.mText_Desc = self:GetText("Root/GrpDialog/GrpCenter/GrpSkillDescription/GrpSkillDescription/Viewport/Content/Text_Describe")

    self.mTrans_Confirm = self:GetRectTransform("Root/GrpConfirm")

    self.mTrans_LevelInfo = self:GetRectTransform("Root/GrpDialog/GrpSkillOverall/Trans_GrpOn")
    self.mTrans_LockUpgrade = self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_Locked")
    self.mTrans_MaxLevel = self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_UnLocked")
    self.mText_LockInfo = self:GetText("Root/GrpDialog/GrpAction/Trans_Locked/Text_Name")
    self.mText_SkillInfo = self:GetText("Root/GrpDialog/GrpSkillOverall/Trans_GrpOn/GrpAllSkillDescription/GrpDescribe/Viewport/Content/Text_Level1")
    self.mTrans_SkillInfoList = self:GetRectTransform("Root/GrpDialog/GrpSkillOverall/Trans_GrpOn/GrpAllSkillDescription/GrpDescribe/Viewport/Content/GrpLevelDescription")

    self.mTrans_Effect = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpEffect")
    self.mGridLayouts = {}
    table.insert(self.mGridLayouts, getchildcomponent(self.mUIRoot, "Root/GrpDialog/GrpCenter/GrpSkillDescription/GrpSkillDiagram/Img_SkillDiagram_9x9", typeof(CS.GridLayout)))
    table.insert(self.mGridLayouts, getchildcomponent(self.mUIRoot, "Root/GrpDialog/GrpCenter/GrpSkillDescription/GrpSkillDiagram/Img_SkillDiagram_17x17", typeof(CS.GridLayout)))
    table.insert(self.mGridLayouts, getchildcomponent(self.mUIRoot, "Root/GrpDialog/GrpCenter/GrpSkillDescription/GrpSkillDiagram/Img_SkillDiagram_21x21", typeof(CS.GridLayout)))

    UIUtils.GetButtonListener(self.mBtn_LevelInfoClose.gameObject).onClick = function()
        self:OnCloseLevelInfo()
    end

    UIUtils.GetButtonListener(self.mBtn_Goto.gameObject).onClick = function()
        self:OnClickGoto()
    end

    UIUtils.GetButtonListener(self.mBtn_LevelInfo.gameObject).onClick = function()
        self:OnClickLevelInfo()
    end

    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = function()
        self:OnCloseContent()
    end

    UIUtils.GetButtonListener(self.mBtn_BgClose.gameObject).onClick = function()
        self:OnCloseContent()
    end

    UIUtils.GetButtonListener(self.mBtn_Left.gameObject).onClick = function()
        self:OnClickSkillChange(-1)
    end

    UIUtils.GetButtonListener(self.mBtn_Right.gameObject).onClick = function()
        self:OnClickSkillChange(1)
    end

    UIUtils.GetButtonListener(self.mBtn_LevelInfoBgClose.gameObject).onClick = function()
        self:OnCloseLevelInfo()
    end
end

function UISkillContent:InitAttribute(path, index)
    local obj = self:GetRectTransform(path)
    if obj then
        local attr = {}
        attr.obj = obj
        attr.index = index
        attr.attrName = FacilityBarrackGlobal.ShowSKillAttr[index]
        attr.txtName = UIUtils.GetText(obj, "TextName")
        attr.txtNum = UIUtils.GetText(obj, "Text_Num")

        attr.txtName.text = TableData.GetHintById(102061 + index)
        table.insert(self.attrList, attr)
    end
end

function UISkillContent:SetData(data, parent)
    UISkillContent.super.SetData(self, data, parent)
    self:UpdateContent()
    self:OnEnable(true)
end

function UISkillContent:UpdateContent()
    self.curSkill = self:GetSkillDataByType(self.mData)
    self:UpdateSkillInfo()
end

function UISkillContent:UpdateSkillInfo()
    local skillData = self.curSkill
    if skillData then
        self.mImage_Icon.sprite = IconUtils.GetSkillIconByAttr(skillData.data.icon, skillData.data.icon_attr_type,self.mParent.isGunLock and self.mParent.mData.WeaponDefaultId or self.mParent.mData.WeaponStcId)
        self.mText_Level.text = skillData.data.level
        self.mText_Name.text = skillData.data.name.str
        self.mText_Desc.text = skillData.data.description.str
        if not skillData.isUnLock then
            self.mText_LockInfo.text = string_format(TableData.GetHintById(102106), skillData.unlockGrade)
        end

        self:UpdateAttribute()
        CS.SkillRangeUIHelper.SetSkillRange(self.mGridLayouts, 1, skillData.data)
        setactive(self.mBtn_Goto.gameObject,  not self.mParent.isGunLock and skillData.isUnLock and skillData.data.id < skillData.maxLevel)
        setactive(self.mTrans_MaxLevel, not self.mParent.isGunLock and skillData.data.id == skillData.maxLevel)
        setactive(self.mTrans_LockUpgrade, not skillData.isUnLock)
    end
end

function UISkillContent:UpdateAttribute()
    for i, attr in ipairs(self.attrList) do
        local num = self.curSkill.data[attr.attrName]
        if attr.attrName == "skill_points" then
            if num ~= "" then
                num = tonumber(string.split(num, ",")[1])
            else
                num = 0
            end
        end
        attr.txtNum.text = num
        setactive(attr.obj, num > 0)
    end
end

function UISkillContent:OnUpgradeEffectEnd(targetObj)
	setactive(targetObj, false)
end

function UISkillContent:UpdateSkillUpConfirm()
    if self.curSkill then
        self.mConfirmView.mImage_ConfirmIcon.sprite = UIUtils.GetIconSprite("Icon/Skill", self.curSkill.data.icon)
        self.mConfirmView.mText_ConfirmName.text = self.curSkill.data.name.str

        if self.curSkill.data.level < self.curSkill.maxLevel then
            local nextLevel = self.curSkill.data.level + 1
            local nextSkillData = TableData.GetGroupSkill(self.curSkill.skillGroup.group_id, nextLevel)
            self.mConfirmView.mText_ConfirmDesc.text = nextSkillData.upgrade_description.str
            self.mConfirmView.mText_ConfirmCurLevel.text = self.curSkill.data.level
            self.mConfirmView.mText_ConfirmNextLevel.text = nextLevel
        end

        self:UpdateCostItem(self.curSkill.skillGroup)
    end
end

function UISkillContent:UpdateCostItem(skillGroup)
    if skillGroup then
        local itemList = skillGroup:GetItemConsumptionDict()
        local tempList = {}
        for id, num in pairs(itemList) do
            local item = {}
            item.id = id
            item.num = num
            table.insert(tempList, item)
        end

        table.sort(tempList, function (a, b) return a.id < b.id end)

        local itemIsEnough = false
        for i = 1, #tempList do
            if tempList[i].id == GlobalConfig.CoinId then
                local count = NetCmdItemData:GetItemCountById(tempList[i].id)
                self.mConfirmView.mImage_CoinIcon.sprite = IconUtils.GetItemIconSprite(tempList[i].id)

                local text = (count >= tempList[i].num) and FacilityBarrackGlobal.ItemCountRichText or FacilityBarrackGlobal.ItemCountNotEnoughText
                self.mConfirmView.mText_CoinCost.text = string_format(text, count, tempList[i].num)

                itemIsEnough = count >= tempList[i].num
            else
                if self.costItem == nil then
                    self.costItem = UICommonItem.New()
                    self.costItem:InitObj(self.mConfirmView.mTrans_CostItem)
                end
                self.costItem:SetItemData(tempList[i].id, tempList[i].num, true,true)
                itemIsEnough = self.costItem:IsItemEnough()
            end
        end

        self.isItemEnough = itemIsEnough
    end
end

function UISkillContent:CheckSkillIsUnLock(skillType)
    if skillType then
        local mentalData = TableData.listMentalCircuitDatas:GetDataById(self.mData.stc_gun_id)
        local unLockList = TableData.GlobalSystemData.SkillUnlockRank
        local unLockRank = unLockList[skillType]
        local rankNum = 1
        if self.mData.current_mental_node ~= nil then
            for i = 0, mentalData.rank_list.Count - 1 do
                if mentalData.rank_list[i] == self.mData.current_mental_node.Id then
                    rankNum = i + 1
                    break
                end
            end
        end

        local rankData = TableData.listMentalRankDatas:GetDataById(mentalData.rank_list[unLockRank - 1])
        return rankNum >= unLockRank, rankData.name.str
    end
    return false
end

function UISkillContent:OnClickLevelInfo()
    self:UpdateSkillListInfo()
    setactive(self.mTrans_LevelInfo, true)
end

function UISkillContent:OnCloseLevelInfo()
    setactive(self.mTrans_LevelInfo, false)
end

function UISkillContent:UpdateSkillListInfo()
    for i, skill in ipairs(self.skillDetailList) do
        skill:SetData(nil)
    end

    local skillLv1 = luaRoundNum(self.curSkill.data.id - self.curSkill.data.level) + 1
    local curSkillLevel = self.curSkill.data.level
    if skillLv1 and curSkillLevel then
        local maxLevel = self.curSkill.maxLevel
        local skillList = {}
        for i = skillLv1, maxLevel do
            local skillData = TableData.listBattleSkillDatas:GetDataById(i)
            if skillData.level == 1 then
                self.mText_SkillInfo.text = skillData.description.str
            else
                table.insert(skillList, skillData)
            end
        end

        for i = 1, #skillList do
            local item = nil
            if i <= #self.skillDetailList then
                item = self.skillDetailList[i]
            else
                item = UISkillDetailItem.New()
                item:InitCtrl(self.mTrans_SkillInfoList)
                table.insert(self.skillDetailList, item)
            end
            item:SetData(skillList[i], curSkillLevel)
        end
    end
end

function UISkillContent:GetSkillDataByType(id)
    for _, skill in ipairs(self.mParent.skillList) do
        if skill.type == id then
           return skill
        end
    end

    return nil
end

function UISkillContent:OnClickSkillChange(step)
    local curType = self.curSkill.type + step
    if curType < 1 then
        curType = 4
    elseif curType > 4 then
        curType = 1
    end
    self.mData = curType
    self.curSkill = self:GetSkillDataByType(curType)
    self:UpdateSkillInfo()
end

function UISkillContent:OnCloseContent()
    self:OnEnableEffect(false)
    self:OnEnable(false)
end

function UISkillContent:OnClickGoto()
    self:OnCloseContent()
    self.mParent:ChangeTab(FacilityBarrackGlobal.PowerUpType.Upgrade)
end

function UISkillContent:OnEnableEffect(enable)
    setactive(self.mTrans_Effect, enable)
end


