--region *.lua
--Date

require("UI.UIBaseCtrl")

UIFormationCarrierItem = class("UIFormationCarrierItem", UIBaseCtrl);
UIFormationCarrierItem.__index = UIFormationCarrierItem;

UIFormationCarrierItem.mButton_Select = nil;

UIFormationCarrierItem.mImage_Carrier = nil;
UIFormationCarrierItem.mImage_CarrierTypeA = nil;
UIFormationCarrierItem.mImage_CarrierTypeD = nil;

UIFormationCarrierItem.mText_CarrierLevel = nil;
UIFormationCarrierItem.mText_CarrierName = nil;

UIFormationCarrierItem.mObj_Select = nil;

UIFormationCarrierItem.mData = nil;

--构造
function UIFormationCarrierItem:ctor()
    UIFormationCarrierItem.super.ctor(self);
end

--初始化
function UIFormationCarrierItem:InitCtrl(root)

    self:SetRoot(root);

    self.mButton_Select = self:GetButton("BG/CarrierDetail");

    self.mImage_Carrier = self:GetImage("BG/CarrierDetail/CarrierChar/Placeholder");
    self.mImage_CarrierTypeA = self:GetImage("BG/CarrierDetail/Type/A_Pic");
    self.mImage_CarrierTypeD = self:GetImage("BG/CarrierDetail/Type/D_Pic");

    self.mText_CarrierLevel = self:GetText("BG/CarrierDetail/Lv/BG/Text");
    self.mText_CarrierName = self:GetText("BG/CarrierDetail/Name/BG/Text");

    self.mObj_Select = self:FindChild("BG/Sel");
end

function UIFormationCarrierItem:SetData(data)

    self.mData = data;

    local carrier = TableData.GetCarrierBaseBodyData(data.stc_carrier_id);
    if carrier == nil then
        return
    end

    self.mText_CarrierLevel.text = "1";
    self.mText_CarrierName.text = carrier.name;

    if carrier.type == CS.TableEnumDefine.ECarrierType.eAttack then
        setactive(self.mImage_CarrierTypeA, true);
        setactive(self.mImage_CarrierTypeD, false);
    else 
        if carrier.type == CS.TableEnumDefine.ECarrierType.eDefense then
            setactive(self.mImage_CarrierTypeA, false);
            setactive(self.mImage_CarrierTypeD, true);
        end
    end
end

function UIFormationCarrierItem:SetSelectEnable(enable)
    setactive(self.mObj_Select, enable);
end

--endregion
