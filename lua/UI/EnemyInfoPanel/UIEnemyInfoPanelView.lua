require("UI.UIBaseView")

UIEnemyInfoPanelView = class("UIEnemyInfoPanelView", UIBaseView);
UIEnemyInfoPanelView.__index = UIEnemyInfoPanelView

--@@ GF Auto Gen Block Begin
UIEnemyInfoPanelView.mBtn_ExitMask = nil;
UIEnemyInfoPanelView.mImage_BasicInfo_HeadPic = nil;
UIEnemyInfoPanelView.mImage_BuffDetailPanel_Icon = nil;
UIEnemyInfoPanelView.mImage_SkillDetailPanel_Icon = nil;
UIEnemyInfoPanelView.mImage_SkillDetailPanel_Shape = nil;
UIEnemyInfoPanelView.mText_BasicInfo_Name = nil;
UIEnemyInfoPanelView.mText_BasicInfo_Level = nil;
UIEnemyInfoPanelView.mText_BasicInfo_AttackRange = nil;
UIEnemyInfoPanelView.mText_BasicInfo_AP = nil;
UIEnemyInfoPanelView.mText_BuffDetailPanel_Name = nil;
UIEnemyInfoPanelView.mText_BuffDetailPanel_Description = nil;
UIEnemyInfoPanelView.mText_BuffDetailPanel_Tier = nil;
UIEnemyInfoPanelView.mText_SkillDetailPanel_Name = nil;
UIEnemyInfoPanelView.mText_SkillDetailPanel_Description = nil;
UIEnemyInfoPanelView.mText_SkillDetailPanel_Type = nil;
UIEnemyInfoPanelView.mText_SkillDetailPanel_Level = nil;
UIEnemyInfoPanelView.mText_SkillDetailPanel_Range = nil;
UIEnemyInfoPanelView.mText_SkillDetailPanel_ShapeRange = nil;
UIEnemyInfoPanelView.mText_SkillDetailPanel_Colddown = nil;
UIEnemyInfoPanelView.mTrans_BuffList_BuffItemLayout = nil;
UIEnemyInfoPanelView.mTrans_BuffDetailPanel = nil;
UIEnemyInfoPanelView.mTrans_SkillList_SKillItemLayout = nil;
UIEnemyInfoPanelView.mTrans_SkillDetailPanel = nil;
UIEnemyInfoPanelView.mTrans_SkillDetailPanel_BasicInfo = nil;

function UIEnemyInfoPanelView:__InitCtrl()

	self.mBtn_ExitMask = self:GetButton("Btn_ExitMask");
	self.mImage_BasicInfo_HeadPic = self:GetImage("InfoPanel/UI_BasicInfo/Image/Image_HeadPic");
	self.mImage_BuffDetailPanel_Icon = self:GetImage("InfoPanel/UI_Trans_BuffDetailPanel/Icon/Image_Icon");
	self.mImage_SkillDetailPanel_Icon = self:GetImage("InfoPanel/UI_Trans_SkillDetailPanel/Icon/Image_Icon");
	self.mImage_SkillDetailPanel_Shape = self:GetImage("InfoPanel/UI_Trans_SkillDetailPanel/Trans_BasicInfo/Image_Shape");
	self.mText_BasicInfo_Name = self:GetText("InfoPanel/UI_BasicInfo/Text_Name");
	self.mText_BasicInfo_Level = self:GetText("InfoPanel/UI_BasicInfo/Text_Level");
	self.mText_BasicInfo_AttackRange = self:GetText("InfoPanel/UI_BasicInfo/Text_AttackRange");
	self.mText_BasicInfo_AP = self:GetText("InfoPanel/UI_BasicInfo/Text_AP");
	self.mText_BuffDetailPanel_Name = self:GetText("InfoPanel/UI_Trans_BuffDetailPanel/Text_Name");
	self.mText_BuffDetailPanel_Description = self:GetText("InfoPanel/UI_Trans_BuffDetailPanel/Text_Description");
	self.mText_BuffDetailPanel_Tier = self:GetText("InfoPanel/UI_Trans_BuffDetailPanel/Text_Tier");
	self.mText_SkillDetailPanel_Name = self:GetText("InfoPanel/UI_Trans_SkillDetailPanel/Text_Name");
	self.mText_SkillDetailPanel_Description = self:GetText("InfoPanel/UI_Trans_SkillDetailPanel/Text_Description");
	self.mText_SkillDetailPanel_Type = self:GetText("InfoPanel/UI_Trans_SkillDetailPanel/Trans_BasicInfo/Text_Type");
	self.mText_SkillDetailPanel_Level = self:GetText("InfoPanel/UI_Trans_SkillDetailPanel/Trans_BasicInfo/Level/Text_Level");
	self.mText_SkillDetailPanel_Range = self:GetText("InfoPanel/UI_Trans_SkillDetailPanel/Trans_BasicInfo/Text_Range");
	self.mText_SkillDetailPanel_ShapeRange = self:GetText("InfoPanel/UI_Trans_SkillDetailPanel/Trans_BasicInfo/Text_ShapeRange");
	self.mText_SkillDetailPanel_Colddown = self:GetText("InfoPanel/UI_Trans_SkillDetailPanel/Trans_BasicInfo/Text_Colddown");
	self.mTrans_BuffList_BuffItemLayout = self:GetRectTransform("InfoPanel/UI_BuffList/BuffList/Trans_BuffItemLayout");
	self.mTrans_BuffDetailPanel = self:GetRectTransform("InfoPanel/UI_Trans_BuffDetailPanel");
	self.mTrans_SkillList_SKillItemLayout = self:GetRectTransform("InfoPanel/UI_SkillList/Trans_SKillItemLayout");
	self.mTrans_SkillDetailPanel = self:GetRectTransform("InfoPanel/UI_Trans_SkillDetailPanel");
	self.mTrans_SkillDetailPanel_BasicInfo = self:GetRectTransform("InfoPanel/UI_Trans_SkillDetailPanel/Trans_BasicInfo");
end

--@@ GF Auto Gen Block End

function UIEnemyInfoPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();



end