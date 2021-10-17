require("UI.UIBaseCtrl")

---@class UIPostRightItemV2 : UIBaseCtrl
UIPostRightItemV2 = class("UIPostRightItemV2", UIBaseCtrl);
UIPostRightItemV2.__index = UIPostRightItemV2
--@@ GF Auto Gen Block Begin
UIPostRightItemV2.mTrans_ItemList = nil;

function UIPostRightItemV2:__InitCtrl()

	self.mLayout_ItemList = self:GetGridLayoutGroup("Trans_Layout_ItemList");
	self.mTrans_ItemList = self:GetRectTransform("Trans_Layout_ItemList");
end

--@@ GF Auto Gen Block End

UIPostRightItemV2.mPath_AttachmentItem = "UICommonFramework/ComItemV2.prefab"

function UIPostRightItemV2:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPostRightItemV2:SetData(data)
	local rewardDataList = data.rewardDataList
	for i=0,rewardDataList.Count-1 do
		local itemView = UICommonItem.New();
		itemView:InitCtrl(self.mTrans_ItemList);
		itemView:SetItemData(rewardDataList[i].itemID, rewardDataList[i].itemNum);
	end
end