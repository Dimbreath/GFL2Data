require("UI.UIBaseView")

UILoadingMaskPanelView = class("UILoadingMaskPanelView", UIBaseView);
UILoadingMaskPanelView.__index = UILoadingMaskPanelView

--@@ GF Auto Gen Block Begin
UILoadingMaskPanelView.mText_LoadingText = nil;

function UILoadingMaskPanelView:__InitCtrl()

	self.mText_LoadingText = self:GetText("Loading/Text_LoadingText");
end

--@@ GF Auto Gen Block End

function UILoadingMaskPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end