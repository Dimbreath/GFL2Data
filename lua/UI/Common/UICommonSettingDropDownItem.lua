
---@class UICommonSettingDropDownItem : UIBaseCtrl
UICommonSettingDropDownItem = class("UICommonSettingDropDownItem", UIBaseCtrl);
UICommonSettingDropDownItem.__index = UICommonSettingDropDownItem
--@@ GF Auto Gen Block Begin
UICommonSettingDropDownItem.mText_SuitName = nil;
UICommonSettingDropDownItem.mText_SuitNum = nil;

function UICommonSettingDropDownItem:__InitCtrl()
	self.mText_Name = self:GetText("GrpText/Text_Name");
end

--@@ GF Auto Gen Block End

function UICommonSettingDropDownItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mBtn_Select = self:GetSelfButton()
end

function UICommonSettingDropDownItem:SetData(data, callback)
	self.id = data.id
	self.mText_Name.text = data.name

	UIUtils.GetButtonListener(self.mBtn_Select.gameObject).onClick = function()
		if callback then callback(self) end
	end
end
