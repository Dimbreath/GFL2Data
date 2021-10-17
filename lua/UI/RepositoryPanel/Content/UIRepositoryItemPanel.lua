require("UI.RepositoryPanel.Content.UIRepositoryBasePanel")

UIRepositoryItemPanel = class("UIRepositoryItemPanel", UIRepositoryBasePanel)
UIRepositoryItemPanel.__index = UIRepositoryItemPanel

function UIRepositoryItemPanel:ctor(parent, panelId, transRoot)
    UIRepositoryItemPanel.super.ctor(self, parent, panelId, transRoot)
    self.itemList = nil
end

function UIRepositoryItemPanel:InitItemTypeList()
    local parentRoot = self.parent.mView.mContent_Item.transform
    local typeList = TableData.listRepositoryCategoryDatas
    for i = 0, typeList.Count - 1 do
        ---@type UIRepositoryListItemV2
        local item = UIRepositoryListItemV2.New()
        item:InitCtrl(parentRoot)
        item:SetData(typeList[i])

        table.insert(self.itemList, item)
    end
end

function UIRepositoryItemPanel:UpdateItemList()
    if self.itemList == nil then
        self.itemList = {}
        self:InitItemTypeList()
    end
    for _, item in ipairs(self.itemList) do
        item:UpdateItemList()
    end
end

function UIRepositoryItemPanel:OnRelease()
    if self.itemList ~= nil then
        for _, item in ipairs(self.itemList) do
            item:OnRelease()
        end
    end

    UIRepositoryItemPanel.super.OnRelease(self)
end
