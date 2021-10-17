require("UI.UIBaseCtrl")

UIDoUpgradePanel = class("UIDoUpgradePanel", UIBaseCtrl);
UIDoUpgradePanel.__index = UIDoUpgradePanel
--@@ GF Auto Gen Block Begin
UIDoUpgradePanel.mBtn_Close = nil;
UIDoUpgradePanel.mText_SlotHP_Before = nil;
UIDoUpgradePanel.mText_SlotHP_After = nil;
UIDoUpgradePanel.mText_SlotATK_Before = nil;
UIDoUpgradePanel.mText_SlotATK_After = nil;
UIDoUpgradePanel.mText_SlotDEF_Before = nil;
UIDoUpgradePanel.mText_SlotDEF_After = nil;
UIDoUpgradePanel.mText_Before_Effect = nil;
UIDoUpgradePanel.mText_After_Effect = nil;
UIDoUpgradePanel.mText_Dialog_Text = nil;
UIDoUpgradePanel.mText_Close_Text = nil;
UIDoUpgradePanel.mTrans_StarLayout = nil;
UIDoUpgradePanel.mTrans_Dialog = nil;
UIDoUpgradePanel.mTrans_TalentUpPanel = nil;
UIDoUpgradePanel.mTrans_PropertyUpPanel = nil;

UIDoUpgradePanel.mGunInfo = nil;
UIDoUpgradePanel.mStep = 0;
UIDoUpgradePanel.mTweenEase = CS.DG.Tweening.Ease.InOutElastic;
UIDoUpgradePanel.mTweenExpo = CS.DG.Tweening.Ease.InOutBack;
UIDoUpgradePanel.mPathStar = "UICommonFramework/StarA.prefab";

UIDoUpgradePanel.mPropertyUpPanelToPos = nil;
UIDoUpgradePanel.mPropertyUpPanelFromPos = nil;

function UIDoUpgradePanel:__InitCtrl()

	self.mBtn_Close = self:GetButton("Btn_Close");
	self.mText_SlotHP_Before = self:GetText("PropertyUpPanel/UI_SlotHP/Layout/Text_Before");
	self.mText_SlotHP_After = self:GetText("PropertyUpPanel/UI_SlotHP/Layout/Text_After");
	self.mText_SlotATK_Before = self:GetText("PropertyUpPanel/UI_SlotATK/Layout/Text_Before");
	self.mText_SlotATK_After = self:GetText("PropertyUpPanel/UI_SlotATK/Layout/Text_After");
	self.mText_SlotDEF_Before = self:GetText("PropertyUpPanel/UI_SlotDEF/Layout/Text_Before");
	self.mText_SlotDEF_After = self:GetText("PropertyUpPanel/UI_SlotDEF/Layout/Text_After");
	self.mText_Before_Effect = self:GetText("TalentUpPanel/UI_Before/Text_Effect");
	self.mText_After_Effect = self:GetText("TalentUpPanel/UI_After/Text_Effect");
	self.mText_Dialog_Text = self:GetText("Trans_Dialog/Text");
	self.mText_Close_Text = self:GetText("Btn_Close/Text");
	self.mTrans_StarLayout = self:GetRectTransform("Trans_StarLayout");
	self.mTrans_Dialog = self:GetRectTransform("Trans_Dialog");
	self.mTrans_TalentUpPanel = self:GetRectTransform("TalentUpPanel");
	self.mTrans_PropertyUpPanel = self:GetRectTransform("PropertyUpPanel");
end

--@@ GF Auto Gen Block End

function UIDoUpgradePanel.Init(root, data)
    self = UIDoUpgradePanel;
    self:SetRoot(root);

	self:__InitCtrl();

	self.mGunInfo = data;
	self.mPropertyUpPanelToPos = self.mTrans_PropertyUpPanel.transform.localPosition;
	self.mPropertyUpPanelFromPos = (self.mPropertyUpPanelToPos + Vector3(-1500,0,0));

	UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = self.OnCloseClicked;

	self:ShowPanel();
	self:SetStars();
	self:SetBeforeValues();
	self:SetAfterValues();
end

