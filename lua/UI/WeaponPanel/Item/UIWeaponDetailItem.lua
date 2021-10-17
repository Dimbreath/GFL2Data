require("UI.UIBaseCtrl")

UIWeaponDetailItem = class("UIWeaponDetailItem", UIBaseCtrl)
UIWeaponDetailItem.__index = UIWeaponDetailItem

function UIWeaponDetailItem:ctor()
    UIWeaponDetailItem.super.ctor(self)
    self.data = nil
    self.lockCallback = nil
    self.skillList = {}
    self.starList = {}
    self.attributeList = {}
end

function UIWeaponDetailItem:__InitCtrl()
    self.mBtn_Lock = self:GetButton("Btn_LockButton")
    self.mText_WeaponName = self:GetText("Text_WeaponName")
    self.mImage_Element = self:GetImage("Image_Trans_Stars/Image_IconElement")
    self.mImage_Grade = self:GetImage("BG/Image_BGGrade")
    self.mText_Power = self:GetText("Trans_PowerPanel/Text_Power")
    self.mText_WeaponLv = self:GetText("Trans_LevelPanel/Text_Level")
    self.mTrans_Lock = self:GetRectTransform("Btn_LockButton/Trans_WeaponLock")
    self.mTrans_UnLock = self:GetRectTransform("Btn_LockButton/Trans_WeaponUnlock")
    self.mTrans_Properties = self:GetRectTransform("Trans_Properties/Trans_WeaponPropertiesList")

    for i = 1, UIWeaponGlobal.MaxStar do
        local obj = self:GetRectTransform("Image_Trans_Stars/Trans_StarList/Star" .. i)
        table.insert(self.starList, obj)
    end

    for i = 1, 2 do
        local obj = self:GetRectTransform("Trans_SkillPanel/Trans_WeaponSkillList/UI_Trans_Skill" .. i)
        local item = self:InitSkill(obj)
        table.insert(self.skillList, item)
    end

    UIUtils.GetButtonListener(self.mBtn_Lock.gameObject).onClick = function()
        self:OnClickLock()
    end
end

function UIWeaponDetailItem:OnClickLock()
    NetCmdWeaponData:SendGunWeaponLockUnlock(self.data.id, function ()
        if self.lockCallback ~= nil then
            self.lockCallback(self.data.id, self.data.IsLocked)
        end
        self:UpdateLockStatue()
    end)
end

function UIWeaponDetailItem:InitCtrl(root, lockCallback)
    self:SetRoot(root)
    self:__InitCtrl()

    self.lockCallback = lockCallback
end

function UIWeaponDetailItem:InitSkill(obj)
    if obj then
        local skill = {}
        skill.obj = obj
        skill.imageIcon = UIUtils.GetImage(obj, "Image_Icon")
        skill.txtName = UIUtils.GetText(obj, "Title/Text_Name")
        skill.txtDesc = UIUtils.GetText(obj, "Text_Desc")

        return skill
    end
end

function UIWeaponDetailItem:SetData(data)
    if data then
        self.data = data
        local elementData = TableData.listLanguageElementDatas:GetDataById(data.Element)
        self.mText_WeaponName.text = data.Name
        self.mText_WeaponLv.text = string_format(UIWeaponGlobal.WeaponLvRichText, data.Level, data.CurMaxLv)
        self.mImage_Element.sprite = IconUtils.GetElementIcon(elementData.icon .. "_M")
        -- self.mImage_Grade.sprite = IconUtils.GetGradeFrame(data.Rank)
        self.mText_Power.text = self.data:GetPower()
        self:UpdateStar(data.Rank)
        self:UpdateAttribute(data)
        self:UpdateSkill(self.skillList[UIWeaponGlobal.SkillType.NormalSkill], data.Skill)
        self:UpdateSkill(self.skillList[UIWeaponGlobal.SkillType.BuffSkill], data.BuffSkill)
        self:UpdateLockStatue()
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIWeaponDetailItem:UpdateSkill(skill, data)
    setactive(skill.obj, data ~= nil)
    if data then
        skill.imageIcon.sprite = UIUtils.GetIconSprite("Icon/Skill", data.icon)
        skill.txtName.text = data.name.str
        skill.txtDesc.text = data.description.str
    end
end

function UIWeaponDetailItem:UpdateStar(star)
    for i = 1, #self.starList do
        setactive(self.starList[i], i <= star)
    end
end

function UIWeaponDetailItem:UpdateLockStatue()
    setactive(self.mTrans_UnLock, not self.data.IsLocked)
    setactive(self.mTrans_Lock, self.data.IsLocked)
end

function UIWeaponDetailItem:UpdateAttribute(data)
    local attrList = {}

    local expandList = TableData.GetPropertyExpandList()
    for i = 0, expandList.Count - 1 do
        local lanData = expandList[i]
        if(lanData.type == 1) then
            local value = data:GetPropertyByLevelAndSysName(lanData.sys_name, data.CurLv, data.BreakTimes)
            if(value > 0) then
                local attr = {}
                attr.propData = lanData
                attr.value = value
                table.insert(attrList, attr)
            end
        end
    end

    table.sort(attrList, function (a, b) return a.propData.order < b.propData.order end)

    for _, item in ipairs(self.attributeList) do
        item:SetData(nil)
    end

    for i = 1, #attrList do
        local item = nil
        if i <= #self.attributeList then
            item = self.attributeList[i]
        else
            item = PropertyItemS.New()
            item:InitCtrl(self.mTrans_Properties)
            table.insert(self.attributeList, item)
        end
        item:SetData(attrList[i].propData, attrList[i].value, i % 2 == 0 , ColorUtils.WhiteColor, false)
    end
end