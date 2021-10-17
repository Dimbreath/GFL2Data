require("UI.UIBasePanel")
require("UI.RaidAndAutoBattle.UIRaidPanelView");

UIRaidPanel = class("UIRaidPanel", UIBasePanel);
UIRaidPanel.__index = UIRaidPanel;

UIRaidPanel.mView = nil;
UIRaidPanel.mStageData = nil;
UIRaidPanel.mSimData = nil;

UIRaidPanel.mRaidTimes = 1;
UIRaidPanel.mRaidTimesLeft = 999;
UIRaidPanel.mTimer = nil;
UIRaidPanel.mCanClose = true;

function UIRaidPanel:ctor()
    UIRaidPanel.super.ctor(self);
end

function UIRaidPanel.Open(data)
    self = UIRaidPanel;
    UIManager.OpenUIByParam(UIDef.UIRaidPanel,data);
end

function UIRaidPanel.Close()
    if(UIRaidPanel.mCanClose == false) then
        return;
    end
    UIManager.CloseUI(UIDef.UIRaidPanel);
end

function UIRaidPanel.Hide()
    self = UIRaidPanel;
    self:Show(false);
end

function UIRaidPanel.Init(root, data)
    UIRaidPanel.super.SetRoot(UIRaidPanel, root);
    if data.stage_id ~= nil then
        if data.daily_times ~= nil then
            UIRaidPanel.mStoryData = data
            UIRaidPanel.mStageData = TableData.listStageDatas:GetDataById(data.stage_id);
        else
            UIRaidPanel.mSimData = data;
            UIRaidPanel.mStageData = TableData.listStageDatas:GetDataById(data.stage_id);
        end
    else
        UIRaidPanel.mStageData = data
    end

    UIRaidPanel.mIsPop = true;
    UIRaidPanel.mView = UIRaidPanelView;
    UIRaidPanel.mView:InitCtrl(root);

    UIUtils.GetButtonListener(self.mView.mBtn_BakButton.gameObject).onClick=self.OnReturnClick;
    UIUtils.GetButtonListener(self.mView.mBtn_Cancel.gameObject).onClick=self.OnReturnClick;
    UIUtils.GetButtonListener(self.mView.mBtn_ButtonPlusOne.gameObject).onClick=self.OnAddOneClick;
    --UIUtils.GetButtonListener(self.mView.mBtn_ButtonPlusTen.gameObject).onClick=self.OnAddTenClick;
    UIUtils.GetButtonListener(self.mView.mBtn_ButtonMinusOne.gameObject).onClick=self.OnMinusOneClick;
    --UIUtils.GetButtonListener(self.mView.mBtn_ButtonMinusTen.gameObject).onClick=self.OnMinusTenClick;
    --UIUtils.GetButtonListener(self.mView.mBtn_ButtonPlusMax.gameObject).onClick=self.OnAddMaxClick;
    UIUtils.GetButtonListener(self.mView.mBtn_StartRaid.gameObject).onClick=self.OnStartClick;

    MessageSys:AddListener(9007, self.UpdateView)
    MessageSys:AddListener(5100, self.Close)

    self.mView.mSilderLine.onValueChanged:AddListener(self.OnSliderValueChanged);
end


function UIRaidPanel.OnInit()
    self = UIRaidPanel;
    self.UpdateView();
end

function UIRaidPanel.OnShow()
    self = UIRaidPanel;
end

function UIRaidPanel.OnRelease()
    self = UIRaidPanel;

    self.mRaidTimes = 1;
    self.mRaidTimesLeft = 999;
    MessageSys:RemoveListener(9007, self.UpdateView)
    MessageSys:RemoveListener(5100, self.Close)
    if UIRaidPanel.mTimer ~= nil then
        UIRaidPanel.mTimer:Stop()
    end
    self.mSimData = nil
    -- TimerSys:Remove(UIRaidPanel.mTimer);
end

function UIRaidPanel.OnReturnClick(gameobj)
    self = UIRaidPanel;
    if(UIRaidPanel.mCanClose == false) then
        return;
    end
    
    UIManager.CloseUI(UIDef.UIRaidPanel);
end

function UIRaidPanel.OnSliderValueChanged(value)
    self = UIRaidPanel;
    self.mRaidTimes = value;
    self.mRaidTimes = math.min( self.mRaidTimes,self.mRaidTimesLeft);
    self.mRaidTimes = math.max( self.mRaidTimes,1);

    self.UpdateView();
