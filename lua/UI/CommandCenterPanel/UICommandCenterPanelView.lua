require("UI.UIBaseView")
---@class UICommandCenterPanelView : UIBaseView
UICommandCenterPanelView = class("UICommandCenterPanelView", UIBaseView)
UICommandCenterPanelView.__index = UICommandCenterPanelView

function UICommandCenterPanelView:ctor()
	self.systemList = {}
end

function UICommandCenterPanelView:__InitCtrl()
	self.mItem_Chat       = self:InitChat("Root/GrpChat", nil)

	self.mBtn_PlayerInfo  = self:GetButton("Root/GrpTop/GrpPlayerInfo/GrpPlayerAvatar/Btn_PlayerAvatar")
	self.mItem_PlayerInfo = self:InitAvatar("Root/GrpTop/GrpPlayerInfo/GrpPlayerAvatar", nil)
	self.mItem_DailyTask  = self:InitCommandTabBtn("Root/GrpRightTop/GrpTabSwitch/BtnQuest", SystemList.Quest)
	self.mItem_Friend     = self:InitCommandTabBtn("Root/GrpRightTop/GrpTabSwitch/BtnFriend", SystemList.Friend)
	self.mItem_Post       = self:InitCommandTabBtn("Root/GrpRightTop/GrpTabSwitch/BtnPost", SystemList.Notice)
	self.mItem_Mail       = self:InitCommandTabBtn("Root/GrpRightTop/GrpTabSwitch/BtnMail", SystemList.Mail)

	self.mItem_Archives   = self:InitCommandTabBtn("Root/GrpRightBottom/GrpTabSwitch/BtnArchives", SystemList.Archives)
	self.mItem_Guild      = self:InitCommandTabBtn("Root/GrpRightBottom/GrpTabSwitch/BtnGuild", SystemList.Guild)
	self.mItem_UAV        = self:InitCommandTabBtn("Root/GrpRightBottom/GrpTabSwitch/BtnUAV", SystemList.Uav)
	self.mItem_Repository = self:InitCommandTabBtn("Root/GrpRightBottom/GrpTabSwitch/BtnRepository", SystemList.Storage)
	self.mItem_Exchange   = self:InitCommandTabBtn("Root/GrpRightBottom/GrpTabSwitch/BtnDarkShop", SystemList.Exchangestore)

	self.mItem_Dorm       = self:InitCommandTabBtn("Root/GrpBottom/GrpTabSwitch/BtnLounge", SystemList.Restroom)
	self.mItem_PVP        = self:InitCommandTabBtn("Root/GrpBottom/GrpTabSwitch/BtnArena", SystemList.Nrtpvp)
	self.mItem_Gacha      = self:InitCommandTabBtn("Root/GrpBottom/GrpTabSwitch/BtnGashapon", SystemList.Gacha)
	self.mItem_Barrack    = self:InitCommandTabBtn("Root/GrpBottom/GrpTabSwitch/BtnBarrack", SystemList.Barrack)
	self.mItem_Battle     = self:InitCommandTabBtn("Root/GrpBottom/GrpTabSwitch/BtnCombat", SystemList.Battle)

	self.mTrans_Conversation = self:GetRectTransform("Root/Trans_GrpDialogBox")
	self.mText_Conversation = self:GetText("Root/Trans_GrpDialogBox/Panel/Text/Text_Content")

	self.mText_PlayerName = self:GetText("Root/GrpTop/GrpPlayerInfo/GrpText/Text_PlayerName")
	self.mImage_PlayerAvatar = self:GetImage("Root/GrpTop/GrpPlayerInfo/GrpPlayerAvatar/Btn_PlayerAvatar/Root/GrpPlayerAvatar/Img_Avatar")
	self.mText_PlayerLevel = self:GetText("Root/GrpTop/GrpPlayerInfo/GrpText/Text_Lv")
	self.mImage_PlayerExp = self:GetImage("Root/GrpTop/GrpPlayerInfo/GrpExpPercent/Img_Line")

	self.mTrans_Mask = self:GetRectTransform("Trans_Mask")

	self.mAnimator = self:GetRectTransform("Root"):GetComponent("Animator")
	self.mDialogAnimator = self:GetRectTransform("Root/Trans_GrpDialogBox"):GetComponent("Animator")

    --- 员工路口相关
    self.mTrans_TemporaryPanel = self:GetRectTransform("Root/Trans_TemporaryPanel")
    self.mBtn_OpenTemporaryPanel = self:GetButton("Root/Btn_OpenTemporary")
    self.mBtn_CloseTemporaryPanel = self:GetButton("Root/Trans_TemporaryPanel/UI_Btn_CloseTemporaryPanel")
    self.mBtn_StageList = self:GetButton("Root/Trans_TemporaryPanel/ButtonList/ButtonList/UI_Btn_StageList")
    self.mBtn_AVG2 = self:GetButton("Root/Trans_TemporaryPanel/ButtonList/ButtonList/UI_Btn_AVGV2")
    self.mBtn_LogOut = self:GetButton("Root/Trans_TemporaryPanel/ButtonList/ButtonList/UI_BtnLogOut")
    self.mBtn_Jump360 = self:GetButton("Root/Trans_TemporaryPanel/ButtonList/ButtonList/UI_Jump360")
    self.mBtn_VideoTest = self:GetButton("Root/Trans_TemporaryPanel/ButtonList/ButtonList/UI_VideoTest")
    self.mBtn_Achievement = self:GetButton("Root/Trans_TemporaryPanel/ButtonList/ButtonList/UI_Achievement/Btn_Achievement")


	self.parentIndicator = self:GetRectTransform("Root/GrpNormalBanner/GrpTop/GrpIndicator")
	self.parentBanner = self:GetRectTransform("Root/GrpNormalBanner/GrpBannerList/Viewport/Content")
	self.slideShow = self:GetRectTransform("Root/GrpNormalBanner/GrpBannerList"):GetComponent("SlideShowHelper")
