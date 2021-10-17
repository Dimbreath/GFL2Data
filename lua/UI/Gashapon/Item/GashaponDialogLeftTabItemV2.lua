--zhai xing
require("UI.UIBaseCtrl")

GashaponDialogLeftTabItemV2=class("GashaponDialogLeftTabItemV2",UIBaseCtrl)
GashaponDialogLeftTabItemV2.__Index=GashaponDialogLeftTabItemV2

function GashaponDialogLeftTabItemV2:__InitCtrl()
         self.mText_Name=self:GetText("GrpNor/GrpText/Text_Name")
         self.mBtn_Self=self:GetSelfButton()
end

function GashaponDialogLeftTabItemV2:InitCtrl(parent)
    local obj=instantiate(UIUtils.GetGizmosPrefab("Gashapon/GashaponDialogLeftTabItemV2.prefab",self))
    if parent then
          CS.LuaUIUtils.SetParent(obj.gameObject,parent.gameObject,false)
    end
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function GashaponDialogLeftTabItemV2:SetData(data)

        self.mText_Name.text=data.name;

end

function GashaponDialogLeftTabItemV2:SetSelect(isSelect)
    self.mBtn_Self.interactable=not isSelect
end