require("UI.UIBaseView")

---@class SimCombatMythicAffixDialog : UIBasePanel
SimCombatMythicAffixDialog = class("SimCombatMythicAffixDialog", UIBasePanel);
SimCombatMythicAffixDialog.__index = SimCombatMythicAffixDialog

--@@ GF Auto Gen Block Begin

SimCombatMythicAffixDialog.mView = nil
SimCombatMythicAffixDialog.mTier = 0;

function SimCombatMythicAffixDialog.Init(root, data)
	self = SimCombatMythicAffixDialog

	SimCombatMythicAffixDialog.mData = data
	
	SimCombatMythicAffixDialog.mView = SimCombatMythicAffixDialogView
	SimCombatMythicAffixDialog.mView:InitCtrl(root)
	self.mIsPop = true
	SimCombatMythicAffixDialog.super.SetRoot(SimCombatMythicAffixDialog, root)
	
	
	self:InitCtrl(root)
	self.mTier = data;

	self:SetData();
end

function SimCombatMythicAffixDialog:InitCtrl(root)
	self:SetRoot(root);

	UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
		self.Close()
	end

	UIUtils.GetButtonListener(self.mView.mBtn_Close1.gameObject).onClick = function()
		self.Close()
	end

end

function SimCombatMythicAffixDialog:SetData()
	--local mythicMainDatasList = TableData.listSimCombatMythicMainDatas:GetList();
	clearallchild(self.mView.mContent_Affix.transform)
	
	local mythicMainData = TableData.listSimCombatMythicMainDatas:GetDataById(self.mTier);
	if mythicMainData ~= nil then
		for i = 0, mythicMainData.Enchantment.Count - 1 do
			local skillData = TableData.listBattleSkillDatas:GetDataById(mythicMainData.Enchantment[i]);
				if skillData ~= nil then
					local obj = instantiate(UIUtils.GetGizmosPrefab("SimCombat/SimCombatMythicAffixItemV2.prefab", self));
					setparent(self.mView.mContent_Affix.transform, obj.transform);
					obj.transform:Find("GrpTextTittle/GrpTextName/Text_SkillName"):GetComponent("Text").text = skillData.Name.str;
					obj.transform:Find("Text_Description"):GetComponent("Text").text = skillData.Description.str;
					local isShow = i%2 == 0 and true or false;
					setactive(obj.transform:Find("Trans_GrpBg"),isShow)
				 
				end
		end
	end
end

function SimCombatMythicAffixDialog.Close()
	UIManager.CloseUI(UIDef.SimCombatMythicAffixDialog)
end

