require("UI.UIBasePanel")
require("UI.FriendPanel.UIPlayerInfoPanelView")

UIPlayerInfoPanel = class("UIPlayerInfoPanel", UIBasePanel)
UIPlayerInfoPanel.__index = UIPlayerInfoPanel

UIPlayerInfoPanel.mView = nil
UIPlayerInfoPanel.playerInfoItem = nil
UIPlayerInfoPanel.playerInfo = nil

function UIPlayerInfoPanel:ctor()
    UIPlayerInfoPanel.super.ctor(self)
end

function UIPlayerInfoPanel.Open()
    UIManager.OpenUI(UIDef.UIPlayerInfoPanel)
end

function UIPlayerInfoPanel.OpenByParam(param)
    UIManager.OpenUIByParam(UIDef.UIPlayerInfoPanel, param)
end

function UIPlayerInfoPanel.Close()
    UIManager.CloseUI(UIDef.UIPlayerInfoPanel)
end

function UIPlayerInfoPanel.Init(root, data)
    self = UIPlayerInfoPanel
    UIPlayerInfoPanel.super.SetRoot(UIPlayerInfoPanel, root)
    if data == nil then
        return
    end
    self.mIsPop = true
    self.playerInfo = data

    self.mView = UIPlayerInfoPanelView.New()
    self.mView:InitCtrl(root)

    if self.playerInfoItem == nil then
        self.playerInfoItem = UIFriendInfoItem.New()
        self.playerInfoItem:InitCtrl(self.mView.mTrans_Dialog, function ()
            UIPlayerInfoPanel.Close()
        end)
    end
end

function UIPlayerInfoPanel.OnInit()
    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UIPlayerInfoPanel.Close()
    end

    UIUtils.GetButtonListener(self.playerInfoItem.mBtn_Close.gameObject).onClick = function()
        UIPlayerInfoPanel.Close()
    end
    
    self:UpdatePanel()
end

function UIPlayerInfoPanel:UpdatePanel()
    if self.playerInfoItem ~= nil then
        self.playerInfoItem:SetData(self.playerInfo)
    end
end


function UIPlayerInfoPanel.OnRelease()
    self = UIPlayerInfoPanel
    UIPlayerInfoPanel.playerInfoItem = nil
    UIPlayerInfoPanel.playerInfo = nil
end