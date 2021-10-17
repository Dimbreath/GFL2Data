require("UI.UIBaseCtrl")

UICombatPreparation_EnemyUnitMarkItem = class("UICombatPreparation_EnemyUnitMarkItem", UIBaseCtrl);
UICombatPreparation_EnemyUnitMarkItem.__index = UICombatPreparation_EnemyUnitMarkItem

UICombatPreparation_EnemyUnitMarkItem.grid_id = nil;
UICombatPreparation_EnemyUnitMarkItem.enemy_id = nil;
UICombatPreparation_EnemyUnitMarkItem.direction = nil;
UICombatPreparation_EnemyUnitMarkItem.max_ap = nil;
UICombatPreparation_EnemyUnitMarkItem.max_hp = nil;
UICombatPreparation_EnemyUnitMarkItem.shoot_range = nil;
UICombatPreparation_EnemyUnitMarkItem.grid_position = nil;
UICombatPreparation_EnemyUnitMarkItem.level = 0;
UICombatPreparation_EnemyUnitMarkItem.name = nil;
UICombatPreparation_EnemyUnitMarkItem.description = nil;

--@@ GF Auto Gen Block Begin
UICombatPreparation_EnemyUnitMarkItem.mImage_Icon = nil;

function UICombatPreparation_EnemyUnitMarkItem:__InitCtrl()

	self.mImage_Icon = self:GetImage("Mask/Image_Icon");
end

--@@ GF Auto Gen Block End

function UICombatPreparation_EnemyUnitMarkItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UICombatPreparation_EnemyUnitMarkItem:InitData(data,level)
	local datas = string.split(data,":");
	self.grid_id = datas[1];
	self.enemy_id = datas[2];
	self.direction = datas[3];
	self.grid_position = CS.GridUtils.GetGridByGridID(tonumber(self.grid_id));
	local enemyData = TableData.GetEnemyData(self.enemy_id);
	--local role_template = TableData.GetRoleTemplateData(enemyData.role_template_id);
	local sprite = UICombatPreparationPanel.GetCharacterHeadSprite(enemyData.character_pic);
	if sprite == nil then
		gferror("找不到敌人图标"..code);
	else
		self.mImage_Icon.sprite = sprite;
	end
	local levelPropertyData = TableData.GetLevelPropertyDataByGroupAndLevel(enemyData.property_group,level);
	
	self.level = level;--enemyData.add_level;
	self.name = enemyData.name;
	self.description = enemyData.description;
	self.max_ap = levelPropertyData.max_ap;
	self.max_hp = levelPropertyData.max_hp;
	--self.shoot_range = PropertyUtils.GetShootRange(enemyData.role_template_id);
end


function UICombatPreparation_EnemyUnitMarkItem:UpdatePosition(parent,camera)
	local rect = self:GetSelfRectTransform();
	local pos = CS.LuaUIUtils.World2UI(parent,camera,CS.GridUtils.GridToWorld(self.grid_position));
	rect.anchoredPosition = pos;
end

