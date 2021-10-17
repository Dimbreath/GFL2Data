require("UI.Common.PropertyItemS")

UIGunInfoContent = class("UIGunInfoContent", UIBarrackContentBase)
UIGunInfoContent.__index = UIGunInfoContent

UIGunInfoContent.PrefabPath = "Character/ChrOverviewPanelV2.prefab"

function UIGunInfoContent:ctor(obj)
    self.gunMaxkLevel = 0

    self.attributeList = {}
    self.upgradeList = {}
    self.skillList = {}
    ---@type UISkillContent
    self.skillLevelUpPanel = nil
    ---@type UILevelUpContent
    self.levelUpPanel = nil

    self.dutyItem = nil
    self.fragmentItem = nil
    self.isGunLock = false

    UIGunInfoContent.super.ctor(self, obj)
end

function UIGunInfoContent:__InitCtrl()
    self.mBtn_PowerInfo = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpRight/GrpChrInfo/GrpCombatEffect/BtnAllDescription"))
    self.mBtn_LevelUp = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpRight/GrpAction/Trans_BtnLevelUp"))
    self.mBtn_Fragment = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpRight/GrpAction/Trans_BtnMix"))

    self.mTrans_Level = self:GetRectTransform("Root/GrpLevel")
    self.mText_Level = self:GetText("Root/GrpLevel/GrpChrLevel/GrpLevel/GrpTextLevel/Text_LvNumNow")
    self.mText_MaxLevel = self:GetText("Root/GrpLevel/GrpChrLevel/GrpLevel/GrpTextLevel/Text_LvNumMax")
    self.mImage_LevelSlider = self:GetImage("Root/GrpLevel/GrpChrLevel/GrpLevel/GrpSlider/Img_Slider")
    self.mText_Exp = self:GetText("Root/GrpLevel/GrpChrTextExp/Text_ExpNum")

    self.mText_Name = self:GetText("Root/GrpRight/GrpChrInfo/GrpTextName/Text_Name")
    self.mImage_MentalLevel = self:GetImage("Root/GrpRight/GrpChrInfo/GrpMental/GrpLevel/Img_Level")
    self.mText_Power = self:GetText("Root/GrpRight/GrpChrInfo/GrpCombatEffect/GrpCombatEffect/Text_Num")
    self.mImage_Rank = self:GetImage("Root/GrpRight/GrpChrInfo/GrpLine/ImgLine")
    self.mTrans_AttrList = self:GetRectTransform("Root/GrpRight/GrpAttribute/AttributeList/Viewport/Content")
    self.mTrans_Duty = self:GetRectTransform("Root/GrpRight/GrpChrInfo/GrpElement")
    self.mText_DutyName = self:GetText("Root/GrpRight/GrpChrInfo/GrpType/Text_Name")

    self.mTrans_LevelBtn = self:GetRectTransform("Root/GrpRight/GrpAction/Trans_BtnLevelUp")
    self.mTrans_FragmentBtn = self:GetRectTransform("Root/GrpRight/GrpAction/Trans_BtnMix")
    self.mTrans_MaxLevel = self:GetRectTransform("Root/GrpRight/GrpAction/Trans_MaxLevel")
    self.mText_MaxHint = self:GetText("Root/GrpRight/GrpAction/Trans_MaxLevel/Text_Name")

    self.mTrans_LevelUp = self:GetRectTransform("Root/GrpGunLevelUp")
    self.mTrans_SkillLvUp = self:GetRectTransform("Root/GrpSkillLevelUp")

    self.mTrans_FragmentItem = self:GetRectTransform("Root/GrpRight/GrpFragmentItem")
    self.mTrans_Lock = self:GetRectTransform("Root/GrpRight/GrpAction/Trans_Locked")
    self.mText_LockHint = self:GetText("Root/GrpRight/GrpAction/Trans_Locked/Text_Name")

    UIUtils.GetButtonListener(self.mBtn_LevelUp.gameObject).onClick = function()
        self:OnClickLevelUp()
    end

    UIUtils.GetButtonListener(self.mBtn_PowerInfo.gameObject).onClick = function()
        self:OnClickPowerInfo()
    end

    UIUtils.GetButtonListener(self.mBtn_Fragment.gameObject).onClick = function()
        self:OnClickFragment()
    end

    for i = 1, TableData.GlobalSystemData.GunMaxGrade do
        local obj = self:GetRectTransform("Root/GrpRight/GrpChrInfo/GrpStage/GrpStage" .. i)
        local item = self:InitUpgrade(obj)
        table.insert(self.upgradeList, item)
    end

    for i = 1, 4 do
        local obj = self:GetRectTransform("Root/GrpRight/GrpSkill/GrpSkill" .. i)
        local item = self:InitSkill(obj, i)
        table.insert(self.skillList, item)
    end

    self:InitAttributeList()
    self:InitDutyItem()
    self:InitFragmentItem()
