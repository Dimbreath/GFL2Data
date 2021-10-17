require("UI.UIBaseCtrl")

UIGachaDropDetailItem = class("UIGachaDropDetailItem", UIBaseCtrl);
UIGachaDropDetailItem.__index = UIGachaDropDetailItem
--@@ GF Auto Gen Block Begin
UIGachaDropDetailItem.mBtn_GachaInfo = nil;
UIGachaDropDetailItem.mBtn_DropRate = nil;
UIGachaDropDetailItem.mBtn_ComfirmBtn = nil;
UIGachaDropDetailItem.mImage_ADImage = nil;
UIGachaDropDetailItem.mText_TitleText = nil;
UIGachaDropDetailItem.mText_NewArriveMessage = nil;
UIGachaDropDetailItem.mText_CommonHintMessage = nil;
UIGachaDropDetailItem.mVLayout_GunRateList = nil;
UIGachaDropDetailItem.mVLayout_WeaponRateList = nil;
UIGachaDropDetailItem.mTrans_DetailPanel = nil;
UIGachaDropDetailItem.mTrans_RatePanel = nil;
UIGachaDropDetailItem.mTrans_GunRate = nil;
UIGachaDropDetailItem.mTrans_WeaponRate = nil;

UIGachaDropDetailItem.mPath_Prefab = "Gashapon/UIGachaDropDetailPanel.prefab"

function UIGachaDropDetailItem:__InitCtrl()

	self.mBtn_GachaInfo = self:GetButton("MessagePanel/ButtonList/Btn_GachaInfo");
	self.mBtn_DropRate = self:GetButton("MessagePanel/ButtonList/Btn_DropRate");
	self.mBtn_ComfirmBtn = self:GetButton("MessagePanel/Btn_ComfirmBtn");
	self.mImage_ADImage = self:GetImage("MessagePanel/DetailMask/Trans_DetailPanel/Message/ImagePanel/Image_ADImage");
	self.mText_TitleText = self:GetText("MessagePanel/Top/Text_TitleText");
	self.mText_NewArriveMessage = self:GetText("MessagePanel/DetailMask/Trans_DetailPanel/Message/Text_NewArriveMessage");
	self.mText_CommonHintMessage = self:GetText("MessagePanel/DetailMask/Trans_DetailPanel/Message/Text_CommonHintMessage");
	self.mVLayout_GunRateList = self:GetVerticalLayoutGroup("MessagePanel/DetailMask/Trans_RatePanel/RateDetail/Trans_GunRate/VLayout_GunRateList");
	self.mVLayout_WeaponRateList = self:GetVerticalLayoutGroup("MessagePanel/DetailMask/Trans_RatePanel/RateDetail/Trans_WeaponRate/VLayout_WeaponRateList");
	self.mTrans_DetailPanel = self:GetRectTransform("MessagePanel/DetailMask/Trans_DetailPanel");
	self.mTrans_RatePanel = self:GetRectTransform("MessagePanel/DetailMask/Trans_RatePanel");
	self.mTrans_GunRate = self:GetRectTransform("MessagePanel/DetailMask/Trans_RatePanel/RateDetail/Trans_GunRate");
	self.mTrans_WeaponRate = self:GetRectTransform("MessagePanel/DetailMask/Trans_RatePanel/RateDetail/Trans_WeaponRate");
end

--@@ GF Auto Gen Block End

UIGachaDropDetailItem.mData = nil;
UIGachaDropDetailItem.mView = nil;
UIGachaDropDetailItem.mTrans_RateDetail = nil;

UIGachaDropDetailItem.mIsInited = false;

function UIGachaDropDetailItem:InitCtrl(parent)
	local instObj = instantiate(UIUtils.GetGizmosPrefab(self.mPath_Prefab,self));
	obj=instObj

	self:SetRoot(instObj.transform);
	UIGachaDropDetailItem.mView = self;

	instObj.transform:SetParent(parent.transform,false);
	self:__InitCtrl();
	self.mTrans_RateDetail = self:GetRectTransform("MessagePanel/DetailMask/Trans_RatePanel/RateDetail");

	self:InitButton();
	
	return obj
end

function UIGachaDropDetailItem:InitData(data)
	self.mData = data;

	self.OnDetailClicked(nil);
end

function UIGachaDropDetailItem:InitButton()
	UIUtils.GetListener(self.mBtn_DropRate.gameObject).onClick = self.OnDropRateClicked;
	UIUtils.GetListener(self.mBtn_GachaInfo.gameObject).onClick = self.OnDetailClicked;
	UIUtils.GetListener(self.mBtn_ComfirmBtn.gameObject).onClick = self.OnConfirmClicked;
end

function UIGachaDropDetailItem.OnDropRateClicked(obj)
	self = UIGachaDropDetailItem.mView;
	setactive(self.mTrans_RatePanel,true);
	setactive(self.mTrans_DetailPanel,false);

	if(not UIGachaDropDetailItem.mIsInited) then
		self:InitDropRate();
	end
end

function UIGachaDropDetailItem:InitDropRate()
	local gunRateDict = self.mData.GunRateDict;

	for k,v in pairs(gunRateDict) do
		local item = UIGachaItemRateItem.New();

    	item:InitCtrl(self.mVLayout_GunRateList.transform);
		item:InitGunData(k,v);

	end

	UIUtils.ForceRebuildLayout(self.mVLayout_GunRateList.transform);

	local weaponRateDict = self.mData.WeaponRateDict;
	if(weaponRateDict.Count == 0) then
		setactive(self.mTrans_WeaponRate,false);
		UIGachaDropDetailItem.mIsInited = true;

		UIUtils.ForceRebuildLayout(self.mTrans_RateDetail);
		TimerSys:DelayCall(0.1 ,function(idx) 
			UIUtils.ForceRebuildLayout(self.mTrans_RateDetail);
		end,0);

		return;
	end

	for k,v in pairs(weaponRateDict) do
		local item = UIGachaItemRateItem.New();

    	item:InitCtrl(self.mVLayout_WeaponRateList.transform);
		item:InitWeaponData(k,v);
		
	end

	UIGachaDropDetailItem.mIsInited = true;

	UIUtils.ForceRebuildLayout(self.mVLayout_WeaponRateList.transform);
	UIUtils.ForceRebuildLayout(self.mTrans_RateDetail);
	TimerSys:DelayCall(0.1 ,function(idx) 
		UIUtils.ForceRebuildLayout(self.mTrans_RateDetail);
	end,0);
	
end

function UIGachaDropDetailItem.OnDetailClicked(obj)
	self = UIGachaDropDetailItem.mView;
	setactive(self.mTrans_RatePanel,false);
	setactive(self.mTrans_DetailPanel,true);
	
	self:InitGachaInfo();
end

function UIGachaDropDetailItem:InitGachaInfo()
	self.mText_NewArriveMessage.text = self.mData.NewArrive;
	self.mText_CommonHintMessage.text = self.mData.CommonHint;
	self.mImage_ADImage.sprite = UIUtils.GetIconSprite("Gashapon/Res",self.mData.GachaBanner);

	UIUtils.ForceRebuildLayout(self.mTrans_DetailPanel);
	TimerSys:DelayCall(0.1 ,function(idx) 
		UIUtils.ForceRebuildLayout(self.mTrans_RateDetail);
	end,0);
end


function UIGachaDropDetailItem.OnConfirmClicked(obj)
	self = UIGachaDropDetailItem.mView;
	UIGachaDropDetailItem.mIsInited = false;
	gfdestroy(self:GetRoot().gameObject);
end


