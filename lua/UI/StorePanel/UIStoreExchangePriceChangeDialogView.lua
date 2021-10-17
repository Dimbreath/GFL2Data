require("UI.UIBaseView")

UIStoreExchangePriceChangeDialogView = class("UIStoreExchangePriceChangeDialogView", UIBaseView);
UIStoreExchangePriceChangeDialogView.__index = UIStoreExchangePriceChangeDialogView

--@@ GF Auto Gen Block Begin


function UIStoreExchangePriceChangeDialogView:__InitCtrl()
    self.mTrans_IconRoot = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpItem") 
    self.mText_Description = self:GetText("Root/GrpDialog/GrpCenter/GrpContent/GrpTextName/Text_Description")
    self.mText_PriceNum1 = self:GetText("Root/GrpDialog/GrpCenter/GrpContent/GrpPriceDetails/GrpPrice1/Text_Num")
    self.mText_PriceNum2 = self:GetText("Root/GrpDialog/GrpCenter/GrpContent/GrpPriceDetails/GrpPrice2/Text_Num")
    self.mImage_PriceIcon1 = self:GetImage("Root/GrpDialog/GrpCenter/GrpContent/GrpPriceDetails/GrpPrice1/GrpItemIcon/Img_Icon")
    self.mImage_PriceIcon2 = self:GetImage("Root/GrpDialog/GrpCenter/GrpContent/GrpPriceDetails/GrpPrice2/GrpItemIcon/Img_Icon")
    self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")

    self.mBtn_Confirm = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnConfirm"))
end

--@@ GF Auto Gen Block End

function UIStoreExchangePriceChangeDialogView:InitCtrl(root)

	self:SetRoot(root);

    self:__InitCtrl();

end