require("UI.UIBaseView")
---@class UICommonGetGunPanelView : UIBaseView
UICommonGetGunPanelView = class("UICommonGetGunPanelView", UIBaseView)
UICommonGetGunPanelView.__index = UICommonGetGunPanelView

UICommonGetGunPanelView.ShowStarMaxCount = 3

function UICommonGetGunPanelView:ctor()
end

function UICommonGetGunPanelView:__InitCtrl()
    self.mTrans_GunContent = self:GetRectTransform("Root/Trans_GrpChrDisplay")
    self.mTrans_WeaponContent = self:GetRectTransform("Root/Trans_GrpWeaponDisplay")

    self.mItem_GunContent = self:InitGunContent(self.mTrans_GunContent)
    self.mItem_WeaponContent = self:InitWeaponContent(self.mTrans_WeaponContent)
    self.mItem_ExtraGet = self:InitExtraItem(self:GetRectTransform("Root/Trans_GrpExtraGet"))
    self.mTrans_BtnSkip = self:GetRectTransform("Root/Trans_BtnSkip")
    self.mItem_Skip = self:InitSkipContent(self.mTrans_BtnSkip)
    self.animator = self:GetRootAnimator()
    self.bgJump = self.mUIRoot:Find("Root"):GetComponent("JumpToFrame")
    self.chrJump = self.mTrans_GunContent:GetComponent("JumpToFrame")
    self.weaponJump = self.mTrans_WeaponContent:GetComponent("JumpToFrame")
end

function UICommonGetGunPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end

function UICommonGetGunPanelView:InitGunContent(obj)
    local content = {}
    content.starList = {}
    content.gameObject = obj
    content.animator = UIUtils.GetAnimator(obj)
    content.imgQuality = UIUtils.GetImage(obj, "GrpChr/GrpChrAvatar/GrpQualityLine/Img_Line")
    content.imgFlower = UIUtils.GetImage(obj, "GrpChr/GrpChrAvatar/GrpQualityLine/ImgFlower/Img_Flower")
    content.imgLodingIcon = UIUtils.GetImage(obj, "GrpChrLoding/GrpChrIcon/Img_Icon")
    content.imgLodingBg = UIUtils.GetImage(obj, "GrpChrLoding/GrpBg/Img_Bg")
    content.imgIcon1 = UIUtils.GetImage(obj, "GrpBg/GrpChrIconLeft/Img_Icon")
    content.imgIcon2 = UIUtils.GetImage(obj, "GrpBg/GrpChrIconRight/Img_Icon")
    content.imgAvatar = UIUtils.GetImage(obj, "GrpChr/GrpChrAvatar/Img_Avatar")
    content.txtName = UIUtils.GetText(obj, "GrpChr/GrpChrName/GrpChrName/Text_Name")
    content.txtBody = UIUtils.GetText(obj, "GrpBg/GrpChrInfo/GrpInfo1/Text_Name")
    content.txtBrand = UIUtils.GetText(obj, "GrpBg/GrpChrInfo/GrpInfo2/Text_Name")
    content.txtDialog = UIUtils.GetText(obj, "GrpChr/Trans_GrpDialogBox/Panel/Text/Text_Content")
    content.transNew = UIUtils.GetRectTransform(obj, "GrpChr/GrpChrName/Trans_GrpNew")
    content.transStar = UIUtils.GetRectTransform(obj, "GrpChr/GrpStar")
    content.transDuty = UIUtils.GetRectTransform(obj, "GrpChr/GrpChrType/GrpDuty")
    --content.imgType = UIUtils.GetImage(obj, "GrpChr/GrpChrType/GrpGunType/Img_GunTypeIcon")
    content.audio = obj:GetComponent("UIAudioComponent")
    --content.elementItem = UICommonElementItem.New()
    --content.elementItem:InitCtrl(content.transElement)

    local dutyObj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComDutyItemV2.prefab", self))
    content.imgDutyIcon = UIUtils.GetImage(dutyObj, "Img_DutyIcon")
    CS.LuaUIUtils.SetParent(dutyObj, content.transDuty.gameObject, true)

    for i = 1, UICommonGetGunPanelView.ShowStarMaxCount do
        local obj = self:InstanceUIPrefab("Gashapon/GashaponChrWeaponDisplayStarItemV2.prefab", content.transStar, true)
        setactive(obj, false)
        table.insert(content.starList, obj)
    end

    return content
end

function UICommonGetGunPanelView:InitWeaponContent(obj)
    local content = {}
    content.starList = {}
    content.gameObject = obj
    content.animator = UIUtils.GetAnimator(obj)
    content.txtName = UIUtils.GetText(obj, "GrpWeapon/GrpWeaponName/GrpChrName/Text_Name")
    content.transStar = UIUtils.GetRectTransform(obj, "GrpWeapon/GrpStar")
    content.imgAvatar = UIUtils.GetImage(obj, "GrpWeapon/GrpWeaponIcon/Img_WeaponIcon")
    content.imgQuality = UIUtils.GetImage(obj, "GrpWeapon/GrpWeaponIcon/GrpQualityLine/Img_Line")
    content.imgFlower = UIUtils.GetImage(obj, "GrpWeapon/GrpWeaponIcon/GrpQualityLine/ImgFlower/Img_Flower")
    content.imgIcon = UIUtils.GetImage(obj, "GrpBg/GrpWeaponIconRight/Img_Icon")
    content.txtType = UIUtils.GetText(obj, "GrpBg/GrpWeaponTypeLeftTop/Text_WeaponType")
    content.transNew = UIUtils.GetRectTransform(obj, "GrpWeapon/GrpWeaponName/Trans_GrpNew")
    content.transElement = UIUtils.GetRectTransform(obj, "GrpWeapon/GrpElement")
    content.audio = obj:GetComponent("UIAudioComponent")
    local elementObj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComElementItemV2.prefab", self))
    content.imgElementIcon = UIUtils.GetImage(elementObj, "Image_ElementIcon")
    CS.LuaUIUtils.SetParent(elementObj, content.transElement.gameObject, true)

    for i = 1, UICommonGetGunPanelView.ShowStarMaxCount do
        local obj = self:InstanceUIPrefab("Gashapon/GashaponChrWeaponDisplayStarItemV2.prefab", content.transStar, true)
        setactive(obj, false)
        table.insert(content.starList, obj)
    end

    return content
end

function UICommonGetGunPanelView:InitExtraItem(obj)
    local item = {}
    item.gameObject = obj
    item.imgIcon = UIUtils.GetImage(obj, "GrpIcon/Img_Icon")
    item.txtName = UIUtils.GetText(obj, "GrpTextName/Text_Name")
    item.txtNum = UIUtils.GetText(obj, "GrpTextNum/Text_Num")

    return item
end

function UICommonGetGunPanelView:InitSkipContent(parent)
    local content = {}
    local obj = self:InstanceUIPrefab("Gashapon/GashaponSkipPanelV2.prefab", parent, true)
    content.gameObject = obj
    content.btnClose = UIUtils.GetButton(obj, "Btn_BgSkip")
    content.btnSkip = UIUtils.GetButton(obj, "Btn_IconSkip")

    return content
end

