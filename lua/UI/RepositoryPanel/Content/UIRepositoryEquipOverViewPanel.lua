require("UI.RepositoryPanel.Content.UIRepositoryBasePanel")
require("UI.Common.UICommonItemL")
require("UI.Common.UIEquipOverViewItem")

UIRepositoryEquipOverViewPanel = class("UIRepositoryEquipOverViewPanel", UIRepositoryBasePanel)
UIRepositoryEquipOverViewPanel.__index = UIRepositoryEquipOverViewPanel

function UIRepositoryEquipOverViewPanel:ctor(parent, panelId, rootTrans)
    UIRepositoryEquipOverViewPanel.super.ctor(self, parent, panelId, rootTrans)
    self.itemList = nil
    self.overViewList = {}
end

function UIRepositoryEquipOverViewPanel:UpdateItemList()
    if self.itemList == nil then
        self.itemList = {}
        self:InitEquipSetList()
    else
        for _, item in ipairs(self.overViewList) do
            if item.mData.id > 0 then
                item:UpdateCount()
            end
        end
    end
end

function UIRepositoryEquipOverViewPanel:InitEquipSetList()
    local rootParent = self.parent.mView.mContent_EquipSuit.transform
    self.itemList = self:GetEquipSetList()
    for i = 1, #self.itemList do
        local data = self.itemList[i]
        local item = ChrEquipSuitListItemV2.New()
        item:InitCtrl(rootParent)
        item:SetData(data)

        UIUtils.GetButtonListener(item.mBtn_Detail.gameObject).onClick = function()
            self:OnClickEquipSet(data.id)
        end

        table.insert(self.overViewList, item)
    end
end

function UIRepositoryEquipOverViewPanel:GetEquipSetList()
    local list = {}
    local setList = TableData.listEquipSetDatas
    for i = 0, setList.Count - 1 do
        table.insert(list, setList[i])
    end
    return list
end


function UIRepositoryEquipOverViewPanel:OnClickEquipSet(setId)
    self:UpdatePanelByType(UIRepositoryGlobal.PanelType.EquipPanel, setId)
end
