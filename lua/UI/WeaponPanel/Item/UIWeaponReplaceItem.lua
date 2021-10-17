require("UI.UIBaseCtrl")

UIWeaponReplaceItem = class("UIWeaponReplaceItem", UIBaseCtrl);
UIWeaponReplaceItem.__index = UIWeaponReplaceItem
function UIWeaponReplaceItem:ctor()
    UIWeaponReplaceItem.super.ctor(self)
    self.starList = {}
    self.slotList = {}
    self.rankColorList = {}
    self.weaponData = nil
    self.cmdData = nil
    self.elementItem = nil
end

function UIWeaponReplaceItem:__InitCtrl()
    self.mBtn_Weapon = self:GetSelfButton()
    self.mTrans_NowEquip = self:GetRectTransform("GrpSelBlack")
    self.mTrans_Element = self:GetRectTransform("GrpNor/GrpElement")
    self.mImage_WeaponIcon = self:GetImage("GrpNor/GrpWeaponIcon/Img_WeaponIcon")
    self.mTrans_Equipped = self:GetRectTransform("GrpNor/Trans_GrpHead")
    self.mImage_GunIcon = self:GetImage("GrpNor/Trans_GrpHead/GrpHead/Img_ChrHead")
    self.mTrans_Lock = self:GetRectTransform("GrpNor/Trans_GrpLock")
    self.mText_WeaponLv = self:GetText("GrpNor/GrpTextLevel/Text_Level")
    self.mImage_RankColor1 = self:GetImage("GrpNor/GrpQualityCor/GrpBottomLine/Img_BottomLine")
    self.mImage_RankColor2 = self:GetImage("GrpNor/GrpQualityCor/GrpRightLine/Img_RightLine")
    self.mImage_RankColor3 = self:GetImage("GrpNor/GrpQualityCor/GrpRightLine/Img_RightLine")
    self.mTrans_Select = self:GetRectTransform("GrpNor/GrpSel")

    for i = 1, UIWeaponGlobal.MaxStar do
        local obj = self:GetRectTransform("GrpNor/GrpStage/GrpStage" .. i)
        local item = self:InitUpgrade(obj)
        table.insert(self.starList, item)
    end

    for i = 1, UIWeaponGlobal.WeaponMaxSlot do
        local obj = self:GetRectTransform("GrpNor/Trans_GrpWeaponParts/GrpPosition" .. i)
        local item = self:InitSlot(obj)
        table.insert(self.slotList, item)
    end

    self.elementItem = UICommonElementItem.New()
    self.elementItem:InitCtrl(self.mTrans_Element)

    self.rankColorList = {self.mImage_RankColor1, self.mImage_RankColor2}
end

function UIWeaponReplaceItem:InitUpgrade(obj)
    if obj then
        local item = {}
        item.obj = obj

        item.transOn = UIUtils.GetRectTransform(obj, "Trans_On")
        item.transOff = UIUtils.GetRectTransform(obj, "Trans_Off")

        return item
    end
end

function UIWeaponReplaceItem:InitSlot(obj)
    if obj then
        local item = {}
        item.obj = obj

        item.imgOn = UIUtils.GetImage(obj, "Trans_On")
        item.transOff = UIUtils.GetRectTransform(obj, "ImgOff")

        return item
    end
end

function UIWeaponReplaceItem:InitCtrl()
    local obj = instantiate(UIUtils.GetGizmosPrefab("Character/ChrBarrackWeaponListItemV2.prefab",self))
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIWeaponReplaceItem:SetData(data)
    if data then
        self.weaponData = data
        self.cmdData = NetCmdWeaponData:GetWeaponById(data.id)
        local elementData = TableData.listLanguageElementDatas:GetDataById(data.element)
        self.mText_WeaponLv.text = "Lv." .. data.level
        self.mImage_WeaponIcon.sprite = IconUtils.GetWeaponNormalSprite(data.stcData.res_code)
        if data.gunId ~= 0 then
            local gunData = TableData.listGunDatas:GetDataById(data.gunId)
            self.mImage_GunIcon.sprite = IconUtils.GetCharacterHeadSprite(gunData.code)
        end

        setactive(self.mTrans_Select, data.isSelect)
        -- self.mBtn_Weapon.interactable = not data.isSelect
        self.elementItem:SetData(elementData)
        self:UpdateRankColor()
        self:UpdateStar(data.breakTimes)
        self:UpdateSlot()
        setactive(self.mTrans_Equipped, data.gunId ~= 0)
        setactive(self.mTrans_Lock, data.isLock)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIWeaponReplaceItem:UpdateStar(star)
    for i, item in ipairs(self.starList) do
        setactive(item.transOn, i <= star)
        setactive(item.transOff, i > star)
    end
end

function UIWeaponReplaceItem:UpdateSlot()
    for i, part in ipairs(self.slotList) do
        setactive(part.obj, false)
    end

    local slotList = self.cmdData.slotList
    for i = 0, slotList.Count - 1 do
        local item = self.slotList[i + 1]
        local data = self.cmdData:GetWeaponPartByIndex(slotList[i])
        if data then
            item.imgOn.color = TableData.GetGlobalGun_Quality_Color2(data.rank)
            setactive(item.imgOn.gameObject, true)
        else
            setactive(item.imgOn.gameObject, false)
        end

        setactive(item.obj, true)
    end
end

function UIWeaponReplaceItem:UpdateRankColor()
    for _, rank in ipairs(self.rankColorList) do
        rank.color = TableData.GetGlobalGun_Quality_Color2(self.weaponData.rank)
    end
end

function UIWeaponReplaceItem:SetSelect(isSelect)
    setactive(self.mTrans_Select, self.weaponData.isSelect)
    -- self.mBtn_Weapon.interactable = not self.weaponData.isSelect
end

function UIWeaponReplaceItem:SetNowEquip(isEquip)
    setactive(self.mTrans_NowEquip, isEquip)
end