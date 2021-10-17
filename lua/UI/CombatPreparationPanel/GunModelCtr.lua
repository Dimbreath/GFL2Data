
GunModelCtr = class("GunModelCtr",UIBaseCtrl);
GunModelCtr.__index = GunModelCtr;
GunModelCtr.gameObject = nil;
GunModelCtr.mImage_Icon = nil;
GunModelCtr.uid = 0;
GunModelCtr.headIconCtr = nil;
GunModelCtr.TypeColor = { CS.GF2.UI.UITool.StringToColor("0DBB57"),CS.GF2.UI.UITool.StringToColor("FF392A"),CS.GF2.UI.UITool.StringToColor("3472EF"),CS.GF2.UI.UITool.StringToColor("8634FF"),CS.GF2.UI.UITool.StringToColor("EBB702"),CS.GF2.UI.UITool.StringToColor("FFFFFF")};
function GunModelCtr:InitCtrl(obj,TokensHeadIconPrefab,iconRoot)
    self:SetRoot(obj.transform);
    self.gameObject = obj;
    --self.mImage_Icon = self:GetImage("Type_Pos/UIRoot/Mask/Image_Icon");
    --self.mText_Name = self:GetText("Type_Pos/UIRoot/ImageBG/Text_GunTypeText");
    self.Type_Pos = self:FindChild("Type_Pos");

    self.mBase = self:FindChild("Base");
    self.mBase_Selected = self:FindChild("Base/Base_Selected");
    self.mBase_Unselected = self:FindChild("Base/Base_Unselected");

    self.mBase_Friend = self:FindChild("Base_Friend");
    self.mBase_Friend_Selected = self:FindChild("Base_Friend/Base_Selected_Friend");
    self.mBase_Friend_Unselected = self:FindChild("Base_Friend/Base_Unselected_Friend");
    local instObj = instantiate(TokensHeadIconPrefab);
    UIUtils.AddListItem(instObj,iconRoot);
    self.headIconCtr = instObj.transform;
    self.mImage_Icon = self:GetUIImage(instObj.transform ,"Mask/Image_Head");
    self.mGunTypeBG = self:GetUIImage(instObj.transform ,"GunTypeBG/Image_GunTypeBGImage");
    self.mGunType = self:GetUIImage(instObj.transform ,"GunTypeBG/Image_GunType");

    local angle = CS.EmbattleCameraController.Instance.angle_y;
    self:AdjustGridRotation(-angle);
end


function GunModelCtr:AdjustGridRotation(angle)
    angle = CS.MathClient.SimplifyDegree(angle);

    if -45 < angle and angle <= 45 then
        angle = 0;
    elseif -135 < angle and angle < -45 then
        angle = -90;
    elseif 45 < angle and angle < 135 then
        angle = 90;
    else
        angle = -180;
    end
    self.mUIRoot.rotation = CS.UnityEngine.Quaternion.Euler(0, angle, 0);
end

function GunModelCtr:GetUIImage(transform, path)
    if path == "" then
        return;
    end
    child = transform:Find(path);
    if child == nil then
        return;
    end
    return CS.LuaUIUtils.GetImage(child)
end

function GunModelCtr:InitData(gun_id,grid_id,uid,battleType)
    self:InitGun(gun_id,uid,battleType);
    self:InitGrid(grid_id);
    self:SetSelected(false);
end

function GunModelCtr:InitGun(gun_id,uid,battleType)
    self.uid = uid;
    self:SetAssistant(self.uid ~= 0);
    local data = NetCmdTeamData:GetMyGun(battleType,tonumber(gun_id));
    if data == nil then
        print("找不到人形数据 gun_id = " ..gun_id)
    else
        --self.mText_Name.text = data.TabGunData.name.str;
        setactive(self.headIconCtr.gameObject,true);
        self.mImage_Icon.sprite = UICombatPreparationPanel.GetCharacterHeadSprite(data.TabGunData.code);
        local elementData = TableData.listLanguageElementDatas:GetDataById(data.TabGunData.element)
		self.mGunType.sprite = IconUtils.GetElementIcon(elementData.icon .. "_M")
		
		self.mGunTypeBG.color = self.TypeColor[data.TabGunData.element];
        self.data = data;
        self.gun_id = gun_id;
    end
end

function GunModelCtr:InitGrid(grid_id)
    self.grid_id = tonumber(grid_id);
    local grid = CS.GridManager.Instance:GetGridByID(tonumber(grid_id));
    self.gameObject.transform.position = grid.pos;
    self:SetPosition(grid.pos,grid.pos);
end

function GunModelCtr:SetSelected(value)
    setactive(self.mBase_Selected.gameObject, value);
    setactive(self.mBase_Unselected.gameObject,not value);

    setactive(self.mBase_Friend_Selected.gameObject, value);
    setactive(self.mBase_Friend_Unselected.gameObject,not value);
end

function GunModelCtr:SetAssistant(value)
    setactive(self.mBase.gameObject,not value);
    setactive(self.mBase_Friend.gameObject, value);
end


function GunModelCtr:SetPosition(worldPos,GridPos)
    self.gameObject.transform.position = worldPos;
    self.mBase.transform.position = GridPos;
end

function GunModelCtr:UpdateHeadPosition(CameraPosition)

    local distance = math.abs(self.Type_Pos.transform.position.y - CameraPosition.y);

    self.headIconCtr.position = CS.LuaUtils.WorldToScreenPoint(self.Type_Pos.transform.position);
    if distance < 1 then
        distance = 1;
    end
    local scale = 12 / distance;
    if scale > 2 then
        scale = 2;
    end
    self.headIconCtr.localScale = Vector3(scale,scale,scale);
end

function GunModelCtr:SetVisible(value)
    setactive(self.headIconCtr.gameObject, value);
    setactive(self.gameObject, value);
end

function GunModelCtr:OnDestroy()
    gfdestroy(self.headIconCtr.gameObject);
    gfdestroy(self.gameObject);
end
