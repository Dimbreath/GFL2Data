require("UI.UIBaseView")

UIWeaponPanelView = class("UIWeaponPanelView", UIBaseView)
UIWeaponPanelView.__index = UIWeaponPanelView

function UIWeaponPanelView:ctor()
	self.starList = {}
	self.skillList = {}
	self.weaponListContent = nil
end

function UIWeaponPanelView:__InitCtrl()
	self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
	self.mBtn_CommandCenter = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))

	self.mTrans_TabList = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/GrpLeft/GrpDetailsList/Content")

	self.mTrans_WeaponInfo = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/GrpRight/Trans_GrpDetails")
	self.mTrans_Enhance = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/GrpRight/Trans_GrpPowerUp")
	self.mTrans_Break = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/GrpRight/Trans_GrpBreak")
	self.mTrans_WeaponPartPower = self:GetRectTransform("Root/Trans_GrpWeaponPartsPowerUp_1")

	self.mTrans_WeaponPartContent = self:GetRectTransform("Root/Trans_GrpWeaponPartsDetails_2")
	self.mTrans_WeaponPartList = self:GetRectTransform("Root/Trans_GrpWeaponPartsDetails_2/Trans_GrpWeaponPartsInfo/GrpWeaponParts")
	self.mTrans_WeaponPartsInfo = self:GetRectTransform("Root/Trans_GrpWeaponPartsDetails_2/Trans_GrpWeaponPartsInfo/Trans_GrpTextInfo")

	self.mTrans_Equipped = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/Trans_GrpEquipedChr")
	self.mImage_GunIcon = self:GetImage("Root/Trans_GrpWeaponDetails_0/Trans_GrpEquipedChr/GrpHead/GrpHead/Img_ChrHead")
	self.mTrans_WeaponList = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/Trans_GrpWeaponList")

	UIWeaponPanelView.mTrans_Mask = self:GetRectTransform("Root/Trans_Mask")

	for i = 1, UIWeaponGlobal.MaxStar do
		local obj = self:GetRectTransform("UI_Trans_RightPanel/Trans_WeaponDetailPoint/UIWeaponDetailItem/Image_Trans_Stars/Trans_StarList/Star" .. i)
		table.insert(self.starList, obj)
	end

	for i = 1, 2 do
		local obj = self:GetRectTransform("UI_Trans_RightPanel/Trans_WeaponDetailPoint/UIWeaponDetailItem/Trans_SkillPanel/Trans_WeaponSkillList/UI_Trans_Skill" .. i)
		local item = self:InitSkill(obj)
		table.insert(self.skillList, item)
	end

	self.weaponListContent = UIWeaponListContent.New()
	self.weaponListContent:InitCtrl(self.mTrans_WeaponList)
end

function UIWeaponPanelView:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end

function UIWeaponPanelView:InitSkill(obj)
	if obj then
		local skill = {}
		skill.obj = obj
		skill.imageIcon = UIUtils.GetImage(obj, "Image_Icon")
		skill.txtName = UIUtils.GetText(obj, "Title/Text_Name")
		skill.txtDesc = UIUtils.GetText(obj, "Text_Desc")

		return skill
	end
end

