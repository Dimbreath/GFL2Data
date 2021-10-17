require("UI.UIBaseCtrl")
require("UI.Common.UICommonReceiveItem")

UIPVPGradeUpItem = class("UIPVPGradeUpItem", UIBaseCtrl);
UIPVPGradeUpItem.__index = UIPVPGradeUpItem

function UIPVPGradeUpItem:ctor()
	self.currentRank = 0
	self.lastRank = 0
	self.parent = nil
	self.receivePanel = nil
	self.mIsPop = true
end

function UIPVPGradeUpItem:__InitCtrl()
	self.mBtn_CloseButton = self:GetButton("Btn_CloseButton");
	self.mImage_RankImg = self:GetImage("GradeChangePanel/Image_RankImg")
	self.mText_GradeNameOld = self:GetText("GradeChangePanel/GradeChangePanel/Text_GradeNameOld")
	self.mText_GradeNameNew = self:GetText("GradeChangePanel/GradeChangePanel/Text_GradeNameNew")
	self.mTrans_SeasonUpdate = self:GetRectTransform("GradeChangePanel/Trans_SeasonChangedText")
end

function UIPVPGradeUpItem:InitCtrl(parent)
	self.parent = parent
	local itemPrefab = UIUtils.GetGizmosPrefab("PVP/UIPVPGradeUpItem.prefab", self)
	local instObj = instantiate(itemPrefab)

	CS.LuaUIUtils.SetParent(instObj.gameObject, parent.gameObject, true)

	self:SetRoot(instObj.transform)
	self:__InitCtrl()

	setactive(self.mUIRoot, false)
end

function UIPVPGradeUpItem:SetData(currentRank, lastRank)
	self.currentRank = currentRank    --- 玩家当前等级
	self.lastRank = lastRank
	if currentRank == lastRank then
		UINRTPVPPanel:PVPCheckQueue()
		return
	else
		local step = currentRank < lastRank and -1 or currentRank - lastRank

		local currentRankData = TableData.listNrtpvpLevelDatas:GetDataById(lastRank + step)
		local lastRankData = TableData.listNrtpvpLevelDatas:GetDataById(lastRank)
		self.mImage_RankImg.sprite = IconUtils.GetPvpRankIcon(currentRankData.icon)
		self.mText_GradeNameNew.text = currentRankData.name.str
		self.mText_GradeNameOld.text = lastRankData.name.str

		UIUtils.GetButtonListener(self.mBtn_CloseButton.gameObject).onClick = function()
			self:OnClickGradeUpClose(lastRank + step)
		end

		setactive(self.mTrans_SeasonUpdate, false)

		TimerSys:DelayCall(UIPVPGlobal.DelayShow,function(obj)
			-- UIUtils.AddCanvas(self.mUIRoot.gameObject, UIManager.GetResourceBarSortOrder() + 1)
			setactive(self.mUIRoot, true)
		end);
	end
end

function UIPVPGradeUpItem:SetDataBySettle(currentRank, lastRank)
	setactive(self.mUIRoot, false)
	self.currentRank = currentRank    --- 玩家当前等级
	self.lastRank = lastRank
	if currentRank == lastRank then
		UINRTPVPPanel:PVPCheckQueue()
		NetCmdPvPData:ClearBattleSettle()
		return
	else
		printstack("currentRank:" .. currentRank .. "     ".. "oldRank:" .. lastRank)
		local currentRankData = TableData.listNrtpvpLevelDatas:GetDataById(currentRank)
		local lastRankData = TableData.listNrtpvpLevelDatas:GetDataById(lastRank)
		self.mImage_RankImg.sprite = IconUtils.GetPvpRankIcon(currentRankData.icon)
		self.mText_GradeNameNew.text = currentRankData.name.str
		self.mText_GradeNameOld.text = lastRankData.name.str

		UIUtils.GetButtonListener(self.mBtn_CloseButton.gameObject).onClick = function()
			self:OnClickSettleClose(currentRank)
		end

		setactive(self.mTrans_SeasonUpdate, true)

		TimerSys:DelayCall(UIPVPGlobal.DelayShow,function(obj)
			-- UIUtils.AddCanvas(self.mUIRoot.gameObject, UIManager.GetResourceBarSortOrder() + 1)
			setactive(self.mUIRoot, true)
		end)
	end
end

function UIPVPGradeUpItem:OnClickSettleClose(level)
	NetCmdPvPData:ReqGetUpgradeReward(level, function (ret)
		NetCmdPvPData:ClearBattleSettle()
		setactive(self.mUIRoot, false)
		UINRTPVPPanel:PVPCheckQueue()
	end)
end

function UIPVPGradeUpItem:OnClickGradeUpClose(level)
	NetCmdPvPData:ReqGetUpgradeReward(level, function (ret)
		self:OnShowReward(ret)
	end)
end

function UIPVPGradeUpItem:OnShowReward(ret)
	if ret == CS.CMDRet.eSuccess then
		printstack("领奖成功")
		local rewardList = NetCmdPvPData.RewardList
		if rewardList and rewardList.Count > 0 then
			if self.receivePanel == nil then
				self.receivePanel = UICommonReceiveItem.New()
				self.receivePanel:InitCtrl(self.parent)
				UIUtils.GetButtonListener(self.receivePanel.mBtn_Confirm.gameObject).onClick = function()
					self:CloseRewardCallBack()
				end
			end
			self.receivePanel:SetData(rewardList)
		else
			self:CloseRewardCallBack()
		end
	end
end

function UIPVPGradeUpItem:CloseRewardCallBack()
	local step = self.currentRank < self.lastRank and -1 or self.currentRank - self.lastRank
	if self.lastRank + step ~= self.currentRank then
		self:SetData(self.currentRank, self.lastRank + step)
	else
		setactive(self.mUIRoot, false)
		UINRTPVPPanel:PVPCheckQueue()
	end
	if self.receivePanel ~= nil then
		self.receivePanel:SetData(nil)
	end
	NetCmdPvPData:SetCurrentLevel(self.lastRank + step)
end