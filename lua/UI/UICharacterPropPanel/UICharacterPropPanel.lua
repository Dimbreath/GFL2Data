require("UI.UIBasePanel")

UICharacterPropPanel = class("UICharacterPropPanel", UIBasePanel)
UICharacterPropPanel.__index = UICharacterPropPanel

UICharacterPropPanel.gunData = nil

function UICharacterPropPanel:ctor()
    UICharacterPropPanel.super.ctor(self)
end

function UICharacterPropPanel.Close()
    self = UICharacterPropPanel
    UIManager.CloseUI(UIDef.UICharacterPropPanel)
end

function UICharacterPropPanel.OnRelease()
    self = UICharacterPropPanel
end

function UICharacterPropPanel.Init(root, data)
    self = UICharacterPropPanel

    self.mIsPop = true
    self.gunData = NetCmdTeamData:GetGunByID(data)
    if self.gunData == nil then
        self.gunData = NetCmdTeamData:GetLockGunData(data)
    end

    UICharacterPropPanel.super.SetRoot(UICharacterPropPanel, root)

    UICharacterPropPanel.mView = UICharacterPropPanelView.New()
    UICharacterPropPanel.mView:InitCtrl(root)
end

function UICharacterPropPanel.OnInit()
    self = UICharacterPropPanel

    UICharacterPropPanel.super.SetPosZ(UICharacterPropPanel)

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UICharacterPropPanel.Close()
    end

    self:UpdatePanel()
end


function UICharacterPropPanel:UpdatePanel()
    if self.gunData then
        self:UpdateProp()
    end
end

function UICharacterPropPanel:UpdateProp()
    local propList = self:GetBarrackShowPropList()
    for i, prop in ipairs(propList) do
        local item = UICommonPropertyItem.New()
        item:InitCtrl(self.mView.mTrans_PropList)

        local value = self:GetPropValueByName(prop.sys_name)
        local addValue = self:GetEquipWeaponValue(prop.sys_name)
        item:SetGunProp(prop, value, addValue, false, i % 2 == 0)
    end
end

function UICharacterPropPanel:GetBarrackShowPropList()
    local propList = {}
    for i = 0, TableData.listLanguagePropertyDatas.Count - 1 do
        local propData = TableData.listLanguagePropertyDatas[i]
        if propData then
            if propData.barrack_show ~= 0 then
                table.insert(propList, propData)
            end
        end
    end

    table.sort(propList, function (a, b) return a.barrack_show < b.barrack_show end)

    return propList
end

function UICharacterPropPanel:GetPropValueByName(name)
    return self.gunData:GetGunPropertyValueByType(name)
end

function UICharacterPropPanel:GetEquipWeaponValue(name)
    local equipValue = self.gunData:GetGunEquipValueByName(name)
    local weaponValue = self.gunData:GetWeaponValueByName(name)
    return equipValue + weaponValue
end





