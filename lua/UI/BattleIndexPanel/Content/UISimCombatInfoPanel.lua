require("UI.UIBaseCtrl")
require("UI.BattleIndexPanel.Item.UISimCombatItem")

UISimCombatInfoPanel = class("UISimCombatInfoPanel", UIBaseCtrl)
UISimCombatInfoPanel.__index = UISimCombatInfoPanel
--@@ GF Auto Gen Block Begin
UISimCombatInfoPanel.mTrans_StageList = nil

UISimCombatInfoPanel.PrefabPath = "BattleIndex/UISimCombatListItem.prefab"
UISimCombatInfoPanel.simCombatList = {}

function UISimCombatInfoPanel:__InitCtrl()
	self.mTrans_StageList = self:GetRectTransform("StageTypeListPanel/StageTypeList/Trans_StageList")
end

--@@ GF Auto Gen Block End

function UISimCombatInfoPanel:InitCtrl(parent)
	local instObj = instantiate(UIUtils.GetGizmosPrefab(self.PrefabPath, self))

	CS.LuaUIUtils.SetParent(instObj.gameObject, parent.gameObject, true)

	self:SetRoot(instObj.transform)
	self:__InitCtrl()
end

function UISimCombatInfoPanel:OnEnable(enable)
	setactive(self.mUIRoot, enable)
end

function UISimCombatInfoPanel:OnHide()

end

function UISimCombatInfoPanel:OnShow()

end

function UISimCombatInfoPanel:OnRelease()
	UISimCombatInfoPanel.simCombatList = {}
end

function UISimCombatInfoPanel:OnClose()

end

function UISimCombatInfoPanel:SetData()
	for _, item in ipairs(self.simCombatList) do
		item:SetData(nil)
	end

	local dataList = TableData.listSimCombatEntranceDatas

	local item = nil
	for i = 0, dataList.Count - 1 do
		if i + 1 <= #self.simCombatList then
			item = self.simCombatList[i + 1]
		else
			item = UISimCombatItem.New()
			item:InitCtrl(self.mTrans_StageList.transform)
			table.insert(self.simCombatList, item)
		end
		local data = dataList[i]
		item:SetData(data)
		local type = item.mType
		UIUtils.GetButtonListener(item.mTrans_SimCombat.gameObject).onClick = function()
			if data.nocomplete == 1 then
				return
			end
			self:OnClickSimCombat(data.id, type)
		end
	end

	self:UpdateUnLockInfo()
end

function UISimCombatInfoPanel:OnClickSimCombat(simType, unlockType)
	if TipsManager.NeedLockTips(unlockType) then
		return
	end
	if simType == 1 then
		UIManager.OpenUI(UIDef.UISimCombatEquipPanel)
	elseif simType == 2 then
		UIManager.OpenUI(UIDef.UISimCombatRunesPanel)
	elseif simType == 3 then
		UIManager.OpenUI(UIDef.SimTrainingListPanel)
	elseif simType == 4 then
		UIManager.OpenUI(UIDef.UISimCombatWeeklyPanel)
	elseif simType == 5 then
		UIManager.OpenUI(UIDef.UISimCombatMythicPanel)
	end
end

function UISimCombatInfoPanel:UpdateUnLockInfo()
	for _, item in ipairs(self.simCombatList) do
		item:CheckSimCombatIsUnLock()
	end
end

function UISimCombatInfoPanel:UpdateRedPoint()

end


