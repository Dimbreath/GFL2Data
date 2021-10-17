require("UI.UIBaseView")

UIAdjutantPanelView = class("UIAdjutantPanelView", UIBaseView);
UIAdjutantPanelView.__index = UIAdjutantPanelView

--@@ GF Auto Gen Block Begin
UIAdjutantPanelView.mBtn_Return = nil;
UIAdjutantPanelView.mBtn_SetButton = nil;
UIAdjutantPanelView.mImage_Bg = nil;
UIAdjutantPanelView.mImage_element_icon = nil;
UIAdjutantPanelView.mText_Title = nil;
UIAdjutantPanelView.mText_NameText = nil;
UIAdjutantPanelView.mText_Power_AvatarName = nil;
UIAdjutantPanelView.mTrans_characterList = nil;
UIAdjutantPanelView.mTrans_AvatarList = nil;
UIAdjutantPanelView.mTrans_AvatarListLayout = nil;
UIAdjutantPanelView.mTrans_Unlock = nil;
UIAdjutantPanelView.mTrans_Set = nil;
UIAdjutantPanelView.mTrans_Locked = nil;
UIAdjutantPanelView.mTrans_Is = nil;

function UIAdjutantPanelView:__InitCtrl()

	self.mBtn_Return = self:GetButton("TopPanel/Btn_Return");
	self.mBtn_SetButton = self:GetButton("Trans_Set/Btn_SetButton");
	self.mImage_Bg = self:GetImage("BG/Image_Bg");
	self.mImage_element_icon = self:GetImage("characterInfo/UI_element/Image_icon");
	self.mText_Title = self:GetText("BG/Text_Title");
	self.mText_NameText = self:GetText("characterInfo/name/Text_NameText");
	self.mText_Power_AvatarName = self:GetText("characterInfo/name/UI_Power/Text_AvatarName");
	self.mTrans_characterList = self:GetRectTransform("list/Trans_characterList");
	self.mTrans_AvatarList = self:GetRectTransform("characterInfo/name/AvatarInfo/Trans_AvatarList");
	self.mTrans_AvatarListLayout = self:GetRectTransform("characterInfo/name/AvatarInfo/Trans_AvatarList/Trans_AvatarListLayout");
	self.mTrans_Unlock = self:GetRectTransform("characterInfo/name/DetailBtn/Trans_Unlock");
	self.mTrans_Set = self:GetRectTransform("Trans_Set");
	self.mTrans_Locked = self:GetRectTransform("Trans_Set/Btn_SetButton/Trans_Unlock");
	self.mTrans_Is = self:GetRectTransform("Trans_Set/Btn_SetButton/Trans_Is");
end

--@@ GF Auto Gen Block End

function UIAdjutantPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end