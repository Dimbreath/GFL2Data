require("UI.UIBaseCtrl")

UIAdjutantTypeListItem = class("UIAdjutantTypeListItem", UIBaseCtrl);
UIAdjutantTypeListItem.__index = UIAdjutantTypeListItem
--@@ GF Auto Gen Block Begin
UIAdjutantTypeListItem.mImage_TypeIcon = nil;
UIAdjutantTypeListItem.mText_TypeName = nil;
UIAdjutantTypeListItem.mText_TextNum = nil;
UIAdjutantTypeListItem.mTrans_CardList = nil;
UIAdjutantTypeListItem.mTrans_Up = nil;
UIAdjutantTypeListItem.mTrans_Down = nil;

function UIAdjutantTypeListItem:__InitCtrl()

	self.mImage_TypeIcon = self:GetImage("Image_TypeIcon");
	self.mText_TypeName = self:GetText("Text_TypeName");
	self.mText_TextNum = self:GetText("expand/Text_TextNum");
	self.mTrans_CardList = self:GetRectTransform("Trans_CardList");
	self.mTrans_Up = self:GetRectTransform("expand/Trans_Up");
	self.mTrans_Down = self:GetRectTransform("expand/Trans_Down");
end

--@@ GF Auto Gen Block End

UIAdjutantTypeListItem.mPath_item = "Adjustant/UIAdjutantTypeListItem.prefab";

function UIAdjutantTypeListItem:InitCtrl(parent)

	local obj=instantiate(UIUtils.GetGizmosPrefab(UIAdjutantTypeListItem.mPath_item,self));
	self:SetRoot(obj.transform);
	obj.transform:SetParent(parent,false);
    --setparent(parent,obj.transform);
    obj.transform.localScale=vectorone;
    --self:SetRoot(obj.transform);
	self:__InitCtrl();

end

function UIAdjutantTypeListItem:InitData(data)
	self.mText_TypeName.text = data.name;
	self.mText_TextNum.text = NetCmdIllustrationData:GetUnlockNumStr(data.id);
end