require("UI.UIBasePanel")
require("UI.MaxPanelNew.UIMaxPanelNewView")

UIMaxPanelNew = class("UIMaxPanelNew",UIBasePanel);
UIMaxPanelNew.__index = UIMaxPanelNew;

UIMaxPanelNew.mView = nil;

UIMaxPanelNew.OverHeatedFlag = false

UIMaxPanelNew.HitCount = nil


UIMaxPanelNew.mPath_MaxPanel = "UIMaxPanelNew.prefab";

UIMaxPanelNew.mPanelState = gfenum({"waiting","initializing","shooting","driving","crashing","crashingOver","end"},-1);

UIMaxPanelNew.mCrashResultType = gfenum({"unfinished","win","lose","draw"},-1);

UIMaxPanelNew.mCrashResult = nil;

UIMaxPanelNew.mEndValue= 0;

UIMaxPanelNew.resultTime = 5;

UIMaxPanelNew.ringRadiusBegin = 0.5

UIMaxPanelNew.ringRadiusEnd = 0.05

UIMaxPanelNew.QTEWinValue = 0.2

UIMaxPanelNew.haveGotResult = false;

UIMaxPanelNew.fireButtonListener = nil;
--构造
function UIMaxPanelNew:ctor()
    UIMaxPanelNew.super.ctor(self)
end

function UIMaxPanelNew.Open()
    UIManager.OpenUI(UIDef.UIMaxPanelNew)
end

function UIMaxPanelNew.Close()
    UIManager.CloseUI(UIDef.UIMaxPanelNew)
end

function UIMaxPanelNew.Init(root,data)
    UIMaxPanelNew.super.SetRoot(UIMaxPanelNew,root)
    self = UIMaxPanelNew
    self.mView = UIMaxPanelNewView
    self.mView:InitCtrl(root);


--Init Properties
    self.ResetHitCount()
--Init components
    CS.LuaUIUtils.SetColor(self.mView.mImage_HeatBarLeft_Fill,"#FFFFFFFF")
    CS.LuaUIUtils.SetColor(self.mView.mImage_HeatBarRight_Fill,"#FFFFFFFF")

--set tween
    self.mHitMarkSequence = CS.LuaTweenUtils.Sequence()
    CS.LuaTweenUtils.Append(self.mHitMarkSequence,CS.LuaTweenUtils.Fade(self.mView.mCanvasG_HitMark,1,0.01))
    CS.LuaTweenUtils.Append(self.mHitMarkSequence,CS.LuaTweenUtils.Fade(self.mView.mCanvasG_HitMark,0,0.75))
    CS.LuaTweenUtils.SetAutoKill(self.mHitMarkSequence,false)

    self.mHitCountSequence = CS.LuaTweenUtils.Sequence()
    CS.LuaTweenUtils.AppendInterval(self.mHitCountSequence,3)
    CS.LuaTweenUtils.Append(self.mHitCountSequence,CS.LuaTweenUtils.Fade(self.mView.mCanvasG_HitsMark,0,0.5))
    CS.LuaTweenUtils.AppendInterval(self.mHitCountSequence,0.5)
    CS.LuaTweenUtils.AppendCallBack(self.mHitCountSequence,self.ResetHitCount)
    CS.LuaTweenUtils.SetAutoKill(self.mHitCountSequence,false)

    self.mResetSequence = CS.LuaTweenUtils.Sequence();
    CS.LuaTweenUtils.AppendInterval(self.mResetSequence, self.resultTime);
    CS.LuaTweenUtils.AppendCallBack(self.mResetSequence,self.ResetResult);
    CS.LuaTweenUtils.SetAutoKill(self.mResetSequence,false);

---event registration
    CS.GF2.Message.MessageSys.Instance:AddListener(7012,self.OnHeatChanged);
    CS.GF2.Message.MessageSys.Instance:AddListener(7008,self.OnHitEnemy);
    CS.GF2.Message.MessageSys.Instance:AddListener(7011,self.OnQTEBegin);
    CS.GF2.Message.MessageSys.Instance:AddListener(7007,self.OnSceneStateChanged);
    CS.GF2.Message.MessageSys.Instance:AddListener(7004,self.OnMainCharactorHpChange);
    CS.GF2.Message.MessageSys.Instance:AddListener(7013,self.OnMainCannonShot)
