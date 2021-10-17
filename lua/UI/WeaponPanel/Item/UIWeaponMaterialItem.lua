require("UI.UIBaseCtrl")

UIWeaponMaterialItem = class("UIWeaponMaterialItem", UIBaseCtrl)
UIWeaponMaterialItem.__index = UIWeaponMaterialItem

function UIWeaponMaterialItem:ctor()
    self.mData = nil
    self.elementItem = nil
end

function UIWeaponMaterialItem:__InitCtrl()
    self.mBtn_Reduce = self:GetButton("Trans_GrpReduce/GrpMinus/ComBtn1ItemV2")
    self.mBtn_Select = self:GetSelfButton()
    self.mImage_Icon = self:GetImage("GrpNor/GrpWeaponIcon/Img_Icon")
    self.mImage_Rank = self:GetImage("GrpNor/GrpQualityLine/ImgLine")
    self.mImage_Rank2 = self:GetImage("GrpNor/GrpWeaponIcon/Img_Bg")
    self.mText_Count = self:GetText("GrpNor/GrpLevel/Text_Level")
    self.mTrans_Select = self:GetRectTransform("GrpSel/ImgSel")
    self.mTrans_UseDetail = self:GetRectTransform("Trans_GrpReduce")
    self.mText_SelectCount = self:GetText("Trans_GrpReduce/GrpText/Text_Num")
    self.mTrans_Choose = self:GetRectTransform("Trans_GrpChoose")
    self.mTrans_Element = self:GetRectTransform("GrpNor/GrpElement")

    self.elementItem = UICommonElementItem.New()
    self.elementItem:InitCtrl(self.mTrans_Element)
end

function UIWeaponMaterialItem:InitCtrl()
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComWeaponInfoItemV2.prefab", self))
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIWeaponMaterialItem:SetData(data, isCanNotSelect)
    if data then
        self.mData = data
        if data.type == UIWeaponGlobal.MaterialType.Item then
            self.mImage_Icon.sprite = IconUtils.GetItemIconSprite(data.id)
            self.mText_Count.text = data.count
            setactive(self.mTrans_Element.gameObject, false)
        elseif data.type == UIWeaponGlobal.MaterialType.Weapon then
            local weaponData = TableData.listGunWeaponDatas:GetDataById(data.stcId)
            local elementData = TableData.listLanguageElementDatas:GetDataById(weaponData.element)
            self.mImage_Icon.sprite = IconUtils.GetWeaponSprite(data.icon)
            self.mText_Count.text = "Lv." .. data.level
            self.elementItem:SetData(elementData)
            setactive(self.mTrans_Element.gameObject, true)
        end
        self.mImage_Rank2.sprite = IconUtils.GetWeaponQuiltyByRank(data.rank)
        self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(data.rank)
        self.mText_SelectCount.text = data.selectCount
        setactive(self.mTrans_Select, data.selectCount > 0)
        setactive(self.mTrans_UseDetail, data.selectCount > 0 and data.type == UIWeaponGlobal.MaterialType.Item)
        setactive(self.mTrans_Choose, data.selectCount > 0 and data.type == UIWeaponGlobal.MaterialType.Weapon)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIWeaponMaterialItem:SetSelect()
    if self.mData.selectCount < self.mData.count then
        self.mData.selectCount = self.mData.selectCount + 1
        if self.mData.type == UIWeaponGlobal.MaterialType.Item then
            self.mText_SelectCount.text = self.mData.selectCount
            setactive(self.mTrans_UseDetail, self.mData.selectCount > 0)
            setactive(self.mTrans_Choose, false)
        end
    else
        if self.mData.type == UIWeaponGlobal.MaterialType.Weapon then
            self.mData.selectCount = self.mData.selectCount - 1
            setactive(self.mTrans_UseDetail, false)
        end
    end
    setactive(self.mTrans_Choose, self.mData.type == UIWeaponGlobal.MaterialType.Weapon and self.mData.selectCount > 0)
    setactive(self.mTrans_Select, self.mData.selectCount > 0)
end

function UIWeaponMaterialItem:OnReduce()
    if self.mData.type == UIWeaponGlobal.MaterialType.Item then
        if self.mData.selectCount > 0 then
            self.mData.selectCount = self.mData.selectCount - 1
        end
        self.mText_SelectCount.text = self.mData.selectCount
        setactive(self.mTrans_Select, self.mData.selectCount > 0)
        setactive(self.mTrans_UseDetail, self.mData.selectCount > 0)
    end
end


function UIWeaponMaterialItem:IsRemoveWeapon()
    return self.mData.type == UIWeaponGlobal.MaterialType.Weapon and self.mData.selectCount > 0
end

function UIWeaponMaterialItem:IsBreakItem(id)
    if self.mData.type == UIWeaponGlobal.MaterialType.Weapon then
        return self.mData.stcId == id
    elseif self.mData.type == UIWeaponGlobal.MaterialType.Item then
        return self.mData.isBreakItem
    end
end
