require("UI.RepositoryPanel.Content.UIRepositoryBasePanel")
require("UI.Common.UICommonItemL")
---@class UIRepositoryGunCorePanel : UIRepositoryBasePanel
UIRepositoryGunCorePanel = class("UIRepositoryGunCorePanel", UIRepositoryBasePanel)
UIRepositoryGunCorePanel.__index = UIRepositoryGunCorePanel

function UIRepositoryGunCorePanel:ctor(parent, panelId, transRoot)
    UIRepositoryGunCorePanel.super.ctor(self, parent, panelId, transRoot)
    self.itemList = nil
end

function UIRepositoryGunCorePanel:InitItemTypeList()
    local parentRoot = self.parent.mView.mContent_GunCore.transform
    local gunList = TableData.listGunDatas
    for i = 0, gunList.Count - 1 do
        ---@type UIRepositoryListItemV2
        local item = UICommonItem.New()
        local count = NetCmdItemData:GetItemCountById(gunList[i].core_item_id)
        item:InitCtrl(parentRoot)
        item:SetItemData(gunList[i].core_item_id, count)

        table.insert(self.itemList, item)
    end
end

function UIRepositoryGunCorePanel:UpdateItemList()
    if self.itemList == nil then
        self.itemList = {}
        self:InitItemTypeList()
    end
end
