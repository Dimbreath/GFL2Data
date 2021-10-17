require("UI.UIBaseCtrl")

UICombatLauncherChallengeItem = class("UICombatLauncherChallengeItem", UIBaseCtrl);
UICombatLauncherChallengeItem.__index = UICombatLauncherChallengeItem

--- const
UICombatLauncherChallengeItem.CompleteColor = Color(253 / 255, 100 / 255, 50 / 255, 1)
UICombatLauncherChallengeItem.UnCompleteColor = Color(102 / 255, 102 / 255, 102 / 255, 1)
--- const

function UICombatLauncherChallengeItem:__InitCtrl()
	self.mTrans_Complete = self:GetRectTransform("GrpIcon/Trans_ImgOn")
	self.mText_Desc = self:GetText("Text_Description")
end

function UICombatLauncherChallengeItem:InitCtrl(parent)
	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComTargetListItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UICombatLauncherChallengeItem:SetData(id, archived)
	if id ~= nil then
		local challengeData = TableData.GetStageChallengeData(id)
		-- local alpha = archived and 1 or ColorUtils.HalfAlpha
		self.mText_Desc.text = challengeData.description.str
		setactive(self.mTrans_Complete, archived)
		-- UIUtils.SetTextAlpha(self.mText_Desc, alpha)

		setactive(self.mUIRoot, true)
	else
		setactive(self.mUIRoot, false)
	end

end