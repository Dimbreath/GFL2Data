require("UI.RepositoryPanel.Content.UIRepositoryBasePanel")
require("UI.Common.UICommonItemL")
---@class UIRepositoryWeaponPanel : UIRepositoryBasePanel
UIRepositoryWeaponPanel = class("UIRepositoryWeaponPanel", UIRepositoryBasePanel)
UIRepositoryWeaponPanel.__index = UIRepositoryWeaponPanel

function UIRepositoryWeaponPanel:ctor(parent, panelId, transRoot)
    ---@type UIRepositoryPanelV2
    self.parent = parent
    self.transRoot = transRoot
    self.panelId = panelId
    self.virtualList = parent.mView.mVirtualList_Weapon
    self.itemList = {}
    self.isSub = false
    self.sortFunc = nil
    self.param = nil
    self.selectItemList = {}

    self.virtualList.itemProvider = function() local item = self:ItemProvider() return item end
end

function UIRepositoryWeaponPanel:UpdateItemList()
    self.itemList = self:GetWeaponList()
    self.virtualList.itemRenderer = function(index, renderData) self:ItemRenderer(index, renderData) end
    UIRepositoryWeaponPanel.super.UpdateItemList(self)
end

function UIRepositoryWeaponPanel:ItemProvider()
    ---@type UICommonWeaponInfoItem
    local itemView = UICommonWeaponInfoItem.New()
    itemView:InitCtrl(self.parent)
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView

    return renderDataItem
end


function UIRepositoryWeaponPanel:RefreshItemList()
    self.itemList = self:GetWeaponList()
    UIRepositoryWeaponPanel.super.RefreshItemList(self)
end

function UIRepositoryWeaponPanel:ItemRenderer(index, renderData)
    local data = self.itemList[index + 1]
    ---@type UICommonWeaponInfoItem
    local item = renderData.data
    item:SetByData(data, handler(self, self.OnClickWeaponItem))
end

function UIRepositoryWeaponPanel:InitFiltrateItemList()
    local tempList = {}
    for _, item in ipairs(self.itemList) do
        if not item.isEquip and not item.isLock then
            table.insert(tempList, item)
        end
    end

    self.itemList = tempList

    UIRepositoryWeaponPanel.super.UpdateItemList(self)
end

function UIRepositoryWeaponPanel:OnClickWeaponItem(item)
    UIManager.OpenUIByParam(UIDef.UIWeaponPanel, {item.mData.id, UIWeaponGlobal.WeaponPanelTab.Info, true})
end

function UIRepositoryWeaponPanel:GetWeaponList()
    local list = {}
    local weaponList = NetCmdWeaponData:GetEnhanceWeaponList(0)
    for i = 0, weaponList.Count - 1 do
        table.insert(list, weaponList[i])
    end

    return list
end
