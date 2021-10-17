require("UI.UIBasePanel")
---@class UICommonModifyPanel : UIBasePanel

UICommonModifyPanel = class("UICommonModifyPanel", UIBasePanel)
UICommonModifyPanel.__index = UICommonModifyPanel

UICommonModifyPanel.confirmCallback = nil

function UICommonModifyPanel:ctor()
    UICommonModifyPanel.super.ctor(self)
end

function UICommonModifyPanel.Close()
    self = UICommonModifyPanel
    UIManager.CloseUI(UIDef.UICommonModifyPanel)
end

function UICommonModifyPanel.OnRelease()
    self = UICommonModifyPanel
    UICommonModifyPanel.confirmCallback = nil
    UICommonModifyPanel.defaultStr = ""
end

function UICommonModifyPanel.Init(root, data)
    self = UICommonModifyPanel

    self.mIsPop = true
    self.confirmCallback = data[1]
    self.defaultStr = data[2]

    UICommonModifyPanel.super.SetRoot(UICommonModifyPanel, root)

    UICommonModifyPanel.mView = UICommonModifyPanelView.New()
    UICommonModifyPanel.mView:InitCtrl(root)
end

function UICommonModifyPanel.OnInit()
    self = UICommonModifyPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UICommonModifyPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CloseBg.gameObject).onClick = function()
        UICommonModifyPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Cancel.gameObject).onClick = function()
        UICommonModifyPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Confirm.gameObject).onClick = function()
        UICommonModifyPanel:OnConfirmName()
    end

    setactive(self.mView.mTrans_TextLimit, false)
    self.mView.mText_InputField.text = self.defaultStr

    self.mView.mText_InputField.onValueChanged:AddListener(function()
        UICommonModifyPanel:OnValueChange()
    end)

    self:OnValueChange()
end

function UICommonModifyPanel:OnConfirmName()
    local strName = self.mView.mText_InputField.text

    if strName ~= "" then
        if not UIUtils.CheckInputIsLegal(strName) or TextData:IsContainForbidWord(strName) then
            UIUtils.PopupHintMessage(60049)
            return
        end
    end

    if self.confirmCallback ~= nil then
        self.confirmCallback(strName)
    end
    self.Close()
end

function UICommonModifyPanel:OnValueChange()
    local str = self.mView.mText_InputField.text
    self.mView.mText_Num.text = utf8.len(str)
    self.mView.mText_AllNum.text = "/" .. 7
    setactive(self.mView.mTrans_TextLimit, #str > 0)
end