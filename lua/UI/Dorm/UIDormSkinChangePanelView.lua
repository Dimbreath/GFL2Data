require("UI.UIBaseView")

UIDormSkinChangePanelView = class("UIDormSkinChangePanelView", UIBaseView);
UIDormSkinChangePanelView.__index = UIDormSkinChangePanelView

--@@ GF Auto Gen Block Begin
UIDormSkinChangePanelView.mBtn_HairPart = nil;
UIDormSkinChangePanelView.mBtn_BodyPart = nil;
UIDormSkinChangePanelView.mBtn_Ensure = nil;
UIDormSkinChangePanelView.mBtn_CommandCenter = nil;
UIDormSkinChangePanelView.mBtn_Close = nil;
UIDormSkinChangePanelView.mImage_HairPart_Selected = nil;
UIDormSkinChangePanelView.mImage_BodyPart_Selected = nil;
UIDormSkinChangePanelView.mText_Text = nil;

function UIDormSkinChangePanelView:__InitCtrl()

	self.mBtn_HairPart = self:GetButton("LeftLayout/UI_Btn_HairPart");
	self.mBtn_BodyPart = self:GetButton("LeftLayout/UI_Btn_BodyPart");
	self.mBtn_Ensure = self:GetButton("RightLayout/Description/Btn_Ensure");
	self.mBtn_CommandCenter = self:GetButton("Btn_CommandCenter");
	self.mBtn_Close = self:GetButton("Btn_Close");
	self.mImage_HairPart_Selected = self:GetImage("LeftLayout/UI_Btn_HairPart/Image_Selected");
	self.mImage_BodyPart_Selected = self:GetImage("LeftLayout/UI_Btn_BodyPart/Image_Selected");
	self.mText_Text = self:GetText("RightLayout/Description/Text_Text");
end

--@@ GF Auto Gen Block End

UIDormSkinChangePanelView.mTrans_Content = nil;

function UIDormSkinChangePanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mTrans_Content = self:GetRectTransform("LeftLayout/ItemList/Viewport/Content");

end