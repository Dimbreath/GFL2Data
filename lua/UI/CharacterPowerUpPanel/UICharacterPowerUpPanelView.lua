require("UI.UIBaseView")

UICharacterPowerUpPanelView = class("UICharacterPowerUpPanelView", UIBaseView);
UICharacterPowerUpPanelView.__index = UICharacterPowerUpPanelView

UICharacterPowerUpPanelView.mText_UI_CapsuleNum = nil;
UICharacterPowerUpPanelView.mText_UI_PowerUpGunName = nil;
UICharacterPowerUpPanelView.mText_UI_PowerUpGunType = nil;
UICharacterPowerUpPanelView.mText_UI_PowerUpGunPower = nil;
UICharacterPowerUpPanelView.mText_UI_AttackUpText = nil;
UICharacterPowerUpPanelView.mText_UI_AttackUpOriginText = nil;
UICharacterPowerUpPanelView.mText_UI_AttackUpPlusText = nil;
UICharacterPowerUpPanelView.mText_UI_AttackUpNewText = nil;
UICharacterPowerUpPanelView.mText_UI_HitUpText = nil;
UICharacterPowerUpPanelView.mText_UI_HitUpOriginText = nil;
UICharacterPowerUpPanelView.mText_UI_HitUpNewText = nil;
UICharacterPowerUpPanelView.mText_UI_HitUpPlusText = nil;
UICharacterPowerUpPanelView.mText_UI_DodgeUpText = nil;
UICharacterPowerUpPanelView.mText_UI_DodgeUpOriginText = nil;
UICharacterPowerUpPanelView.mText_UI_DodgeUpPlusText = nil;
UICharacterPowerUpPanelView.mText_UI_DodgeUpNewText = nil;
UICharacterPowerUpPanelView.mText_UI_ArmorUpText = nil;
UICharacterPowerUpPanelView.mText_UI_ArmorUpOriginText = nil;
UICharacterPowerUpPanelView.mText_UI_ArmorUpPlusText = nil;
UICharacterPowerUpPanelView.mText_UI_ArmorUpNewText = nil;
UICharacterPowerUpPanelView.mText_UI_PowerUpCostText = nil;
UICharacterPowerUpPanelView.mImage_UI_PowerUpGunRarity = nil;
UICharacterPowerUpPanelView.mImage_UI_AttackMinusButton = nil;
UICharacterPowerUpPanelView.mImage_UI_AttackPlusButton = nil;
UICharacterPowerUpPanelView.mImage_UI_AttackOriginFill = nil;
UICharacterPowerUpPanelView.mImage_UI_AttackNewFill = nil;
UICharacterPowerUpPanelView.mImage_UI_AttackUpIcon = nil;
UICharacterPowerUpPanelView.mImage_UI_HitMinusButton = nil;
UICharacterPowerUpPanelView.mImage_UI_HitPlusButton = nil;
UICharacterPowerUpPanelView.mImage_UI_HitOriginFill = nil;
UICharacterPowerUpPanelView.mImage_UI_HitNewFill = nil;
UICharacterPowerUpPanelView.mImage_UI_HitUpIcon = nil;
UICharacterPowerUpPanelView.mImage_UI_DodgeMinusButton = nil;
UICharacterPowerUpPanelView.mImage_UI_DodgePlusButton = nil;
UICharacterPowerUpPanelView.mImage_UI_DodgeOriginFill = nil;
UICharacterPowerUpPanelView.mImage_UI_DodgeNewFill = nil;
UICharacterPowerUpPanelView.mImage_UI_DodgeUpIcon = nil;
UICharacterPowerUpPanelView.mImage_UI_ArmorMinusButton = nil;
UICharacterPowerUpPanelView.mImage_UI_ArmorPlusButton = nil;
UICharacterPowerUpPanelView.mImage_UI_ArmorOriginFill = nil;
UICharacterPowerUpPanelView.mImage_UI_ArmorNewFill = nil;
UICharacterPowerUpPanelView.mImage_UI_ArmorUpIcon = nil;
UICharacterPowerUpPanelView.mImage_UI_PowerUpResetButton = nil;
UICharacterPowerUpPanelView.mImage_UI_PowerUpConfirmButton = nil;
UICharacterPowerUpPanelView.mGridLayoutGroup_UI_PowerUpGunGrade = nil;
UICharacterPowerUpPanelView.mButton_UI_AttackMinusButton = nil;
UICharacterPowerUpPanelView.mButton_UI_AttackPlusButton = nil;
UICharacterPowerUpPanelView.mButton_UI_HitMinusButton = nil;
UICharacterPowerUpPanelView.mButton_UI_HitPlusButton = nil;
UICharacterPowerUpPanelView.mButton_UI_DodgeMinusButton = nil;
UICharacterPowerUpPanelView.mButton_UI_DodgePlusButton = nil;
UICharacterPowerUpPanelView.mButton_UI_ArmorMinusButton = nil;
UICharacterPowerUpPanelView.mButton_UI_ArmorPlusButton = nil;
UICharacterPowerUpPanelView.mButton_UI_PowerUpResetButton = nil;
UICharacterPowerUpPanelView.mButton_UI_PowerUpConfirmButton = nil;

