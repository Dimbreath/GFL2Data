require("UI.UIBaseCtrl")

GetChapterRewardItem = class("GetChapterRewardItem", UIBaseCtrl);
GetChapterRewardItem.__index = GetChapterRewardItem
--@@ GF Auto Gen Block Begin
GetChapterRewardItem.mText_LimitText = nil;
GetChapterRewardItem.mTrans_ChapterRewardList = nil;
GetChapterRewardItem.mTrans_Got = nil;
GetChapterRewardItem.mTrans_ChapterRewardLimit = nil;

function GetChapterRewardItem:__InitCtrl()

	self.mText_LimitText = self:GetText("Trans_ChapterRewardLimit/Text_LimitText");
	self.mTrans_ChapterRewardList = self:GetRectTransform("ChapterReward/Trans_ChapterRewardList");
	self.mTrans_Got = self:GetRectTransform("Trans_Got");
	self.mTrans_ChapterRewardLimit = self:GetRectTransform("Trans_ChapterRewardLimit");
end

--@@ GF Auto Gen Block End

GetChapterRewardItem.mChapterRewardItemList=nil;

function GetChapterRewardItem:InitCtrl(parent)
    --实例化
    local obj=instantiate(UIUtils.GetGizmosPrefab("GetChapterRewardItem.prefab",self));
    self:SetRoot(obj.transform);
    setparent(parent,obj.transform);
    obj.transform.localScale=vectorone;
    self:SetRoot(obj.transform);
    self:__InitCtrl();
    GetChapterRewardItem.mChapterRewardItemList=List:New();

end



function GetChapterRewardItem:SetData(data)
    if data~=nil then
        setactive(self.mUIRoot,true);

        local state=NetCmdMailData:CheckCanGetRewardByID(data);

        if state==2 then
            setactive(self.mTrans_Got,true);
            setactive(self.mTrans_ChapterRewardLimit,false);
        else
            setactive(self.mTrans_Got,false);
            setactive(self.mTrans_ChapterRewardLimit,true);
            self.mText_LimitText.text=tostring(data.id);
        end

        local datas=data.mRewardItemlist;


        for i = 1, self.mChapterRewardItemList:Count() do
            self.mChapterRewardItemList[i]:SetData(nil);
        end

        for i = 0, datas.Count-1 do

            if i< self.mChapterRewardItemList:Count() then
                self.mChapterRewardItemList[i+1]:SetData(datas[i].itemid,datas[i].num);
            else
                local itemview=UIChapterRewardItem.New();
                itemview:InitCtrl(self.mTrans_ChapterRewardList);
                self.mChapterRewardItemList:Add(itemview);
                itemview:SetData(datas[i].itemid,datas[i].num);
            end
        end

    else
        setactive(self.mUIRoot,false);

    end
end