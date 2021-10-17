require("UI.UIBaseCtrl")

UIGashaponFrontLayerItem = class("UIGashaponFrontLayerItem", UIBaseCtrl);
UIGashaponFrontLayerItem.__index = UIGashaponFrontLayerItem
--@@ GF Auto Gen Block Begin

UIGashaponFrontLayerItem.mImage = nil;
UIGashaponFrontLayerItem.mSmallImage = nil;
UIGashaponFrontLayerItem.mImgRankDown = nil;

UIGashaponFrontLayerItem.mBackLayerItem = nil;

function UIGashaponFrontLayerItem:__InitCtrl()
	self.mImage = self:GetImage("Front/IconMask/ItemIcon");
	self.mSmallImage = self:GetImage("Front/IconMask/SmallIcon");
	self.mImgRankDown = self:GetImage("Front/Rank_Down");
end

--@@ GF Auto Gen Block End

function UIGashaponFrontLayerItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIGashaponFrontLayerItem:InitImage(img,color)
	self.mImage.sprite = img;
	self.mImgRankDown.color = color;
end

function UIGashaponFrontLayerItem:InitSmallImage(img,color)
	setactive(self.mImage.gameObject,false);
	setactive(self.mSmallImage.gameObject,true);
	
	self.mSmallImage.sprite = img;
	self.mImgRankDown.color = color;
end

function UIGashaponFrontLayerItem:ConvertChipAnim(item)
	self.mBackLayerItem = item;

	local trans = self.mSmallImage.transform;
	local from = CS.UnityEngine.Vector3(0,90,0);
	local to = CS.UnityEngine.Vector3(0,0,0);
	local duration = 0.5;
	local delay = 1;
	
	setactive(self.mSmallImage.gameObject,true);
	CS.UITweenManager.PlayRotationTween(trans,from,to,duration,delay,nil,UIGachaResultPanel.mTweenExpo);
	CS.UITweenManager.PlayFadeTween(trans,1,0,duration,(2*duration + delay),nil,UIGachaResultPanel.mTweenExpo);	
	TimerSys:DelayCall(3*duration + delay, self.ConvertToChip, self);
end

function UIGashaponFrontLayerItem.ConvertToChip(item)
	if(CS.LuaUtils.IsNullOrDestroyed(item.mSmallImage)) then
		return;
	end

	local stcData = TableData.GetItemData(UIStoreConfirmPanelView.GUN_CORE_ID);
	local hintId = stcData.type + 1000;
	local trans = item.mSmallImage.transform;
	local duration = 0.5;
	CS.UITweenManager.PlayFadeTween(trans,0,1,duration,0,nil,UIGachaResultPanel.mTweenExpo);	

	item.mSmallImage.sprite = UIUtils.GetIconSprite("Icon/"..stcData.IconPath,stcData.icon);
	item.mBackLayerItem.mTxtName.text = stcData.name.str;
	item.mBackLayerItem.mImgType.sprite = UIUtils.GetIconSprite("Icon/ItemType","ItemTypeIcon_3");	
	item.mBackLayerItem.mTxtBottomType.text = GashaponNetCmdHandler:GetGachaItemType(hintId);

	local rankColor = TableData.GetGlobalGun_Quality_Color2(stcData.rank);
	item.mImgRankDown.color = rankColor;
	item.mBackLayerItem.mImgRank.color = rankColor;
	item.mBackLayerItem.mImgRankBG.color = rankColor;
	item.mBackLayerItem.mImgRankUp.color = rankColor;
	item.mBackLayerItem.mImgRankCardBG.color = rankColor;
	item.mBackLayerItem.mImgRankDown.color = rankColor;

	setactive(item.mBackLayerItem.mTxtNum.gameObject, true);
	setactive(item.mImage.gameObject,false);
	setactive(item.mSmallImage.gameObject,true);
end
