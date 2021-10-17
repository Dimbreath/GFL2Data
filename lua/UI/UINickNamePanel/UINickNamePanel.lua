require("UI.UIBasePanel")

UINickNamePanel = class("UINickNamePanel", UIBasePanel)
UINickNamePanel.__index = UINickNamePanel

UINickNamePanel.SexType =
{
    Male   = 0,
    Female = 1,
}

UINickNamePanel.callback = nil
UINickNamePanel.curSex = -1

function UINickNamePanel:ctor()
    UINickNamePanel.super.ctor(self)
end

function UINickNamePanel.Close()
    self = UINickNamePanel
    UIManager.CloseUIByCallback(UIDef.UINickNamePanel, function ()
        if UINickNamePanel.callback ~= nil then
            UINickNamePanel.callback()
        end
    end)
    
end

function UINickNamePanel.OnRelease()
    self = UINickNamePanel
    UINickNamePanel.curSex = -1
end

function UINickNamePanel.Init(root, data)
    self = UINickNamePanel

    self.mIsPop = true
    self.callback = data

    UINickNamePanel.super.SetRoot(UINickNamePanel, root)

    UINickNamePanel.mView = UINickNamePanelView.New()
    UINickNamePanel.mView:InitCtrl(root)
end

function UINickNamePanel.OnInit()
    self = UINickNamePanel
    

    --self.mView.mInputField.onEndEdit:AddListener(function()
    --    UINickNamePanel:OnEndInput()
    --end)

    UIUtils.GetButtonListener(self.mView.mBtn_Man.gameObject).onClick = function()
        UINickNamePanel:OnClickSex(UINickNamePanel.SexType.Male)
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Woman.gameObject).onClick = function()
        UINickNamePanel:OnClickSex(UINickNamePanel.SexType.Female)
    end


    UIUtils.GetButtonListener(self.mView.mBtn_Confirm.gameObject).onClick = function()
        UINickNamePanel:OnConfirmName()
    end
end

function UINickNamePanel:OnConfirmName()
    local strName = self.mView.mInputField.text
    if strName == "" then
        UIUtils.PopupHintMessage(60048)
        return
    end

    if not UIUtils.CheckInputIsLegal(strName) or TextData:IsContainForbidWord(strName) then
        UIUtils.PopupHintMessage(60049)
        return
    end

    if self.curSex < 0 then
        UIUtils.PopupHintMessage(60059)
        return
    end

    AccountNetCmdHandler:SendInitRoleInfo(strName, self.curSex, function (ret)
        self:OnModNameCallback(ret)
    end)
end

function UINickNamePanel:OnEndInput(str)
    setactive(self.mView.mTrans_Editor, true)
end


function UINickNamePanel:OnClickSex(type)
    if self.curSex == type then
        return
    end
    self.mView.mBtn_Man.interactable = not (type == UINickNamePanel.SexType.Male)
    self.mView.mBtn_Woman.interactable = not (type == UINickNamePanel.SexType.Female)
    self.curSex = type
end

function UINickNamePanel:OnModNameCallback(ret)
    if ret == CS.CMDRet.eSuccess then
        self.Close()
    else
        UIUtils.PopupHintMessage(60049)
    end
end

--function UINickNamePanel.OnUpdate()
--    self = UINickNamePanel
--    if self.mView.mInputField.isFocused then
--        setactive(self.mView.mTrans_Editor, false)
--    end
--end






