--region *.lua

require("UI.UIBasePanel")
require("UI.AutoMax.UIAutoMaxConfirmPanelView")

UIAutoMaxConfirmPanel = class("UIAutoMaxConfirmPanel",UIBasePanel)
UIAutoMaxConfirmPanel.__index = UIAutoMaxConfirmPanel

UIAutoMaxConfirmPanel.mView = nil
UIAutoMaxConfirmPanel.mPath_AutoMaxConfirmPanel = "UIAutoMaxConfirmPanel.prefab"

UIAutoMaxConfirmPanel.mSkipFlag = false

function UIAutoMaxConfirmPanel:ctor()
    UIAutoMaxConfirmPanel.super.ctor(self)
end

function UIAutoMaxConfirmPanel.Open()
    UIManager.OpenUI(UIDef.UIAutoMaxConfirmPanel)
end

function UIAutoMaxConfirmPanel.Close()
    gfwarning("uiclose")
    UIManager.CloseUI(UIDef.UIAutoMaxConfirmPanel)
end

function UIAutoMaxConfirmPanel.Init(root,data)
    UIAutoMaxConfirmPanel.super.SetRoot(UIAutoMaxConfirmPanel,root)
    self = UIAutoMaxConfirmPanel
    self.mView = UIAutoMaxConfirmPanelView
    self.mView:InitCtrl(root)

    UIAutoMaxConfirmPanel.InitTeamInfo()
    UIAutoMaxConfirmPanel.RegisterAllListener()
end

function UIAutoMaxConfirmPanel.RegisterAllListener()
    UIUtils.GetListener(UIAutoMaxConfirmPanel.mView.mBtn_AnimSkipSwitch.gameObject).onClick = UIAutoMaxConfirmPanel.OnSkipSwitchBtnClicked
    UIUtils.GetListener(UIAutoMaxConfirmPanel.mView.mBtn_Comfirm.gameObject).onClick = UIAutoMaxConfirmPanel.OnConfirmBtnClicked
end

function UIAutoMaxConfirmPanel.RemoveAllListener()

end

function UIAutoMaxConfirmPanel.OnSkipSwitchBtnClicked()
    UIAutoMaxConfirmPanel.mSkipFlag = not UIAutoMaxConfirmPanel.mSkipFlag

end

function UIAutoMaxConfirmPanel.OnConfirmBtnClicked()
    UIAutoMaxConfirmPanel.Close()
    MessageSys:SendMessage(CS.GF2.Message.AutoMaxEvent.AutoEnterConfirm,UIAutoMaxConfirmPanel.mSkipFlag)


end


function UIAutoMaxConfirmPanel.InitTeamInfo()
    local attackCarrierDataList = AutoMaxManager.mData.AttackCarrierDataList
    local defendCarrierDataList = AutoMaxManager.mData.DefendCarrierDataList

    local attackSlotPrefab = UIUtils.GetGizmosPrefab("AutoMax/UIAutoMaxComfirm_PlayerVehicleSlotItem.prefab",self);
    local defendSlotPrefab = UIUtils.GetGizmosPrefab("AutoMax/UIAutoMaxComfirm_EnemyVehicleSlotItem.prefab",self);
    for i=0, attackCarrierDataList.Count-1 do
        local attackSlotItem = UIAutoMaxComfirm_PlayerVehicleSlotItem:New()
        local attackSlotInstance = instantiate(attackSlotPrefab)
        UIUtils.AddListItem(attackSlotInstance,UIAutoMaxConfirmPanel.mView.mTrans_PlayerTeam.transform)
        attackSlotItem:InitCtrl(attackSlotInstance.transform)
        attackSlotItem:SetData(attackCarrierDataList[i])
    end

    for i=0, defendCarrierDataList.Count-1 do
        local defendSlotItem = UIAutoMaxComfirm_EnemyVehicleSlotItem:New()
        local defendSlotInstance = instantiate(defendSlotPrefab)
        UIUtils.AddListItem(defendSlotInstance,UIAutoMaxConfirmPanel.mView.mTrans_EnemyTeam.transform)
        defendSlotItem:InitCtrl(defendSlotInstance.transform)
        defendSlotItem:SetData(defendCarrierDataList[i])
    end
end


