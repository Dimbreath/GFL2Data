require("UI.UIBaseView")

UIRaidPanelView = class("UIRaidPanelView", UIBaseView);
UIRaidPanelView.__index = UIRaidPanelView

--@@ GF Auto Gen Block Begin
UIRaidPanelView.mBtn_BakButton = nil;
UIRaidPanelView.mBtn_ButtonPlusOne = nil;
UIRaidPanelView.mBtn_ButtonPlusTen = nil;
UIRaidPanelView.mBtn_ButtonMinusOne = nil;
UIRaidPanelView.mBtn_ButtonMinusTen = nil;
UIRaidPanelView.mBtn_StartRaid = nil;
UIRaidPanelView.mImage_FillAft = nil;
UIRaidPanelView.mImage_FillCur = nil;
UIRaidPanelView.mText_PlusExp = nil;
UIRaidPanelView.mText_ExpBar = nil;
UIRaidPanelView.mText_LV = nil;
UIRaidPanelView.mText_LVPlus = nil;
UIRaidPanelView.mText_TimesNum = nil;
UIRaidPanelView.mText_TimeLimit = nil;
UIRaidPanelView.mText_staminaNum = nil;
UIRaidPanelView.mTrans_content = nil;
UIRaidPanelView.mTrans_ListRoot = nil;
UIRaidPanelView.mTrans_ReadyToRaid = nil;
UIRaidPanelView.mTrans_RaidStart = nil;

function UIRaidPanelView:__InitCtrl()

	self.mBtn_BakButton = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close");
	self.mBtn_Cancel = self:GetButton("Root/GrpDialog/GrpAction/BtnCancel/Btn_Cancel");
	self.mBtn_ButtonPlusOne = self:GetButton("Root/GrpDialog/GrpCenter/GrpSlider/GrpBtnIncrease/Btn_ComBtnAdd");
	--self.mBtn_ButtonPlusTen = self:GetButton("panel/raidTime/Btn_ButtonPlusTen");
	self.mBtn_ButtonMinusOne = self:GetButton("Root/GrpDialog/GrpCenter/GrpSlider/GrpBtnReduce/Btn_ComBtnReduce");
	--self.mBtn_ButtonMinusTen = self:GetButton("panel/raidTime/Btn_ButtonMinusTen");
	--self.mBtn_ButtonPlusMax = self:GetButton("panel/raidTime/Btn_ButtonPlusMax");
	self.mBtn_StartRaid = self:GetButton("Root/GrpDialog/GrpAction/BtnConfirm/Btn_Confirm");

	self.mSilderLine = self:GetSlider("Root/GrpDialog/GrpCenter/GrpSlider/GrpSlider/SliderLine/Slider_Line")

	-- self.mImage_FillAft = self:GetImage("panel/result/Trans_content/commanderExp/Back/Image_FillAft");
	-- self.mImage_FillCur = self:GetImage("panel/result/Trans_content/commanderExp/Back/Image_FillCur");
	-- self.mText_PlusExp = self:GetText("panel/result/Trans_content/commanderExp/Text_PlusExp");
	-- self.mText_ExpBar = self:GetText("panel/result/Trans_content/commanderExp/Text_ExpBar");
	-- self.mText_LV = self:GetText("panel/result/Trans_content/commanderExp/Text_LV");
	-- self.mText_LVPlus = self:GetText("panel/result/Trans_content/commanderExp/Text_LVPlus");
	self.mText_Min = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpTextMin/Text_MinNum")
	self.mText_Max = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpTextMax/Text_MaxNum")

	--self.mText_TimesNum = self:GetText("panel/raidTime/TimesNum/Text_TimesNum");
	self.mText_NowNum = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpSlider/SliderLine/Slider_Line/Handle Slide Area/Handle/Text_NowNum")
	self.mText_TimeLimit = self:GetText("Root/GrpDialog/GrpCenter/GrpTextRaidLeft/Text_Num");
	self.mText_staminaNum = self:GetText("Root/GrpDialog/GrpCenter/GrpSlider/GrpGoldConsume/Text_CostNum");
	--self.mTrans_content = self:GetRectTransform("panel/result/Trans_content");
	self.mTrans_ListRoot = self:GetRectTransform("panel/result/Trans_content/ItemList/Trans_ListRoot");
	--self.mTrans_ReadyToRaid = self:GetRectTransform("panel/result/Trans_ReadyToRaid");
	self.mTrans_RaidStart = self:GetRectTransform("panel/result/Trans_RaidStart");
end

--@@ GF Auto Gen Block End

function UIRaidPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end