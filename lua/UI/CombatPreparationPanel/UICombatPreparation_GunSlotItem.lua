require("UI.UIBaseCtrl")

UICombatPreparation_GunSlotItem = class("UICombatPreparation_GunSlotItem", UIBaseCtrl);
UICombatPreparation_GunSlotItem.__index = UICombatPreparation_GunSlotItem
UICombatPreparation_GunSlotItem.uid = 0;
UICombatPreparation_GunSlotItem.data = nil;
UICombatPreparation_GunSlotItem.enabled = true;
UICombatPreparation_GunSlotItem.dragging = false;
--@@ GF Auto Gen Block Begin
UICombatPreparation_GunSlotItem.mImage_BG_CharacterPic = nil;
UICombatPreparation_GunSlotItem.mImage_BG_Cover = nil;
UICombatPreparation_GunSlotItem.mImage_LevelBG = nil;
UICombatPreparation_GunSlotItem.mText_GunType = nil;
UICombatPreparation_GunSlotItem.mText_Level = nil;
UICombatPreparation_GunSlotItem.mTrans_GunSelect = nil;
UICombatPreparation_GunSlotItem.mTrans_GunSelect_GunSelectUnAble = nil;
UICombatPreparation_GunSlotItem.mTrans_BG = nil;
UICombatPreparation_GunSlotItem.mTrans_Cover = nil;
UICombatPreparation_GunSlotItem.mImage_GunElement = nil;
UICombatPreparation_GunSlotItem.mImage_GunDuty = nil;
UICombatPreparation_GunSlotItem.mImage_MythicBlood = nil;
UICombatPreparation_GunSlotItem.mImage_GunStatusBgImage = nil;

function UICombatPreparation_GunSlotItem:__InitCtrl()

	self.mImage_BG_CharacterPic = self:GetImage("UI_Trans_Root/UI_Trans_BG/HeadMask/Image_CharacterPic");
	self.mImage_BG_Cover = self:GetImage("UI_Trans_Root/UI_Trans_BG/HeadMask/Image_Cover");
	self.mImage_LevelBG = self:GetImage("UI_Trans_Root/Bottom/Type/Image_LevelBG");
	self.mText_GunType = self:GetText("UI_Trans_Root/Bottom/Type/FriendNameBGImage/Text_GunType");
	self.mText_Level = self:GetText("UI_Trans_Root/Bottom/Type/Text_Level");
	self.mImage_MythicBlood = self:GetImage("UI_Trans_Root/Bottom/Type/Trans_GunMythicBlood");
	self.mTrans_GunSelect = self:GetRectTransform("UI_Trans_Root/UI_Trans_GunSelect");
	self.mTrans_GunSelect_GunSelectUnAble = self:GetRectTransform("UI_Trans_Root/UI_Trans_GunSelect/Trans_GunSelectUnAble");
	self.mTrans_BG = self:GetRectTransform("UI_Trans_Root/UI_Trans_BG");
	self.mTrans_Cover = self:GetRectTransform("UI_Trans_Root/Bottom/Type/Trans_Cover");
	self.mImage_GunElement = self:GetImage("UI_Trans_Root/Bottom/Type/GunType/Image_GunElement");
	self.mImage_GunDuty = self:GetImage("UI_Trans_Root/Bottom/Type/GunType/Image_GunDuty");
	self.mTrans_Must = self:GetRectTransform("UI_Trans_Root/Trans_Suggest/Trans_Must");
	self.mTrans_Recommend = self:GetRectTransform("UI_Trans_Root/Trans_Suggest/Trans_Recommend");
	self.mTrans_Root = self:GetRectTransform("UI_Trans_Root");
	self.mTrans_Frame = self:GetRectTransform("UI_Trans_Root/Bottom/Type/UI_Trans_Frame");
	self.mImage_HeadLine = self:GetImage("UI_Trans_Root/UI_Trans_BG/HeadMask/HeadLine");
	self.mImage_GunStatusBgImage =self:GetRectTransform("UI_Trans_Root/Image_GunStatusBgImage");
end
--@@ GF Auto Gen Block End

function UICombatPreparation_GunSlotItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	local helper = UIUtils.GetSscrollRectDragHelper(root.gameObject);
	helper.onBeginDrag = function(data,mousePos) self:OnBeginDrag(data,mousePos) end
	helper.onDrag = function(data,mousePos) self:OnDrag(data,mousePos) end
	helper.onEndDrag = function(data,mousePos) self:OnEndDrag(data,mousePos) end

	helper.onClick = function (obj)
		if self.enabled then
			UICombatPreparationPanel.onGunCardClick(self);
		end
	end;
