require("UI.UIBaseView")
---@class UIMailPanelView : UIBaseView
UIMailPanelView = class("UIMailPanelView", UIBaseView);
UIMailPanelView.__index = UIMailPanelView

--@@ GF Auto Gen Block Begin
UIMailPanelView.mBtn_Return = nil;
UIMailPanelView.mBtn_BottomPanel_AllReceiveButton = nil;
UIMailPanelView.mBtn_DeleteButton = nil;
UIMailPanelView.mBtn_ReceiveButton = nil;
UIMailPanelView.mBtn_DeleteCancel = nil;
UIMailPanelView.mBtn_DeleteConfirm = nil;
UIMailPanelView.mText_BottomPanel_MailAmount = nil;
UIMailPanelView.mText_MainText = nil;
UIMailPanelView.mText_MailTitle = nil;
UIMailPanelView.mText_RemainingTime = nil;
UIMailPanelView.mText_ReceivedTime = nil;
UIMailPanelView.mText_LinkText = nil;
UIMailPanelView.mText_QuestionText = nil;
UIMailPanelView.mTrans_AttachmentList = nil;
UIMailPanelView.mTrans_Received = nil;
UIMailPanelView.mTrans_EmptyDetail = nil;
UIMailPanelView.mTrans_MailListPanel = nil;
UIMailPanelView.mTrans_MailList = nil;
UIMailPanelView.mTrans_DeleteConfirmPanel = nil;
UIMailPanelView.mTrans_AttachmentText = nil;

function UIMailPanelView:__InitCtrl()

	self.mBtn_Return = self:GetButton("TopPanel/Btn_Return");
	self.mBtn_CommanderCenter = self:GetButton("TopPanel/Btn_CommanderCenter")
	self.mBtn_BottomPanel_AllReceiveButton = self:GetButton("UI_BottomPanel/Btn_AllReceiveButton");
	self.mBtn_DeleteButton = self:GetButton("Trans_MailDetailPanel/Btn_DeleteButton");
	self.mBtn_ReceiveButton = self:GetButton("Trans_MailDetailPanel/Btn_ReceiveButton");
	self.mBtn_DeleteCancel = self:GetButton("Trans_DeleteConfirmPanel/DeleteConfirm/Btn_DeleteCancel");
	self.mBtn_DeleteConfirm = self:GetButton("Trans_DeleteConfirmPanel/DeleteConfirm/Btn_DeleteConfirm");
	self.mBtn_AllDeleteButton = self:GetButton("UI_BottomPanel/Btn_AllDeleteButton")
	self.mText_BottomPanel_MailAmount = self:GetText("TopPanel/Con_MailInfo/Text_MailAmount");
	self.mText_MainText = self:GetText("Trans_MailDetailPanel/MainTextPanel/Text_MainText");
	self.mText_MailTitle = self:GetText("Trans_MailDetailPanel/Text_MailTitle");
	self.mText_ReceivedTime = self:GetText("Trans_MailDetailPanel/Text_ReceivedTime");
	self.mText_LinkText = self:GetText("Trans_MailDetailPanel/Btn_InviteButton/Text_LinkText");
	self.mText_QuestionText = self:GetText("Trans_DeleteConfirmPanel/DeleteConfirm/Text_QuestionText");
	self.mTrans_MailDetailPanel = self:GetRectTransform("Trans_MailDetailPanel");
	self.mTrans_AttachmentList = self:GetRectTransform("Trans_MailDetailPanel/MainTextPanel/Attachment/Trans_AttachmentList");
	self.mTrans_Received = self:GetRectTransform("Trans_MailDetailPanel/MainTextPanel/Trans_Received");
	self.mTrans_EmptyDetail = self:GetRectTransform("Trans_EmptyDetail");
	self.mTrans_MailListPanel = self:GetRectTransform("Trans_MailListPanel");
	self.mTrans_MailList = self:GetRectTransform("Trans_MailListPanel/MailList/Trans_MailList");
	self.mTrans_DeleteConfirmPanel = self:GetRectTransform("Trans_DeleteConfirmPanel");
end

--@@ GF Auto Gen Block End

function UIMailPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end