end

function UIGunInfoContent:InitUpgrade(obj)
    if obj then
        local item = {}
        item.obj = obj

        item.transOn = UIUtils.GetRectTransform(obj, "Trans_On")
        item.transOff = UIUtils.GetRectTransform(obj, "Trans_Off")

        return item
    end
end

function UIGunInfoContent:InitSkill(parent, type)
    if parent then
        local item = {}
        local obj = self:InstanceUIPrefab("Character/ChrBarrackSkillItemV2.prefab", parent, true)
        item.obj = obj
        item.type = type
        item.btnSkill = UIUtils.GetButton(obj)
        item.imgIcon = UIUtils.GetImage(obj, "GrpIcon/Img_Icon")
        item.txtLevel = UIUtils.GetText(obj, "GrpLevel/GrpText/Text_Level")
        item.transLock = UIUtils.GetRectTransform(obj, "Trans_GrpLock")
        item.transRedPoint = UIUtils.GetRectTransform(obj, "GrpRedPoint")

        return item
    end
end

function UIGunInfoContent:InitAttributeList()
    for i, att in ipairs(FacilityBarrackGlobal.ShowAttribute) do
        local attr = UICommonPropertyItem.New()
        attr:InitCtrl(self.mTrans_AttrList)
        attr:SetDataByName(att, 0, true, true, false, false)

        table.insert(self.attributeList, attr)
    end
end

function UIGunInfoContent:InitDutyItem()
    if self.dutyItem == nil then
        self.dutyItem = UICommonDutyItem.New()
        self.dutyItem:InitCtrl(self.mTrans_Duty)
    end
end

function UIGunInfoContent:InitFragmentItem()
    local item = UICommonItem.New()
    item:InitCtrl(self.mTrans_FragmentItem)
    self.fragmentItem = item
end

function UIGunInfoContent:OnShow()

end

function UIGunInfoContent:OnHide()
end

function UIGunInfoContent:OnUpdate()
    if self.levelUpPanel ~= nil then
        self.levelUpPanel:OnUpdate()
    end
end

function UIGunInfoContent:SetData(data, parent)
    UIGunInfoContent.super.SetData(self, data, parent)
    self.isGunLock = NetCmdTeamData:GetGunByID(data.id) == nil
    self:UpdateContent()
    self:EnableModel(true)
    self:OnEnable(true)
end

function UIGunInfoContent:UpdateContent()
    self:UpdateLevelInfo()
    self:UpdateGunInfo()
end

