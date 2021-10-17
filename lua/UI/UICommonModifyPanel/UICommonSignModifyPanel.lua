require("UI.UIBasePanel")
---@class UICommonSignModifyPanel : UIBasePanel

UICommonSignModifyPanel = class("UICommonSignModifyPanel", UIBasePanel)
UICommonSignModifyPanel.__index = UICommonSignModifyPanel

UICommonSignModifyPanel.confirmCallback = nil
UICommonSignModifyPanel.maxLength = 0

function UICommonSignModifyPanel:ctor()
    UICommonSignModifyPanel.super.ctor(self)
end

function UICommonSignModifyPanel.Close()
    self = UICommonSignModifyPanel
    UIManager.CloseUI(UIDef.UICommonSignModifyPanel)
end

function UICommonSignModifyPanel.OnRelease()
    self = UICommonSignModifyPanel
end

function UICommonSignModifyPanel.Init(root, data)
    self = UICommonSignModifyPanel

    UICommonSignModifyPanel.super.SetRoot(UICommonSignModifyPanel, root)

    UICommonSignModifyPanel.mView = UICommonSignModifyPanelView.New()
    UICommonSignModifyPanel.mView:InitCtrl(root)

    self.mIsPop = true
    self.confirmCallback = data[1]
    self.defaultStr = data[2]
    self.maxLength = TableData.GlobalSystemData.MottoLimit
end

function UICommonSignModifyPanel.OnInit()
    self = UICommonSignModifyPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UICommonSignModifyPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CloseBg.gameObject).onClick = function()
        UICommonSignModifyPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Cancel.gameObject).onClick = function()
        UICommonSignModifyPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Confirm.gameObject).onClick = function()
        UICommonSignModifyPanel:OnConfirmName()
    end

    setactive(self.mView.mTrans_TextLimit, false)
    self.mView.mText_InputField.text = self.defaultStr
    self.mView.mText_InputField.characterLimit = self.maxLength

    self.mView.mText_InputField.onValueChanged:AddListener(function()
        UICommonSignModifyPanel:OnValueChange()
    end)

    UICommonSignModifyPanel:OnValueChange()
end

function UICommonSignModifyPanel:OnConfirmName()
    local strName = self.mView.mText_InputField.text

    if strName ~= "" then
        if TextData:IsContainForbidWord(strName) then
            UIUtils.PopupHintMessage(60049)
            return
        end
    end

    if self.confirmCallback ~= nil then
        self.confirmCallback(strName)
    end
    self.Close()
end

function UICommonSignModifyPanel:OnValueChange()
    local str = self.mView.mText_InputField.text
    self.mView.mText_Num.text = utf8.len(str)
    self.mView.mText_AllNum.text = "/" .. self.maxLength
    setactive(self.mView.mTrans_TextLimit, #str > 0)
end