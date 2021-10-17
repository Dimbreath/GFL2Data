---
--- Created by firwg
--- DateTime: 2018/8/8 16:44
---



require("UI.UIBaseView")
require("UI.Common.HeadViewItem")


UIRepairConfirmView = class("UIRepairConfirmView", UIBaseView);
UIRepairConfirmView.__index = UIRepairConfirmView;

--
UIRepairConfirmView.mTextCostNum = nil;
UIRepairConfirmView.mButtonConfirm = nil;
UIRepairConfirmView.mButtonCancel = nil;

--载具头像Obj
UIRepairConfirmView.mCarrierTrans=nil;

UIRepairConfirmView.mEchelonMessageTrans=nil;

UIRepairConfirmView.mCarrierTriangleHint=nil;


--Gun头像列表Obj
UIRepairConfirmView.mGunListTrans = nil;


UIRepairConfirmView.mObj_GunList = nil;

function UIRepairConfirmView:ctor()
    UIRepairConfirmView.super.ctor(self);
end

--
function UIRepairConfirmView:InitCtrl(root)

    self:SetRoot(root);

    self.mTextCostNum = self:GetText("Comfirm/RepairDetail/Cost/Icon/CostNum");
    self.mButtonConfirm = self:GetButton("Comfirm/RepairDetail/ComfirmBtn");
    self.mButtonCancel = self:GetButton("Comfirm/RepairDetail/CancelBtn");

    self.mCarrierTriangleHint=self:FindChild("Comfirm/RepairDetail/RepairList/EchelonMessage/TriangleHint");
    self.mGunListTrans = self:FindChild("Comfirm/RepairDetail/RepairList/GunList");
    self.mEchelonMessageTrans=self:FindChild("Comfirm/RepairDetail/RepairList/EchelonMessage");
    --载具头像Obj
    self.mCarrierTrans=self:FindChild("Comfirm/RepairDetail/RepairList/EchelonMessage");
    --Gun头像列表Obj

    self.mTextCostNum.text=CampaignPool.mCurCost;

    --载具 待修理列表
    local carlist=CampaignPool.mWaitForRepairCarrierList;

    if carlist.Count ==1 then
        setactive(self.mCarrierTrans,true);
        local veiw2=HeadViewItem.New();
        veiw2:InitCtrl(self.mCarrierTrans);
        local Carrierdata=CarrierNetCmdHandler:GetCarrierByID(carlist[0]);
        veiw2:SetCarrierData(Carrierdata);
    else
        setactive(self.mEchelonMessageTrans,false);
        setactive(self.mCarrierTrans,false);
    end

    --人形  待修理列表
    local gunlist=CampaignPool.mWaitForRepairGunList;

    if gunlist.Count ~=0 then
        for i = 1, gunlist.Count do
            local veiw1=HeadViewItem.New();
            veiw1:InitCtrl(self.mGunListTrans);
            local gundata= NetTeamHandle:GetGunByID(gunlist[i-1]);
            veiw1:SetGunData(gundata);
        end
    else
        setactive(self.mCarrierTriangleHint,false);
        setactive(self.mGunListTrans,false);
    end

end


--endregion