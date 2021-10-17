require("UI.UIBaseView")

---@class SimCombatMythicBuffDialogV2 : UIBasePanel
SimCombatMythicBuffDialogV2 = class("SimCombatMythicBuffDialogV2", UIBasePanel);
SimCombatMythicBuffDialogV2.__index = SimCombatMythicBuffDialogV2

--@@ GF Auto Gen Block Begin


SimCombatMythicBuffDialogV2.mView = nil
SimCombatMythicBuffDialogV2.mBuffLevel = 0;
SimCombatMythicBuffDialogV2.mTotalBuffs = nil;
SimCombatMythicBuffDialogV2.mTotalItems = nil;

function SimCombatMythicBuffDialogV2.Init(root, data)
	self = SimCombatMythicBuffDialogV2

	SimCombatMythicBuffDialogV2.mData = data
	self.mTotalBuffs = data[1];
	self.mBuffLevel = data[2]
	self.mTotalItems = {}
	
	SimCombatMythicBuffDialogV2.mView = SimCombatMythicBuffDialogV2View
	SimCombatMythicBuffDialogV2.mView:InitCtrl(root)
	
	SimCombatMythicBuffDialogV2.super.SetRoot(SimCombatMythicBuffDialogV2, root)

	self.mIsPop = true
	self:InitCtrl(root)
	
end

function SimCombatMythicBuffDialogV2.OnInit()
	self = SimCombatMythicBuffDialogV2
	self:SetData();
end

function SimCombatMythicBuffDialogV2:InitCtrl(root)
	self:SetRoot(root);

	UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
		self.Close()
	end

	UIUtils.GetButtonListener(self.mView.mBtn_Close1.gameObject).onClick = function()
		self.Close()
	end

end

function SimCombatMythicBuffDialogV2:SetData()
	clearallchild(self.mView.mContent_Skill.transform);

    self.mView.mText_SkillName.text = ""
    self.mView.mText_Description.text = ""
    
	if NetCmdSimulateBattleData:GetCombatMythicTierFinishNum() == 0 then  --未开始
		--setactive(self.mView.mTrans_BuffListPanel_EmptyDetail.gameObject, true)
		setactive(self.mView.mTrans_Center.gameObject, false)
		setactive(self.mView.mTrans_GrpEmpty.gameObject, true)
		return;
	end

	if self.mTotalBuffs.Count == 0 then
		setactive(self.mView.mTrans_Center.gameObject, false)
		setactive(self.mView.mTrans_GrpEmpty.gameObject, true)
	else
		setactive(self.mView.mTrans_Center.gameObject, true)
		setactive(self.mView.mTrans_GrpEmpty.gameObject, false)
	end
	
	for i = 0, self.mTotalBuffs.Count - 1 do

		local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComBtnSkillItemV2.prefab",self));
		obj.transform:SetParent(self.mView.mContent_Skill.transform,false);
		
		local mythicBuffItem = UISkillIconCtrl.New();
	
		mythicBuffItem:InitCtrl(obj.transform,self.mView.mContent_Skill.transform);
		local curBuff = self.mTotalBuffs[i]

		local skillData = TableData.listBattleSkillDatas:GetDataById(curBuff)
		if skillData ~= nil then
			mythicBuffItem:SetData(skillData);

			UIUtils.GetButtonListener(mythicBuffItem.m_RootBtn.gameObject).onClick = function(obj)
				self:OnClickItem(mythicBuffItem, skillData)
			end

			if i == 0 then
				self:OnClickItem(mythicBuffItem, skillData)
			end
		end
			
		table.insert(self.mTotalItems,mythicBuffItem)
		
		--mythicBuffItem:SetData(curBuff,curBuffLevel);

	end
end

function SimCombatMythicBuffDialogV2:OnClickItem(mythicBuffItem,skillData)

	for _, item in ipairs(self.mTotalItems) do
		item:SetSelected(false)
	end
	
	mythicBuffItem:SetSelected(true)
	self.mView.mText_SkillName.text = skillData.name.str;
	self.mView.mText_Description.text = skillData.description.str;
end

function SimCombatMythicBuffDialogV2.Close()
	UIManager.CloseUI(UIDef.SimCombatMythicBuffDialogV2)
end

