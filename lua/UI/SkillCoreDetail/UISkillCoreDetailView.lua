require("UI.UIBaseView")

UISkillCoreDetailView = class("UISkillCoreDetailView", UIBaseView);
UISkillCoreDetailView.__index = UISkillCoreDetailView

UISkillCoreDetailView.mBtn_Return = nil;
UISkillCoreDetailView.mBtn_powerUp = nil;
UISkillCoreDetailView.mBtn_AddMaterial = nil;
UISkillCoreDetailView.mBtn_PowerUpButton = nil;
UISkillCoreDetailView.mBtn_SkillPUmatItemEmpty = nil;
UISkillCoreDetailView.mBtn_PUReturn = nil;
UISkillCoreDetailView.mImage_SkillIcon = nil;
UISkillCoreDetailView.mImage_Rank = nil;
UISkillCoreDetailView.mImage_CurFill = nil;
UISkillCoreDetailView.mImage_AftFill = nil;
UISkillCoreDetailView.mText_SkillNameText = nil;
UISkillCoreDetailView.mText_LvText = nil;
UISkillCoreDetailView.mText_TypeText = nil;
UISkillCoreDetailView.mText_EffectText = nil;
UISkillCoreDetailView.mText_before_lv = nil;
UISkillCoreDetailView.mText_before_description = nil;
UISkillCoreDetailView.mText_after_lv = nil;
UISkillCoreDetailView.mText_after_description = nil;
UISkillCoreDetailView.mText_ExpText = nil;
UISkillCoreDetailView.mText_coinCost = nil;
UISkillCoreDetailView.mTrans_OverViewPanel = nil;
UISkillCoreDetailView.mTrans_PowerUpPanel = nil;
UISkillCoreDetailView.mTrans_MaterialList = nil;
UISkillCoreDetailView.mTrans_SkillPUmatItemEmpty = nil;
UISkillCoreDetailView.mTrans_after_max = nil;
UISkillCoreDetailView.mTrans_LVUP = nil;

UISkillCoreDetailView.mData = nil;
UISkillCoreDetailView.mStcData = nil;
UISkillCoreDetailView.mPowerUpButtonOnClick = nil;
UISkillCoreDetailView.mCoreMaxLevel = 10;

UISkillCoreDetailView.mBeforeScale = nil;
UISkillCoreDetailView.mAfterScale = nil;

UISkillCoreDetailView.mTweenEase = CS.DG.Tweening.Ease.InOutSine;
UISkillCoreDetailView.mTweenCirc = CS.DG.Tweening.Ease.OutCirc;
UISkillCoreDetailView.mOutBounce = CS.DG.Tweening.Ease.OutBounce;