function UIGunInfoContent:UpdateLevelInfo()
    local gunData = self.mData
    self.gunMaxLevel = self.mData.MaxGunLevel
    self.mText_Level.text = gunData.level
    self.mText_MaxLevel.text = self.gunMaxLevel

    local nextLevel = (gunData.level >= self.gunMaxLevel) and self.gunMaxLevel or (gunData.level + 1)
    local nextLevelExp = TableData.listGunLevelExpDatas:GetDataById(nextLevel)
    if nextLevelExp then
        local curExp = gunData.exp
        if gunData.level >= self.gunMaxLevel then
            curExp = nextLevelExp.exp
        end
        local fillAmount = curExp / nextLevelExp.exp
        self.mImage_LevelSlider.fillAmount = fillAmount
        self.mText_Exp.text = string_format("{0}/{1}", curExp, nextLevelExp.exp)
    else
        self.mImage_LevelSlider.fillAmount = 0
        self.mText_Exp.text.text = string_format("{0}/{1}", 0, 0)
    end

    setactive(self.mTrans_MaxLevel, gunData.level >= self.gunMaxLevel and AccountNetCmdHandler:CheckSystemIsUnLock(SystemList.GundetailLevelup))
    local hint = ""
    if gunData.level >= self.gunMaxLevel then
        hint = TableData.GetHintById(30020)
    end
    self.mText_MaxHint.text = hint
end

function UIGunInfoContent:UpdateGunInfo()
    local gunData = self.mData
    local dutyData = TableData.listGunDutyDatas:GetDataById(gunData.TabGunData.duty)
    self.mText_Name.text = gunData.TabGunData.name.str
    self.mImage_MentalLevel.sprite = IconUtils.GetMentalIcon(FacilityBarrackGlobal.RomaIconPrefix .. gunData.currentMentalRank + 1)
    self.mText_Power.text = NetCmdTeamData:GetGunFightingCapacity(gunData)
    self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(gunData.TabGunData.rank)

    self.mText_DutyName.text = dutyData.name.str
    self.dutyItem:SetData(dutyData)

    for i, item in ipairs(self.upgradeList) do
        setactive(item.transOn, i <= gunData.upgrade)
        setactive(item.transOff, i > gunData.upgrade)
    end

    self:UpdateAttributeList()
    self:UpdateSkillItem()
    self:UpdateFragment()
    self:UpdateGunLevelLock()
end

function UIGunInfoContent:UpdateFightingCapacity()
    self.mText_Power.text = NetCmdTeamData:GetGunFightingCapacity(self.mData)
end

function UIGunInfoContent:UpdateGunLevelLock()
    local isUnlock = AccountNetCmdHandler:CheckSystemIsUnLock(SystemList.GundetailLevelup)
    local lockInfo = TableData.GetUnLockInfoByType(SystemList.GundetailLevelup)
    self.mText_LockHint.text = lockInfo.prompt.str
    setactive(self.mTrans_LevelBtn, (not self.isGunLock) and self.mData.level < self.gunMaxLevel and isUnlock)
    setactive(self.mTrans_Lock, (not self.isGunLock) and not isUnlock)
end

function UIGunInfoContent:UpdateSkillItem()
    if self.skillList then
        local data = self:GetSkillDataList()
        for i, skill in ipairs(self.skillList) do
            if data[i] == nil then
                gferror("ID:".. self.mData.id .. "人形第" .. i .. "个技能为空，请及时处理~")
            else
                local skillData = TableData.listBattleSkillDatas:GetDataById(data[i].id)
                skill.data = skillData
                skill.maxLevel = data[i].maxLevel
                skill.isUnLock = not data[i].isLock
                skill.unlockGrade = data[i].unlockGrade
                skill.imgIcon.sprite = IconUtils.GetSkillIconByAttr(skillData.icon, skillData.icon_attr_type, self.isGunLock and self.mData.WeaponDefaultId or self.mData.WeaponStcId)
                skill.txtLevel.text = GlobalConfig.LVText .. skillData.level

                setactive(skill.transLock, data[i].isLock)

                UIUtils.GetButtonListener(skill.btnSkill.gameObject).onClick = function()
                    self:OnClickSkill(skill.type)
                end

                setactive(skill.transRedPoint, false)
            end
        end
    end
end

