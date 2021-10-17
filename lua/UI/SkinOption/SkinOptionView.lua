require("UI.UIBaseView")

SkinOptionView = class("SkinOptionView", UIBaseView);
SkinOptionView.__index = SkinOptionView

--@@ GF Auto Gen Block Begin
SkinOptionView.mBtn_ConfirmButton = nil;
SkinOptionView.mBtn_SkinDetailButton = nil;
SkinOptionView.mBtn_ViewButton = nil;
SkinOptionView.mImage_ConfirmButton = nil;
SkinOptionView.mImage_SkinDetailButton = nil;
SkinOptionView.mText_OverView_GunName = nil;
SkinOptionView.mText_OverView_GunType = nil;
SkinOptionView.mText_OverView_SkinHavePerCent = nil;
SkinOptionView.mText_SkinName = nil;
SkinOptionView.mText_SkinDSC = nil;
SkinOptionView.mText_again = nil;
SkinOptionView.mLayout_SkinListPanel = nil;
SkinOptionView.mVLayout_SkinDetailPanel = nil;
SkinOptionView.mTrans_OverView_GunGrade = nil;
SkinOptionView.mTrans_SkinListPanel = nil;
SkinOptionView.mTrans_SkinDetailPanel = nil;

function SkinOptionView:__InitCtrl()

	self.mBtn_ConfirmButton = self:GetButton("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//Image_Btn_ConfirmButton");
	self.mBtn_SkinDetailButton = self:GetButton("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//Image_Btn_SkinDetailButton");
	self.mBtn_ViewButton = self:GetButton("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//Btn_ViewButton");
	self.mImage_ConfirmButton = self:GetImage("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//Image_Btn_ConfirmButton");
	self.mImage_SkinDetailButton = self:GetImage("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//Image_Btn_SkinDetailButton");
	self.mText_OverView_GunName = self:GetText("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//UI_OverView/Text_GunName");
	self.mText_OverView_GunType = self:GetText("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//UI_OverView/Text_GunType");
	self.mText_OverView_SkinHavePerCent = self:GetText("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//UI_OverView/Text_SkinHavePerCent");
	self.mText_SkinName = self:GetText("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//DetailPanel/Trans_VLayout_SkinDetailPanel/Text_SkinName");
	self.mText_SkinDSC = self:GetText("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//DetailPanel/Trans_VLayout_SkinDetailPanel/Text_SkinDSC");
	self.mText_again = self:GetText("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//SkinName/Text_SkinName_again");
	self.mLayout_SkinListPanel = self:GetGridLayoutGroup("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//DetailPanel/Trans_Layout_SkinListPanel");
	self.mVLayout_SkinDetailPanel = self:GetVerticalLayoutGroup("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//DetailPanel/Trans_VLayout_SkinDetailPanel");
	self.mTrans_OverView_GunGrade = self:GetRectTransform("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//UI_OverView/UI_Trans_GunGrade");
	self.mTrans_SkinListPanel = self:GetRectTransform("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//DetailPanel/Trans_Layout_SkinListPanel");
	self.mTrans_SkinDetailPanel = self:GetRectTransform("Canvas/UICharacterDetailPanel/UICharacterSkinPanel//DetailPanel/Trans_VLayout_SkinDetailPanel");
end

--@@ GF Auto Gen Block End

function SkinOptionView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end