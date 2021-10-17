require("UI.UIBaseCtrl")

---@class UIAchievementItemV2 : UIBaseCtrl
UIAchievementItemV2 = class("UIAchievementItemV2", UIBaseCtrl);
UIAchievementItemV2.__index = UIAchievementItemV2
--@@ GF Auto Gen Block Begin
UIAchievementItemV2.mImg_ProgressBar = nil;
UIAchievementItemV2.mText_Tittle = nil;
UIAchievementItemV2.mText_Content = nil;
UIAchievementItemV2.mText_Percent = nil;
UIAchievementItemV2.mText_Name = nil;
UIAchievementItemV2.mText_Completed = nil;
UIAchievementItemV2.mContent_Item = nil;

function UIAchievementItemV2:__InitCtrl()


	self.mImg_ProgressBar = self:GetImage("GrpProgressBar/Img_ProgressBar");
	self.mText_Tittle = self:GetText("GrpCenterText/Text_Tittle");
	self.mText_Content = self:GetText("GrpCenterText/Text_Content");
	self.mText_Percent = self:GetText("GrpProgressBar/Text_Percent");
	self.mText_Name = self:GetText("GrpState/GrpTextCompleted/TextName");
	self.mText_Completed = self:GetText("GrpState/GrpTextCompleted/Text");
	self.mContent_Item = self:GetGridLayoutGroup("GrpItem/Content");
	self.mTrans_Completed = self:GetRectTransform("GrpState/GrpTextCompleted");
	self.mTrans_Goto = self:GetRectTransform("GrpState/BtnGoAhead")
	self.mTrans_Receive = self:GetRectTransform("GrpState/BtnPick")
end

--@@ GF Auto Gen Block End

function UIAchievementItemV2:InitCtrl(parent)
	local obj = instantiate(UIUtils.GetGizmosPrefab("CommanderInfo/AchievementItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()

	local pickObj = instantiate(UIUtils.GetGizmosPrefab("CommanderInfo/AchievementBtnPickItemV2.prefab", self))
	CS.LuaUIUtils.SetParent(pickObj, self.mTrans_Receive.gameObject, true)
	self.mBtn_CompleteQuest = CS.LuaUIUtils.GetButton(pickObj.transform)

	local gotoObj = instantiate(UIUtils.GetGizmosPrefab("CommanderInfo/AchievementBtnGoAheadItemV2.prefab", self))
	CS.LuaUIUtils.SetParent(gotoObj, self.mTrans_Goto.gameObject, true)
	self.mBtn_GotoQuest = CS.LuaUIUtils.GetButton(gotoObj.transform)

	self.mText_CompleteQuest = UIUtils.GetText(self.mBtn_CompleteQuest, "Root/GrpText/TextName")
	self.mText_GotoQuest = UIUtils.GetText(self.mBtn_GotoQuest, "Root/GrpText/TextName")

	self.mText_GotoQuest.text = TableData.GetHintById(20)
	self.mText_CompleteQuest.text = TableData.GetHintById(901001)

	self.mItemViewList = List:New();
end

function UIAchievementItemV2:SetData(data)
	if data ~= nil then
		setactive(self.mUIRoot, true);
		self.mText_Tittle.text = data.Name;
		self.mText_Content.text = data.Desp;
		self.mImg_ProgressBar.fillAmount = data.Progress
		self.mText_Percent.text = data.ProgressStr

		for _, item in ipairs(self.mItemViewList) do
			gfdestroy(item:GetRoot());
		end

		for i = 0, data.RewardList.Count - 1 do
			local itemview = UICommonItem.New();
			itemview:InitCtrl(self.mContent_Item);
			itemview:SetItemData(data.RewardList[i].itemid, data.RewardList[i].num);
			self.mItemViewList:Add(itemview);
			itemview.mUIRoot:SetAsFirstSibling();

			local stcData = TableData.GetItemData(data.RewardList[i].itemid)
			TipsManager.Add(itemview.mUIRoot, stcData)
		end

		local isCompleted = data.IsCompleted
		local canJump = data.CanJump
		local isReceived = data.IsReceived
		setactive(self.mTrans_Receive, isCompleted and not isReceived)
		setactive(self.mTrans_Goto, not isCompleted and canJump)
		if isCompleted then
			self.mText_Name.text = TableData.GetHintById(901003)
		else
			self.mText_Name.text = TableData.GetHintById(901002)
		end

		setactive(self.mTrans_Completed, (isCompleted and isReceived) or (not isCompleted and not canJump))
	else
		setactive(self.mUIRoot, false);
	end
end