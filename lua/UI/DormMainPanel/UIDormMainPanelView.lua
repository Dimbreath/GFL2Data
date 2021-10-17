require("UI.UIBaseView")

UIDormMainPanelView = class("UIDormMainPanelView", UIBaseView);
UIDormMainPanelView.__index = UIDormMainPanelView

--@@ GF Auto Gen Block Begin
UIDormMainPanelView.mBtn_Top = nil;
UIDormMainPanelView.mBtn_Right = nil;
UIDormMainPanelView.mBtn_Bottom = nil;
UIDormMainPanelView.mBtn_Left = nil;
UIDormMainPanelView.mBtn_Center = nil;
UIDormMainPanelView.mBtn_back = nil;
UIDormMainPanelView.mBtn_DormSelect = nil;
UIDormMainPanelView.mBtn_HangUp = nil;
UIDormMainPanelView.mBtn_Gift = nil;
UIDormMainPanelView.mBtn_Dress = nil;
UIDormMainPanelView.mBtn_Manage = nil;
UIDormMainPanelView.mBtn_LeftSlide = nil;
UIDormMainPanelView.mBtn_RightSlide = nil;
UIDormMainPanelView.mBtn_cheatback = nil;
UIDormMainPanelView.mBtn_cheattool = nil;
UIDormMainPanelView.mBtn_ActionButton = nil;
UIDormMainPanelView.mBtn_Nextline = nil;
UIDormMainPanelView.mBtn_Skip = nil;
UIDormMainPanelView.mBtn_Accelerate = nil;
UIDormMainPanelView.mImage_Actionbg = nil;
UIDormMainPanelView.mImage_ActionselectBg = nil;
UIDormMainPanelView.mImage_slider = nil;
UIDormMainPanelView.mText_linespace = nil;
UIDormMainPanelView.mText_Name = nil;
UIDormMainPanelView.mText_Storyline = nil;
UIDormMainPanelView.mTrans_DormMain = nil;
UIDormMainPanelView.mTrans_CharacterDormSelect = nil;
UIDormMainPanelView.mTrans_DormList = nil;
UIDormMainPanelView.mTrans_Slide = nil;
UIDormMainPanelView.mTrans_Cheat = nil;
UIDormMainPanelView.mTrans_CheatGroup = nil;
UIDormMainPanelView.mTrans_Plot = nil;
UIDormMainPanelView.mTrans_Subtitle = nil;
UIDormMainPanelView.mTrans_StoryBox = nil;

function UIDormMainPanelView:__InitCtrl()

	self.mBtn_Top = self:GetButton("Trans_DormMain/LeftLayout/Navigate/Btn_Top");
	self.mBtn_Right = self:GetButton("Trans_DormMain/LeftLayout/Navigate/Btn_Right");
	self.mBtn_Bottom = self:GetButton("Trans_DormMain/LeftLayout/Navigate/Btn_Bottom");
	self.mBtn_Left = self:GetButton("Trans_DormMain/LeftLayout/Navigate/Btn_Left");
	self.mBtn_Center = self:GetButton("Trans_DormMain/LeftLayout/Navigate/Btn_Center");
	self.mBtn_back = self:GetButton("Trans_DormMain/LeftLayout/Btn_back");
	self.mBtn_DormSelect = self:GetButton("Trans_DormMain/LeftLayout/Btn_DormSelect");
	self.mBtn_HangUp = self:GetButton("Trans_DormMain/RightLayout/Btn_HangUp");
	self.mBtn_Gift = self:GetButton("Trans_DormMain/RightLayout/Btn_Gift");
	self.mBtn_Dress = self:GetButton("Trans_DormMain/RightLayout/Btn_Dress");
	self.mBtn_Manage = self:GetButton("Trans_DormMain/RightLayout/Btn_Manage");
	self.mBtn_LeftSlide = self:GetButton("Trans_CharacterDormSelect/Trans_Slide/Btn_LeftSlide");
	self.mBtn_RightSlide = self:GetButton("Trans_CharacterDormSelect/Trans_Slide/Btn_RightSlide");
	self.mBtn_cheatback = self:GetButton("Trans_Cheat/Btn_cheatback");
	self.mBtn_cheattool = self:GetButton("Trans_Cheat/Btn_cheattool");
	self.mBtn_ActionButton = self:GetButton("Trans_Cheat/Trans_CheatGroup/cheatlistbg/Btn_ActionButton");
	self.mBtn_Nextline = self:GetButton("Trans_Plot/Trans_StoryBox/StoryBoxbg/Btn_Nextline");
	self.mBtn_Skip = self:GetButton("Trans_Plot/Trans_StoryBox/Settingbar/Btn_Skip");
	self.mBtn_Accelerate = self:GetButton("Trans_Plot/Trans_StoryBox/Settingbar/Btn_Accelerate");
	self.mImage_Actionbg = self:GetImage("Trans_Cheat/Trans_CheatGroup/cheatlistbg/Btn_ActionButton/Image_Actionbg");
	self.mImage_ActionselectBg = self:GetImage("Trans_Cheat/Trans_CheatGroup/cheatlistbg/Btn_ActionButton/Image_ActionselectBg");
	self.mImage_slider = self:GetImage("Trans_Plot/Trans_StoryBox/Settingbar/Btn_Accelerate/Image_slider");
	self.mText_linespace = self:GetText("Trans_Plot/Trans_Subtitle/Text_linespace");
	self.mText_Name = self:GetText("Trans_Plot/Trans_StoryBox/StoryBoxbg/Namebg/Text_Name");
	self.mText_Storyline = self:GetText("Trans_Plot/Trans_StoryBox/StoryBoxbg/Text_Storyline");
	self.mTrans_DormMain = self:GetRectTransform("Trans_DormMain");
	self.mTrans_CharacterDormSelect = self:GetRectTransform("Trans_CharacterDormSelect");
	self.mTrans_DormList = self:GetRectTransform("Trans_CharacterDormSelect/Trans_DormList");
	self.mTrans_Slide = self:GetRectTransform("Trans_CharacterDormSelect/Trans_Slide");
	self.mTrans_Cheat = self:GetRectTransform("Trans_Cheat");
	self.mTrans_CheatGroup = self:GetRectTransform("Trans_Cheat/Trans_CheatGroup");
	self.mTrans_Plot = self:GetRectTransform("Trans_Plot");
	self.mTrans_Subtitle = self:GetRectTransform("Trans_Plot/Trans_Subtitle");
	self.mTrans_StoryBox = self:GetRectTransform("Trans_Plot/Trans_StoryBox");
