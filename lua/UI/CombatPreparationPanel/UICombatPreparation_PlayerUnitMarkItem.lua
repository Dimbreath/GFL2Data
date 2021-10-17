require("UI.UIBaseCtrl")

UICombatPreparation_PlayerUnitMarkItem = class("UICombatPreparation_PlayerUnitMarkItem", UIBaseCtrl);
UICombatPreparation_PlayerUnitMarkItem.__index = UICombatPreparation_PlayerUnitMarkItem
UICombatPreparation_PlayerUnitMarkItem.grid_id = nil;
UICombatPreparation_PlayerUnitMarkItem.gun_id = nil;
UICombatPreparation_PlayerUnitMarkItem.data = nil;
UICombatPreparation_PlayerUnitMarkItem.grid_position = nil;
UICombatPreparation_PlayerUnitMarkItem.grid_position = nil;
--@@ GF Auto Gen Block Begin
UICombatPreparation_PlayerUnitMarkItem.mImage_Icon = nil;
UICombatPreparation_PlayerUnitMarkItem.mText_PlayerTypeText = nil;

function UICombatPreparation_PlayerUnitMarkItem:__InitCtrl()

	self.mImage_Icon = self:GetImage("Mask/Image_Icon");
	self.mText_PlayerTypeText = self:GetText("Text_PlayerTypeText");
end
--@@ GF Auto Gen Block End

function UICombatPreparation_PlayerUnitMarkItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end


function UICombatPreparation_PlayerUnitMarkItem:InitData(gun_id,grid_id)
	self:InitGun(gun_id);
	self:InitGrid(grid_id);

	if self.DragHelper == nil then
		local helper = UIUtils.GetDragHelper(self:GetRoot());
		helper.onBeginDrag = function(data,mousePos) self:OnBeginDrag(data,mousePos) end
		helper.onDrag = function(data,mousePos) self:OnDrag(data,mousePos) end
		helper.onEndDrag = function(data,mousePos) self:OnEndDrag(data,mousePos) end
		helper.onClick = function (obj) UICombatPreparationPanel.ShowGunInfo(self,true); end;
	end
end

function UICombatPreparation_PlayerUnitMarkItem:InitGun(gun_id)
	local data = NetCmdTeamData:GetGunByID(tonumber(gun_id));
	if data == nil then
		print("找不到人形数据 gun_id = " ..gun_id)
	else
		self.mText_PlayerTypeText.text = GunTypeStr[data.TabGunData.type];
		self.mImage_Icon.sprite = UICombatPreparationPanel.GetCharacterHeadSprite(data.TabGunData.code);
		self.data = data;
		self.gun_id = gun_id;
	end
end

function UICombatPreparation_PlayerUnitMarkItem:InitGrid(grid_id)
	self.grid_id = grid_id;
	self.grid_position = CS.GridUtils.GetGridByGridID(tonumber(self.grid_id));
end


function UICombatPreparation_PlayerUnitMarkItem:UpdatePosition(parent,camera)
	local rect = self:GetSelfRectTransform();
	local pos = CS.LuaUIUtils.World2UI(parent,camera,CS.GridUtils.GridToWorld(self.grid_position));
	rect.anchoredPosition = pos;
end

function UICombatPreparation_PlayerUnitMarkItem:OnBeginDrag(data,mousePos)
	UICombatPreparationPanel.PreviewIconDragBegin(self.gun_id,mousePos);
end

function UICombatPreparation_PlayerUnitMarkItem:OnDrag(data,mousePos)
	UICombatPreparationPanel.PreviewIconDrag(mousePos);
end
function UICombatPreparation_PlayerUnitMarkItem:OnEndDrag(data,mousePos)
	UICombatPreparationPanel.PlayerUnitMarkItemDragEnd(self);
end