require("UI.UIBaseCtrl")
require("UI.FriendPanel.UIPlayerInfoPanel")

---@class UIFriendsListItem : UIBaseCtrl
UIFriendsListItem = class("UIFriendsListItem", UIBaseCtrl)
UIFriendsListItem.__index = UIFriendsListItem
--@@ GF Auto Gen Block Begin


function UIFriendsListItem:ctor()
	UIFriendsListItem.super.ctor(self)
	self.playerInfo = nil
	self.stageList = nil
end

function UIFriendsListItem:__InitCtrl()
	self.mBtn_PlayerAvatar = self:GetSelfButton()
	self.mBtn_Talk = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/Trans_BtnChat"))
	self.mBtn_Add = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/Trans_BtnAdd"))
	self.mBtn_Refuse = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/Trans_BtnRefuse"))
	self.mBtn_Agree = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/Trans_BtnAgree"))

	self.mTrans_TextContent = self:GetRectTransform("GrpCenterText")
	self.mTrans_Talk = self:GetRectTransform("GrpAction/Trans_BtnChat")
	self.mTrans_Add = self:GetRectTransform("GrpAction/Trans_BtnAdd")
	self.mTrans_Refuse = self:GetRectTransform("GrpAction/Trans_BtnRefuse")
	self.mTrans_Agree = self:GetRectTransform("GrpAction/Trans_BtnAgree")

	self.mTrans_Avatar = self:GetRectTransform("GrpPlayerAvatar")
	self.mText_Name = self:GetText("GrpCenterText/Text_PlayerName")
	self.mImage_LineBg = self:GetImage("GrpCenterText/GrpOnlineTime/ImgBg")
	self.mText_LineTime = self:GetText("GrpCenterText/GrpOnlineTime/Text_Time")
	self.mText_Level = self:GetText("GrpCenterText/Text_Level")
	self.mText_GuildName = self:GetText("GrpCenterText/Text_GuildName")
	self.mText_Sign = self:GetText("GrpCenterText/Text_Sign")

	self.mTrans_GunStageList = self:GetRectTransform("GrpSupportChr/GrpChrInfo/GrpStage")
	self.mText_GunLevel = self:GetText("GrpSupportChr/GrpChrInfo/GrpTextLv/Text_Lv")
	self.mImage_Mental = self:GetImage("GrpSupportChr/GrpChrInfo/GrpMental/GrpLevel/Img_Level")
	self.mImage_GunAvatar = self:GetImage("GrpSupportChr/GrpChrInfo/GrpChrAvatar/Img_Avatar")
	self.mImage_GunRank = self:GetImage("GrpSupportChr/GrpChrInfo/GrpQualityLine/Img_Line")
	self.mImage_Mental = self:GetImage("GrpSupportChr/GrpChrInfo/GrpMental/GrpLevel/Img_Level")
	self.mTrans_Duty = self:GetRectTransform("GrpSupportChr/GrpChrInfo/GrpDuty")

	self.mTrans_TalkRedPoint = UIUtils.GetRectTransform(self.mBtn_Talk.gameObject, "Root/Trans_RedPoint")

	self:InstanceUIPrefab("UICommonFramework/ComRedPointItemV2.prefab", self.mTrans_TalkRedPoint, true)

	self.mAnimator = self:GetSelfRectTransform():GetComponent("Animator")

	self:InitInfo()

	UIUtils.GetButtonListener(self.mBtn_PlayerAvatar.gameObject).onClick = function()
		self:OnClickPlayerInfo()
	end

	UIUtils.GetButtonListener(self.mBtn_Add.gameObject).onClick = function()
		self:OnClickPlayerContent()
	end

	UIUtils.GetButtonListener(self.mBtn_Refuse.gameObject).onClick = function()
		self:OnClickPlayerContent(false)
	end

	UIUtils.GetButtonListener(self.mBtn_Agree.gameObject).onClick = function()
		self:OnClickPlayerContent(true)
	end

	UIUtils.GetButtonListener(self.mBtn_Talk.gameObject).onClick = function()
		self:OnClickChatButton()
	end
end

function UIFriendsListItem:InitInfo()
	if self.stageList == nil then
		self.stageList = UICommonStageItem.New(GlobalConfig.GunMaxStar)
		self.stageList:InitCtrl(self.mTrans_GunStageList)
	end

	if self.avatarInfo == nil then
		self.avatarInfo = UICommonPlayerAvatarItem.New()
		self.avatarInfo:InitCtrl(self.mTrans_Avatar)

		UIUtils.GetButtonListener(self.avatarInfo.mBtn_Avatar.gameObject).onClick = function()
			self:OnClickPlayerInfo()
		end
	end

	if self.dutyItem == nil then
		self.dutyItem = UICommonDutyItem.New()
		self.dutyItem:InitCtrl(self.mTrans_Duty)
	end
end

--@@ GF Auto Gen Block End

function UIFriendsListItem:InitCtrl()
	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComPlayerInfoItemV2.prefab", self))
	self:SetRoot(obj.transform)
	self:__InitCtrl()

	UIUtils.ForceRebuildLayout(self.mUIRoot.transform)
end

