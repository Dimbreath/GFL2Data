require("UI.UIBaseView")

---@class SimCombatMythicBuffSelPanelV2View : UIBaseView
SimCombatMythicBuffSelPanelV2View = class("SimCombatMythicBuffSelPanelV2View", UIBaseView);
SimCombatMythicBuffSelPanelV2View.__index = SimCombatMythicBuffSelPanelV2View

--@@ GF Auto Gen Block Begin
SimCombatMythicBuffSelPanelV2View.mText_Name = nil;
SimCombatMythicBuffSelPanelV2View.mContent_BuffSel = nil;
SimCombatMythicBuffSelPanelV2View.mScrollbar_BuffSel = nil;
SimCombatMythicBuffSelPanelV2View.mList_BuffSel = nil;

function SimCombatMythicBuffSelPanelV2View:__InitCtrl()

	self.mText_Name = self:GetText("Root/GrpBottom/GrpText/Text_Name");
	self.mContent_BuffSel = self:GetGridLayoutGroup("Root/GrpCenter/GrpBuffSelList/Viewport/Content");
	self.mScrollbar_BuffSel = self:GetScrollbar("Root/GrpCenter/GrpBuffSelList/Scrollbar");
	self.mList_BuffSel = self:GetScrollRect("Root/GrpCenter/GrpBuffSelList");
	self.mBtn_Confirm = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpBottom/GrpAction/BtnConfirm")) 
end

--@@ GF Auto Gen Block End

function SimCombatMythicBuffSelPanelV2View:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end