require("UI.UIBaseView")

UIChangeAutographPanelView = class("UIChangeAutographPanelView", UIBaseView);
UIChangeAutographPanelView.__index = UIChangeAutographPanelView

--@@ GF Auto Gen Block Begin
UIChangeAutographPanelView.mBtn_CancelBtn = nil;
UIChangeAutographPanelView.mBtn_ComfirmBtn = nil;

function UIChangeAutographPanelView:__InitCtrl()

	self.mBtn_CancelBtn = self:GetButton("MessagePanel/BtnPanel/ButtonDouble/Btn_CancelBtn");
	self.mBtn_ComfirmBtn = self:GetButton("MessagePanel/BtnPanel/ButtonDouble/Btn_ComfirmBtn");
	
	self.mInput_Sign  = self:GetInputField("MessagePanel/EnterPanel/InputField")       
	
end


--@@ GF Auto Gen Block End

function UIChangeAutographPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end