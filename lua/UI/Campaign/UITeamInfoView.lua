---
--- Created by firwg
--- DateTime: 2018/8/8 16:44
---



require("UI.UIBaseView")

UITeamInfoView = class("UITeamInfoView", UIBaseView);
UITeamInfoView.__index = UITeamInfoView;

UITeamInfoView.mTextTeamName = nil;
UITeamInfoView.mTextTeamID = nil;
UITeamInfoView.mButtonRepairAll = nil;
UITeamInfoView.mImageBG = nil;


UITeamInfoView.mHalfViewItemTrans1=nil;
UITeamInfoView.mHalfViewItemTrans2=nil;
UITeamInfoView.mHalfViewItemTrans3=nil;
UITeamInfoView.mHalfViewItemTrans4=nil;

UITeamInfoView.mGunHalfObjList = nil;


UITeamInfoView.mTextCarrierName=nil;
UITeamInfoView.mTextCarrierWearPec=nil;

UITeamInfoView.mImangeCarrierHpPec=nil;
UITeamInfoView.mImangeCarrierMain=nil;

UITeamInfoView.mTextCarrierPower=nil;
UITeamInfoView.mTextCarrierLevel=nil;

UITeamInfoView.mBtnCarrierRepair=nil;
UITeamInfoView.mObjGunList=nil;


function UITeamInfoView:ctor()
    UITeamInfoView.super.ctor(self);
end

--��ʼ��
function UITeamInfoView:InitCtrl(root)

    self:SetRoot(root);

    self.mTextTeamName = self:GetText("TeamInfo/TeamName/TeamName");
    self.mTextTeamID = self:GetText("TeamInfo/TeamName/TeamMunber");
    self.mButtonRepairAll = self:GetButton("TeamInfo/Repair_ALL_Button");
    self.mImageBG = self:GetImage("BtnMask");

    --carrier
    self.mTextCarrierName=self:GetText("NumList/EchelonDetail/BG/EchelonName");
    self.mTextCarrierWearPec=self:GetText("NumList/EchelonDetail/BG/EchelonHP/wear");
    self.mImangeCarrierHpPec=self:GetImage("NumList/EchelonDetail/BG/EchelonHP/HPBar");
    self.mImangeCarrierMain=self:GetImage("NumList/EchelonDetail/BG/EchelonIcon");
    self.mTextCarrierPower=self:GetText("NumList/EchelonDetail/PropertyPanel/CombatText");
    self.mTextCarrierLevel=self:GetText("NumList/EchelonDetail/PropertyPanel/LVDetail");
    self.mBtnCarrierRepair=self:GetButton("NumList/EchelonDetail/RepairButton");


    self.mTextTeamID.text=UIUtils.StringFormat("{0:D2}",CampaignPool.mCurSelTeamID);


    self.mObjGunList=self:FindChild("NumList/GunListTitel/GunList");




    --self.mButton_Return = self:GetComponent("ReturnBtn", typeof(CS.UnityEngine.UI.Button));
    --self.mPanel_FormationCheck = self:FindChild("FormationCheck");




end

function UITeamInfoView:UpdateView()



    local cmd_carrier_data=CarrierNetCmdHandler:GetCarrierByTeamId(CampaignPool.mCurSelTeamID);

    if cmd_carrier_data ~=nil then
        carrier_data=TableData.GetCarrierBaseBodyData(cmd_carrier_data.stc_carrier_id);
        if carrier_data ~=nil then

            self.mTextCarrierName.text=carrier_data.name;

            local wearPec=cmd_carrier_data.hp/cmd_carrier_data.prop.max_hp;
            self.mTextCarrierWearPec.text=UIUtils.StringFormat("{0:P0}",wearPec);
            self.mImangeCarrierHpPec.fillAmount=cmd_carrier_data.hp/cmd_carrier_data.prop.max_hp;
            self.mImangeCarrierMain.sprite=CS.IconUtils.GetIconSprite(CS.GF2Icon.Carrier,carrier_data.icon);
            self.mTextCarrierPower.text=0;
            self.mTextCarrierLevel.text=cmd_carrier_data.level;

            --self.mBtnCarrierRepair=self:GetButton("NumList/EchelonDetail/RepairButton");
        else
            gfdebug("找不到载具配置表数据ID"..cmd_carrier_data.stc_carrier_id)
        end
    else
        gfdebug("找不到载具服务器数据ID"..CampaignPool.mCurSelTeamID)
    end

 end

--endregion