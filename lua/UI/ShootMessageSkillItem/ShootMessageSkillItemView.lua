require("UI.UIBaseView")

ShootMessageSkillItemView = class("ShootMessageSkillItemView", UIBaseView);
ShootMessageSkillItemView.__index = ShootMessageSkillItemView

--@@ GF Auto Gen Block Begin
ShootMessageSkillItemView.mImage_SkillIcon = nil;
ShootMessageSkillItemView.mImage_SkillCDProgress = nil;
ShootMessageSkillItemView.mText_SkillCostBG = nil;
ShootMessageSkillItemView.mText_SkillName = nil;
ShootMessageSkillItemView.mText_Infromation = nil;
ShootMessageSkillItemView.mText_CDNumber = nil;
ShootMessageSkillItemView.mText_SkillCD = nil;
ShootMessageSkillItemView.mTrans_SkillLock = nil;

function ShootMessageSkillItemView:__InitCtrl()

	self.mImage_SkillIcon = self:GetImage("SkillBG/Image_SkillIcon");
	self.mImage_SkillCDProgress = self:GetImage("Trans_SkillLock/Image_SkillCDProgress");
	self.mText_SkillCostBG = self:GetText("SkillCost/Text_SkillCostBG");
	self.mText_SkillName = self:GetText("SkillInf/Text/Text_SkillName");
	self.mText_Infromation = self:GetText("SkillInf/Text/Text_Infromation");
	self.mText_CDNumber = self:GetText("SkillInf/Text/SkillCD/Text_CDNumber");
	self.mText_SkillCD = self:GetText("Trans_SkillLock/Text_SkillCD");
	self.mTrans_SkillLock = self:GetRectTransform("Trans_SkillLock");
end

--@@ GF Auto Gen Block End

function ShootMessageSkillItemView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end