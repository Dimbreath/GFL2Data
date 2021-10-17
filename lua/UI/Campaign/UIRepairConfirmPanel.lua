---
--- Created by chun.
--- DateTime: 2018/8/7 12:02
---

require("UI.Common.HalfDetailViewItem")
require("UI.Campaign.UIRepairConfirmView")




UIRepairConfirmPanel = class("UIRepairConfirmPanel", UIBasePanel);
UIRepairConfirmPanel.mListGunHalfView = nil;
UIRepairConfirmPanel.mGunHalfObjList=nil;
UIRepairConfirmPanel.mView=nil;



--构造
function UIRepairConfirmPanel:ctor()
    UIRepairConfirmPanel.super.ctor(self);
end

function UIRepairConfirmPanel.Open()
    UIManager.OpenUI(UIDef.UIRepairConfirmPanel);
end

function UIRepairConfirmPanel.Close()

    UIManager.CloseUI(UIDef.UIRepairConfirmPanel);
end

function UIRepairConfirmPanel.Init(root, data)

    UIRepairConfirmPanel.super.SetRoot(UIRepairConfirmPanel, root);

    self= UIRepairConfirmPanel;

    self.mUIRoot=root;
    --print(data)
    self.mData = data;


    self.mView=UIRepairConfirmView;
    self.mView:InitCtrl(root);

    UIUtils.GetListener(self.mView.mButtonConfirm.gameObject).onClick = self.OnConfirmClick;
    UIUtils.GetListener(self.mView.mButtonCancel.gameObject).onClick = self.OnCancelClick;

end


--确定按钮--
function UIRepairConfirmPanel.OnConfirmClick(gameobj)

    CampaignPool:SendReqCampaignRepair();

    UIRepairConfirmPanel:Close();

end

--取消按钮--
function UIRepairConfirmPanel.OnCancelClick(gameobj)
    self:Close();
end

function UIRepairConfirmPanel.OnInit()

end