end


function UIRaidPanel.OnAddOneClick(gameobj)
    self = UIRaidPanel;

    if(self.mRaidTimes >= self.mRaidTimesLeft) then
        local hint = TableData.GetHintById(601);
        CS.PopupMessageManager.PopupString(hint);
    end

    if(self.mRaidTimes >= TableData.GlobalSystemData.RaidOnetimeLimit) then
        local hint = TableData.GetHintById(609);
        CS.PopupMessageManager.PopupString(hint);
        return;
    end
 
    self.mRaidTimes = self.mRaidTimes + 1;
    self.mRaidTimes = math.min( self.mRaidTimes,self.mRaidTimesLeft);
    self.mRaidTimes = math.max( self.mRaidTimes,1);

    self.UpdateView();

    --UIRaidPanel.CheckTimes();
end

function UIRaidPanel.OnMinusOneClick(gameobj)
    self = UIRaidPanel;
    
    self.mRaidTimes = self.mRaidTimes - 1;
    self.mRaidTimes = math.max( self.mRaidTimes,1);

    self.UpdateView();

    UIRaidPanel.CheckTimes();
end

function UIRaidPanel.OnAddTenClick(gameobj)
    self = UIRaidPanel;

    if(self.mRaidTimes >= self.mRaidTimesLeft) then
        local hint = TableData.GetHintById(601);
        CS.PopupMessageManager.PopupString(hint);
    end

    if(self.mRaidTimes + 10 > TableData.GlobalSystemData.RaidOnetimeLimit) then
        local hint = TableData.GetHintById(609);
        CS.PopupMessageManager.PopupString(hint);
    end
   
    self.mRaidTimes = self.mRaidTimes + 10;
    self.mRaidTimes = math.min( self.mRaidTimes,self.mRaidTimesLeft);
    self.mRaidTimes = math.min( self.mRaidTimes,TableData.GlobalSystemData.RaidOnetimeLimit);
    self.mRaidTimes = math.max( self.mRaidTimes,1);

    self.UpdateView();

    --UIRaidPanel.CheckTimes();
end

function UIRaidPanel.OnAddMaxClick(gameobj)
    self = UIRaidPanel;

    local total =  GlobalData.GetStaminaResourceItemCount(GlobalConfig.StaminaId)
    local limit = math.floor(total / self.mStageData.StaminaCost);

    self.mRaidTimes = 999;
    self.mRaidTimes = math.min( self.mRaidTimes,self.mRaidTimesLeft);
    self.mRaidTimes = math.min( self.mRaidTimes,TableData.GlobalSystemData.RaidOnetimeLimit);
    self.mRaidTimes = math.min( self.mRaidTimes,limit);
    self.mRaidTimes = math.max( self.mRaidTimes,1);

    self.UpdateView();

    --UIRaidPanel.CheckTimes();
end


function UIRaidPanel.OnMinusTenClick(gameobj)
    self = UIRaidPanel;

    self.mRaidTimes = self.mRaidTimes - 10;
    self.mRaidTimes = math.max( self.mRaidTimes,1);

    self.UpdateView();

    UIRaidPanel.CheckTimes();
end

function UIRaidPanel.OnStartClick(gameobj)
    self = UIRaidPanel;

    if(self.mRaidTimesLeft == 0) then
        local hint = TableData.GetHintById(601);
        CS.PopupMessageManager.PopupString(hint);
        return;
    end
    if not TipsManager.CheckStaminaIsEnoughOnly(self.mStageData.stamina_cost * self.mRaidTimes) then
        return
    end
    --[[
    if(not self.IsStaminaEnough(self.mRaidTimes)) then
        local hint = TableData.GetHintById(602);
        CS.PopupMessageManager.PopupString(hint);
        UIManager.OpenUIByParam(UIDef.UICommonGetPanel,1)
        return;
    end
    --]]
    if(TipsManager.CheckRepositoryIsFull()) then
        --local hint = TableData.GetHintById(601);
        -- CS.PopupMessageManager.PopupString("仓库已满,请先整理仓库");
        return;
    end

    NetCmdRaidData:SendRaidCmd(self.mStageData.Id,self.mRaidTimes,self.OnRaidResult);

    self.OnStartRaid();
end

