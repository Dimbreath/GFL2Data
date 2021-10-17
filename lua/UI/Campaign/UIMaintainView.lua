---
--- Created by firwg.
--- DateTime: 18/9/9 16:03
---

require("UI.UIBaseView")



UIMaintainView = class("UIMaintainView", UIBaseView);
UIMaintainView.__index = UIMaintainView;

UIMaintainView.mButton_Return = nil;

UIMaintainView.mText_ResMTPNum = nil;
UIMaintainView.mText_ResDiamondNum = nil;

UIMaintainView.mText_UsedNum = nil;

UIMaintainView.mButton_MaintainAll = nil;
UIMaintainView.mTrans_ItemList = nil;

function UIMaintainView:ctor()
    UIMaintainView.super.ctor(self);
end

function UIMaintainView:InitCtrl(root)

    self:SetRoot(root);


    UIMaintainView.mButton_Return = self:GetButton("CloseButton");

    UIMaintainView.mText_ResMTPNum = self:GetText("MaintainPanel/Adornment/ResourcePanel/MTP_Icon/Text");
    UIMaintainView.mText_ResDiamondNum = self:GetText("MaintainPanel/Adornment/ResourcePanel/Diamond_Icon/Text");

    UIMaintainView.mText_UsedNum = self:GetText("MaintainPanel/MaintainListPanel/ImfoPanel/LeftPanel/Text");

    UIMaintainView.mButton_MaintainAll = self:GetButton("MaintainPanel/MaintainListPanel/ImfoPanel/RightPanel/SpeedUpAllBtn");
    UIMaintainView.mTrans_ItemList = self:FindChild("MaintainPanel/MaintainListPanel/ListPanel");



end

