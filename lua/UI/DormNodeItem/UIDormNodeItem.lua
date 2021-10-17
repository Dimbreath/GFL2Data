require("UI.UIBaseCtrl")

UIDormNodeItem = class("UIDormNodeItem", UIBaseCtrl);
UIDormNodeItem.__index = UIDormNodeItem
--@@ GF Auto Gen Block Begin
UIDormNodeItem.mBtn_Icon = nil;
UIDormNodeItem.mImage_NormalState = nil;
UIDormNodeItem.mImage_SelectedState = nil;
UIDormNodeItem.mText_Name = nil;
UIDormNodeItem.mTrans_equipped = nil;

function UIDormNodeItem:__InitCtrl()

	self.mBtn_Icon = self:GetButton("Btn_Icon");
	self.mImage_NormalState = self:GetImage("Btn_Icon/Image_NormalState");
	self.mImage_SelectedState = self:GetImage("Btn_Icon/Image_SelectedState");
	self.mText_Name = self:GetText("Text_Name");
	self.mTrans_equipped = self:GetRectTransform("Trans_equipped");
end

--@@ GF Auto Gen Block End

UIDormNodeItem.mPath_item = "Dorm/UIDormNodeItem.prefab";
UIDormNodeItem.mData = nil;
UIDormNodeItem.mPartId = 0;

function UIDormNodeItem:InitCtrl(parent)

	local obj=instantiate(UIUtils.GetGizmosPrefab(UIDormNodeItem.mPath_item,self));
    self:SetRoot(obj.transform);
	obj.transform:SetParent(parent,false);
    obj.transform.localScale=vectorone;
	self:__InitCtrl();

end

function UIDormNodeItem:SetData(data)
	self.mData = data

	self.mText_Name.text = data.Name;

	self:SetEquipped();
end

function UIDormNodeItem:SetSkinData(name,id)
	self.mData = name
	self.mText_Name.text = name;
	self.mPartId = id;
	--self:SetEquipped();
end

function UIDormNodeItem:SetEquipped()
	if(self.mData.IsPlaced) then
		setactive(self.mTrans_equipped,true);
	else
		setactive(self.mTrans_equipped,false);
	end
end

function UIDormNodeItem:SetSelect(isSelected)
	setactive(self.mImage_SelectedState.transform,isSelected);
end
