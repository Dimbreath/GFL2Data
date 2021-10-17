require("UI.UIBasePanel")
---@class UICommonBreakSucPanel : UIBasePanel

UICommonBreakSucPanel = class("UICommonBreakSucPanel", UIBasePanel)
UICommonBreakSucPanel.__index = UICommonBreakSucPanel

function UICommonBreakSucPanel:ctor()
    UICommonBreakSucPanel.super.ctor(self)
end

function UICommonBreakSucPanel.Close()
    self = UICommonBreakSucPanel
    UIManager.CloseUI(UIDef.UICommonBreakSucPanel)
end

function UICommonBreakSucPanel.OnRelease()
    self = UICommonBreakSucPanel
end

function UICommonBreakSucPanel.Init(root, data)
    self = UICommonBreakSucPanel

    UICommonBreakSucPanel.super.SetRoot(UICommonBreakSucPanel, root)

    UICommonBreakSucPanel.mView = UICommonBreakSucPanelView.New()
    UICommonBreakSucPanel.mView:InitCtrl(root)

    self.mIsPop = true
end

function UICommonBreakSucPanel.OnInit()
    self = UICommonBreakSucPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UICommonBreakSucPanel.Close()
    end
end

