require("UI.UIBaseCtrl")

UIGuildDonationItem = class("UIGuildDonationItem", UIBaseCtrl);
UIGuildDonationItem.__index = UIGuildDonationItem

UIGuildDonationItem.mData = nil
UIGuildDonationItem.type = 0
UIGuildDonationItem.itemList = {}
UIGuildDonationItem.mPath_UICommonItemS = "UICommonFramework/UICommonItemS.prefab"

function UIGuildDonationItem:ctor()
    UIGuildDonationItem.super.ctor(self)
    self.itemList = {}
end

function UIGuildDonationItem:__InitCtrl()
    self.mText_Name = self:GetText("UI_Trans_UndoQuest/Text_ItemName")
    self.mImage_Icon = self:GetImage("UI_Trans_UndoQuest/Image_ItemIcon")
    self.mText_Repertory = self:GetText("UI_Trans_UndoQuest/Repertory/Text_Repertory")
    self.mText_Amount = self:GetText("UI_Trans_UndoQuest/Text_Amount")
    self.mBtn_Donation = self:GetRectTransform("UI_Trans_UndoQuest/Btn_GotoQuest")
    self.mTrans_ItemList = self:GetRectTransform("UI_Trans_ItemList")
end

function UIGuildDonationItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("Guild/UIGuildDonationItem.prefab",self));
    setparent(parent, obj.transform)
    obj.transform.localScale = vectorone
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIGuildDonationItem:SetData(data)
    self.mData = data
    if self.mData then
        local itemData = TableData.listItemDatas:GetDataById(data.ItemId)
        if itemData then
            local iconPath = itemData.icon_path
            if(iconPath == "") then
                iconPath = "Item"
            end

            self.mText_Name.text = itemData.name.str
            self.mImage_Icon.sprite  = UIUtils.GetIconSprite("Icon/"..iconPath, itemData.icon)
            self.mText_Amount.text = data.ItemNum
            self.mText_Repertory.text = data:GetItemCount()
        end

        self:UpdateRewardList()
    end
end

function UIGuildDonationItem:UpdateRewardList()
    local rewardList = self.mData:GetRewardList()
    local item = nil
    for i = 0, rewardList.Count - 1 do
        local data = rewardList[i]
        if #self.itemList < i + 1 then
            local prefab =  UIUtils.GetGizmosPrefab(self.mPath_UICommonItemS, self)
            local instObj = instantiate(prefab)
            item = UICommonItemS.New()
            item:InitCtrl(instObj.transform)
            UIUtils.AddListItem(instObj.transform, self.mTrans_ItemList.transform)
            table.insert(self.itemList, item)
        else
            item = self.itemList[i + 1]
        end
        item:SetData(data.item_id, data.item_num)
    end
end
