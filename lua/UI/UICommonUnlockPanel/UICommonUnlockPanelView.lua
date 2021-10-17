require("UI.UIBaseView")

---@class UICommonUnlockPanelView : UIBaseView
UICommonUnlockPanelView = class("UICommonUnlockPanelView", UIBaseView);
UICommonUnlockPanelView.__index = UICommonUnlockPanelView

--@@ GF Auto Gen Block Begin
UICommonUnlockPanelView.mBtn_Close = nil;
UICommonUnlockPanelView.mImg_Icon = nil;
UICommonUnlockPanelView.mText_Tittle = nil;
UICommonUnlockPanelView.mText_Unlock = nil;
UICommonUnlockPanelView.mText_Next = nil;
UICommonUnlockPanelView.mContent_ = nil;

function UICommonUnlockPanelView:__InitCtrl()

	self.mBtn_Close = self:GetButton("Root/GrpBg/Btn_Close");
	self.mImg_Icon = self:GetImage("Root/GrpContent/Content/GrpIcon/Img_Icon");
	self.mText_Tittle = self:GetText("Root/GrpContent/Content/GrpText/Text_Tittle");
	self.mText_Unlock = self:GetText("Root/GrpContent/Content/GrpText/TextUnlock");
	self.mText_Next = self:GetText("Root/GrpTextNext/NextText");
	self.mContent_ = self:GetHorizontalLayoutGroup("Root/GrpContent/Content");
end

--@@ GF Auto Gen Block End

function UICommonUnlockPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end