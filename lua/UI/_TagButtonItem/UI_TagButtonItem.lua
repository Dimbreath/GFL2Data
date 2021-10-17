require("UI.UIBaseCtrl")

UI_TagButtonItem = class("UI_TagButtonItem", UIBaseCtrl);
UI_TagButtonItem.__index = UI_TagButtonItem
--@@ GF Auto Gen Block Begin
UI_TagButtonItem.mText_TagButtonItem_Tag = nil;
UI_TagButtonItem.mText_TagButtonItem_TagButtonSelected_SelectTag = nil;
UI_TagButtonItem.mTrans_TagButtonItem_TagButtonSelected = nil;
UI_TagButtonItem.mTrans_TagButtonItem_RedPoint = nil;

UI_TagButtonItem.mBtnSelf = nil;

function UI_TagButtonItem:__InitCtrl()

	self.mText_TagButtonItem_Tag = self:GetText("Text_Tag");
	self.mText_TagButtonItem_TagButtonSelected_SelectTag = self:GetText("UI_Trans_TagButtonSelected/Text_SelectTag");
	self.mTrans_TagButtonItem_TagButtonSelected = self:GetRectTransform("UI_Trans_TagButtonSelected");
	self.mTrans_TagButtonItem_RedPoint = self:GetRectTransform("Trans_RedPoint");
	self.mBtnSelf = self:GetSelfButton();
end

--@@ GF Auto Gen Block End

UI_TagButtonItem.mData = nil;

function UI_TagButtonItem:InitCtrl(parent)

	local obj=instantiate(UIUtils.GetGizmosPrefab("Store/UI_TagButtonItem.prefab",self));
	setparent(parent,obj.transform);
	obj.transform.localScale=vectorone;

	self:SetRoot(obj.transform);
	self:__InitCtrl();
end

function UI_TagButtonItem:InitData(data)
	self.mData = data;
	self.mText_TagButtonItem_Tag.text = data.name.str;
	self.mText_TagButtonItem_TagButtonSelected_SelectTag.text = data.name.str;
end

function UI_TagButtonItem:SetSelect(value)
	setactive(self.mTrans_TagButtonItem_TagButtonSelected.gameObject,value);
end