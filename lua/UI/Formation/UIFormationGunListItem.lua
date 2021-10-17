--region *.lua
--Date

require("UI.UIBaseCtrl")

UIFormationGunListItem = class("UIFormationGunListItem", UIBaseCtrl);
UIFormationGunListItem.__index = UIFormationGunListItem;

UIFormationGunListItem.mText_GunName = nil;
UIFormationGunListItem.mButton_Gun = nil;
UIFormationGunListItem.mImage_Sel = nil;

--构造
function UIFormationGunListItem:ctor()
    UIFormationGunListItem.super.ctor(self);
end

--初始化
function UIFormationGunListItem:InitCtrl(root)

    self:SetRoot(root);

    self.mText_GunName = self:GetText("BG/GunDetail/Name/BG/Text");
    self.mButton_Gun = self:GetButton("BG/GunDetail");
    self.mImage_Sel = self:GetImage("BG/GunDetail/Sel"); 
end

function UIFormationGunListItem:SetData(gunData)
    local gunData = CS.GF2.Data.TableData.listGunDatas:GetDataById(gunData.stc_gun_id);
    self.mText_GunName.text = gunData.name;
end

function UIFormationGunListItem:SetSelect(visible)
    setactive(self.mImage_Sel, visible);
end

--endregion
