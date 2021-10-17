require("UI.UIBaseView")

---@class UICommonAffixDisplayPanel : UIBasePanel
UICommonAffixDisplayPanel = class("UICommonAffixDisplayPanel", UIBasePanel)
UICommonAffixDisplayPanel.__index = UICommonAffixDisplayPanel

UICommonAffixDisplayPanel.mView = nil
UICommonAffixDisplayPanel.affixList = nil

function UICommonAffixDisplayPanel.Init(root, data)
	self = UICommonAffixDisplayPanel
	UICommonAffixDisplayPanel.super.SetRoot(UICommonAffixDisplayPanel, root)

	UICommonAffixDisplayPanel.mView = UICommonAffixDisplayPanelView.New()
	UICommonAffixDisplayPanel.mView:InitCtrl(root)
	self.mIsPop = true
	self.affixList = data
end

function UICommonAffixDisplayPanel.OnInit()
	self = UICommonAffixDisplayPanel

	UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
		UICommonAffixDisplayPanel.Close()
	end

	UIUtils.GetButtonListener(self.mView.mBtn_Close1.gameObject).onClick = function()
		UICommonAffixDisplayPanel.Close()
	end

	self:UpdatePanel()
end

function UICommonAffixDisplayPanel:UpdatePanel()
	for i = 0, self.affixList.Count - 1 do
		local skillData = TableData.listBattleSkillDatas:GetDataById(self.affixList[i])
		if skillData ~= nil then
			local obj = self:InstanceUIPrefab("SimCombat/SimCombatMythicAffixItemV2.prefab", self.mView.mContent_Affix, true)
			local txtName = UIUtils.GetText(obj, "GrpTextTittle/GrpTextName/Text_SkillName")
			local txtDesc = UIUtils.GetText(obj, "Text_Description")
			local transBg = UIUtils.GetRectTransform(obj, "Trans_GrpBg")
			txtName.text = skillData.name.str
			txtDesc.text = skillData.description.str
			setactive(transBg, i % 2 ==  0)
		end
	end
end

function UICommonAffixDisplayPanel.Close()
	UIManager.CloseUI(UIDef.UICommonAffixDisplayPanel)
end

