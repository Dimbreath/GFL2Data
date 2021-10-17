require("UI.UIBaseCtrl")

UIStoreTagItem = class("UIStoreTagItem", UIBaseCtrl);
UIStoreTagItem.__index = UIStoreTagItem
--@@ GF Auto Gen Block Begin
UIStoreTagItem.mBtn_TagButton = nil;
UIStoreTagItem.mImage_TageImage = nil;
UIStoreTagItem.mText_BigTagText = nil;
UIStoreTagItem.mText_SmallTagText = nil;
UIStoreTagItem.mText_Lock = nil;
UIStoreTagItem.mTrans_TopImage = nil;
UIStoreTagItem.mTrans_TagBGImageLock = nil;


function UIStoreTagItem:__InitCtrl()

	self.mBtn_TagButton = self:GetButton("Btn_TagButton");
	self.mImage_TageImage = self:GetImage("Btn_TagButton/Image_TageImage");
	self.mText_BigTagText = self:GetText("Btn_TagButton/Text_BigTagText");
	self.mText_SmallTagText = self:GetText("Btn_TagButton/Text_SmallTagText");
	self.mText_Lock = self:GetText("Btn_TagButton/Trans_TagBGImageLock/Text_Lock");
	self.mTrans_TopImage = self:GetRectTransform("Btn_TagButton/Trans_TopImage");
	self.mTrans_TagBGImageLock = self:GetRectTransform("Btn_TagButton/Trans_TagBGImageLock");
end


--@@ GF Auto Gen Block End

UIStoreTagItem.mData = nil;
function UIStoreTagItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIStoreTagItem:InitData(data)
	self.mData = data;
	self.mText_BigTagText.text = data.name.str;
	self.mText_SmallTagText.text = data.hintname.str;
	self.mImage_TageImage.sprite = UIUtils.GetIconSprite("Store/Res",data.icon);
	
	setactive(self.mTrans_TopImage.gameObject,false);
end