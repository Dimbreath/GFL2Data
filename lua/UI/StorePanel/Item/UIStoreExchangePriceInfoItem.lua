require("UI.UIBaseCtrl")

UIStoreExchangePriceInfoItem = class("UIStoreExchangePriceInfoItem", UIBaseCtrl)
UIStoreExchangePriceInfoItem.__index = UIStoreExchangePriceInfoItem

function UIStoreExchangePriceInfoItem:ctor()

end

function UIStoreExchangePriceInfoItem:__InitCtrl()
    -- self.mBtn_OpenDetail = self:GetButton("Root/Btn_OpenDetail")
    -- self.mImage_Icon = self:GetImage("Root/HeadMask/Image_CharacterPic")
    -- self.mText_Level = self:GetText("Root/Detail/Text_Level")
    -- self.mImage_Element = self:GetImage("Root/Detail/Image_Attribute")
    -- self.mImage_Rank = self:GetImage("Root/Detail/Image_GunColor")

    self.mText_Num = self:GetText("Root/GrpBuyNum/Text_Num")
    self.mText_Price = self:GetText("Root/GrpPrice/Text_Price");
    self.mImage_Icon = self:GetImage("Root/GrpPrice/GrpItemIcon/Img_Icon");
    self.mTrans_Now = self:GetRectTransform("Root/Trans_GrpNow")
end
--@@ GF Auto Gen Block End

function UIStoreExchangePriceInfoItem:InitCtrl(parent)
    local itemPrefab = UIUtils.GetGizmosPrefab("StoreExchange/StoreExchangePriceInfoItemV2.prefab",self);
    local instObj = instantiate(itemPrefab)

    UIUtils.AddListItem(instObj.gameObject, parent.gameObject)

    self:SetRoot(instObj.transform)
    self:__InitCtrl()
end


function UIStoreExchangePriceInfoItem:SetData(data)
    if(data.endCount > 0) then
        self.mText_Num.text = data.startCount .. "~" .. data.endCount;
    else
        self.mText_Num.text = data.startCount .. "~";
    end
    self.mText_Price.text = data.price;
    local stcData = TableData.GetItemData(data.priceId);
    self.mImage_Icon.sprite = UIUtils.GetIconSprite("Icon/Item",stcData.icon);
end

function UIStoreExchangePriceInfoItem:SetNow()
    setactive(self.mTrans_Now,true)
end

