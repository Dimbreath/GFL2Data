require("UI.UIBaseView")

UIGachaShoppingDetailPanelView=class("UIGachaShoppingDetailPanel",UIBaseView)
UIGachaShoppingDetailPanelView.__index=UIGachaShoppingDetailPanelView

function UIGachaShoppingDetailPanelView:ctor()

end

function UIGachaShoppingDetailPanelView:__InitCtrl()
    self.GrpOrderDetails=self:GetScrollRect("Root/GrpDialog/GrpRight/Trans_GrpOrderDetails")

    self.mTrans_GrpOrderDetails=self:GetRectTransform("Root/GrpDialog/GrpRight/Trans_GrpOrderDetails")
    self.mTrans_GrpOdds=self:GetRectTransform("Root/GrpDialog/GrpRight/Trans_GrpOdds")
    self.mTrans_GrpOrderDetailsContent=self:GetRectTransform("Root/GrpDialog/GrpRight/Trans_GrpOrderDetails/Viewport/Content")

    self.mTrans_GrpOddsUp=self:GetRectTransform("Root/GrpDialog/GrpRight/Trans_GrpOdds/Viewport/Content/Trans_GrpOddsUp")
    self.mTrans_UpGrpChr=self:GetRectTransform("Root/GrpDialog/GrpRight/Trans_GrpOdds/Viewport/Content/Trans_GrpOddsUp/Trans_GrpChr")
    self.mTrans_GrpChrContent=self:GetRectTransform("Root/GrpDialog/GrpRight/Trans_GrpOdds/Viewport/Content/Trans_GrpOddsUp/Trans_GrpChr/Content")
    self.mTrans_UpGrpWeapon=self:GetRectTransform("Root/GrpDialog/GrpRight/Trans_GrpOdds/Viewport/Content/Trans_GrpOddsUp/Trans_GrpWeapon")
    self.mTrans_GrpWeaponContent=self:GetRectTransform("Root/GrpDialog/GrpRight/Trans_GrpOdds/Viewport/Content/Trans_GrpOddsUp/Trans_GrpWeapon/Content")

    self.mTrans_OddsPublicity=self:GetRectTransform("Root/GrpDialog/GrpRight/Trans_GrpOdds/Viewport/Content/Trans_OddsPublicity")
    self.mTrans_PublicityGrpChr=self:GetRectTransform("Root/GrpDialog/GrpRight/Trans_GrpOdds/Viewport/Content/Trans_OddsPublicity/Trans_GrpChr")
    self.mTrans_PublicityGrpWeapon=self:GetRectTransform("Root/GrpDialog/GrpRight/Trans_GrpOdds/Viewport/Content/Trans_OddsPublicity/Trans_GrpWeapon")
    self.GrpOdds=self:GetScrollRect("Root/GrpDialog/GrpRight/Trans_GrpOdds")


    self.mLeftTabList=self:GetRectTransform("Root/GrpDialog/GrpLeft/GrpLeftTabList/Viewport/Content")
    self.Text_Details=self:GetText("Root/GrpDialog/GrpRight/Trans_GrpOdds/Viewport/Content/Trans_GrpOddsUp/GrpTextTittle/Text_Details")
    self.mText_topTitle=self:GetText("Root/GrpDialog/GrpTop/GrpText/Text_Tittle")
    self.mText_Description=self:GetText("Root/GrpDialog/GrpRight/Trans_GrpOrderDetails/Viewport/Content/Text_Description")
    self.mBtn_Close=self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")

end

function UIGachaShoppingDetailPanelView:InitCtrl(root)
    self:SetRoot(root);
    self:__InitCtrl();
end