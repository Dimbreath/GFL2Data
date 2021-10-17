require("UI.UIBaseCtrl")

---@class UIMailLeftTabItemV2 : UIBaseCtrl
UIMailLeftTabItemV2 = class("UIMailLeftTabItemV2", UIBaseCtrl);
UIMailLeftTabItemV2.__index = UIMailLeftTabItemV2
UIMailLeftTabItemV2.mMailType = 0 --0 普通 1 奖励 2 链接
UIMailLeftTabItemV2.mIsRead = false
--@@ GF Auto Gen Block Begin
UIMailLeftTabItemV2.mImg_Nor = nil;
UIMailLeftTabItemV2.mText_Name = nil;
UIMailLeftTabItemV2.mTrans_ImgNor = nil;
UIMailLeftTabItemV2.mTrans_RedPoint = nil;

function UIMailLeftTabItemV2:__InitCtrl()

	self.mImg_Nor = self:GetImage("GrpNor/GrpBg/Img_Nor");
	self.mText_Name = self:GetText("GrpNor/GrpText/Text_Name");
	self.mTrans_ImgNor = self:GetRectTransform("GrpNor/GrpBg/Trans_ImgNor");
	self.mTrans_RedPoint = self:GetRectTransform("GrpNor/Trans_RedPoint");
end

--@@ GF Auto Gen Block End

function UIMailLeftTabItemV2:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end

function UIMailLeftTabItemV2:InitData(data)
	self.mData = data
	self.mText_Name.text = data.title

	--self.mText_Chosen_Date.text = data.mail_date
	--self.mText_UnChosen_Date.text = data.mail_date

	if(data.IsExpired == true) then
		setactive(self:GetRoot().gameObject, false)
	end

	self.mMailType = 0

	if(data.hasLink == true) then
		self.mMailType = 2
	end

	if data.hasAttachment then
		self.mMailType = 1
		self.mIsRead = self.mData.get_attachment > 0
	else
		self.mIsRead = data.read == 1
	end

	self:ClearAttachment()
end

function UIMailLeftTabItemV2:SetData(data)
	self.mData = data
end

function UIMailLeftTabItemV2:Select()
	UIUtils.SetInteractive(self.mUIRoot, false)
end

function UIMailLeftTabItemV2:UnSelect()
	UIUtils.SetInteractive(self.mUIRoot, true)
end

function UIMailLeftTabItemV2:SetRead(isRead)
	local read = self.mIsRead
	if self.mMailType == 1 then
		self.mIsRead = self.mData.get_attachment > 0
	else
		self.mIsRead = isRead
	end
	if not read and self.mIsRead then
		RedPointSystem:GetInstance():UpdateRedPointByType(RedPointConst.Mails)
	end
	self:ClearAttachment()
end

function UIMailLeftTabItemV2:ClearAttachment()
	setactive(self.mTrans_RedPoint.gameObject, not self.mIsRead)
	setactive(self.mTrans_ImgNor.gameObject, self.mData.read == 1)
end
