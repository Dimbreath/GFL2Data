require("UI.UIBasePanel")
require("UI.RaidAndAutoBattle.UIAutoBattleEndPanelView");

UIAutoBattleEndPanel = class("UIAutoBattleEndPanel", UIBasePanel);
UIAutoBattleEndPanel.__index = UIAutoBattleEndPanel;

UIAutoBattleEndPanel.mView = nil;


function UIAutoBattleEndPanel:ctor()
    UIAutoBattleEndPanel.super.ctor(self);
end

function UIAutoBattleEndPanel.Open(data)
    self = UIAutoBattleEndPanel;
    UIManager.OpenUIByParam(UIDef.UIAutoBattleEndPanel,data);
end

function UIAutoBattleEndPanel.Close()
    UIManager.CloseUI(UIDef.UIAutoBattleEndPanel);
end

function UIAutoBattleEndPanel.Hide()
    self = UIAutoBattleEndPanel;
    self:Show(false);
end

function UIAutoBattleEndPanel.Init(root, data)
    UIAutoBattleEndPanel.super.SetRoot(UIAutoBattleEndPanel, root);
    UIAutoBattleEndPanel.mView = UIAutoBattleEndPanelView;
    UIAutoBattleEndPanel.mView:InitCtrl(root);
    UIAutoBattleEndPanel.mIsPop = true;
    
    self = UIAutoBattleEndPanel;
    self.mIsPop = true;

    UIUtils.GetListener(self.mView.mBtn_PanelButton.gameObject).onClick=self.OnCloseClick;

    MessageSys:AddListener(CS.GF2.Message.AFKEvent.KeepOnTop, self.StayOnTop);
    MessageSys:AddListener(CS.GF2.Message.BattleEvent.PlayEnemyTurnAnimation, self.StayOnTop);
    MessageSys:AddListener(CS.GF2.Message.BattleEvent.PlayPlayerTurnAnimation, self.StayOnTop);
end


function UIAutoBattleEndPanel.OnInit()
    self = UIAutoBattleEndPanel;

    self:InitEndInfo();
    self:InitRewardList();
    self:InitGunExpList();
    self:InitPlayerExpList();
end

function UIAutoBattleEndPanel:InitEndInfo()
    if(AFKBattleManager.EndReason ~= CS.AFKBattleManager.EAutoEndReason.Default) then
        setactive(self.mView.mTrans_EndReason,true);
        self.mView.mText_endReason.text = AFKBattleManager.BattleEndReasonStr;
    else
        setactive(self.mView.mTrans_EndReason,false);
    end
end

function UIAutoBattleEndPanel:InitRewardList()
    local rewardDict = AFKBattleManager.RewardList;
    local prefab = UIUtils.GetGizmosPrefab(UICommonItemS.Path_UICommonItemS,self);
	for key,DropItem in pairs(rewardDict)do
		local rewardItem = UICommonItemS.New()
		local rewardInst = instantiate(prefab)
		UIUtils.AddListItem(rewardInst,self.mView.mTrans_itemRoot.transform)
		rewardItem:InitCtrl(rewardInst.transform)
        rewardItem:SetRelateId(DropItem.RelateId)
		rewardItem:SetData(DropItem.ItemId, DropItem.ItemNum, false)
	end
end

function UIAutoBattleEndPanel:InitGunExpList()
    
end

function UIAutoBattleEndPanel:InitPlayerExpList()
    local levelup = AFKBattleManager.PlayerExpData.curLevel - AFKBattleManager.PlayerExpData.beginLevel;
    self.mView.mText_PlusExp.text = AFKBattleManager.PlayerExpData:GetAddExp();
    self.mView.mText_ExpBar.text = AFKBattleManager.PlayerExpData.curExp.. "/" ..AFKBattleManager.PlayerExpData:GetStcLevelExp();
    self.mView.mText_LV.text = AFKBattleManager.PlayerExpData.beginLevel;
    self.mView.mText_LVPlus.text = "+"..levelup;
    self.mView.mImage_FillCur.fillAmount = AFKBattleManager.PlayerExpData:GetOldExpPct();
    self.mView.mImage_FillAft.fillAmount = AFKBattleManager.PlayerExpData:GetExpPct();

    if(levelup > 0) then
        setactive(self.mView.mImage_FillCur.gameObject, false);
    else
        setactive(self.mView.mImage_FillCur.gameObject, true);
    end
end

function UIAutoBattleEndPanel.OnShow()
    self = UIAutoBattleEndPanel;
end

function UIAutoBattleEndPanel.StayOnTop()
    self = UIAutoBattleEndPanel;
    self.mUIRoot.transform:SetSiblingIndex(self.mUIRoot.transform.parent.childCount - 1);
end

function UIAutoBattleEndPanel.OnRelease()
    self = UIAutoBattleEndPanel;

    MessageSys:RemoveListener(CS.GF2.Message.AFKEvent.KeepOnTop, self.StayOnTop);
    MessageSys:RemoveListener(CS.GF2.Message.BattleEvent.PlayEnemyTurnAnimation, self.StayOnTop);
    MessageSys:RemoveListener(CS.GF2.Message.BattleEvent.PlayPlayerTurnAnimation, self.StayOnTop);
end

function UIAutoBattleEndPanel.OnCloseClick(gameobj)
    self = UIAutoBattleEndPanel;
    -- if(AFKBattleManager.EndReason ~= CS.AFKBattleManager.EAutoEndReason.Default) then
    --     SceneSys:OpenSceneByName("CommandCenter")
    -- end

    CS.GuideManager.Instance:StartOrResumeGuide(2)
    self.Close();
end