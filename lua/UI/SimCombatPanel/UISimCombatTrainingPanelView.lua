require("UI.UIBaseView")

UISimCombatTrainingPanelView = class("UISimCombatTrainingPanelView", UIBaseView);
UISimCombatTrainingPanelView.__index = UISimCombatTrainingPanelView

function UISimCombatTrainingPanelView:__InitCtrl()
	self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
	self.mBtn_CommanderCenter = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))
	self.mBtn_Info = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpRight/GrpDetails/GrpChallenges/GrpDescription"))
	self.mBtn_Return = self:GetButton("Root/GrpLeft/GrpReturn/Btn_Return")
	
	self.Scroll_TrainingList = self:GetRectTransform("Root/GrpLeft/GrpTrainingList")
	self.mTrans_TrainingList = self:GetRectTransform("Root/GrpLeft/GrpTrainingList/Viewport/Content")
	self.mTrans_RunesType = self:GetRectTransform("Con_EquipType")
	self.mTrans_TraningInfo = self:GetRectTransform("Root/GrpRight")
	self.mTrans_CombatLauncher = self:GetRectTransform("Root/Trans_CombatLauncher")

	self.mText_Title = self:GetText("Root/GrpLeft/GrpBg/TextName")
	self.mText_CurrentLevel = self:GetText("Root/GrpRight/GrpDetails/GrpProgress/Text_Now")
	self.mText_TotalLevel = self:GetText("Root/GrpRight/GrpDetails/GrpProgress/Text_Total")
	self.mTrans_RewardItem = self:GetRectTransform("Root/GrpRight/GrpDetails/GrpItem/ComItemV2")
	self.mTrans_Mask = self:GetRectTransform("Trans_Mask")

	self.mVirtualList = UIUtils.GetVirtualList(self.Scroll_TrainingList.transform)
end

--@@ GF Auto Gen Block End

function UISimCombatTrainingPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	self.mTrans_TopCurrency = self:GetRectTransform("Root/GrpTop/GrpCurrency")
end