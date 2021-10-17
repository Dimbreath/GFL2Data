require("UI.UIBaseCtrl")

UIBarrackBriefItem = class("UIBarrackBriefItem", UIBaseCtrl)
UIBarrackBriefItem.__index = UIBarrackBriefItem

UIBarrackBriefItem.ShowType =
{
    Equip = 1,
    Weapon = 2,
    WeaponPart = 3,
    Item = 4
}

function UIBarrackBriefItem:ctor()
    self.gunId = 0
    self.lockCallback = nil
    self.lvUpCallback = nil
    self.changeCallback = nil
    self.curContent = nil
end

function UIBarrackBriefItem:__InitCtrl()
    self.mTrans_ButtonGroup = self:GetRectTransform("GrpAction")
    self.mTrans_Equip = self:GetRectTransform("GrpAction/BtnEquipe")
    self.mTrans_PowerUp = self:GetRectTransform("GrpAction/BtnPowerUp")
    self.mTrans_Replace = self:GetRectTransform("GrpAction/BtnReplace")
    self.mTrans_Disassemble = self:GetRectTransform("GrpAction/BtnUninstall")
    self.mTrans_CurEquiped = self:GetRectTransform("GrpAction/Trans_Equiped")

    self.mBtn_PowerUp = UIUtils.GetTempBtn(self.mTrans_PowerUp)
    self.mBtn_Replace = UIUtils.GetTempBtn(self.mTrans_Replace)
    self.mBtn_Equip = UIUtils.GetTempBtn(self.mTrans_Equip)
    self.mBtn_Disassemble = UIUtils.GetTempBtn(self.mTrans_Disassemble)

    self.mTrans_WeaponContent = self:GetRectTransform("GrpContent/Trans_GrpWeapon")
    self.mTrans_EquipContent = self:GetRectTransform("GrpContent/Trans_GrpEquip")
    self.mTrans_WeaponPartContent = self:GetRectTransform("GrpContent/Trans_GrpWeaponParts")
    self.mTrans_ItemContent = self:GetRectTransform("GrpContent/Trans_GrpConsumeItem")

    self.mItem_Weapon = self:InitWeaponContent(self.mTrans_WeaponContent)
    self.mItem_Equip = self:InitEquipContent(self.mTrans_EquipContent)
    self.mItem_WeaponPart = self:InitWeaponPartContent(self.mTrans_WeaponPartContent)
    self.mItem_Item = self:InitItemContent(self.mTrans_ItemContent)

    UIUtils.GetButtonListener(self.mBtn_Replace.gameObject).onClick = function()
        self:OnClickChange()
    end

    UIUtils.GetButtonListener(self.mBtn_Equip.gameObject).onClick = function()
        self:OnClickChange()
    end

    UIUtils.GetButtonListener(self.mBtn_Disassemble.gameObject).onClick = function()
        self:OnClickChange()
    end

    UIUtils.GetButtonListener(self.mBtn_PowerUp.gameObject).onClick = function()
        self:OnClickLvUp()
    end
end

