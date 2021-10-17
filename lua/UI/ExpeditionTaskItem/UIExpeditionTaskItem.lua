require("UI.UIBaseCtrl")
require("UI.Common.UICommonItemS")

UIExpeditionTaskItem = class("UIExpeditionTaskItem", UIBaseCtrl);
UIExpeditionTaskItem.__index = UIExpeditionTaskItem
--@@ GF Auto Gen Block Begin
UIExpeditionTaskItem.mBtn_ExpeditionTaskInformation_GoExpedition_GoExpedition = nil;
UIExpeditionTaskItem.mBtn_ExpeditionTaskInformation_GoExpedition_CancelExpedition = nil;
UIExpeditionTaskItem.mImage_ExpeditionTaskInformation_ExpeditionTaskProgress = nil;
UIExpeditionTaskItem.mText_ExpeditionTaskInformation_ExpeditionTaskName = nil;
UIExpeditionTaskItem.mText_ExpeditionTaskInformation_Description = nil;
UIExpeditionTaskItem.mText_ExpeditionTaskInformation_ExpeditionTime_ExpeditionTimeCountdown = nil;
UIExpeditionTaskItem.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionConsumption = nil;
UIExpeditionTaskItem.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionLevel = nil;
UIExpeditionTaskItem.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionRemainderTime = nil;
UIExpeditionTaskItem.mText_ExpeditionTaskInformation_LockDescription = nil;
UIExpeditionTaskItem.mText_ExpeditionTaskInformation_ExpCount = nil;
UIExpeditionTaskItem.mScrRect_ExpeditionTaskInformation_DropItemList_ItemList = nil;
UIExpeditionTaskItem.mTrans_ExpeditionTaskInformation_DropItemList_DropItemList = nil;
UIExpeditionTaskItem.mTrans_ExpeditionTaskInformation_GoExpedition_GoExpedition = nil;
UIExpeditionTaskItem.mTrans_ExpeditionTaskInformation_GoExpedition_CancelExpedition = nil;
UIExpeditionTaskItem.mTrans_ExpeditionTaskInformation_GoExpedition_ExpeditionLevel = nil;
UIExpeditionTaskItem.mTrans_ExpeditionTaskInformation_GoExpedition_ExpeditionRemainderTime = nil;
UIExpeditionTaskItem.mTrans_ExpeditionTaskInformation_ExpeditionTaskLock = nil;

UIExpeditionTaskItem.mData = nil;
UIExpeditionTaskItem.mCountDownTimer = nil;

UIExpeditionTaskItem.mPath_UICommonItemS = "UICommonFramework/UICommonItemS.prefab";

function UIExpeditionTaskItem:__InitCtrl()

	self.mBtn_ExpeditionTaskInformation_GoExpedition_GoExpedition = self:GetButton("UI_ExpeditionTaskInformation/UI_GoExpedition/Trans_Btn_GoExpedition");
	self.mBtn_ExpeditionTaskInformation_GoExpedition_CancelExpedition = self:GetButton("UI_ExpeditionTaskInformation/UI_GoExpedition/Trans_Btn_CancelExpedition");
	self.mImage_ExpeditionTaskInformation_ExpeditionTaskProgress = self:GetImage("UI_ExpeditionTaskInformation/Image_ExpeditionTaskProgress");
	self.mText_ExpeditionTaskInformation_ExpeditionTaskName = self:GetText("UI_ExpeditionTaskInformation/Text_ExpeditionTaskName");
	self.mText_ExpeditionTaskInformation_Description = self:GetText("UI_ExpeditionTaskInformation/Text_Description");
	self.mText_ExpeditionTaskInformation_ExpeditionTime_ExpeditionTimeCountdown = self:GetText("UI_ExpeditionTaskInformation/UI_ExpeditionTime/Text_ExpeditionTimeCountdown");
	self.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionConsumption = self:GetText("UI_ExpeditionTaskInformation/UI_GoExpedition/Trans_Btn_GoExpedition/ExpeditionConsumption/Text_ExpeditionConsumption");
	self.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionLevel = self:GetText("UI_ExpeditionTaskInformation/UI_GoExpedition/Trans_Text_ExpeditionLevel");
	self.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionRemainderTime = self:GetText("UI_ExpeditionTaskInformation/UI_GoExpedition/Trans_Text_ExpeditionRemainderTime");
	self.mText_ExpeditionTaskInformation_LockDescription = self:GetText("UI_ExpeditionTaskInformation/Trans_ExpeditionTaskLock/Text_LockDescription");
	self.mText_ExpeditionTaskInformation_ExpCount = self:GetText("UI_ExpeditionTaskInformation/UI_DropItemList/ScrRect_ItemList/Trans_DropItemList/UI_ExpItem/Trans_CountBGImage/Text_Count");
	self.mScrRect_ExpeditionTaskInformation_DropItemList_ItemList = self:GetScrollRect("UI_ExpeditionTaskInformation/UI_DropItemList/ScrRect_ItemList");
	self.mTrans_ExpeditionTaskInformation_DropItemList_DropItemList = self:GetRectTransform("UI_ExpeditionTaskInformation/UI_DropItemList/ScrRect_ItemList/Trans_DropItemList");
	self.mTrans_ExpeditionTaskInformation_GoExpedition_GoExpedition = self:GetRectTransform("UI_ExpeditionTaskInformation/UI_GoExpedition/Trans_Btn_GoExpedition");
	self.mTrans_ExpeditionTaskInformation_GoExpedition_CancelExpedition = self:GetRectTransform("UI_ExpeditionTaskInformation/UI_GoExpedition/Trans_Btn_CancelExpedition");
	self.mTrans_ExpeditionTaskInformation_GoExpedition_ExpeditionLevel = self:GetRectTransform("UI_ExpeditionTaskInformation/UI_GoExpedition/Trans_Text_ExpeditionLevel");
	self.mTrans_ExpeditionTaskInformation_GoExpedition_ExpeditionRemainderTime = self:GetRectTransform("UI_ExpeditionTaskInformation/UI_GoExpedition/Trans_Text_ExpeditionRemainderTime");
	self.mTrans_ExpeditionTaskInformation_ExpeditionTaskLock = self:GetRectTransform("UI_ExpeditionTaskInformation/Trans_ExpeditionTaskLock");