---button event
    local longPress = CS.LongPressTriggerListener.Set(self.mView.mBtn_ShootButton.gameObject,0.1,true);
    longPress.longPressStart = self.OnShootButtonPressed;
    longPress.longPressEnd = self.OnShootButtonEnd;

    --self.fireButtonListener = UIUtils.GetListener(self.mView.mBtn_ShootButton.gameObject)
    --UIUtils.GetListener(self.mView.mBtn_ShootButton.gameObject).onClick = self.OnShootButtonPressed;
    --UIUtils.GetListener(self.mView.mBtn_ShootButton.gameObject).onPress = self.OnShootButtonPressed;
    UIUtils.GetListener(self.mView.mBtn_QTEButton.gameObject).onClick = self.OnQTEButtonClicked;
    UIUtils.GetListener(self.mView.mBtn_ButtonExit.gameObject).onClick = self.OnExitButtonClicked
end

function UIMaxPanelNew.OnInit()

end

function UIMaxPanelNew.Update()

end

function UIMaxPanelNew.OnShow()

end

function UIMaxPanelNew.OnRelease()
    CS.GF2.Message.MessageSys.Instance:RemoveListener(7012,self.OnHeatChanged);
    CS.GF2.Message.MessageSys.Instance:RemoveListener(7008,self.OnHitEnemy);
    CS.GF2.Message.MessageSys.Instance:RemoveListener(7011,self.OnQTEBegin);
    CS.GF2.Message.MessageSys.Instance:RemoveListener(7007,self.OnSceneStateChanged);
    CS.GF2.Message.MessageSys.Instance:RemoveListener(7004,self.OnMainCharactorHpChange);
    CS.GF2.Message.MessageSys.Instance:RemoveListener(7013,self.OnMainCannonShot)
end


--------系统响应函数
function UIMaxPanelNew.OnHeatChanged(msg)
    self = UIMaxPanelNew
    gunHeatAmount = msg.Content
    mainCannon = msg.Sender
    self.mView.mImage_HeatBarLeft_Fill.fillAmount = gunHeatAmount
    self.mView.mImage_HeatBarRight_Fill.fillAmount = gunHeatAmount
    self.mView.mText_HeatPrecent.text = math.ceil(gunHeatAmount*100)
    self.OverHeatedHandler(mainCannon.GunOverHeatedLast)
    InnerLocalScale = self.mView.mTrans_AimPointInner.localScale
    deflectionAmount = mainCannon.DeflectionRange/mainCannon.MaxDeflectionRange
   -- gfdebug(deflectionAmount)

    InnerLocalScale.x = 1.5+1*deflectionAmount
    InnerLocalScale.y = InnerLocalScale.x
    self.mView.mTrans_AimPointInner.localScale = InnerLocalScale

    OuterlocalScale = self.mView.mTrans_AimPointOuter.localScale
    OuterlocalScale.x = 1.5+0.5*deflectionAmount
    OuterlocalScale.y = OuterlocalScale.x
    self.mView.mTrans_AimPointOuter.localScale = OuterlocalScale
end

function UIMaxPanelNew.OnHitEnemy(msg)
    self = UIMaxPanelNew
    CS.LuaTweenUtils.TweenRestart(self.mHitMarkSequence)
    CS.LuaTweenUtils.TweenRestart(self.mHitCountSequence)
    self.SetHitCount(self.HitCount +1)
end

function UIMaxPanelNew.OnMainCannonShot(msg)
    self = UIMaxPanelNew
end

function UIMaxPanelNew.OverHeatedHandler(GunOverHeatedLast)
    self = UIMaxPanelNew
    if(GunOverHeatedLast>0 and self.OverHeatedFlag==false)
    then self.OverHeatedFlag = true
         setactive(self.mView.mTrans_OverHeatMark,true)
         CS.LuaUIUtils.SetColor(self.mView.mImage_HeatBarLeft_Fill,"#C30000FF")
         CS.LuaUIUtils.SetColor(self.mView.mImage_HeatBarRight_Fill,"#C30000FF")
         self.mView.mCanvasG_ShootButton.alpha = 0.5;
    elseif(GunOverHeatedLast<=0 and self.OverHeatedFlag==true)
    then self.OverHeatedFlag = false
         setactive(self.mView.mTrans_OverHeatMark,false)
         CS.LuaUIUtils.SetColor(self.mView.mImage_HeatBarLeft_Fill,"#FFFFFFFF")
         CS.LuaUIUtils.SetColor(self.mView.mImage_HeatBarRight_Fill,"#FFFFFFFF")
         self.mView.mCanvasG_ShootButton.alpha = 1;
    end
