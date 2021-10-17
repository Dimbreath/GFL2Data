require("UI.UIBaseView")

UIPosterPanelView = class("UIPosterPanelView", UIBaseView);
UIPosterPanelView.__index = UIPosterPanelView

--@@ GF Auto Gen Block Begin
UIPosterPanelView.mBtn_GotoActivity = nil;
UIPosterPanelView.mBtn_Back = nil;
UIPosterPanelView.mImage_Background = nil;

function UIPosterPanelView:__InitCtrl()

	self.mBtn_GotoActivity = self:GetButton("Btn_GotoActivity");
	self.mBtn_Back = self:GetButton("Btn_Back");
	self.mImage_Background = self:GetImage("Image_Background");
end

--@@ GF Auto Gen Block End

function UIPosterPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end