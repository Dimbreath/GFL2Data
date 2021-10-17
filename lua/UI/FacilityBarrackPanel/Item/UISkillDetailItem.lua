require("UI.UIBaseCtrl")

UISkillDetailItem = class("UISkillDetailItem", UIBaseCtrl)
UISkillDetailItem.__index = UISkillDetailItem
--@@ GF Auto Gen Block Begin
UISkillDetailItem.StarList = {}

UISkillDetailItem.mData = nil
UISkillDetailItem.PrefabPath = "UICommonFramework/ChrSkillDescriptionItemV2.prefab"

function UISkillDetailItem:ctor()
    UISkillDetailItem.super.ctor(self)
end

function UISkillDetailItem:__InitCtrl()
    self.mImage_Statue = self:GetImage("GrpLevel/Img_Bg")
    self.mText_Lv = self:GetText("GrpLevel/Text_Num")
    self.mText_Desc = self:GetText("Text_Description")
    self.mText_LevelHint = self:GetText("GrpLevel/Text")
end

function UISkillDetailItem:InitCtrl(parent)
    local itemPrefab = UIUtils.GetGizmosPrefab(self.PrefabPath, self)
    local instObj = instantiate(itemPrefab)

    UIUtils.AddListItem(instObj.gameObject, parent.gameObject)

    self:SetRoot(instObj.transform)
    self:__InitCtrl()
end

function UISkillDetailItem:SetData(skillData, curLevel, textColor)
    textColor = textColor == nil and ColorUtils.WhiteColor or ColorUtils.BlackColor
    self.mData = skillData
    if skillData then
        self.mText_Lv.text = skillData.level
        self.mText_Desc.text = skillData.upgrade_description.str

        local color = skillData.level == curLevel and ColorUtils.OrangeColor or textColor
        self.mImage_Statue.color = color
        self.mText_Desc.color = color
        if textColor == ColorUtils.WhiteColor then
            self.mText_Lv.color = ColorUtils.BlackColor
            self.mText_LevelHint.color = ColorUtils.BlackColor
        elseif textColor == ColorUtils.BlackColor then
            self.mText_Lv.color = ColorUtils.WhiteColor
            self.mText_LevelHint.color = ColorUtils.WhiteColor
        end
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

