require("UI.UIBaseCtrl")

UICommonWeaponBriefItem = class("UICommonWeaponBriefItem", UIBaseCtrl)
UICommonWeaponBriefItem.__index = UICommonWeaponBriefItem

UICommonWeaponBriefItem.ShowType =
{
    Item = 1,
    Weapon = 2,
}

function UICommonWeaponBriefItem:ctor()
    self.skillList = {}
    self.starList = {}
    self.attributeList = {}
end

function UICommonWeaponBriefItem:__InitCtrl()
    self.mText_WeaponName = self:GetText("Text_WeaponName")
    self.mImage_Element = self:GetImage("InfoPanel/Image_IconElement")
    self.mImage_ElementBg = self:GetImage("InfoPanel/Image_BGElement")
    self.mImage_Grade = self:GetImage("BG/Image_BGGrade")
    self.mText_Power = self:GetText("PowerPanel/Text_Power")
    self.mText_WeaponLv = self:GetText("LevelPanel/Text_Level")
    self.mTrans_Properties = self:GetRectTransform("PropertyPanel/VLayout_Sub")
    self.mText_Desc = self:GetText("Text_DESCRIPTION")

    for i = 1, GlobalConfig.MaxStar do
        local obj = self:GetRectTransform("InfoPanel/StarList/Trans_Star" .. i)
        table.insert(self.starList, obj)
    end

    for i = 1, 2 do
        local obj = self:GetRectTransform("SkillPanel/UI_Trans_Skill" .. i)
        local item = self:InitSkill(obj)
        table.insert(self.skillList, item)
    end

    -- self.pointer = UIUtils.GetPointerClickHelper(self.mUIRoot.gameObject, function() self:SetData(nil) end, self.mTrans_SelfArea.gameObject)
end

function UICommonWeaponBriefItem:InitSkill(obj)
    if obj then
        local skill = {}
        skill.obj = obj
        skill.imageIcon = UIUtils.GetImage(obj, "Image_SkillIcon")
        skill.txtName = UIUtils.GetText(obj, "Text_SkillName")

        return skill
    end
end

function UICommonWeaponBriefItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonWeaponBrief.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonWeaponBriefItem:SetData(type, id)
    if type then
        self.type = type
        if self.type == UICommonWeaponBriefItem.ShowType.Item then
            self.data = TableData.GetItemData(id)
            self:UpdateItem()
        elseif self.type == UICommonWeaponBriefItem.ShowType.Weapon then
            self.data = NetCmdWeaponData:GetWeaponById(id)
            self:UpdateWeapon()
        end
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UICommonWeaponBriefItem:UpdateWeapon()
    local weaponData = TableData.listGunWeaponDatas:GetDataById(self.data.stc_id)
    self.mText_Power.text = self.data:GetPower()
    self.mText_WeaponLv.text = string_format(UIWeaponGlobal.WeaponLvRichText, self.data.CurLv, self.data.CurMaxLv)
    self:UpdateWeaponShow(weaponData)
    self:UpdateAttribute(self.data)
    self:UpdateSkill(self.skillList[1], self.data.Skill)
    self:UpdateSkill(self.skillList[2], self.data.BuffSkill)
end

function UICommonWeaponBriefItem:UpdateItem()
    if self.data then
        local weaponData = TableData.listGunWeaponDatas:GetDataById(self.data.args[0])
        self.mText_Power.text = self:GetItemPower(weaponData)
        self.mText_WeaponLv.text = string_format(UIWeaponGlobal.WeaponLvRichText, 0, weaponData.DefaultMaxlv)
        self:UpdateWeaponShow(weaponData)
        self:UpdateItemAttr(weaponData)
        self:UpdateSkill(self.skillList[1], self:GetItemSkill(self.data.Skill))
        self:UpdateSkill(self.skillList[2], self:GetItemSkill(self.data.BuffSkill))
    end
end

