require("UI.UIBaseCtrl")

UIDailyRewardItem = class("UIDailyRewardItem", UIBaseCtrl);
UIDailyRewardItem.__index = UIDailyRewardItem
--@@ GF Auto Gen Block Begin
UIDailyRewardItem.mBtn_OpenDetail = nil;
UIDailyRewardItem.mText_ActiveCount = nil;
UIDailyRewardItem.mTrans_UnfinishedBox = nil;
UIDailyRewardItem.mTrans_FinishedBox = nil;
UIDailyRewardItem.mTrans_ReceivedBox = nil;

function UIDailyRewardItem:__InitCtrl()

	self.mBtn_OpenDetail = self:GetSelfButton();
	self.mText_ActiveCount = self:GetText("GrpText/Text_Num");
	self.mTrans_UnfinishedBox = self:GetRectTransform("GrpState/Trans_GrpLocked");
	self.mTrans_FinishedBox = self:GetRectTransform("GrpState/Trans_GrpCanUnLock");
	self.mTrans_ReceivedBox = self:GetRectTransform("GrpState/Trans_GrpUnLocked");

	setactive(self.mTrans_UnfinishedBox ,false);
	setactive(self.mTrans_FinishedBox ,false);
	setactive(self.mTrans_ReceivedBox ,false);
end

--@@ GF Auto Gen Block End

function UIDailyRewardItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIDailyRewardItem:SetData(rewardItem)
	self.mText_ActiveCount.text = tostring(rewardItem.Value);
	
end
