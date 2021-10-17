require("UI.UIBaseView")

UIMemoryChipPanelView = class("UIMemoryChipPanelView", UIBaseView);
UIMemoryChipPanelView.__index = UIMemoryChipPanelView

--@@ GF Auto Gen Block Begin
UIMemoryChipPanelView.mBtn_ChipInformation_Replace = nil;
UIMemoryChipPanelView.mBtn_ChipInformation_Unload = nil;
UIMemoryChipPanelView.mBtn_ChipInformation_Equip = nil;
UIMemoryChipPanelView.mBtn_ChipInformation_lock = nil;
UIMemoryChipPanelView.mBtn_ChipInformation_LevelUp = nil;
UIMemoryChipPanelView.mBtn_LevelUp_Consume = nil;
UIMemoryChipPanelView.mBtn_LevelUp_LevelUpConfirm = nil;
UIMemoryChipPanelView.mBtn_TopInformation_Exit = nil;
UIMemoryChipPanelView.mImage_ChipInformation_Back = nil;
UIMemoryChipPanelView.mImage_ChipInformation_SpecialGunList = nil;
UIMemoryChipPanelView.mImage_LevelUp_IconFrame_Rank = nil;
UIMemoryChipPanelView.mImage_LevelUp_IconFrame_Icon = nil;
UIMemoryChipPanelView.mImage_LevelUp_ExpBar = nil;
UIMemoryChipPanelView.mImage_LevelUp_ExpGrow = nil;
UIMemoryChipPanelView.mImage_LevelUp_ExpNow = nil;
UIMemoryChipPanelView.mImage_LevelUp_LevelUpBG = nil;
UIMemoryChipPanelView.mImage_LevelUp_maxLevelUpBG = nil;
UIMemoryChipPanelView.mImage_TopInformation_gold_goldIcon = nil;
UIMemoryChipPanelView.mText_ChipInformation_Name = nil;
UIMemoryChipPanelView.mText_ChipInformation_LVCount = nil;
UIMemoryChipPanelView.mText_ChipInformation_GunType_GunCodeStr = nil;
UIMemoryChipPanelView.mText_ChipInformation_ChipEffect_ChipStory_ChipStory = nil;
UIMemoryChipPanelView.mText_ChipInformation_ChipEffect_SkillEffect_SkillEffect = nil;
UIMemoryChipPanelView.mText_ChipInformation_SpecialGunListStr = nil;
UIMemoryChipPanelView.mText_LevelUp_Name = nil;
UIMemoryChipPanelView.mText_LevelUp_LVCount = nil;
UIMemoryChipPanelView.mText_LevelUp_SkillLevelUpEffect_SkillEffectBefore_LVBefore_LVCount = nil;
UIMemoryChipPanelView.mText_LevelUp_SkillLevelUpEffect_SkillEffectBefore_SkillEffectBefore = nil;
UIMemoryChipPanelView.mText_LevelUp_SkillLevelUpEffect_SkillEffectAfter_LVAfter_LVCount = nil;
UIMemoryChipPanelView.mText_LevelUp_SkillLevelUpEffect_SkillEffectAfter_SkillEffectAfter = nil;
UIMemoryChipPanelView.mText_LevelUp_Num = nil;
UIMemoryChipPanelView.mText_LevelUp_CantInfo = nil;
UIMemoryChipPanelView.mText_LevelUp_Exp = nil;
UIMemoryChipPanelView.mText_LevelUp_LevelUpText = nil;
UIMemoryChipPanelView.mText_LevelUp_MaxLevelUpText = nil;
UIMemoryChipPanelView.mText_LevelUp_CostStr = nil;
UIMemoryChipPanelView.mText_LevelUp_CostNum = nil;
UIMemoryChipPanelView.mText_TopInformation_gold_goldNumber = nil;
UIMemoryChipPanelView.mTrans_ChipInformation = nil;
UIMemoryChipPanelView.mTrans_ChipInformation_locked = nil;
UIMemoryChipPanelView.mTrans_LevelUp = nil;
UIMemoryChipPanelView.mTrans_LevelUp_FoodList = nil;
UIMemoryChipPanelView.mTrans_LevelUp_EmptyPlus = nil;
UIMemoryChipPanelView.mTrans_LevelUp_maskCantLevelUp = nil;
UIMemoryChipPanelView.mTrans_LevelUp_LevelUpBG = nil;
UIMemoryChipPanelView.mTrans_LevelUp_maxLevelUpBG = nil;
UIMemoryChipPanelView.mTrans_TopInformation = nil;
UIMemoryChipPanelView.mTrans_TopInformation_resPanel = nil;

UIMemoryChipPanelView.mData = nil;

