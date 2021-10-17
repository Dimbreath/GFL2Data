require("UI.UIBaseCtrl")

UICombatStageTaskItem = class("UICombatStageTaskItem", UIBaseCtrl);
UICombatStageTaskItem.__index = UICombatStageTaskItem
--@@ GF Auto Gen Block Begin
UICombatStageTaskItem.mBtn_MythicStageBuffTask_BuffInf = nil;
UICombatStageTaskItem.mBtn_MythicStageWordsTask_BuffInf = nil;
UICombatStageTaskItem.mImage_StageTaskComplete_TaskSign = nil;
UICombatStageTaskItem.mImage_StageTaskUnComplete_TaskSign = nil;
UICombatStageTaskItem.mText_StageTaskComplete_TaskCount = nil;
UICombatStageTaskItem.mText_StageTaskComplete_TaskName = nil;
UICombatStageTaskItem.mText_StageTaskUnComplete_TaskCount = nil;
UICombatStageTaskItem.mText_StageTaskUnComplete_TaskName = nil;
UICombatStageTaskItem.mText_StageGoal_TaskName = nil;
UICombatStageTaskItem.mTrans_StageTaskComplete = nil;
UICombatStageTaskItem.mTrans_StageTaskUnComplete = nil;
UICombatStageTaskItem.mTrans_StageGoal = nil;
UICombatStageTaskItem.mTrans_MythicStageBuffTask = nil;
UICombatStageTaskItem.mTrans_MythicStageWordsTask = nil;

function UICombatStageTaskItem:__InitCtrl()

	self.mBtn_MythicStageBuffTask_BuffInf = self:GetButton("UI_Trans_MythicStageBuffTask/Btn_BuffInf");
	self.mBtn_MythicStageWordsTask_BuffInf = self:GetButton("UI_Trans_MythicStageWordsTask/Btn_BuffInf");
	self.mImage_StageTaskComplete_TaskSign = self:GetImage("UI_Trans_StageTaskComplete/Image_TaskSign");
	self.mImage_StageTaskUnComplete_TaskSign = self:GetImage("UI_Trans_StageTaskUnComplete/Image_TaskSign");
	self.mText_StageTaskComplete_TaskCount = self:GetText("UI_Trans_StageTaskComplete/Text_TaskCount");
	self.mText_StageTaskComplete_TaskName = self:GetText("UI_Trans_StageTaskComplete/Text_TaskName");
	self.mText_StageTaskUnComplete_TaskCount = self:GetText("UI_Trans_StageTaskUnComplete/Text_TaskCount");
	self.mText_StageTaskUnComplete_TaskName = self:GetText("UI_Trans_StageTaskUnComplete/Text_TaskName");
	self.mText_StageGoal_TaskName = self:GetText("UI_Trans_StageGoal/Text_TaskName");
	self.mTrans_StageTaskComplete = self:GetRectTransform("UI_Trans_StageTaskComplete");
	self.mTrans_StageTaskUnComplete = self:GetRectTransform("UI_Trans_StageTaskUnComplete");
	self.mTrans_StageGoal = self:GetRectTransform("UI_Trans_StageGoal");
	self.mTrans_MythicStageBuffTask = self:GetRectTransform("UI_Trans_MythicStageBuffTask");
	self.mTrans_MythicStageWordsTask = self:GetRectTransform("UI_Trans_MythicStageWordsTask");
end

--@@ GF Auto Gen Block End

function UICombatStageTaskItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UICombatStageTaskItem:InitData(challenge_id,isComplete)
	self.challengeData = TableData.GetStageChallengeData(challenge_id);
	self.isComplete = isComplete;
	self.mText_StageTaskUnComplete_TaskName.text = self.challengeData.description.str;
	self.mText_StageTaskComplete_TaskName.text = self.challengeData.description.str;
end