end

function UIMaxPanelNew.ResetHitCount()
    UIMaxPanelNew.HitCount = 0
    UIMaxPanelNew.mView.mText_HitsMark.text = UIMaxPanelNew.HitCount
    UIMaxPanelNew.mView.mText_HitsMarkShadow.text = UIMaxPanelNew.HitCount
end

function UIMaxPanelNew.SetHitCount(count)
    UIMaxPanelNew.HitCount = count
    UIMaxPanelNew.mView.mText_HitsMark.text = UIMaxPanelNew.HitCount
    UIMaxPanelNew.mView.mText_HitsMarkShadow.text = UIMaxPanelNew.HitCount
end

function UIMaxPanelNew.OnMainCharactorHpChange(msg)
    self = UIMaxPanelNew;
    self.mView.mImage_HPSlider.fillAmount = msg.Sender.Hp/msg.Sender.MaxHp;
end
------------State-----------------

function UIMaxPanelNew.OnSceneStateChanged(msg)
    self = UIMaxPanelNew;
    state = msg.Sender;
    gfdebug (state);
    if state == CS.MadMaxScene.MaxState.battleBegin then self:OnBattleBegin();
    elseif state == CS.MadMaxScene.MaxState.changing then self:OnDrivingBegin();
    elseif state == CS.MadMaxScene.MaxState.crashing then self:OnCrashingBegin();
    elseif state == CS.MadMaxScene.MaxState.crashOver then self:OnCrashingOver();
    elseif state == CS.MadMaxScene.MaxState.driving then self:OnDrivingBegin();
    elseif state == CS.MadMaxScene.MaxState.shooting then self:OnShootingBegin();
    elseif state == CS.MadMaxScene.MaxState.ended then self:OnEnd(msg);
    end
end

function UIMaxPanelNew:OnBattleBegin()
    setactive(self.mView.mTrans_QTEPanel,false);
    setactive(self.mView.mTrans_Result,false)
    setactive(self.mView.mTrans_ShootingPanel,false);
    setactive(self.mView.mTrans_SettlementPanel,false);
end

function UIMaxPanelNew:OnDrivingBegin()
    setactive(self.mView.mTrans_ShootingPanel,false);
    self.OnShootButtonEnd()
end
--QTE阶段在OnQTEBegin中特别处理
function UIMaxPanelNew:OnCrashingBegin()

end

function UIMaxPanelNew:OnCrashingOver()
    setactive(self.mView.mTrans_QTEZone,false);
end

function UIMaxPanelNew:OnShootingBegin()
    setactive(self.mView.mTrans_ShootingPanel,true);
end

function UIMaxPanelNew:OnEnd(msg)
    setactive(self.mView.mTrans_ShootingPanel,false);
    self.OnShootButtonEnd()
    setactive(self.mView.mTrans_QTEPanel,false)
    if msg.Content == "backToBase" then
        return
    end

    setactive(self.mView.mTrans_SettlementPanel,true)
--[[   setactive(self.mView.mButton_ReturnButton,true);
    local result = msg.content;
    if result==CS.MaxBattleResult.win then
        setactive(self.mView.mObj_Win,true);
    elseif result==CS.MaxBattleResult.lose then
        setactive(self.mView.mObj_Lose,true);
    end
    ]]--
end


-----QTE
function UIMaxPanelNew.OnQTEBegin(mes)
    self = UIMaxPanelNew
    --self.fireButtonListener.IsPress = false;
    self.haveGotResult = false;
    setactive(self.mView.mTrans_QTEPanel,true);
    setactive(self.mView.mTrans_QTEZone,true)
    setactive(self.mView.mTrans_ShootingPanel,false)
    self.OnShootButtonEnd()
    self.mCrashResult = self.mCrashResultType.unfinished
    local time = mes.Sender.durationWithScale
    self.CreateQTESequence(time)
    CS.LuaTweenUtils.TweenRestart(self.mShrunkSequence)
    CS.LuaTweenUtils.TweenRestart(self.mShrunkSequence2)
end



