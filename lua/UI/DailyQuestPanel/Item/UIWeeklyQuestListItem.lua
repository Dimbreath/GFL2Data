require("UI.UIBaseCtrl")

UIWeeklyQuestListItem = class("UIWeeklyQuestListItem", UIBaseCtrl);
UIWeeklyQuestListItem.__index = UIWeeklyQuestListItem
--@@ GF Auto Gen Block Begin
UIWeeklyQuestListItem.mBtn_UndoQuest_GotoQuest = nil;
UIWeeklyQuestListItem.mBtn_FinishQuest_FinishQuest = nil;
UIWeeklyQuestListItem.mBtn_CompleteQuest = nil;
UIWeeklyQuestListItem.mText_UndoQuest_Title = nil;
UIWeeklyQuestListItem.mText_UndoQuest_MainText = nil;
UIWeeklyQuestListItem.mText_UndoQuest_Progress = nil;
UIWeeklyQuestListItem.mText_FinishQuest_Number = nil;
UIWeeklyQuestListItem.mText_FinishQuest_Title = nil;
UIWeeklyQuestListItem.mText_FinishQuest_MainText = nil;
UIWeeklyQuestListItem.mText_FinishQuest_Progress = nil;
UIWeeklyQuestListItem.mTrans_UndoQuest = nil;
UIWeeklyQuestListItem.mTrans_FinishQuest = nil;
UIWeeklyQuestListItem.mTrans_ItemList = nil;

function UIWeeklyQuestListItem:__InitCtrl()

	self.mBtn_UndoQuest_GotoQuest = self:GetButton("Btn_GotoQuest");
	self.mBtn_FinishQuest_FinishQuest = self:GetButton("Btn_FinishReceive");
	self.mBtn_CompleteQuest = self:GetButton("Btn_CompleteQuest");
	self.mText_UndoQuest_Title = self:GetText("UI_Trans_UndoQuest/Text_Title");
	self.mText_UndoQuest_MainText = self:GetText("UI_Trans_UndoQuest/Text_Task");
	self.mText_UndoQuest_Progress = self:GetText("UI_Trans_UndoQuest/Text_Progress");
	self.mText_FinishQuest_Title = self:GetText("UI_Trans_FinishQuest/Text_Title");
	self.mText_FinishQuest_MainText = self:GetText("UI_Trans_FinishQuest/Text_Task");
	self.mText_FinishQuest_Progress = self:GetText("UI_Trans_FinishQuest/Text_Progress");
	self.mImage_UnDoIcon = self:GetImage("UI_Trans_UndoQuest/Image_IconImage");
	self.mImage_FinishIcon = self:GetImage("UI_Trans_FinishQuest/Image_IconImage");
	self.mTrans_UndoQuest = self:GetRectTransform("UI_Trans_UndoQuest");
	self.mTrans_FinishQuest = self:GetRectTransform("UI_Trans_FinishQuest");
	self.mTrans_ItemList = self:GetRectTransform("UI_Trans_ItemList");
end

--@@ GF Auto Gen Block End

UIWeeklyQuestListItem.mItemViewList = nil;

function UIWeeklyQuestListItem:InitCtrl(parent)

	local obj=instantiate(UIUtils.GetGizmosPrefab("DailyQuest/UIWeeklyQuestListItem.prefab",self));
    self:SetRoot(obj.transform);

	self:__InitCtrl();

	self.mItemViewList=List:New();

	self.mScrollBar1=self:GetScrollbar("UI_Trans_UndoQuest/Scrollbar");
	self.mScrollBar2=self:GetScrollbar("UI_Trans_FinishQuest/Scrollbar");

end

-- function UIWeeklyQuestListItem:InitCtrl(parent)

-- 	local obj=instantiate(UIUtils.GetGizmosPrefab("DailyQuest/UIWeeklyQuestListItem.prefab",self));
--     self:SetRoot(obj.transform);
--     setparent(parent,obj.transform);
-- 	obj.transform.localScale=vectorone;

-- 	self:SetRoot(obj.transform);

-- 	self:__InitCtrl();

-- 	self.mItemViewList=List:New();

-- 	self.mScrollBar1=self:GetScrollbar("UI_Trans_UndoQuest/Scrollbar");
-- 	self.mScrollBar2=self:GetScrollbar("UI_Trans_FinishQuest/Scrollbar");

-- end

function UIWeeklyQuestListItem:SetData(data, typeData)
    if data~=nil then

        setactive(self.mUIRoot,true);

		self.mText_UndoQuest_Title.text=data.name;
		self.mText_FinishQuest_Title.text=data.name;
		self.mText_UndoQuest_Progress.text = data:GetProgressStr();
		self.mText_FinishQuest_Progress.text = data:GetProgressStr();
		self.mText_UndoQuest_MainText.text=data.description;
		self.mText_FinishQuest_MainText.text=data.description;

		self.mScrollBar1.size=data:GetProgress();
		self.mScrollBar2.size=data:GetProgress();

		if typeData then
			self.mImage_UnDoIcon.sprite = IconUtils.GetTaskIcon(typeData.type_task_icon .. "01")
			self.mImage_FinishIcon.sprite = IconUtils.GetTaskIcon(typeData.type_task_icon .. "02")
		end

        local state=data:GetState();

        if state==0 then
            setactive(self.mBtn_UndoQuest_GotoQuest,true);
			setactive(self.mBtn_FinishQuest_FinishQuest,false);
			setactive(self.mBtn_CompleteQuest, false);
			setactive(self.mTrans_UndoQuest,true);
			setactive(self.mTrans_FinishQuest,false);
        elseif state==1 then
            setactive(self.mBtn_UndoQuest_GotoQuest,false);
			setactive(self.mBtn_FinishQuest_FinishQuest,false);
			setactive(self.mBtn_CompleteQuest, true);
			setactive(self.mTrans_UndoQuest,false);
			setactive(self.mTrans_FinishQuest,true);
		elseif state == 2 then
			setactive(self.mBtn_UndoQuest_GotoQuest,false);
			setactive(self.mBtn_FinishQuest_FinishQuest,true);
			setactive(self.mBtn_CompleteQuest, false);
			setactive(self.mTrans_UndoQuest,false);
			setactive(self.mTrans_FinishQuest,true);
        else
            gferror(data.id);
		end

		local datas=data.rewardList;

        for i = 1, self.mItemViewList:Count() do
            self.mItemViewList[i]:SetData(nil,nil);
        end

		local prefab = UIUtils.GetGizmosPrefab(UICommonItemS.Path_UICommonItemS,self);
		local i = 0
		for itemId, num in pairs(datas) do
			if i< self.mItemViewList:Count() then
				self.mItemViewList[i+1]:SetData(itemId,num);
			else
				local instObj = instantiate(prefab);
				local itemview = UICommonItemS.New();
				itemview:InitCtrl(instObj.transform);
				self.mItemViewList:Add(itemview);
				itemview:SetData(itemId, num);
				UIUtils.AddListItem(instObj, self.mTrans_ItemList.transform);
			end
			i = i + 1
		end
    else
        setactive(self.mUIRoot,false);
    end
end