require("UI.UIBaseView")

---@class SimCombatMythicBuffSelPanel : UIBasePanel
SimCombatMythicBuffSelPanel = class("SimCombatMythicBuffSelPanel", UIBasePanel);
SimCombatMythicBuffSelPanel.__index = SimCombatMythicBuffSelPanel

--@@ GF Auto Gen Block Begin


SimCombatMythicBuffSelPanel.mView = nil
SimCombatMythicBuffSelPanel.mPhaseBuffs = nil;
SimCombatMythicBuffSelPanel.mChooseNum = 0;

SimCombatMythicBuffSelPanel.mTotalSelectNum = 0;

SimCombatMythicBuffSelPanel.mSelectBuff = nil;

SimCombatMythicBuffSelPanel.mIsChangeToggle = false;

function SimCombatMythicBuffSelPanel.Init(root, data)
	self = SimCombatMythicBuffSelPanel

	SimCombatMythicBuffSelPanel.mData = data

	SimCombatMythicBuffSelPanel.mView = SimCombatMythicBuffSelPanelV2View
	SimCombatMythicBuffSelPanel.mView:InitCtrl(root)
	self.mIsPop = true
	SimCombatMythicBuffSelPanel.super.SetRoot(SimCombatMythicBuffSelPanel, root)


	self:InitCtrl(root)
	self.mPhaseBuffs = data[1];
	self.mChooseNum = data[2];
	self:SetData();
	self.mSelectBuff = {}
end

function SimCombatMythicBuffSelPanel:InitCtrl(root)
	self:SetRoot(root);
	--self.mPhaseBuffs

	UIUtils.GetButtonListener(self.mView.mBtn_Confirm.gameObject).onClick = function()
		self:OnConfirm()
	end

end

function SimCombatMythicBuffSelPanel:SetData()

	clearallchild(self.mView.mContent_BuffSel.transform)
	for i = 0, self.mPhaseBuffs.Count-1 do
		local phaseBuff = self.mPhaseBuffs[i]
		local obj = instantiate(UIUtils.GetGizmosPrefab("SimCombat/SimCombatMythicBuffSelItemV2.prefab",self),self.mView.mContent_BuffSel.transform);

		local skillData = TableData.listBattleSkillDatas:GetDataById(phaseBuff)
		if skillData ~= nil then
			UIUtils.GetText(obj, "GrpCenterText/Text/Text_Content").text = skillData.Description.str;
			UIUtils.GetText(obj, "GrpBuffName/GrpText/Text_Name").text = skillData.Name.str;
			UIUtils.GetImage(obj, "GrpIcon/Img_SkillIcon").sprite = IconUtils.GetSkillIconSprite(skillData.Icon)
		end

		UIUtils.GetToggle(obj.gameObject).onValueChanged:AddListener(function(value)
			value = UIUtils.GetToggle(obj.gameObject).isOn == true and true or false
			self:ChooseBuff(obj, value, phaseBuff)
		end);
	end


	
	self.mView.mText_Name.text = string_format(TableData.GetHintDataById(30022).chars.str,self.mTotalSelectNum,self.mChooseNum)
	setactive(self.mView.mBtn_Confirm.gameObject, false)
end

function SimCombatMythicBuffSelPanel.Close()
	self.mView = nil
	self.mPhaseBuffs = nil;
	self.mChooseNum = 0;
	self.mTotalSelectNum = 0;
	self.mSelectBuff = nil;

	UIManager.CloseUI(UIDef.SimCombatMythicBuffSelPanel)
end

function SimCombatMythicBuffSelPanel:ChooseBuff(obj,value,phaseBuff)

	if self.mIsChangeToggle == true then
		self.mIsChangeToggle = false;
		return;
	end
	
	if value == true then

		if (self.mChooseNum == self.mTotalSelectNum and self.mTotalSelectNum == 1  ) then
			 --提示至少选中1个
			UIGuildGlobal:PopupHintMessage(30023) --提示至少选中
			self.mIsChangeToggle = true;
			UIUtils.GetToggle(obj.gameObject).isOn = false
			return ;
		end

		if (self.mChooseNum == self.mTotalSelectNum and self.mTotalSelectNum == 2 ) then
			UIGuildGlobal:PopupHintMessage(30023) --提示至少选中
			self.mIsChangeToggle = true;
			UIUtils.GetToggle(obj.gameObject).isOn = false;
			return ;
		end
		table.insert(self.mSelectBuff,phaseBuff)
		UIUtils.GetAnimator(obj.gameObject):SetTrigger("Pressed");
		self.mTotalSelectNum = self.mTotalSelectNum + 1;
	else
		

		for i,v in ipairs(self.mSelectBuff) do
			if v == phaseBuff then
				table.remove(self.mSelectBuff, i)
			end
		end

		
		UIUtils.GetAnimator(obj.gameObject):SetTrigger("Normal");
		self.mTotalSelectNum = self.mTotalSelectNum - 1;
	end

	local isEnough = (self.mChooseNum == self.mTotalSelectNum);
	setactive(self.mView.mBtn_Confirm.gameObject, isEnough)
	
	self.mView.mText_Name.text = string_format(TableData.GetHintDataById(30022).chars.str,self.mTotalSelectNum,self.mChooseNum)

end


function SimCombatMythicBuffSelPanel:OnConfirm()
	NetCmdSimulateBattleData:ReqSimCombatMythicBuffSelect(self.mSelectBuff, self:ReqSimCombatMythicInfo())
end

function SimCombatMythicBuffSelPanel:ReqSimCombatMythicInfo()
	self = SimCombatMythicBuffSelPanel
	self.Close();
end


