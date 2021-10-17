require("UI.UIBaseCtrl")

CharacterSelectionItem = class("CharacterSelectionItem", UIBaseCtrl);
CharacterSelectionItem.__index = CharacterSelectionItem
--@@ GF Auto Gen Block Begin
CharacterSelectionItem.mBtn_CharacterItem = nil;
CharacterSelectionItem.mImage_CharacterIcon = nil;
CharacterSelectionItem.mImage_CharacterItemGunType = nil;
CharacterSelectionItem.mImage_CharacterRank = nil;
CharacterSelectionItem.mText_BottomInformation_CharacterLevel = nil;

CharacterSelectionItem.mTrans_CharacterUp = nil;
CharacterSelectionItem.mTrans_CharacterUpText = nil;

function CharacterSelectionItem:__InitCtrl()

	self.mBtn_CharacterItem = self:GetButton("Btn_CharacterItem");
	self.mImage_CharacterIcon = self:GetImage("Btn_CharacterItem/CharacterIcon/Image_CharacterIcon");
	self.mImage_CharacterItemGunType = self:GetImage("Btn_CharacterItem/Image_CharacterItemGunType");
	self.mImage_CharacterRank = self:GetImage("Btn_CharacterItem/Image_CharacterRank");
	self.mText_BottomInformation_CharacterLevel = self:GetText("Btn_CharacterItem/UI_BottomInformation/Text_CharacterLevel");

	self.mTrans_CharacterUp = self:GetRectTransform("Btn_CharacterItem/UI_BottomInformation/CharacterUp");
	self.mTrans_CharacterUpText = self:GetRectTransform("Btn_CharacterItem/UI_BottomInformation/CharacterUpText");
end

--@@ GF Auto Gen Block End

function CharacterSelectionItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function CharacterSelectionItem:InitData(data,isFit)
	
	self.mImage_CharacterIcon.sprite = IconUtils.GetCharacterHeadSprite(data.TabGunData.code);
	self.mImage_CharacterItemGunType.sprite = UIUtils.GetGunMessageSprite("Combat_GunTypeIcon_"..tostring(data.TabGunData.typeInt));
	self.mText_BottomInformation_CharacterLevel.text = "Lv."..data.level;
	self.mImage_CharacterRank.color = TableData.GetGlobalGun_Quality_Color1(data.TabGunData.rank);

	if(isFit == false) then
		setactive(self.mTrans_CharacterUp.gameObject,false);
		setactive(self.mTrans_CharacterUpText.gameObject,false);
	end
end