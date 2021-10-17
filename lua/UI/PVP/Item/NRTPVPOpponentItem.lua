require("UI.UIBaseCtrl")
require("UI.PVP.Item.NRTPVPGunItem")

NRTPVPOpponentItem = class("NRTPVPOpponentItem", UIBaseCtrl)
NRTPVPOpponentItem.__index = NRTPVPOpponentItem

function NRTPVPOpponentItem:ctor()
	self.opponentData = nil
	self.gunList = {}
	self.opponentId = 0
	self.type = 0
	self.times = 0
	self.isCanChallenge = true
end


function NRTPVPOpponentItem:__InitCtrl()
	self.mBtn_Challenge = self:GetButton("BG/Trans_ChallengePanel/Btn_Challenge")
	self.mBtn_Revenge = self:GetButton("BG/Trans_RevengePanel/Btn_Revenge")
	self.mImage_GradeImage = self:GetImage("BG/Trans_ChallengePanel/LeftGradePanel/Image_GradeImage")
	self.mImage_CostIcon = self:GetImage("BG/Trans_ChallengePanel/Btn_Challenge/Image_CostIcon")
	self.mText_PvpCost = self:GetText("BG/Trans_ChallengePanel/Btn_Challenge/Image_CostIcon/Text_PvpCost")
	self.mText_CantChallengeText = self:GetText("BG/Trans_ChallengePanel/Btn_Challenge/Trans_CantChallenge/Text_CantChallengeText")
	self.mText_CantChallengeTextEn = self:GetText("BG/Trans_ChallengePanel/Btn_Challenge/Trans_CantChallenge/Text_CantChallengeTextEn")
	self.mText_OpponentName = self:GetText("BG/OpponentDetailPanel/OpponentInfo/Text_OpponentName")
	self.mText_OpponentPoint = self:GetText("BG/Trans_ChallengePanel/OpponentPointPanel/Text_OpponentPoint")
	self.mText_BattleTime = self:GetText("BG/Trans_RevengePanel/Btn_Revenge/TimeRecord/Text")
	self.mTrans_ChallengePanel = self:GetRectTransform("BG/Trans_ChallengePanel")
	self.mTrans_CanChallenge = self:GetRectTransform("BG/Trans_ChallengePanel/Btn_Challenge/Trans_CanChallenge")
	self.mTrans_FinishChallenge = self:GetRectTransform("BG/Trans_ChallengePanel/Btn_Challenge/Trans_FinChallenge")
	self.mTrans_CantChallenge = self:GetRectTransform("BG/Trans_ChallengePanel/Btn_Challenge/Trans_CantChallenge")
	self.mTrans_Again = self:GetRectTransform("BG/Trans_ChallengePanel/Btn_Challenge/Trans_Again")
	self.mTrans_RevengePanel = self:GetRectTransform("BG/Trans_RevengePanel")
	self.mTrans_CanRevenge = self:GetRectTransform("BG/Trans_RevengePanel/Btn_Revenge/Trans_CanRevenge")
	self.mTrans_CantRevenge = self:GetRectTransform("BG/Trans_RevengePanel/Btn_Revenge/Trans_CantRevenge")
	self.mTrans_DefenceWin = self:GetRectTransform("BG/Trans_RevengePanel/LeftMessagePanel/Trans_DefenceWin")
	self.mTrans_DefenceLose = self:GetRectTransform("BG/Trans_RevengePanel/LeftMessagePanel/Trans_DefenceLose")
	self.mTrans_AttackWin = self:GetRectTransform("BG/Trans_RevengePanel/LeftMessagePanel/Trans_AttackWin")
	self.mTrans_AttackLose = self:GetRectTransform("BG/Trans_RevengePanel/LeftMessagePanel/Trans_AttackLose")
	self.mTrans_RevengeWin = self:GetRectTransform("BG/Trans_RevengePanel/LeftMessagePanel/Trans_RevengeWin")
	self.mTrans_RevengeLose = self:GetRectTransform("BG/Trans_RevengePanel/LeftMessagePanel/Trans_RevengeLose")

	for i = 1, 4 do
		local gun = {}
		local item = self:GetRectTransform("BG/OpponentDetailPanel/OpponentGunList/Gun" .. i)
		gun.transDetail = item:Find("GunDetail")
		gun.transUnSet = item:Find("Unset")
		gun.gunDetail = nil
		table.insert(self.gunList, gun)
	end
end


function NRTPVPOpponentItem:InitCtrl(parent)
	local itemPrefab = UIUtils.GetGizmosPrefab("PVP/NRTPVPOpponentItem.prefab", self)
	local instObj = instantiate(itemPrefab)

	if parent then
		UIUtils.AddListItem(instObj.gameObject, parent.gameObject)
	end

	self:SetRoot(instObj.transform)
	self:__InitCtrl()
end

