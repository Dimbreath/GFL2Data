require("UI.UIBaseView")
---@class UICommonGunDisplayPanelView : UIBaseView

UICommonGunDisplayPanelView = class("UICommonGunDisplayPanelView", UIBaseView)
UICommonGunDisplayPanelView.__index = UICommonGunDisplayPanelView

function UICommonGunDisplayPanelView:ctor()

end

function UICommonGunDisplayPanelView:__InitCtrl()
    self.mBtn_Close = self:GetButton("Root/GrpWindow/GrpTop/GrpClose/Btn_Close")
    self.mBtn_Close1 = self:GetButton("Root/GrpBg/Btn_Close")

    self.mTrans_GunList = self:GetRectTransform("Root/GrpWindow/GrpCenter/GrpChr/Viewport/Content")
end

function UICommonGunDisplayPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end
