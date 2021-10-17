require("UI.UIBaseView")

UIRankingPanelView = class("UIRankingPanelView", UIBaseView)
UIRankingPanelView.__index = UIRankingPanelView

function UIRankingPanelView:ctor()
	self.gunItemList = {}
end

function UIRankingPanelView:__InitCtrl()
	self.mBtn_Close = self:GetButton("Btn_Close")
	self.mBtn_CommandCenter = self:GetButton("Btn_CommandCenter")

	self.mImage_Head = self:GetImage("MainPanel/PlayerRanking/BG/PlayerHead/RoundMask/Image_Head")
	self.mText_Ranking = self:GetText("MainPanel/PlayerRanking/BG/RankingPanel/Text_Rank")
	self.mText_Point = self:GetText("MainPanel/PlayerRanking/BG/OpponentDetailPanel/OpponentInfo/OpponentPointPanel/Text_OpponentPoint")
	self.mText_PlayerLevel = self:GetText("MainPanel/PlayerRanking/BG/OpponentDetailPanel/OpponentInfo/GunLV/Text_LV")
	self.mText_PlayerName = self:GetText("MainPanel/PlayerRanking/BG/OpponentDetailPanel/OpponentInfo/Text_OpponentName")
	self.mScrRect_RankingPanel = self:GetScrollRect("MainPanel/UI_Trans_ScrRect_RankingPanel")
	self.mTrans_RankingPanel = self:GetRectTransform("MainPanel/UI_Trans_ScrRect_RankingPanel")
	self.mTrans_NoData = self:GetRectTransform("MainPanel/Trans_NoDate")

	for i = 1, 4 do
		local gun = {}
		local item = self:GetRectTransform("MainPanel/PlayerRanking/BG/OpponentDetailPanel/OpponentGunList/Gun" .. i)
		gun.transDetail = item:Find("GunDetail")
		gun.transUnSet = item:Find("Unset")
		gun.gunDetail = nil
		table.insert(self.gunItemList, gun)
	end

	self.mVirtualList = UIUtils.GetVirtualList(self.mTrans_RankingPanel)
end

--@@ GF Auto Gen Block End

function UIRankingPanelView:InitCtrl(root)

	self:SetRoot(root)

	self:__InitCtrl()

end