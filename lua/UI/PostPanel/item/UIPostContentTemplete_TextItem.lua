require("UI.UIBaseCtrl")

UIPostContentTemplete_TextItem = class("UIPostContentTemplete_TextItem", UIBaseCtrl);
UIPostContentTemplete_TextItem.__index = UIPostContentTemplete_TextItem
--@@ GF Auto Gen Block Begin

function UIPostContentTemplete_TextItem:__InitCtrl()
	self.mText_self = self:GetSelfText()
end

--@@ GF Auto Gen Block End

function UIPostContentTemplete_TextItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPostContentTemplete_TextItem:SetData(postData)

	self.mText_self.text = postData.text
	self.mText_self.alignment = postData.alignment

end