require("UI.UIBaseView")

---@class SimCombatMythicRewardDialogV2 : UIBasePanel
SimCombatMythicRewardDialogV2 = class("SimCombatMythicRewardDialogV2", UIBasePanel);
SimCombatMythicRewardDialogV2.__index = SimCombatMythicRewardDialogV2

--@@ GF Auto Gen Block Begin


SimCombatMythicRewardDialogV2.mView = nil
SimCombatMythicRewardDialogV2.mTier = 0;

function SimCombatMythicRewardDialogV2.Init(root, data)
	self = SimCombatMythicRewardDialogV2

	SimCombatMythicRewardDialogV2.mData = data
	
	SimCombatMythicRewardDialogV2.mView = SimCombatMythicRewardDialogV2View
	SimCombatMythicRewardDialogV2.mView:InitCtrl(root)
	self.mIsPop = true
	SimCombatMythicRewardDialogV2.super.SetRoot(SimCombatMythicRewardDialogV2, root)
	
	
	self:InitCtrl(root)
	self.mTier = data;

	self:SetData();
end

function SimCombatMythicRewardDialogV2:InitCtrl(root)
	self:SetRoot(root);

	UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
		self.Close()
	end

	UIUtils.GetButtonListener(self.mView.mBtn_Close1.gameObject).onClick = function()
		self.Close()
	end

end

function SimCombatMythicRewardDialogV2:SetData()
	local mythicMainDatasList = TableData.listSimCombatMythicMainDatas:GetList();

	for i = 0, mythicMainDatasList.Count - 1 do
		local curMainData = mythicMainDatasList[i]
		local obj = instantiate(UIUtils.GetGizmosPrefab("SimCombat/SimCombatMythicRewardItemV2.prefab", self));
		setparent(self.mView.mContent_Reward.transform, obj.transform);
		obj.transform.localScale = vectorone;
		local mythicRewardItem = UISimCombatMythicRewardItem.New();
		mythicRewardItem:InitCtrl(obj.transform);
		local isCurTier = false;
		if curMainData.Id == self.mTier then
			isCurTier = true;
		end
		mythicRewardItem:SetData(curMainData.Id, curMainData.RewardList, isCurTier);
	end
end

function SimCombatMythicRewardDialogV2.Close()
	UIManager.CloseUI(UIDef.SimCombatMythicRewardDialogV2)
end