function UIRaidPanel.UpdateView()
    self = UIRaidPanel;
    -- self.mView:SetPosZ(-9);
    if self.mSimData ~= nil then
        if self.mSimData.SimType == 16 or self.mSimData.SimType == 17 then
            self.mRaidTimesLeft = NetCmdRaidData:GetRaidTimesLeftBySimDataId(self.mSimData.Id);
        else
            self.mRaidTimesLeft = NetCmdRaidData:GetRaidTimesLeftByStageId(self.mStageData.Id);
        end
    else
        if self.mStoryData ~= nil and self.mStoryData.daily_times > 0 then
            self.mRaidTimesLeft = self.mStoryData.daily_times - NetCmdDungeonData:DailyTimes(self.mStoryData.id)
        else
            self.mRaidTimesLeft = NetCmdRaidData:GetRaidTimesLeftByStageId(self.mStageData.Id);
        end
    end

    if(self.mRaidTimesLeft < 0) then
        self.mView.mText_TimeLimit.text =  "∞";
        self.mRaidTimesLeft = 999;
    else
        self.mView.mText_TimeLimit.text = self.mRaidTimesLeft;
    end

    --self.mView.mText_TimesNum.text = self.mRaidTimes;
    self.mView.mText_staminaNum.text = FormatNum(self.mRaidTimes * self.mStageData.StaminaCost) .. "/" .. GlobalData.GetStaminaResourceItemCount(GlobalConfig.StaminaId);
    self.mView.mText_NowNum.text = FormatNum(self.mRaidTimes)

    if(self.IsStaminaEnough(self.mRaidTimes)) then
        --self.mView.mText_TimesNum.color = Color.black;
        self.mView.mText_staminaNum.color = Color.black;
    else
        --self.mView.mText_TimesNum.color = Color.red;
        self.mView.mText_staminaNum.color = Color.red;
    end

    if(self.mRaidTimesLeft > 0) then
        self.mView.mText_TimeLimit.color = Color.black;
    else
        self.mView.mText_TimeLimit.color = Color.red;
    end

    local max = math.min(TableData.GlobalSystemData.RaidOnetimeLimit,self.mRaidTimesLeft);
    max = math.max(max,1);

    -- self.mRaidTimes = math.min( self.mRaidTimes,self.mRaidTimesLeft);
    -- self.mRaidTimes = math.min( self.mRaidTimes,TableData.GlobalSystemData.RaidOnetimeLimit);
    -- self.mRaidTimes = math.max( self.mRaidTimes,1);

    if(self.mRaidTimesLeft == 0) then
        self.mView.mSilderLine.maxValue = 0
        self.mView.mSilderLine.minValue = 0
        self.mView.mText_Min.text = 0;
        self.mView.mText_Max.text = 0;
        self.mView.mText_NowNum.text = 0
        self.mView.mSilderLine:SetValueWithoutNotify(0);
        return
    end

    self.mView.mText_Max.text = max;
    self.mView.mSilderLine.maxValue = max
    self.mView.mSilderLine:SetValueWithoutNotify(self.mRaidTimes)

    
end

function UIRaidPanel.OnStartRaid()
    self = UIRaidPanel;
    self.mView.mBtn_StartRaid.interactable = false;

    UIRaidPanel.mCanClose = false;
    UIManager.OpenUI(UIDef.UIRaidDuringPanel)

    UIRaidPanel.mTimer = TimerSys:DelayCall(2.1,function(idx) 
        if(UIRaidPanel.mRaidTimesLeft >= UIRaidPanel.mRaidTimes) then
            UIRaidPanel.mView.mBtn_StartRaid.interactable = true; 
        else
            UIRaidPanel.mView.mBtn_StartRaid.interactable = false; 
        end
        UIManager.CloseUI(UIDef.UIRaidDuringPanel)

        local result = NetCmdRaidData.ResultData;
        local items = result.RaidDropList;

        local rewardList = {}
        for _, value in pairs(items) do
            local item = {}
            item.ItemId = value.ItemId
            item.ItemNum = value.ItemNum
            table.insert(rewardList, item)
        end

        UIManager.OpenUIByParam(UIDef.UIRaidReceivePanel,{rewardList, nil, nil,nil,true})
        UIRaidPanel.mCanClose = true;
        
    end,0);
end

