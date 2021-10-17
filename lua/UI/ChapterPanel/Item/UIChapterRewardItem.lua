require("UI.UIBaseCtrl")

UIChapterRewardItem = class("UIChapterRewardItem", UIBaseCtrl);
UIChapterRewardItem.__index = UIChapterRewardItem
--@@ GF Auto Gen Block Begin
UIChapterRewardItem.mImage_GetChapterReward1_Rank = nil;
UIChapterRewardItem.mImage_GetChapterReward1_Picture = nil;
UIChapterRewardItem.mText_GetChapterReward1_Count = nil;

function UIChapterRewardItem:__InitCtrl()

	self.mImage_GetChapterReward1_Rank = self:GetImage("Image_Rank");
	self.mImage_GetChapterReward1_Picture = self:GetImage("Image_Picture");
	self.mText_GetChapterReward1_Count = self:GetText("Text_Count");
end

--@@ GF Auto Gen Block End

function UIChapterRewardItem:InitCtrl(root)


    local obj=instantiate(UIUtils.GetGizmosPrefab("Story/UIChapterRewardItem.prefab",self));

    self:SetRoot(obj.transform);
    setparent(root,obj.transform);
    obj.transform.localScale=vectorone;

	self:__InitCtrl();

end


function UIChapterRewardItem:SetData(itemId, itemNum)

    if itemId~=nil then
        setactive(self.mUIRoot,true);
        local itemData = TableData.GetItemData(itemId);
        self.mText_GetChapterReward1_Count.text = itemNum;
        self.mImage_GetChapterReward1_Picture.sprite = CS.IconUtils.GetItemIconSprite(itemId);
    else
       setactive(self.mUIRoot,false);
    end
    --TipsManager.Add(self.mBtn_Icon.gameObject, itemData, itemNum);
end
