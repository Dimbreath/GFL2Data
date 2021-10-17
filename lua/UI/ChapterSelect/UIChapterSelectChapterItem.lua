--region *.lua
--Date

require("UI.UIBaseCtrl")

UIChapterSelectChapterItem = class("UIChapterSelectChapterItem", UIBaseCtrl);
UIChapterSelectChapterItem.__index = UIChapterSelectChapterItem;

UIChapterSelectChapterItem.mButton_Select = nil;
UIChapterSelectChapterItem.mText_ChapterName = nil;
UIChapterSelectChapterItem.mObj_NewSign = nil;
UIChapterSelectChapterItem.mObj_CurrentSign = nil;
UIChapterSelectChapterItem.mObj_PlayerSign = nil;
UIChapterSelectChapterItem.mObj_UnlockSign = nil;

UIChapterSelectChapterItem.mOverviewData = nil;
UIChapterSelectChapterItem.mLocked = true;
UIChapterSelectChapterItem.mData = nil;

--构造
function UIChapterSelectChapterItem:ctor()
    UIChapterSelectChapterItem.super.ctor(self);
end

--初始化
function UIChapterSelectChapterItem:InitCtrl(root)

    self:SetRoot(root);
    
    self.mButton_Select = self:GetImage("Select");
    self.mText_ChapterName = self:GetText("ChapterName");
    self.mObj_NewSign = self:FindChild("New");
    self.mObj_CurrentSign = self:FindChild("Current");
    self.mObj_PlayerSign = self:FindChild("Player");
    self.mObj_UnlockSign = self:FindChild("Lock");

end

function UIChapterSelectChapterItem:SetUIData(chapterData)

   self.mOverviewData = CampaignPool:GetChapterOveriew(chapterData.id);
   --根据前置章节判断是否已解锁
   local preOverviewData = CampaignPool:GetChapterOveriew(chapterData.pre_campaign);
   self.mLocked = preOverviewData ~= nil and preOverviewData.finished == 1;
   self.mData = chapterData;
   self.mText_ChapterName.text = chapterData.name;

   setactive(self.mObj_UnlockSign, self.mLocked);
   setactive(self.mObj_NewSign, CampaignPool:IsNewMap(chapterData.id));
end

function UIChapterSelectChapterItem:SetInPlace(inplace)
   setactive(self.mObj_PlayerSign, inplace);
end

function UIChapterSelectChapterItem:SetSelect(selected)
   setactive(self.mObj_CurrentSign, selected);
end

function UIChapterSelectChapterItem:Release(locked)
    
    self.mOverviewData = nil;
    self.mData = nil;
    gfdestroy(self:GetRoot().gameObject);
end

--endregion
