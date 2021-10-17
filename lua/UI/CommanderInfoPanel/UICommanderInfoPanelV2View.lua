require("UI.UIBaseView")

---@class UICommanderInfoPanelV2View : UIBaseView
UICommanderInfoPanelV2View = class("UICommanderInfoPanelV2View", UIBaseView);
UICommanderInfoPanelV2View.__index = UICommanderInfoPanelV2View

--@@ GF Auto Gen Block Begin
UICommanderInfoPanelV2View.mText_Num = nil;
UICommanderInfoPanelV2View.mContent_AchievementAll = nil;
UICommanderInfoPanelV2View.mContent_2 = nil;
UICommanderInfoPanelV2View.mContent_Account = nil;
UICommanderInfoPanelV2View.mContent_Sound = nil;
UICommanderInfoPanelV2View.mContent_PictureQuality = nil;
UICommanderInfoPanelV2View.mContent_Other = nil;
UICommanderInfoPanelV2View.mContent_ = nil;
UICommanderInfoPanelV2View.mScrollbar_AchievementAll = nil;
UICommanderInfoPanelV2View.mScrollbar_Sound = nil;
UICommanderInfoPanelV2View.mScrollbar_PictureQuality = nil;
UICommanderInfoPanelV2View.mScrollbar_Other = nil;
UICommanderInfoPanelV2View.mList_AchievementAll = nil;
UICommanderInfoPanelV2View.mTrans_0 = nil;
UICommanderInfoPanelV2View.mTrans_1 = nil;
UICommanderInfoPanelV2View.mTrans_2 = nil;
UICommanderInfoPanelV2View.mTrans_Sound = nil;
UICommanderInfoPanelV2View.mTrans_PictureQuality = nil;
UICommanderInfoPanelV2View.mTrans_Account = nil;
UICommanderInfoPanelV2View.mTrans_Other = nil;
UICommanderInfoPanelV2View.mTrans_SupChrReplace = nil;
UICommanderInfoPanelV2View.mTrans_DropDown = nil;

function UICommanderInfoPanelV2View:__InitCtrl()
	self.mBtn_Back = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpLeft/Content/GrpTop/BtnBack"));
	self.mBtn_Home = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpLeft/Content/GrpTop/BtnHome"));
	self.mBtn_ExitGame = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpLeft/BtnExitGame"));
	
	self.mContent_Tab = self:GetVerticalLayoutGroup("Root/GrpLeft/Content/GrpTabSwitch/Content");

	self.mScrollbar_Sound = self:GetScrollbar("Root/GrpRight/Trans_GrpSettings_2/Trans_GrpSound/Scrollbar");
	self.mScrollbar_PictureQuality = self:GetScrollbar("Root/GrpRight/Trans_GrpSettings_2/Trans_GrpPictureQuality/Scrollbar");
	self.mScrollbar_Other = self:GetScrollbar("Root/GrpRight/Trans_GrpSettings_2/Trans_GrpOther/Scrollbar");

	self.mTrans_0 = self:GetRectTransform("Root/GrpRight/Trans_GrpPlayerInfo_0");
	self.mTrans_1 = self:GetRectTransform("Root/GrpRight/Trans_Grpachievement_1");
	self.mTrans_2 = self:GetRectTransform("Root/GrpRight/Trans_GrpSettings_2");

	self.mTrans_SupChrReplace = self:GetRectTransform("Root/Trans_SupChrReplace");
	self.mTrans_DropDown = self:GetRectTransform("Root/Trans_DropDownList");
end

--@@ GF Auto Gen Block End

function UICommanderInfoPanelV2View:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	self.animator = self:GetRootAnimator()
end