function UIBarrackBriefItem:InitWeaponContent(obj)
    local content = {}
    content.obj = obj
    content.stageItem = nil
    content.attributeList = {}
    content.skillList = {}
    content.transItem = UIUtils.GetRectTransform(obj, "GrpWeaponInfo/GrpItem")
    content.txtName = UIUtils.GetText(obj, "GrpWeaponInfo/GrpInfo/GrpName/Text_Name")
    content.txtType = UIUtils.GetText(obj, "GrpWeaponDetails/GrpTextType/Text_Name")
    content.txtPower = UIUtils.GetText(obj, "GrpWeaponInfo/TextEffectNum/Text_Num")
    content.txtLevel = UIUtils.GetText(obj, "GrpWeaponInfo/GrpInfo/GrpElementLv/GrpWeaponLevel/GrpText/Text_Lv")
    content.transElement = UIUtils.GetRectTransform(obj, "GrpWeaponInfo/GrpInfo/GrpElementLv/GrpElement")
    content.imgLine = UIUtils.GetImage(obj, "GrpWeaponInfo/GrpLine/Img_Line")
    content.btnLock = UIUtils.GetButton(obj, "GrpWeaponInfo/Trans_GrpLock/ComLockItemV2")
    content.transLock = UIUtils.GetRectTransform(obj, "GrpWeaponInfo/Trans_GrpLock/ComLockItemV2/ImgLocked")
    content.transUnlock = UIUtils.GetRectTransform(obj, "GrpWeaponInfo/Trans_GrpLock/ComLockItemV2/ImgUnLocked")
    content.transAttrList = UIUtils.GetRectTransform(obj, "GrpWeaponDetails/GrpAttribute/Viewport/Content/GrpAttribute")
    content.transSkillList = UIUtils.GetRectTransform(obj, "GrpWeaponDetails/GrpAttribute/Viewport/Content/GrpSkill")
    content.transStarList = UIUtils.GetRectTransform(obj, "GrpWeaponDetails/GrpStage")

    content.itemContent = UICommonWeaponInfoItem.New()
    content.itemContent:InitCtrl(content.transItem)
    content.itemContent:EnableButton(false)

    content.elementItem = UICommonElementItem.New()
    content.elementItem:InitCtrl(content.transElement)

    content.stageItem = UICommonStageItem.New(GlobalConfig.MaxStar)
    content.stageItem:InitCtrl(content.transStarList)

    for i = 1, 2 do
        local obj = self:InstanceUIPrefab("Character/ChrWaeaponSkillItemV2.prefab", content.transSkillList)
        local item = self:InitSkill(obj)
        table.insert(content.skillList, item)
    end

    UIUtils.GetButtonListener(content.btnLock.gameObject).onClick = function()
        self:OnClickLock()
    end

    return content
end

function UIBarrackBriefItem:InitEquipContent(obj)
    local content = {}
    content.obj = obj
    content.attributeList = {}
    content.skillList = {}
    content.transItem = UIUtils.GetRectTransform(obj, "GrpEquipInfo/GrpItem/ComItemV2")
    content.txtName = UIUtils.GetText(obj, "GrpEquipInfo/GrpInfo/GrpName/Text_Name")
    content.txtLevel = UIUtils.GetText(obj, "GrpEquipInfo/GrpInfo/GrpElementLv/GrpWeaponLevel/GrpText/Text_Level")
    content.imgLine = UIUtils.GetImage(obj, "GrpEquipInfo/GrpLine/Img_Line")
    content.imgCorner = UIUtils.GetImage(obj, "GrpEquipInfo/GrpCorner/Img_Corner")
    content.btnLock = UIUtils.GetButton(obj, "GrpEquipInfo/Trans_GrpLock/ComLockItemV2")
    content.transLock = UIUtils.GetRectTransform(obj, "GrpEquipInfo/Trans_GrpLock/ComLockItemV2/ImgLocked")
    content.transUnlock = UIUtils.GetRectTransform(obj, "GrpEquipInfo/Trans_GrpLock/ComLockItemV2/ImgUnLocked")
    content.transAttrList = UIUtils.GetRectTransform(obj, "GrpEquipDetails/GrpAttribute")
    content.transSkillList = UIUtils.GetRectTransform(obj, "GrpEquipDetails/GrpSkillList/Viewport/Content")

    content.itemContent = UICommonItem.New()
    content.itemContent:InitObj(content.transItem)
    content.itemContent:EnableButton(false)

    for i = 1, 2 do
        local item = self:InitEquipSet(content.transSkillList)
        table.insert(content.skillList, item)
    end

    UIUtils.GetButtonListener(content.btnLock.gameObject).onClick = function()
        self:OnClickLock()
    end

    return content
end

