require("UI.UIBaseView")

UIBattleIndexPanelView = class("UIBattleIndexPanelView", UIBaseView);
UIBattleIndexPanelView.__index = UIBattleIndexPanelView

function UIBattleIndexPanelView:__InitCtrl()
	self.mBtn_Exit = self:GetButton("Root/GrpTop/BtnBack/ComBtnBackItemV2")
	self.mBtn_CommandCenter = self:GetButton("Root/GrpTop/BtnHome/ComBtnHomeItemV2")
	self.mTrans_BattleList = self:GetRectTransform("BattleListPanel")

	self.mTrans_TextGrp = self:GetRectTransform("Root/GrpRight/Trans_GrpText")
	self.mText_CurName = self:GetText("Root/GrpRight/Trans_GrpText/GrpTop/GrpText/Text_Percent/Text_Name");
	self.mText_CurProgress = self:GetText("Root/GrpRight/Trans_GrpText/GrpTop/GrpText/Text_Percent/Text_Progress")
	self.mText_CurPercent = self:GetText("Root/GrpRight/Trans_GrpText/GrpTop/GrpText/Text_Percent")

	self.mTrans_ChapterList = self:GetRectTransform("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpPlotCombat/Trans_GrpContentList/Viewport/Content")
	self.mTrans_ChapterIndexList = self:GetRectTransform("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpPlotCombat/GrpBattleIndexList")
	self.mTrans_ChapterGrp = self:GetRectTransform("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpPlotCombat/Trans_GrpContentList")

	self.mTrans_HardList = self:GetRectTransform("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpDifficultyCombat/Trans_GrpContentList/Viewport/Content")
	self.mTrans_HardIndexList = self:GetRectTransform("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpDifficultyCombat/GrpBattleIndexList")
	self.mTrans_HardGrp = self:GetRectTransform("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpDifficultyCombat/Trans_GrpContentList")

	self.mAnim_GrpPlotCombat = self:GetAnimator("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpPlotCombat")
	self.mAnim_GrpHardCombat = self:GetAnimator("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpDifficultyCombat")
	self.mAnim_GrpSimCombat = self:GetAnimator("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpSimCombat")

	self.mTrans_SimList = self:GetRectTransform("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpSimCombat/Trans_GrpContentList/Viewport/Content")
	self.mTrans_SimIndexList = self:GetRectTransform("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpSimCombat/GrpBattleIndexList")
	self.mTrans_SimGrp = self:GetRectTransform("Root/GrpModeList/GrpModeSelList/Viewport/Content/GrpSimCombat/Trans_GrpContentList")

	self.mImage_BG = self:GetImage("Root/GrpBg/GrpRight/Img_Bg");

	-- self.mBtn_Mail = self:GetButton("Root/GrpTop/BtnMail/Btn_Mail")
	-- self.mBtn_Post = self:GetButton("Root/GrpTop/BtnPost/Btn_Post")
	--self.mBtn_Setting = self:GetButton("Root/GrpTop/BtnSetting/Btn_Setting")

	self.mTrans_Mail_RedPoint = self:GetRectTransform("Root/GrpTop/BtnMail/Btn_Mail/Trans_RedPoint")
	self.mTrans_Post_RedPoint = self:GetRectTransform("Root/GrpTop/BtnPost/Btn_Post/Trans_RedPoint")
	self.mTrans_Setting_RedPoint = self:GetRectTransform("Root/GrpTop/BtnSetting/Btn_Setting/Trans_RedPoint")
end

--@@ GF Auto Gen Block End

function UIBattleIndexPanelView:InitCtrl(root)
	self:SetRoot(root);
	self:__InitCtrl();
end

function UIBattleIndexPanelView:InitBattleTypeItem(obj, type)
	if obj then
		local item = {}
		item.type = type
		item.transChoose = UIUtils.GetRectTransform(obj, "Trans_Choose")
		item.transLocked = UIUtils.GetRectTransform(obj, "UI_Trans_Locked")
		item.btnClick    = UIUtils.GetRectTransform(obj)

		return item
	end
	return nil
end