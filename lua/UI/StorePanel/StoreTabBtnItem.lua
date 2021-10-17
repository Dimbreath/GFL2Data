require("UI.UIBaseCtrl")

StoreTabBtnItem = class("StoreTabBtnItem", UIBaseCtrl);
StoreTabBtnItem.__index = StoreTabBtnItem
--@@ GF Auto Gen Block Begin
StoreTabBtnItem.mBtn_Tab = nil;
StoreTabBtnItem.mText_TabName = nil;
StoreTabBtnItem.mText_Sel_TabName = nil;
StoreTabBtnItem.mTrans_Sel = nil;

function StoreTabBtnItem:__InitCtrl()

	self.mBtn_Tab = self:GetButton("Btn_Tab");
	self.mText_TabName = self:GetText("Background/Text_TabName");
	self.mText_Sel_TabName = self:GetText("Background/UI_Trans_Sel/Text_TabName");
	self.mTrans_Sel = self:GetRectTransform("Background/UI_Trans_Sel");
end

--@@ GF Auto Gen Block End

StoreTabBtnItem.mData = nil;

function StoreTabBtnItem:InitCtrl(parent)

	local obj=instantiate(UIUtils.GetGizmosPrefab("Store/StoreTabBtnItem.prefab",self));
	setparent(parent,obj.transform);
	obj.transform.localScale=vectorone;

	self:SetRoot(obj.transform);

	self:__InitCtrl();

end

function StoreTabBtnItem:InitData(data )
	self.mData = data;
	self.mText_TabName.text = data.name.str;
	self.mText_Sel_TabName.text = data.name.str;
end

function StoreTabBtnItem:SetSelect(value)
	setactive(self.mTrans_Sel.gameObject,value);
end