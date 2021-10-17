require("UI.UIBaseView")

UISimCombatWeeklyPanelView = class("UISimCombatWeeklyPanelView", UIBaseView)
UISimCombatWeeklyPanelView.__index = UISimCombatWeeklyPanelView

function UISimCombatWeeklyPanelView:__InitCtrl()
	self.mBtn_Return = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
	self.mBtn_Home = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))
	self.mBtn_Desc = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnDescription"))
	self.mBtn_Start = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpCenter/Trans_Opening/GrpLeft/GrpAction/BtnCancel"))

	self.mBtn_Gun = self:GetButton("Root/GrpCenter/Trans_Level/GrpTop/Content/Btn_UpChr")
	self.mBtn_Affix = self:GetButton("Root/GrpCenter/Trans_Level/GrpTop/Content/Btn_Affix")
	self.mBtn_Buff = self:GetButton("Root/GrpCenter/Trans_Level/GrpTop/Content/Btn_Buff")

	self.mImage_BossAvatar = self:GetImage("Root/GrpBg/GrpBossAvatar/GrpBoss/Img_Boss")
	self.mTrans_BossLock = self:GetRectTransform("Root/GrpBg/GrpBossAvatar/Trans_ImgLock")

	self.mItem_Close = self:InitCloseContent(self:GetRectTransform("Root/GrpCenter/Trans_NotOpen"))
	self.mItem_Open = self:InitOpenContent(self:GetRectTransform("Root/GrpCenter/Trans_Opening"))
	self.mItem_Level = self:InitLevelContent(self:GetRectTransform("Root/GrpCenter/Trans_Level"))
	
	self.mTrans_CombatLauncher = self:GetRectTransform("Root/Trans_GrpCombatLauncher")

	self.mAnimator = self:GetRootAnimator()
end

--@@ GF Auto Gen Block End

function UISimCombatWeeklyPanelView:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end

function UISimCombatWeeklyPanelView:InitCloseContent(obj)
	local content = {}
	content.gameObject = obj
	content.index = 0
	content.txtTime = UIUtils.GetText(obj, "GrpLeft/GrpResidualTime/Text_Time")
	content.txtName = UIUtils.GetText(obj, "GrpLeft/GrpIntroduce/Text_Tittle")
	content.txtDesc = UIUtils.GetText(obj, "GrpLeft/GrpIntroduce/GrpDescribe/Viewport/Content/Text_Details")
	content.transBoss = UIUtils.GetRectTransform(obj, "GrpLeft/GrpBossDetails/GrpBoss")
	content.btnStore = UIUtils.GetTempBtn(UIUtils.GetRectTransform(obj, "GrpLeft/GrpSpecialShop"))

	return content
end

function UISimCombatWeeklyPanelView:InitOpenContent(obj)
	local content = {}
	content.gameObject = obj
	content.index = 1
	content.txtName = UIUtils.GetText(obj, "GrpLeft/GrpIntroduce/Text_Tittle")
	content.txtDesc = UIUtils.GetText(obj, "GrpLeft/GrpIntroduce/GrpDescribe/Viewport/Content/Text_Details")
	content.txtTime = UIUtils.GetText(obj, "GrpLeft/GrpResidualTime/Text_Time")

	return content
end

function UISimCombatWeeklyPanelView:InitLevelContent(obj)
	local content = {}
	content.gameObject = obj
	content.index = 2
	content.txtName = UIUtils.GetText(obj, "Trans_GrpRight/Content/GrpIntroduce/Text_Tittle")
	content.txtDesc = UIUtils.GetText(obj, "Trans_GrpRight/Content/GrpIntroduce/GrpDescribe/Viewport/Content/Text_Details")
	content.txtTitle = UIUtils.GetText(obj, "Trans_GrpRight/Content/TextName")
	content.txtPoint = UIUtils.GetText(obj, "Trans_GrpRight/Content/GrpScores/Text_Num")
	content.txtTimes = UIUtils.GetText(obj, "Trans_GrpRight/Content/GrpTimes/Text_Num")
	content.transBoss = UIUtils.GetRectTransform(obj, "Trans_GrpRight/Content/GrpBossDetails/GrpBoss")
	content.txtTime = UIUtils.GetText(obj, "GrpTime/Text_Time")
	content.transStageList = UIUtils.GetRectTransform(obj, "GrpLeftList/GrpDetailsList/Viewport/Content")
	content.btnStore = UIUtils.GetTempBtn(UIUtils.GetRectTransform(obj, "Trans_GrpRight/Content/GrpAction/BtnSpecialShop"))
	content.btnRank = UIUtils.GetTempBtn(UIUtils.GetRectTransform(obj, "Trans_GrpRight/Content/GrpAction/BtnRanking"))

	return content
end