function UIMaxPanelNew.CreateQTESequence(time)
    self = UIMaxPanelNew
    self.mShrunkSequence = CS.LuaTweenUtils.Sequence();
    local material = self.mView.mImage_QTERingBack.material
    local resetfloat = CS.LuaTweenUtils.MaterialDoFloat(material,self.ringRadiusBegin,"_Radius",0.1)
    local floatTween = CS.LuaTweenUtils.MaterialDoFloat(material,self.ringRadiusEnd,"_Radius",time)
    self.mShrunkSequence = CS.LuaTweenUtils.Append(self.mShrunkSequence,resetfloat)
    self.mShrunkSequence = CS.LuaTweenUtils.Append(self.mShrunkSequence,floatTween)
    self.mShrunkSequence = CS.LuaTweenUtils.AppendCallBack(self.mShrunkSequence,self.OnQTEMissed)

    self.mShrunkSequence2 = CS.LuaTweenUtils.Sequence();
    local material2 = self.mView.mImage_QTERingFront.material
    local resetfloat2 = CS.LuaTweenUtils.MaterialDoFloat(material2,self.ringRadiusBegin,"_Radius",0.1)
    local floatTween2 = CS.LuaTweenUtils.MaterialDoFloat(material2,self.ringRadiusEnd,"_Radius",time)
    self.mShrunkSequence2 = CS.LuaTweenUtils.Append(self.mShrunkSequence2,resetfloat2)
    self.mShrunkSequence2 = CS.LuaTweenUtils.Append(self.mShrunkSequence2,floatTween2)

end

function UIMaxPanelNew.OnQTEButtonClicked()
    gfdebug("QTEClicked!")
    if self.haveGotResult then
        return
    end
    local currentValue = CS.LuaUIUtils.GetMaterialFloat(self.mView.mImage_QTERingBack.material,"_Radius")
    local resultValue = (currentValue - self.ringRadiusEnd)/(self.ringRadiusBegin-self.ringRadiusEnd)
    gfdebug("GotValue!")
    if resultValue < self.QTEWinValue then
        self.mCrashResult = self.mCrashResultType.win
    else
        self.mCrashResult = self.mCrashResultType.draw
    end
    gfdebug("PrepareAfterQTE!")
    self.AfterQTE()

end

function UIMaxPanelNew.OnQTEMissed()
    self = UIMaxPanelNew
    if self.haveGotResult then
        return
    end

    self.mCrashResult = self.mCrashResultType.lose
    self.AfterQTE()
end

function UIMaxPanelNew.AfterQTE()
    self = UIMaxPanelNew
    self.haveGotResult = true
    CS.GF2.Message.MessageSys.Instance:SendMessage(CS.GF2.Message.MaxSceneEvent.QTEOver,self.mCrashResult);
    if self.mCrashResult==self.mCrashResultType.win then
        setactive(self.mView.mTrans_Perfect,true)
    elseif self.mCrashResult == self.mCrashResultType.draw then
        setactive(self.mView.mTrans_Good,true)
    elseif self.mCrashResult == self.mCrashResultType.lose then
        setactive(self.mView.mTrans_Bad,true)
    end
    setactive(self.mView.mTrans_Result,true)
    setactive(self.mView.mTrans_QTEZone,false)
    CS.LuaTweenUtils.TweenRestart(self.mResetSequence)
end

function UIMaxPanelNew.ResetResult()
    self = UIMaxPanelNew
    setactive(self.mView.mTrans_Perfect,false);
    setactive(self.mView.mTrans_Good,false);
    setactive(self.mView.mTrans_Bad,false);
    setactive(self.mView.mTrans_Result,false);

end

--[[function UIMaxPanelNew.QTEOver()
    self = UIMaxPanelNew
    CS.GF2.Message.MessageSys.Instance:SendMessage(CS.GF2.Message.MaxSceneEvent.QTEOver,self.mCrashResult)

end--]]

----button
function UIMaxPanelNew.OnShootButtonPressed()
    CS.GF2.Message.MessageSys.Instance:SendMessage(CS.GF2.Message.MaxUIEvent.MaxManagerShootPressed,1);
end

function UIMaxPanelNew.OnShootButtonEnd()
    CS.GF2.Message.MessageSys.Instance:SendMessage(CS.GF2.Message.MaxUIEvent.MaxManagerShootPressed,0);
end
function UIMaxPanelNew.OnExitButtonClicked()
    gfdebug("Exit!")
    CS.SceneSys.Instance:ReturnLast();
end