require("UI.UIBaseCtrl")

UIColorPickerItem = class("UIColorPickerItem", UIBaseCtrl);
UIColorPickerItem.__index = UIColorPickerItem
--@@ GF Auto Gen Block Begin
UIColorPickerItem.mBtn_ColorConfirmButton = nil;
UIColorPickerItem.mBtn_ColorPickerButton = nil;
UIColorPickerItem.mTrans_ColorPickerImage = nil;

UIColorPickerItem.mColorPicker = nil;
UIColorPickerItem.OnConfirmCallback = nil;
UIColorPickerItem.mTagIndex = nil;

function UIColorPickerItem:__InitCtrl()

	self.mBtn_ColorConfirmButton = self:GetButton("ColorPickerPanel/Btn_ColorConfirmButton");
	self.mBtn_ColorPickerButton = self:GetButton("ColorPickerPanel/Btn_ColorPickerButton");
	self.mTrans_ColorPickerImage =  self:GetRectTransform("ColorPickerPanel/ColorPickerImage");
	
	UIUtils.GetButtonListener(self.mBtn_ColorConfirmButton.gameObject).onClick = self.OnConfirmClicked;
end

--@@ GF Auto Gen Block End

function UIColorPickerItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	
	self.mColorPicker = self.mTrans_ColorPickerImage:GetComponent("ColorPicker");

end

function UIColorPickerItem:InitCallBack(pickCallback, confirmCallback)
	self.mColorPicker:SetColorPickerCallback(pickCallback);
	UIColorPickerItem.OnConfirmCallback = confirmCallback;
end

function UIColorPickerItem.OnConfirmClicked(gameObj)
	self = UIColorPickerItem;
	UIColorPickerItem.OnConfirmCallback();
end

function UIColorPickerItem:InitHandlePos(pos)
	self.mColorPicker:SetHandlerPos(pos);
	
end