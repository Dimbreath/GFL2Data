require("UI.UIBaseCtrl")

UISimCombatMythicRewardItem = class("UISimCombatMythicRewardItem", UIBaseCtrl);
UISimCombatMythicRewardItem.__index = UISimCombatMythicRewardItem
--@@ GF Auto Gen Block Begin
UISimCombatMythicRewardItem.mText_Tier = nil;
UISimCombatMythicRewardItem.mTrans_Current = nil;
UISimCombatMythicRewardItem.mTrans_ChapterRewardList = nil;

function UISimCombatMythicRewardItem:__InitCtrl()

	self.mText_Tier = self:GetText("GrpLayerNum/Text_Num");
	self.mTrans_Current = self:GetRectTransform("Trans_GrpSel");
	self.mTrans_ChapterRewardList = self:GetRectTransform("GrpReward/Viewport/Content");
end

--@@ GF Auto Gen Block End

function UISimCombatMythicRewardItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UISimCombatMythicRewardItem:SetData(tier,rewardList,isCurTier)
	local hint = TableData.GetHintById(103034)
	self.mText_Tier.text = string_format(hint, tier);
	setactive(self.mTrans_Current, isCurTier)
	clearallchild(self.mTrans_ChapterRewardList)
	for key, value in pairs(rewardList) do
		
		local itemView = UICommonItem.New();
		itemView:InitCtrl(self.mTrans_ChapterRewardList)
		itemView:SetItemData(key, value)

	end
	 
end
