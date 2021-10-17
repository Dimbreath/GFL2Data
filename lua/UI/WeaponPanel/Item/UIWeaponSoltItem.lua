require("UI.UIBaseCtrl")
---@class UIWeaponSlotItem : UIBaseCtrl

UIWeaponSlotItem = class("UIWeaponSlotItem", UIBaseCtrl)
UIWeaponSlotItem.__index = UIWeaponSlotItem

function UIWeaponSlotItem:ctor()
    self.partData = nil
    self.slotId = 0
end

function UIWeaponSlotItem:__InitCtrl()
    self.mBtn_Part = self:GetSelfButton()
    self.mTrans_PartInfo = self:GetRectTransform("Trans_GrpNor")
    self.mTrans_Add = self:GetRectTransform("Trans_GrpAdd")

    self.mTrans_SkillIcon = self:GetRectTransform("Trans_GrpNor/GrpLevel/ImgIcon")
    self.mTrans_Lock = self:GetRectTransform("Trans_GrpLock")
    self.mTrans_MaxLevel = self:GetRectTransform("Trans_PowerUpMax")

    self.mTrans_Select = self:GetRectTransform("GrpSel")
    self.mTrans_Black = self:GetRectTransform("Trans_GrpSelBack")
    self.mImage_Shadow = self:GetImage("Trans_GrpAdd/GrpIcon/Img_Icon")
    self.mImage_Icon = self:GetImage("Trans_GrpNor/GrpWeaponPartsIcon/Img_Icon")
    self.mImage_SkillIcon = self:GetImage("Trans_GrpNor/GrpLevel/ImgIcon/Img_Icon")
    self.mText_Level = self:GetText("Trans_GrpNor/GrpLevel/Text_Level")
    self.mImage_Rank = self:GetImage("Trans_GrpNor/GrpQualityLine/ImgLine")
    self.mImage_Rank2 = self:GetImage("Trans_GrpNor/GrpWeaponPartsIcon/Img_Bg")

    setactive(self.mTrans_Select, false)
end

function UIWeaponSlotItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComWeaponPartsInfoItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIWeaponSlotItem:SetData(partData, slotId)
    if partData == nil and slotId == nil then
        self.partData = nil
        self.slotId = nil
        setactive(self.mUIRoot, false)
        return
    end
    self.partData = partData
    self.slotId = slotId
    if self.partData == nil then
        local slotData = TableData.listWeaponSlotTypeDatas:GetDataById(slotId)
        self.mImage_Shadow.sprite = IconUtils.GetWeaponPartIcon(slotData.slot_base)
        setactive(self.mTrans_Lock, false)
    else
        self:UpdatePartInfo()
    end
    setactive(self.mTrans_PartInfo, self.partData ~= nil)
    setactive(self.mTrans_Add, self.partData == nil)
    setactive(self.mUIRoot, true)
end

function UIWeaponSlotItem:UpdatePartInfo()
    self.mImage_Icon.sprite = IconUtils.GetWeaponPartIcon(self.partData.icon.. "_S")
    self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(self.partData.rank)
    self.mImage_Rank2.sprite = IconUtils.GetWeaponQuiltyByRank(self.partData.rank)
    if self.partData.affixSkill then
        self.mImage_SkillIcon.sprite = IconUtils.GetSkillIconSprite(self.partData.affixSkill.icon)
        self.mText_Level.text = GlobalConfig.LVText .. self.partData.affixLevel
        setactive(self.mTrans_SkillIcon, true)
    else
        setactive(self.mTrans_SkillIcon, false)
        self.mText_Level.text = TableData.GetHintById(40025)
    end
    setactive(self.mTrans_Lock, self.partData.IsLocked)
    setactive(self.mTrans_MaxLevel, self.partData.isCanCalibration and not self.partData.isCanLevelUp)

end

function UIWeaponSlotItem:SetItemSelect(isSelect)
    self.mBtn_Part.interactable = not isSelect
    setactive(self.mTrans_Select, isSelect)
end