function UIMemoryChipPanelView:__InitCtrl()

	self.mBtn_ChipInformation_Replace = self:GetButton("UI_Trans_ChipInformation/Btn_Replace");
	self.mBtn_ChipInformation_Unload = self:GetButton("UI_Trans_ChipInformation/Btn_Unload");
	self.mBtn_ChipInformation_Equip = self:GetButton("UI_Trans_ChipInformation/Btn_Equip");
	self.mBtn_ChipInformation_lock = self:GetButton("UI_Trans_ChipInformation/Btn_lock");
	self.mBtn_ChipInformation_LevelUp = self:GetButton("UI_Trans_ChipInformation/Btn_LevelUp");
	self.mBtn_LevelUp_Consume = self:GetButton("UI_Trans_LevelUp/Btn_Consume");
	self.mBtn_LevelUp_LevelUpConfirm = self:GetButton("UI_Trans_LevelUp/UI_Btn_LevelUpConfirm");
	self.mBtn_TopInformation_Exit = self:GetButton("UI_Trans_TopInformation/Btn_Exit");
	self.mImage_ChipInformation_Back = self:GetImage("UI_Trans_ChipInformation/Image_Back");
	self.mImage_ChipInformation_SpecialGunList = self:GetImage("UI_Trans_ChipInformation/Image_SpecialGunList");
	self.mImage_LevelUp_IconFrame_Rank = self:GetImage("UI_Trans_LevelUp/UI_IconFrame/Image_Rank");
	self.mImage_LevelUp_IconFrame_Icon = self:GetImage("UI_Trans_LevelUp/UI_IconFrame/Image_Icon");
	self.mImage_LevelUp_ExpBar = self:GetImage("UI_Trans_LevelUp/Image_ExpBar");
	self.mImage_LevelUp_ExpGrow = self:GetImage("UI_Trans_LevelUp/Image_ExpBar/Image_ExpGrow");
	self.mImage_LevelUp_ExpNow = self:GetImage("UI_Trans_LevelUp/Image_ExpBar/Image_ExpNow");
	self.mImage_LevelUp_LevelUpBG = self:GetImage("UI_Trans_LevelUp/Image_ExpBar/Trans_Image_LevelUpBG");
	self.mImage_LevelUp_maxLevelUpBG = self:GetImage("UI_Trans_LevelUp/Image_ExpBar/Trans_Image_maxLevelUpBG");
	self.mImage_TopInformation_gold_goldIcon = self:GetImage("UI_Trans_TopInformation/Trans_resPanel/UI_gold/Image_goldIcon");
	self.mText_ChipInformation_Name = self:GetText("UI_Trans_ChipInformation/ChipName/Text_Name");
	self.mText_ChipInformation_LVCount = self:GetText("UI_Trans_ChipInformation/LVBGImage/Text_LVCount");
	self.mText_ChipInformation_GunType_GunCodeStr = self:GetText("UI_Trans_ChipInformation/UI_GunType/Text_GunCodeStr");
	self.mText_ChipInformation_ChipEffect_ChipStory_ChipStory = self:GetText("UI_Trans_ChipInformation/UI_ChipEffect/UI_ChipStory/Text_ChipStory");
	self.mText_ChipInformation_ChipEffect_SkillEffect_SkillEffect = self:GetText("UI_Trans_ChipInformation/UI_ChipEffect/UI_SkillEffect/Text_SkillEffect");
	self.mText_ChipInformation_SpecialGunListStr = self:GetText("UI_Trans_ChipInformation/Image_SpecialGunList/Text_SpecialGunListStr");
	self.mText_LevelUp_Name = self:GetText("UI_Trans_LevelUp/ChipName/Text_Name");
	self.mText_LevelUp_LVCount = self:GetText("UI_Trans_LevelUp/LVBGImage/Text_LVCount");
	self.mText_LevelUp_SkillLevelUpEffect_SkillEffectBefore_LVBefore_LVCount = self:GetText("UI_Trans_LevelUp/UI_SkillLevelUpEffect/UI_SkillEffectBefore/UI_LVBefore/Text_LVCount");
	self.mText_LevelUp_SkillLevelUpEffect_SkillEffectBefore_SkillEffectBefore = self:GetText("UI_Trans_LevelUp/UI_SkillLevelUpEffect/UI_SkillEffectBefore/Text_SkillEffectBefore");
	self.mText_LevelUp_SkillLevelUpEffect_SkillEffectAfter_LVAfter_LVCount = self:GetText("UI_Trans_LevelUp/UI_SkillLevelUpEffect/UI_SkillEffectAfter/UI_LVAfter/Text_LVCount");
	self.mText_LevelUp_SkillLevelUpEffect_SkillEffectAfter_SkillEffectAfter = self:GetText("UI_Trans_LevelUp/UI_SkillLevelUpEffect/UI_SkillEffectAfter/Text_SkillEffectAfter");
	self.mText_LevelUp_Num = self:GetText("UI_Trans_LevelUp/Btn_Consume/Text_Num");
	self.mText_LevelUp_CantInfo = self:GetText("UI_Trans_LevelUp/Btn_Consume/Trans_maskCantLevelUp/Text_CantInfo");
	self.mText_LevelUp_Exp = self:GetText("UI_Trans_LevelUp/Image_ExpBar/Text_Exp");
	self.mText_LevelUp_LevelUpText = self:GetText("UI_Trans_LevelUp/Image_ExpBar/Trans_Image_LevelUpBG/Text_LevelUpText");
	self.mText_LevelUp_MaxLevelUpText = self:GetText("UI_Trans_LevelUp/Image_ExpBar/Trans_Image_maxLevelUpBG/Text_MaxLevelUpText");
	self.mText_LevelUp_CostStr = self:GetText("UI_Trans_LevelUp/Text_CostStr");
	self.mText_LevelUp_CostNum = self:GetText("UI_Trans_LevelUp/Text_CostStr/Text_CostNum");
	self.mText_TopInformation_gold_goldNumber = self:GetText("UI_Trans_TopInformation/Trans_resPanel/UI_gold/Text_goldNumber");
	self.mTrans_ChipInformation = self:GetRectTransform("UI_Trans_ChipInformation");
	self.mTrans_ChipInformation_locked = self:GetRectTransform("UI_Trans_ChipInformation/Btn_lock/Trans_locked");
	self.mTrans_LevelUp = self:GetRectTransform("UI_Trans_LevelUp");
	self.mTrans_LevelUp_FoodList = self:GetRectTransform("UI_Trans_LevelUp/Btn_Consume/FoodRoot/Trans_FoodList");
	self.mTrans_LevelUp_EmptyPlus = self:GetRectTransform("UI_Trans_LevelUp/Btn_Consume/FoodRoot/Trans_FoodList/Trans_EmptyPlus");
	self.mTrans_LevelUp_maskCantLevelUp = self:GetRectTransform("UI_Trans_LevelUp/Btn_Consume/Trans_maskCantLevelUp");
	self.mTrans_LevelUp_LevelUpBG = self:GetRectTransform("UI_Trans_LevelUp/Image_ExpBar/Trans_Image_LevelUpBG");
	self.mTrans_LevelUp_maxLevelUpBG = self:GetRectTransform("UI_Trans_LevelUp/Image_ExpBar/Trans_Image_maxLevelUpBG");
	self.mTrans_TopInformation = self:GetRectTransform("UI_Trans_TopInformation");
	self.mTrans_TopInformation_resPanel = self:GetRectTransform("UI_Trans_TopInformation/Trans_resPanel");
