require("UI.UIBasePanel")
---@class UICommonUnlockPanel : UIBasePanel
UICommonUnlockPanel = class("UICommonUnlockPanel", UIBasePanel)
UICommonUnlockPanel.__index = UICommonUnlockPanel

UICommonUnlockPanel.callback = nil

--- static func ---
function UICommonUnlockPanel.Open(data, callback)
    if data.interface_id ~= UIDef.UICommandCenterPanel then
        GuideManager:PauseGuide()
    end
    UICommandCenterPanel.isUnlockShowing = true;
    local param = {}
    param[1] = data;
    if callback ~= nil then
        param[2] = callback;
    end
    UIManager.OpenUIByParam(UIDef.UICommonUnlockPanel, param)
end
--- static func ---

function UICommonUnlockPanel:ctor()
    UICommonUnlockPanel.super.ctor(self)
end

function UICommonUnlockPanel.Close()
    self = UICommonUnlockPanel
    if not self:StopAnimator() then
        UIManager.CloseUI(UIDef.UICommonUnlockPanel)
        UICommandCenterPanel.isUnlockShowing = false;
        if not AccountNetCmdHandler:ContainsUnlockId(self.data.interface_id) and self.data.interface_id ~= UIDef.UICommandCenterPanel then
            gfdebug("AccountNetCmdHandler's temporary list contains NONE of the unlock ids of this interface !!")
            GuideManager:UnPauseGuide()
            if self.callback then
                self.callback()
            end
        else
            if self.callback then
                self.callback()
            end
            gfdebug("AccountNetCmdHandler's temporary list contains unlock ids of this interface !!")
        end
    end
end

function UICommonUnlockPanel.OnRelease()
    self = UICommonUnlockPanel
end


function UICommonUnlockPanel.OnShow()
    self = UICommonUnlockPanel;
    local canvasGroup = self.mUIRoot:Find("Root"):GetComponent("CanvasGroup")
    canvasGroup.blocksRaycasts = true;

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        AccountNetCmdHandler:SendReqSystemUnlocks(UICommonUnlockPanel.data.id, function()
            UICommonUnlockPanel.Close()
        end)
    end
end

function UICommonUnlockPanel.Init(root, data)
    self = UICommonUnlockPanel

    self.mIsPop = true
    AccountNetCmdHandler.IsLevelUpdate = false

    UICommonUnlockPanel.super.SetRoot(UICommonUnlockPanel, root)

    UICommonUnlockPanel.mView = UICommonUnlockPanelView.New()
    UICommonUnlockPanel.mView:InitCtrl(root)

    if data then
        self.data = data[1]
        self.callback = data[2]
    end
end

function UICommonUnlockPanel.OnInit()
    self = UICommonUnlockPanel

    UICommonUnlockPanel.super.SetPosZ(UICommonUnlockPanel)

    self:UpdatePanel()
end

function UICommonUnlockPanel:UpdatePanel()
    self.mView.mImg_Icon.sprite = IconUtils.GetUnlockIcon(self.data.icon)
    self.mView.mText_Tittle.text = self.data.unlock_name.str
    self.mView.mText_Unlock.text = TableData.GetHintById(901024)
    self.mView.mText_Next.text = TableData.GetHintById(901025)
end

function UICommonUnlockPanel:StopAnimator()
    if self.mView.mAnimator then
        local animationState = self.mView.mAnimator:GetCurrentAnimatorStateInfo(0)
        if animationState:IsName("NewFunctionUnlock") and animationState.normalizedTime < 1 then
            self.mView.mAnimator:Play("NewFunctionUnlock", 0, 1)
            return true
        end
    end
    return false
end



