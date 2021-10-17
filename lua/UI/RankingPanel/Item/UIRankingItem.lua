require("UI.UIBaseCtrl")

UIRankingItem = class("UIRankingItem", UIBaseCtrl)
UIRankingItem.__index = UIRankingItem

function UIRankingItem:ctor()
	UIRankingItem.super.ctor(self)
	self.data = nil
	self.gunList = {}
end

function UIRankingItem:__InitCtrl()
	self.mText_Rank = self:GetText("BG/RankingPanel/Text_Rank")
	self.mText_OpponentName = self:GetText("BG/OpponentDetailPanel/OpponentInfo/Text_OpponentName")
	self.mText_LV = self:GetText("BG/OpponentDetailPanel/OpponentInfo/GunLV/Text_LV")
	self.mText_OpponentPoint = self:GetText("BG/OpponentDetailPanel/OpponentInfo/OpponentPointPanel/Text_OpponentPoint")

	for i = 1, 4 do
		local gun = {}
		local item = self:GetRectTransform("BG/OpponentDetailPanel/OpponentGunList/Gun" .. i)
		gun.transDetail = item:Find("GunDetail")
		gun.transUnSet = item:Find("Unset")
		gun.gunDetail = nil
		table.insert(self.gunList, gun)
	end
end

--@@ GF Auto Gen Block End

function UIRankingItem:InitCtrl()
	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UIRankingItem.prefab",self))
	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIRankingItem:SetData(data, index)
	self.data = data
	if self.data then
		self.mText_Rank.text = index + 1
		self.mText_OpponentName.text = data.name
		self.mText_LV.text = data.level
		self.mText_OpponentPoint.text = data.points
		self.mText_Rank.color = self:GetColorByRank(index + 1)
		self:UpdateGunList(data.gunList)
	end
end

function UIRankingItem:UpdateGunList(gunList)
	if gunList then
		for i = 1, #self.gunList do
			local gunObj = self.gunList[i]
			setactive(gunObj.transDetail.gameObject, i <= gunList.Count)
			setactive(gunObj.transUnSet.gameObject, i > gunList.Count)
			if i <= gunList.Count then
				local data = gunList[i - 1]
				if gunObj.gunDetail == nil then
					local detail = NRTPVPGunItem.New()
					detail:InitCtrl(gunObj.transDetail.transform)
					gunObj.gunDetail = detail
				end
				gunObj.gunDetail:SetData(data)
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


