require("UI.UIBaseView")

UIDailyCheckInPanelView = class("UIDailyCheckInPanelView", UIBaseView);
UIDailyCheckInPanelView.__index = UIDailyCheckInPanelView

--@@ GF Auto Gen Block Begin
UIDailyCheckInPanelView.mBtn_DailyCheckIn_Confirm = nil;
--UIDailyCheckInPanelView.mImage_DailyCheckIn_CharacterInfo_CharacterImage = nil;
--UIDailyCheckInPanelView.mText_DailyCheckIn_CheckinCountBGImage_CheckinCount_CheckinCountNow = nil;
UIDailyCheckInPanelView.mText_DailyCheckIn_CharacterInfo_Message = nil;
UIDailyCheckInPanelView.mText_DailyCheckIn_CharacterInfo_InfoText02 = nil;
UIDailyCheckInPanelView.mText_DailyCheckIn_CharacterInfo_InfoText03 = nil;
UIDailyCheckInPanelView.mLayout_DailyCheckIn_CheckInItemList = nil;
UIDailyCheckInPanelView.mTrans_DailyCheckIn_CharacterInfo_MessageBGImage = nil;
--UIDailyCheckInPanelView.mTrans_DailyCheckIn_CheckInItemList_CheckInToday = nil;

function UIDailyCheckInPanelView:__InitCtrl()

	self.mBtn_DailyCheckInClose = self:GetButton("Root/GrpDialog/GrpBg/GrpTop/GrpClose/Btn_Close")
	self.mBtn_DailyCheckIn_Confirm = self:GetButton("Root/GrpBg/Btn_Close");
	--self.mImage_DailyCheckIn_CharacterInfo_CharacterImage = self:GetImage("UI_DailyCheckIn/UI_CharacterInfo/Image_CharacterImage");
	--self.mText_DailyCheckIn_CheckinCountBGImage_CheckinCount_CheckinCountNow = self:GetText("UI_DailyCheckIn/UI_CheckinCountBGImage/UI_CheckinCount/Text_CheckinCountNow");
	self.mLayout_DailyCheckIn_CheckInItemList = self:GetGridLayoutGroup("Root/GrpDialog/GrpCenter/GrpList/Viewport/Content");
	--self.mTrans_DailyCheckIn_CheckInItemList_CheckInToday = self:GetRectTransform("UI_DailyCheckIn/ItemScrollView/UI_Layout_CheckInItemList/Trans_CheckInToday");
	self.mScrollView = UIUtils.GetScrollRectEx(self.mUIRoot, "Root/GrpDialog/GrpCenter/GrpList")
end

--@@ GF Auto Gen Block End

function UIDailyCheckInPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end