function UISkillCoreDetailView:__InitCtrl()

	self.mBtn_Return = self:GetButton("Trans_OverViewPanel/Btn_Return");
	self.mBtn_powerUp = self:GetButton("Trans_OverViewPanel/Btn_powerUp");
	self.mBtn_AddMaterial = self:GetButton("Trans_PowerUpPanel/Material/Btn_AddMaterial");
	self.mBtn_PowerUpButton = self:GetButton("Trans_PowerUpPanel/Btn_PowerUpButton");
	self.mBtn_SkillPUmatItemEmpty = self:GetButton("Trans_PowerUpPanel/Material/Trans_MaterialList/Trans_SkillPUmatItemEmpty");
	self.mBtn_PUReturn = self:GetButton("Trans_PowerUpPanel/Btn_PUReturn");
	self.mImage_SkillIcon = self:GetImage("Trans_OverViewPanel/SkillIcon/Image_SkillIcon");
	self.mImage_Rank = self:GetImage("Trans_OverViewPanel/Image_Rank");
	self.mImage_CurFill = self:GetImage("Trans_PowerUpPanel/Exp/FillArea/Image_CurFill");
	self.mImage_AftFill = self:GetImage("Trans_PowerUpPanel/Exp/FillArea/Image_AftFill");
	self.mText_SkillNameText = self:GetText("Trans_OverViewPanel/Name/Text_SkillNameText");
	self.mText_LvText = self:GetText("Trans_OverViewPanel/Lv/Text_LvText");
	self.mText_TypeText = self:GetText("Trans_OverViewPanel/Type/Text_TypeText");
	self.mText_EffectText = self:GetText("Trans_OverViewPanel/effect/Text_EffectText");
	self.mText_before_lv = self:GetText("Trans_PowerUpPanel/Effect/UI_before/Image/Text_lv");
	self.mText_before_description = self:GetText("Trans_PowerUpPanel/Effect/UI_before/Text_description");
	self.mText_after_lv = self:GetText("Trans_PowerUpPanel/Effect/UI_after/Image/Text_lv");
	self.mText_after_description = self:GetText("Trans_PowerUpPanel/Effect/UI_after/Text_description");
	self.mText_ExpText = self:GetText("Trans_PowerUpPanel/Exp/Text_ExpText");
	self.mText_coinCost = self:GetText("Trans_PowerUpPanel/CoinCost/Text_coinCost");
	self.mTrans_OverViewPanel = self:GetRectTransform("Trans_OverViewPanel");
	self.mTrans_PowerUpPanel = self:GetRectTransform("Trans_PowerUpPanel");
	self.mTrans_MaterialList = self:GetRectTransform("Trans_PowerUpPanel/Material/Trans_MaterialList");
	self.mTrans_SkillPUmatItemEmpty = self:GetRectTransform("Trans_PowerUpPanel/Material/Trans_MaterialList/Trans_SkillPUmatItemEmpty");
	self.mTrans_after_max = self:GetRectTransform("Trans_PowerUpPanel/Effect/UI_after/Trans_Mask_max");
	self.mTrans_LVUP = self:GetRectTransform("Trans_PowerUpPanel/Exp/Trans_LVUP");
	
	setactive(self.mTrans_LVUP.gameObject,false);
end

function UISkillCoreDetailView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UISkillCoreDetailView:InitData(data)
	self.mData = data;
	self.mStcData = TableData.GetSkillCoreDataById(data.stc_id);

	local icon = TableData.GetSkillIconByCoreId(self.mStcData.id);
	local type = self.mStcData.type;
	
	self.mImage_SkillIcon.sprite = UIUtils.GetIconSprite("Icon/Skill",icon);
	self.mText_SkillNameText.text = TableData.GetSkillCoreSkillNameById(self.mStcData.skill_group_id);
	self.mText_LvText.text = data.level;
	self.mText_EffectText.text = TableData.GetSkillLvDescriptionById(self.mStcData.skill_group_id,self.mData.level);
	
	if(type == 1) then
		self.mText_TypeText.text = "主动";
	else
		self.mText_TypeText.text = "被动";
	end
	
	self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(self.mStcData.rank);
	self.mCoreMaxLevel = self.mStcData.max_level;
end