function UIFriendsListItem:SetData(data, type)
	if data then
		self.playerInfo = data
		self.type = type
		self.avatarInfo:SetData(self.playerInfo.Icon)
		self.mText_Level.text = GlobalConfig.LVText .. self.playerInfo.Level
		if self.playerInfo.Mark == nil or self.playerInfo.Mark == "" then
			self.mText_Name.text = self.playerInfo.Name
            self.mText_Name.color = ColorUtils.BlackColor
		else
			self.mText_Name.text = self.playerInfo.Mark
            self.mText_Name.color = ColorUtils.StringToColor("0168B7")
		end

		self.mText_GuildName.text = self.playerInfo.GuildName

		if self.playerInfo.PlayerMotto == nil or self.playerInfo.PlayerMotto == "" then
			self.mText_Sign.text = CS.LuaUIUtils.Unescape(TableData.GetHintById(100013))
		else
			self.mText_Sign.text =  UIUtils.BreviaryText(self.playerInfo.PlayerMotto, self.mText_Sign, UIFriendGlobal:GetTextMaxWidthByType(self.type))
		end

		self.mText_LineTime.text = self.playerInfo.IsOnline and TableData.GetHintById(100020) or self.playerInfo.GetOnlineOrOfflineTimeStr
		self.mAnimator:SetBool("Online", self.playerInfo.IsOnline)
		--self.mImage_LineBg.color = self.playerInfo.IsOnline and UIFriendGlobal.OnlineColor or UIFriendGlobal.OfflineColor
		--UIUtils.SetAlpha(self.mImage_LineBg, self.playerInfo.IsOnline and 1 or 55 / 100)

		self:UpdateAssistGun()
		self:UpdateButtonType()
		self:UpdateRedPoint()
		setactive(self.mUIRoot, true)
	else
		setactive(self.mUIRoot, false)
	end
end

function UIFriendsListItem:UpdateRedPoint()
	setactive(self.mTrans_TalkRedPoint, self.playerInfo.unreadNum > 0)
end

function UIFriendsListItem:UpdateAssistGun()
	local gunData = TableData.listGunDatas:GetDataById(self.playerInfo.AssistGunId)
	if gunData then
		local avatar = IconUtils.GetCharacterBustSprite(gunData.code)
		local dutyData = TableData.listGunDutyDatas:GetDataById(gunData.duty)
		local color = TableData.GetGlobalGun_Quality_Color2(gunData.rank)
		self.mImage_GunAvatar.sprite = avatar
		self.mImage_GunRank.color = color
		self.mText_GunLevel.text = GlobalConfig.LVText .. self.playerInfo.GunLevel
		self.stageList:SetData(self.playerInfo.GunUpgrade)
		self:SetMental(self.playerInfo.AssistGunId)
		self.dutyItem:SetData(dutyData)
	else
		gfdebug("策划说了不可能没有助战人形，看看这个ID是不是出了什么问题" .. self.playerInfo.AssistGunId)
	end
end

function UIFriendsListItem:SetMental(id)
	local rankNum = 0
	local mentalData = TableData.listMentalCircuitDatas:GetDataById(id)
	if self.playerInfo.GunMentalNode ~= nil then
		for i = 0, mentalData.rank_list.Count - 1 do
			if mentalData.rank_list[i] == self.playerInfo.GunMentalNode.Id then
				rankNum = i
			end
		end
	end

	self.mImage_Mental.sprite = IconUtils.GetMentalIcon(FacilityBarrackGlobal.RomaIconPrefix .. rankNum + 1)
end

function UIFriendsListItem:UpdateButtonType()
	setactive(self.mTrans_Add.gameObject, self.type == UIFriendGlobal.PanelTag.AddFriend)
	setactive(self.mTrans_Agree.gameObject, self.type == UIFriendGlobal.PanelTag.ApplyFriend)
	setactive(self.mTrans_Refuse.gameObject, self.type == UIFriendGlobal.PanelTag.ApplyFriend)
	setactive(self.mTrans_Talk.gameObject, self.type == UIFriendGlobal.PanelTag.FriendList)
end

function UIFriendsListItem:OnClickPlayerInfo()
	if self.type == UIFriendGlobal.PanelTag.FriendList then
		if self.playerInfo then
			if self.playerInfo.CanReqFriendInfo then
				NetCmdFriendData:SendSocialFriendSearch(tostring(self.playerInfo.UID), function ()
					self.playerInfo = NetCmdFriendData:GetFriendDataById(self.playerInfo.UID)
					self:SetData(self.playerInfo, self.type)
					UIPlayerInfoPanel.OpenByParam(self.playerInfo)
				end)
			else
				UIPlayerInfoPanel.OpenByParam(self.playerInfo)
			end
		end
	else
		if self.playerInfo then
			UIPlayerInfoPanel.OpenByParam(self.playerInfo)
		end
	end
end

function UIFriendsListItem:OnClickPlayerContent(param)
	if self.type == UIFriendGlobal.PanelTag.BlackList then
		self:SetBlackList()
	elseif self.type == UIFriendGlobal.PanelTag.AddFriend then
		self:AddFriend()
	elseif self.type == UIFriendGlobal.PanelTag.ApplyFriend then
		self:ApplyFriend(param)
	end
end

function UIFriendsListItem:AddFriend()
	if self.playerInfo then
		if NetCmdFriendData:GetFriendCount() >= TableData.GetFriendLimit() then
			UIUtils.PopupHintMessage(60020)
			return
		end
		NetCmdFriendData:SendSocialFriendApply(self.playerInfo.UID, function ()
			UIUtils.PopupPositiveHintMessage(100027)
		end)
	end
end

function UIFriendsListItem:ApplyFriend(isPass)
	if self.playerInfo then
		NetCmdFriendData:SendFriendApproveApplication(self.playerInfo.UID, isPass)
	end
end

function UIFriendsListItem:OnClickChatButton()
	setactive(self.mTrans_TalkRedPoint, false)
	UIManager.OpenUIByParam(UIDef.UIChatPanel, {self.playerInfo.UID, false})
end


