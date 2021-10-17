require("UI.UIBaseCtrl")

UIGashaponItemNew = class("UIGashaponItemNew", UIBaseCtrl);
UIGashaponItemNew.__index = UIGashaponItemNew
--@@ GF Auto Gen Block Begin

--逻辑参数
UIGashaponItemNew.mData = nil;
UIGashaponItemNew.mStcData = nil;
UIGashaponItemNew.mIsFlipped = false;
UIGashaponItemNew.mIsFlipping = false;
UIGashaponItemNew.mIsBeingLongPressed = false;

UIGashaponItemNew.mObjFront = nil;

function UIGashaponItemNew:__InitCtrl()

end

--@@ GF Auto Gen Block End

function UIGashaponItemNew:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIGashaponItemNew:InitData(data)
	self.mData = data;
	self.mStcData = TableData.GetItemData(data.item_id);
	if(self.mStcData == nil) then
		gferror("没有找到id是"..data.item_id.."的道具");
	else
		self:InitItemInfo();
	end
end

function UIGashaponItemNew:InitItemInfo()
	local name = self.mStcData.name;
	local icon = self.mStcData.icon;
	local rank = self.mStcData.rank;
	
	self.mTxtName.text = name.str;
	self.mTxtNum.text = tostring(self.mData.num);
	
	if(self.mStcData.type == 4) then	
		local gunData = TableData.GetGunData(tonumber(self.mStcData.args[0]));
		gfdebug(gunData.code);
		self.mImage.sprite = UIUtils.GetIconSprite("CharacterRes/"..gunData.code,"Head");
		self.mImgType.sprite = UIUtils.GetIconSprite("Icon/GunType","Combat_GunTypeIcon_"..tostring(gunData.typeInt));
	
	elseif(self.mStcData.type == 3) then
		self.mImage.sprite = UIUtils.GetIconSprite("Icon/Item",icon);
		setactive(self.mImgType.gameObject,false);
				
	elseif(self.mStcData.type == 6) then	
		local carrierData = TableData.GetCarrierBaseBodyData(tonumber(self.mStcData.args[0]));	
		self.mImage.sprite = UIUtils.GetIconSprite("Icon/Carrier",carrierData.icon);	
		setactive(self.mImgType.gameObject,false);
		
	elseif(self.mStcData.type == 8) then
		self.mImage.sprite = UIUtils.GetIconSprite("Icon/Skill",icon);
		setactive(self.mImgType.gameObject,false);
		
	else
	
	end
	
	local rankColor = TableData.GetGlobalGun_Quality_Color2(rank);
	self.mImgRank.color = rankColor;
	self.mImage_Glow.color = Color(rankColor.r,rankColor.g,rankColor.b,0);
	
	setactive(self.mImageBack.gameObject, true);
	setactive(self.mObjFront,false);
end

function UIGashaponItemNew:ShowCard()
	self:HideGlow();
	self.mIsFlipped = true;
	self.mIsBeingLongPressed = false;
	
	setactive(self.mObjFront,true);
	setactive(self.mImageBack.gameObject, false);
end

function UIGashaponItemNew:ShowGlow()
	if(self.mIsFlipped == true) then
		return;
	end
	CS.UITweenManager.PlayFadeTweens(self.mImage_Glow.transform,0,0.4,0.5);
end

function UIGashaponItemNew:HideGlow()
	if(self.mIsFlipped == true) then
		return;
	end
	CS.UITweenManager.KillTween(self.mImage_Glow.transform);
	CS.UITweenManager.PlayFadeTweens(self.mImage_Glow.transform,0.4,0,0.1);
end

function UIGashaponItemNew:CheckSwipeOpen(xPos,xStart,dir)
	
	local itemX = self.mImageBack.transform.position.x;
	if(xPos > itemX and itemX > xStart and dir == CS.SwipeDirection.Right) then
		self.mIsFlipping = true;
		if(self.mStcData.rank >= 5) then
			self:ShowGlow();
			return false;
		end
		return true;
	end
	
	if(xPos < itemX and itemX < xStart and dir == CS.SwipeDirection.Left) then
		self.mIsFlipping = true;
		if(self.mStcData.rank >= 5) then
			self:ShowGlow();
			return false;
		end
		return true;	
	end
	
	return false;
end