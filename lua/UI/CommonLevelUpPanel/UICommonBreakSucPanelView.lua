require("UI.UIBaseView")
---@class UICommonBreakSucPanelView : UIBaseView

UICommonBreakSucPanelView = class("UICommonBreakSucPanelView", UIBaseView)
UICommonBreakSucPanelView.__index = UICommonBreakSucPanelView

function UICommonBreakSucPanelView:ctor()

end

function UICommonBreakSucPanelView:__InitCtrl()
    self.mBtn_Close = self:GetButton("Root/GrpBg/Btn_Close")
end

function UICommonBreakSucPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end
