require("UI.UIBasePanel")
require("UI.RaidAndAutoBattle.UIAutoBattleView");

UIAutoBattlePanel = class("UIAutoBattlePanel", UIBasePanel);
UIAutoBattlePanel.__index = UIAutoBattlePanel;

UIAutoBattlePanel.mView = nil;


function UIAutoBattlePanel:ctor()
    UIAutoBattlePanel.super.ctor(self);
end

function UIAutoBattlePanel.Open(data)
    self = UIAutoBattlePanel;
    UIManager.OpenUIByParam(UIDef.UIAutoBattlePanel,data);
end

function UIAutoBattlePanel.Close()
    UIManager.CloseUI(UIDef.UIAutoBattlePanel);
end

function UIAutoBattlePanel.Hide()
    self = UIAutoBattlePanel;
    self:Show(false);
end

function UIAutoBattlePanel.Init(root, data)
    
    UIAutoBattlePanel.super.SetRoot(UIAutoBattlePanel, root);
    UIAutoBattlePanel.mView = UIAutoBattleView;
    UIAutoBattlePanel.mView:InitCtrl(root);

    self = UIAutoBattlePanel;
    -- local canvas = GameObject.Find("Canvas");
    -- root.transform:SetParent(canvas.transform,false);
    self.mIsPop = true;

    UIUtils.GetListener(self.mView.mBtn_ButtonMask.gameObject).onClick=self.OnMaskClick;
    UIUtils.GetListener(self.mView.mBtn_BasePanel_stop.gameObject).onClick=self.OnStopClick;
    UIUtils.GetListener(self.mView.mBtn_BasePanel_setting.gameObject).onClick=self.OnSettingClick;
    UIUtils.GetListener(self.mView.mBtn_return.gameObject).onClick=self.OnSettingClose;
    UIUtils.GetListener(self.mView.mBtn_BasePanel_battleReport.gameObject).onClick=self.OnReportClick;
    UIUtils.GetListener(self.mView.mBtn_ButtonPlusOne.gameObject).onClick=self.OnAddOneClick;
    UIUtils.GetListener(self.mView.mBtn_ButtonMinusOne.gameObject).onClick=self.OnMinusOneClick;
    UIUtils.GetListener(self.mView.mBtn_ButtonPlusTen.gameObject).onClick=self.OnAddTenClick;
    UIUtils.GetListener(self.mView.mBtn_ButtonMinusTen.gameObject).onClick=self.OnMinusTenClick;

    self.mView.mToggle_failStopToggle.onValueChanged:AddListener(self.OnFailStopValueChanged);
    self.mView.mToggle_maxTimeToggle.onValueChanged:AddListener(self.OnMaxTimeValueChanged);
    self.mView.mDropDown_AutoStamina.onValueChanged:AddListener(self.OnStaminaValueChanged);

    MessageSys:AddListener(CS.GF2.Message.AFKEvent.StayOnTop, self.StayOnTop);
    MessageSys:AddListener(CS.GF2.Message.BattleEvent.PlayEnemyTurnAnimation, self.StayOnTop);
    MessageSys:AddListener(CS.GF2.Message.BattleEvent.PlayPlayerTurnAnimation, self.StayOnTop);
end


function UIAutoBattlePanel.OnInit()
    self = UIAutoBattlePanel;

end

function UIAutoBattlePanel.OnShow()
    self = UIAutoBattlePanel;
end

function UIAutoBattlePanel.OnRelease()
    self = UIAutoBattlePanel;

    MessageSys:RemoveListener(CS.GF2.Message.AFKEvent.StayOnTop, self.StayOnTop);
    MessageSys:RemoveListener(CS.GF2.Message.BattleEvent.PlayEnemyTurnAnimation, self.StayOnTop);
    MessageSys:RemoveListener(CS.GF2.Message.BattleEvent.PlayPlayerTurnAnimation, self.StayOnTop);
end

function UIAutoBattlePanel.StayOnTop()
    self = UIAutoBattlePanel;
    self.mUIRoot.transform:SetSiblingIndex(self.mUIRoot.transform.parent.childCount - 1);

    MessageSys:SendMessage(CS.GF2.Message.AFKEvent.KeepOnTop, nil);
end

function UIAutoBattlePanel.OnMaskClick(gameobj)
    local hint = TableData.GetHintById(603)
    CS.PopupMessageManager.PopupString(hint)
end

function UIAutoBattlePanel.OnSettingClick(gameobj)
    self = UIAutoBattlePanel;
    setactive(self.mView.mTrans_setting, true);
    self.mView.mDropDown_AutoStamina.value = AFKBattleManager.FillModeInt;
end

function UIAutoBattlePanel.OnSettingClose(gameObj)
    self = UIAutoBattlePanel;
    setactive(self.mView.mTrans_setting,false);
end

function UIAutoBattlePanel.OnFailStopValueChanged(value)
    self = UIAutoBattlePanel;
    AFKBattleManager.RetryAfterFailed = value;
end

function UIAutoBattlePanel.OnMaxTimeValueChanged(value)
    self = UIAutoBattlePanel;
    AFKBattleManager.IsLimitedTimes = value;
end

function UIAutoBattlePanel.OnStaminaValueChanged(value)
    self = UIAutoBattlePanel;
    AFKBattleManager.FillMode = value;
end


function UIAutoBattlePanel.OnReportClick(gameobj)
    self = UIAutoBattlePanel;
    UIManager.OpenUI(UIDef.UIAutoBattleEndPanel);
end

function UIAutoBattlePanel.OnStopClick(gameobj)
    self = UIAutoBattlePanel;
    AFKBattleManager:StopAutoBattle();
    UIManager.CloseUI(UIDef.UIAutoBattlePanel);
end

function UIAutoBattlePanel.OnAddOneClick(gameobj)
    self = UIAutoBattlePanel;
    AFKBattleManager.MaxTimes = AFKBattleManager.MaxTimes + 1;
    self.mView.UpdateTimesNum();
end

function UIAutoBattlePanel.OnMinusOneClick(gameobj)
    self = UIAutoBattlePanel;
    AFKBattleManager.MaxTimes = AFKBattleManager.MaxTimes - 1;
    self.mView.UpdateTimesNum();
end

function UIAutoBattlePanel.OnAddTenClick(gameobj)
    self = UIAutoBattlePanel;
    AFKBattleManager.MaxTimes = AFKBattleManager.MaxTimes + 10;
    self.mView.UpdateTimesNum();
end

function UIAutoBattlePanel.OnMinusTenClick(gameobj)
    self = UIAutoBattlePanel;
    AFKBattleManager.MaxTimes = AFKBattleManager.MaxTimes - 10;
    self.mView.UpdateTimesNum();
end