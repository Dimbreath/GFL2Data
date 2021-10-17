require("UI.UIBaseView")
---@class UIFriendBlackListPanelView : UIBaseView

UIFriendBlackListPanelView = class("UIFriendBlackListPanelView", UIBaseView)
UIFriendBlackListPanelView.__index = UIFriendBlackListPanelView

function UIFriendBlackListPanelView:ctor()

end

function UIFriendBlackListPanelView:__InitCtrl()
    self.mBtn_BgClose = self:GetButton("Root/GrpBg/Btn_Close")
    self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mTrans_BlackList = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpList")
    self.mTrans_BlackEmpty = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpEmpty")

    self.mText_Num = self:GetText("Root/GrpDialog/GrpBlackListNum/GrpText/Text_Num")
    self.mText_AllNum = self:GetText("Root/GrpDialog/GrpBlackListNum/GrpText/TextNumAll")

    self.mVirtualList = UIUtils.GetVirtualList(self.mTrans_BlackList)
end

function UIFriendBlackListPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end