function UIBarrackBriefItem:InitWeaponPartContent(obj)
    local content = {}
    content.obj = obj
    content.attribute = nil
    content.skill = nil
    content.transItem = UIUtils.GetRectTransform(obj, "GrpWeaponPartsInfo/GrpItem")
    content.txtName = UIUtils.GetText(obj, "GrpWeaponPartsInfo/GrpInfo/GrpName/Text_Name")
    content.txtType = UIUtils.GetText(obj, "GrpWeaponPartsInfo/GrpInfo/GrpType/Text_Name")
    content.imgLine = UIUtils.GetImage(obj, "GrpWeaponPartsInfo/GrpLine/Img_Line")
    content.btnLock = UIUtils.GetButton(obj, "GrpWeaponPartsInfo/Trans_GrpLock/ComLockItemV2")
    content.transLock = UIUtils.GetRectTransform(obj, "GrpWeaponPartsInfo/Trans_GrpLock/ComLockItemV2/ImgLocked")
    content.transUnlock = UIUtils.GetRectTransform(obj, "GrpWeaponPartsInfo/Trans_GrpLock/ComLockItemV2/ImgUnLocked")
    content.transAttrList = UIUtils.GetRectTransform(obj, "GrpWeaponPartsDetails/GrpAttribute/Viewport/Content/GrpAttribute")
    content.transSkillList = UIUtils.GetRectTransform(obj, "GrpWeaponPartsDetails/GrpAttribute/Viewport/Content/GrpSkill")

    content.itemContent = UIWeaponPartItem.New()
    content.itemContent:InitCtrl(content.transItem)
    content.itemContent:EnableButton(false)

    content.attribute = UICommonPropertyItem.New()
    content.attribute:InitCtrl(content.transAttrList)

    content.skill = UIWeaponSkillItem.New()
    content.skill:InitCtrl(content.transSkillList)
    content.skill:EnableSkillIcon(true)

    UIUtils.GetButtonListener(content.btnLock.gameObject).onClick = function()
        self:OnClickLock()
    end

    return content
end

function UIBarrackBriefItem:InitItemContent(obj)
    local content = {}
    content.obj = obj
    content.transItem = UIUtils.GetRectTransform(obj, "GrpConsumeInfo/GrpItem")
    content.txtName = UIUtils.GetText(obj, "GrpConsumeInfo/GrpInfo/GrpName/Text_Name")
    content.txtType = UIUtils.GetText(obj, "GrpConsumeInfo/GrpInfo/GrpType/Text_Name")
    content.txtDesc = UIUtils.GetText(obj, "GrpConsumeDetails/GrpAttribute/Viewport/Content/Text_Description")

    content.itemContent = UICommonWeaponInfoItem.New()
    content.itemContent:InitCtrl(content.transItem)
    content.itemContent:EnableButton(false)

    return content
end

function UIBarrackBriefItem:OnClickLock()
    if self.type == UIBarrackBriefItem.ShowType.Weapon then
        NetCmdWeaponData:SendGunWeaponLockUnlock(self.data.id, function()
            if self.lockCallback ~= nil then
                self.lockCallback(self.data.id, self.data.IsLocked)
            end
            self:UpdateLockStatue(self.data.IsLocked)
        end)
    elseif self.type == UIBarrackBriefItem.ShowType.Equip then
        NetCmdGunEquipData:SendEquipLockOrUnlockCmd(self.data.id, function ()
            if self.lockCallback ~= nil then
                self.lockCallback(self.data.id, self.data.locked)
            end
            self:UpdateLockStatue(self.data.locked)
        end)
    elseif self.type == UIBarrackBriefItem.ShowType.WeaponPart then
        NetCmdWeaponPartsData:ReqWeaponPartLockUnlock(self.data.id, function ()
            if self.lockCallback ~= nil then
                self.lockCallback(self.data.id, self.data.IsLocked)
            end
            self:UpdateLockStatue(self.data.IsLocked)
        end)
    end
end

function UIBarrackBriefItem:InitUpgrade(obj)
    if obj then
        local item = {}
        item.obj = obj

        item.transOn = UIUtils.GetRectTransform(obj, "Trans_On")
        item.transOff = UIUtils.GetRectTransform(obj, "Trans_Off")

        return item
    end
end

function UIBarrackBriefItem:InitSkill(obj)
    if obj then
        local skill = {}
        skill.obj = obj
        skill.imageIcon = UIUtils.GetImage(obj, "GrpNameInfo/Trans_GrpIcon/Img_Icon")
        skill.txtName = UIUtils.GetText(obj, "GrpNameInfo/GrpTextName/Text_SkillName")
        skill.txtDesc = UIUtils.GetText(obj, "Text_Describe")
        skill.txtLevel = UIUtils.GetText(obj, "GrpNameInfo/GrpTextName/Trans_Text_Lv")

        setactive(skill.txtLevel.gameObject, true)

        return skill
    end
