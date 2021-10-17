require("UI.UIBaseCtrl")
---@class UICommonWeaponInfoItem
UICommonWeaponInfoItem = class("UICommonWeaponInfoItem", UIBaseCtrl)
UICommonWeaponInfoItem.__index = UICommonWeaponInfoItem

function UICommonWeaponInfoItem:ctor()
    self.mData = nil
    self.elementItem = nil
end

function UICommonWeaponInfoItem:__InitCtrl()
    self.mBtn_Select = self:GetSelfButton()
    self.mBtn_Reduce = self:GetButton("Trans_GrpReduce/GrpMinus/ComBtn1ItemV2")
    self.mImage_Icon = self:GetImage("GrpNor/GrpWeaponIcon/Img_Icon")
    self.mImage_Rank = self:GetImage("GrpNor/GrpQualityLine/ImgLine")
    self.mImage_Rank2 = self:GetImage("GrpNor/GrpWeaponIcon/Img_Bg")
    self.mText_Count = self:GetText("GrpNor/GrpLevel/Text_Level")
    self.mTrans_Select = self:GetRectTransform("GrpSel/ImgSel")
    self.mTrans_UseDetail = self:GetRectTransform("Trans_GrpReduce")
    self.mText_SelectCount = self:GetText("Trans_GrpReduce/GrpText/Text_Num")
    self.mTrans_MaxLv = self:GetRectTransform("Trans_GrpLevelLimit")
    self.mTrans_Choose = self:GetRectTransform("Trans_GrpChoose")
    self.mTrans_Lock = self:GetRectTransform("Trans_GrpLock")
    self.mTrans_Equipped = self:GetRectTransform("Trans_Equiped")
    self.mImage_Head = self:GetImage("Trans_Equiped/GrpHead/Img_ChrHead")
    self.mTrans_Received = self:GetRectTransform("Trans_GrpReceived")
    self.mTrans_First = self:GetRectTransform("Trans_GrpFirst")
    self.mTrans_Level = self:GetRectTransform("GrpNor/GrpLevel")
    self.mTrans_Line = self:GetRectTransform("GrpNor/GrpQualityLine")
    self.mTrans_Element = self:GetRectTransform("GrpNor/GrpElement")

    self.elementItem = UICommonElementItem.New()
    self.elementItem:InitCtrl(self.mTrans_Element)
end

function UICommonWeaponInfoItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComWeaponInfoItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
    end
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonWeaponInfoItem:InitObj(obj)
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonWeaponInfoItem:SetSelect(isChoose)
    self.isChoose = isChoose
    setactive(self.mTrans_Choose, self.isChoose)
end

function UICommonWeaponInfoItem:SetByData(data, callback, isChoose)
    self:SetData(data.stcId or data.stc_id, data.level or data.Level, callback)
    self.mData = data
    if isChoose ~= nil then
        self:SetSelect(isChoose)
    else
        self:SetSelect(false)
    end
    if data then
        setactive(self.mTrans_Lock, data.IsLocked)
        setactive(self.mTrans_Equipped, data.gun_id > 0)
        if data.gun_id > 0 then
            local gunData = TableData.listGunDatas:GetDataById(data.gun_id)
            self.mImage_Head.sprite = IconUtils.GetCharacterHeadSprite(IconUtils.cCharacterAvatarType_Avatar, gunData.code)
        end
    end
end

function UICommonWeaponInfoItem:SetData(weaponId, level, callback, hasTip)
    if weaponId then
        self.mData = TableData.listGunWeaponDatas:GetDataById(weaponId)
        local elementData = TableData.listLanguageElementDatas:GetDataById(self.mData.element)
        self.mImage_Icon.sprite = IconUtils.GetWeaponSprite(self.mData.res_code)
        if level then
            self.mText_Count.text = "Lv." .. level
            setactive(self.mText_Count.gameObject, true)
        else
            setactive(self.mText_Count.gameObject, false)
        end

        self.elementItem:SetData(elementData)
        self.mImage_Rank2.sprite = IconUtils.GetWeaponQuiltyByRank(self.mData.rank)
        self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(self.mData.rank)
        setactive(self.mUIRoot, true)

        UIUtils.GetButtonListener(self.mBtn_Select.gameObject).onClick = function()
            if callback then callback(self) end
        end
        if hasTip == true then
            local itemData = TableData.GetItemData(weaponId)
            TipsManager.Add(self:GetRoot().gameObject, itemData)
        end
        self:EnableElement(true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UICommonWeaponInfoItem:SetItem(itemId)
    if itemId then
        self.mData = TableData.listItemDatas:GetDataById(itemId)
        self.mImage_Icon.sprite = IconUtils.GetItemIconSprite(itemId)
        self.mImage_Rank2.sprite = IconUtils.GetWeaponQuiltyByRank(self.mData.rank)
        setactive(self.mTrans_Level, false)
        setactive(self.mTrans_Line, false)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UICommonWeaponInfoItem:SetWeapon(weaponId)
    if weaponId then
        self.mData = TableData.listGunWeaponDatas:GetDataById(weaponId)
        self.mImage_Icon.sprite = IconUtils.GetWeaponSprite(self.mData.res_code)
        self.mImage_Rank2.sprite = IconUtils.GetWeaponQuiltyByRank(self.mData.rank)
        setactive(self.mTrans_Level, false)
        setactive(self.mTrans_Line, false)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UICommonWeaponInfoItem:SetReceived(isReceived)
    setactive(self.mTrans_Received, isReceived)
end

function UICommonWeaponInfoItem:SetFirstDrop(isFirst)
    setactive(self.mTrans_First, isFirst)
end

function UICommonWeaponInfoItem:EnableElement(enable)
    setactive(self.mTrans_Element, enable)
end

function UICommonWeaponInfoItem:EnableButton(enable)
    self.mBtn_Select.interactable = enable
end