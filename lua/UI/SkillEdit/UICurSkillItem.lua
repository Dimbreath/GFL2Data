require("UI.UIBaseCtrl")

UICurSkillItem = class("UICurSkillItem", UIBaseCtrl);
UICurSkillItem.__index = UICurSkillItem

UICurSkillItem.mText_UI_CurSkillItemSkillName = nil;
UICurSkillItem.mText_UI_CurSkillItemNum = nil;
UICurSkillItem.mImage_UICurSkillItem = nil;
UICurSkillItem.mImage_UI_SkillIconBak = nil;
UICurSkillItem.mImage_UI_CurSkillItemIcon = nil;

UICurSkillItem.mCoreData = nil;

function UICurSkillItem:InitCtrl(root)

	self:SetRoot(root);

	self.mText_UI_CurSkillItemSkillName = self:GetText("UI_CurSkillItemSkillName");
	self.mText_UI_CurSkillItemNum = self:GetText("Lv/UI_CurSkillItemNum");
	self.mImage_UICurSkillItem = self:GetImage("Canvas/UISkillEditPanel (1)/CurrentSkill/SkillList/UICurSkillItem");
	self.mImage_UI_SkillIconBak = self:GetImage("UI_SkillIconBak");
	self.mImage_UI_CurSkillItemIcon = self:GetImage("UI_SkillIconBak/UI_CurSkillItemIcon");
end

function UICurSkillItem:InitData(level,coreData)
	self.mCoreData = coreData;
	self:SetSkillIcon();
	self:SetSkillName();
	self:SetSkillLevel(level);
end

function UICurSkillItem:SetSkillIcon ()
	local name = TableData.GetSkillIconByCoreId(self.mCoreData.id);
	self.mImage_UI_CurSkillItemIcon.sprite = UIUtils.GetIconSprite("Icon/Skill",name);
	
	if(self.mCoreData.type == 0) then
		self.mImage_UI_SkillIconBak.color = TableData.GetPositiveSkillIconColor();
	else
		self.mImage_UI_SkillIconBak.color = TableData.GetActiveSkillIconColor();
	end
end

function UICurSkillItem:SetSkillName ()
	self.mText_UI_CurSkillItemSkillName.text = TableData.GetSkillCoreSkillNameById(self.mCoreData.skill_group_id);
end

function UICurSkillItem:SetSkillLevel (lv)
	self.mText_UI_CurSkillItemNum.text = lv;
end