end

--@@ GF Auto Gen Block End

function UIExpeditionTaskItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIExpeditionTaskItem:InitData(data)
	if(self.mCountDownTimer ~= nil) then
		self.mCountDownTimer:Stop()
		-- TimerSys:Remove(self.mCountDownTimer);
		self.mCountDownTimer = nil;
	end

	if data == nil then
		setactive(self.mUIRoot,false);
		return;
	else 
		setactive(self.mUIRoot,true);
	end
	

	self.mData = data;

	self.mText_ExpeditionTaskInformation_ExpeditionTaskName.text = data.Name
	self.mText_ExpeditionTaskInformation_Description.text = "2";
	self.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionConsumption.text = "3";
	self.mText_ExpeditionTaskInformation_ExpeditionTime_ExpeditionTimeCountdown.text = data.TotalTime;

	if(data.IsInProgress == false) then
		setactive(self.mBtn_ExpeditionTaskInformation_GoExpedition_GoExpedition.gameObject,true);
		setactive(self.mBtn_ExpeditionTaskInformation_GoExpedition_CancelExpedition.gameObject,false);
		setactive(self.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionLevel.gameObject,true);
		self.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionLevel.text = "需求等级Lv"..data.Level;
		self.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionConsumption.text = data.Stamina .. "体力";
	else
		setactive(self.mBtn_ExpeditionTaskInformation_GoExpedition_GoExpedition.gameObject,false);
		setactive(self.mBtn_ExpeditionTaskInformation_GoExpedition_CancelExpedition.gameObject,true);
		setactive(self.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionLevel.gameObject,false);
	end

	self.mText_ExpeditionTaskInformation_ExpCount.text = data.GunExp;

	for i = 1, self.mScrRect_ExpeditionTaskInformation_DropItemList_ItemList.transform.childCount-1 do
		local obj = self.mScrRect_ExpeditionTaskInformation_DropItemList_ItemList.transform:GetChild(i);
		gfdestroy(obj);
	end
	
	local reward = string.split(data.Reward, ':');
	local prefab =  UIUtils.GetGizmosPrefab(self.mPath_UICommonItemS,self);
	local instObj = instantiate(prefab);
    local itemS = UICommonItemS.New();
    itemS:InitCtrl(instObj.transform);
    itemS:SetData(tonumber(reward[1]),tonumber(reward[2]));
	UIUtils.AddListItem(instObj, self.mScrRect_ExpeditionTaskInformation_DropItemList_ItemList.transform);

	if(not NetCmdDungeonData:IsStoryUnlocked(data.UnlockStory)) then
		setactive(self.mTrans_ExpeditionTaskInformation_ExpeditionTaskLock.gameObject,true);
		local msg = TableData.GetHintById(505);
		local name = TableData.GetStoryNameById(data.UnlockStory);
		self.mText_ExpeditionTaskInformation_LockDescription.text = string_format(msg,name);
	else
		setactive(self.mTrans_ExpeditionTaskInformation_ExpeditionTaskLock.gameObject,false);
	end
	
	self.StartTaskCountDown({data,self});
end


function UIExpeditionTaskItem.StartTaskCountDown(params)
	local item = params[2];
	local itemData = params[1];

	item.mCountDownTimer = TimerSys:DelayCall(item.StartTaskCountDown, {itemData,item});
	item.mText_ExpeditionTaskInformation_GoExpedition_ExpeditionRemainderTime.text = itemData.RemainTime;
	item:SetProgress(itemData);
end

function UIExpeditionTaskItem:SetProgress(data)
	local progress = data.Progress;
	self.mImage_ExpeditionTaskInformation_ExpeditionTaskProgress.fillAmount = progress;

	if(progress >= 1 and self.mCountDownTimer ~= nil) then
		self.mCountDownTimer:Stop()
		-- TimerSys:Remove(self.mCountDownTimer);
		self.mCountDownTimer = nil;
	end
end