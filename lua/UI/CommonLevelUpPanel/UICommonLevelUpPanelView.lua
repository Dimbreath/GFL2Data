 require("UI.UIBaseView")

UICommonLevelUpPanelView = class("UICommonLevelUpPanelView", UIBaseView)
UICommonLevelUpPanelView.__index = UICommonLevelUpPanelView

function UICommonLevelUpPanelView:ctor()

end

function UICommonLevelUpPanelView:__InitCtrl()
    --self.mBtn_Close = self:GetButton("Btn_Close")
    self.mText_Lv_1 = self:GetText("Root/GrpLvUp/GrpCenter/GrpLevelUp/GrpTextNum/Text_2/Text2")
    self.mText_BeforeLv_1 = self:GetText("Root/GrpLvUp/GrpCenter/GrpLevelUp/GrpTextNum/Text_2/Text")
    self.mText_Lv_2 = self:GetText("Root/GrpLvUp/GrpCenter/GrpLevelUp/GrpTextNum/Text_1/Text2")
    self.mText_BeforeLv_2 = self:GetText("Root/GrpLvUp/GrpCenter/GrpLevelUp/GrpTextNum/Text_1/Text")

    self.mTransLevelNum = self:GetRectTransform("Root/GrpLvUp/GrpCenter/GrpLevelUp/TextNum/Text_Level")

    self.mTrans_PropertyList = self:GetRectTransform("propertyList")

    self.mAnimator = self:GetRectTransform("Root"):GetComponent("Animator")

    self.mTrans_LvUp = self:GetRectTransform("Root/GrpLvUp")
    self.mTrans_Text = self:GetRectTransform("Root/GrpText")

    self.mBtn_Close = self:GetButton("Root/GrpBg/Btn_Close")

    --self.mTweenNumber = self.mTransLevelNum:GetComponent("TweenNumber")

    self.mAnimText_1 = self:GetRectTransform("Root/GrpLvUp/GrpCenter/GrpLevelUp/GrpTextNum/Text_2"):GetComponent("Animator")
    self.mAnimText_2 = self:GetRectTransform("Root/GrpLvUp/GrpCenter/GrpLevelUp/GrpTextNum/Text_1"):GetComponent("Animator")

    self.mTextName = self:GetText("Root/GrpLvUp/GrpCenter/GrpTextDescription/TexName/TexName")
end

function UICommonLevelUpPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end