function UIRaidPanel.OnRaidResult(msg)
    self = UIRaidPanel;

    self.UpdateView()
    --setactive(self.mView.mTrans_RaidStart,true);
    --setactive(self.mView.mTrans_content,true);
    --setactive(self.mView.mTrans_ReadyToRaid,false);

    -- local result = NetCmdRaidData.ResultData;
    -- local items = result.RaidDropList;
    -- local prefab = UIUtils.GetGizmosPrefab(UICommonItemS.Path_UICommonItemS,self);

    -- for i = 0, self.mView.mTrans_ListRoot.transform.childCount-1 do
	-- 	local obj = self.mView.mTrans_ListRoot.transform:GetChild(i);
	-- 	gfdestroy(obj);
    -- end

    -- for i = 0, items.Count -1 do
    --     local item = UICommonItemS.New();
	-- 	local itemInst = instantiate(prefab);
	-- 	item:InitCtrl(itemInst.transform);
    --     item:SetData(items[i].ItemId,items[i].ItemNum);--掉落协议更新，这里简单处理
    --     UIUtils.AddListItem(itemInst,self.mView.mTrans_ListRoot.transform);
    -- end

    -- local levelup = AFKBattleManager.PlayerExpData.curLevel - AFKBattleManager.PlayerExpData.beginLevel;
    -- self.mView.mText_PlusExp.text = AFKBattleManager.PlayerExpData:GetAddExp();
    -- self.mView.mText_ExpBar.text = AFKBattleManager.PlayerExpData.curExp.. "/" ..AFKBattleManager.PlayerExpData:GetStcLevelExp();
    -- self.mView.mText_LV.text = AFKBattleManager.PlayerExpData.beginLevel;
    -- self.mView.mText_LVPlus.text = "+"..levelup;
    --self.mView.mImage_FillCur.fillAmount = AFKBattleManager.PlayerExpData:GetOldExpPct();

    -- local last_level = AFKBattleManager.PlayerExpData.beginLevel + AFKBattleManager.PlayerExpData:GetOldExpPct();
    -- local cur_level = AFKBattleManager.PlayerExpData.curLevel + AFKBattleManager.PlayerExpData:GetExpPct();

    -- CS.ProgressBarAnimationHelper.Play(self.mView.mImage_FillAft,last_level,cur_level,2,
    -- function (lv)
    --     print(lv);
    --     UIRaidPanel.mView.mText_LVPlus.text ="+"..(lv - AFKBattleManager.PlayerExpData.beginLevel);
    -- end,
    -- function ()
    --     --self.mView.mBtn_StartRaid.interactable = true;  
    --     if AccountNetCmdHandler.IsLevelUpdate==true then
    --         --UIManager.OpenUI(UIDef.UILevelUpRewardPanel);
    --         UICommonLevelUpPanel.Open(UICommonLevelUpPanel.ShowType.CommanderLevelUp)
    --     end 
    --     setactive(UIRaidPanel.mView.mTrans_ReadyToRaid,true);
    --     setactive(UIRaidPanel.mView.mTrans_RaidStart,false);
    --     --setactive(UIRaidPanel.mView.mTrans_content,false);
    --     print("over");
        
    -- end);


    -- if(levelup > 0) then
    --     setactive(self.mView.mImage_FillCur.gameObject, false);
    -- else
    --     setactive(self.mView.mImage_FillCur.gameObject, true);
    -- end
end

function UIRaidPanel.IsStaminaEnough(count)
    local cost = count * self.mStageData.StaminaCost;
    local total =  GlobalData.GetStaminaResourceItemCount(GlobalConfig.StaminaId)

    if(cost > total) then
        return false;
    end

    return true;
end

function UIRaidPanel.CheckTimes()
    self = UIRaidPanel;
    if(UIRaidPanel.mRaidTimesLeft >= self.mRaidTimes) then
        UIRaidPanel.mView.mBtn_StartRaid.interactable = true; 
    else
        UIRaidPanel.mView.mBtn_StartRaid.interactable = false; 
    end
end

function UIRaidPanel.CheckItemFull()
    
    local havenum=NetCmdEquipData:GetEquipCount();

    if(havenum > CS.GF2.Data.GlobalData.equip_capacity) then
        return true;
    end

    local chipList = NetCmdChipData:GetChipList(0);
    if(chipList.Count > CS.GF2.Data.GlobalData.weapon_capacity) then
        return true;
    end

    return false;
end

