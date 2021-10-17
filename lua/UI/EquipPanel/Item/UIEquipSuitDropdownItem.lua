require("UI.UIBaseCtrl")

UIEquipSuitDropdownItem = class("UIEquipSuitDropdownItem", UIBaseCtrl)
UIEquipSuitDropdownItem.__index = UIEquipSuitDropdownItem

function UIEquipSuitDropdownItem:ctor()
    self.setId = 0
end

function UIEquipSuitDropdownItem:__InitCtrl()
    self.mBtn_Suit = self:GetSelfButton()
    self.mText_Name = self:GetText("GrpText/Text_SuitName")
    self.mText_Num = self:GetText("GrpText/Text_SuitNum")
end

function UIEquipSuitDropdownItem:InitCtrl(parent)
   local obj = instantiate(UIUtils.GetGizmosPrefab("Character/ChrEquipSuitDropdownItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIEquipSuitDropdownItem:SetData(setId)
    self.setId = setId
    if setId then
        local data = TableData.listEquipSetDatas:GetDataById(setId)
        self.mText_Name.text = data.name.str
        self.mText_Num.text = NetCmdEquipData:GetEquipListBySetId(data.id).Count
        setactive(self.mText_Num.gameObject, true)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end

end


