require("UI.UIBaseCtrl")
 
UI_Btn_MythicStage = class("UI_Btn_MythicStage", UIBaseCtrl);
UI_Btn_MythicStage.__index = UI_Btn_MythicStage
--@@ GF Auto Gen Block Begin
UI_Btn_MythicStage.mBtn_MythicStage = nil;
UI_Btn_MythicStage.mImage_MythicStage_StageImag = nil;
UI_Btn_MythicStage.mImage_MythicStage_ElementIcon = nil;
UI_Btn_MythicStage.mText_MythicStage_StageDifficulty = nil;
UI_Btn_MythicStage.mText_MythicStage_StageName = nil;
UI_Btn_MythicStage.mTrans_MythicStage_Current = nil;

function UI_Btn_MythicStage:__InitCtrl()
	
	self.mBtn_MythicStage = self:GetSelfButton();
	self.mImage_MythicStage_StageImag = self:GetImage("Image_StageImag");
	self.mImage_MythicStage_ElementIcon = self:GetImage("ElementPanel/Image_ElementIcon");
	self.mText_MythicStage_StageDifficulty = self:GetText("Text_StageDifficulty");
	self.mText_MythicStage_StageName = self:GetText("Text_StageName");
	self.mTrans_MythicStage_Current = self:GetRectTransform("Trans_Current");
end

--@@ GF Auto Gen Block End

UI_Btn_MythicStage.StagesDifficulty = { "简单", "普通", "困难" }

UI_Btn_MythicStage.root = nil;
UI_Btn_MythicStage.mStageId = nil;
UI_Btn_MythicStage.mCurStageData = nil;
UI_Btn_MythicStage.mCurMithicStageData = nil;
UI_Btn_MythicStage.mCombatLauncher = nil;

function UI_Btn_MythicStage:InitCtrl(root, stageId)
	
	self:SetRoot(root);

	self.root = root;
	self:__InitCtrl();
	UIUtils.GetButtonListener(self.mBtn_MythicStage.gameObject).onClick = function(gObj)
		self:OnClickStage()
	end
	self.mStageId = stageId;
	self.mCurStageData = TableData.listSimCombatMythicStageDatas:GetDataById(tonumber(self.mStageId));

	if self.mCurStageData ~= nil then
		self.mCurMithicStageData = TableData.listStageDatas:GetDataById(tonumber(self.mCurStageData.Stage))
	end
	self.mText_MythicStage_StageName.text = self.mCurMithicStageData.Name.str
	self.mText_MythicStage_StageDifficulty.text = UI_Btn_MythicStage.StagesDifficulty[self.mCurStageData.Difficulty]
end

function UI_Btn_MythicStage:SetSelect(isSelect)
	setactive(self.mTrans_MythicStage_Current.gameObject,isSelect)
end

