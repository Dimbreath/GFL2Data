---
--- Created by 6.
--- DateTime: 18/9/5 11:12
---

require("UI.UIBaseView")

UIFormationTeamTipItem = class("UIFormationTeamTipItem", UIBaseView);
UIFormationTeamTipItem.__index = UIFormationTeamTipItem;

UIFormationTeamTipItem.mObj_Regular = nil;
UIFormationTeamTipItem.mObj_Selected = nil;
UIFormationTeamTipItem.mObj_Locked = nil;

UIFormationTeamTipItem.IsSelected = false;
UIFormationTeamTipItem.CarrierInfo = nil;

--构造
function UIFormationTeamTipItem:ctor()
    UIFormationTeamTipItem.super.ctor(self);
end

--初始化
function UIFormationTeamTipItem:InitCtrl(root)

    self:SetRoot(root);

    self.mObj_Regular = self:FindChild("TeamLabelRegular");
    self.mObj_Selected = self:FindChild("TeamLabelSelected");
    self.mObj_Locked = self:FindChild("TeamLabelLocked");

end

function UIFormationTeamTipItem:SetCarrierInfo(info)
    self.CarrierInfo = info;
end

function UIFormationTeamTipItem:ShowRegular()
    setactive(self.mObj_Regular, true);
    setactive(self.mObj_Selected, false);
    setactive(self.mObj_Locked, false);
end

function UIFormationTeamTipItem:ShowSelected()
    setactive(self.mObj_Regular, false);
    setactive(self.mObj_Selected, true);
    setactive(self.mObj_Locked, false);
end

function UIFormationTeamTipItem:ShowLocked()
    setactive(self.mObj_Regular, false);
    setactive(self.mObj_Selected, false);
    setactive(self.mObj_Locked, true);
end