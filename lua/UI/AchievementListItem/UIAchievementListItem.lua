require("UI.UIBaseCtrl")

UIAchievementListItem = class("UIAchievementListItem", UIBaseCtrl);
UIAchievementListItem.__index = UIAchievementListItem
--@@ GF Auto Gen Block Begin
UIAchievementListItem.mBtn_GotoQuest = nil;
UIAchievementListItem.mBtn_CompleteQuest = nil;
UIAchievementListItem.mBtn_FinishReceive = nil;
UIAchievementListItem.mBtn_InProgress = nil;
UIAchievementListItem.mImage_UndoQuest_IconImage = nil;
UIAchievementListItem.mImage_FinishQuest_IconImage = nil;
UIAchievementListItem.mText_UndoQuest_Title = nil;
UIAchievementListItem.mText_UndoQuest_Task = nil;
UIAchievementListItem.mText_UndoQuest_Progress = nil;
UIAchievementListItem.mText_FinishQuest_Title = nil;
UIAchievementListItem.mText_FinishQuest_Task = nil;
UIAchievementListItem.mText_FinishQuest_Progress = nil;
UIAchievementListItem.mTrans_UndoQuest = nil;
UIAchievementListItem.mTrans_FinishQuest = nil;
UIAchievementListItem.mTrans_FinishQuest_FinishReceiveMask = nil;
UIAchievementListItem.mTrans_ItemList = nil;

function UIAchievementListItem:__InitCtrl()

	self.mBtn_GotoQuest = self:GetButton("Btn_GotoQuest");
	self.mBtn_CompleteQuest = self:GetButton("Btn_CompleteQuest");
	self.mBtn_FinishReceive = self:GetButton("Btn_FinishReceive");
	self.mBtn_InProgress = self:GetButton("Btn_InProgress");
	self.mImage_UndoQuest_IconImage = self:GetImage("UI_Trans_UndoQuest/Image_IconImage");
	self.mImage_FinishQuest_IconImage = self:GetImage("UI_Trans_FinishQuest/Image_IconImage");
	self.mText_UndoQuest_Title = self:GetText("UI_Trans_UndoQuest/Text_Title");
	self.mText_UndoQuest_Task = self:GetText("UI_Trans_UndoQuest/Text_Task");
	self.mText_UndoQuest_Progress = self:GetText("UI_Trans_UndoQuest/Text_Progress");
	self.mText_FinishQuest_Title = self:GetText("UI_Trans_FinishQuest/Text_Title");
	self.mText_FinishQuest_Task = self:GetText("UI_Trans_FinishQuest/Text_Task");
	self.mText_FinishQuest_Progress = self:GetText("UI_Trans_FinishQuest/Text_Progress");
	self.mTrans_UndoQuest = self:GetRectTransform("UI_Trans_UndoQuest");
	self.mTrans_FinishQuest = self:GetRectTransform("UI_Trans_FinishQuest");
	self.mTrans_FinishQuest_FinishReceiveMask = self:GetRectTransform("UI_Trans_FinishQuest/Trans_FinishReceiveMask");
	self.mTrans_ItemList = self:GetRectTransform("UI_Trans_ItemList");
end

--@@ GF Auto Gen Block End

UIAchievementListItem.mScrollBar1 = nil;
UIAchievementListItem.mScrollBar2 = nil;

UIAchievementListItem.mPath_item = "AchievementPanel/UIAchievementListItem.prefab";
UIAchievementListItem.mData = nil;
UIAchievementListItem.mItemViewList = nil;

function UIAchievementListItem:InitCtrl(parent)
	local obj=instantiate(UIUtils.GetGizmosPrefab(UIAchievementListItem.mPath_item,self));
    self:SetRoot(obj.transform);
    setparent(parent,obj.transform);
    obj.transform.localScale=vectorone;
    self:SetRoot(obj.transform);
	self:__InitCtrl();
	
	self.mScrollBar1 = self:GetScrollbar("UI_Trans_UndoQuest/Scrollbar");
	self.mScrollBar2 = self:GetScrollbar("UI_Trans_FinishQuest/Scrollbar");

	self.mItemViewList = List:New();
end

function UIAchievementListItem:InitData(data)
	if data ~= nil then
		setactive(self.mUIRoot, true);
		self.mData = data;

		self.mText_UndoQuest_Title.text = data.Name;
		self.mText_FinishQuest_Title.text = data.Name;
		self.mText_UndoQuest_Task.text = data.Desp;
		self.mText_FinishQuest_Task.text = data.Desp;
		self.mText_UndoQuest_Progress.text = data.ProgressStr;
		self.mText_FinishQuest_Progress.text = data.ProgressStr;
		self.mScrollBar1.size = data.Progress;
		self.mScrollBar2.size = data.Progress;

		if(data.IsCompleted and data.IsReceived) then
			setactive(self.mBtn_FinishReceive.gameObject, true);
			setactive(self.mBtn_GotoQuest.gameObject, false);
			setactive(self.mBtn_CompleteQuest.gameObject, false);
			setactive(self.mBtn_InProgress.gameObject, false);

			setactive(self.mTrans_UndoQuest.gameObject, false);
			setactive(self.mTrans_FinishQuest.gameObject, true);
		end

		if(data.IsCompleted and not data.IsReceived) then
			setactive(self.mBtn_FinishReceive.gameObject, false);
			setactive(self.mBtn_GotoQuest.gameObject, false);
			setactive(self.mBtn_CompleteQuest.gameObject, true);
			setactive(self.mBtn_InProgress.gameObject, false);

			setactive(self.mTrans_UndoQuest.gameObject, false);
			setactive(self.mTrans_FinishQuest.gameObject, true);
		end

		if(not data.IsCompleted and data.CanJump) then
			setactive(self.mBtn_FinishReceive.gameObject, false);
			setactive(self.mBtn_GotoQuest.gameObject, true);
			setactive(self.mBtn_CompleteQuest.gameObject, false);
			setactive(self.mBtn_InProgress.gameObject, false);

			setactive(self.mTrans_UndoQuest.gameObject, true);
			setactive(self.mTrans_FinishQuest.gameObject, false);
			
		end

		if(not data.IsCompleted and not data.CanJump) then
			setactive(self.mBtn_FinishReceive.gameObject, false);
			setactive(self.mBtn_GotoQuest.gameObject, false);
			setactive(self.mBtn_CompleteQuest.gameObject, false);
			setactive(self.mBtn_InProgress.gameObject, true);

			setactive(self.mTrans_UndoQuest.gameObject, true);
			setactive(self.mTrans_FinishQuest.gameObject, false);
			
		end

		local prefab = UIUtils.GetGizmosPrefab(UICommonItemS.Path_UICommonItemS,self);
		local rewardList = data.RewardList;

		for _, item in ipairs(self.mItemViewList) do
			gfdestroy(item:GetRoot());
		end

		for i = 0, rewardList.Count - 1 do
			local instObj = instantiate(prefab);
			local itemview = UICommonItemS.New();
			itemview:InitCtrl(instObj.transform);
			self.mItemViewList:Add(itemview);
			itemview:SetData(rewardList[i].itemid, rewardList[i].num);
			UIUtils.AddListItem(instObj, self.mTrans_ItemList.transform);
		end
	else
		setactive(self.mUIRoot, false);
	end

end