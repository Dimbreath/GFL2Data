require("UI.UIBaseView")

UIPlayerInfoPanelView = class("UIPlayerInfoPanelView", UIBaseView)
UIPlayerInfoPanelView.__index = UIPlayerInfoPanelView

function UIPlayerInfoPanelView:ctor()
end

function UIPlayerInfoPanelView:__InitCtrl()
	self.mBtn_Close = self:GetButton("Root/GrpBg/Btn_Close")
	self.mTrans_Dialog = self:GetRectTransform("Root/GrpDialog")
end

function UIPlayerInfoPanelView:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end