function UIGunInfoContent:UpdateFragment()
    if self.isGunLock then
        if self.fragmentItem then
            self.fragmentItem:SetItemData(self.mData.TabGunData.core_item_id, tonumber(self.mData.TabGunData.unlock_cost), true, true)
        end
    end
    setactive(self.mTrans_FragmentItem, self.isGunLock)
    setactive(self.mTrans_FragmentBtn, self.isGunLock)
end

function UIGunInfoContent:OnClickSkill(type)
    if self.skillLevelUpPanel == nil then
        self.skillLevelUpPanel = UISkillContent.New()
        self.skillLevelUpPanel:InitCtrl(self.mTrans_SkillLvUp)
    end
    self.skillLevelUpPanel:SetData(type, self)
end

function UIGunInfoContent:OnClickLevelUp()
    if self.levelUpPanel == nil then
        self.levelUpPanel = UILevelUpContent.New()
        self.levelUpPanel:InitCtrl(self.mTrans_LevelUp)
    end
    self.levelUpPanel:SetData(self.mData, self)
end

function UIGunInfoContent:OnClickPowerInfo()
    UIManager.OpenUIByParam(UIDef.UICharacterPropPanel, self.mData.id)
end

function UIGunInfoContent:OnClickFragment()
    if self.fragmentItem then
        if not self.fragmentItem:IsItemEnough() then
            CS.PopupMessageManager.PopupString(GlobalConfig.GetCostNotEnoughStr(self.fragmentItem.itemId))
            return
        else
            NetCmdTrainGunData:SendCmdUpgradeGun(self.mData.id, function (ret)
                self:UnLockCallBack(ret)
            end)
        end
    end
end

function UIGunInfoContent:UnLockCallBack(ret)
    if ret == CS.CMDRet.eSuccess then
        printstack("解锁人形成功");
        UICommonGetGunPanel.OpenGetGunPanel(self.mData.id, nil, UICommonGetGunPanel.GunType.Gun)
        self:RefreshGun()
    else
        printstack("解锁人形失败");
    end
end

function UIGunInfoContent:CheckSkillIsUnLock(skillType)
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

function UIGunInfoContent:UpdateAttributeList()
    for i, attName in ipairs(FacilityBarrackGlobal.ShowAttribute) do
        local attr = self.attributeList[i]
        local value = self.mData:GetGunPropertyValueByType(attName)
        attr:UpdateAttrValue(value)
    end
end

function UIGunInfoContent:GetSkillDataList()
    local list = {}
    if self.mData then
        table.insert(list, {id = self.mData.TabGunData.skill_normal_attack, isLock = false, maxLevel = self.mData.TabGunData.skill_normal_attack})
        for i = 0, self.mData.TabGunData.grade.Count - 1 do
            local gradeId = self.mData.TabGunData.grade[i]
            local gradeSkillData = TableData.listGunGradeDatas:GetDataById(gradeId)
            for j = 0, gradeSkillData.abbr.Count - 1 do
                local skill = {}
                local id = gradeSkillData.abbr[j]
                local index, item = tableIsContain(list, function (a) return luaRoundNum(a.id / 10) == luaRoundNum(id / 10 ) end)
                if index == -1 then
                    skill.id = id
                    skill.isLock = (self.mData.upgrade - 1 < i)
                    skill.maxLevel = id
                    skill.unlockGrade = i + 1
                    table.insert(list, skill)
                else
                    if id > item.id then
                        if self.mData.upgrade - 1 >= i  then
                            item.id = id
                            item.isLock = (self.mData.upgrade - 1 < i)
                        end
                        item.maxLevel = id
                    end
                end
            end
        end
    end
    return list
end


function UIGunInfoContent:EnableLevelInfo(enable)
    setactive(self.mTrans_Level, enable)
end

function UIGunInfoContent:OnEnable(enable)
	UIGunInfoContent.super.OnEnable(self, enable)
	if enable then
		UIModelToucher.SwitchToucher(1);
	end
end