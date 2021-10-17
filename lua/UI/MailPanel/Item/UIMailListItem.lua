require("UI.UIBaseCtrl")

UIMailListItem = class("UIMailListItem", UIBaseCtrl)
UIMailListItem.__index = UIMailListItem
UIMailListItem.mMailType = 0 --0 普通 1 奖励 2 链接
UIMailListItem.mIsRead = false
UIMailListItem.Title = nil
--@@ GF Auto Gen Block Begin
UIMailListItem.mImage_Chosen_MailState = nil
UIMailListItem.mImage_UnChosen_MailState = nil
UIMailListItem.mText_Chosen_Title = nil
UIMailListItem.mText_Chosen_Date = nil
UIMailListItem.mText_UnChosen_Title = nil
UIMailListItem.mText_UnChosen_Date = nil
UIMailListItem.mTrans_Chosen = nil
UIMailListItem.mTrans_UnChosen = nil
UIMailListItem.mTrans_UnChosen_ImageNew = nil

function UIMailListItem:__InitCtrl()
	self.mText_Chosen_Title = self:GetText("UI_Trans_Chosen/Text_Title")
	self.mText_Chosen_Date = self:GetText("UI_Trans_Chosen/Text_Date")
	self.mText_UnChosen_Title = self:GetText("UI_Trans_UnChosen/Text_Title")
	self.mText_UnChosen_Date = self:GetText("UI_Trans_UnChosen/Text_Date")
	self.mTrans_Chosen = self:GetRectTransform("UI_Trans_Chosen")
	self.mTrans_UnChosen = self:GetRectTransform("UI_Trans_UnChosen")
	self.mTrans_UnChosen_ImageNew = self:GetRectTransform("UI_Trans_UnChosen/Trans_ImageNew")
end

--@@ GF Auto Gen Block End

function UIMailListItem:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end

function UIMailListItem:InitData(data)
	self.mData = data
	self.mText_Chosen_Title.text = data.title
	self.mText_UnChosen_Title.text = data.title
	self.title = data.title

	self.mText_Chosen_Date.text = data.mail_date
	self.mText_UnChosen_Date.text = data.mail_date

	self.mMailType = 0

	if(data.hasLink == true) then
		self.mMailType = 2
	end

	if(data.get_attachment == 0 and data.hasAttachment) then
		self.mMailType = 1
	end

	self.mIsRead = data.read == 1

	if(data.IsExpired == true) then
		setactive(self:GetRoot().gameObject, false)
	end

	self:ClearAttachment()
end

function UIMailListItem:SetData(data)
	self.mData = data
end

function UIMailListItem:Select()
    setactive(self.mTrans_Chosen.gameObject, true)
    setactive(self.mTrans_UnChosen.gameObject, false)
end

function UIMailListItem:UnSelect()
	setactive(self.mTrans_Chosen.gameObject, false)
    setactive(self.mTrans_UnChosen.gameObject, true)
end

function UIMailListItem:SetRead(isRead)
	self.mIsRead = isRead
	self:ClearAttachment()
end

function UIMailListItem:ClearAttachment()
	setactive(self.mTrans_UnChosen_ImageNew.gameObject, not self.mIsRead)
end
