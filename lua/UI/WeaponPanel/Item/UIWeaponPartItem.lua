require("UI.UIBaseCtrl")
---@class UIWeaponPartItem : UIBaseCtrl
UIWeaponPartItem = class("UIWeaponPartItem", UIBaseCtrl)
UIWeaponPartItem.__index = UIWeaponPartItem

function UIWeaponPartItem:ctor()
    self.partData = nil
end

function UIWeaponPartItem:__InitCtrl()
    self.mBtn_Part = self:GetSelfButton()
    self.mTrans_PartInfo = self:GetRectTransform("Trans_GrpNor")
    self.mTrans_Add = self:GetRectTransform("Trans_GrpAdd")

    self.mTrans_SkillIcon = self:GetRectTransform("Trans_GrpNor/GrpLevel/ImgIcon")
    self.mTrans_Lock = self:GetRectTransform("Trans_GrpLock")
    self.mTrans_Equiped = self:GetRectTransform("Trans_Equiped")
    self.mTrans_MaxLevel = self:GetRectTransform("Trans_PowerUpMax")
    self.mTrans_Received = self:GetRectTransform("Trans_GrpReceived")
    self.mTrans_QualityLine = self:GetRectTransform("Trans_GrpNor/GrpQualityLine")
    self.mTrans_Level = self:GetRectTransform("Trans_GrpNor/GrpLevel")

    self.mTrans_Select = self:GetRectTransform("GrpSel")
    self.mTrans_Black = self:GetRectTransform("Trans_GrpSelBack")
    self.mImage_Shadow = self:GetImage("Trans_GrpAdd/GrpIcon/Img_Icon")
    self.mImage_Icon = self:GetImage("Trans_GrpNor/GrpWeaponPartsIcon/Img_Icon")
    self.mImage_SkillIcon = self:GetImage("Trans_GrpNor/GrpLevel/ImgIcon/Img_Icon")
    self.mText_Level = self:GetText("Trans_GrpNor/GrpLevel/Text_Level")
    self.mImage_Rank = self:GetImage("Trans_GrpNor/GrpQualityLine/ImgLine")
    self.mImage_Rank2 = self:GetImage("Trans_GrpNor/GrpWeaponPartsIcon/Img_Bg")
end

function UIWeaponPartItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComWeaponPartsInfoItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIWeaponPartItem:InitObj(obj)
    if obj then
        self:SetRoot(obj.transform)
        self:__InitCtrl()
    end
end

function UIWeaponPartItem:SetData(partData)
    if partData == nil then
        setactive(self.mUIRoot, false)
        return
    end
    self.partData = partData
    self:UpdatePartInfo()
    setactive(self.mTrans_Select, partData.isSelect)
    setactive(self.mTrans_PartInfo, true)
    setactive(self.mTrans_Add, false)
    setactive(self.mUIRoot, true)
end

function UIWeaponPartItem:SetReceiveData(partData)
    if partData == nil then
        setactive(self.mUIRoot, false)
        return
    end
    self.partData = partData
    self:UpdateReceivePartInfo()
    --setactive(self.mTrans_Select, partData.isSelect)
    setactive(self.mTrans_PartInfo, true)
    setactive(self.mTrans_Add, false)
    setactive(self.mUIRoot, true)

    local itemData  = TableData.GetWeaponPartItemData(partData.stcId);
	TipsManager.Add(self.mUIRoot.gameObject, itemData)
end

function UIWeaponPartItem:SetDisplay(partData)
    if partData == nil then
        setactive(self.mUIRoot, false)
        return
    end
    self.partData = partData
    self:UpdateDisplayInfo()
    setactive(self.mTrans_PartInfo, true)
    setactive(self.mTrans_Add, false)
    setactive(self.mUIRoot, true)
end

function UIWeaponPartItem:UpdateDisplayInfo()
    self.mImage_Icon.sprite = IconUtils.GetWeaponPartIcon(self.partData.icon .. "_S")
    self.mImage_Rank2.sprite = IconUtils.GetWeaponQuiltyByRank(self.partData.rank)
    setactive(self.mTrans_Level, false)
    self:SetQualityLine(false)
end

function UIWeaponPartItem:UpdatePartInfo()
    self.mImage_Icon.sprite = IconUtils.GetWeaponPartIcon(self.partData.icon .. "_S")
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
        self.mBtn_Part.interactable = not self.partData.isSelect
        setactive(self.mTrans_Lock, self.partData.isLock)
        setactive(self.mTrans_Equiped, self.partData.weaponId > 0)
        setactive(self.mTrans_MaxLevel, self.partData.isCanCalibration and self.partData.isMaxLv)
end

function UIWeaponPartItem:UpdateReceivePartInfo()
    self.mImage_Icon.sprite = IconUtils.GetWeaponPartIcon(self.partData.icon .. "_S")
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
end

function UIWeaponPartItem:SetItemSelect(isSelect)
    self.mBtn_Part.interactable = not isSelect
    setactive(self.mTrans_Select, isSelect)
end

function UIWeaponPartItem:SetNowEquip(isEquip)
    setactive(self.mTrans_Black, isEquip)
end

function UIWeaponPartItem:SetReceived(isReceived)
    setactive(self.mTrans_Received, isReceived)
end

function UIWeaponPartItem:SetLevel(isOn)
    setactive(self.mTrans_Level, isOn)
end

function UIWeaponPartItem:SetQualityLine(isOn)
    setactive(self.mTrans_QualityLine, isOn)
end

function UIWeaponPartItem:EnableButton(enable)
    self.mBtn_Part.interactable = enable
end
