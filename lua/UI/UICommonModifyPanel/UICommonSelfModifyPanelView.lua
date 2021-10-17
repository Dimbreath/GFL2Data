require("UI.UIBaseView")
---@class UICommonSelfModifyPanelView : UIBaseView

UICommonSelfModifyPanelView = class("UICommonSelfModifyPanelView", UIBaseView)
UICommonSelfModifyPanelView.__index = UICommonSelfModifyPanelView

function UICommonSelfModifyPanelView:ctor()

end

function UICommonSelfModifyPanelView:__InitCtrl()
    self.mBtn_Cancel = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnCancel"))
    self.mBtn_Confirm = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnConfirm"))
    self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_CloseBg = self:GetButton("Root/GrpBg/Btn_Close")

    self.mTrans_TextLimit = self:GetRectTransform("Root/GrpDialog/GrpTextLimit")

    self.mText_Num = self:GetText("Root/GrpDialog/GrpTextLimit/GrpTextLimit/Text_Num")
    self.mText_AllNum =  self:GetText("Root/GrpDialog/GrpTextLimit/GrpTextLimit/Text_NumAll")

    self.mText_InputField = self:GetInputField("Root/GrpDialog/GrpInputField/Btn_InputField")

    self.mImage_CostIcon = self:GetImage("Root/GrpDialog/GrpConsume/GrpGoldIcon/Img_Bg")
    self.mText_CostNum = self:GetText("Root/GrpDialog/GrpConsume/Text_CostNum")
end

function UICommonSelfModifyPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end
