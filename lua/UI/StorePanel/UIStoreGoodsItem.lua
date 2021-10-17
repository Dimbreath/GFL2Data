require("UI.UIBaseCtrl")

UIStoreGoodsItem = class("UIStoreGoodsItem", UIBaseCtrl);
UIStoreGoodsItem.__index = UIStoreGoodsItem
--@@ GF Auto Gen Block Begin
UIStoreGoodsItem.mBtn_Main = nil;
UIStoreGoodsItem.mImage_IconImage = nil;
UIStoreGoodsItem.mText_Name = nil;
UIStoreGoodsItem.mText_PriceNumber = nil;
UIStoreGoodsItem.mText_AmountNumber = nil;
UIStoreGoodsItem.mText_DiscountDetial = nil;
UIStoreGoodsItem.mTrans_Recommend = nil;
UIStoreGoodsItem.mTrans_Limit = nil;
UIStoreGoodsItem.mTrans_Discount = nil;
UIStoreGoodsItem.mTrans_SoldOut = nil;

function UIStoreGoodsItem:__InitCtrl()

	self.mBtn_Main = self:GetButton("Btn_Goods");
	self.mImage_IconImage = self:GetImage("GoodsIcon/Image_IconImage");
	self.mText_Name = self:GetText("GoodsName/Text_Name");
	self.mText_PriceNumber = self:GetText("Price/Text_PriceNumber");
	self.mText_AmountNumber = self:GetText("Amount/Text_AmountNumber");
	self.mText_DiscountDetial = self:GetText("Trans_Discount/Text_DiscountDetial");
	self.mTrans_Recommend = self:GetRectTransform("Trans_Recommend");
	self.mTrans_Limit = self:GetRectTransform("Trans_Limit");
	self.mTrans_Discount = self:GetRectTransform("Trans_Discount");
	self.mTrans_SoldOut = self:GetRectTransform("Trans_SoldOut");
end

--@@ GF Auto Gen Block End

function UIStoreGoodsItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIStoreGoodsItem:InitData(data)
	self.mData = data;
	
	self.mText_Name.text = data.name;
	local num = tonumber(data.price);
	self.mText_PriceNumber.text = formatnum(num);
	
	--if(data.limit == 0 and data.hasRefreshTime == false) then
	if(data.limit == 0) then
		self.mText_AmountNumber.text = "-";
	else
		self.mText_AmountNumber.text = ""..data.remain_times;
	end
	
	if(data.IsRecommend) then
		setactive(self.mTrans_Recommend.gameObject, true);
	else
		setactive(self.mTrans_Recommend.gameObject, false);
	end
	
	if(data.remain_times == 0 and (data.limit ~= 0 or data.IsSpecial)) then
		setactive(self.mTrans_SoldOut.gameObject, true);
	end
	
	--self.mImage_ItemType.color = TableData.GetGlobalGun_Quality_Color2(data.rank);
	self.mImage_IconImage.sprite = UIUtils.GetIconSprite("Icon/Item",data.icon);

	-- if(data.price_type > 0) then
	-- 	local stcData = TableData.GetItemData(data.price_type);

	-- 	if(stcData == nil) then
	-- 		gferror("未知的PriceType"..data.price_type..",Item表里没有该ID");
	-- 	end
	-- 	self.mImage_PriceImage.sprite = UIUtils.GetIconSprite("Icon/Item",stcData.icon);
	-- end

	-- if(data.can_refresh) then
	-- 	setactive(self.mTrans_Refreshtime.gameObject,true);
	-- 	self.StartItemCountDown({data,self});
	-- end
end