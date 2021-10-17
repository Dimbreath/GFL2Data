---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 6.
--- DateTime: 18/9/9 23:15
---
require("UI.UIBaseCtrl")

UIUnitPropertyItemV2 = class("UIUnitPropertyItemV2", UIBaseCtrl);
UIUnitPropertyItemV2.__index = UIUnitPropertyItemV2;


function UIUnitPropertyItemV2:ctor()
    UIUnitPropertyItemV2.super.ctor(self);
end

function UIUnitPropertyItemV2:InitCtrl(root,propertyType)
    self:SetRoot(root);
    self.m_IconImage = self:GetImage("GrpList/GrpIcon/Img_Icon");
    self.m_NameText = self:GetText("GrpList/Text_Name");
    self.m_ValueText = self:GetText("GrpNum/Text_Num");

    if propertyType == nil then
        --临时兼容
        return;
    end
    self.PropertyType = propertyType;
    local propertyData = TableData.GetPropertyDataByName(propertyType:ToString());
    self.m_NameText.text = propertyData.show_name;
    self.m_IconImage.sprite = IconUtils.GetAttributeIcon(propertyData.icon);
    self.m_NormalShowType = (propertyData.ShowType == 1);
end


function UIUnitPropertyItemV2:SetValue(value)
    if self.PropertyType == E_PD.hit then
        value = value + 1000;
    end

    if(self.m_NormalShowType) then
        self.m_ValueText.text = value;
    else
        self.m_ValueText.text = math.ceil(value * 0.1) .. "%";
    end

    self.m_ValueText.color = Color.white;
            
end