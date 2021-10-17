---
--- Created by 6.
--- DateTime: 18/9/5 11:04
---

require("UI.UIBaseView")

UICarrierSelectionView = class("UICarrierSelectionView", UIBaseView);
UICarrierSelectionView.__index = UICarrierSelectionView;

-----------------------[载具显示]----------------------
UICarrierSelectionView.mButton_CarrierConfirm = nil;
UICarrierSelectionView.mGrid_CarrierSelect = nil;
UICarrierSelectionView.mButton_Return = nil;
UICarrierSelectionView.mButton_Remove = nil;

UICarrierSelectionView.mButton_Confirm = nil;
--构造
function UICarrierSelectionView:ctor()
    UICarrierSelectionView.super.ctor(self);
end

--初始化
function UICarrierSelectionView:InitCtrl(root)

    self:SetRoot(root);

    print("init UICarrierSelectionView")
    self.mButton_CarrierConfirm = self:GetButton("ConfirmBtn");
    self.mGrid_CarrierSelect = self:FindChild("CarrierListBG/List");
    self.mButton_Return = self:GetButton("TopPanel/Return");
    self.mButton_Remove = self:GetButton("CarrierListBG/List/VehicleRemove");
    self.mButton_Confirm=self:GetButton("RightPanel/Confirm");
end