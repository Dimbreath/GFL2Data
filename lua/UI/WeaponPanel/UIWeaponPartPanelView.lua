require("UI.UIBaseView")
---@class UIWeaponPartPanelView : UIBaseView

UIWeaponPartPanelView = class("UIWeaponPartPanelView", UIBaseView)
UIWeaponPartPanelView.__index = UIWeaponPartPanelView

function UIWeaponPartPanelView:ctor()

end

function UIWeaponPartPanelView:__InitCtrl()
    self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("GrpTop/BtnBack"))
    self.mBtn_CommandCenter = UIUtils.GetTempBtn(self:GetRectTransform("GrpTop/BtnHome"))
    self.mBtn_LevelUp = UIUtils.GetTempBtn(self:GetRectTransform("GrpRight/Trans_GrpPowerUp/GrpAction/Trans_BtnPowerUp"))

    self.mTrans_TabList = self:GetRectTransform("GrpLeft/GrpDetailsList/Content")

    self.mTrans_Detail = self:GetRectTransform("GrpRight/Trans_GrpDetails")
    self.mTrans_Enhance = self:GetRectTransform("GrpRight/Trans_GrpPowerUp")

    self.mTrans_PartInfo = self:GetRectTransform("GrpRight/Trans_GrpDetails/GrpWeaponPartsInfo")
    self.mTrans_EnhaceInfo = self:GetRectTransform("GrpRight/Trans_GrpPowerUp/GrpWeaponPartsInfo")

    self.mText_EquipWeapon = self:GetText("GrpRight/Trans_GrpDetails/GrpTextInfo/Text_Name")
    self.mImage_Icon = self:GetImage("GrpWeaponPartsIcon/Img_WeaponPartsIcon")
    self.mTrans_CostContent = self:GetRectTransform("GrpRight/Trans_GrpPowerUp/Trans_GrpConsume")
    self.mTrans_CostItem = self:GetRectTransform("GrpRight/Trans_GrpPowerUp/Trans_GrpConsume/GrpItem")

    self.mTrans_Weapon = self:GetRectTransform("Trans_GrpEquiped")
    self.mTrans_LevelUp = self:GetRectTransform("GrpRight/Trans_GrpPowerUp/GrpAction/Trans_BtnPowerUp")
    self.mTrans_MaxLevel = self:GetRectTransform("GrpRight/Trans_GrpPowerUp/GrpAction/Trans_TextMax")
end

function UIWeaponPartPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end
