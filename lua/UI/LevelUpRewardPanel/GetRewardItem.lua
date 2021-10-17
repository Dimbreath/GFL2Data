require("UI.UIBaseCtrl")

GetRewardItem = class("GetRewardItem", UIBaseCtrl);
GetRewardItem.__index = GetRewardItem
--@@ GF Auto Gen Block Begin
GetRewardItem.mImage_RewardIcon = nil;
GetRewardItem.mText_Rewardnum = nil;

function GetRewardItem:__InitCtrl()

	self.mImage_RewardIcon = self:GetImage("Image_RewardIcon");
	self.mText_Rewardnum = self:GetText("Text_Rewardnum");
end

--@@ GF Auto Gen Block End

function GetRewardItem:InitCtrl(parent)
    --实例化
    local obj=instantiate(UIUtils.GetGizmosPrefab("LevelUpReward/GetRewardItem.prefab",self));
    self:SetRoot(obj.transform);
    setparent(parent,obj.transform);
    obj.transform.localScale=vectorone;
    self:SetRoot(obj.transform);
    self:__InitCtrl();
end



function GetRewardItem:SetData(data)
    if data~=nil then
        setactive(self.mUIRoot,true);

        self.mImage_RewardIcon.sprite = IconUtils.GetItemIconSprite(data.itemid)
        self.mText_Rewardnum.text=data.num;

    else
        setactive(self.mUIRoot,false);
    end
end