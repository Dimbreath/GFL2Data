--region *.lua

require("UI.UIBaseView")

UIChapterSelectView = class("UIChapterSelectView", UIBaseView);
UIChapterSelectView.__index = UIChapterSelectView;

-----------------------[控件]----------------------
UIChapterSelectView.mButton_Return = nil;

UIChapterSelectView.mList_Chapters = nil;

--构造
function UIChapterSelectView:ctor()
    UIChapterSelectView.super.ctor(self);
end

--初始化
function UIChapterSelectView:InitCtrl(root)

    self:SetRoot(root);
    
    self.mButton_Return = self:GetButton("TopPanel/Return");

    self.mList_Chapters = self:FindChild("ButtonPanel/chapterList");
end

--endregion
