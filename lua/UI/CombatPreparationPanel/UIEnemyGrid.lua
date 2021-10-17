require("UI.UIBaseCtrl")

UIEnemyGrid = class("UIEnemyGrid", UIBaseCtrl);
UIEnemyGrid.__index = UIEnemyGrid
UIEnemyGrid.enemy_id = 0;
UIEnemyGrid.grid_id = 0;
UIEnemyGrid.Base_Selected = nil;
UIEnemyGrid.Base_Unselected = nil;


function UIEnemyGrid:InitCtrl(obj)
    self:SetRoot(obj.transform);
    self.gameObject = obj;
    self.Base_Selected = self:FindChild("Base_Selected");
    self.Base_Unselected = self:FindChild("Base_Unselected");
end

function UIEnemyGrid:InitData(enemy_id,grid_id,pos,scale)
    self.enemy_id = enemy_id;
    self.grid_id = grid_id;
    self.gameObject.transform.localScale = Vector3.one * scale;
    self.gameObject.transform.position = pos;
    self:SetSelected(false);
end

function UIEnemyGrid:SetSelected(value)
    setactive(self.Base_Selected.gameObject, value);
    setactive(self.Base_Unselected.gameObject,not value);
end