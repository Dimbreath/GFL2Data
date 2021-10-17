require("UI.UIBaseView")

UIWeaponEnhanceContentView = class("UIWeaponEnhanceContentView", UIBaseView);
UIWeaponEnhanceContentView.__index = UIWeaponEnhanceContentView

function UIWeaponEnhanceContentView:ctor()
    UIWeaponEnhanceContentView.super.ctor(self)
    self.stageItem = nil
    self.skillItem = {}
    self.addBtnList = {}
end

function UIWeaponEnhanceContentView:__InitCtrl(weaponList)
    self.mBtn_LevelUp = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/Trans_BtnPowerUp"))
    self.mText_Name = self:GetText("GrpWeaponInfo/GrpTextName/Text_Name")
    self.mText_Type = self:GetText("GrpWeaponInfo/GrpType/Text_Name")
    self.mText_LevelNow = self:GetText("GrpWeaponLevel/GrpTextLevel/GrpTextLevel/TextLevelNow/Text_LevelNow")
    self.mText_LevelMax = self:GetText("GrpWeaponLevel/GrpTextLevel/GrpTextLevel/Trans_Text_LevelMax")
    -- self.mText_LevelUp = self:GetText("GrpWeaponLevel/GrpTextLevel/GrpTextLevel/Trans_Text_MaxLimitAdd")
    self.mText_Exp = self:GetText("GrpWeaponLevel/GrpTextLevel/GrpTextExp/Text_Exp")
    self.mText_AddExp = self:GetText("GrpWeaponLevel/GrpTextLevel/Trans_GrpTextAdd/Text_Add")
    self.mImage_ExpAfter = self:GetImage("GrpWeaponLevel/GrpProgressBar/Img_ProgressBarAfter")
    self.mImage_ExpBefore = self:GetImage("GrpWeaponLevel/GrpProgressBar/Img_ProgressBarBefore")
    self.mTrans_PropList = self:GetRectTransform("GrpAttributeList/Viewport/Content/GrpAttribute")
    self.mTrans_SkillList = self:GetRectTransform("GrpAttributeList/Viewport/Content/GrpSkill")
    self.mTrans_MaterialList = self:GetRectTransform("Trans_GrpItemConsume/Trans_GrpItemWeapon/Content")
    self.mTrans_AddItemList= self:GetRectTransform("Trans_GrpItemConsume/GrpItemAdd/Content")
    self.mTrans_ExpAdd = self:GetRectTransform("GrpWeaponLevel/GrpTextLevel/Trans_GrpTextAdd")
    self.mTrans_Stage = self:GetRectTransform("GrpWeaponInfo/GrpStage")
    self.mTrans_Mask = UIWeaponPanelView.mTrans_Mask

    self.mTrans_CostHint = self:GetRectTransform("Trans_GrpTextConsume")
    self.mTrans_CostItemList = self:GetRectTransform("Trans_GrpItemConsume")
    self.mTrans_CostCoin = self:GetRectTransform("Trans_GrpGoldConsume")
    self.mTrans_BtnLevelUp = self:GetRectTransform("GrpAction/Trans_BtnPowerUp")
    self.mTrans_MaxLevel = self:GetRectTransform("GrpAction/Trans_MaxLevel")
    self.mText_CostCoin = self:GetText("Trans_GrpGoldConsume/Text_Num")

    self.mTrans_EnhanceContent = weaponList.mUIRoot
    self.mBtn_CloseList = weaponList.mBtn_CloseList
    self.mBtn_AutoSelect = weaponList.mBtn_AutoSelect
    self.mTrans_Sort = weaponList.mTrans_Sort
    self.mTrans_SortList = weaponList.mTrans_SortList
    self.mTrans_WeaponScroll = weaponList.mTrans_WeaponScroll
    self.mTrans_ItemBrief = weaponList.mTrans_ItemBrief
    self.mTrans_AutoSelect = weaponList.mTrans_AutoSelect
    self.mTrans_Empty = weaponList.mTrans_Empty
    self.mVirtualList = weaponList.mVirtualList
    self.mListAnimator = weaponList.mListAnimator
    self.mListAniTime = weaponList.mListAniTime

    local obj = self:InstanceUIPrefab("Character/ChrWaeaponSkillItemV2.prefab", self.mTrans_SkillList, true)
    self.skillItem = self:InitSkillItem(obj)

    for i = 1, UIWeaponGlobal.MaxMaterialCount do
        local obj = self:InstanceUIPrefab("UICommonFramework/ComItemAddItemV2.prefab", self.mTrans_AddItemList, true)
        table.insert(self.addBtnList, obj)
    end

    self:InitStageItem()
end

function UIWeaponEnhanceContentView:InitCtrl(root, weaponList)
    self:SetRoot(root)
    self:__InitCtrl(weaponList)
end

function UIWeaponEnhanceContentView:InitSkillItem(obj)
    if obj then
        local skill = {}
        skill.obj = obj
        skill.txtName = UIUtils.GetText(obj, "GrpNameInfo/GrpTextName/Text_SkillName")
        skill.txtLv = UIUtils.GetText(obj, "GrpNameInfo/GrpTextName/Trans_Text_Lv")
        skill.txtNum = UIUtils.GetText(obj, "GrpNameInfo/GrpTextName/Trans_Text_Num")
        skill.txtDesc = UIUtils.GetText(obj, "Text_Describe")

        return skill
    end
end

function UIWeaponEnhanceContentView:InitStageItem()
    if self.stageItem == nil then
        self.stageItem = UICommonStageItem.New(GlobalConfig.MaxStar)
        self.stageItem:InitCtrl(self.mTrans_Stage)
    end
end

