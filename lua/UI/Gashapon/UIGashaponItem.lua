require("UI.UIBaseCtrl")
require("UI.Gashapon.UIGashaponFrontLayerItem")

UIGashaponItem = class("UIGashaponItem", UIBaseCtrl);
UIGashaponItem.__index = UIGashaponItem

UIGashaponItem.mPath_GashaponFrontLayerItem = "Gashapon/UIGashaponFrontLayerItem.prefab";

UIGashaponItem.Trans_FronLayerLayout = nil;
--UI控件
UIGashaponItem.mButton = nil;
UIGashaponItem.mImage = nil;
UIGashaponItem.mSmallImage = nil;
UIGashaponItem.mImageBack = nil;
UIGashaponItem.mImage_Glow = nil;

UIGashaponItem.mTxtName = nil;
UIGashaponItem.mTxtNum = nil;
UIGashaponItem.mImgType = nil;
UIGashaponItem.mImgRank = nil;

UIGashaponItem.mImgRankBG = nil;
UIGashaponItem.mImgRankUp = nil;
UIGashaponItem.mImgRankCardBG = nil;
UIGashaponItem.mImgRankDown = nil;
UIGashaponItem.mTxtBottomType = nil;

UIGashaponItem.mCardInside_EffectTrans = nil;
UIGashaponItem.mCardBorder_EffectTrans = nil;
UIGashaponItem.mCardFlop_EffectTrans = nil;

--逻辑参数
UIGashaponItem.mIndex = 0;
UIGashaponItem.mData = nil;
UIGashaponItem.mStcData = nil;
UIGashaponItem.mIsFlipped = false;
UIGashaponItem.mIsFlipping = false;
UIGashaponItem.mIsBeingLongPressed = false;


UIGashaponItem.mObjFront = nil;
UIGashaponItem.mFrontLayerObj = nil;

UIGashaponItem.mFrontLayerItem = nil;

UIGashaponItem.mItemScreenPosX = 0;

function UIGashaponItem:__InitCtrl()
	self.mObjFront = self:GetImage("Front").gameObject;
	self.mImage = self:GetImage("Front/IconMask/ItemIcon");
	self.mSmallImage = self:GetImage("Front/IconMask/SmallIcon");
	self.mImageBack = self:GetImage("Back");
	self.mImage_Glow = self:GetImage("Glow");
	
	self.mTxtName = self:GetText("Front/NameBG/GunName");
	self.mTxtNum = self:GetText("Front/Botton/Num");
	self.mImgType = self:GetImage("Front/TypeIcon");
	self.mImgRank = self:GetImage("Front/Rank");
	
	self.mImgRankBG = self:GetImage("Front/Rank_BG");
	self.mImgRankUp = self:GetImage("Front/Rank_UP");
	self.mImgRankCardBG = self:GetImage("Front/Rank_CardBG");
	self.mImgRankDown = self:GetImage("Front/Rank_Down");
	
	self.mTxtBottomType = self:GetText("Front/Botton/Type");
	
	self.mCardInside_EffectTrans = self:GetRoot():Find("Front/CardInside_Effect");
	self.mCardBorder_EffectTrans = self:GetRoot():Find("Glow/CardBorder_Effect");
	self.mCardFlop_EffectTrans = self:GetRoot():Find("CardFlop_Effect");
end

function UIGashaponItem:InitCtrl(root)
	self:SetRoot(root);
	self:__InitCtrl();	
end

function UIGashaponItem:InitData(data)
	self.mData = data;
	self.mStcData = TableData.GetItemData(data.ItemId);
	if(self.mStcData == nil) then
		gferror("没有找到id是"..data.ItemId.."的道具");
	else
		self:InitItemInfo();
	end
end

function UIGashaponItem:SetIndex(index)
	self.mIndex = index;
end

function UIGashaponItem:SetItemScale(scale)	
	local s = Vector3(1/scale,1/scale,1/scale);
	setscale(self:GetRoot().transform, s);
	setscale(self.mFrontLayerObj.transform, s);
	
end

function UIGashaponItem:SetEffectScale(scale)
	UIUtils.SetChildrenScale(self.mCardInside_EffectTrans,scale,false);
	UIUtils.SetChildrenScale(self.mCardBorder_EffectTrans,scale,false);
	UIUtils.SetChildrenScale(self.mCardFlop_EffectTrans,scale,false);	