end

function UICommandCenterPanelView:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end

function UICommandCenterPanelView:InitCommandTabBtn(parentPath, systemId)
	local parent = self:GetRectTransform(parentPath)
	if parent then
		local item = {}
		item.systemId = systemId
		item.parent = parent
		if systemId == SystemList.Battle then
			item.btn = UIUtils.GetButton(parent, "Btn_Combat")
			item.txtPercent = UIUtils.GetText(parent, "Btn_Combat/Root/GrpPercent/Text_Percent")
			item.txtLevel = UIUtils.GetText(parent, "Btn_Combat/Root/GrpName/Text_Level")
			item.txtName = UIUtils.GetText(parent, "Btn_Combat/Root/GrpName/Text_Name")
			item.transRedPoint = UIUtils.GetRectTransform(parent, "Btn_Combat/Root/Trans_RedPoint")
		else
			item.btn = UIUtils.GetTempBtn(parent)
			item.animator = item.btn.gameObject:GetComponent("Animator")
			item.transRedPoint = UIUtils.GetRectTransform(item.btn.transform, "Root/Trans_RedPoint")
		end
		table.insert(self.systemList, item)

		return item
	end
end

function UICommandCenterPanelView:InitChat(parentPath)
	local parent = self:GetRectTransform(parentPath)
	if parent then
		local item = {}
		item.parent = parent
		item.chatIsOn = false
		item.txtContent = UIUtils.GetText(parent, "Btn_Chat/Root/GrpText/Content/Text_Content")
		item.chatContent = UIUtils.GetRectTransform(parent, "Btn_Chat/Root/GrpText/Content/Text_Content")
		item.animator = UIUtils.GetRectTransform(parent):GetComponent("Animator")
		item.txtAnimator = UIUtils.GetRectTransform(parent, "Btn_Chat/Root/GrpText"):GetComponent("Animator")
		item.btn = UIUtils.GetButton(parent, "Btn_Chat")
        item.btnIcon = UIUtils.GetButton(parent, "GrpChatIcon")
		item.transRedPoint = UIUtils.GetRectTransform(parent, "GrpChatIcon/Trans_RedPoint")

		table.insert(self.systemList, item)

		return item
	end
end

function UICommandCenterPanelView:InitAvatar(parentPath)
	local parent = self:GetRectTransform(parentPath)
	if parent then
		local item = {}
		item.parent = parent
		item.btn = UIUtils.GetButton(parent, "Btn_PlayerAvatar")
		item.transRedPoint = UIUtils.GetRectTransform(parent, "Btn_PlayerAvatar/Root/Trans_RedPoint")

		table.insert(self.systemList, item)

		return item
	end
end