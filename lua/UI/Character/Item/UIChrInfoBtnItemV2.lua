---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 6.
--- DateTime: 18/9/9 23:15
---
require("UI.UIBaseCtrl")

UIChrInfoBtnItemV2 = class("UIChrInfoBtnItemV2", UIBaseCtrl);
UIChrInfoBtnItemV2.__index = UIChrInfoBtnItemV2;



function UIChrInfoBtnItemV2:ctor()
    UIChrInfoBtnItemV2.super.ctor(self);
end

function UIChrInfoBtnItemV2:InitCtrl(parent)
    local prefab = ResSys:GetUIGizmos("UICommonFramework/ComChrEnemyInfoBtnItemV2.prefab");
    local obj = instantiate(prefab, parent); 

    self:SetRoot(obj.transform);

    self.m_Button = self:GetSelfButton();
    self.m_Text = self:GetText("Root/GrpText/Text_Name")
end


function UIChrInfoBtnItemV2:SetData(data)
    self.m_Text.text = data          
end

function UIChrInfoBtnItemV2:SetSelected(isSelect)
    self.m_Button.interactable = (not isSelect)
end
