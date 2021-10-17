require("UI.UIBaseView")

UIFacilityLvUpPanelView = class("UIFacilityLvUpPanelView", UIBaseView);
UIFacilityLvUpPanelView.__index = UIFacilityLvUpPanelView

UIFacilityLvUpPanelView.mTrans_FacilityLvUpTree = nil;


--@@ GF Auto Gen Block Begin
UIFacilityLvUpPanelView.mBtn_Return = nil;
UIFacilityLvUpPanelView.mBtn_DetailReturn = nil;
UIFacilityLvUpPanelView.mBtn_LvUpButton = nil;
UIFacilityLvUpPanelView.mBtn_LvUpButtonFast = nil;
UIFacilityLvUpPanelView.mImage_Icon = nil;
UIFacilityLvUpPanelView.mImage_arrow = nil;
UIFacilityLvUpPanelView.mImage_upgradeFill = nil;
UIFacilityLvUpPanelView.mText_LvUpDetailName = nil;
UIFacilityLvUpPanelView.mText_FacilityText = nil;
UIFacilityLvUpPanelView.mText_NumBe = nil;
UIFacilityLvUpPanelView.mText_NumAf = nil;
UIFacilityLvUpPanelView.mText_upgradingTime = nil;
UIFacilityLvUpPanelView.mText_TimeReqNumer = nil;
UIFacilityLvUpPanelView.mText_GemReqNumer = nil;
UIFacilityLvUpPanelView.mTrans_LevelUpDetail = nil;
UIFacilityLvUpPanelView.mTrans_LvUpList = nil;
UIFacilityLvUpPanelView.mTrans_FacilityLv = nil;
UIFacilityLvUpPanelView.mTrans_RequestList = nil;
UIFacilityLvUpPanelView.mTrans_PanelReqUpgrading = nil;
UIFacilityLvUpPanelView.mTrans_PanelReqMAX = nil;
UIFacilityLvUpPanelView.mTrans_timeReq = nil;

function UIFacilityLvUpPanelView:__InitCtrl()

	self.mBtn_Return = self:GetButton("Top/Btn_Return");
	self.mBtn_DetailReturn = self:GetButton("Trans_LevelUpDetail/Btn_DetailReturn");
	self.mBtn_LvUpButton = self:GetButton("Trans_LevelUpDetail/Btn_LvUpButton");
	self.mBtn_LvUpButtonFast = self:GetButton("Trans_LevelUpDetail/Btn_LvUpButtonFast");
	self.mImage_Icon = self:GetImage("Trans_LevelUpDetail/Image_Icon");
	self.mImage_arrow = self:GetImage("Trans_LevelUpDetail/LvUpCurrentStatus/Trans_LvUpList/Trans_FacilityLv/Image_arrow");
	self.mImage_upgradeFill = self:GetImage("Trans_LevelUpDetail/Trans_PanelReqUpgrading/upgradeBak/Image_upgradeFill");
	self.mText_LvUpDetailName = self:GetText("Trans_LevelUpDetail/DetailName/Text_LvUpDetailName");
	self.mText_FacilityText = self:GetText("Trans_LevelUpDetail/LvUpCurrentStatus/Trans_LvUpList/Trans_FacilityLv/Text_FacilityText");
	self.mText_NumBe = self:GetText("Trans_LevelUpDetail/LvUpCurrentStatus/Trans_LvUpList/Trans_FacilityLv/Text_NumBe");
	self.mText_NumAf = self:GetText("Trans_LevelUpDetail/LvUpCurrentStatus/Trans_LvUpList/Trans_FacilityLv/Text_NumAf");
	self.mText_upgradingTime = self:GetText("Trans_LevelUpDetail/Trans_PanelReqUpgrading/Text_upgradingTime");
	self.mText_TimeReqNumer = self:GetText("Trans_LevelUpDetail/Btn_LvUpButton/Trans_timeReq/Text_TimeReqNumer");
	self.mText_GemReqNumer = self:GetText("Trans_LevelUpDetail/Btn_LvUpButtonFast/timeReq/Text_GemReqNumer");
	self.mTrans_LevelUpDetail = self:GetRectTransform("Trans_LevelUpDetail");
	self.mTrans_LvUpList = self:GetRectTransform("Trans_LevelUpDetail/LvUpCurrentStatus/Trans_LvUpList");
	self.mTrans_FacilityLv = self:GetRectTransform("Trans_LevelUpDetail/LvUpCurrentStatus/Trans_LvUpList/Trans_FacilityLv");
	self.mTrans_RequestList = self:GetRectTransform("Trans_LevelUpDetail/PanelReq/Trans_RequestList");
	self.mTrans_PanelReqUpgrading = self:GetRectTransform("Trans_LevelUpDetail/Trans_PanelReqUpgrading");
	self.mTrans_PanelReqMAX = self:GetRectTransform("Trans_LevelUpDetail/Trans_PanelReqMAX");
	self.mTrans_timeReq = self:GetRectTransform("Trans_LevelUpDetail/Btn_LvUpButton/Trans_timeReq");
end

--@@ GF Auto Gen Block End

function UIFacilityLvUpPanelView:InitCtrl(root)

	self:SetRoot(root);
	self:__InitCtrl();


    self.mTrans_FacilityLvUpTree= self:GetRectTransform("PanelRoot/FacilityLvUpTreePanel/FacilityLvUpTree");


end