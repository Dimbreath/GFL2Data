--region *.lua

--�����controller
require("UI.UIBasePanel")
require("UI.MadMax.UIMaxPanelView")

UIMaxPanel = class("UIMaxPanel",UIBasePanel);
UIMaxPanel.__index = UIMaxPanel;

UIMaxPanel.mView = nil;

UIMaxPanel.mPath_MaxPanel = "UIMaxPanel.prefab";

UIMaxPanel.mPanelState = gfenum({"waiting","initializing","shooting","driving","crashing","crashingOver","end"},-1);

UIMaxPanel.mCrashResultType = gfenum({"unfinished","win","lose","draw"},-1);

UIMaxPanel.mCrashResult = nil;

UIMaxPanel.mEndValue= 0;

UIMaxPanel.resultTime = 10;

UIMaxPanel.ringRadiusBegin = 0.5

UIMaxPanel.ringRadiusEnd = 0.05

UIMaxPanel.QTEWinValue = 0.2

UIMaxPanel.haveGotResult = false;

--UIMaxPanel.fireButtonListener = nil;
--����
function UIMaxPanel:ctor()
	UIMaxPanel.super.ctor(self);
end

function UIMaxPanel.Open()
	UIManager.OpenUI(UIDef.UIMaxPanel);
end

function UIMaxPanel.Close()
	UIManager.CloseUI(UIDef.UIMaxPanel);
end

function UIMaxPanel.Init(root,data)
	UIMaxPanel.super.SetRoot(UIMaxPanel,root);
	
	self = UIMaxPanel;
	
	self.mView = UIMaxPanelView;
	self.mView:InitCtrl(root);
	
	self.mHaveGottenResult = false;
	self.mCrashResult = self.mCrashResultType.unfinished

	local longPress = CS.LongPressTriggerListener.Set(self.mView.mButton_ShootButton.gameObject,0.1,true);
	longPress.longPressStart = self.OnShootButtonPressed;
	longPress.longPressEnd = self.OnShootButtonEnd;

	--self.fireButtonListener = UIUtils.GetListener(self.mView.mButton_ShootButton.gameObject)
	--UIUtils.GetListener(self.mView.mButton_ShootButton.gameObject).onPress = self.OnShootButtonPressed;
	UIUtils.GetListener(self.mView.mButton_QTEButton.gameObject).onClick = self.OnQTEButtonClicked;
	UIUtils.GetListener(self.mView.mButton_ReturnButton.gameObject).onClick = self.OnReturnButtonClicked;
	--������������ý����ʾʱ���
	self.mResetSequence = CS.LuaTweenUtils.Sequence();
	CS.LuaTweenUtils.AppendInterval(self.mResetSequence, self.resultTime);
	CS.LuaTweenUtils.AppendCallBack(self.mResetSequence,self.ResetResult);
	CS.LuaTweenUtils.SetAutoKill(self.mResetSequence,false);
	
	
	
	
	CS.GF2.Message.MessageSys.Instance:AddListener(7004,self.OnMainCharactorHpChange);
	CS.GF2.Message.MessageSys.Instance:AddListener(7007,self.OnSceneStateChanged);
	CS.GF2.Message.MessageSys.Instance:AddListener(7011,self.OnQTEBegin);
	CS.GF2.Message.MessageSys.Instance:AddListener(7012,self.OnMainCannonHeatChanged);
end

--[[function UIMaxPanel.InitActivity()
	self = UIMaxPanel
	self.mView.mPanel_QTEPanel:SetActive(false) 
	
end--]]

function UIMaxPanel.OnInit()

end

function UIMaxPanel.Update()
	
end	
	

function UIMaxPanel.OnShow()
	
end

function UIMaxPanel.OnRelease()
	self = UIMaxPanel;
	CS.GF2.Message.MessageSys.Instance:RemoveListener(7004,self.OnMainCharactorHpChange);
	CS.GF2.Message.MessageSys.Instance:RemoveListener(7007,self.OnSceneStateChanged);
	CS.GF2.Message.MessageSys.Instance:RemoveListener(7011,self.OnQTEBegin);
	CS.GF2.Message.MessageSys.Instance:RemoveListener(7012,self.OnMainCannonHeatChanged);
	UIMaxPanel.mHaveGottenResult = false;
end


-------�����¼���Ӧ����

function UIMaxPanel.OnSceneStateChanged(msg)
	self = UIMaxPanel;
	state = msg.Sender;
	print (state);
	if state == CS.MadMaxScene.MaxState.battleBegin then self:OnBattleBegin();
	elseif state == CS.MadMaxScene.MaxState.changing then self:OnDrivingBegin();
	elseif state == CS.MadMaxScene.MaxState.crashing then self:OnCrashingBegin();
	elseif state == CS.MadMaxScene.MaxState.crashOver then self:OnCrashingOver();
	elseif state == CS.MadMaxScene.MaxState.driving then self:OnDrivingBegin();
	elseif state == CS.MadMaxScene.MaxState.shooting then self:OnShootingBegin();
	elseif state == CS.MadMaxScene.MaxState.ended then self:OnEnd(msg);
	end
end


function UIMaxPanel.OnMainCannonHeatChanged(msg)
	self = UIMaxPanel
	gunHeatAmount = msg.Sender
	self.mView.mImage_HeatSlider.fillAmount = gunHeatAmount
	
