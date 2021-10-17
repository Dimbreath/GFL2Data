require("UI.UIBasePanel")
---@class UICommonGunDisplayPanel : UIBasePanel

UICommonGunDisplayPanel = class("UICommonGunDisplayPanel", UIBasePanel)
UICommonGunDisplayPanel.__index = UICommonGunDisplayPanel

UICommonGunDisplayPanel.gunList = nil
UICommonGunDisplayPanel.itemList = {}

function UICommonGunDisplayPanel:ctor()
    UICommonGunDisplayPanel.super.ctor(self)
end

function UICommonGunDisplayPanel.Close()
    self = UICommonGunDisplayPanel
    UIManager.CloseUI(UIDef.UICommonGunDisplayPanel)
end

function UICommonGunDisplayPanel.OnRelease()
    self = UICommonGunDisplayPanel
    UICommonGunDisplayPanel.gunList = nil
    UICommonGunDisplayPanel.itemList = {}
end

function UICommonGunDisplayPanel.Init(root, data)
    self = UICommonGunDisplayPanel

    UICommonGunDisplayPanel.super.SetRoot(UICommonGunDisplayPanel, root)

    UICommonGunDisplayPanel.mView = UICommonGunDisplayPanelView.New()
    UICommonGunDisplayPanel.mView:InitCtrl(root)

    self.mIsPop = true
    self.gunList = data
end

function UICommonGunDisplayPanel.OnInit()
    self = UICommonGunDisplayPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UICommonGunDisplayPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Close1.gameObject).onClick = function()
        UICommonGunDisplayPanel.Close()
    end

    self:UpdatePanel()
end

function UICommonGunDisplayPanel:UpdatePanel()
    for i = 0, self.gunList.Count - 1 do
        local gunId = self.gunList[i]
        local item = UIBarrackChrCardItem.New()
        item:InitCtrl(self.mView.mTrans_GunList)
        item:SetDisplay(self.gunList[i])

        UIUtils.GetButtonListener(item.mBtn_Gun.gameObject).onClick = function()
            self:OnClickGun(gunId)
        end
    end
end

function UICommonGunDisplayPanel:OnClickGun(id)
    UIUnitInfoPanel.Open(UIUnitInfoPanel.ShowType.GunItem, id)
end