require("UI.UIBaseCtrl")

UIDormBarItem = class("UIDormBarItem", UIBaseCtrl);
UIDormBarItem.__index = UIDormBarItem
--@@ GF Auto Gen Block Begin
UIDormBarItem.mTrans_NodeList = nil;

function UIDormBarItem:__InitCtrl()

	self.mTrans_NodeList = self:GetRectTransform("Trans_NodeList");
end

--@@ GF Auto Gen Block End

UIDormBarItem.mPath_item = "Dorm/UIDormBarItem.prefab";
UIDormBarItem.mData = nil;

function UIDormBarItem:InitCtrl(parent)

	local obj=instantiate(UIUtils.GetGizmosPrefab(UIDormBarItem.mPath_item,self));
    self:SetRoot(obj.transform);
	obj.transform:SetParent(parent,false);
    obj.transform.localScale=vectorone;
	self:__InitCtrl();

end


function UIDormBarItem:SetData(data)
	self.mData = data

end