require("UI.UIBaseCtrl")

UIStoreDiamondItem = class("UIStoreDiamondItem", UIBaseCtrl);
UIStoreDiamondItem.__index = UIStoreDiamondItem
--@@ GF Auto Gen Block Begin
UIStoreDiamondItem.mBtn_Main = nil;
UIStoreDiamondItem.mImage_IconImage = nil;
UIStoreDiamondItem.mText_Name = nil;
UIStoreDiamondItem.mText_PriceNumber = nil;
UIStoreDiamondItem.mText_Price_PriceNumber = nil;

function UIStoreDiamondItem:__InitCtrl()

	self.mBtn_Main = self:GetButton("Btn_Main");
	self.mImage_IconImage = self:GetImage("Btn_Main/GoodsIcon/Image_IconImage");
	self.mText_Name = self:GetText("Btn_Main/GoodsName/Text_Name");
	self.mText_PriceNumber = self:GetText("Btn_Main/Price/Text_PriceNumber");
	self.mText_Price_PriceNumber = self:GetText("Shadow/UI_Price/Text_PriceNumber");
end

--@@ GF Auto Gen Block End

function UIStoreDiamondItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIStoreDiamondItem:InitData(data)
	self.mData = data;
	
	self.mText_Name.text = data.name;
	local num = tonumber(data.price);
	self.mText_PriceNumber.text = "<size=48>￥</size><size=78>".. formatnum(num) .."</size>" ;
	self.mText_Price_PriceNumber.text = "<size=48>￥</size><size=78>".. formatnum(num) .."</size>" ;
	
	-- if(data.limit == 0) then
	-- 	self.mText_AmountNumber.text = "-";
	-- else
	-- 	self.mText_AmountNumber.text = data.remain_times;
	-- end
	
	-- if(data.IsRecommend) then
	-- 	setactive(self.mTrans_Recommend.gameObject, true);
	-- else
	-- 	setactive(self.mTrans_Recommend.gameObject, false);
	-- end
	
	-- if(data.remain_times == 0 and (data.limit ~= 0 or data.IsSpecial)) then
	-- 	setactive(self.mTrans_UnavailableMask.gameObject, true);
	-- end
	
	--self.mImage_ItemType.color = TableData.GetGlobalGun_Quality_Color2(data.rank);
	--self.mImage_GoodsRate.color = TableData.GetGlobalGun_Quality_Color2(data.rank);
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