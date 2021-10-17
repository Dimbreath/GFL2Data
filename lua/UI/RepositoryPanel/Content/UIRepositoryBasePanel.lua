require("UI.Common.UICommonItemL")
---@class UIRepositoryBasePanel
UIRepositoryBasePanel = class("UIRepositoryBasePanel")
UIRepositoryBasePanel.__index = UIRepositoryBasePanel

function UIRepositoryBasePanel:ctor(parent, panelId, transRoot)
    ---@type UIRepositoryPanelV2
    self.parent = parent
    self.transRoot = transRoot
    self.panelId = panelId
    self.virtualList = parent.mView.mVirtualList_EquipAll
    self.itemList = {}
    self.isSub = false
    self.sortFunc = nil
    self.param = nil
    self.selectItemList = {}

    self.virtualList.itemProvider = function() local item = self:ItemProvider() return item end
end

function UIRepositoryBasePanel:Show()
    if self.transRoot then
        setactive(self.transRoot, true)
        CS.UITweenManager.CanvasGroupDoFade(self.transRoot)
    end
end

function UIRepositoryBasePanel:Close()
    if self.transRoot then
        setactive(self.transRoot, false)
    end
end

function UIRepositoryBasePanel:UpdatePanelByType(type, param)
    if self.parent then
        self.parent:UpdatePanelByType(type, param)
    end
end

function UIRepositoryBasePanel:UpdateItemList()
    self.virtualList.numItems = #self.itemList
    self.virtualList:Refresh()
end

function UIRepositoryBasePanel:RefreshItemList()
    if self.sortFunc then
        table.sort(self.itemList, self.sortFunc)
    end
    self.virtualList.numItems = #self.itemList
    self.virtualList:Refresh()
end

function UIRepositoryBasePanel:ItemProvider()
    ---@type UICommonItem
    local itemView = UICommonItem.New()
    itemView:InitCtrl(self.parent)
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIRepositoryBasePanel:SortItemList(sortFunc)
    if sortFunc then
        table.sort(self.itemList, sortFunc)
        self.virtualList:Refresh()
        self.sortFunc = sortFunc
    end
end

function UIRepositoryBasePanel:UpdateVirtualList()
    if self.virtualList then
        self.virtualList:Refresh()
    end
end

function UIRepositoryBasePanel:FiltrateItemList(filtrateType, isFiltrate)
    for _, item in ipairs(self.itemList) do
        if self:IsFiltrateItem(filtrateType, item) and item.isChoose ~= isFiltrate then
            item.isChoose = isFiltrate
            if isFiltrate then
                self.parent:AddSoldItem(item.soldItem)
                table.insert(self.selectItemList, item)
            else
                self.parent:RemoveSoldItem(item.soldItem)
                self:RemoveSelectItemById(item.id)
            end
        end
    end
    self.virtualList:Refresh()
end

function UIRepositoryBasePanel:IsFiltrateItem(filtrateType, item)
    return item.rank == filtrateType
end

function UIRepositoryBasePanel:GetSelectItemList()
    return self.selectItemList
end

function UIRepositoryBasePanel:GetItemList()
    return self.itemList
end

function UIRepositoryBasePanel:UpdateConfirmBtn()
    if self.parent then
        self.parent:UpdateConfirmBtn()
    end
end

function UIRepositoryBasePanel:ResetSelectItemList()
    self.selectItemList = {}
end

function UIRepositoryBasePanel:RemoveSelectItemById(id)
    local index = 0
    for i, item in ipairs(self.selectItemList) do
        if item.id == id then
            index = i
            break
        end
    end
    if index > 0 then
        table.remove(self.selectItemList, index)
    end
end

function UIRepositoryBasePanel:OnRelease()
    self.parent = nil
    self.transRoot = nil
    self.panelId = nil
    self.virtualList = nil
    self.itemList = {}
    self.isSub = false
    self.sortFunc = nil
    self.selectItemList = {}
end