end

------------State-----------------
function UIMaxPanel:OnBattleBegin()
	setactive(self.mView.mPanel_QTEPanel,false);
	setactive(self.mView.mObj_Win,false);
	setactive(self.mView.mObj_Lose,false);
	setactive(self.mView.mPanel_ShootingPanel,false);
end

function UIMaxPanel:OnDrivingBegin()
	setactive(self.mView.mPanel_ShootingPanel,false);
end

function UIMaxPanel:OnCrashingBegin()
	self.mHaveGottenResult = false;
	gfwarning("CrashingBegin!")
	--self.fireButtonListener.IsPress = false;
	setactive(self.mView.mPanel_ShootingPanel,false);
	setactive(self.mView.mPanel_QTEPanel,true);
	self.mCrashResult = self.mCrashResultType.unfinished
	self.QTEBegin();
end

function UIMaxPanel:OnCrashingOver()
	setactive(self.mView.mPanel_QTEPanel,false);
end

function UIMaxPanel:OnShootingBegin()
	setactive(self.mView.mPanel_ShootingPanel,true);
end

function UIMaxPanel:OnEnd(msg)
	setactive(self.mView.mPanel_ShootingPanel,false);
	setactive(self.mView.mButton_ReturnButton,true);
	local result = msg.content;
	if result==CS.MaxBattleResult.win then
		setactive(self.mView.mObj_Win,true);
	elseif result==CS.MaxBattleResult.lose then
		setactive(self.mView.mObj_Lose,true);
	end
end

-------------Button--------------

function UIMaxPanel.OnShootButtonPressed()
	CS.GF2.Message.MessageSys.Instance:SendMessage(CS.GF2.Message.MaxUIEvent.MaxManagerShootPressed,1);
end

function UIMaxPanel.OnShootButtonEnd()
	CS.GF2.Message.MessageSys.Instance:SendMessage(CS.GF2.Message.MaxUIEvent.MaxManagerShootPressed,0);
end

function UIMaxPanel.OnReturnButtonClicked()
	CS.SceneSys.Instance:ReturnLast();
end

function UIMaxPanel.OnMainCharactorHpChange(msg)
	self = UIMaxPanel;
	self.mView.mImage_HPSlider.fillAmount = msg.Sender.Hp/msg.Sender.MaxHp;
end


---------------------------------------------------------->>>> QTE <<<<----------------------------------------------
function UIMaxPanel.OnQTEButtonClicked()
	if haveGotResult then
		return
	end
	local currentValue = CS.LuaUIUtils.GetMaterialFloat(self.mView.mImage_QTERingBack.material,"_Radius")
	local resultValue = (currentValue - self.ringRadiusEnd)/(self.ringRadiusBegin-self.ringRadiusEnd)
	if resultValue < self.QTEWinValue then
		self.mCrashResult = self.mCrashResultType.win
	else
		self.mCrashResult = self.mCrashResultType.draw
	end
	self.AfterQTE()
	
end
function UIMaxPanel.AfterQTE()
	self = UIMaxPanel
	self.haveGotResult = true
	CS.GF2.Message.MessageSys.Instance:SendMessage(CS.GF2.Message.MaxUIEvent.MaxManagerQTEOver,self.mCrashResult);
	if self.mCrashResult==self.mCrashResultType.win then
		setactive(self.mView.mObj_ResultGood,true)
	elseif self.mCrashResult == self.mCrashResultType.draw then
		setactive(self.mView.mObj_ResultOK,true)
	elseif self.mCrashResult == self.mCrashResultType.lose then
		setactive(self.mView.mObj_ResultMiss,true)
	end
	setactive(self.mView.mPanel_QTERings,false)
	CS.LuaTweenUtils.TweenRestart(self.mResetSequence)
	self.QTEOver()
end

function UIMaxPanel.OnQTEBegin(mes)
	self = UIMaxPanel
	gfwarning("QTEBegin!")
	--self.fireButtonListener.IsPress = false;
	local time = mes.Sender.durationWithScale
	self.CreateSequence(time)
	setactive(self.mView.mPanel_QTERings,true)
	CS.LuaTweenUtils.TweenRestart(self.mShrunkSequence)
	CS.LuaTweenUtils.TweenRestart(self.mShrunkSequence2)
end

function UIMaxPanel.OnQTEMissed()
	self = UIMaxPanel
	if self.haveGotResult then
		return
	end

	self.mCrashResult = self.mCrashResultType.lose
	self.AfterQTE()
end
	
function UIMaxPanel.QTEBegin()
	self = UIMaxPanel
	self.haveGotResult = false;
end

function UIMaxPanel.QTEOver()
	CS.GF2.Message.MessageSys.Instance:SendMessage(CS.GF2.Message.MaxSceneEvent.QTEOver,nil)

end
function UIMaxPanel.CreateSequence(time)	
	self = UIMaxPanel
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




function UIMaxPanel.ResetResult()
	self = UIMaxPanel
	setactive(self.mView.mObj_ResultGood,false);
	setactive(self.mView.mObj_ResultOK,false);
	setactive(self.mView.mObj_ResultMiss,false);
	setactive(self.mView.mPanel_QTEPanel,false);

end




