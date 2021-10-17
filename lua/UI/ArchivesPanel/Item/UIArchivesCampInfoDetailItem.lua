require("UI.UIBaseCtrl")

UIArchivesCampInfoDetailItem = class("UIArchivesCampInfoDetailItem", UIBaseCtrl);
UIArchivesCampInfoDetailItem.__index = UIArchivesCampInfoDetailItem
--@@ GF Auto Gen Block Begin
UIArchivesCampInfoDetailItem.mBtn_Open = nil;
UIArchivesCampInfoDetailItem.mImage_UnlockItem = nil;
UIArchivesCampInfoDetailItem.mText_DescEN = nil;
UIArchivesCampInfoDetailItem.mText_DescCHS = nil;
UIArchivesCampInfoDetailItem.mText_Name = nil;
UIArchivesCampInfoDetailItem.mText_Num = nil;
UIArchivesCampInfoDetailItem.mText_UnlockCost = nil;
UIArchivesCampInfoDetailItem.mText_LockDetail = nil;
UIArchivesCampInfoDetailItem.mTrans_Normal = nil;
UIArchivesCampInfoDetailItem.mTrans_Reward = nil;
UIArchivesCampInfoDetailItem.mTrans_UnLock = nil;

function UIArchivesCampInfoDetailItem:__InitCtrl()

	self.mBtn_Open = self:GetButton("Btn_Open");
	self.mImage_UnlockItem = self:GetImage("Trans_UnLock/Image_UnlockItem");
	self.mText_DescEN = self:GetText("Text_DescEN");
	self.mText_DescCHS = self:GetText("Text_DescCHS");
	self.mText_Name = self:GetText("NameBG/Text_Name");
	self.mText_Num = self:GetText("NumBG/Text_Num");
	self.mText_UnlockCost = self:GetText("Trans_UnLock/Image_UnlockItem/Text_UnlockCost");
	self.mText_LockDetail = self:GetText("Trans_UnLock/Text_LockDetail");
	self.mTrans_Normal = self:GetRectTransform("Btn_Open/Trans_Normal");
	self.mTrans_Reward = self:GetRectTransform("Btn_Open/Trans_Reward");
	self.mTrans_UnLock = self:GetRectTransform("Trans_UnLock");
end

--@@ GF Auto Gen Block End

function UIArchivesCampInfoDetailItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end