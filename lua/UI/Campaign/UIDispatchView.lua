---
--- Created by 6队.
--- DateTime: 18/8/9 16:03
---

require("UI.UIBaseView")
require("UI.Campaign.Item.UIDispatchTeamItem")

UIDispatchView = class("UIDispatchView", UIBaseView);
UIDispatchView.__index = UIDispatchView;

UIDispatchView.mText_CurTeamNum = nil;

UIDispatchView.mButton_Exit = nil;
UIDispatchView.mButton_Confirm = nil;

UIDispatchView.mGrid_TeamList = nil;



function UIDispatchView:ctor()
    UIDispatchView.super.ctor(self);
end

function UIDispatchView:InitCtrl(root)

    self:SetRoot(root);

    self.mText_CurTeamNum = self:GetText("ChosenTeamText");

    self.mButton_Exit = self:GetButton("CloseButton");
    self.mButton_Confirm = self:GetButton("ConfirmButton");

    self.mGrid_TeamList = self:FindChild("TeamListMask/List");

    --拿到编队信息  刷新界面



end

