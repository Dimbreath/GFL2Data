require("UI.UIBaseView")

---@class SimCombatMythicRewardDialogV2View : UIBaseView
SimCombatMythicRewardDialogV2View = class("SimCombatMythicRewardDialogV2View", UIBaseView);
SimCombatMythicRewardDialogV2View.__index = SimCombatMythicRewardDialogV2View

--@@ GF Auto Gen Block Begin
SimCombatMythicRewardDialogV2View.mBtn_Close = nil;
SimCombatMythicRewardDialogV2View.mBtn_Close1 = nil;
SimCombatMythicRewardDialogV2View.mContent_Reward = nil;
SimCombatMythicRewardDialogV2View.mScrollbar_Reward = nil;
SimCombatMythicRewardDialogV2View.mList_Reward = nil;

function SimCombatMythicRewardDialogV2View:__InitCtrl()

	self.mBtn_Close = self:GetButton("Root/GrpBg/Btn_Close");
	self.mBtn_Close1 = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close");
	self.mContent_Reward = self:GetGridLayoutGroup("Root/GrpDialog/GrpCenter/RewardList/Viewport/Content");
	self.mScrollbar_Reward = self:GetScrollbar("Root/GrpDialog/GrpCenter/RewardList/Scrollbar");
	self.mList_Reward = self:GetScrollRect("Root/GrpDialog/GrpCenter/RewardList");
end

--@@ GF Auto Gen Block End

function SimCombatMythicRewardDialogV2View:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end