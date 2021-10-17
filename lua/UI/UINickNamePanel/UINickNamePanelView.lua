 require("UI.UIBaseView")

UINickNamePanelView = class("UINickNamePanelView", UIBaseView)
UINickNamePanelView.__index = UINickNamePanelView

function UINickNamePanelView:ctor()

end

function UINickNamePanelView:__InitCtrl()
    self.mInputField = self:GetInputField("Root/GrpName/GrpInputField")
    self.mTrans_Editor = self:GetRectTransform("Root/GrpName/GrpInputField/Placeholder")
    self.mBtn_Confirm = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpAction/BtnConfirm"))
    self.mBtn_Man = self:GetButton("Root/GrpGender/BtnGenderSel/Btn_Man")
    self.mBtn_Woman = self:GetButton("Root/GrpGender/BtnGenderSel/Btn_Woman")
end

function UINickNamePanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end

