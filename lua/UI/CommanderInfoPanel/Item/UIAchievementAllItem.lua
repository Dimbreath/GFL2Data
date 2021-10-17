require("UI.UIBaseCtrl")

---@class UIAchievementAllItem : UIBaseCtrl
UIAchievementAllItem = class("UIAchievementAllItem", UIBaseCtrl);
UIAchievementAllItem.__index = UIAchievementAllItem
--@@ GF Auto Gen Block Begin
UIAchievementAllItem.mImg_Icon = nil;
UIAchievementAllItem.mImg_ProgressBar = nil;
UIAchievementAllItem.mText_ = nil;
UIAchievementAllItem.mText_ = nil;
UIAchievementAllItem.mText_Lv = nil;
UIAchievementAllItem.mText_Progress = nil;
UIAchievementAllItem.mTrans_RedPoint = nil;

function UIAchievementAllItem:__InitCtrl()
    self.mBtn = self:GetSelfButton()
    self.mImg_Icon = self:GetImage("Root/GrpIcon/Img_Icon");
    self.mImg_ProgressBar = self:GetImage("Root/GrpProgress/GrpProgressBar/Img_ProgressBar");
    self.mText_ = self:GetText("Root/GrpBg/Text");
    self.mText_Content = self:GetText("Root/GrpTittle/Text_Content");
    self.mText_Lv = self:GetText("Root/GrpProgress/Text_Lv");
    self.mText_Progress = self:GetText("Root/GrpProgress/Text_Progress");
    self.mTrans_RedPoint = self:GetRectTransform("Root/Trans_RedPoint");
end

--@@ GF Auto Gen Block End

function UIAchievementAllItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("CommanderInfo/AchievementAllItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIAchievementAllItem:SetData(data)
    self.mData = data
    self.mText_Content.text = data.tag_name;
    self.mImg_Icon.sprite = IconUtils.GetAchievementIcon(data.icon, true)
    self:RefreshData()
end

function UIAchievementAllItem:RefreshData()
    local rewardId = NetCmdAchieveData:GetCurrentTagRewardId(self.mData.id)
    local rewardNotReceivedId = NetCmdAchieveData:GetCurrentNotReceivedTagRewardId(self.mData.id)
    local count = 0
    local rewardData = nil
    local nextRewardData = nil
    if rewardNotReceivedId == -1 then
        rewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId);
        count = NetCmdAchieveData:GetCurrentTagRewardLevelProgress(self.mData);

        if TableData.listAchievementRewardDatas:ContainsId(rewardId + 1) then
            nextRewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId + 1);
        end
        if nextRewardData ~= nil and nextRewardData.lv_exp > NetCmdItemData:GetResCount(self.mData.point_item) then
            self.mText_Progress.text = count .. "/" .. (nextRewardData.lv_exp - rewardData.lv_exp)
            self.mImg_ProgressBar.fillAmount = count / (nextRewardData.lv_exp - rewardData.lv_exp)
        else
            local prevRewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId - 1);
            self.mText_Progress.text = count .. "/" .. (rewardData.lv_exp - prevRewardData.lv_exp)
            self.mImg_ProgressBar.fillAmount = count / (rewardData.lv_exp - prevRewardData.lv_exp)
        end
        self.mText_Lv.text = "Lv." .. rewardData.tag_lv
    else
        rewardId = rewardNotReceivedId
        rewardData = TableData.listAchievementRewardDatas:GetDataById(rewardNotReceivedId);
        local prevRewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId - 1);
        count = rewardData.lv_exp - prevRewardData.lv_exp
        self.mText_Progress.text = count .. "/" .. (rewardData.lv_exp - prevRewardData.lv_exp);
        self.mImg_ProgressBar.fillAmount = count / (rewardData.lv_exp - prevRewardData.lv_exp);
        self.mText_Lv.text = "Lv." .. prevRewardData.tag_lv
    end
    setactive(self.mTrans_RedPoint, NetCmdAchieveData:TagRewardCanReceive(self.mData.id) or NetCmdAchieveData:CanReceiveByTagId(self.mData.id))
end