require("UI.UIBaseCtrl")

UICombatPreparationSkillItem = class("UICombatPreparationSkillItem", UIBaseCtrl);
UICombatPreparationSkillItem.__index = UICombatPreparationSkillItem
--@@ GF Auto Gen Block Begin
UICombatPreparationSkillItem.mImage_SkillSelect = nil;
UICombatPreparationSkillItem.mImage_SkillIcon = nil;
UICombatPreparationSkillItem.mTrans_SkillSelect = nil;
UICombatPreparationSkillItem.mTrans_SkillImageBG = nil;

function UICombatPreparationSkillItem:__InitCtrl()

    self.mImage_SkillSelect = self:GetImage("Trans_Image_SkillSelect");
    self.mImage_SkillIcon = self:GetImage("Trans_SkillImageBG/Image_SkillIcon");
    self.mTrans_SkillSelect = self:GetRectTransform("Trans_Image_SkillSelect");
    self.mTrans_SkillImageBG = self:GetRectTransform("Trans_SkillImageBG");
end

--@@ GF Auto Gen Block End

function UICombatPreparationSkillItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	UIUtils.GetButtonListener(self.mImage_SkillIcon.gameObject).onClick = function()
		if self.data ~= nil then
			UICombatPreparationPanel.ShowSkillDetail(self.data,self.mTrans_SkillImageBG);
		end
	end
end

function UICombatPreparationSkillItem:InitSkill(skillData)
	print(skillData.icon);
	self.data = skillData;
	self.mImage_SkillIcon.sprite = IconUtils.GetSkillIconSprite(skillData.icon);
	self:SetSelected(false);
end

function UICombatPreparationSkillItem:SetSelected(value)
	setactive(self.mTrans_SkillSelect.gameObject, value);
end