UICharacterPowerUpPanelView.mFillImageBaseWidth = 549;
UICharacterPowerUpPanelView.mFillImageBaseHeight = 12;
UICharacterPowerUpPanelView.mColorOriginalStr = "#DCDDDDFF";
UICharacterPowerUpPanelView.mColorMaxStr = "#00A0E9FF";
UICharacterPowerUpPanelView.mColorGrayStr = "#898989FF";

UICharacterPowerUpPanelView.mColorOriginal = Color.white;
UICharacterPowerUpPanelView.mColorMax = Color.white;
UICharacterPowerUpPanelView.mColorGray = Color.white;

UICharacterPowerUpPanelView.mColorEnd = "</color>";
UICharacterPowerUpPanelView.GunInfo = nil;
UICharacterPowerUpPanelView.GunData = nil;
UICharacterPowerUpPanelView.GunDefine = nil;

UICharacterPowerUpPanelView.mStars = nil;

function UICharacterPowerUpPanelView:InitCtrl(root)
	self:SetRoot(root);

	self.mText_UI_CapsuleNum = self:GetText("CurrentCapsule/CapsuleNum/UI_CapsuleNum");
	self.mText_UI_PowerUpGunName = self:GetText("PowerUpOption/PowerUpOption/OverView/UI_PowerUpGunName");
	self.mText_UI_PowerUpGunType = self:GetText("PowerUpOption/PowerUpOption/OverView/UI_PowerUpGunType");
	self.mText_UI_PowerUpGunPower = self:GetText("PowerUpOption/PowerUpOption/OverView/GunPower/UI_PowerUpGunPower");
	self.mText_UI_AttackUpText = self:GetText("PowerUpOption/PowerUpOption/Panel/attack/UI_AttackUpText");
	self.mText_UI_AttackUpOriginText = self:GetText("PowerUpOption/PowerUpOption/Panel/attack/attackNum/UI_AttackUpOriginText");
	self.mText_UI_AttackUpPlusText = self:GetText("PowerUpOption/PowerUpOption/Panel/attack/attackNum/UI_AttackUpPlusText");
	self.mText_UI_AttackUpNewText = self:GetText("PowerUpOption/PowerUpOption/Panel/attack/attackNum/UI_AttackUpNewText");
	self.mText_UI_HitUpText = self:GetText("PowerUpOption/PowerUpOption/Panel/hit/UI_HitUpText");
	self.mText_UI_HitUpOriginText = self:GetText("PowerUpOption/PowerUpOption/Panel/hit/HitNum/UI_HitUpOriginText");
	self.mText_UI_HitUpNewText = self:GetText("PowerUpOption/PowerUpOption/Panel/hit/HitNum/UI_HitUpNewText");
	self.mText_UI_HitUpPlusText = self:GetText("PowerUpOption/PowerUpOption/Panel/hit/HitNum/UI_HitUpPlusText");
	self.mText_UI_DodgeUpText = self:GetText("PowerUpOption/PowerUpOption/Panel/dodge/UI_DodgeUpText");
	self.mText_UI_DodgeUpOriginText = self:GetText("PowerUpOption/PowerUpOption/Panel/dodge/DodgeNum/UI_DodgeUpOriginText");
	self.mText_UI_DodgeUpPlusText = self:GetText("PowerUpOption/PowerUpOption/Panel/dodge/DodgeNum/UI_DodgeUpPlusText");
	self.mText_UI_DodgeUpNewText = self:GetText("PowerUpOption/PowerUpOption/Panel/dodge/DodgeNum/UI_DodgeUpNewText");
	self.mText_UI_ArmorUpText = self:GetText("PowerUpOption/PowerUpOption/Panel/armor/UI_ArmorUpText");
	self.mText_UI_ArmorUpOriginText = self:GetText("PowerUpOption/PowerUpOption/Panel/armor/ArmorNum/UI_ArmorUpOriginText");
	self.mText_UI_ArmorUpPlusText = self:GetText("PowerUpOption/PowerUpOption/Panel/armor/ArmorNum/UI_ArmorUpPlusText");
	self.mText_UI_ArmorUpNewText = self:GetText("PowerUpOption/PowerUpOption/Panel/armor/ArmorNum/UI_ArmorUpNewText");
	self.mText_UI_PowerUpCostText = self:GetText("PowerUpOption/PowerUpCost/UI_PowerUpCostText");
	self.mImage_UI_PowerUpGunRarity = self:GetImage("PowerUpOption/PowerUpOption/OverView/UI_PowerUpGunRarity");
	self.mImage_UI_AttackMinusButton = self:GetImage("PowerUpOption/PowerUpOption/Panel/attack/UI_AttackMinusButton");
	self.mImage_UI_AttackPlusButton = self:GetImage("PowerUpOption/PowerUpOption/Panel/attack/UI_AttackPlusButton");
	self.mImage_UI_AttackOriginFill = self:GetImage("PowerUpOption/PowerUpOption/Panel/attack/amountFill/UI_AttackOriginFill");
	self.mImage_UI_AttackNewFill = self:GetImage("PowerUpOption/PowerUpOption/Panel/attack/amountFill/UI_AttackNewFill");
	self.mImage_UI_AttackUpIcon = self:GetImage("PowerUpOption/PowerUpOption/Panel/attack/UI_AttackUpIcon");
	self.mImage_UI_HitMinusButton = self:GetImage("PowerUpOption/PowerUpOption/Panel/hit/UI_HitMinusButton");
	self.mImage_UI_HitPlusButton = self:GetImage("PowerUpOption/PowerUpOption/Panel/hit/UI_HitPlusButton");
	self.mImage_UI_HitOriginFill = self:GetImage("PowerUpOption/PowerUpOption/Panel/hit/amountFill/UI_HitOriginFill");
	self.mImage_UI_HitNewFill = self:GetImage("PowerUpOption/PowerUpOption/Panel/hit/amountFill/UI_HitNewFill");
	self.mImage_UI_HitUpIcon = self:GetImage("PowerUpOption/PowerUpOption/Panel/hit/UI_HitUpIcon");
	self.mImage_UI_DodgeMinusButton = self:GetImage("PowerUpOption/PowerUpOption/Panel/dodge/UI_DodgeMinusButton");
	self.mImage_UI_DodgePlusButton = self:GetImage("PowerUpOption/PowerUpOption/Panel/dodge/UI_DodgePlusButton");
	self.mImage_UI_DodgeOriginFill = self:GetImage("PowerUpOption/PowerUpOption/Panel/dodge/amountFill/UI_DodgeOriginFill");
	self.mImage_UI_DodgeNewFill = self:GetImage("PowerUpOption/PowerUpOption/Panel/dodge/amountFill/UI_DodgeNewFill");
	self.mImage_UI_DodgeUpIcon = self:GetImage("PowerUpOption/PowerUpOption/Panel/dodge/UI_DodgeUpIcon");
	self.mImage_UI_ArmorMinusButton = self:GetImage("PowerUpOption/PowerUpOption/Panel/armor/UI_ArmorMinusButton");
	self.mImage_UI_ArmorPlusButton = self:GetImage("PowerUpOption/PowerUpOption/Panel/armor/UI_ArmorPlusButton");
	self.mImage_UI_ArmorOriginFill = self:GetImage("PowerUpOption/PowerUpOption/Panel/armor/amountFill/UI_ArmorOriginFill");
	self.mImage_UI_ArmorNewFill = self:GetImage("PowerUpOption/PowerUpOption/Panel/armor/amountFill/UI_ArmorNewFill");
	self.mImage_UI_ArmorUpIcon = self:GetImage("PowerUpOption/PowerUpOption/Panel/armor/UI_ArmorUpIcon");
	self.mImage_UI_PowerUpResetButton = self:GetImage("PowerUpOption/UI_PowerUpResetButton");
	self.mImage_UI_PowerUpConfirmButton = self:GetImage("PowerUpOption/UI_PowerUpConfirmButton");
	self.mGridLayoutGroup_UI_PowerUpGunGrade = self:GetGridLayoutGroup("PowerUpOption/PowerUpOption/OverView/UI_PowerUpGunGrade");
	self.mButton_UI_AttackMinusButton = self:GetButton("PowerUpOption/PowerUpOption/Panel/attack/UI_AttackMinusButton");
	self.mButton_UI_AttackPlusButton = self:GetButton("PowerUpOption/PowerUpOption/Panel/attack/UI_AttackPlusButton");
	self.mButton_UI_HitMinusButton = self:GetButton("PowerUpOption/PowerUpOption/Panel/hit/UI_HitMinusButton");
	self.mButton_UI_HitPlusButton = self:GetButton("PowerUpOption/PowerUpOption/Panel/hit/UI_HitPlusButton");
	self.mButton_UI_DodgeMinusButton = self:GetButton("PowerUpOption/PowerUpOption/Panel/dodge/UI_DodgeMinusButton");
	self.mButton_UI_DodgePlusButton = self:GetButton("PowerUpOption/PowerUpOption/Panel/dodge/UI_DodgePlusButton");
	self.mButton_UI_ArmorMinusButton = self:GetButton("PowerUpOption/PowerUpOption/Panel/armor/UI_ArmorMinusButton");
	self.mButton_UI_ArmorPlusButton = self:GetButton("PowerUpOption/PowerUpOption/Panel/armor/UI_ArmorPlusButton");
	self.mButton_UI_PowerUpResetButton = self:GetButton("PowerUpOption/UI_PowerUpResetButton");
	self.mButton_UI_PowerUpConfirmButton = self:GetButton("PowerUpOption/UI_PowerUpConfirmButton");

	self.mColorOriginal = CSUIUtils.ConvertEngineColor(self.mColorOriginalStr);
	self.mColorMax = CSUIUtils.ConvertEngineColor(self.mColorMaxStr);
	self.mColorGray = CSUIUtils.ConvertEngineColor(self.mColorGrayStr);

	self.mStars = {};
	for i = 1, self.mGridLayoutGroup_UI_PowerUpGunGrade.transform.childCount do
		if i ~= 1 then
			self.mStars[i - 1] = self.mGridLayoutGroup_UI_PowerUpGunGrade.transform:GetChild(i - 1);
		end
	end
