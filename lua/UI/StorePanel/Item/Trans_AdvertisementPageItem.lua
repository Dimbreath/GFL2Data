require("UI.UIBaseCtrl")

Trans_AdvertisementPageItem = class("Trans_AdvertisementPageItem", UIBaseCtrl);
Trans_AdvertisementPageItem.__index = Trans_AdvertisementPageItem
--@@ GF Auto Gen Block Begin
Trans_AdvertisementPageItem.mTrans_AdvertisementPageItem = nil;
Trans_AdvertisementPageItem.mTrans_AdvertisementPageSelect = nil;



function Trans_AdvertisementPageItem:__InitCtrl()

	self.mTrans_AdvertisementPageItem = self:GetRectTransform("Canvas/");
	self.mTrans_AdvertisementPageSelect = self:GetRectTransform("Trans_AdvertisementPageSelect");
end

--@@ GF Auto Gen Block End

Trans_AdvertisementPageItem.mIndex = 0;

function Trans_AdvertisementPageItem:InitCtrl(parent)
	local obj=instantiate(UIUtils.GetGizmosPrefab("Store/Trans_AdvertisementPageItem.prefab",self));
    setparent(parent,obj.transform);
    obj.transform.localScale=vectorone;

    self:SetRoot(obj.transform);
    self:__InitCtrl();

end

function Trans_AdvertisementPageItem:InitData(index)
	self.mIndex = index;
end

function Trans_AdvertisementPageItem:SetSelect(value)
	setactive(self.mTrans_AdvertisementPageSelect,value);
end