function UIDoUpgradePanel:ShowPanel()
	local to = self.mPropertyUpPanelToPos;
	local from =  self.mPropertyUpPanelFromPos;
	
	CS.UITweenManager.PlayLocalPositionTween(self.mTrans_PropertyUpPanel.transform,from,to,0.5,nil,self.mTweenExpo);
	CS.UITweenManager.PlayFadeTweens(self.mTrans_PropertyUpPanel.transform,0,1,0.5);	
	
	--setactive(self.mText_Close_Text.gameObject,false);
	self.CloseTextFlash();
end

function UIDoUpgradePanel:SetStars()
	local prefab = UIUtils.GetGizmosPrefab(self.mPathStar,self);
	local n = self.mGunInfo.upgrade;
	
	for i = 0, self.mTrans_StarLayout.transform.childCount-1 do
		local obj = self.mTrans_StarLayout.transform:GetChild(i);
		gfdestroy(obj);
	end

	for i = 1, n do 
		local prefabIns = instantiate(prefab);
		UIUtils.AddListItem(prefabIns, self.mTrans_StarLayout);
	end
end

function UIDoUpgradePanel:SetBeforeValues()
	local text = self.mGunInfo.TabGunData.upgrade_speech;
	CS.TypeTextComponentUtility.TypeText(self.mText_Dialog_Text,text, 0.05);

	local beforeHp = self.mGunInfo.max_hp - self.mGunInfo:UpgradeAddValue(self.mGunInfo.upgrade,CS.EPropType.max_hp);
	local beforeAtk = self.mGunInfo.pow - self.mGunInfo:UpgradeAddValue(self.mGunInfo.upgrade,CS.EPropType.pow);
	local beforeDef = self.mGunInfo.armor - self.mGunInfo:UpgradeAddValue(self.mGunInfo.upgrade,CS.EPropType.armor);

	self.mText_SlotHP_Before.text = beforeHp;
	self.mText_SlotATK_Before.text = beforeAtk;
	self.mText_SlotDEF_Before.text = beforeDef;
end

function UIDoUpgradePanel:SetAfterValues()
	self.FadeInUIComponent(self.mText_SlotHP_After,1.0,nil);
	self.FadeInUIComponent(self.mText_SlotATK_After,1.5,nil);
	self.FadeInUIComponent(self.mText_SlotDEF_After,2.0,nil);

	self.mText_SlotHP_After.text = self.mGunInfo.max_hp;
	self.mText_SlotATK_After.text = self.mGunInfo.pow;
	self.mText_SlotDEF_After.text = self.mGunInfo.armor;
end

function UIDoUpgradePanel:SetTalent()
	--self.FadeInUIComponent(self.mText_After_Effect,0.5);
	CS.UITweenManager.PlayFadeTween(self.mText_After_Effect.transform,0,1,0.5,0.5,nil);	
	self.mText_Before_Effect.text = self.mGunInfo:GetTalentByUpgrade(self.mGunInfo.upgrade-1).description;
	self.mText_After_Effect.text = self.mGunInfo:GetTalentByUpgrade(self.mGunInfo.upgrade).description;
end

function UIDoUpgradePanel.FadeInUIComponent(component,delay,callback)
	CS.UITweenManager.PlayFadeTween(component.transform,0,1,0.5,delay,nil);	
	CS.UITweenManager.PlayScaleTween(component.transform,vectorzero,vectorone,0.5,delay,callback,self.mTweenEase);	
end

function UIDoUpgradePanel.CloseTextFlash()
	self = UIDoUpgradePanel;
	setactive(self.mText_Close_Text.gameObject,true);
	CS.UITweenManager.PlayFadePingPangTween(self.mText_Close_Text.transform,0,1,0.5);	
end

function UIDoUpgradePanel.OnCloseClicked()
	self = UIDoUpgradePanel;
	self.mStep = self.mStep + 1;

	if(self.mStep <= 1) then
		setactive(self.mTrans_TalentUpPanel.gameObject,true);
		setactive(self.mTrans_PropertyUpPanel.gameObject,false);
		self:SetTalent();
	else
		UIManager.CloseUI(UIDef.UIDoUpgradePanel);
		UIFacilityBarrackPanel:Show(true);
	end
end

function UIDoUpgradePanel.OnRelease()
    self = UIDoUpgradePanel;
	gfdebug("OnRelease");
	self.mStep = 0;
end