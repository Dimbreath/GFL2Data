require("UI.UIBasePanel")

---@class UICommanderInfoPanelV2 : UIBasePanel
UICommanderInfoPanelV2 = class("UICommanderInfoPanelV2", UIBasePanel)
UICommanderInfoPanelV2.__index = UICommanderInfoPanelV2
---@type UICommanderInfoPanelV2View
UICommanderInfoPanelV2.mView = nil
UICommanderInfoPanelV2.mData = nil
UICommanderInfoPanelV2.curTab = 0
UICommanderInfoPanelV2.curPanel = 0
UICommanderInfoPanelV2.tabList = {}

UICommanderInfoPanelV2.playerInfoItem = nil

UICommanderInfoPanelV2.TAB = {
	PlayerInfo = 1,
	Achievement = 2,
	Settings = 3
}

function UICommanderInfoPanelV2:ctor()
	UICommanderInfoPanelV2.super.ctor(self)
end

function UICommanderInfoPanelV2.Open()
	UIManager.OpenUI(UIDef.UICommanderInfoPanel)
end

function UICommanderInfoPanelV2.Close()
	UICommanderInfoPanelV2.curTab = 0
	UIManager.CloseUI(UIDef.UICommanderInfoPanel)
end

function UICommanderInfoPanelV2.Init(root,data)
	self = UICommanderInfoPanelV2
	UICommanderInfoPanelV2.super.SetRoot(UICommanderInfoPanelV2, root)
	--self.mIsPop = true
	self.mData = data
end

function UICommanderInfoPanelV2.OnInit()
	self = UICommanderInfoPanelV2

	self.mView = UICommanderInfoPanelV2View.New()
	self.mView:InitCtrl(self.mUIRoot)

	UIUtils.GetListener(self.mView.mBtn_Back.gameObject).onClick = function()
		UICommanderInfoPanelV2:OnClose();
	end

	UIUtils.GetListener(self.mView.mBtn_Home.gameObject).onClick = function()
		CS.BattlePerformSetting.RefreshGraphicSetting();
		UIManager.JumpToMainPanel();
	end

	UIUtils.GetListener(self.mView.mBtn_ExitGame.gameObject).onClick = function()
		CS.LuaUtils.ExitGame();
	end

	self:InitTabButton()
	self:OnClickTab(UICommanderInfoPanelV2.TAB.PlayerInfo)
end

function UICommanderInfoPanelV2.OnShow()
	self = UICommanderInfoPanelV2
	local lastTab = self.curTab
	self.curTab = 0
	self:OnClickTab(lastTab)
end

function UICommanderInfoPanelV2.OnRelease()
	self = UICommanderInfoPanelV2
	MessageSys:RemoveListener(CS.GF2.Message.UIEvent.RefreshSgin, function()
			UICommanderInfoPanelV2:RefreshPanel()
		end)


	UICommanderInfoPanelV2.mData = nil
	UICommanderInfoPanelV2.achievementPanel = nil
	UICommanderInfoPanelV2.settingPanel = nil
	UICommanderInfoPanelV2.playerInfoItem = nil
end


function UICommanderInfoPanelV2:OnClose()
	CS.BattlePerformSetting.RefreshGraphicSetting();
	self:Close();
end

function UICommanderInfoPanelV2:InitTabButton()
	local leftTabPrefab = UIUtils.GetGizmosPrefab("UICommonFramework/ComLeftTab1ItemV2.prefab", self)
	for id = 1, 3 do
		---@type UICommonLeftTabItemV2
		local item = UICommonLeftTabItemV2.New()
		local obj = instantiate(leftTabPrefab, self.mView.mContent_Tab.transform)
		item:InitCtrl(obj.transform)
		item.tagId = id
		item.mText_Name.text = TableData.GetHintById(900015 + id)

		--item:UpdateSystemLock()
		UIUtils.GetButtonListener(item.mBtn.gameObject).onClick = function()
			self:OnClickTab(item.tagId)
		end
		self.tabList[id] = item
		if id == self.TAB.Achievement then
			local unlocked = AccountNetCmdHandler:CheckSystemIsUnLock(CS.GF2.Data.SystemList.Achievement);
			setactive(item.mTrans_Locked, not unlocked)
			setactive(item.mTrans_RedPoint, unlocked and NetCmdAchieveData:UpdateAchievementRedPoint() > 0)
		end
	end
end

function UICommanderInfoPanelV2:OnClickTab(id)
	if id == 2 and TipsManager.NeedLockTips(CS.GF2.Data.SystemList.Achievement) then
		return
	end

	if self.curTab == id or id == nil or id <= 0 then
		return
	end
	if self.curTab > 0 then
		local lastTab = self.tabList[self.curTab]
		lastTab:SetItemState(false)
	end
	---@type UICommonLeftTabItemV2
	local curTabItem = self.tabList[id]
	curTabItem:SetItemState(true)
	self.curTab = id

	setactive(self.mView.mTrans_0, self.curTab == self.TAB.PlayerInfo)
	setactive(self.mView.mTrans_1, self.curTab == self.TAB.Achievement)
	setactive(self.mView.mTrans_2, self.curTab == self.TAB.Settings)
	self.mView.animator:SetInteger("SwitchTab", self.curTab - 1)
	self:UpdatePanelByType(id)
	for id = 1, 3 do
		if id == self.TAB.Achievement then
			local unlocked = AccountNetCmdHandler:CheckSystemIsUnLock(CS.GF2.Data.SystemList.Achievement);
			setactive(self.tabList[id].mTrans_Locked, not unlocked)
			setactive(self.tabList[id].mTrans_RedPoint, unlocked and NetCmdAchieveData:UpdateAchievementRedPoint() > 0)
		end
	end
end

function UICommanderInfoPanelV2:UpdatePanelByType()
	if self.curTab == self.TAB.Achievement then
		if self.achievementPanel == nil then
			self.achievementPanel = UIAchievementSubPanel.New(self.mView.mTrans_1)
		else
			self.achievementPanel.Show()
		end
	elseif self.curTab == self.TAB.PlayerInfo then
		if self.playerInfoItem == nil then
			self.playerInfoItem = UIPlayerInfoItem.New()
			self.playerInfoItem:InitCtrl(self.mView.mTrans_0)
		end
		self.playerInfoItem:SetData(AccountNetCmdHandler:GetRoleInfoData())
	elseif self.curTab == self.TAB.Settings then
		if self.settingPanel == nil then
			self.settingPanel = UISettingSubPanel.New(self.mView.mTrans_2)
		else
			self.settingPanel.Show()
		end
	end
end

 
