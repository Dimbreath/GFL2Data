require("UI.UIBaseCtrl")

UICombatGunPreparationItem = class("UICombatGunPreparationItem", UIBaseCtrl);
UICombatGunPreparationItem.__index = UICombatGunPreparationItem
--@@ GF Auto Gen Block Begin
UICombatGunPreparationItem.mImage_GunImage = nil;
UICombatGunPreparationItem.mText_GunNameText = nil;
UICombatGunPreparationItem.mText_GunNameLabel = nil;
UICombatGunPreparationItem.mText_GunName = nil;
UICombatGunPreparationItem.mTrans_GunUnSelect = nil;
UICombatGunPreparationItem.mTrans_GunSelect = nil;
UICombatGunPreparationItem.mTrans_GunImageMask = nil;
UICombatGunPreparationItem.mTrans_GunUnJoin = nil;

function UICombatGunPreparationItem:__InitCtrl()

	self.mImage_GunImage = self:GetImage("Trans__GunImageMask/Image__GunImage");
	self.mText_GunNameText = self:GetText("Trans_GunUnSelect/Text_GunNameText");
	self.mText_GunNameLabel = self:GetText("Trans_GunSelect/Text_GunNameLabel");
	self.mText_GunName = self:GetText("Trans_GunUnJoin/Text_GunName");
	self.mTrans_GunUnSelect = self:GetRectTransform("Trans_GunUnSelect");
	self.mTrans_GunSelect = self:GetRectTransform("Trans_GunSelect");
	self.mTrans_GunImageMask = self:GetRectTransform("Trans__GunImageMask");
	self.mTrans_GunUnJoin = self:GetRectTransform("Trans_GunUnJoin");
end

--@@ GF Auto Gen Block End

function UICombatGunPreparationItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	UIUtils.GetButtonListener(root.gameObject).onClick = function()
		if self.data ~= nil then
			UICombatPreparationPanel.OnTopLineUpGunClicked(self.data.id);
		end
	end
end

function UICombatGunPreparationItem:initData(gun_id)
	local data = NetCmdTeamData:GetGunByID(tonumber(gun_id));
	if data == nil then
		print("找不到人形数据 gun_id = " ..gun_id)
	else
		self.data = data;

		--local duty = TableData.GetHintById(56 + data.TabGunData.duty);
		--self.mText_GunTypeText.text = duty;
		self.mText_GunNameText.text = data.TabGunData.name.str;
        self.mText_GunNameLabel.text = data.TabGunData.name.str;
		self.mImage_GunImage.sprite = UICombatPreparationPanel.GetCharacterHeadSprite(data.TabGunData.code);
		self:SetSelected(false);
	end
end

function UICombatGunPreparationItem:SetEmpty()
	self.data = nil;
	setactive(self.mTrans_GunUnJoin.gameObject,true);
	setactive(self.mTrans_GunUnSelect.gameObject,false);
	setactive(self.mTrans_GunSelect.gameObject,false);
	setactive(self.mTrans_GunImageMask.gameObject,false);
end

function UICombatGunPreparationItem:SetSelected(value)
	if self.data ~= nil then
		setactive(self.mTrans_GunUnJoin.gameObject,false);
		setactive(self.mTrans_GunUnSelect.gameObject,not value);
		setactive(self.mTrans_GunSelect.gameObject,value);
		setactive(self.mTrans_GunImageMask.gameObject,true);
	end
end

