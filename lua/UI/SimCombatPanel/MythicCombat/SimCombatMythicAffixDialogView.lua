require("UI.UIBaseView")

---@class SimCombatMythicAffixDialogView : UIBaseView
SimCombatMythicAffixDialogView = class("SimCombatMythicAffixDialogView", UIBaseView);
SimCombatMythicAffixDialogView.__index = SimCombatMythicAffixDialogView

--@@ GF Auto Gen Block Begin
SimCombatMythicAffixDialogView.mBtn_Close = nil;
SimCombatMythicAffixDialogView.mBtn_Close1 = nil;
SimCombatMythicAffixDialogView.mContent_Affix = nil;
SimCombatMythicAffixDialogView.mScrollbar_Affix = nil;
SimCombatMythicAffixDialogView.mList_Affix = nil;

function SimCombatMythicAffixDialogView:__InitCtrl()

	self.mBtn_Close = self:GetButton("Root/GrpBg/Btn_Close");
	self.mBtn_Close1 = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close");
	self.mContent_Affix = self:GetVerticalLayoutGroup("Root/GrpDialog/GrpCenter/GrpAffixList/Viewport/Content");
	self.mScrollbar_Affix = self:GetScrollbar("Root/GrpDialog/GrpCenter/GrpAffixList/Scrollbar");
	self.mList_Affix = self:GetScrollRect("Root/GrpDialog/GrpCenter/GrpAffixList");
end

--@@ GF Auto Gen Block End

function SimCombatMythicAffixDialogView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end