end


function UICombatPreparation_GunSlotItem:InitData(data,necessary,recommended,UserCompleteInfo,battleType)
	self:SetSelected(false);
	self:SetEnabled(true);
	setactive(self.mTrans_Must.gameObject,necessary);
	setactive(self.mTrans_Recommend.gameObject,recommended);
	--self.mImage_BG_QualityMark.color = TableData.GetGlobalGun_Quality_Color1(data.TabGunData.rank);
	self.mText_Level.text = data.level;

    if UserCompleteInfo ~= nil then
        self.uid = UserCompleteInfo.Uid;
        self.userData = UserCompleteInfo;
        self.mText_GunType.text = UserCompleteInfo.Name;
    else
        self.uid = nil;
        self.userData = nil;
        self.mText_GunType.text = data.TabGunData.name.str;
    end

	local sprite = UICombatPreparationPanel.GetCharacterHeadSprite(data.TabGunData.code);
	self.mImage_BG_CharacterPic.sprite = sprite;
	self.mImage_BG_Cover.sprite = sprite;
	 
	self.mImage_GunElement.sprite = UICombatPreparationPanel.GetSprite("CombatPreparation/Res/CombatPreparation_RoleCard_AttributeBG"..data.TabGunData.element);
	self.mImage_GunDuty.sprite = UICombatPreparationPanel.GetSprite("Icon/Duty/Combat_GunDuty_"..data.TabGunData.duty);
	self.data = data;

	setactive(self.mImage_GunStatusBgImage.transform,false)
	self.mImage_BG_CharacterPic.color = CS.GF2.UI.UITool.StringToColor("FFFFFF");
	self.mImage_MythicBlood.color = CS.GF2.UI.UITool.StringToColor("FFFFFF");
	UIUtils.SetAlpha(self.mImage_MythicBlood,1);
	
	local playerHps = NetCmdSimulateBattleData:GetStagePlayerHpsByType(battleType)
	if playerHps ~= nil and playerHps.Count>0 then
		for k, v in pairs(playerHps) do
			if k == data.id and data.max_hp ~= 0 then
				self.mImage_MythicBlood.fillAmount = v / data.max_hp
				if v == 0 then
					setactive(self.mImage_GunStatusBgImage.transform,true)
					self.mImage_BG_CharacterPic.color = CS.GF2.UI.UITool.StringToColor("404040");
					self.mImage_MythicBlood.color = CS.GF2.UI.UITool.StringToColor("FF1940");
					UIUtils.SetAlpha(self.mImage_MythicBlood,0.02); 
				end
			end
		end
	end
end

function UICombatPreparation_GunSlotItem:SetSelected(value)
	setactive(self.mTrans_GunSelect.gameObject,value);
	self.mTrans_Root.transform.localPosition = value and Vector3(0,8,0) or Vector3(0,0,0);
	setactive(self.mTrans_Frame.gameObject,not value);
	self.mImage_HeadLine.color = value and Color(1,1,1,0.9) or Color(0,0,0,0.9);
end


function UICombatPreparation_GunSlotItem:SetVisible(value)
	self.mTrans_Root.transform.localPosition = value and Vector3(0,0,0) or Vector3(0,-500,0);
end


function UICombatPreparation_GunSlotItem:OnBeginDrag(data,mousePos)
	if self.enabled then
		print("OnBeginDrag uid = "..self.uid );
		self.dragging = UICombatPreparationPanel.PreviewIconDragBegin(self,mousePos);
	end
end

function UICombatPreparation_GunSlotItem:OnDrag(data,mousePos)
	if self.enabled and self.dragging then
		UICombatPreparationPanel.PreviewIconDrag(mousePos);
	end
end

function UICombatPreparation_GunSlotItem:OnEndDrag(data,mousePos)
	if self.enabled and self.dragging  then
		print("OnEndDrag uid = "..self.uid )
		UICombatPreparationPanel.PreviewIconDragEnd(self,mousePos);
		self.dragging = false;
	end
end


function UICombatPreparation_GunSlotItem:SetEnabled(enabled)
	self.enabled = enabled;
	setactive(self.mImage_BG_Cover.gameObject,not enabled);
	setactive(self.mTrans_Cover.gameObject,not enabled);
end