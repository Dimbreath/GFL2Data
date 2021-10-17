require("UI.UIBaseCtrl")

UIStoreSkinItem = class("UIStoreSkinItem", UIBaseCtrl);
UIStoreSkinItem.__index = UIStoreSkinItem
--@@ GF Auto Gen Block Begin
UIStoreSkinItem.mBtn_Main = nil;
UIStoreSkinItem.mImage_IconImage = nil;
UIStoreSkinItem.mText_Name = nil;
UIStoreSkinItem.mText_PriceNumber = nil;
UIStoreSkinItem.mText_DiscountDetial = nil;
UIStoreSkinItem.mText_Price_PriceNumber = nil;
UIStoreSkinItem.mTrans_Recommend = nil;
UIStoreSkinItem.mTrans_Limit = nil;
UIStoreSkinItem.mTrans_Discount = nil;
UIStoreSkinItem.mTrans_SoldOut = nil;

function UIStoreSkinItem:__InitCtrl()

	self.mBtn_Main = self:GetButton("Btn_Main");
	self.mImage_IconImage = self:GetImage("Btn_Main/GoodsIcon/Image_IconImage");
	self.mText_Name = self:GetText("Btn_Main/GoodsName/Text_Name");
	self.mText_PriceNumber = self:GetText("Btn_Main/Price/Text_PriceNumber");
	self.mText_DiscountDetial = self:GetText("Btn_Main/Trans_Discount/Text_DiscountDetial");
	self.mText_Price_PriceNumber = self:GetText("Shadow/UI_Price/Text_PriceNumber");
	self.mTrans_Recommend = self:GetRectTransform("Btn_Main/Trans_Recommend");
	self.mTrans_Limit = self:GetRectTransform("Btn_Main/Trans_Limit");
	self.mTrans_Discount = self:GetRectTransform("Btn_Main/Trans_Discount");
	self.mTrans_SoldOut = self:GetRectTransform("Btn_Main/Trans_SoldOut");
end

--@@ GF Auto Gen Block End

function UIStoreSkinItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIStoreSkinItem:InitData(data)
	self.mData = data;
	
	self.mText_Name.text = data.name;
	local num = tonumber(data.price);
	self.mText_PriceNumber.text = formatnum(num);
	self.mText_Price_PriceNumber.text = formatnum(num);
	
	-- if(data.limit == 0) then
	-- 	self.mText_AmountNumber.text = "-";
	-- else
	-- 	self.mText_AmountNumber.text = ""..data.remain_times;
	-- end
	
	if(data.IsRecommend) then
		setactive(self.mTrans_Recommend.gameObject, true);
	else
		setactive(self.mTrans_Recommend.gameObject, false);
	end
	
	if(data.remain_times == 0 and (data.limit ~= 0 or data.IsSpecial)) then
		setactive(self.mTrans_SoldOut.gameObject, true);
	end
	
	self.mImage_IconImage.sprite = UIUtils.GetIconSprite("Icon/Item",data.icon);
end