function UICommonWeaponBriefItem:UpdateWeaponShow(data)
    if data then
        local elementData = TableData.listLanguageElementDatas:GetDataById(data.Element)
        self.mText_WeaponName.text = data.name.str
        self.mImage_Element.sprite = IconUtils.GetElementIcon(elementData.icon .. "_M")
        self.mImage_ElementBg.color = elementData.color
        -- self.mImage_Grade.sprite = IconUtils.GetGradeFrame(data.Rank)
        self.mText_Desc.text = data.description.str
        self:UpdateStar(data.Rank)
    end
end

function UICommonWeaponBriefItem:UpdateSkill(skill, data)
    setactive(skill.obj, data ~= nil)
    if data then
        skill.imageIcon.sprite = UIUtils.GetIconSprite("Icon/Skill", data.icon)
        skill.txtName.text = data.name.str
    end
end

function UICommonWeaponBriefItem:UpdateStar(star)
    for i = 1, #self.starList do
        setactive(self.starList[i], i <= star)
    end
end

function UICommonWeaponBriefItem:UpdateAttribute(data)
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
            item = PropertyItemS.New()
            item:InitCtrl(self.mTrans_Properties)
            table.insert(self.attributeList, item)
        end
        item:SetData(attrList[i].propData, attrList[i].value, false, ColorUtils.BlackColor, false)
        item:SetNameColor(ColorUtils.BlackColor)
        item:SetTextSize(24)
    end
end

function UICommonWeaponBriefItem:UpdateItemAttr(data)
    local attrList = {}

    local expandList = TableData.GetPropertyExpandList()
    for i = 0, expandList.Count - 1 do
        local lanData = expandList[i]
        if (lanData.type == 1) then
            local value = data[lanData.sys_name]
            if (value ~= nil and value > 0) then
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
            item = PropertyItemS.New()
            item:InitCtrl(self.mTrans_Properties)
            table.insert(self.attributeList, item)
        end
        item:SetData(attrList[i].propData, attrList[i].value, false, ColorUtils.BlackColor, false)
        item:SetNameColor(ColorUtils.BlackColor)
        item:SetTextSize(24)
    end
end

function UICommonWeaponBriefItem:GetItemSkill(data)
    if data then
        local skillGroup = TableData.listSkillGroupDatas:GetDataById(data + 1)
        local skillData = TableData.GetSkillData(skillGroup.skill_list[0])
        return skillData
    end
end

function UICommonWeaponBriefItem:GetItemPower(data)
    local max_hp = data["max_hp"] == nil and 0 or data["max_hp"]
    local pow = data["pow"] == nil and 0 or data["pow"]
    local hit = data["hit_percentage"] == nil and 0 or data["hit_percentage"]
    local dodge = data["dodge_percentage"] == nil and 0 or data["dodge_percentage"]
    local crit = data["crit"] == nil and 0 or data["crit"]
    local crit_mult = data["crit_mult"] == nil and 0 or data["crit_mult"]
    local armor = data["armor"] == nil and 0 or data["armor"]
    local max_ap = data["max_ap"] == nil and 0 or data["max_ap"]

    local capacity = math.ceil(((max_hp * TableData.GetFightingCapacityValueByName("max_hp") + pow * TableData.GetFightingCapacityValueByName("pow") +
    hit * TableData.GetFightingCapacityValueByName("hit_percentage") + dodge * TableData.GetFightingCapacityValueByName("dodge_percentage")
    + crit * TableData.GetFightingCapacityValueByName("crit") + crit_mult * TableData.GetFightingCapacityValueByName("crit_mult") +
    armor * TableData.GetFightingCapacityValueByName("armor") + max_ap * TableData.GetFightingCapacityValueByName("max_ap")) * ((TableData.GetFightingCapacityValueByName("skill_weapon_2") +  TableData.GetFightingCapacityValueByName("skill_weapon_1")) + 1) / TableData.GetFightingCapacityValueByName("scale_param")))
    return capacity
end


