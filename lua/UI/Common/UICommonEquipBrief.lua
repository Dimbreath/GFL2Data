require("UI.UIBaseCtrl")

UICommonEquipBriefItem = class("UICommonEquipBriefItem", UIBaseCtrl)
UICommonEquipBriefItem.__index = UICommonEquipBriefItem

UICommonEquipBriefItem.ShowType =
{
    Item = 1,
    Equip = 2,
}

function UICommonEquipBriefItem:ctor()
    self.data = nil
    self.type = 0
    self.starList = {}
    self.subProp = {}
end

function UICommonEquipBriefItem:__InitCtrl()
    self.mTrans_RandomProp = self:GetRectTransform("UI_Trans_RandomProperty")
    self.mTrans_Random = self:GetRectTransform("IconBase/Image_RandomMask")
    self.mImage_Icon = self:GetImage("IconBase/EquipIconBase/UI_base/mask/avatareImage")
    self.mImage_Base = self:GetImage("IconBase/EquipIconBase/UI_base")
    self.mTrans_Arrow = self:GetRectTransform("IconBase/EquipIconBase/UI_base/Trans_arrow")
    self.mImage_Arrow = self:GetImage("IconBase/EquipIconBase/UI_base/Trans_arrow/Image")
    self.mText_Name = self:GetText("Text_name")
    self.mText_Level = self:GetText("LVPanel/Text_lvNum")
    self.mImage_Rank = self:GetImage("Image_rank")
    self.mTrans_PropList = self:GetRectTransform("UI_Trans_Property")
    self.mText_MainAttrName = self:GetText("UI_Trans_Property/Main/Text_PropertyName")
    self.mText_MainAttrValue = self:GetText("UI_Trans_Property/Main/Text_PropertyNum")
    self.mTrans_SubProperties = self:GetRectTransform("UI_Trans_Property/VLayout_Sub")
    self.mText_SetName = self:GetText("SetInfo/Text_SetName")
    self.mText_SetDetail = self:GetText("SetInfo/Text_setDetail")
    self.mText_SetType = self:GetText("SetInfo/SetType/Trans_Text_TypeText")
    self.mText_Desc = self:GetText("Text_DESCRIPTION")

    for i = 1, GlobalConfig.MaxStar do
        local star = self:GetRectTransform("Layout_star/StarUp" .. i)
        table.insert(self.starList, star)
    end
end

function UICommonEquipBriefItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonEquipBrief.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonEquipBriefItem:SetData(type, id)
    if type then
        self.type = type
        if self.type == UICommonEquipBriefItem.ShowType.Item then
            self.data = TableData.GetItemData(id)
            self:UpdateItem()
        elseif self.type == UICommonEquipBriefItem.ShowType.Equip then
            self.data = NetCmdEquipData:GetEquipById(id)
            self:UpdateEquip()
        end
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UICommonEquipBriefItem:UpdateEquip()
    local equipData = TableData.listGunEquipDatas:GetDataById(self.data.stcId)
    self.mText_Level.text = self.data.level
    self:UpdateEquipShow(equipData)
    self:UpdateAttribute(self.data)

    setactive(self.mTrans_PropList, true)
    setactive(self.mTrans_Random, false)
    setactive(self.mTrans_RandomProp, false)
    setactive(self.mTrans_Arrow, true)
end

function UICommonEquipBriefItem:UpdateItem()
    if self.data then
        if self.data.type == GlobalConfig.ItemType.EquipPackages then
            self.mText_Name.text = self.data.name.str
            self.mImage_Icon.sprite = IconUtils.GetItemIconSprite(self.data.id)
            self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(self.data.rank)
            self.mText_Desc.text = self.data.description.str
            self:SetStar(self.data.rank)
            self:SetEquipSuit(self.data.args[1])
        elseif self.data.type == GlobalConfig.ItemType.EquipmentType then
            local equipData = TableData.listGunEquipDatas:GetDataById(self.data.args[0])
            self:UpdateEquipShow(equipData)
        end
        self.mText_Level.text = "0"
        setactive(self.mTrans_PropList, false)
        setactive(self.mTrans_RandomProp, true)
        setactive(self.mTrans_Random, self.data.type == GlobalConfig.ItemType.EquipPackages)
        setactive(self.mTrans_Arrow, self.data.type ~= GlobalConfig.ItemType.EquipPackages)
    end
end

function UICommonEquipBriefItem:UpdateAttribute(data)
    self:UpdateMainAttribute(data)
    self:UpdateSubAttribute(data)
end

function UICommonEquipBriefItem:UpdateEquipShow(equipData)
    if equipData then
        local rankColor = TableData.GetGlobalGun_Quality_Color2(equipData.rank)
        self.mText_Name.text = equipData.name.str
        self.mImage_Icon.sprite = IconUtils.GetEquipSprite(equipData.res_code)
        self.mText_Desc.text = equipData.description.str
        self.mImage_Rank.color = rankColor
        self.mImage_Arrow.color = rankColor
        self.mImage_Base.color = rankColor
        self:SetEquipSuit(equipData.set_id_cs)
        self:SetStar(equipData.rank)
        self:UpdateArrow(equipData.category)
    end
end

function UICommonEquipBriefItem:SetEquipSuit(setId)
    local setData = TableData.listEquipSetDatas:GetDataById(setId)
    self.mText_SetName.text = setData.name.str
    self.mText_SetDetail.text = CS.LuaUIUtils.Unescape("\t\t\t\t" .. setData.description.str)
    self.mText_SetType.text = string_format(TableData.GetHintById(20008), UIUtils.NumberToString(setData.set_num))
end

function UICommonEquipBriefItem:SetStar(rank)
    if self.starList then
        for i = 1, #self.starList do
            setactive(self.starList[i], i <= rank)
        end
    end
end

function UICommonEquipBriefItem:UpdateArrow(index)
    self.mTrans_Arrow.localEulerAngles = UIEquipGlobal:GetEquipAngle(index)
end

function UICommonEquipBriefItem:UpdateMainAttribute(data)
    if data.main_prop then
        local tableData = TableData.listCalibrationDatas:GetDataById(data.main_prop.Id)
        if tableData then
            local propData = TableData.GetPropertyDataByName(tableData.property, tableData.type)
            self.mText_MainAttrName.text = propData.show_name.str
            if propData.show_type == 2 then
                self.mText_MainAttrValue.text = math.ceil(data.main_prop.Value / 10)  .. "%"
            else
                self.mText_MainAttrValue.text = data.main_prop.Value
            end
        end
    end
end

function UICommonEquipBriefItem:UpdateSubAttribute(data)
    if data.sub_props then
        local item = nil
        for _, item in ipairs(self.subProp) do
            item:SetData(nil)
        end

        for i = 0, data.sub_props.Length - 1 do
            local prop = data.sub_props[i]
            local tableData = TableData.listCalibrationDatas:GetDataById(prop.Id)
            local propData = TableData.GetPropertyDataByName(tableData.property, tableData.type)
            if i + 1 <= #self.subProp then
                item = self.subProp[i + 1]
            else
                item = PropertyItemS.New()
                item:InitCtrl(self.mTrans_SubProperties)
                table.insert(self.subProp, item)
            end
            item:SetData(propData, prop.Value, false, ColorUtils.BlackColor, false)
            item:SetNameColor(ColorUtils.BlackColor)
            item:SetTextSize(24)
        end
    end
end
