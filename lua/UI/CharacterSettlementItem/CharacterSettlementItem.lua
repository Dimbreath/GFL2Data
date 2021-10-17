require("UI.UIBaseCtrl")

CharacterSettlementItem = class("CharacterSettlementItem", UIBaseCtrl);
CharacterSettlementItem.__index = CharacterSettlementItem
--@@ GF Auto Gen Block Begin
CharacterSettlementItem.mImage_CharacterIcon = nil;
CharacterSettlementItem.mImage_CharacterItemGunType = nil;
CharacterSettlementItem.mImage_CharacterRank = nil;
CharacterSettlementItem.mImage_CharacterEXP_CharacterEXPGet = nil;
CharacterSettlementItem.mImage_CharacterEXP_CharacterEXPNow = nil;
CharacterSettlementItem.mText_LevelInformation_CharacterLevel = nil;
CharacterSettlementItem.mText_CharacterEXP_CharacterEXP = nil;
CharacterSettlementItem.mTrans_LevelInformation_CharacterLevelUp = nil;

function CharacterSettlementItem:__InitCtrl()

	self.mImage_CharacterIcon = self:GetImage("CharacterIcon/Image_CharacterIcon");
	self.mImage_CharacterItemGunType = self:GetImage("Image_CharacterItemGunType");
	self.mImage_CharacterRank = self:GetImage("Image_CharacterRank");
	self.mImage_CharacterEXP_CharacterEXPGet = self:GetImage("UI_CharacterEXP/CharacterEXP/Image_CharacterEXPGet");
	self.mImage_CharacterEXP_CharacterEXPNow = self:GetImage("UI_CharacterEXP/CharacterEXP/Image_CharacterEXPNow");
	self.mText_LevelInformation_CharacterLevel = self:GetText("UI_LevelInformation/Text_CharacterLevel");
	self.mText_CharacterEXP_CharacterEXP = self:GetText("UI_CharacterEXP/CharacterEXP/Text_CharacterEXP");
	self.mTrans_LevelInformation_CharacterLevelUp = self:GetRectTransform("UI_LevelInformation/Trans_CharacterLevelUp");
end

--@@ GF Auto Gen Block End

function CharacterSettlementItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function CharacterSettlementItem:InitData(id,addExp)
	local gun = NetCmdTeamData:GetGunByID(id);

	self.mImage_CharacterIcon.sprite = IconUtils.GetCharacterHeadSprite(gun.TabGunData.code);
	self.mImage_CharacterItemGunType.sprite = UIUtils.GetGunMessageSprite("Combat_GunTypeIcon_"..tostring(gun.TabGunData.typeInt));
	self.mImage_CharacterRank.color = TableData.GetGlobalGun_Quality_Color1(gun.TabGunData.rank);

	self.mText_LevelInformation_CharacterLevel.text = "Lv." .. gun.level;
	self.mText_CharacterEXP_CharacterEXP.text = "EXP+" .. addExp;

	local prevLv = 0;
	local nowLv = 0;

	setactive(self.mTrans_LevelInformation_CharacterLevelUp.gameObject , false);	

	local totalExpBefore =  TableData.GunExpToLevel(gun.level) + gun.exp - addExp;
	local lvBefore = NetCmdTrainGunData:GetLevelByExp(totalExpBefore);
	local beforeExp = totalExpBefore - TableData.GunExpToLevel(lvBefore);
	local expRatioBefore = beforeExp / TableData.listGunLevelExpDatas:GetDataById(lvBefore+1).exp;
	local expRatioAfter = gun.exp / TableData.listGunLevelExpDatas:GetDataById(gun.level+1).exp;

	self.mImage_CharacterEXP_CharacterEXPNow.fillAmount = expRatioBefore;

	prevLv = lvBefore + expRatioBefore;
	nowLv = gun.level + expRatioAfter;

	self.mText_LevelInformation_CharacterLevel.text = string.format("Lv.%d",lvBefore);


	CS.ProgressBarAnimationHelper.Play(self.mImage_CharacterEXP_CharacterEXPGet,prevLv,nowLv,2,
    function (lv)
		self.mImage_CharacterEXP_CharacterEXPNow.fillAmount = 0;
		self.mText_LevelInformation_CharacterLevel.text = string.format("Lv.%d",lv);
		setactive(self.mTrans_LevelInformation_CharacterLevelUp.gameObject , true);	
    end,
    function ()
        print("over");
    end);
end