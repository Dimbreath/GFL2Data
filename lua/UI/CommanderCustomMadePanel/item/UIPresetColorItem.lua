require("UI.UIBaseCtrl")

UIPresetColorItem = class("UIPresetColorItem", UIBaseCtrl);
UIPresetColorItem.__index = UIPresetColorItem
--@@ GF Auto Gen Block Begin
UIPresetColorItem.mBtn_TemplateUnchosen = nil;
UIPresetColorItem.mImage_Bg2 = nil;
UIPresetColorItem.mBtn_PresetColor = nil;

UIPresetColorItem.mColor = nil;

function UIPresetColorItem:__InitCtrl()

	self.mBtn_TemplateUnchosen = self:GetButton("Btn_TemplateUnchosen");
	self.mBtn_PresetColor = self:GetButton("Btn_PresetColor");
	self.mImage_Bg2 = self:GetImage("Btn_PresetColor/Image_Bg2");
end

--@@ GF Auto Gen Block End

function UIPresetColorItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPresetColorItem:InitData(data)
	self.mColor = data;
	self.mImage_Bg2.color = data;
end