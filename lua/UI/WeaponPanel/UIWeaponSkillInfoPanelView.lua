 require("UI.UIBaseView")

UIWeaponSkillInfoPanelView = class("UIWeaponSkillInfoPanelView", UIBaseView)
UIWeaponSkillInfoPanelView.__index = UIWeaponSkillInfoPanelView

function UIWeaponSkillInfoPanelView:ctor()

end

function UIWeaponSkillInfoPanelView:__InitCtrl()
    self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_BgClose = self:GetButton("Root/GrpBg/Btn_Close")

    self.mText_LevelDesc = self:GetText("Root/GrpDialog/GrpCenter/GrpDescribe/Viewport/Content/Text_Level1")
    self.mTrans_DescList = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpDescribe/Viewport/Content/GrpLevelDescription")
end

function UIWeaponSkillInfoPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end

