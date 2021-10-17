require("UI.UIBaseView")

UIWeaponBreakContentView = class("UIWeaponBreakContentView", UIBaseView);
UIWeaponBreakContentView.__index = UIWeaponBreakContentView

function UIWeaponBreakContentView:ctor()
    UIWeaponBreakContentView.super.ctor(self)
    self.starList = {}
    self.skillList = {}
    self.addBtnList = {}
    self.stageItem = nil
end

function UIWeaponBreakContentView:__InitCtrl(weaponList)
    self.mBtn_LevelUp = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/BtnBreak"))
    self.mText_Name = self:GetText("GrpWeaponInfo/GrpTextName/Text_Name")
    self.mText_Type = self:GetText("GrpWeaponInfo/GrpType/Text_Name")
    self.mText_Level = self:GetText("GrpWeaponLevel/GrpTextLevel/GrpTextLevel/TextLevelNow/Text_LevelNow")
    self.mText_LevelUp = self:GetText("GrpWeaponLevel/GrpTextLevel/Text_MaxLimitAdd")
    self.mTrans_PropList = self:GetRectTransform("GrpAttributeList/Viewport/Content/GrpAttribute")
    self.mTrans_SkillList = self:GetRectTransform("GrpAttributeList/Viewport/Content/GrpSkill")
    self.mTrans_MaterialList = self:GetRectTransform("GrpItemConsume/Trans_GrpItemWeapon/Content")
    self.mTrans_AddItemList= self:GetRectTransform("GrpItemConsume/GrpItemAdd/Content")

    self.mTrans_EnhanceContent = weaponList.mUIRoot
    self.mBtn_CloseList = weaponList.mBtn_CloseList
    self.mTrans_Sort = weaponList.mTrans_Sort
    self.mTrans_SortList = weaponList.mTrans_SortList
    self.mTrans_WeaponPartScroll = weaponList.mTrans_WeaponPartScroll
    self.mTrans_ItemBrief = weaponList.mTrans_ItemBrief
    self.mTrans_AutoSelect = weaponList.mTrans_AutoSelect
    self.mTrans_Empty = weaponList.mTrans_Empty
    self.mVirtualList = weaponList.mVirtualList
    self.mListAnimator = weaponList.mListAnimator
    self.mListAniTime = weaponList.mListAniTime

    for i = 1, 2 do
        local obj = self:InstanceUIPrefab("Character/ChrWaeaponSkillItemV2.prefab", self.mTrans_SkillList, true)
        local item = self:InitSkillItem(obj, i)
        table.insert(self.skillList, item)
    end

    for i = 1, UIWeaponGlobal.MaxBreakCount do
        local obj = self:InstanceUIPrefab("UICommonFramework/ComItemAddItemV2.prefab", self.mTrans_AddItemList, true)
        table.insert(self.addBtnList, obj)
    end

    self:InitStageItem()
end

function UIWeaponBreakContentView:InitCtrl(root, weaponList)
    self:SetRoot(root)
    self:__InitCtrl(weaponList)
end

function UIWeaponBreakContentView:InitSkillItem(obj, index)
    if obj then
        local skill = {}
        skill.obj = obj
        skill.txtName = UIUtils.GetText(obj, "GrpNameInfo/GrpTextName/Text_SkillName")
        skill.transBreak = UIUtils.GetRectTransform(obj, "GrpNameInfo/GrpTextName/Trans_GrpBreakText")
        skill.txtLv = UIUtils.GetText(obj, "GrpNameInfo/GrpTextName/Trans_GrpBreakText/Text_Lv")
        skill.imgSkillBg = UIUtils.GetImage(obj, "GrpNameInfo/GrpTextName/Trans_GrpBreakText/ImgBg")
        skill.transBg = UIUtils.GetRectTransform(obj, "Trans_ImgBg")
        skill.transBg2 = UIUtils.GetRectTransform(obj, "ImgBgW")
        skill.txtDesc = UIUtils.GetText(obj, "Text_Describe")

        if index == 2 then
            skill.imgSkillBg.color = ColorUtils.OrangeColor
            skill.txtLv.color = ColorUtils.WhiteColor
            setactive(skill.transBg, true)
        end
        setactive(skill.transBg2, true)
        setactive(skill.transBreak, true)
        return skill
    end
end

function UIWeaponBreakContentView:InitStageItem()
    if self.stageItem == nil then
        local parent = self:GetRectTransform("GrpWeaponInfo/GrpStage")
        self.stageItem = UICommonStageItem.New(GlobalConfig.MaxStar)
        self.stageItem:InitCtrl(parent)
    end
end

