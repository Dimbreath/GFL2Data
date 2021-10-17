require("UI.UIBaseCtrl")

UIGoodsItem_Big = class("UIGoodsItem_Big", UIBaseCtrl);
UIGoodsItem_Big.__index = UIGoodsItem_Big
--@@ GF Auto Gen Block Begin
UIGoodsItem_Big.mImage_ItemType = nil;
UIGoodsItem_Big.mImage_GoodsRate = nil;
UIGoodsItem_Big.mImage_IconImage = nil;
UIGoodsItem_Big.mText_refreshtime = nil;
UIGoodsItem_Big.mText_AmountNumber = nil;
UIGoodsItem_Big.mText_Name = nil;
UIGoodsItem_Big.mText_PriceNumber = nil;
UIGoodsItem_Big.mTrans_Refreshtime = nil;
UIGoodsItem_Big.mTrans_Recommend = nil;
UIGoodsItem_Big.mTrans_UnavailableMask = nil;



function UIGoodsItem_Big:__InitCtrl()

	self.mImage_ItemType = self:GetImage("Image_ItemType");
	self.mImage_GoodsRate = self:GetImage("GoodsIcon/Image_GoodsRate");
	self.mImage_IconImage = self:GetImage("GoodsIcon/Image_IconImage");
	self.mText_refreshtime = self:GetText("Trans_Refreshtime/Text_refreshtime");
	self.mText_AmountNumber = self:GetText("Amount/Text_AmountNumber");
	self.mText_Name = self:GetText("GoodsName/Text_Name");
	self.mText_PriceNumber = self:GetText("Price/Text_PriceNumber");
	self.mTrans_Refreshtime = self:GetRectTransform("Trans_Refreshtime");
	self.mTrans_Recommend = self:GetRectTransform("Trans_Recommend");
	self.mTrans_UnavailableMask = self:GetRectTransform("Trans_UnavailableMask");
end
--@@ GF Auto Gen Block End


UIGoodsItem_Big.mImage_PriceImage = nil;

function UIGoodsItem_Big:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mImage_PriceImage = self:GetImage("Price/image_price");

end

function UIGoodsItem_Big:InitData(data)
	self.mData = data;
	
	self.mText_Name.text = data.name;
	local num = tonumber(data.price);
	self.mText_PriceNumber.text = formatnum(num);
	
	if(data.limit == 0) then
		self.mText_AmountNumber.text = "-";
	else
		self.mText_AmountNumber.text = data.remain_times;
	end
	
	if(data.IsRecommend) then
		setactive(self.mTrans_Recommend.gameObject, true);
	else
		setactive(self.mTrans_Recommend.gameObject, false);
	end
	
	if(data.remain_times == 0 and (data.limit ~= 0 or data.IsSpecial)) then
		setactive(self.mTrans_UnavailableMask.gameObject, true);
	end
	
	self.mImage_ItemType.color = TableData.GetGlobalGun_Quality_Color2(data.rank);
	--self.mImage_GoodsRate.color = TableData.GetGlobalGun_Quality_Color2(data.rank);
	self.mImage_IconImage.sprite = UIUtils.GetIconSprite("Icon/Item",data.icon);

	if(data.price_type > 0) then
		local stcData = TableData.GetItemData(data.price_type);
		if(stcData == nil) then
			gferror("未知的PriceType"..data.price_type..",Item表里没有该ID");
		end
		self.mImage_PriceImage.sprite = UIUtils.GetIconSprite("Icon/Item",stcData.icon);
	end

	if(data.can_refresh) then
		setactive(self.mTrans_Refreshtime.gameObject,true);
		self.StartItemCountDown({data,self});
	end
end

function UIGoodsItem_Big.StartItemCountDown(params)
	local item = params[2];
	local itemData = params[1];

	item.mCountDownTimer = TimerSys:DelayCall(1, item.StartItemCountDown, {itemData,item});
	item.mText_refreshtime.text = itemData.refresh_time;
	item.mText_AmountNumber.text = ""..itemData.remain_times;

	-- if(itemData.remain_times > 0 and itemData.IsSpecial) then
	-- 	setactive(item.mTrans_UnavailableMask.gameObject, false);
	-- 	local itemBtn = UIUtils.GetButtonListener(item.mUIRoot.gameObject);
	-- 	itemBtn.onClick = UIStorePanel.OnGoodsItemClicked;
	-- 	itemBtn.param = item;
	-- 	itemBtn.paramData = nil;
	-- end
end

function UIGoodsItem_Big:ReleaseTimer()
	if(self.mCountDownTimer ~= nil) then
		self.mCountDownTimer:Stop()
		-- TimerSys:Remove(self.mCountDownTimer);
		self.mCountDownTimer = nil;
	end
end

function UIGoodsItem_Big:OnHighlight()

end