end

--@@ GF Auto Gen Block End

function UIMemoryChipPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIMemoryChipPanelView:InitView(data, type)
	
	self.mData = data;
	self.mText_LevelUp_Num.text = 0;
	--self:UpdateResource();

	if(data.IsReachMaxLv) then
		setactive(self.mTrans_LevelUp_maskCantLevelUp.gameObject,true);
	end

	setactive(self.mTrans_LevelUp_maxLevelUpBG.gameObject,false);
	setactive(self.mTrans_LevelUp_LevelUpBG.gameObject,false);
	setactive(self.mTrans_ChipInformation_locked.gameObject,data.IsLocked);

	local nextLvNeedExp = NetCmdChipData:GetChipNeedExpByLv(self.mData.CurLv+1);
	self.mText_ChipInformation_Name.text = data.StcData.name.str;
	self.mText_LevelUp_Name.text = data.StcData.name.str;
	self.mText_ChipInformation_LVCount.text = "Lv:"..data.CurLv.."/"..data.CurMaxLv;
	self.mText_LevelUp_Exp.text = self.mData.CurExp.."/".. nextLvNeedExp;

	local typeCodes = TableDataMgr:GetEnableGunType(data.StcData.gun_type_code);
	local strType = "";
	for i = 0, typeCodes.Count - 1 do
		if i >= typeCodes.Count - 1  then
			strType = strType .. typeCodes[i];
		else
			strType = strType .. typeCodes[i] .. ", ";
		end
	end
	self.mText_ChipInformation_GunType_GunCodeStr.text = strType;
	self.mText_ChipInformation_ChipEffect_ChipStory_ChipStory.text = data.StcData.description;
	self.mText_ChipInformation_ChipEffect_SkillEffect_SkillEffect.text = data:GetSkillDespByLv(data.CurLv);

	local guns = TableDataMgr:GetSpecialGuns(data.StcData.special_gun_list);
	local strGuns = "";
	for i = 0, guns.Count - 1 do
		if i >= guns.Count - 1  then
			strGuns = strGuns .. guns[i];
		else
			strGuns = strGuns .. guns[i] .. ", ";
		end
	end

	if(guns.Count > 0) then
		setactive(self.mImage_ChipInformation_SpecialGunList.gameObject,true);
		self.mText_ChipInformation_SpecialGunListStr.text = strGuns;
	end

	if(not data.CanDevelop) then 
		setactive(self.mBtn_ChipInformation_LevelUp.gameObject,false);
	else
		setactive(self.mBtn_ChipInformation_LevelUp.gameObject,true);
	end

	if(type == 1) then
		setactive(self.mBtn_ChipInformation_Replace.gameObject,false);
		setactive(self.mBtn_ChipInformation_Equip.gameObject,false);
		if(data.IsEquipped) then
			setactive(self.mBtn_ChipInformation_Unload.gameObject,true);		
		else
			setactive(self.mBtn_ChipInformation_Unload.gameObject,false);	
		end
		return;
	end

	if(data.IsEquipped) then
		setactive(self.mBtn_ChipInformation_Unload.gameObject,true);
		setactive(self.mBtn_ChipInformation_Replace.gameObject,true);
		setactive(self.mBtn_ChipInformation_Equip.gameObject,false);
		setactive(self.mBtn_ChipInformation_LevelUp.gameObject,true);
	else
		setactive(self.mBtn_ChipInformation_Unload.gameObject,false);
		setactive(self.mBtn_ChipInformation_Replace.gameObject,false);
		setactive(self.mBtn_ChipInformation_Equip.gameObject,true);
		setactive(self.mBtn_ChipInformation_LevelUp.gameObject,false);
	end

	
