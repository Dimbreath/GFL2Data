require("UI.UIBaseView")

---@class UICommonBuffDisplayPanelView : UIBaseView
UICommonBuffDisplayPanelView = class("UICommonBuffDisplayPanelView", UIBaseView)
UICommonBuffDisplayPanelView.__index = UICommonBuffDisplayPanelView

function UICommonBuffDisplayPanelView:__InitCtrl()
	self.mBtn_Close = self:GetButton("Root/GrpBg/Btn_Close")
	self.mBtn_Close1 = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
	self.mText_SkillName = self:GetText("Root/GrpDialog/GrpCenter/GrpSkillDescribe/GrpSkillDescribe/Viewport/Content/Text_SkillName")
	self.mText_Description = self:GetText("Root/GrpDialog/GrpCenter/GrpSkillDescribe/GrpSkillDescribe/Viewport/Content/Text_Description")
	self.mContent_Skill = self:GetGridLayoutGroup("Root/GrpDialog/GrpCenter/GrpSkillBuff/GrpSkill/Viewport/Content")
	self.mContent_SkillContent = self:GetVerticalLayoutGroup("Root/GrpDialog/GrpCenter/GrpSkillDescribe/GrpSkillDescribe/Viewport/Content")
	self.mScrollbar_ = self:GetScrollbar("Root/GrpDialog/GrpCenter/GrpSkillBuff/GrpSkill/Scrollbar")
	self.mScrollbar_1 = self:GetScrollbar("Root/GrpDialog/GrpCenter/GrpSkillDescribe/GrpSkillDescribe/Scrollbar")

	self.mTrans_Center = self:GetRectTransform("Root/GrpDialog/GrpCenter")
	self.mTrans_GrpEmpty = self:GetRectTransform("Root/GrpDialog/Trans_GrpEmpty")
end

--@@ GF Auto Gen Block End

function UICommonBuffDisplayPanelView:InitCtrl(root)
	self:SetRoot(root)

	self:__InitCtrl()
end