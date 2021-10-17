require("UI.UIBaseCtrl")

UIQuestRewardItem = class("UIQuestRewardItem", UIBaseCtrl);
UIQuestRewardItem.__index = UIQuestRewardItem
--@@ GF Auto Gen Block Begin
UIQuestRewardItem.mBtn_panel_Close = nil;
UIQuestRewardItem.mHLayout_ItemList = nil;

function UIQuestRewardItem:__InitCtrl()
    self.mText_Num = self:GetText("GrpCollectNum/GrpText/Text_Num")
	self.mHLayout_ItemList = self:GetRectTransform("GrpRewardList/Viewport/Content");
    self.mTrans_Select = self:GetRectTransform("Trans_GrpSel");
    self.mTrans_UnfinishedBox = self:GetRectTransform("GrpState/Trans_TextUnCompleted");
	self.mTrans_FinishedBox = self:GetRectTransform("GrpState/Trans_BtnCanReceive");
	self.mTrans_ReceivedBox = self:GetRectTransform("GrpState/Trans_TextCompleted");

    self.mBtn_Receive = self:GetButton("GrpState/Trans_BtnCanReceive/ComBtn3ItemV2")
end

--@@ GF Auto Gen Block End

UIQuestRewardItem.mGetPoint = 0;
UIQuestRewardItem.mData = nil;

function UIQuestRewardItem:InitCtrl(root)
	local obj = instantiate(UIUtils.GetGizmosPrefab("DailyQuest/QuestRewardItemV2.prefab",self));
	self:SetRoot(obj.transform);
	obj.transform:SetParent(root, false)
	self:__InitCtrl();

end

function UIQuestRewardItem:SetData(data,getPoint)
    self.mText_Num.text = data.Value
    self.mData = data;
    self.mGetPoint = getPoint
	if data ~=nil then
		for itemId, num  in pairs(data.RewardList) do

			local itemview = UICommonItem.New();
			itemview:InitCtrl(self.mHLayout_ItemList);
			itemview:SetItemData(itemId, num);
            itemview.mUIRoot:SetAsFirstSibling();

            local stcData = TableData.GetItemData(itemId)
            TipsManager.Add(itemview.mUIRoot, stcData)
		end
		setactive(self:GetRoot().gameObject, true);
	else
		setactive(self:GetRoot().gameObject, false);
	end
    local dailyRewards = NetCmdQuestData:GetDailyRewards();
    if getPoint >=data.Value then
        setactive(self.mTrans_UnfinishedBox.gameObject, false);
        setactive(self.mTrans_FinishedBox.gameObject, true);
    end
    for key, value in pairs(dailyRewards) do
        if key == data.Id and value == true then
            setactive(self.mTrans_ReceivedBox.gameObject, true);
            setactive(self.mTrans_UnfinishedBox.gameObject, false);
            setactive(self.mTrans_FinishedBox.gameObject, false);
        end
    end

    UIUtils.GetButtonListener(self.mBtn_Receive.gameObject).onClick = function()
		NetCmdQuestData:C2SQuestTakeDailyReward(data.Id,self.TakeQuestRewardCallBack)
	end

end 

function UIQuestRewardItem:SetSelect(isSelect)
	setactive(self.mTrans_Select,isSelect)
end

function UIQuestRewardItem.TakeQuestRewardCallBack(data)
	UIDailyQuestPanel.UpdateQuestRewardDialog()
end