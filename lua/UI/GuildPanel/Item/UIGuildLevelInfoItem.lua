require("UI.UIBaseCtrl")

UIGuildLevelInfoItem = class("UIGuildLevelInfoItem", UIBaseCtrl);
UIGuildLevelInfoItem.__index = UIGuildLevelInfoItem

UIGuildLevelInfoItem.itemList = {}
UIGuildLevelInfoItem.mPath_UICommonItemS = "UICommonFramework/UICommonItemS.prefab";

function UIGuildLevelInfoItem:ctor()
    UIGuildLevelInfoItem.super.ctor(self)
    self.itemList = {}
end

function UIGuildLevelInfoItem:__InitCtrl()
    self.mTrans_UnLock = self:GetRectTransform("Trans_UnlockPanel")
    self.mText_UnLockLevel = self:GetText("Trans_UnlockPanel/Text_Level")
    self.mText_UnLockDonationTimes = self:GetText("Trans_UnlockPanel/Text_DonationTimes")
    self.mTrans_Now = self:GetRectTransform("Trans_NowPanel")
    self.mText_NowLevel = self:GetText("Trans_NowPanel/Text_Level")
    self.mText_NowDonationTime = self:GetText("Trans_NowPanel/Text_DonationTimes")
    self.mTran_UnLockItemList = self:GetRectTransform("UI_Trans_ItemList")
    self.mTrans_Lock = self:GetRectTransform("Trans_LockPanel")
    self.mText_LockLevel = self:GetText("Trans_LockPanel/Text_Level")
    self.mText_LockDonationTimes = self:GetText("Trans_LockPanel/Text_DonationTimes")
end

function UIGuildLevelInfoItem:InitCtrl()
    local obj = instantiate(UIUtils.GetGizmosPrefab("Guild/UIGuildLevelInfoListItem.prefab",self));
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIGuildLevelInfoItem:SetData(data, curLevel)
    if data then
        self.mText_LockLevel.text = data.level
        self.mText_UnLockLevel.text = data.level
        self.mText_NowLevel.text = data.level
        self.mText_NowDonationTime.text = data.guild_donation_times
        self.mText_LockDonationTimes.text = data.guild_donation_times
        self.mText_UnLockDonationTimes.text = data.guild_donation_times
        setactive(self.mText_UnLockDonationTimes.gameObject, data.level < curLevel)
        setactive(self.mText_LockDonationTimes.gameObject, data.level > curLevel)
        setactive(self.mText_LockLevel.gameObject, data.level > curLevel)
        setactive(self.mText_UnLockLevel.gameObject, data.level < curLevel)
        setactive(self.mText_NowDonationTime.gameObject, data.level == curLevel)
        setactive(self.mText_NowLevel.gameObject, data.level == curLevel)
        setactive(self.mTrans_Now.gameObject, data.level == curLevel)
        setactive(self.mTrans_Lock.gameObject, data.level > curLevel)
        setactive(self.mTrans_UnLock.gameObject, data.level < curLevel)

        local rewardList = string.split(data.guild_item, ',')
        self:UpdateRewardList(rewardList)
    end
end

function UIGuildLevelInfoItem:UpdateRewardList(list)
    local rewardList = list
    local item = nil
    for i = 1, #rewardList do
        local data = rewardList[i]
        if #self.itemList < i then
            local prefab =  UIUtils.GetGizmosPrefab(self.mPath_UICommonItemS, self)
            local instObj = instantiate(prefab)
            item = UICommonItemS.New()
            item:InitCtrl(instObj.transform)
            UIUtils.AddListItem(instObj.transform, self.mTran_UnLockItemList.transform)
            table.insert(self.itemList, item)
        else
            item = self.itemList[i]
        end
        item:SetData(data, 0)
    end
end

