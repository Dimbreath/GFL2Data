---
--- Created by 6.
--- DateTime: 18/9/5 12:00
---

require("UI.UIBaseView")

UIFormationTeammateItem = class("UIFormationTeammateItem", UIBaseView);
UIFormationTeammateItem.__index = UIFormationTeammateItem;

UIFormationTeammateItem.mImage_GunType = nil;
UIFormationTeammateItem.mText_GunType = nil;
UIFormationTeammateItem.mText_GunLevel = nil;

UIFormationTeammateItem.mText_GunName = nil;
UIFormationTeammateItem.mImage_GunStar = nil;

UIFormationTeammateItem.mText_GunGrade = nil;
UIFormationTeammateItem.mText_GunHp = nil;

UIFormationTeammateItem.mImage_Battery = nil;
UIFormationTeammateItem.mText_Power = nil;

UIFormationTeammateItem.mImage_Hp = nil;

UIFormationTeammateItem.mGunHpColor = "<color=#23A8E5FF>";
UIFormationTeammateItem.mColorEnd = "</color>";

--构造
function UIFormationTeammateItem:ctor()
    UIFormationTeammateItem.super.ctor(self);
end

--初始化
function UIFormationTeammateItem:InitCtrl(root)
    self:SetRoot(root);

    self.mImage_GunType = self:GetImage("TopBackground/GunType/GunTypeImage");
    self.mText_GunType = self:GetText("TopBackground/GunType/GunTypeText");
    self.mText_GunLevel = self:GetText("TopBackground/GunLevel/GunTypeText");

    self.mText_GunName = self:GetText("TopBackground/MiddlePart/GunName");
    self.mImage_GunStar = self:GetImage("TopBackground/MiddlePart/GunRate");

    self.mText_GunGrade = self:GetText("TopBackground/Grade/GradeText");
    self.mText_GunHp = self:GetText("TopBackground/HealthNum/HPnumber");

    self.mImage_Battery = self:GetImage("TopBackground/Fatigue/Battery");
    self.mText_Power = self:GetText("ButtonBackground/Power/PowerNumber");

    self.mImage_Hp = self:GetImage("TopBackground/HealthSliderBak/HealthSliderFill");

    self.mButton_IntoGunDetail = self:FindChild("TopBackground");
end

function UIFormationTeammateItem:SetData(gun)
    if gun == nil then
        return;
    end

    local gundata = TableData.GetGunData(gun.stc_gun_id);
    local defineGund = TableData.GetDefineGunData(gundata.typeInt);

    self.mImage_GunType.sprite = UIUtils.GetGunMessageSprite("Combat_GunTypeIcon_"..tostring(gundata.typeInt));
    self.mText_GunType.text = defineGund.name;
    self.mText_GunLevel.text = gun.level;
    self.mText_Power = gun.Power;

    self.mText_GunName.text = gundata.name;
    self.mImage_GunStar.sprite = UIUtils.GetGunMessageSprite("GunStar_"..gundata.rank);
    --self.mText_GunGrade =

    local hp = 0;

    if gun.hp <= 0 then
        hp = 0;
    else
        hp = gun.hp;
    end

    self.mText_GunHp.text = "<color=#23A8E5FF>"..gun.hp.."</color>/" ..gun.max_hp;

    local hpPer = gun.hp / gun.max_hp;
    self.mImage_Hp.fillAmount = hpPer;
    self.mImage_Hp.color = TableData.GetGlobalGunHpColorByPec(hpPer);

    local fatiguePec = gun.wear_Pct;
    local batterySpritename=TableData.GetGlobalGunFatigueBatterySpriteNameByPec(fatiguePec)
    self.mImage_Battery.sprite = UIUtils.GetGunMessageSprite(batterySpritename);
    self.mImage_Battery.color = TableData.GetGlobalGunFatigueBatteryColorByPec(fatiguePec);
    --self.mText_Power.text =
end

function UIFormationTeammateItem:SetActive(visible)
    setactive(self:GetRoot(), visible);
end

function UIFormationTeammateItem:SetParent(parent)
    UIUtils.AddListItem(self:GetRoot(), parent);
end