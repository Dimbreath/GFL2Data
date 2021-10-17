require("UI.UIBaseCtrl")

UIQuestRewardDialog = class("UIQuestRewardDialog", UIBaseCtrl);
UIQuestRewardDialog.__index = UIQuestRewardDialog
--@@ GF Auto Gen Block Begin
UIQuestRewardDialog.mBtn_panel_Close = nil;
UIQuestRewardDialog.mHLayout_ItemList = nil;

function UIQuestRewardDialog:__InitCtrl()

	self.mBtn_panel_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close");
	self.mHLayout_ItemList = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpItemList/Viewport/Content");

    UIUtils.GetButtonListener(self.mBtn_panel_Close.gameObject).onClick = function()
		setactive(self:GetRoot().gameObject, false);
	end
end

--@@ GF Auto Gen Block End

function UIQuestRewardDialog:InitCtrl(root)
	local obj = instantiate(UIUtils.GetGizmosPrefab("DailyQuest/QuestRewardlDialogV2.prefab",self));
    
	self:SetRoot(obj.transform);
	obj.transform:SetParent(root, false)
	self:__InitCtrl();
    return obj
end

function UIQuestRewardDialog:SetData(rewardList,getPoint)

    clearallchild(self.mHLayout_ItemList.transform)

    local lastItem = nil;
    local lastValue = 0;
    for i, v in pairs(rewardList) do
        local item = UIQuestRewardItem.New()
        item:InitCtrl(self.mHLayout_ItemList)
        item:SetData(v,getPoint);

        if(v.Value > getPoint and lastValue <= getPoint and lastItem) then
            lastItem:SetSelect(true)
        end

        lastItem = item;
        lastValue = v.Value;
	end

    setactive(self:GetRoot().gameObject, true);

end 