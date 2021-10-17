require("UI.UIBaseCtrl")

StoreCoin = class("StoreCoin", UIBaseCtrl);
StoreCoin.__index = StoreCoin
--@@ GF Auto Gen Block Begin
StoreCoin.mImage_CoinImage = nil;
StoreCoin.mText_CoinAmount = nil;

function StoreCoin:__InitCtrl()

	self.mImage_CoinImage = self:GetImage("Image_CoinImage");
	self.mText_CoinAmount = self:GetText("Text_CoinAmount");
end

--@@ GF Auto Gen Block End

function StoreCoin:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function StoreCoin:InitData(item_id)
	local stcData = TableData.GetItemData(item_id);
	if(stcData ~= nil and stcData.type ~= 1) then
		local data = NetCmdItemData:GetNormalItem(item_id);
		if(data ~= nil) then
			self.mText_CoinAmount.text = data.item_num;
		else
			self.mText_CoinAmount.text = 0;
		end
	elseif(stcData.id == 1) then
		self.mText_CoinAmount.text = GlobalData.diamond;
	elseif(stcData.id == 2) then
		self.mText_CoinAmount.text = GlobalData.cash;
	end
	self.mImage_CoinImage.sprite = UIUtils.GetIconSprite("Icon/Item",stcData.icon);
end