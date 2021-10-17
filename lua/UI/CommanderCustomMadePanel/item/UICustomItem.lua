require("UI.UIBaseCtrl")

UICustomItem = class("UICustomItem", UIBaseCtrl);
UICustomItem.__index = UICustomItem
--@@ GF Auto Gen Block Begin
UICustomItem.mBtn_CustomItemButton = nil;
UICustomItem.mImage_CustomIcon = nil;
UICustomItem.mTrans_CustomChosen = nil;

UICustomItem.mData = nil;
UICustomItem.mDecoIndex = 0;

function UICustomItem:__InitCtrl()

	self.mBtn_CustomItemButton = self:GetButton("Btn_CustomItemButton");
	self.mImage_CustomIcon = self:GetImage("Btn_CustomItemButton/Image_CustomIcon");
	self.mTrans_CustomChosen = self:GetRectTransform("Btn_CustomItemButton/Trans_CustomChosen");
end

--@@ GF Auto Gen Block End

function UICustomItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UICustomItem:InitData(data)
	self.mData = data;
end

function UICustomItem:SetSelect(isSelect)
	setactive(self.mTrans_CustomChosen.gameObject, isSelect);
end