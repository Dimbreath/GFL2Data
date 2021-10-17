require("UI.UIBaseView")
---@class UICommonSignModifyPanelView : UIBaseView

UICommonSignModifyPanelView = class("UICommonSignModifyPanelView", UIBaseView)
UICommonSignModifyPanelView.__index = UICommonSignModifyPanelView

function UICommonSignModifyPanelView:ctor()

end

function UICommonSignModifyPanelView:__InitCtrl()
    self.mBtn_Cancel = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnCancel"))
    self.mBtn_Confirm = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnConfirm"))
    self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_CloseBg = self:GetButton("Root/GrpBg/Btn_Close")

    self.mTrans_TextLimit = self:GetRectTransform("Root/GrpDialog/GrpTextLimit")

    self.mText_Num = self:GetText("Root/GrpDialog/GrpTextLimit/GrpTextLimit/Text_Num")
    self.mText_AllNum =  self:GetText("Root/GrpDialog/GrpTextLimit/GrpTextLimit/Text_NumAll")

    self.mText_InputField = self:GetInputField("Root/GrpDialog/GrpInputField/Btn_InputField")
end

function UICommonSignModifyPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end
