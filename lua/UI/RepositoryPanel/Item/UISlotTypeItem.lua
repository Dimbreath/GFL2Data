require("UI.UIBaseCtrl")
require("UI.Common.UICommonItemL")

UISlotTypeItem = class("UISlotTypeItem", UIBaseCtrl)
UISlotTypeItem.__index = UISlotTypeItem

UISlotTypeItem.mData = nil

function UISlotTypeItem:ctor()
    self.itemList = {}
end

function UISlotTypeItem:__InitCtrl()
    self.mText_Name = self:GetText("Con_Info/Text_SortName")
    self.mTrans_ItemList = self:GetRectTransform("UISlotListItem")
end

function UISlotTypeItem:InitCtrl(parent)
    self.parent = parent

    local obj = instantiate(UIUtils.GetGizmosPrefab("Repository/UISlotTypeItem.prefab", self))
    self:SetRoot(obj.transform)
    setparent(parent, obj.transform)
    obj.transform.localScale = vectorone

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end


function UISlotTypeItem:SetData(data)
    self.mData = data
    if data then
        self.mText_Name.text = data.title.str
    end
end

function UISlotTypeItem:UpdateItemList()
    if self.mData then
        local itemDataList = NetCmdItemData:GetRepositoryItemListByType(self.mData.item_type)
        for i = 0, itemDataList.Count - 1 do
            local itemData = itemDataList[i]
            local item = nil
            if i + 1 > #self.itemList then
                item = UICommonItemL.New()
                item:InitCtrl(self.mTrans_ItemList)
                table.insert(self.itemList, item)
            else
                item = self.itemList[i + 1]
            end
            item:SetItemData(itemData.item_id, itemData.item_num, false, false, itemData.item_num)
        end
    end
end

function UISlotTypeItem:OnRelease()
    self.itemList = {}
end