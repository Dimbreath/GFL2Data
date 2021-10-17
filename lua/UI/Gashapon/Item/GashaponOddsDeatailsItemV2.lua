---zhai xing
require("UI.UIBaseCtrl")

GashaponOddsDeatailsItemV2=class("GashaponOddsDeatailsItemV2",UIBaseCtrl)
GashaponOddsDeatailsItemV2.__Index=GashaponOddsDeatailsItemV2

function GashaponOddsDeatailsItemV2:__InitCtrl()
    self.mTrans_ImgBg = self:GetRectTransform("Trans_ImgBg")
    self.mText_Name = self:GetText("Text_Name")
    self.mText_Percentage = self:GetText("GrpPercent/Text_Percentage")
    self.ImgIcon = self:GetImage("GrpPercent/Trans_GrpIcon/ImgIcon")
    self.mTrans_GrpDuty = self:GetRectTransform("Trans_GrpDuty")
    self.mTrans_GrpElement = self:GetRectTransform("Trans_GrpElement")
end

function GashaponOddsDeatailsItemV2:InitCtrl(parent)
    local obj=instantiate(UIUtils.GetGizmosPrefab("Gashapon/GashaponOddsDeatailsItemV2.prefab",self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject,parent.gameObject,false)
    end
    self:SetRoot(obj.transform)
    self:__InitCtrl()
    self.elementItem = UICommonElementItem.New()
    self.elementItem:InitCtrl(self.mTrans_GrpElement)
    self.dutyItem = UICommonDutyItem.New()
    self.dutyItem:InitCtrl(self.mTrans_GrpDuty)
end

function GashaponOddsDeatailsItemV2:SetData(data)
    self.mText_Name.text = data.name.str
    if data.type == GlobalConfig.ItemType.GunType then
        local gunData = TableData.listGunDatas:GetDataById(data.args[0])
        local dutyData = TableData.listGunDutyDatas:GetDataById(gunData.duty)
        self.dutyItem:SetData(dutyData);
    elseif data.type == GlobalConfig.ItemType.Weapon then
        local weaponData = TableData.listGunWeaponDatas:GetDataById(data.args[0])
        local elementData = TableData.listLanguageElementDatas:GetDataById(weaponData.element)
        self.elementItem:SetData(elementData);
    end

    setactive(self.mTrans_GrpDuty, data.type == GlobalConfig.ItemType.GunType)
    setactive(self.mTrans_GrpElement, data.type == GlobalConfig.ItemType.Weapon)
end

function GashaponOddsDeatailsItemV2:SetSelect(isSelect)

end
