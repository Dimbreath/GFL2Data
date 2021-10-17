require("UI.UIBaseCtrl")

UICompleteTaskItem = class("UICompleteTaskItem", UIBaseCtrl);
UICompleteTaskItem.__index = UICompleteTaskItem
--@@ GF Auto Gen Block Begin
UICompleteTaskItem.mImage_Info_TypeIcon = nil;
UICompleteTaskItem.mImage_CompleteIcon = nil;
UICompleteTaskItem.mText_Info_Type = nil;
UICompleteTaskItem.mText_Info_TitleName = nil;
UICompleteTaskItem.mText_Info_Description = nil;

function UICompleteTaskItem:__InitCtrl()

	self.mImage_Info_TypeIcon = self:GetImage("UI_Info/Image_TypeIcon");
	self.mImage_CompleteIcon = self:GetImage("Image_CompleteIcon");
	self.mText_Info_Type = self:GetText("UI_Info/Text_Type");
	self.mText_Info_TitleName = self:GetText("UI_Info/Text_TitleName");
	self.mText_Info_Description = self:GetText("UI_Info/Text_Description");
end

--@@ GF Auto Gen Block End

function UICompleteTaskItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end