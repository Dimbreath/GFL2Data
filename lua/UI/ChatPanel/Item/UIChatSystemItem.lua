require("UI.UIBaseCtrl")
---@class UIChatSystemItem : UIBaseCtrl

UIChatSystemItem = class("UIChatSystemItem", UIBaseCtrl)
UIChatSystemItem.__index = UIChatSystemItem

function UIChatSystemItem:ctor()
    self.tempData = nil
    self.messageData = nil
end

function UIChatSystemItem:__InitCtrl()
    self.mText_Content = self:GetText("Text_Content")

    --UIUtils.AddHyperTextListener(self.mText_Content.gameObject, function (content)
    --    self:OnClickHyperText(content)
    --end)
end

function UIChatSystemItem:InitCtrl(obj)
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIChatSystemItem:SetData(data)
    if data then
        local str = ""
        local tempData = TableData.listSystemTipsDatas:GetDataById(data.tempId)
        self.tempData = tempData
        self.messageData = data
        if data.user then
            if data.tempType == UIChatGlobal.SystemType.Gun or data.tempType == UIChatGlobal.SystemType.Upgrade or data.tempType == UIChatGlobal.SystemType.Mental then
                if data.gun then
                    local gunData = TableData.listGunDatas:GetDataById(data.gun.Id)
                    local param = gunData.name.str .. "{" .. gunData.id .. "}"
                    str = string_format(tempData.content.str, data.user.Name, param)
                end
            elseif data.tempType == UIChatGlobal.SystemType.Weapon or data.tempType == UIChatGlobal.SystemType.WeaponLv then
                if data.weapon then
                    local weaponData = TableData.listGunWeaponDatas:GetDataById(data.weapon.StcId)
                    local param = weaponData.name.str .. "{" .. weaponData.id .. "}"
                    str = string_format(tempData.content.str, data.user.Name, param)
                end

            elseif data.tempType == UIChatGlobal.SystemType.EquipLv then
                if data.equip then
                    local equipData = TableData.listGunEquipDatas:GetDataById(data.equip.StcId)
                    local param = equipData.name.str .. "{" .. equipData.id .. "}"
                    str = string_format(tempData.content.str, data.user.Name, param)
                end
            end
        end

        self.mText_Content.text = str
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIChatSystemItem:OnClickHyperText(content)
    if self.messageData.tempType == UIChatGlobal.SystemType.Gun or self.messageData.tempType == UIChatGlobal.SystemType.Upgrade or self.messageData.tempType == UIChatGlobal.SystemType.Mental then
        UIUnitInfoPanel.Open(UIUnitInfoPanel.ShowType.Gun, self.messageData.gun)
    elseif self.messageData.tempType == UIChatGlobal.SystemType.Weapon or self.messageData.tempType == UIChatGlobal.SystemType.WeaponLv then

    elseif self.messageData.tempType == UIChatGlobal.SystemType.EquipLv then

    end
end