end

--@@ GF Auto Gen Block End

UIDormMainPanelView.mDropDownA = nil;
UIDormMainPanelView.mDropDownB = nil;
UIDormMainPanelView.mDropDownC = nil;
UIDormMainPanelView.mDropDownD = nil;

UIDormMainPanelView.mBtn_Fixcamera = nil;
UIDormMainPanelView.mBtn_Peercamera = nil;
UIDormMainPanelView.mBtn_Followcamera = nil;

UIDormMainPanelView.mTrans_Fixcamera_Selected = nil;
UIDormMainPanelView.mTrans_Peercamera_Selected = nil;
UIDormMainPanelView.mTrans_Followcamera_Selected = nil;

UIDormMainPanelView.mBtn_Enlarge = nil;
UIDormMainPanelView.mTrans_Enlarge_Selected = nil;

function UIDormMainPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mDropDownA = self:GetDropDown("Trans_Cheat/Trans_CheatGroup/cheatlistbg/DropdownA");
	self.mDropDownB = self:GetDropDown("Trans_Cheat/Trans_CheatGroup/cheatlistbg/DropdownB");
	self.mDropDownC = self:GetDropDown("Trans_Cheat/Trans_CheatGroup/cheatlistbg/DropdownC");
	self.mDropDownD = self:GetDropDown("Trans_Cheat/Trans_CheatGroup/cheatlistbg/DropdownD");

	self.mBtn_Fixcamera = self:GetButton("Trans_DormMain/LeftLayout/CameraNode/Btn_Fixcamera");
	self.mBtn_Peercamera = self:GetButton("Trans_DormMain/LeftLayout/CameraNode/Btn_Peercamera");
	self.mBtn_Followcamera = self:GetButton("Trans_DormMain/LeftLayout/CameraNode/Btn_Followcamera");
	self.mBtn_Enlarge = self:GetButton("Trans_DormMain/LeftLayout/CameraNode/Btn_Enlarge");

	self.mTrans_Fixcamera_Selected = self:GetRectTransform("Trans_DormMain/LeftLayout/CameraNode/Btn_Fixcamera/Trans_Selected");
	self.mTrans_Peercamera_Selected = self:GetRectTransform("Trans_DormMain/LeftLayout/CameraNode/Btn_Peercamera/Trans_Selected");
	self.mTrans_Followcamera_Selected = self:GetRectTransform("Trans_DormMain/LeftLayout/CameraNode/Btn_Followcamera/Trans_Selected");
	self.mTrans_Enlarge_Selected = self:GetRectTransform("Trans_DormMain/LeftLayout/CameraNode/Btn_Enlarge/Trans_Selected");

end