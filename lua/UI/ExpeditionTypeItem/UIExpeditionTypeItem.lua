require("UI.UIBaseCtrl")

UIExpeditionTypeItem = class("UIExpeditionTypeItem", UIBaseCtrl);
UIExpeditionTypeItem.__index = UIExpeditionTypeItem
--@@ GF Auto Gen Block Begin
UIExpeditionTypeItem.mBtn_ExpeditionType = nil;
UIExpeditionTypeItem.mBtn_ExpeditionTypeSelect = nil;
UIExpeditionTypeItem.mImage_ExpeditionType = nil;
UIExpeditionTypeItem.mText_ExpeditionTypeName = nil;
UIExpeditionTypeItem.mTrans_ExpeditionTypeSelect = nil;

UIExpeditionTypeItem.mId = 0;

function UIExpeditionTypeItem:__InitCtrl()

	self.mBtn_ExpeditionType = self:GetButton("Image_Btn_ExpeditionType");
	self.mBtn_ExpeditionTypeSelect = self:GetButton("Image_Btn_ExpeditionType/Trans_Btn_ExpeditionTypeSelect");
	self.mImage_ExpeditionType = self:GetImage("Image_Btn_ExpeditionType");
	self.mText_ExpeditionTypeName = self:GetText("Image_Btn_ExpeditionType/Text_ExpeditionTypeName");
	self.mTrans_ExpeditionTypeSelect = self:GetRectTransform("Image_Btn_ExpeditionType/Trans_Btn_ExpeditionTypeSelect");
end

--@@ GF Auto Gen Block End

function UIExpeditionTypeItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIExpeditionTypeItem:InitData(name,id) 
	self.mText_ExpeditionTypeName.text = name;
	self.mId = id;
end

function UIExpeditionTypeItem:SetSelect(isSelect)
	setactive(self.mTrans_ExpeditionTypeSelect.gameObject,isSelect);
end