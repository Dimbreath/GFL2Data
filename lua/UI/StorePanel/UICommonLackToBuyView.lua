require("UI.UIBaseView")
require("UI.StorePanel.Item.StoreLackToBuyCoin")

UICommonLackToBuyView = class("UICommonLackToBuyView", UIBaseView);
UICommonLackToBuyView.__index = UICommonLackToBuyView

--@@ GF Auto Gen Block Begin
UICommonLackToBuyView.mBtn_Cancel = nil;
UICommonLackToBuyView.mBtn_Confirm = nil;
UICommonLackToBuyView.mText_Name = nil;
UICommonLackToBuyView.mText_Title = nil;
UICommonLackToBuyView.mText_Des = nil;
UICommonLackToBuyView.mText_label = nil;
UICommonLackToBuyView.mHLayout_ItemList = nil;
UICommonLackToBuyView.mTrans_ItemList = nil;

function UICommonLackToBuyView:__InitCtrl()

	self.mBtn_Cancel = self:GetButton("BG/ButtonPanel/Btn_Cancel");
	self.mBtn_Confirm = self:GetButton("BG/ButtonPanel/Btn_Confirm");
	self.mText_Name = self:GetText("Text_Name");
	self.mText_Title = self:GetText("BG/Title/Text_Title");
	self.mText_Des = self:GetText("BG/DesPanel/Text_Des");
	self.mText_label = self:GetText("BG/DesPanel/Text_label");
	self.mHLayout_ItemList = self:GetHorizontalLayoutGroup("BG/DesPanel/Trans_HLayout_ItemList");
	self.mTrans_ItemList = self:GetRectTransform("BG/DesPanel/Trans_HLayout_ItemList");
end

--@@ GF Auto Gen Block End

UICommonLackToBuyView.mPath_Panel = "Store/UICommonLackToBuy.prefab"

UICommonLackToBuyView.Instance = nil;
UICommonLackToBuyView.mCurrencyId = 0;

function UICommonLackToBuyView.OpenLackToBuyPanel(root, currencyId,num)
	self.itemPrefab = UIUtils.GetUIRes(UICommonLackToBuyView.mPath_Panel);
	local instObj = instantiate(self.itemPrefab);
	
	UICommonLackToBuyView.Instance = UICommonLackToBuyView:New();
	UICommonLackToBuyView.Instance:InitCtrl(instObj.transform);
	UICommonLackToBuyView.Instance:InitData(currencyId,num);

	instObj.transform:SetParent(root.gameObject.transform,false);
end


function UICommonLackToBuyView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	UIUtils.GetListener(self.mBtn_Confirm.gameObject).onClick = self.OnConfirmClicked;
	UIUtils.GetListener(self.mBtn_Cancel.gameObject).onClick = self.OnCancelClicked;

end

function UICommonLackToBuyView:InitData(currencyId,num)
	UICommonLackToBuyView.Instance.mCurrencyId = currencyId;
	local itemview=StoreLackToBuyCoin.New();
    itemview:InitCtrl(self.mTrans_ItemList);
    itemview:SetData(currencyId,num);
end

function UICommonLackToBuyView.OnConfirmClicked(gameObject)
	self = UICommonLackToBuyView;

	local stcData = TableData.GetItemData(UICommonLackToBuyView.Instance.mCurrencyId);
	local tagId = stcData.go_to_store;

	if(UIStoreConfirmPanelView.Instance ~= nil and UIStoreExchangePanel.Instance == nil) then 
		UIStorePanel.OnConfirmGotoBuyDiamond(tagId);

		UICommonLackToBuyView.Instance:OnRelease()
		gfdestroy(UIStoreConfirmPanelView.Instance:GetRoot().gameObject);
		UIStoreConfirmPanelView.Instance = nil;
	else
		QuickStorePurchase.RedirectToStoreTag(tagId ,nil);
	end

	UICommonLackToBuyView.Instance:OnRelease()
	gfdestroy(UICommonLackToBuyView.Instance:GetRoot().gameObject);
	UICommonLackToBuyView.Instance = nil;
	UIStorePanel.IsConfirmPanelOpening = false;
end

function UICommonLackToBuyView.OnCancelClicked(gameObject)
	UICommonLackToBuyView.Instance:OnRelease()
	gfdestroy(UICommonLackToBuyView.Instance:GetRoot().gameObject);
	UICommonLackToBuyView.Instance = nil;
end

function UICommonLackToBuyView:OnRelease()
	if self.itemPrefab then
        ResourceManager:UnloadAsset(self.itemPrefab)
    end
end