function UICombatStageTaskItem:InitGoalData(str)
	setactive(self.mTrans_StageTaskComplete.gameObject, false);
	setactive(self.mTrans_StageTaskUnComplete.gameObject,false);
	setactive(self.mTrans_StageGoal,true);
	self.mText_StageGoal_TaskName.text = str.str;
end

function UICombatStageTaskItem:InitMythicBuffData(buffList,enchantmentList)
	setactive(self.mTrans_StageTaskComplete.gameObject, false);
	setactive(self.mTrans_StageTaskUnComplete.gameObject,false);
	setactive(self.mTrans_StageGoal,false);
	setactive(self.mTrans_MythicStageWordsTask,false);
	setactive(self.mTrans_MythicStageBuffTask,true);

	UIUtils.GetButtonListener(self.mBtn_MythicStageBuffTask_BuffInf.gameObject).onClick = function()
		UICombatStageTaskItem:OnBtnBuff(buffList,enchantmentList)
	end
end


function UICombatStageTaskItem:InitMythicEnchantmentData(buffList,enchantmentList)
	setactive(self.mTrans_StageTaskComplete.gameObject, false);
	setactive(self.mTrans_StageTaskUnComplete.gameObject,false);
	setactive(self.mTrans_StageGoal,false);
	
	setactive(self.mTrans_MythicStageBuffTask,false);
	setactive(self.mTrans_MythicStageWordsTask,true);
	UIUtils.GetButtonListener(self.mBtn_MythicStageWordsTask_BuffInf.gameObject).onClick = function()
		UICombatStageTaskItem:OnBtnEnchantment(buffList,enchantmentList)
	end
end


function UICombatStageTaskItem:UpdateState()
	if self.isComplete then
		self:SetComplete(true);
		return;
	end
	local type = self.challengeData.type;
	if type == 3 then
		--只带指定的一种枪种
		local arg = self.challengeData.args[0];
		local res = UICombatPreparationPanel.OnlySingleGunType(tonumber(arg))
		self:SetComplete(res);
	elseif type == 4 then
		--至少带一种指定的枪种
		local arg = self.challengeData.args[0];
		local res = UICombatPreparationPanel.IncludeGunType(tonumber(arg))
		self:SetComplete(res);
	elseif type == 5 then
		--不使用指定的枪种
		local arg = self.challengeData.args[0];
		local res = UICombatPreparationPanel.ExcludeGunType(tonumber(arg))
		self:SetComplete(res);
	elseif type == 6 then
		--出战人形数≤n
		local arg = self.challengeData.args[0];
		local res = UICombatPreparationPanel.GunFewerThan(tonumber(arg))
		self:SetComplete(res);
	else
		--其他无法预部署达成的
		self:SetComplete(false);
	end
end

function UICombatStageTaskItem:SetComplete(value)
	setactive(self.mTrans_StageTaskComplete.gameObject, value);
	setactive(self.mTrans_StageTaskUnComplete.gameObject,not value);
end

------------------------按钮响应-----------------------------------------

function UICombatStageTaskItem:OnBtnBuff(buffList,enchantmentList)
	print("    OnBtnBuff    ")
	local mythicInformationPanel = CS.LuaUtils.EnumToInt(CS.GF2.UI.enumUIPanel.UICombatMythicInformationPanel);
	local mythicData = CS.MythicInfo();
	mythicData.showType = 1;
	mythicData.buffDataList = buffList;
	mythicData.enchangmentDataList = enchantmentList;
	UIManager.OpenUIByParam(mythicInformationPanel,mythicData );
	
end


function UICombatStageTaskItem:OnBtnEnchantment(buffList,enchantmentList)
	print("    enchantmentList    ")
	local mythicInformationPanel = CS.LuaUtils.EnumToInt(CS.GF2.UI.enumUIPanel.UICombatMythicInformationPanel);
	local mythicData = CS.MythicInfo();
	mythicData.showType = 2;
	mythicData.buffDataList = buffList;
	mythicData.enchangmentDataList = enchantmentList;
	UIManager.OpenUIByParam(mythicInformationPanel, mythicData);
end