---
--- Created by 6.
--- DateTime: 18/9/5 11:23
---

require("UI.UIBaseCtrl")

UICarrierItem = class("UICarrierItem", UIBaseCtrl);
UICarrierItem.__index = UICarrierItem;

UICarrierItem.mObj_Carrier = nil;
UICarrierItem.mObj_Chose = nil;

UICarrierItem.mText_CarrierName = nil;
UICarrierItem.mText_CarrierLevel = nil;

UICarrierItem.mImage_Carrier = nil;
UICarrierItem.mObj_CarrierStar = {};
UICarrierItem.mButton_Detail = nil;

UICarrierItem.mImage_HpSlider = nil;
UICarrierItem.mText_HpPer = nil;

UICarrierItem.mText_Power = nil;

 -----------------------载具界面应用到的子物件-----------------------
UICarrierItem.mButton_ItemSelect = nil;
UICarrierItem.mImage_ItemCarrier = nil;
UICarrierItem.mImage_CarrierTypeA = nil;
UICarrierItem.mImage_CarrierTypeD = nil;
UICarrierItem.mImage_HeavyDamage = nil;

UICarrierItem.mObj_CarrierItemTeamId = nil;

UICarrierItem.mText_CarrierItemLevel = nil;
UICarrierItem.mText_CarrierItemName = nil;
UICarrierItem.mText_CarrierItemTeamId = nil;

UICarrierItem.mObj_Selected = nil;
UICarrierItem.mObj_UnavailableMask = nil;


UICarrierItem.mObj_Select = nil;
UICarrierItem.mData = nil;

function UICarrierItem:ctor()
    UICarrierItem.super.ctor(self);
end

function UICarrierItem:InitCtrl(root)

    self:SetRoot(root);

    ------------编队界面右下角------------
    self.mObj_Carrier = self:FindChild("Regular");
    self.mObj_Chose = self:FindChild("NotSelected");

    self.mText_CarrierName = self:GetText("Regular/VehicleName");
    self.mText_CarrierLevel = self:GetText("Regular/VehicleLevel/GunTypeText");
    self.mImage_Carrier = self:GetImage("Regular/VehicleImage/Image");

    local starNode = self:FindChild("Regular/GunRate");
    if starNode ~= nil then
        for i = 0, starNode.transform.childCount - 1 do
            self.mObj_CarrierStar[i + 1] = starNode.transform:GetChild(i);
        end
    end

    self.mButton_Detail = self:GetButton("Regular/DetailButton");
    self.mImage_HpSlider = self:GetImage("Regular/HealthSliderBak/HealthSliderFill");
    self.mText_HpPer = self:GetText("Regular/HealthPer/Text");
    self.mText_Power = self:GetText("Regular/Power/PowerNumber");

    ------------载具界面应用到的子物件------------
    self.mButton_ItemSelect = self:GetSelfButton();

    self.mImage_ItemCarrier = self:GetImage("avator/image");
    --self.mImage_CarrierTypeA = self:GetImage("BG/CarrierDetail/Type/A_Pic");
    --self.mImage_CarrierTypeD = self:GetImage("BG/CarrierDetail/Type/D_Pic");

    self.mObj_CarrierItemTeamId = self:FindChild("CurrentTeam");
    self.mImage_HeavyDamage = self:GetImage("HeavyDamage");
    self.mText_CarrierItemTeamId = self:GetText("CurrentTeam/TeamNum");
    self.mText_CarrierItemLevel = self:GetText("Level/LvNum");
    self.mText_CarrierItemName = self:GetText("ButtonBar/Name/Text");

    self.mObj_Selected = self:FindChild("Selected");
    self.mObj_UnavailableMask = self:FindChild("UnavailableMask");

end

function UICarrierItem:SetSample(data)
    if data == nil then
        return;
    end

    self.mText_CarrierLevel.text = "<size=16>Lv.</size>"..data.level;
    self.mImage_HpSlider.fillAmount = data.hp / data.prop.max_hp;
    self.mText_HpPer.text = tostring(math.ceil(data.hp / data.prop.max_hp * 100)).."%";

    local carrierData = TableData.GetCarrierTemplateData(data.stc_carrier_id);
    if carrierData ~= nil then
        self.mText_CarrierName.text = carrierData.name;

    end
end

function UICarrierItem:ShowCarrier()
    setactive(self.mObj_Carrier, true);
    setactive(self.mObj_Chose, false);
end

function UICarrierItem:ShowNotSelected()
    setactive(self.mObj_Carrier, false);
    setactive(self.mObj_Chose, true);
end

function UICarrierItem:ShowStar(star)
    for i = 1, #self.mObj_CarrierStar do
        if i > star then
            break;
        end

        --setactive(self.mObj_CarrierStar[i], true);
    end
end

function UICarrierItem:SetCarriedItemData(data)

    self.mData = data;

    local carrier = TableData.GetCarrierBaseBodyData(data.stc_carrier_id);
    if carrier == nil then
        return
    end

    if data.team_id == 0 then
        setactive(self.mObj_CarrierItemTeamId, false);
    else
        setactive(self.mObj_CarrierItemTeamId, true);
        print("设置载具teamid:"..data.team_id);
        self.mText_CarrierItemTeamId.text = data.team_id;
    end
    self.mText_CarrierItemLevel.text = data.level;
    self.mText_CarrierItemName.text = carrier.name;

    local fatiguePec = data.hp / data.prop.max_hp;
    if fatiguePec <= TableDataMgr.HeavyDamageFloat then
        setactive(self.mImage_HeavyDamage.gameObject, true);
    else
        setactive(self.mImage_HeavyDamage.gameObject, false);
    end

    --if carrier.type == CS.TableEnumDefine.ECarrierType.eAttack then
        --setactive(self.mImage_CarrierTypeA, true);
        --setactive(self.mImage_CarrierTypeD, false);
    --else
        --if carrier.type == CS.TableEnumDefine.ECarrierType.eDefense then
            --setactive(self.mImage_CarrierTypeA, false);
            --setactive(self.mImage_CarrierTypeD, true);
        --end
    --end
end

--选择的状态  不可选  未选中  选中
function UICarrierItem:SeclectState(state)
    if state==UICharacterItem.mSelectType.Selected then
        setactive(self.mObj_Selected, true);
        setactive(self.mObj_UnavailableMask, false);
    elseif state==UICharacterItem.mSelectType.UnSelected then
        setactive(self.mObj_Selected, false);
        setactive(self.mObj_UnavailableMask, false);
    elseif state==UICharacterItem.mSelectType.Unusefull then
        setactive(self.mObj_Selected, false);
        setactive(self.mObj_UnavailableMask, true);
    end
end