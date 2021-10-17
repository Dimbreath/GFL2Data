require("UI.UIBaseCtrl")

UIPropertyCompareItem = class("UIPropertyCompareItem", UIBaseCtrl);
UIPropertyCompareItem.__index = UIPropertyCompareItem
--@@ GF Auto Gen Block Begin
UIPropertyCompareItem.mImage_ValueBarPositive = nil;
UIPropertyCompareItem.mImage_ValueBarNegative = nil;
UIPropertyCompareItem.mImage_ValueBarOrigin = nil;
UIPropertyCompareItem.mText_PropertyName = nil;
UIPropertyCompareItem.mText_PropertyValue = nil;

function UIPropertyCompareItem:__InitCtrl()

	self.mImage_ValueBarPositive = self:GetImage("Image_ValueBarPositive");
	self.mImage_ValueBarNegative = self:GetImage("Image_ValueBarNegative");
	self.mImage_ValueBarOrigin = self:GetImage("Image_ValueBarOrigin");
	self.mText_PropertyName = self:GetText("Text_PropertyName");
	self.mText_PropertyValue = self:GetText("Text_PropertyValue");
end

--@@ GF Auto Gen Block End
UIPropertyCompareItem.propID = nil --属性顺序，对应define_carrier_property表

function UIPropertyCompareItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPropertyCompareItem:InitData(id)
	self.propID = id
end

function UIPropertyCompareItem:SetData(part)
	if(part==nil)then
		setactive(self.mUIRoot,false)
		return
	end
	local mValue = CarrierNetCmdHandler:GetPartPropByIndex(part,self.propID)
	if(mValue==0)then
		setactive(self.mUIRoot,false)
	else
		setactive(self.mUIRoot,true)
		local propDefineName = TableData.GetDefineCarrierProperty(self.propID).define_name
		self.mText_PropertyName.text = PropertyUtils.GetPropertyName(propDefineName)
		self.mText_PropertyValue.text = mValue
		local maxValue = TableDataMgr:GetCarrierPartMaxPropertyByIndex(self.propID-1)
		self.mImage_ValueBarOrigin.fillAmount = mValue/maxValue
	end

end