function NRTPVPOpponentItem:SetData(data, type)
	if data then
		self.opponentData = data
		self.type = type
		if type == UIPVPGlobal.PVPBattleType.Challenge then
			local rankData = TableData.listNrtpvpLevelDatas:GetDataById(data.roleInfo.maxLevel)
			local pvpCost = TableData.GlobalSystemData.PvpCost
			self.opponentId = data.opponentId
			self.times = data.times
			self.mText_OpponentName.text = data.name
			self.mText_OpponentPoint.text = data.roleInfo.point
			self.mImage_GradeImage.sprite = IconUtils.GetPvpRankIcon(rankData.icon)

			local itemIsEnough = GlobalData.GetStaminaResourceItemCount(GlobalConfig.PVPTicketId) >= pvpCost
			setactive(self.mTrans_CanChallenge, data.result == 0 and itemIsEnough)
			setactive(self.mTrans_FinishChallenge, data.result == 1)
			setactive(self.mTrans_CantChallenge, data.result ~= 1 and not itemIsEnough)
			setactive(self.mTrans_Again, data.result == 2 and itemIsEnough)
			self.isCanChallenge = data.result ~= 1
			self:UpdateGunList(data.defendGunList)
			self:SetCostItem()
		elseif type == UIPVPGlobal.PVPBattleType.Revenge then
			-- local rankData = TableData.listNrtpvpLevelDatas:GetDataById(data.opponent.roleInfo.maxLevel)
			local time = data.battleTime
			self.opponentId = data.battleId
			self.times = data.times
			self:SetResult(data.positive, data.result, data.revenged)
			self.mText_OpponentName.text = data.opponent.name
			self.mText_OpponentPoint.text = data.pointsChange
			-- self.mImage_GradeImage.sprite = IconUtils.GetPvpRankIcon(rankData.icon)
			self.mText_BattleTime.text = self:GetAboutTime(time) .. "前"
			setactive(self.mTrans_CanRevenge, not data.positive and data.revenged == 0 and not data.result)
			setactive(self.mTrans_CantRevenge, data.positive or data.revenged ~= 0 or data.result)
			self:UpdateGunList(data.opponent.defendGunList)
			self.isCanChallenge = not data.positive and not data.result and data.revenged == 0
 		end
		setactive(self.mTrans_ChallengePanel, type == UIPVPGlobal.PVPBattleType.Challenge)
		setactive(self.mTrans_RevengePanel, type == UIPVPGlobal.PVPBattleType.Revenge)
		setactive(self.mUIRoot,true)
	else
		setactive(self.mUIRoot, false)
	end
end

function NRTPVPOpponentItem:RefreshItem()
	local pvpCost = TableData.GlobalSystemData.PvpCost
	setactive(self.mTrans_CantChallenge, GlobalData.GetStaminaResourceItemCount(GlobalConfig.PVPTicketId) < pvpCost)
end

function NRTPVPOpponentItem:UpdateGunList(gunList)
	if gunList then
		for i = 1, #self.gunList do
			local gunObj = self.gunList[i]
			setactive(gunObj.transDetail.gameObject, i <= gunList.Count)
			setactive(gunObj.transUnSet.gameObject, i > gunList.Count)
			local item = nil
			if i <= gunList.Count then
				local data = gunList[i - 1]
				item = self.gunList[i]
				if item.gunDetail == nil then
					local detail = NRTPVPGunItem.New()
					detail:InitCtrl(item.transDetail.transform)
					item.gunDetail = detail
				end
				item.gunDetail:SetData(data)

				UIUtils.GetButtonListener(item.gunDetail.mBtn_OpenDetail.gameObject).onClick = function()
					self:OnClickDetail(data)
				end
			end
		end
	else
		for i = 1, #self.gunList do
			local gunObj = self.gunList[i]
			setactive(gunObj.transDetail.gameObject, false)
			setactive(gunObj.transUnSet.gameObject, true)
		end
	end
end

function NRTPVPOpponentItem:SetResult(isAttack, isWin, isRevenged)
	setactive(self.mTrans_AttackWin, isRevenged == 0 and isAttack and isWin)
	setactive(self.mTrans_AttackLose, isRevenged == 0 and isAttack and not isWin)
	setactive(self.mTrans_DefenceWin,  isRevenged == 0 and not isAttack and isWin)
	setactive(self.mTrans_DefenceLose, isRevenged == 0 and not isAttack and not isWin)
	setactive(self.mTrans_RevengeWin, isRevenged == 1)
	setactive(self.mTrans_RevengeLose, isRevenged == 2)
end

function NRTPVPOpponentItem:SetCostItem()
	local itemData = TableData.listItemDatas:GetDataById(UIPVPGlobal.NrtPvpTicket)
	self.mImage_CostIcon.sprite = IconUtils.GetItemSprite(itemData.icon)
	self.mText_PvpCost.text = TableData.GlobalSystemData.PvpCost
end

function NRTPVPOpponentItem:GetDefendLineUpDetail()
	if self.opponentData then
		return self.opponentData:GetLineUpDetail()
	end
end

function NRTPVPOpponentItem:OnClickDetail(data)
	UIUnitInfoPanel.Open(UIUnitInfoPanel.ShowType.Gun, data)
end

------------------- private -------------------
function NRTPVPOpponentItem:GetAboutTime(time)
	local strTime = ""
	local deltaTime = CGameTime:GetTimestamp() - time
	deltaTime = deltaTime <= 0 and 1 or deltaTime
	if deltaTime < 3600 then
		strTime = math.floor(deltaTime / 60)
		return strTime .. "分"
	elseif deltaTime >= 3600 and deltaTime < 86400 then
		strTime = math.floor(deltaTime / 3600)
		return strTime .. "小时"
	else
		strTime = math.floor(deltaTime / 86400)
		return strTime .. "天"
	end
	return strTime
end
