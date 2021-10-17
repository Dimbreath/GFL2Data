require("UI.UIBaseCtrl")

UIBarrackWeaponInfoItem = class("UIBarrackWeaponInfoItem", UIBaseCtrl)
UIBarrackWeaponInfoItem.__index = UIBarrackWeaponInfoItem

function UIBarrackWeaponInfoItem:ctor()
    UIBarrackWeaponInfoItem.super.ctor(self)
    self.data = nil
    self.lockCallback = nil
    self.skillList = {}
    self.attributeList = {}
    self.elementItem = nil
    self.stageItem = nil
end

function UIBarrackWeaponInfoItem:__InitCtrl()
    self.mText_Name = self:GetText("GrpTextName/Text_Name")
    self.mImage_Rank = self:GetImage("AttributeList/Viewport/Content/GrpLine/Img_Line")
    self.mText_Level = self:GetText("GrpWeaponLevel/GrpText/Text_Level")
    self.mText_Type = self:GetText("GrpType/Text_Name")
    self.mText_Power = self:GetText("AttributeList/Viewport/Content/GrpCombatNum/Text_Num")
    self.mTrans_AttrList = self:GetRectTransform("AttributeList/Viewport/Content/GrpAttribute")

    for i = 1, 2 do
        local skill = UIWeaponSkillItem.New()
        skill:InitCtrl(self:GetRectTransform("AttributeList/Viewport/Content/GrpSkill"))
        skill:EnableInfoBtn(true)
        table.insert(self.skillList, skill)
    end

    self:InitStageItem()
    self:InitElementItem()
    self:InitLockItem()

    UIUtils.GetButtonListener(self.mBtn_Lock.gameObject).onClick = function()
        self:OnClickLock()
    end
end

function UIBarrackWeaponInfoItem:InitElementItem()
    if self.elementItem == nil then
        local parent = self:GetRectTransform("GrpElement")
        self.elementItem = UICommonElementItem.New()
        self.elementItem:InitCtrl(parent)
    end
end

function UIBarrackWeaponInfoItem:InitStageItem()
    if self.stageItem == nil then
        local parent = self:GetRectTransform("GrpStage")
        self.stageItem = UICommonStageItem.New(GlobalConfig.MaxStar)
        self.stageItem:InitCtrl(parent)
    end
end

function UIBarrackWeaponInfoItem:InitLockItem()
    local parent = self:GetRectTransform("Trans_BtnLock")
    local obj = self:InstanceUIPrefab("UICommonFramework/ComLockItemV2.prefab", parent, true)
    self.mBtn_Lock = UIUtils.GetButton(obj)
    self.mTrans_Lock = UIUtils.GetRectTransform(obj, "ImgLocked")
    self.mTrans_Unlock = UIUtils.GetRectTransform(obj, "ImgUnLocked")
end

function UIBarrackWeaponInfoItem:OnClickLock()
    NetCmdWeaponData:SendGunWeaponLockUnlock(self.data.id, function()
        if self.lockCallback ~= nil then
            self.lockCallback(self.data.id, self.data.IsLocked)
        end
        self:UpdateLockStatue()
    end)
end

function UIBarrackWeaponInfoItem:UpdateLockStatue()
    setactive(self.mTrans_Unlock, not self.data.IsLocked)
    setactive(self.mTrans_Lock, self.data.IsLocked)
end

function UIBarrackWeaponInfoItem:InitCtrl(root, lockCallback)
    self:SetRoot(root)
    self:__InitCtrl()

    self.lockCallback = lockCallback
end

function UIBarrackWeaponInfoItem:SetData(data)
    if data then
        self.data = data
        local elementData = TableData.listLanguageElementDatas:GetDataById(data.Element)
        local typeData = TableData.listGunWeaponTypeDatas:GetDataById(data.Type)
        self.mText_Name.text = data.Name
        self.mText_Type.text = typeData.name.str
        self.mText_Level.text = string_format(UIWeaponGlobal.WeaponLvRichText2, data.Level, data.CurMaxLv)
        self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(data.Rank)
        self.mText_Power.text = self.data:GetPower()
        self.elementItem:SetData(elementData)
        self:UpdateStar(data.BreakTimes, data.MaxBreakTime)
        self:UpdateAttribute(data)
        self:UpdateLockStatue()
        self:UpdateSkill(self.skillList[UIWeaponGlobal.SkillType.NormalSkill], data.Skill, UIWeaponGlobal.SkillType.NormalSkill)
        self:UpdateSkill(self.skillList[UIWeaponGlobal.SkillType.BuffSkill], data.BuffSkill, UIWeaponGlobal.SkillType.BuffSkill)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIBarrackWeaponInfoItem:UpdateSkill(skill, data, type)
    setactive(skill.mUIRoot, data ~= nil)
    if data then
        skill:SetDataBySkillData(data, true)

        if type == UIWeaponGlobal.SkillType.BuffSkill then
            local value = 0.5
            if self.data.slotList.Length == self.data.PartsCount then
                value = 1
            end
            skill:SetNum(self.data.PartsCount, self.data.slotList.Length)
            UIUtils.SetCanvasGroupValue(skill.mUIRoot.gameObject, value)
        else
            skill:SetLevel(data.level)
        end
    end
end

function UIBarrackWeaponInfoItem:UpdateStar(star, maxStar)
    self.stageItem:ResetMaxNum(maxStar)
    self.stageItem:SetData(star)
end

function UIBarrackWeaponInfoItem:UpdateAttribute(data)
    local attrList = {}

    local expandList = TableData.GetPropertyExpandList()
    for i = 0, expandList.Count - 1 do
        local lanData = expandList[i]
        if (lanData.type == 1) then
            local value = data:GetPropertyByLevelAndSysName(lanData.sys_name, data.CurLv, data.BreakTimes)
            if (value > 0) then
                local attr = {}
                attr.propData = lanData
                attr.value = value
                table.insert(attrList, attr)
            end
        end
    end

    table.sort(attrList, function(a, b)
        return a.propData.order < b.propData.order
    end)

    for _, item in ipairs(self.attributeList) do
        item:SetData(nil)
    end

    for i = 1, #attrList do
        local item = nil
        if i <= #self.attributeList then
            item = self.attributeList[i]
        else
            item = UICommonPropertyItem.New()
            item:InitCtrl(self.mTrans_AttrList)
            table.insert(self.attributeList, item)
        end
        item:SetData(attrList[i].propData, attrList[i].value, true, false, false, false)
        item:SetTextColor(attrList[i].propData.statue == 2 and ColorUtils.OrangeColor or ColorUtils.BlackColor)
    end
end