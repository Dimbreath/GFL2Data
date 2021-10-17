require("UI.UIBaseView")

UIFrontLayerCanvasView = class("UIFrontLayerCanvasView", UIBaseView);
UIFrontLayerCanvasView.__index = UIFrontLayerCanvasView

--@@ GF Auto Gen Block Begin
UIFrontLayerCanvasView.mBtn_ConfirmBtn = nil;
UIFrontLayerCanvasView.mBtn_SkipFlipBtn = nil;
UIFrontLayerCanvasView.mBtn_GetOne = nil;
UIFrontLayerCanvasView.mBtn_GetTen = nil;

function UIFrontLayerCanvasView:__InitCtrl()
	self.mBtn_ConfirmBtn = self:GetButton("Btn_ConfirmBtn");
	self.mBtn_SkipFlipBtn = self:GetButton("Btn_SkipFlipBtn");
	self.mBtn_GetOne = self:GetButton("GetGachaBTNPanel/Btn_GetOne");
	self.mBtn_GetTen = self:GetButton("GetGachaBTNPanel/Btn_GetTen");
end

--@@ GF Auto Gen Block End

function UIFrontLayerCanvasView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end