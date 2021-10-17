require("UI.UIBaseView")

UINRTPVPPanelView = class("UINRTPVPPanelView", UIBaseView);
UINRTPVPPanelView.__index = UINRTPVPPanelView

function UINRTPVPPanelView:ctor()
	self.buttonList = {}
end

function UINRTPVPPanelView:__InitCtrl()
	self.mBtn_Close = self:GetButton("Btn_Close")
	self.mBtn_CommandCenter = self:GetButton("Btn_CommandCenter")
	self.mBtn_DefenseSetting = self:GetButton("LeftPanel/Btn_DefenseSetting")
	self.mBtn_RefreshMarchList = self:GetButton("Btn_Trans_ChallengeRenewListButton")
	self.mBtn_RankList = self:GetButton("LeftPanel/PlayerGradePanel/UI_Trans_PlayerRankingDetailPanel/Btn_RankingList")
	self.mBtn_SystemInfo = self:GetButton("Btn_SystemInfo")

	self.mText_PlayerLv = self:GetText("LeftPanel/PlayerInfoPanel/PlayerLevel/Text_PlayerLevel")
	self.mImage_PlayerIcon = self:GetImage("LeftPanel/PlayerInfoPanel/PlayerHead/RoundMask/Image_Head")
	self.mImage_Rank = self:GetImage("LeftPanel/PlayerGradePanel/Image_GradeImg")
	self.mText_Point = self:GetText("LeftPanel/PlayerPointPanel/Text_Point")
	self.mText_Attack = self:GetText("LeftPanel/RatePanel/AttackWin/AttackWinningRate")
	self.mText_Defend = self:GetText("LeftPanel/RatePanel/DefenceWin/DefenseWinningRate")
	self.mText_Rank = self:GetText("LeftPanel/PlayerGradePanel/UI_Trans_PlayerRankingDetailPanel/Text_Ranking")

	self.mTrans_Challenge = self:GetRectTransform("PVPMainPanel/UI_Trans_ScrRect_ChallengePanel")
	self.mTrans_ChallengeList = self:GetRectTransform("PVPMainPanel/UI_Trans_ScrRect_ChallengePanel/Layout_ListPanel")
	self.mTrans_HistoryList = self:GetRectTransform("PVPMainPanel/UI_Trans_ScrRect_RavengePanel")
	self.mTrans_NoHistoryData = self:GetRectTransform("PVPMainPanel/UI_Trans_ScrRect_RavengePanel/Trans_NoData")

	self.mTrans_CanRefresh = self:GetRectTransform("Btn_Trans_ChallengeRenewListButton/Trans_CAN")
	self.mTrans_CanNotRefresh = self:GetRectTransform("Btn_Trans_ChallengeRenewListButton/Trans_CANT")
	self.mText_TimeDetail = self:GetText("Btn_Trans_ChallengeRenewListButton/Trans_CANT/Text_TimeDetail")
	self.mText_Cost = self:GetText("Btn_Trans_ChallengeRenewListButton/Trans_CANT/Text_Cost")

	self.mTrans_Mask = self:GetRectTransform("Trans_Mask")

	for _, type in pairs(UIPVPGlobal.ButtonType) do
		local obj = self:GetRectTransform("HLayout_ButtonList/UI_Btn_Tab" .. type)
		table.insert(self.buttonList, self:InitTypeButton(obj, type))
	end

	self.mVirtualList = UIUtils.GetVirtualList(self.mTrans_HistoryList)
end


function UINRTPVPPanelView:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end

function UINRTPVPPanelView:InitTypeButton(obj, index)
	local button = {}
	button.type = index
	button.obj = obj
	button.transSelect = UIUtils.GetRectTransform(obj, "Trans_Select")

	return button
end