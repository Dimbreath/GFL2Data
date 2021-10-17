require("UI.UIBaseCtrl")
require("UI.DismantlingResult.UIDismantlingResultItem")

UIDismantlingResult = class("UIDismantlingResult", UIBaseCtrl);
UIDismantlingResult.__index = UIDismantlingResult
--@@ GF Auto Gen Block Begin
UIDismantlingResult.mBtn_ComfirmBtn = nil;
UIDismantlingResult.mBtn_ButtonDouble_CancelBtn = nil;
UIDismantlingResult.mBtn_ButtonDouble_ComfirmBtn = nil;
UIDismantlingResult.mImage_DismantlingResultTop = nil;
UIDismantlingResult.mImage_ButtonDouble_ComfirmBtn = nil;
UIDismantlingResult.mText_Massage_DismantlingResultWarning_Cost = nil;
UIDismantlingResult.mTrans_Massage_DismantlingResultItemList = nil;
UIDismantlingResult.mTrans_Massage_DismantlingResultWarning = nil;
UIDismantlingResult.mTrans_ButtonDouble = nil;

function UIDismantlingResult:__InitCtrl()

	self.mBtn_ComfirmBtn = self:GetButton("MessagePanel/BtnPanel/Btn_ComfirmBtn");
	self.mBtn_ButtonDouble_CancelBtn = self:GetButton("MessagePanel/BtnPanel/UI_Trans_ButtonDouble/Btn_CancelBtn");
	self.mBtn_ButtonDouble_ComfirmBtn = self:GetButton("MessagePanel/BtnPanel/UI_Trans_ButtonDouble/Image_Btn_ComfirmBtn");
	self.mImage_DismantlingResultTop = self:GetImage("MessagePanel/Background/Image_DismantlingResultTop");
	self.mImage_ButtonDouble_ComfirmBtn = self:GetImage("MessagePanel/BtnPanel/UI_Trans_ButtonDouble/Image_Btn_ComfirmBtn");
	self.mText_Massage_DismantlingResultWarning_Cost = self:GetText("MessagePanel/Background/UI_Massage/UI_Trans_DismantlingResultWarning/Text_Cost");
	self.mTrans_Massage_DismantlingResultItemList = self:GetRectTransform("MessagePanel/Background/UI_Massage/Trans_DismantlingResultItemList");
	self.mTrans_Massage_DismantlingResultWarning = self:GetRectTransform("MessagePanel/Background/UI_Massage/UI_Trans_DismantlingResultWarning");
	self.mTrans_ButtonDouble = self:GetRectTransform("MessagePanel/BtnPanel/UI_Trans_ButtonDouble");
end

--@@ GF Auto Gen Block End

UIDismantlingResult.mResultsItemList = nil;
UIDismantlingResult.mPathItem = "Character/UIDismantlingResultItem.prefab";
UIDismantlingResult.mTempItemIds = nil;
UIDismantlingResult.mAugmentGunIds = nil;

UIDismantlingResult.mOrigTitleColorStr = "#399AB9FF";
UIDismantlingResult.mOrigTitleColor = Color.white;
UIDismantlingResult.mWarningConfirmColorStr =  "#ef4c04";
UIDismantlingResult.mWarningColor = Color.white;
UIDismantlingResult.mOrigConfirmColorStr =  "#FFB400FF";
UIDismantlingResult.mOrigConfirmColor = Color.white;

function UIDismantlingResult:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self:SetActive(true);

	self.mOrigTitleColor = CSUIUtils.ConvertEngineColor(self.mOrigTitleColorStr);
	self.mWarningColor = CSUIUtils.ConvertEngineColor(self.mWarningConfirmColorStr);
	self.mOrigConfirmColor = CSUIUtils.ConvertEngineColor(self.mOrigConfirmColorStr);

	UIUtils.GetButtonListener(self.mBtn_ButtonDouble_ComfirmBtn.gameObject).onClick = self.OnConfirmClick;
	UIUtils.GetButtonListener(self.mBtn_ButtonDouble_CancelBtn.gameObject).onClick = self.OnCancelClick;

	self.mResultsItemList = List:New(UIDismantlingResultItem);
	self.mAugmentGunIds = List:New(CS.System.Int32);
	self.mTempItemIds = {};
end

function UIDismantlingResult:SetStateAugmented()
	self.mImage_DismantlingResultTop.color = self.mWarningColor;
	self.mImage_ButtonDouble_ComfirmBtn.color = self.mWarningColor;
	setactive(self.mTrans_Massage_DismantlingResultWarning.gameObject, true);
end

function UIDismantlingResult:SetStateNormal()
	self.mImage_DismantlingResultTop.color = self.mOrigTitleColor;
	self.mImage_ButtonDouble_ComfirmBtn.color = self.mOrigConfirmColor;
	setactive(self.mTrans_Massage_DismantlingResultWarning.gameObject, false);
end

function UIDismantlingResult:SetAugmentGuns(gunItems)
	self.mAugmentGunIds:Clear();
	for i = 1, gunItems:Count() do
		self.mAugmentGunIds:Add(gunItems[i].GunInfo.id);
		local gun = NetTeamHandle:GetGunByID(gunItems[i].GunInfo.id);
		local gunData = TableData.GetGunData(gun.stc_gun_id);
		local prizeData = TableData.GetPrizeData(gunData.dismantling_prize);

		--要从prize的itemlist里面拿到item
		for i = 0, prizeData.itemlist.Count - 1 do
			local itemId = prizeData.itemlist[i].item.id;
			if self.mTempItemIds[itemId] == nil then
				self.mTempItemIds[itemId] = prizeData.itemlist[i].num;
			else
				self.mTempItemIds[itemId] = self.mTempItemIds[itemId] + prizeData.itemlist[i].num;
			end
		end
	end

	for itemId, itemNum in pairs(self.mTempItemIds) do
		print("itemid = ".. itemId.."     item num = "..itemNum);
		if itemNum ~= nil then
			self:SetChildren(itemId, itemNum)
		end
	end
end

function UIDismantlingResult:SetChildren(itemId, num)
	local item = UIDismantlingResultItem.New();
	local prefab = UIUtils.GetGizmosPrefab(self.mPathItem,self);
	local insPrefab = instantiate(prefab);

	UIUtils.AddListItem(insPrefab, self.mTrans_Massage_DismantlingResultItemList.transform);

	item:InitCtrl(insPrefab.transform);
	item:SetData(itemId, num);
	self.mResultsItemList:Add(item);
end

function UIDismantlingResult:SetViewActive(active)
	self:SetActive(active);

	if not active then
		for i = 1, self.mResultsItemList:Count() do
			self.mResultsItemList[i]:DestroySelf();
		end

		self.mResultsItemList:Clear();
	end
end

function UIDismantlingResult.OnConfirmClick(gameObject)
	FacilityBarrackData.SendDismantlingGun(UIDismantlingResult.mAugmentGunIds);
end

function UIDismantlingResult.OnCancelClick(gameObject)
	UIDismantlingResult.Close();
end

function UIDismantlingResult.Close()
	UIDismantlingResult:SetViewActive(false);
end