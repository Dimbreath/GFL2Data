---
--- Created by firwg.
--- DateTime: 2018/8/7 11:33
---

require("UI.UIBasePanel")
require("UI.Common.HalfDetailViewItem")
require("UI.CamPaign.UITeamInfoView")


UITeamInfoPanel = class("UITeamInfoPanel", UIBasePanel);

UITeamInfoPanel.mListGunHalfView = nil;

UITeamInfoPanel.mView=nil;

UITeamInfoPanel.mNetTeamHandle=nil;
UITeamInfoPanel.mCampaignPool=nil;


--构造
function UITeamInfoPanel:ctor()
    UITeamInfoPanel.super.ctor(self);
end

function UITeamInfoPanel.Open()
    UIManager.OpenUI(UIDef.UITeamInfoPanel);
end

function UITeamInfoPanel.Close()
    self=UITeamInfoPanel;
    CS.GF2.Message.MessageSys.Instance:RemoveListener(9001,self.UpdateMessage);
    UIManager.CloseUI(UIDef.UITeamInfoPanel);
end


function UITeamInfoPanel.Init(root, data)

    UITeamInfoPanel.super.SetRoot(UITeamInfoPanel, root);

    self = UITeamInfoPanel;
    self:SetRoot(root);
    --print(data)
    self.mData = data;

    self.mView = UITeamInfoView;
    self.mView:InitCtrl(root);

    CS.GF2.Message.MessageSys.Instance:AddListener(9001,self.UpdateMessage);

    self.mNetTeamHandle = CS.NetCmdTeamData.Instance;

    self.mCampaignPool=CS.CampaignPool.Instance;

    self.mListGunHalfView= List:New(HalfDetailViewItem);

    --返回按钮--
    UIUtils.GetListener(self.mView.mImageBG.gameObject).onClick = self.OnCloseBtnClick;


    for i = 1, 4 do
        local halfViewItem=HalfDetailViewItem.New();
        self.mListGunHalfView:Add(halfViewItem);
        halfViewItem:InitCtrl(self.mView.mObjGunList);
    end


    self:UpdateView();

end

function UITeamInfoPanel.OnInit()
    mNetTeamHandle = CS.NetCmdTeamData.Instance;
end


function UITeamInfoPanel:UpdateView()

    self.mView:UpdateView();


    for i = 1, 4 do
            local gun=NetTeamHandle:GetGunByTeamIdAndIndex(CampaignPool.mCurSelTeamID,i-1);
            self.mListGunHalfView[i]:SetData(gun);
    end

    --RepairAllButton
    local str=NetTeamHandle:CheckRepairAllTeam(self.mCampaignPool.mCurSelTeamID);

    if str =="" then
        UIUtils.GetListener(self.mView.mButtonRepairAll.gameObject).onClick = self.OnRepairAllClick;
        self.mView.mButtonRepairAll.interactable=true;
    else
        self.mView.mButtonRepairAll.interactable=false;
        UIUtils.GetListener(self.mView.mButtonRepairAll.gameObject).onClick = nil;
        gfdebug(str);
    end


    --RepairCarrier
    local cmd_carrier_data=CarrierNetCmdHandler:GetCarrierByTeamId(CampaignPool.mCurSelTeamID);

    if cmd_carrier_data ~=nil then
        local str1=CarrierNetCmdHandler:CheckRepairCarrier(cmd_carrier_data.id);
        if str1 =="" then
            UIUtils.GetListener(self.mView.mBtnCarrierRepair.gameObject).onClick = self.OnRepairCarrierClick;
            UIUtils.GetListener(self.mView.mBtnCarrierRepair.gameObject).param = cmd_carrier_data.id;
            self.mView.mBtnCarrierRepair.interactable=true;
        else
            UIUtils.GetListener(self.mView.mBtnCarrierRepair.gameObject).onClick = nil;
            self.mView.mBtnCarrierRepair.interactable=false;
        end
    end

end




function UITeamInfoPanel.UpdateMessage(msg)

    self = UITeamInfoPanel;
    self:UpdateView();

end



--维修所有--
function UITeamInfoPanel.OnRepairAllClick(gameobj)

    self=UITeamInfoPanel;


    if self.mView.mButtonRepairAll.interactable==true then
        local value=CampaignPool:TryCalRepairAllInTeam();

        if value then
            UIManager.OpenUI(UIDef.UIRepairConfirmPanel);
        else
            gfdebug("不存在可以修理的单位");
            --UIUtils.OpenNoticeUIPanel("不存在可以修理的单位")
        end
    end
end


--维修载具--
function UITeamInfoPanel.OnRepairCarrierClick(gameobj)

    local eventClick=UIUtils.GetListener(gameobj);

    local value=CampaignPool:TryCalRepairCarrier(eventClick.param);

    if value then
        UIManager.OpenUI(UIDef.UIRepairConfirmPanel);
    else
        UIUtils.OpenNoticeUIPanel("载具不能维修")
    end

end


--返回--
function UITeamInfoPanel.OnCloseBtnClick(gameobj)

    self=UITeamInfoPanel;
    self:Close();
    --UITeamInfoPanel.Close();
end

--endregion