end

function UIGashaponItem:InitItemInfo()
	local name = self.mStcData.name;
	local icon = self.mStcData.icon;
	local rank = self.mStcData.rank;
	
	self.mTxtName.text = name.str;
	self.mTxtNum.text = tostring(self.mData.ItemNum);

	if(self.mStcData.type == 1) then	
		local gunData = TableData.GetGunData(1001);
		self.mImage.sprite = UIUtils.GetIconSprite("CharacterRes/"..gunData.code,"Head");
		self.mImgType.sprite = UIUtils.GetIconSprite("Icon/GunType","Combat_GunTypeIcon_"..tostring(gunData.duty));

	elseif(self.mStcData.type == 4) then	
		local gunData = TableData.GetGunData(tonumber(self.mStcData.args[0]));
		self.mImage.sprite = UIUtils.GetIconSprite("CharacterRes/"..gunData.code,"Head");
		self.mImgType.sprite = UIUtils.GetIconSprite("Icon/GunType","Combat_GunTypeIcon_"..tostring(gunData.duty));
	
	elseif(self.mStcData.type == 3) then
		setactive(self.mImage.gameObject,false);
		setactive(self.mSmallImage.gameObject,true);
		self.mSmallImage.sprite = UIUtils.GetIconSprite("Icon/"..self.mStcData.IconPath,icon);
		setactive(self.mImgType.gameObject,true);
		self.mImgType.sprite = UIUtils.GetIconSprite("Icon/ItemType","ItemTypeIcon_3");	
				
	elseif(self.mStcData.type == 6) then	
		local carrierData = TableData.GetCarrierBaseBodyData(tonumber(self.mStcData.args[0]));	
		self.mImage.sprite = UIUtils.GetIconSprite("Icon/Carrier",carrierData.icon);	
		setactive(self.mImgType.gameObject,true);
		self.mImgType.sprite = UIUtils.GetIconSprite("Icon/ItemType","ItemTypeIcon_8");	
		
	elseif(self.mStcData.type == 8) then
		setactive(self.mImage.gameObject,false);
		setactive(self.mSmallImage.gameObject,true);
		self.mSmallImage.sprite = UIUtils.GetIconSprite("Icon/"..self.mStcData.IconPath,icon);
		setactive(self.mImgType.gameObject,true);
		
		self.mImgType.sprite = UIUtils.GetIconSprite("Icon/ItemType","ItemTypeIcon_8");	
		
	elseif(self.mStcData.type == 5) then
		setactive(self.mImage.gameObject,false);
		setactive(self.mSmallImage.gameObject,true);
		self.mSmallImage.sprite = UIUtils.GetIconSprite("Icon/"..self.mStcData.IconPath,icon);
		setactive(self.mImgType.gameObject,true);		
		self.mImgType.sprite = UIUtils.GetIconSprite("Icon/ItemType","ItemTypeIcon_5");

	elseif(self.mStcData.type == 12) then
		local gunData = TableData.GetGunData(tonumber(self.mStcData.args[0]));
		self.mImage.sprite = UIUtils.GetIconSprite("CharacterRes/"..gunData.code,"Head");
		self.mImgType.sprite = UIUtils.GetIconSprite("Icon/GunType","Combat_GunTypeIcon_"..tostring(gunData.duty));

		--setactive(self.mTxtNum.gameObject, false);
	end

	if(self.mStcData.id == UIStoreConfirmPanelView.GUN_CORE_ID) then
		self.mSmallImage.sprite = UIUtils.GetIconSprite("Icon/"..self.mStcData.IconPath,icon);
	end
	
	local hintId = self.mStcData.type + 1000;
	self.mTxtBottomType.text = GashaponNetCmdHandler:GetGachaItemType(hintId);
	
	local rankColor = TableData.GetGlobalGun_Quality_Color2(rank);
	self.mImgRank.color = rankColor;
	self.mImgRankBG.color = rankColor;
	self.mImgRankUp.color = rankColor;
	self.mImgRankCardBG.color = rankColor;
	self.mImgRankDown.color = rankColor;
	
	
	self.mImage_Glow.color = Color(rankColor.r,rankColor.g,rankColor.b,0);
	
	setactive(self.mImageBack.gameObject, true);
	setactive(self.mObjFront,false);
	
	UIUtils.SetGachaEffectMaterailColor(self.mCardInside_EffectTrans,rankColor);
	UIUtils.SetGachaEffectMaterailColor(self.mCardBorder_EffectTrans,rankColor);
	UIUtils.SetGachaEffectMaterailColor(self.mCardFlop_EffectTrans,rankColor);
	
	self:InitFrontLayer(rankColor);
