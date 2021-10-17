QuickStorePurchase = {};
local this = QuickStorePurchase;

QuickStorePurchase.mCurRedirectTag = 0;

--在其他相关界面弹出xx不足需要购买的弹窗时，点击该弹窗的确定按钮即可完成商城中该商品的购买
function QuickStorePurchase.QuickPurchase(good_id,num, hint_id, cur_panel,OnBuyCallback,OnCancel, ...)

	self = QuickStorePurchase;
	
	local goodPrice = "-";
	local storeGoods = NetCmdStoreData:GetStoreGoodById(good_id);
	if(storeGoods ~= nil) then
		goodPrice = formatnum(tonumber(storeGoods.price));
	else
		gferror("未知的商品ID："..good_id.."!!");
		return;
	end
	
	local totalPrice = goodPrice * num;
	local diamond = NetTeamHandle:GetMaintainResDiomandNum();
	local isOutOfDiamond = false;
	if(diamond < totalPrice) then
		isOutOfDiamond = true;
	end
	
	local params = {};
	params[1] = good_id;
	params[2] = num;
	params[3] = OnBuyCallback;
	params[4] = isOutOfDiamond;
	params[5] = cur_panel;
	params[6] = OnCancel;
	local hint = TableData.GetHintById(hint_id);
	
	local msg = string_format(hint,totalPrice,TableData.GetItemData(1).name.str,num,TableData.GetItemData(GashaponNetCmdHandler.GachaTicketID).name.str,...);
	MessageBox.Show("注意", msg, params, self.OnBuyTicket, OnCancel);
	
end

--在其他功能中点击购买按钮，直接跳转打开该商品在商城中的购买页签
function QuickStorePurchase.RedirectToStoreTag(tag_id,cur_panel)

	gfdebug("RedirectToStoreTag")
	self = QuickStorePurchase;
	self.mCurRedirectTag = tag_id;
	--cur_panel.Close();
	--SceneSys:OpenStoreScene();
	UIManager.OpenUI(UIDef.UIStoreMainPanel);
	self.mCurRedirectTag = 0;
end

function QuickStorePurchase.OnBuyTicket(params)
	self = QuickStorePurchase;
	
	local isOutOfDiamond = params[4]
	if(isOutOfDiamond == true) then
		local msg = TableData.GetHintById(225);
		local name = TableData.GetItemData(1).Name.str;
		local msg = UIUtils.StringFormat(msg,name);
		--钻石不足,是否前往商场购买？
		CS.PopupMessageManager.PopupString(msg)
		--MessageBox.Show("注意", msg, MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
		--MessageBox.Show("注意", msg, params[5]);

		
		return;
	end
	
	NetCmdStoreData:SendStoreBuy(params[1],params[2],params[3]);
end

-- function QuickStorePurchase.OnBuyTicket(params)
-- 	self = QuickStorePurchase;
	
-- 	local isOutOfDiamond = params[4]
-- 	if(isOutOfDiamond == true) then
-- 		local msg = TableData.GetHintById(2);
-- 		--钻石不足,是否前往商场购买？
-- 		MessageBox.Show("注意", msg, params[5], self.OnGoToStore, params[6]);
-- 		return;
-- 	end
	
-- 	NetCmdStoreData:SendStoreBuy(params[1],params[2],params[3]);
-- end

function QuickStorePurchase.OnGoToStore(cur_panel)
	self = QuickStorePurchase;
	--cur_panel.Close();
	--SceneSys:OpenStoreScene();
	UIManager.OpenUI(UIDef.UIStoreMainPanel);
end

