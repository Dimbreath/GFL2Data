require("UI.UIBaseCtrl")

UILocationPickerItem = class("UILocationPickerItem", UIBaseCtrl);
UILocationPickerItem.__index = UILocationPickerItem
--@@ GF Auto Gen Block Begin
UILocationPickerItem.mBtn_ColorPickerButton = nil;

function UILocationPickerItem:__InitCtrl()

	self.mBtn_ColorPickerButton = self:GetButton("LocationPickerPanel/Btn_ColorPickerButton");
end

--@@ GF Auto Gen Block End

function UILocationPickerItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end