end

function UICharacterPowerUpPanelView:ShowOrigView(num)
	self.mText_UI_PowerUpCostText.text = num;
end

function UICharacterPowerUpPanelView:SetCapsule(num)
	self.mText_UI_CapsuleNum.text = num;
end

function UICharacterPowerUpPanelView:SetDataBase(gunInfo)
	self.GunInfo = gunInfo;
	if gunInfo ~= nil then
		--print("pow: "..self.GunInfo.PUPow.." max powL = " ..self.GunInfo.max_pow.." hit = "..self.GunInfo.PUHit.." max hit = "..
		--self.GunInfo.max_hit.." dodge = "..self.GunInfo.PUDodge.." max dodge = "..self.GunInfo.max_dodge.." armor = "..self.GunInfo.PUArmor
		--.." max armor = "..self.GunInfo.max_armor);

		self.GunData = TableData.GetGunData(gunInfo.stc_gun_id);
		--self.GunDefine = TableData.GetDefineGunData(self.GunData.typeInt);

		if self.GunInfo.PUPow >= self.GunInfo.max_pow then
			setactive(self.mText_UI_AttackUpNewText.gameObject, false);
			setactive(self.mText_UI_AttackUpPlusText.gameObject, false);

			self.mText_UI_AttackUpOriginText.text = self.GunInfo.PUPow.."(MAX)";
			self.mText_UI_AttackUpOriginText.color = self.mColorMax;
			self.mText_UI_AttackUpText.color = self.mColorMax;
			self.mImage_UI_AttackUpIcon.color = self.mColorMax;

			self.mImage_UI_AttackMinusButton.color = self.mColorGray;
		else
			self.mText_UI_AttackUpOriginText.text = self.GunInfo.PUPow;
			self.mText_UI_AttackUpOriginText.color = self.mColorOriginal;
			self.mImage_UI_AttackUpIcon.color = self.mColorOriginal;
			self.mText_UI_AttackUpText.color = self.mColorOriginal;

			self.mImage_UI_AttackMinusButton.color = self.mColorMax;

		end

		if self.GunInfo.PUHit >= self.GunInfo.max_hit then
			setactive(self.mText_UI_HitUpNewText.gameObject, false);
			setactive(self.mText_UI_HitUpPlusText.gameObject, false);

			self.mText_UI_HitUpOriginText.text = self.GunInfo.PUHit.."(MAX)";
			self.mText_UI_HitUpOriginText.color = self.mColorMax;
			self.mText_UI_HitUpText.color = self.mColorMax;
			self.mImage_UI_HitUpIcon.color = self.mColorMax;

			self.mImage_UI_HitMinusButton.color = self.mColorGray;
		else
			self.mText_UI_HitUpOriginText.text = self.GunInfo.PUHit;
			self.mText_UI_HitUpOriginText.color = self.mColorOriginal;
			self.mImage_UI_HitUpIcon.color = self.mColorOriginal;
			self.mText_UI_HitUpText.color = self.mColorOriginal;

			self.mImage_UI_HitMinusButton.color = self.mColorMax;
		end

		if self.GunInfo.PUDodge >= self.GunInfo.max_dodge then
			setactive(self.mText_UI_DodgeUpNewText.gameObject, false);
			setactive(self.mText_UI_DodgeUpPlusText.gameObject, false);

			self.mText_UI_DodgeUpOriginText.text = self.GunInfo.PUDodge.."(MAX)";
			self.mText_UI_DodgeUpOriginText.color = self.mColorMax;
			self.mText_UI_DodgeUpText.color = self.mColorMax;
			self.mImage_UI_DodgeUpIcon.color = self.mColorMax;

			self.mImage_UI_DodgeMinusButton.color = self.mColorGray;
		else
			self.mText_UI_DodgeUpOriginText.text = self.GunInfo.PUDodge;
			self.mText_UI_DodgeUpOriginText.color = self.mColorOriginal;
			self.mImage_UI_DodgeUpIcon.color = self.mColorOriginal;
			self.mText_UI_DodgeUpText.color = self.mColorOriginal;

			self.mImage_UI_DodgeMinusButton.color = self.mColorMax;
		end

		if self.GunInfo.PUArmor >= self.GunInfo.max_armor then
			setactive(self.mText_UI_ArmorUpNewText.gameObject, false);
			setactive(self.mText_UI_ArmorUpPlusText.gameObject, false);

			self.mText_UI_ArmorUpOriginText.text = self.GunInfo.PUArmor.."(MAX)";
			self.mText_UI_ArmorUpOriginText.color = self.mColorMax;
			self.mText_UI_ArmorUpText.color = self.mColorMax;
			self.mImage_UI_ArmorUpIcon.color = self.mColorMax;

			self.mImage_UI_ArmorMinusButton.color = self.mColorGray;
		else
			self.mText_UI_ArmorUpOriginText.text = self.GunInfo.PUArmor;
			self.mText_UI_ArmorUpOriginText.color = self.mColorOriginal;
			self.mImage_UI_ArmorUpIcon.color = self.mColorOriginal;
			self.mText_UI_ArmorUpText.color = self.mColorOriginal;

			self.mImage_UI_ArmorMinusButton.color = self.mColorMax;
		end

		self.mText_UI_PowerUpGunName.text = self.GunData.name;
		--self.mText_UI_PowerUpGunType.text = self.GunDefine.name;
		self.mText_UI_PowerUpGunPower.text = self.GunInfo.Power;
		self.mImage_UI_PowerUpGunRarity.sprite = IconUtils.GetRaritySprite("Rarity_"..self.GunData.rank);

		for i = 1, #self.mStars do
			if i <= gunInfo.upgrade then
				setactive(self.mStars[i].gameObject, true);
			else
				setactive(self.mStars[i].gameObject, false);
			end
		end

		setactive(self.mText_UI_AttackUpNewText.gameObject, false);
		setactive(self.mText_UI_AttackUpPlusText.gameObject, false);
		self.mImage_UI_AttackOriginFill.rectTransform.sizeDelta =
		Vector2(self.GunInfo.PUPow / self.GunInfo.max_pow * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
		self.mImage_UI_AttackNewFill.rectTransform.sizeDelta = Vector2(0, self.mFillImageBaseHeight);

		setactive(self.mText_UI_HitUpNewText.gameObject, false);
		setactive(self.mText_UI_HitUpPlusText.gameObject, false);
		self.mImage_UI_HitOriginFill.rectTransform.sizeDelta =
		Vector2(self.GunInfo.PUHit / self.GunInfo.max_hit * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
		self.mImage_UI_HitNewFill.rectTransform.sizeDelta = Vector2(0, self.mFillImageBaseHeight);

		setactive(self.mText_UI_DodgeUpNewText.gameObject, false);
		setactive(self.mText_UI_DodgeUpPlusText.gameObject, false);
		self.mImage_UI_DodgeOriginFill.rectTransform.sizeDelta =
		Vector2(self.GunInfo.PUDodge / self.GunInfo.max_dodge * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
		self.mImage_UI_DodgeNewFill.rectTransform.sizeDelta = Vector2(0, self.mFillImageBaseHeight);

		setactive(self.mText_UI_ArmorUpNewText.gameObject, false);
		setactive(self.mText_UI_ArmorUpPlusText.gameObject, false);
		self.mImage_UI_ArmorOriginFill.rectTransform.sizeDelta =
		Vector2(self.GunInfo.PUArmor / self.GunInfo.max_armor * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
		self.mImage_UI_ArmorNewFill.rectTransform.sizeDelta = Vector2(0, self.mFillImageBaseHeight);
	end
end

function UICharacterPowerUpPanelView:SetPowerAddition(num)

	if self.GunInfo.PUPow + num >= self.GunInfo.max_pow then
		setactive(self.mText_UI_AttackUpNewText.gameObject, false);
		setactive(self.mText_UI_AttackUpPlusText.gameObject, false);

		self.mText_UI_AttackUpOriginText.text = self.GunInfo.PUPow.."(MAX)";
		self.mText_UI_AttackUpOriginText.color = self.mColorMax;
		self.mText_UI_AttackUpText.color = self.mColorMax;
		self.mImage_UI_AttackUpIcon.color = self.mColorMax;

		self.mImage_UI_AttackMinusButton.color = self.mColorGray;
	else
		if num == 0 then
			setactive(self.mText_UI_AttackUpNewText.gameObject, false);
			setactive(self.mText_UI_AttackUpPlusText.gameObject, false);
		else
			setactive(self.mText_UI_AttackUpNewText.gameObject, true);
			setactive(self.mText_UI_AttackUpPlusText.gameObject, true);
		end

		self.mText_UI_AttackUpOriginText.text = self.GunInfo.PUPow;
		self.mText_UI_AttackUpOriginText.color = self.mColorOriginal;
		self.mText_UI_AttackUpText.color = self.mColorOriginal;
		self.mImage_UI_AttackUpIcon.color = self.mColorOriginal;

		self.mText_UI_AttackUpNewText.text = num;
		self.mText_UI_AttackUpNewText.color = self.mColorMax;

		self.mImage_UI_AttackMinusButton.color = self.mColorMax;
	end

	self.mImage_UI_AttackOriginFill.rectTransform.sizeDelta = Vector2(self.GunInfo.PUPow / self.GunInfo.max_pow * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
	self.mImage_UI_AttackNewFill.rectTransform.sizeDelta = Vector2(num / self.GunInfo.max_pow * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
end

function UICharacterPowerUpPanelView:SetHitAddition(num)

	if self.GunInfo.PUHit + num >= self.GunInfo.max_hit then
		setactive(self.mText_UI_HitUpNewText.gameObject, false);
		setactive(self.mText_UI_HitUpPlusText.gameObject, false);

		self.mText_UI_HitUpOriginText.text = self.GunInfo.PUHit.."(MAX)";
		self.mText_UI_HitUpOriginText.color = self.mColorMax;
		self.mText_UI_HitUpText.color = self.mColorMax;
		self.mImage_UI_HitUpIcon.color = self.mColorMax;

		self.mImage_UI_HitMinusButton.color = self.mColorGray;
	else
		if num == 0 then
			setactive(self.mText_UI_HitUpNewText.gameObject, false);
			setactive(self.mText_UI_HitUpPlusText.gameObject, false);
		else
			setactive(self.mText_UI_HitUpNewText.gameObject, true);
			setactive(self.mText_UI_HitUpPlusText.gameObject, true);
		end

		self.mText_UI_HitUpOriginText.text = self.GunInfo.PUHit;
		self.mText_UI_HitUpOriginText.color = self.mColorOriginal;
		self.mText_UI_HitUpText.color = self.mColorOriginal;
		self.mImage_UI_HitUpIcon.color = self.mColorOriginal;

		self.mText_UI_HitUpNewText.text = num;
		self.mText_UI_HitUpNewText.color = self.mColorMax;

		self.mImage_UI_HitMinusButton.color = self.mColorMax;
	end

	self.mImage_UI_HitOriginFill.rectTransform.sizeDelta = Vector2(self.GunInfo.PUHit / self.GunInfo.max_hit * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
	self.mImage_UI_HitNewFill.rectTransform.sizeDelta = Vector2(num / self.GunInfo.max_hit * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
end

function UICharacterPowerUpPanelView:SetDodgeAddition(num)

	if self.GunInfo.PUDodge + num >= self.GunInfo.max_dodge then
		setactive(self.mText_UI_DodgeUpNewText.gameObject, false);
		setactive(self.mText_UI_DodgeUpPlusText.gameObject, false);

		self.mText_UI_DodgeUpOriginText.text = self.GunInfo.PUDodge.."(MAX)";
		self.mText_UI_DodgeUpOriginText.color = self.mColorMax;
		self.mText_UI_DodgeUpText.color = self.mColorMax;
		self.mImage_UI_DodgeUpIcon.color = self.mColorMax;

		self.mImage_UI_DodgeMinusButton.color = self.mColorGray;
	else
		if num == 0 then
			setactive(self.mText_UI_DodgeUpNewText.gameObject, false);
			setactive(self.mText_UI_DodgeUpPlusText.gameObject, false);
		else
			setactive(self.mText_UI_DodgeUpNewText.gameObject, true);
			setactive(self.mText_UI_DodgeUpPlusText.gameObject, true);
		end

		self.mText_UI_DodgeUpOriginText.text = self.GunInfo.PUDodge;
		self.mText_UI_DodgeUpOriginText.color = self.mColorOriginal;
		self.mText_UI_DodgeUpText.color = self.mColorOriginal;
		self.mImage_UI_DodgeUpIcon.color = self.mColorOriginal;

		self.mText_UI_DodgeUpNewText.text = num;
		self.mText_UI_DodgeUpNewText.color = self.mColorMax;

		self.mImage_UI_DodgeMinusButton.color = self.mColorMax;
	end

	self.mImage_UI_DodgeOriginFill.rectTransform.sizeDelta = Vector2(self.GunInfo.PUDodge / self.GunInfo.max_dodge * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
	self.mImage_UI_DodgeNewFill.rectTransform.sizeDelta = Vector2(num / self.GunInfo.max_dodge * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
end

function UICharacterPowerUpPanelView:SetArmorAddition(num)

	if self.GunInfo.PUArmor + num >= self.GunInfo.max_armor then
		setactive(self.mText_UI_ArmorUpNewText.gameObject, false);
		setactive(self.mText_UI_ArmorUpPlusText.gameObject, false);

		self.mText_UI_ArmorUpOriginText.text = self.GunInfo.PUArmor.."(MAX)";
		self.mText_UI_ArmorUpOriginText.color = self.mColorMax;
		self.mText_UI_ArmorUpText.color = self.mColorMax;
		self.mImage_UI_ArmorUpIcon.color = self.mColorMax;

		self.mImage_UI_ArmorMinusButton.color = self.mColorGray;
	else
		if num == 0 then
			setactive(self.mText_UI_ArmorUpNewText.gameObject, false);
			setactive(self.mText_UI_ArmorUpPlusText.gameObject, false);
		else

			setactive(self.mText_UI_ArmorUpNewText.gameObject, true);
			setactive(self.mText_UI_ArmorUpPlusText.gameObject, true);
		end

		self.mText_UI_ArmorUpOriginText.text = self.GunInfo.PUArmor;
		self.mText_UI_ArmorUpOriginText.color = self.mColorOriginal;
		self.mText_UI_ArmorUpText.color = self.mColorOriginal;
		self.mImage_UI_ArmorUpIcon.color = self.mColorOriginal;

		self.mText_UI_ArmorUpNewText.text = num;
		self.mText_UI_ArmorUpNewText.color = self.mColorMax;

		self.mImage_UI_ArmorMinusButton.color = self.mColorMax;
	end

	self.mImage_UI_ArmorOriginFill.rectTransform.sizeDelta = Vector2(self.GunInfo.PUArmor / self.GunInfo.max_armor * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
	self.mImage_UI_ArmorNewFill.rectTransform.sizeDelta = Vector2(num / self.GunInfo.max_armor * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
end

function UICharacterPowerUpPanelView:ForceUpdate()
	setactive(self.mUIRoot, false);
	setactive(self.mUIRoot, true);
end

function UICharacterPowerUpPanelView:ResetView()

	self:SetDataBase(self.GunInfo);

	self:SetArmorAddition(0);
	self:SetHitAddition(0);
	self:SetDodgeAddition(0);
	self:SetPowerAddition(0);
	self:ShowOrigView(0);

	--self.mImage_UI_AttackOriginFill.rectTransform.sizeDelta =
	--Vector2(self.GunInfo.PUPow / self.GunInfo.max_pow * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
	--self.mImage_UI_AttackNewFill.rectTransform.sizeDelta = Vector2(0, self.mFillImageBaseHeight);
--
	--self.mImage_UI_HitOriginFill.rectTransform.sizeDelta =
	--Vector2(self.GunInfo.PUHit / self.GunInfo.max_hit * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
	--self.mImage_UI_HitNewFill.rectTransform.sizeDelta = Vector2(0, self.mFillImageBaseHeight);
--
	--self.mImage_UI_DodgeOriginFill.rectTransform.sizeDelta =
	--Vector2(self.GunInfo.PUDodge / self.GunInfo.max_dodge * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
	--self.mImage_UI_DodgeNewFill.rectTransform.sizeDelta = Vector2(0, self.mFillImageBaseHeight);
--
	--self.mImage_UI_ArmorOriginFill.rectTransform.sizeDelta =
	--Vector2(self.GunInfo.PUArmor / self.GunInfo.max_armor * self.mFillImageBaseWidth, self.mFillImageBaseHeight);
	--self.mImage_UI_ArmorNewFill.rectTransform.sizeDelta = Vector2(0, self.mFillImageBaseHeight);
--
	--self.mImage_UI_AttackMinusButton.color = self.mColorMax;
	--self.mImage_UI_HitMinusButton.color = self.mColorMax;
	--self.mImage_UI_DodgeMinusButton.color = self.mColorMax;
	--self.mImage_UI_ArmorMinusButton.color = self.mColorMax;
--
	--self.mImage_UI_AttackUpIcon.color = self.mColorOriginal;
	--self.mImage_UI_HitUpIcon.color = self.mColorOriginal;
	--self.mImage_UI_DodgeUpIcon.color = self.mColorOriginal;
	--self.mImage_UI_ArmorUpIcon.color = self.mColorOriginal;
end