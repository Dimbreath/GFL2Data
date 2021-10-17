
---@class UICommonSettingButtonItem : UIBaseCtrl
UICommonSettingButtonItem = class("UICommonSettingButtonItem", UIBaseCtrl);
UICommonSettingButtonItem.__index = UICommonSettingButtonItem
--@@ GF Auto Gen Block Begin
UICommonSettingButtonItem.mText_SuitName = nil;
UICommonSettingButtonItem.mText_SuitNum = nil;

function UICommonSettingButtonItem:__InitCtrl()
	self.mText_Name = self:GetText("Root/GrpText/Text_Name");
end

--@@ GF Auto Gen Block End

function UICommonSettingButtonItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mBtn_Select = self:GetSelfButton()
end

function UICommonSettingButtonItem:SetData(data, callback)
	self.id = data.id
	self.mText_Name.text = data.name

	UIUtils.GetButtonListener(self.mBtn_Select.gameObject).onClick = function()
		if callback then callback(self) end
	end
end
