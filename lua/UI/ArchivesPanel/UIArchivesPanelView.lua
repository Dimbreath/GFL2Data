require("UI.UIBaseView")

UIArchivesPanelView = class("UIArchivesPanelView", UIBaseView);
UIArchivesPanelView.__index = UIArchivesPanelView

--@@ GF Auto Gen Block Begin
UIArchivesPanelView.mBtn_Return = nil;
UIArchivesPanelView.mBtn_CommandRoom = nil;
UIArchivesPanelView.mBtn_ArchivesBtnItem1_Open = nil;
UIArchivesPanelView.mBtn_ArchivesBtnItem2_Open = nil;
UIArchivesPanelView.mBtn_ArchivesBtnItem3_Open = nil;
UIArchivesPanelView.mBtn_ArchivesTagItem1_ChooseButton = nil;
UIArchivesPanelView.mBtn_ArchivesTagItem2_ChooseButton = nil;
UIArchivesPanelView.mBtn_ArchivesTagItem3_ChooseButton = nil;
UIArchivesPanelView.mImage_ArchivesBtnItem1_Icon = nil;
UIArchivesPanelView.mImage_ArchivesBtnItem2_Icon = nil;
UIArchivesPanelView.mImage_ArchivesBtnItem3_Icon = nil;
UIArchivesPanelView.mText_ArchivesBtnItem1_Title = nil;
UIArchivesPanelView.mText_ArchivesBtnItem2_Title = nil;
UIArchivesPanelView.mText_ArchivesBtnItem3_Title = nil;
UIArchivesPanelView.mVLayout_DetailLIst = nil;
UIArchivesPanelView.mHLayout_List = nil;
UIArchivesPanelView.mHLayout_InfoList = nil;
UIArchivesPanelView.mScrRect_CampInfoDetailPanel = nil;
UIArchivesPanelView.mTrans_ArchivesMainPanel = nil;
UIArchivesPanelView.mTrans_ArchivesListPanel = nil;
UIArchivesPanelView.mTrans_ArchivesTagItem1_Sel = nil;
UIArchivesPanelView.mTrans_ArchivesTagItem2_Sel = nil;
UIArchivesPanelView.mTrans_ArchivesTagItem3_Sel = nil;
UIArchivesPanelView.mTrans_Story = nil;
UIArchivesPanelView.mTrans_CampInfo = nil;
UIArchivesPanelView.mTrans_CharacterFiles = nil;
UIArchivesPanelView.mTrans_ArchivesDetailPanel = nil;
UIArchivesPanelView.mTrans_StoryDetailPanel = nil;
UIArchivesPanelView.mTrans_CampDetailPanel = nil;
UIArchivesPanelView.mTrans_CharacterFilesDetailPanel = nil;