function UISkillCoreDetailView:InitPowerUpView(data,addExp)
	self.mData = data;
	
	--描述
	self.mText_before_lv.text = self.mData.level;	
	self.mText_before_description.text = TableData.GetSkillLvDescriptionById(self.mStcData.skill_group_id,self.mData.level);
	
	if(self.mData.level < self.mCoreMaxLevel) then
		setactive(self.mText_after_lv.gameObject,true);
		setactive(self.mText_after_description.gameObject,true);
		setactive(self.mBtn_AddMaterial.gameObject,true);
		setactive(self.mTrans_after_max.gameObject,false);
		self.mText_after_lv.text = self.mData.level + 1;
		self.mText_after_description.text = TableData.GetSkillLvDescriptionById(self.mStcData.skill_group_id,self.mData.level + 1);
	else
		setactive(self.mText_after_lv.gameObject,false);
		setactive(self.mText_after_description.gameObject,false);
		setactive(self.mBtn_AddMaterial.gameObject,false);
		setactive(self.mTrans_after_max.gameObject,true);
	end
	
	self.mText_LvText.text = data.level;
	self.mText_EffectText.text = TableData.GetSkillLvDescriptionById(self.mStcData.skill_group_id,self.mData.level);
	
	--经验
	local curExp = self.mData.exp;
	local sumExp = curExp + addExp;
	local nextLvExp = NetCmdCoreData:GetSkillCoreNextLvExp(self.mData);
	
	if(self.mData.level >= self.mStcData.max_level) then
		sumExp = nextLvExp;
		curExp = nextLvExp;
	end
	
	self.mText_ExpText.text = sumExp.."/"..nextLvExp;
	
	self.mBeforeScale = Vector3(curExp/nextLvExp,1,1);
	self.mAfterScale = Vector3(math.min(sumExp/nextLvExp,1),1,1);
	setscale(self.mImage_CurFill.gameObject,self.mBeforeScale);
	--setscale(self.mImage_AftFill.gameObject,afterScale);	
	
	if(self.mImage_AftFill.transform.localScale.x < 1) then
		CS.UITweenManager.PlayScaleTween(self.mImage_AftFill.transform,self.mImage_AftFill.transform.localScale,self.mAfterScale,0.7,0.3,nil,self.mTweenCirc);
	else
		setscale(self.mImage_AftFill.gameObject,self.mAfterScale);	
	end
	
	if(sumExp >= nextLvExp and self.mData.level < self.mStcData.max_level) then
		setactive(self.mTrans_LVUP.gameObject,true);
		CS.UITweenManager.PlayScaleTween(self.mTrans_LVUP.transform,vectorzero,vectorone,0.3,0.9,nil,self.mOutBounce);
	else
		setactive(self.mTrans_LVUP.gameObject,false);
	end
	
	--消耗
	local curCost = NetCmdCoreData:GetSkillCoreCashCost(addExp,self.mData.level);
	local playerCash = GlobalData.cash;
	self.mText_coinCost.text = curCost.."/"..playerCash;
	
	--按钮
	if(addExp <= 0 or playerCash < curCost or self.mData.level >= self.mCoreMaxLevel) then
		self.mBtn_PowerUpButton.interactable = false;
		UIUtils.GetListener(self.mBtn_PowerUpButton.gameObject).onClick = nil;
	else
		self.mBtn_PowerUpButton.interactable = true;
		UIUtils.GetListener(self.mBtn_PowerUpButton.gameObject).onClick = self.mPowerUpButtonOnClick;
	end
end


function UISkillCoreDetailView:ShowUpgradeAnim(beforeLevel,beforeScale)
	self = UISkillCoreDetailView;

	local t = 0.5;
	local nextLvExp = NetCmdCoreData:GetSkillCoreNextLvExp(self.mData);
	local curExp = self.mData.exp;
	local afterLevel = self.mData.level;
	local afterScale = Vector3(curExp/nextLvExp,1.0,1.0);
	local levelDelta = afterLevel - beforeLevel;
	
	CS.UITweenManager.KillTween(self.mImage_AftFill.transform);
	self.mImage_AftFill.transform.localScale = Vector3(0.0,1.0,1.0);
	
	if(levelDelta > 0) then
		CS.UITweenManager.PlayScaleTween(self.mImage_CurFill.transform,beforeScale,vectorone,0.5,t,self.CurFillTweenScaleReset,self.mTweenCirc);	
		t = t + 0.6;
	end
	
	for i = 1, levelDelta-1, 1 do
		CS.UITweenManager.PlayScaleTween(self.mImage_CurFill.transform,beforeScale,vectorone,0.5,t,self.CurFillTweenScaleReset,self.mTweenCirc);
		t = t + 0.6;
	end
	
	if(afterLevel < self.mStcData.max_level) then
		CS.UITweenManager.PlayScaleTween(self.mImage_CurFill.transform,beforeScale,afterScale,0.5,t,nil,self.mTweenCirc);	
	else
		CS.UITweenManager.PlayScaleTween(self.mImage_CurFill.transform,beforeScale,vectorone,0.5,t,nil,self.mTweenCirc);	
	end
end



function UISkillCoreDetailView.CurFillTweenScaleReset()
	self = UISkillCoreDetailView;
	self.mImage_CurFill.transform.localScale = Vector3(0.0,1.0,1.0);
end

function UISkillCoreDetailView:UpdateResource()
	local playerCash = GlobalData.cash;
	self.mText_coinCost.text = "0/"..playerCash;
end