end

function UIBarrackBriefItem:InitEquipSet(parent)
    local equipSet = UIEquipSetItem.New()
    equipSet:InitCtrl(parent)

    return equipSet
end

function UIBarrackBriefItem:InitCtrl(parent, lockCallback)
    local obj = instantiate(UIUtils.GetGizmosPrefab("Character/ChrWeaponEquipInfoItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()

    self.lockCallback = lockCallback
end

function UIBarrackBriefItem:SetChangeCallback(cb)
    self.changeCallback = cb
end

function UIBarrackBriefItem:SetLevelUpCallback(cb)
    self.lvUpCallback = cb
end

function UIBarrackBriefItem:SetData(type, id)
    if type then
        self.type = type
        if self.type == UIBarrackBriefItem.ShowType.Equip then
            self.curContent = self.mItem_Equip
            self.data = NetCmdEquipData:GetEquipById(id)
            self:UpdateEquip()
        elseif self.type == UIBarrackBriefItem.ShowType.Weapon then
            self.curContent = self.mItem_Weapon
            self.data = NetCmdWeaponData:GetWeaponById(id)
            self:UpdateWeapon()
        elseif self.type == UIBarrackBriefItem.ShowType.WeaponPart then
            self.curContent = self.mItem_WeaponPart
            self.data = NetCmdWeaponPartsData:GetWeaponPartById(id)
            self:UpdateWeaponPart()
        elseif self.type == UIBarrackBriefItem.ShowType.Item then
            self.curContent = self.mItem_Item
            self.data = TableData.listItemDatas:GetDataById(id)
            self:UpdateItemContent()
        end
        setactive(self.mTrans_EquipContent.gameObject, self.type == UIBarrackBriefItem.ShowType.Equip)
        setactive(self.mTrans_WeaponContent.gameObject, self.type == UIBarrackBriefItem.ShowType.Weapon)
        setactive(self.mTrans_WeaponPartContent.gameObject, self.type == UIBarrackBriefItem.ShowType.WeaponPart)
        setactive(self.mTrans_ItemContent.gameObject, self.type == UIBarrackBriefItem.ShowType.Item)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIBarrackBriefItem:SetGunId(gunId)
    self.gunId = gunId
end

function UIBarrackBriefItem:EnableCurrentWeapon(enable)
    setactive(self.mTrans_CurEquiped, enable)
    setactive(self.mTrans_PowerUp.gameObject, not enable)
    setactive(self.mTrans_Replace.gameObject, not enable)
    setactive(self.mTrans_Equip.gameObject, not enable)
end

function UIBarrackBriefItem:UpdateWeapon()
    local weaponData = TableData.listGunWeaponDatas:GetDataById(self.data.stc_id)
    local elementData = TableData.listLanguageElementDatas:GetDataById(weaponData.element)
    local typeData = TableData.listGunWeaponTypeDatas:GetDataById(weaponData.type)
    self.mItem_Weapon.txtPower.text = self.data:GetPower()
    self.mItem_Weapon.txtLevel.text = GlobalConfig.LVText .. self.data.CurLv
    self.mItem_Weapon.itemContent:SetWeapon(weaponData.id)
    self.mItem_Weapon.txtName.text = weaponData.name.str
    self.mItem_Weapon.elementItem:SetData(elementData)
    self.mItem_Weapon.txtType.text = typeData.name.str
    self.mItem_Weapon.imgLine.color = TableData.GetGlobalGun_Quality_Color2(weaponData.rank)
    self:UpdateWeaponAttribute(self.data)
    self:UpdateStar(self.data.BreakTimes, self.data.MaxBreakTime)
    self:UpdateLockStatue(self.data.IsLocked)
    self:UpdateWeaponSkill(self.mItem_Weapon.skillList[1], self.data.Skill)
    self:UpdateWeaponSkill(self.mItem_Weapon.skillList[2], self.data.BuffSkill)
end

function UIBarrackBriefItem:UpdateWeaponAttribute(data)
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

    for _, item in ipairs(self.mItem_Weapon.attributeList) do
        item:SetData(nil)
    end

    for i = 1, #attrList do
        local item = nil
        if i <= #self.mItem_Weapon.attributeList then
            item = self.mItem_Weapon.attributeList[i]
        else
            item = UICommonPropertyItem.New()
            item:InitCtrl(self.mItem_Weapon.transAttrList)
            table.insert(self.mItem_Weapon.attributeList, item)
        end
        item:SetData(attrList[i].propData, attrList[i].value, false, false, i % 2 == 0, false)
        item:SetTextColor(attrList[i].propData.statue == 2 and ColorUtils.OrangeColor or ColorUtils.BlackColor)
    end
end

function UIBarrackBriefItem:UpdateWeaponSkill(skill, data)
    setactive(skill.obj, data ~= nil)
    if data then
        skill.imageIcon.sprite = UIUtils.GetIconSprite("Icon/Skill", data.icon)
        skill.txtName.text = data.name.str
        skill.txtDesc.text = data.description.str
        skill.txtLevel.text = GlobalConfig.LVText .. data.level

        --UIUtils.GetButtonListener(skill.btnInfo.gameObject).onClick = function()
        --    self:OnClickSkillInfo(data.id, data.level)
        --end
    end
end

function UIBarrackBriefItem:UpdateEquip()
    if self.data then
        local equipData = TableData.listGunEquipDatas:GetDataById(self.data.stcId)
        self.mItem_Equip.txtLevel.text = GlobalConfig.LVText .. self.data.level
        self.mItem_Equip.itemContent:SetEquipDataWithoutInfo(equipData.id, self.data.level)
        self.mItem_Equip.txtName.text = equipData.name.str
        self.mItem_Equip.imgCorner.color = TableData.GetGlobalGun_Quality_Color2(equipData.rank)
        self.mItem_Equip.imgLine.color = TableData.GetGlobalGun_Quality_Color2(equipData.rank)
        self:UpdateEquipSet(equipData.set_id_cs)
        self:UpdateEquipAttribute(self.data)
        self:UpdateLockStatue(self.data.locked)
    end
end

function UIBarrackBriefItem:UpdateEquipSet(setId)
    local setData = TableData.listEquipSetDatas:GetDataById(setId)
    for i, item in ipairs(self.mItem_Equip.skillList) do
        item:SetData(setData.id, setData["set" .. i .. "_num"])
    end
end

function UIBarrackBriefItem:UpdateEquipAttribute(data)
    local attrList = {}
    if data.main_prop then
        table.insert(attrList, data.main_prop)
    end

    if data.sub_props then
        for i = 0, data.sub_props.Length - 1 do
            table.insert(attrList, data.sub_props[i])
        end
    end

    if attrList then
        local item = nil
        for _, item in ipairs(self.mItem_Equip.attributeList) do
            item:SetData(nil)
        end

        for i = 1, #attrList do
            local prop = attrList[i]
            local tableData = TableData.listCalibrationDatas:GetDataById(prop.Id)
            local propData = TableData.GetPropertyDataByName(tableData.property, tableData.type)
            if i <= #self.mItem_Equip.attributeList then
                item = self.mItem_Equip.attributeList[i]
            else
                item = UICommonPropertyItem.New()
                item:InitCtrl(self.mItem_Equip.transAttrList)
                table.insert(self.mItem_Equip.attributeList, item)
            end
            item:SetData(propData, prop.Value, false, false, i % 2 == 0, false)
            item:SetTextColor((i == 1) and ColorUtils.StringToColor("F7802F") or nil)
            item:SetTextFont((i == 1) and CS.enumFont.eNOTOSANSHANS_Bold or nil)
        end
    end
end

function UIBarrackBriefItem:SetEquipCompareButtonGroup(isCompare, hasEquip)
    if isCompare then
        setactive(self.mTrans_CurEquiped, (self.gunId == self.data.gun_id))
        setactive(self.mTrans_Replace.gameObject, (self.gunId ~= self.data.gun_id or not isCompare) and hasEquip)
        setactive(self.mTrans_Equip.gameObject, (self.gunId ~= self.data.gun_id or not isCompare) and not hasEquip)
        setactive(self.mTrans_PowerUp.gameObject, self.gunId ~= self.data.gun_id)
        setactive(self.mTrans_Disassemble.gameObject, false)
    else
        setactive(self.mTrans_CurEquiped, false)
        setactive(self.mTrans_Replace.gameObject, false)
        setactive(self.mTrans_Equip.gameObject, false)
        setactive(self.mTrans_Disassemble.gameObject, self.gunId == self.data.gun_id)
        setactive(self.mTrans_PowerUp.gameObject, true)
    end
end

function UIBarrackBriefItem:OnClickSkillInfo(skillId, curLevel)
    UIManager.OpenUIByParam(UIDef.UIWeaponSkillInfoPanel, {skillId, curLevel})
end

function UIBarrackBriefItem:UpdateWeaponPart()
    local typeData = TableData.listWeaponPartTypeDatas:GetDataById(self.data.type)
    self.mItem_WeaponPart.txtName.text = self.data.name
    self.mItem_WeaponPart.txtType.text = typeData.name
    self.mItem_WeaponPart.imgLine.color = TableData.GetGlobalGun_Quality_Color2(self.data.rank)
    self.mItem_WeaponPart.itemContent:SetDisplay(self.data)
    self:UpdateLockStatue(self.data.IsLocked)
    self:UpdateWeaponPartAttribute()
    self.mItem_WeaponPart.skill:SetDataBySkillData(self.data.affixSkill, true)
    if self.data.affixSkill then
        self.mItem_WeaponPart.skill:SetLevel(self.data.affixSkill.level)
    end
end

function UIBarrackBriefItem:UpdateWeaponPartAttribute()
    self.mItem_WeaponPart.attribute:SetDataByName(self.data.attribute, self.data.attributeValue, false, false, true)
end

function UIBarrackBriefItem:UpdateItemContent()
    self.mItem_Item.itemContent:SetItem(self.data.id)
    self.mItem_Item.txtName.text = self.data.name.str
    self.mItem_Item.txtDesc.text = self.data.description.str
end

--- common func
function UIBarrackBriefItem:UpdateStar(star, maxStar)
    self.curContent.stageItem:ResetMaxNum(maxStar)
    self.curContent.stageItem:SetData(star)
end

function UIBarrackBriefItem:UpdateLockStatue(isLock)
    if self.curContent then
        setactive(self.curContent.transUnlock, not isLock)
        setactive(self.curContent.transLock, isLock)
    end
end

function UIBarrackBriefItem:EnableLock(enable)
    setactive(self.mItem_Weapon.btnLock.gameObject, enable)
end

function UIBarrackBriefItem:EnableButtonGroup(enable)
    setactive(self.mTrans_ButtonGroup.gameObject, enable)
end

function UIBarrackBriefItem:OnClickLvUp()
    if self.lvUpCallback ~= nil then
        self.lvUpCallback()
    end
    if self.type == UIBarrackBriefItem.ShowType.Equip then
        UIManager.OpenUIByParam(UIDef.UIEquipPanel, {self.data.id, UIEquipGlobal.EquipPanelTab.Enhance})
    end
end

function UIBarrackBriefItem:OnClickChange()
    if self.type == UIBarrackBriefItem.ShowType.Equip then
        if self.data.gun_id ~= 0 and self.data.gun_id ~= self.gunId then
            local gunName = TableData.listGunDatas:GetDataById(self.data.gun_id).name.str
            local hint = string_format(TableData.GetHintById(20009), gunName)
            MessageBoxPanel.ShowDoubleType(hint, function () self:OnReplaceEquip() end)
        else
            self:OnReplaceEquip()
        end
    end
end

function UIBarrackBriefItem:OnReplaceEquip()
    local equipId = (self.data.gun_id == self.gunId) and 0 or self.data.id
    NetCmdGunEquipData:SendEquipBelongCmd(self.gunId, self.data.category, equipId, function (ret)
        if ret == CS.CMDRet.eSuccess then
            if self.changeCallback ~= nil then
                self.changeCallback()
            end
        end
    end)
end

function UIBarrackBriefItem:GetItemPower(data)
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


