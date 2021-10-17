require("UI.UIBaseCtrl")

UIVehicleCardElementMainItem = class("UIVehicleCardElementMainItem", UIBaseCtrl);
UIVehicleCardElementMainItem.__index = UIVehicleCardElementMainItem

UIVehicleCardElementMainItem.mText_UI_Level = nil;
UIVehicleCardElementMainItem.mText_UI_Load = nil;
UIVehicleCardElementMainItem.mText_UI_Number = nil;
UIVehicleCardElementMainItem.mImage_UIVehicleCardElementMainItem = nil;
UIVehicleCardElementMainItem.mImage_UI_VehiclePicture = nil;
UIVehicleCardElementMainItem.mImage_UI_Rarity = nil;
UIVehicleCardElementMainItem.mImage_UI_RarityBottom = nil;
UIVehicleCardElementMainItem.mImage_UI_Locked = nil;
UIVehicleCardElementMainItem.mImage_UI_Stars = nil;
UIVehicleCardElementMainItem.mImage_UI_InUsing = nil;
UIVehicleCardElementMainItem.mImage_UI_SelectedFrame = nil;
UIVehicleCardElementMainItem.mImage_UI_SelectedFrameDismantling = nil;
UIVehicleCardElementMainItem.mImage_UI_SelectedFrameLock = nil;
UIVehicleCardElementMainItem.mButton_UIVehicleCardElementMainItem = nil;

--UI路径
UIVehicleCardElementMainItem.mPath_UI_Star = "UIStar.prefab";

--逻辑参数
UIVehicleCardElementMainItem.mIsSelected = false;
UIVehicleCardElementMainItem.mIsDismantling = false;
UIVehicleCardElementMainItem.mIsLock = false;
UIVehicleCardElementMainItem.mCarrierData = nil;
UIVehicleCardElementMainItem.mStcCarrierData = nil;
UIVehicleCardElementMainItem.mStcCarrierPrefixData = nil;

UIVehicleCardElementMainItem.mCarrierDataHandler = nil;
UIVehicleCardElementMainItem.mNetCarrierHandler = nil;

--构造
function UIVehicleCardElementMainItem:ctor()
	UIVehicleCardElementMainItem.super.ctor(self);
end

function UIVehicleCardElementMainItem:InitCtrl(root)

	self:SetRoot(root);

	self.mText_UI_Level = self:GetText("UI_Level");
	self.mText_UI_Load = self:GetText("UI_Load");
	self.mText_UI_Number = self:GetText("UI_InUsing/UI_Number");
	self.mImage_UIVehicleCardElementMainItem = self:GetImage("Canvas/");
	self.mImage_UI_VehiclePicture = self:GetImage("UI_VehiclePicture");
	self.mImage_UI_Rarity = self:GetImage("UI_Rarity");
	self.mImage_UI_RarityBottom = self:GetImage("ButtomBlack/Orange")
	self.mImage_UI_Locked = self:GetImage("UI_Locked");
	self.mImage_UI_Stars = self:GetImage("UI_Stars");
	self.mImage_UI_InUsing = self:GetImage("UI_InUsing");
	self.mImage_UI_SelectedFrame = self:GetImage("UI_SelectedFrame");
	self.mImage_UI_SelectedFrameDismantling = self:GetImage("UI_SelectedFrameDismantling");
	self.mImage_UI_SelectedFrameLock = self:GetImage("UI_SelectedFrameLock");
	self.mButton_UIVehicleCardElementMainItem = self:GetButton("Canvas/");
	
	setactive(self.mImage_UI_SelectedFrame.gameObject,false);
	setactive(self.mImage_UI_SelectedFrameDismantling.gameObject,false);

end

function UIVehicleCardElementMainItem:SetCarriedItemData(data)
	self.mCarrierData = data;
	self.mStcCarrierData = TableData.GetCarrierBaseBodyData(data.stc_carrier_id);
	self.mStcCarrierPrefixData = TableData.GetCarrierPrefixData(data.prefix);
	if data.locked == 0 then
		self.mIsLock = false;
	else
		self.mIsLock = true;
	end
	
	self.mImage_UI_Rarity.color = TableData.GetGlobalGun_Quality_Color1(self.mStcCarrierData.rank);
	self.mImage_UI_RarityBottom.color = TableData.GetGlobalGun_Quality_Color1(self.mStcCarrierData.rank);
	self.mText_UI_Level.text = data.level;
	setactive(self.mImage_UI_Locked.gameObject,self.mIsLock);
	
	local curLoad = CarrierTrainNetCmdHandler:GetCarrierCurrentLoad(data.id);
	--local maxLoad = TableData.GetCarrierMaxLoad(self.mCarrierData);
	local maxLoad = data.prop.max_bearing;
	self.mText_UI_Load.text = curLoad .. "/" .. maxLoad;
	
	if data.team_id ~= 0 then
		setactive(self.mImage_UI_InUsing.gameObject,true);
		self.mText_UI_Number.text = data.team_id;
	else
		setactive(self.mImage_UI_InUsing.gameObject,false);
	end
	
	
	self:InitStars(data);
end

function UIVehicleCardElementMainItem:InitStars(data)
	self:ClearStars();
	local starCount = data.star;
	local prefab = UIUtils.GetGizmosPrefab(self.mPath_UI_Star,self);
	for i = 1, starCount, 1 do 
		local prefabInst = instantiate(prefab);
		UIUtils.AddListItem(prefabInst, self.mImage_UI_Stars.transform);
	end
end

function UIVehicleCardElementMainItem:SetNormalSelected(isSelected)
	setactive(self.mImage_UI_SelectedFrame.gameObject,isSelected);
	self.mIsSelected = isSelected;
end

function UIVehicleCardElementMainItem:SetDismantling(isDismantling)
	setactive(self.mImage_UI_SelectedFrameDismantling.gameObject,isDismantling);
	self.mIsDismantling = isDismantling;
end

function UIVehicleCardElementMainItem:SetLock(isLock,callback)
	CarrierTrainNetCmdHandler:ReqCarrierLockAndUnLock(self.mCarrierData.id,callback);
end

function UIVehicleCardElementMainItem:DoLockOrUnlock ()
		self.mIsLock = not self.mIsLock;		
		setactive(self.mImage_UI_SelectedFrameLock.gameObject,self.mIsLock);		
		setactive(self.mImage_UI_Locked.gameObject,self.mIsLock);
		
		if self.mIsLock == true then
			self.mCarrierData.locked = 1;
		else
			self.mCarrierData.locked = 0;
		end
end

function UIVehicleCardElementMainItem:ShowLockFrame()
	setactive(self.mImage_UI_SelectedFrameLock.gameObject,self.mIsLock);
end

function UIVehicleCardElementMainItem:HideLockFrame()
	setactive(self.mImage_UI_SelectedFrameLock.gameObject,false);
end

function UIVehicleCardElementMainItem:ClearStars()
	local tr = self.mImage_UI_Stars.transform;
	local count = tr.childCount;
	for i = count - 1, 0, -1 do
		gfdestroy(tr:GetChild(i).gameObject);
	end
end

function UIVehicleCardElementMainItem:SetActive(isActive)
	setactive(self:GetRoot(),isActive);
end

function UIVehicleCardElementMainItem:IsActive()
	return self:GetRoot().gameObject.activeSelf;
end





