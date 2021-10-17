require("UI.UIBaseCtrl")

UIEquipMaterialItem = class("UIEquipMaterialItem", UIBaseCtrl)
UIEquipMaterialItem.__index = UIEquipMaterialItem

function UIEquipMaterialItem:ctor()
    self.equipData = nil
    self.instanceId = 0
end

function UIEquipMaterialItem:__InitCtrl()
    self.mBtn_Reduce = self:GetButton("Trans_GrpReduce/GrpMinus/ComBtn1ItemV2")
    self.mBtn_Select = self:GetSelfButton()
    self.mImage_Icon = self:GetImage("GrpItem/Img_Item")
    self.mImage_Rank = self:GetImage("GrpBg/Img_Bg")
    self.mText_Count = self:GetText("Trans_GrpNum/ImgBg/Text_Num")
    self.mTrans_UseDetail = self:GetRectTransform("Trans_GrpReduce")
    self.mTrans_EquipIndex = self:GetRectTransform("Trans_GrpEquipNum")
    self.mImage_EquipIndex = self:GetImage("Trans_GrpEquipNum/Img_Icon")
    self.mText_SelectCount = self:GetText("Trans_GrpReduce/GrpText/Text_Num")
    self.mTrans_Lock = self:GetRectTransform("Trans_GrpLock")
    self.mTrans_Select = self:GetRectTransform("GrpSel")
    self.mTrans_Choose = self:GetRectTransform("Trans_GrpChoose")
    self.mTrans_Equiped = self:GetRectTransform("Trans_Equiped")
    self.mImage_GunIcon = self:GetImage("Trans_Equiped/GrpHead/Img_ChrHead")
end

function UIEquipMaterialItem:InitCtrl()
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab", self))
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIEquipMaterialItem:SetData(data)
    if data then
        self.equipData = data
        setactive(self.mTrans_EquipIndex, data.type == UIEquipGlobal.MaterialType.Equip)
        self.mImage_Rank.sprite = IconUtils.GetQuiltyByRank(data.rank)
        if data.type == UIEquipGlobal.MaterialType.Item then
            self.mImage_Icon.sprite = IconUtils.GetItemIconSprite(data.id)
            self.mText_Count.text = data.count
            setactive(self.mTrans_Lock, false)
        elseif data.type == UIEquipGlobal.MaterialType.Equip then
            self.mImage_Icon.sprite = IconUtils.GetEquipSprite(data.icon .. "_1")
            self.mText_Count.text = "Lv." .. data.level
            self.mImage_EquipIndex.sprite = IconUtils.GetEquipNum(data.category, true)

            if data.gunId ~= 0 then
                local gunData = TableData.listGunDatas:GetDataById(data.gunId)
                self.mImage_GunIcon.sprite = IconUtils.GetCharacterHeadSprite(gunData.code)
            end

            setactive(self.mTrans_Lock, data.isLock)
        end
        self.mText_SelectCount.text = data.selectCount
        setactive(self.mTrans_Equiped, data.gunId ~= 0 and data.type == UIEquipGlobal.MaterialType.Equip)
        setactive(self.mTrans_Select, data.selectCount > 0)
        setactive(self.mTrans_Choose, data.selectCount > 0)
        setactive(self.mTrans_UseDetail, data.selectCount > 0 and data.type == UIEquipGlobal.MaterialType.Item)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIEquipMaterialItem:SetReplaceEquip(data)
    if data then
        self.equipData = data
        setactive(self.mTrans_EquipIndex, data.type == UIEquipGlobal.MaterialType.Equip)
        self.mImage_Rank.sprite = IconUtils.GetQuiltyByRank(data.rank)
        if data.type == UIEquipGlobal.MaterialType.Equip then
            self.mImage_Icon.sprite = IconUtils.GetEquipSprite(data.icon .. "_1")
            self.mText_Count.text = "Lv." .. data.level
            self.mImage_EquipIndex.sprite = IconUtils.GetEquipNum(data.category, true)

            if data.gunId ~= 0 then
                local gunData = TableData.listGunDatas:GetDataById(data.gunId)
                self.mImage_GunIcon.sprite = IconUtils.GetCharacterHeadSprite(gunData.code)
            end

            setactive(self.mTrans_Lock, data.isLock)
        end
        setactive(self.mTrans_Equiped, data.gunId ~= 0 and data.type == UIEquipGlobal.MaterialType.Equip)
        setactive(self.mTrans_Select, data.selectCount > 0)
        setactive(self.mTrans_Choose, false)
        setactive(self.mTrans_UseDetail, false)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIEquipMaterialItem:SetSelect()
    if self.equipData.selectCount < self.equipData.count then
        self.equipData.selectCount = self.equipData.selectCount + 1
        if self.equipData.type == UIEquipGlobal.MaterialType.Item then
            self.mText_SelectCount.text = self.equipData.selectCount
            setactive(self.mTrans_UseDetail, self.equipData.selectCount > 0)
        end
    else
        if self.equipData.type == UIEquipGlobal.MaterialType.Equip then
            self.equipData.selectCount = self.equipData.selectCount - 1
            setactive(self.mTrans_UseDetail, false)
        end
    end
    setactive(self.mTrans_Select, self.equipData.selectCount > 0)
    setactive(self.mTrans_Choose, self.equipData.selectCount > 0)
end

function UIEquipMaterialItem:OnReduce()
    if self.equipData.type == UIEquipGlobal.MaterialType.Item then
        if self.equipData.selectCount > 0 then
            self.equipData.selectCount = self.equipData.selectCount - 1
        end
        self.mText_SelectCount.text = self.equipData.selectCount
        setactive(self.mTrans_UseDetail, self.equipData.selectCount > 0)
        setactive(self.mTrans_Select, self.equipData.selectCount > 0)
        setactive(self.mTrans_Choose, self.equipData.selectCount > 0)
    end
end

function UIEquipMaterialItem:IsRemoveEquip()
    return self.equipData.type == UIEquipGlobal.MaterialType.Equip and self.equipData.selectCount > 0
end

function UIEquipMaterialItem:EnableSelect(enable)
    setactive(self.mTrans_Select, enable)
end