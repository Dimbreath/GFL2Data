require("UI.UIBaseCtrl")

UIPostContentTemplete_ItemListItem = class("UIPostContentTemplete_ItemListItem", UIBaseCtrl);
UIPostContentTemplete_ItemListItem.__index = UIPostContentTemplete_ItemListItem
--@@ GF Auto Gen Block Begin
UIPostContentTemplete_ItemListItem.mTrans_ItemList = nil;

function UIPostContentTemplete_ItemListItem:__InitCtrl()

	self.mTrans_ItemList = self:GetRectTransform("Trans_ItemList");
end

--@@ GF Auto Gen Block End

UIPostContentTemplete_ItemListItem.mPath_AttachmentItem = "UICommonFramework/UICommonItemS.prefab"

function UIPostContentTemplete_ItemListItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPostContentTemplete_ItemListItem:SetData(data)
	local rewardDataList = data.rewardDataList
	local rewardPrefab = UIUtils.GetGizmosPrefab(UIPostContentTemplete_ItemListItem.mPath_AttachmentItem,self);
	for i=0,rewardDataList.Count-1 do
		local rewardData = rewardDataList[i]
		local rewardGameObj = instantiate(rewardPrefab,self.mTrans_ItemList.transform)
		local rewardIns = UICommonItemS.New()
		rewardIns:InitCtrl(rewardGameObj.transform)
		rewardIns:SetData(rewardData.itemID,rewardData.itemNum)
	end
end