end

function UIGashaponItem:InitFrontLayer(rankColor)
	local prefab = UIUtils.GetGizmosPrefab(self.mPath_GashaponFrontLayerItem,self);
	local instObj = instantiate(prefab);
	local item = UIGashaponFrontLayerItem.New();
	item:InitCtrl(instObj.transform);
	
	if(self.mStcData.type == 4 or self.mStcData.type == 6) then	
		item:InitImage(self.mImage.sprite,rankColor);
	else
		item:InitSmallImage(self.mSmallImage.sprite,rankColor);
	end
	self.mFrontLayerItem = item;
	
	UIUtils.AddListItem(instObj, UIGachaResultPanel.Trans_FronLayerLayout.transform);
	
	setactive(instObj,false);
	
	local to =  vectorzero;
	local offset = 0;
	if(self.mIndex ~= 0) then
		offset = self.mIndex - 5.5;
	end
		
	to = to + CS.UnityEngine.Vector3(UIGachaResultPanel.mItemSpace * offset ,0,0);
		
	instObj.transform.localPosition = to;
	
	self.mFrontLayerObj = instObj;
	self.mItemScreenPosX = UIGachaResultPanel.mCamera:WorldToScreenPoint(instObj.transform.position).x;
end

function UIGashaponItem:ShowFrontLayer()
	if(CS.LuaUtils.IsNullOrDestroyed(self.mFrontLayerObj)) then
		return;
	end
	setactive(self.mFrontLayerObj,true);
end

function UIGashaponItem:ShowCard()
	if(CS.LuaUtils.IsNullOrDestroyed(self.mObjFront)) then
		return;
	end
	self:HideGlow();
	self.mIsFlipped = true;
	self.mIsBeingLongPressed = false;
	
	setactive(self.mObjFront,true);
	setactive(self.mImageBack.gameObject, false);
	
	if(self.mStcData.id == UIStoreConfirmPanelView.GUN_CORE_ID) then
		setactive(self.mCardFlop_EffectTrans.gameObject,true);
		setactive(self.mCardBorder_EffectTrans.gameObject,true);
	end
end

function UIGashaponItem:ConvertChipAnim()

	if(self.mStcData.id == UIStoreConfirmPanelView.GUN_CORE_ID and self.mData.ItemNum > 0) then
		self.mFrontLayerItem:ConvertChipAnim(self);
	end
end

function UIGashaponItem:ShowGlow()
	if(self.mIsFlipped == true) then
		return;
	end
	setactive(self.mCardBorder_EffectTrans.gameObject,true);
end

function UIGashaponItem:HideGlow()
	if(self.mIsFlipped == true) then
		return;
	end
	CS.UITweenManager.KillTween(self.mImage_Glow.transform);
	setactive(self.mCardBorder_EffectTrans.gameObject,false);
end

function UIGashaponItem:CheckSwipeOpen(xPos,xStart,dir)
	local itemX = self.mItemScreenPosX;
	
	if(xPos > itemX and itemX > xStart and dir == CS.SwipeDirection.Right) then
		self.mIsFlipping = true;
		if(self.mStcData.id == UIStoreConfirmPanelView.GUN_CORE_ID) then
			self:ShowGlow();
			return false;
		end
		return true;
	end
	
	if(xPos < itemX and itemX < xStart and dir == CS.SwipeDirection.Left) then
		self.mIsFlipping = true;
		if(self.mStcData.id == UIStoreConfirmPanelView.GUN_CORE_ID) then
			self:ShowGlow();
			return false;
		end
		return true;	
	end
	
	return false;
end

function UIGashaponItem:DestroySelf()
	UIGashaponItem.Trans_FronLayerLayout = nil;
	gfdestroy(self.mFrontLayerObj.gameObject);
	gfdestroy(self:GetRoot());
end