function UIArchivesPanelView:__InitCtrl()

	self.mBtn_Return = self:GetButton("TopPanel/Btn_Return");
	self.mBtn_CommandRoom = self:GetButton("TopPanel/Btn_CommandRoom");
	self.mBtn_ArchivesBtnItem1_Open = self:GetButton("Trans_ArchivesMainPanel/ButtenList/UI_ArchivesBtnItem1/Btn_Open");
	self.mBtn_ArchivesBtnItem2_Open = self:GetButton("Trans_ArchivesMainPanel/ButtenList/UI_ArchivesBtnItem2/Btn_Open");
	self.mBtn_ArchivesBtnItem3_Open = self:GetButton("Trans_ArchivesMainPanel/ButtenList/UI_ArchivesBtnItem3/Btn_Open");
	self.mBtn_ArchivesTagItem1_ChooseButton = self:GetButton("Trans_ArchivesListPanel/LeftPanel/List/UI_ArchivesTagItem1/Btn_ChooseButton");
	self.mBtn_ArchivesTagItem2_ChooseButton = self:GetButton("Trans_ArchivesListPanel/LeftPanel/List/UI_ArchivesTagItem2/Btn_ChooseButton");
	self.mBtn_ArchivesTagItem3_ChooseButton = self:GetButton("Trans_ArchivesListPanel/LeftPanel/List/UI_ArchivesTagItem3/Btn_ChooseButton");
	self.mImage_ArchivesBtnItem1_Icon = self:GetImage("Trans_ArchivesMainPanel/ButtenList/UI_ArchivesBtnItem1/Image_Icon");
	self.mImage_ArchivesBtnItem2_Icon = self:GetImage("Trans_ArchivesMainPanel/ButtenList/UI_ArchivesBtnItem2/Image_Icon");
	self.mImage_ArchivesBtnItem3_Icon = self:GetImage("Trans_ArchivesMainPanel/ButtenList/UI_ArchivesBtnItem3/Image_Icon");
	self.mText_ArchivesBtnItem1_Title = self:GetText("Trans_ArchivesMainPanel/ButtenList/UI_ArchivesBtnItem1/Text_Title");
	self.mText_ArchivesBtnItem2_Title = self:GetText("Trans_ArchivesMainPanel/ButtenList/UI_ArchivesBtnItem2/Text_Title");
	self.mText_ArchivesBtnItem3_Title = self:GetText("Trans_ArchivesMainPanel/ButtenList/UI_ArchivesBtnItem3/Text_Title");
	self.mVLayout_DetailLIst = self:GetVerticalLayoutGroup("Trans_ArchivesDetailPanel/Trans_CampDetailPanel/ScrRect_CampInfoDetailPanel/VLayout_DetailLIst");
	self.mHLayout_List = self:GetHorizontalLayoutGroup("Trans_ArchivesListPanel/DetaiPanel/Trans_Story/HLayout_List");
	self.mHLayout_InfoList = self:GetHorizontalLayoutGroup("Trans_ArchivesListPanel/DetaiPanel/Trans_CampInfo/HLayout_InfoList");
	self.mScrRect_CampInfoDetailPanel = self:GetScrollRect("Trans_ArchivesDetailPanel/Trans_CampDetailPanel/ScrRect_CampInfoDetailPanel");
	self.mTrans_ArchivesMainPanel = self:GetRectTransform("Trans_ArchivesMainPanel");
	self.mTrans_ArchivesListPanel = self:GetRectTransform("Trans_ArchivesListPanel");
	self.mTrans_ArchivesTagItem1_Sel = self:GetRectTransform("Trans_ArchivesListPanel/LeftPanel/List/UI_ArchivesTagItem1/Trans_Sel");
	self.mTrans_ArchivesTagItem2_Sel = self:GetRectTransform("Trans_ArchivesListPanel/LeftPanel/List/UI_ArchivesTagItem2/Trans_Sel");
	self.mTrans_ArchivesTagItem3_Sel = self:GetRectTransform("Trans_ArchivesListPanel/LeftPanel/List/UI_ArchivesTagItem3/Trans_Sel");
	self.mTrans_Story = self:GetRectTransform("Trans_ArchivesListPanel/DetaiPanel/Trans_Story");
	self.mTrans_CampInfo = self:GetRectTransform("Trans_ArchivesListPanel/DetaiPanel/Trans_CampInfo");
	self.mTrans_CharacterFiles = self:GetRectTransform("Trans_ArchivesListPanel/DetaiPanel/Trans_CharacterFiles");
	self.mTrans_ArchivesDetailPanel = self:GetRectTransform("Trans_ArchivesDetailPanel");
	self.mTrans_StoryDetailPanel = self:GetRectTransform("Trans_ArchivesDetailPanel/Trans_StoryDetailPanel");
	self.mTrans_CampDetailPanel = self:GetRectTransform("Trans_ArchivesDetailPanel/Trans_CampDetailPanel");
	self.mTrans_CharacterFilesDetailPanel = self:GetRectTransform("Trans_ArchivesDetailPanel/Trans_CharacterFilesDetailPanel");
end

--@@ GF Auto Gen Block End

function UIArchivesPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end