end

function UIMemoryChipPanelView:UpdateResource(cost)
	self.mText_LevelUp_CostNum.text = cost;
	self.mText_TopInformation_gold_goldNumber.text = GlobalData.cash;

	if(GlobalData.cash < cost) then
		self.mText_LevelUp_CostNum.color = Color.red;
	else
		self.mText_LevelUp_CostNum.color = Color.black;
	end
end

function UIMemoryChipPanelView:UpdateAmount(num)
	self.mText_LevelUp_Num.text = num;
end

function UIMemoryChipPanelView:SetLevelUpInfo(growExp,nextLv,breakTimes)

	local breakLv = breakTimes * self.mData.LevelPerBreak;
	local finalLv = math.min(self.mData.CurMaxLv + breakLv,nextLv);

	self.mText_LevelUp_SkillLevelUpEffect_SkillEffectBefore_LVBefore_LVCount.text = "Lv."..self.mData.CurLv;
	self.mText_LevelUp_SkillLevelUpEffect_SkillEffectAfter_LVAfter_LVCount.text = "Lv."..finalLv;
	self.mText_LevelUp_SkillLevelUpEffect_SkillEffectBefore_SkillEffectBefore.text = self.mData:GetSkillDespByLv(self.mData.CurLv);
	self.mText_LevelUp_SkillLevelUpEffect_SkillEffectAfter_SkillEffectAfter.text = self.mData:GetSkillDespByLv(finalLv);
	self.mText_LevelUp_LVCount.text = "Lv:"..self.mData.CurLv.."/"..self.mData.CurMaxLv;

	local deltaLv = finalLv - self.mData.CurLv;
	if(deltaLv > 0) then
		setactive(self.mTrans_LevelUp_LevelUpBG.gameObject,true);
		self.mText_LevelUp_LevelUpText.text = "Lv +"..deltaLv;
    else
        setactive(self.mTrans_LevelUp_LevelUpBG.gameObject,false);
	end
	
	if(breakLv > 0) then
		setactive(self.mTrans_LevelUp_maxLevelUpBG.gameObject,true);
		self.mText_LevelUp_MaxLevelUpText.text = "MaxLv +"..breakLv;
	else
		setactive(self.mTrans_LevelUp_maxLevelUpBG.gameObject,false);
	end

	local nextLvNeedExp = NetCmdChipData:GetChipNeedExpByLv(self.mData.CurLv+1);
	local curRatio = self.mData.CurExp / nextLvNeedExp;
	local growRatio = growExp / nextLvNeedExp;
	self.mImage_LevelUp_ExpNow.fillAmount = curRatio;
	self.mImage_LevelUp_ExpGrow.fillAmount = growRatio + curRatio;

	self.mText_LevelUp_Exp.text = (self.mData.CurExp + growExp).."/".. nextLvNeedExp;
end