require("UI.RepositoryPanel.Content.UIRepositoryBasePanel")
require("UI.Common.UICommonItemL")
require("UI.Common.UIEquipOverViewItem")
---@class UIRepositoryEquipPanel : UIRepositoryBasePanel
UIRepositoryEquipPanel = class("UIRepositoryEquipPanel", UIRepositoryBasePanel)
UIRepositoryEquipPanel.__index = UIRepositoryEquipPanel

function UIRepositoryEquipPanel:ctor(parent, panelId, transRoot)
    UIRepositoryEquipPanel.super.ctor(self, parent, panelId, transRoot)
    self.virtualList.itemRenderer = function(index, renderData) self:ItemRenderer(index, renderData) end
end

function UIRepositoryEquipPanel:UpdateItemList(setId)
    self.param = setId
    self.itemList = self:GetEquipList(setId)
    UIRepositoryEquipPanel.super.UpdateItemList(self)
end

function UIRepositoryEquipPanel:RefreshItemList()
    self.itemList = self:GetEquipList(self.param)
    UIRepositoryEquipPanel.super.RefreshItemList(self)
end

function UIRepositoryEquipPanel:ItemRenderer(index, renderData)
    local data = self.itemList[index + 1]
    ---@type UICommonItem
    local item = renderData.data
    item:SetEquipByData(data, handler(self, self.OnClickEquipItem))
end

function UIRepositoryEquipPanel:InitFiltrateItemList()
    local tempList = {}
    for _, item in ipairs(self.itemList) do
        if not item.isEquip and not item.isLock then
            table.insert(tempList, item)
        end
    end

    self.itemList = tempList

    UIRepositoryEquipPanel.super.UpdateItemList(self)
end

function UIRepositoryEquipPanel:OnClickEquipItem(item)
    UIManager.OpenUIByParam(UIDef.UIEquipPanel, {item.mData.id, UIEquipGlobal.EquipPanelTab.Info})
end

function UIRepositoryEquipPanel:GetEquipList(setId)
    local list = {}
    local equipList = NetCmdEquipData:GetEquipListBySetId(setId)
    for i = 0, equipList.Count - 1 do
        table.insert(list, equipList[i])
    end
    return list
end
