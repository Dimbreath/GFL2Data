require("UI.UIBaseCtrl")

UIChatListItem = class("UIChatListItem", UIBaseCtrl);
UIChatListItem.__index = UIChatListItem
--@@ GF Auto Gen Block Begin
UIChatListItem.mBtn_ChosenPanel_PlayerAvatar = nil;
UIChatListItem.mBtn_UnChosenPanel_PlayerAvatar = nil;
UIChatListItem.mImage_ChosenPanel_PlayerAvatar_AvatarImage = nil;
UIChatListItem.mImage_UnChosenPanel_PlayerAvatar_AvatarImage = nil;
UIChatListItem.mText_ChosenPanel_Name = nil;
UIChatListItem.mText_ChosenPanel_Level = nil;
UIChatListItem.mText_ChosenPanel_LastLoginTime = nil;
UIChatListItem.mText_UnChosenPanel_Name = nil;
UIChatListItem.mText_UnChosenPanel_Level = nil;
UIChatListItem.mText_UnChosenPanel_LastLoginTime = nil;
UIChatListItem.mTrans_ChosenPanel = nil;
UIChatListItem.mTrans_UnChosenPanel_RedPoint = nil;
UIChatListItem.userData = nil

function UIChatListItem:__InitCtrl()
	self.mBtn_ChosenPanel_PlayerAvatar = self:GetButton("UI_Trans_ChosenPanel/UI_Btn_PlayerAvatar");
	self.mBtn_UnChosenPanel_PlayerAvatar = self:GetButton("UI_Btn_UnChosenPanel/UI_Btn_PlayerAvatar");
	self.mBtn_UnChosen = self:GetButton("UI_Btn_UnChosenPanel")
	self.mImage_ChosenPanel_PlayerAvatar_AvatarImage = self:GetImage("UI_Trans_ChosenPanel/UI_Btn_PlayerAvatar/RoundMask/Image_AvatarImage");
	self.mImage_UnChosenPanel_PlayerAvatar_AvatarImage = self:GetImage("UI_Btn_UnChosenPanel/UI_Btn_PlayerAvatar/RoundMask/Image_AvatarImage");
	self.mText_ChosenPanel_Name = self:GetText("UI_Trans_ChosenPanel/Text_Name");
	self.mText_ChosenPanel_Level = self:GetText("UI_Trans_ChosenPanel/Text_Level");
	self.mText_ChosenPanel_LastLoginTime = self:GetText("UI_Trans_ChosenPanel/Text_LastLoginTime");
	self.mText_UnChosenPanel_Name = self:GetText("UI_Btn_UnChosenPanel/Text_Name");
	self.mText_UnChosenPanel_Level = self:GetText("UI_Btn_UnChosenPanel/Text_Level");
	self.mText_UnChosenPanel_LastLoginTime = self:GetText("UI_Btn_UnChosenPanel/Text_LastLoginTime");
	self.mTrans_ChosenPanel = self:GetRectTransform("UI_Trans_ChosenPanel");
	self.mTrans_UnChosenPanel = self:GetRectTransform("UI_Btn_UnChosenPanel")
	self.mTrans_UnChosenPanel_RedPoint = self:GetRectTransform("UI_Btn_UnChosenPanel/Trans_RedPoint");
	self.mTrans_UnSelectOnline = self:GetRectTransform("UI_Btn_UnChosenPanel/Trans_Online")
	self.mTrans_SelectOnline = self:GetRectTransform("UI_Trans_ChosenPanel/Trans_Online")
end

--@@ GF Auto Gen Block End

function UIChatListItem:InitCtrl()
	local obj = instantiate(UIUtils.GetGizmosPrefab("Chat/UIChatListItem.prefab",self));
	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIChatListItem:SetData(data, curUID)
	self.userData = data
	if data then
		self.mImage_ChosenPanel_PlayerAvatar_AvatarImage.sprite = UIUtils.GetIconSprite("Icon/PlayerAvatar", self.userData.Icon)
		self.mImage_UnChosenPanel_PlayerAvatar_AvatarImage.sprite = UIUtils.GetIconSprite("Icon/PlayerAvatar", self.userData.Icon)
		self.mText_UnChosenPanel_Level.text = self.userData.Level
		self.mText_ChosenPanel_Level.text = self.userData.Level
		if self.userData.Mark == nil or self.userData.Mark == "" then
			self.mText_UnChosenPanel_Name.text = self.userData.Name
			self.mText_ChosenPanel_Name.text = self.userData.Name
		else
			self.mText_UnChosenPanel_Name.text = self.userData.Mark
			self.mText_ChosenPanel_Name.text = self.userData.Mark
		end

		setactive(self.mTrans_UnSelectOnline, self.userData.IsOnline)
		setactive(self.mTrans_SelectOnline, self.userData.IsOnline)
		setactive(self.mText_UnChosenPanel_LastLoginTime.gameObject, not self.userData.IsOnline)
		setactive(self.mText_ChosenPanel_LastLoginTime.gameObject, not self.userData.IsOnline)
		if not self.userData.IsOnline then
			self.mText_UnChosenPanel_LastLoginTime.text = self.userData.LastLoginTime
			self.mText_ChosenPanel_LastLoginTime.text = self.userData.LastLoginTime
		end

		self:SetItemSelect(curUID == data.UID)
		setactive(self.mTrans_UnChosenPanel_RedPoint, NetCmdChatData:NeedRedPoint(data.UID) and curUID ~= data.UID)

		if curUID == data.UID then
			UIChatPanel.curFriendItem = self
		end
	end
end

function UIChatListItem:SetItemSelect(isSelect)
	setactive(self.mTrans_ChosenPanel, isSelect)
	setactive(self.mTrans_UnChosenPanel, not isSelect)
end