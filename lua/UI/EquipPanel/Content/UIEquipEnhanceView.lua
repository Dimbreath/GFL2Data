require("UI.UIBaseView")

UIEquipEnhanceView = class("UIEquipEnhanceView", UIBaseView)
UIEquipEnhanceView.__index = UIEquipEnhanceView

function UIEquipEnhanceView:ctor()
    UIEquipEnhanceView.super.ctor(self)
    self.addBtnList = {}
end

function UIEquipEnhanceView:__InitCtrl()
    self.mTrans_EquipListPanel = UIEquipPanelView.mTrans_EquipListPanel

    self.mBtn_LevelUp = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/BtnPowerUp"))
    self.mText_EquipName = self:GetText("GrpWeaponInfo/Text_Name")
    self.mImage_Pos = self:GetImage("GrpEquipPosition/Img_Icon")
    self.mText_Level = self:GetText("GrpWeaponLevel/GrpTextLevel/GrpTextLevel/Text_LevelNow")
    self.mText_Exp = self:GetText("GrpWeaponLevel/GrpTextLevel/GrpTextExp/Text_Exp")
    self.mText_AddExp = self:GetText("GrpWeaponLevel/GrpTextLevel/GrpTextAdd/Text_Add")
    self.mImage_ExpAfter = self:GetImage("GrpWeaponLevel/GrpProgressBar/Img_ProgressBarAfter")
    self.mImage_ExpBefore = self:GetImage("GrpWeaponLevel/GrpProgressBar/Img_ProgressBarBefore")
    self.mTrans_PropList = self:GetRectTransform("GrpAttributeList/GrpAttribute")

    self.mTrans_MainPropAdd = self:GetRectTransform("GrpAttributeList/GrpAttribute/AttributeUpMain/Trans_GrpNumRight")
    self.mText_MainPropName = self:GetText("GrpAttributeList/GrpAttribute/AttributeUpMain/GrpList/Text_Name")
    self.mText_MainPropValue = self:GetText("GrpAttributeList/GrpAttribute/AttributeUpMain/Text_Num")
    self.mText_MainPropNow = self:GetText("GrpAttributeList/GrpAttribute/AttributeUpMain/Trans_GrpNumRight/Text_NumNow")
    self.mText_MainPropAfter = self:GetText("GrpAttributeList/GrpAttribute/AttributeUpMain/Trans_GrpNumRight/Text_NumAfter")

    self.mTrans_BtnLevelUp = self:GetRectTransform("GrpAction/BtnPowerUp")
    self.mTrans_MaxLevel = self:GetRectTransform("GrpAction/Trans_MaxLevel")
    self.mTrans_CostHint = self:GetRectTransform("GrpTextConsume")
    self.mTrans_CostItemList = self:GetRectTransform("GrpItemConsume")
    self.mTrans_CostCoin = self:GetRectTransform("GrpGoldConsume")
    self.mTrans_MaterialList = self:GetRectTransform("GrpItemConsume/Trans_GrpItemWeapon/Content")
    self.mText_CostCoin = self:GetText("GrpGoldConsume/Text_Num")

    for i = 1, UIEquipGlobal.MaxMaterialCount do
        local obj = self:GetRectTransform("GrpItemConsume/GrpItemAdd/Content/ComItemAddItemV2" .. i)
        table.insert(self.addBtnList, obj)
    end
end

function UIEquipEnhanceView:InitEquipList(obj)
    if obj then
        CS.LuaUIUtils.SetParent(obj, self.mTrans_EquipListPanel.gameObject, true)
        self.mBtn_CloseList = UIUtils.GetTempBtn(UIUtils.GetRectTransform(obj, "Root/GrpLeft/GrpClose/BtnBack"))
        self.mTrans_EquipScroll = UIUtils.GetRectTransform(obj, "Root/GrpLeft/GrpWeaponList")
        self.mBtn_AutoSelect =  UIUtils.GetTempBtn(UIUtils.GetRectTransform(obj, "Root/GrpLeft/GrpAction/BtnSelect"))
        self.mTrans_ItemBrief =  UIUtils.GetRectTransform(obj,"Root/GrpLeft/Trans_GrpEquipDetails")
        self.mTrans_EquipListEmpty = UIUtils.GetRectTransform(obj, "Root/GrpLeft/GrpWeaponList/Viewport/Trans_GrpEmpty")

        self.mTrans_Sort = UIUtils.GetRectTransform(obj, "Root/GrpLeft/GrpAction/GrpScreen/BtnScreen")
        self.mTrans_SortList = UIUtils.GetRectTransform(obj, "Root/GrpLeft/GrpAction/GrpScreen/Trans_GrpScreenList")

        self.mAniTime = UIUtils.GetRectTransform(obj, "Root"):GetComponent("AniTime")
        self.mAnimator = UIUtils.GetRectTransform(obj, "Root"):GetComponent("Animator")

        self.mVirtualList = UIUtils.GetVirtualList(self.mTrans_EquipScroll)
    end
end

function UIEquipEnhanceView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end


