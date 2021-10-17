require("UI.UIBaseCtrl")
require("UI.Common.UICommonItemL")

UIEquipOverViewItem = class("UIEquipOverViewItem", UIBaseCtrl)
UIEquipOverViewItem.__index = UIEquipOverViewItem

UIEquipOverViewItem.mData = nil

function UIEquipOverViewItem:ctor()
end

function UIEquipOverViewItem:__InitCtrl()
    self.mBtn_Detail = self:GetSelfButton()
    self.mImage_SetIcon = self:GetImage("GrpEquipIcon/Img_Icon")
    self.mText_SetName = self:GetText("GrpTextName/Text_Name")
    self.mText_SetEnName = self:GetText("GrpTextName/Text_Type")
    self.mText_Num = self:GetText("GrpTextNum/Text_Num")
end

function UIEquipOverViewItem:InitCtrl(parent)
    self.parent = parent

    local obj = instantiate(UIUtils.GetGizmosPrefab("Character/ChrEquipSuitListItemV2.prefab", self))
    self:SetRoot(obj.transform)
    CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject)

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end


function UIEquipOverViewItem:SetData(data)
    self.mData = data
    if data then
        if data.id ~= 0 then
            self.mImage_SetIcon.sprite = IconUtils.GetEquipSetIcon(data.icon_large)
            self.mText_SetName.text = data.name.str
            self.mText_SetEnName.text = data.name_en.str
            self.mText_Num.text = NetCmdEquipData:GetEquipListBySetId(data.id).Count
        end
    end
end

function UIEquipOverViewItem:UpdateCount()
    self.mText_Num.text = NetCmdEquipData:GetEquipListBySetId(self.mData.id).Count
end
