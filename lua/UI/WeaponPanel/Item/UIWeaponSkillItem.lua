require("UI.UIBaseCtrl")
---@class UIWeaponSkillItem : UIBaseCtrl

UIWeaponSkillItem = class("UIWeaponSkillItem", UIBaseCtrl)
UIWeaponSkillItem.__index = UIWeaponSkillItem

function UIWeaponSkillItem:ctor()
    self.skillData = nil
end

function UIWeaponSkillItem:__InitCtrl()
    self.mBtn_Info = UIUtils.GetTempBtn(self:GetRectTransform("GrpNameInfo/GrpTextName/Trans_Text_Lv/BtnDescription"))
    self.mText_Name = self:GetText("GrpNameInfo/GrpTextName/Text_SkillName")
    self.mImage_Icon = self:GetImage("GrpNameInfo/Trans_GrpIcon/Img_Icon")
    self.mText_Desc = self:GetText("Text_Describe")
    self.mText_Num = self:GetText("GrpNameInfo/GrpTextName/Trans_Text_Num")
    self.mText_Level = self:GetText("GrpNameInfo/GrpTextName/Trans_Text_Lv")
    self.mTrans_Icon = self:GetRectTransform("GrpNameInfo/Trans_GrpIcon")
    self.mTrans_Info = self:GetRectTransform("GrpNameInfo/GrpTextName/Trans_Text_Lv/BtnDescription")

    UIUtils.GetButtonListener(self.mBtn_Info.gameObject).onClick = function()
        self:OnInfoClick()
    end
end

function UIWeaponSkillItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("Character/ChrWaeaponSkillItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIWeaponSkillItem:SetData(skillGroupId)
    if(skillGroupId) then
        local skillData = TableData.listBattleSkillDatas:GetDataById(skillGroupId)
        self.skillData = skillData

        self.mText_Name.text = skillData.name.str
        self.mImage_Icon.sprite = CS.IconUtils.GetSkillIconSprite(skillData.icon)
        self.mText_Desc.text = skillData.description.str
        self:SetLevel(skillData.level)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIWeaponSkillItem:SetDataBySkillData(data, needDesc)
    self.skillData = data
    if data then
        self.skillId = data.id
        self.mImage_Icon.sprite = UIUtils.GetIconSprite("Icon/Skill", data.icon)
        self.mText_Name.text = data.name.str
        self.mText_Desc.text = data.description.str

        setactive(self.mText_Desc.gameObject, needDesc)

        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIWeaponSkillItem:SetNum(num, maxNum)
    setactive(self.mText_Num.gameObject, true)
    self.mText_Num.text = num .. "/" .. maxNum
end

function UIWeaponSkillItem:SetLevel(level)
    setactive(self.mText_Level.gameObject, true)
    self.mText_Level.text = GlobalConfig.LVText .. level
end

function UIWeaponSkillItem:EnableSkillIcon(enable)
    setactive(self.mTrans_Icon, enable)
end

function UIWeaponSkillItem:EnableInfoBtn(enable)
    setactive(self.mTrans_Info, enable)
end

function UIWeaponSkillItem:OnInfoClick()
    MessageBoxPanel.ShowSingleType(TableData.GetHintById(40032))
end
