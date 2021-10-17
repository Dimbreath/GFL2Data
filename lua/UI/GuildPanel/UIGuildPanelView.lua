require("UI.UIBaseView")

UIGuildPanelView = class("UIGuildPanelView", UIBaseView)
UIGuildPanelView.__index = UIGuildPanelView

function UIGuildPanelView:__InitCtrl()
	self.mBtn_Close = self:GetRectTransform("Btn_Close")
	self.mTrans_Content = self:GetRectTransform("Con_Content")
	self.mTrans_TopBar = self:GetRectTransform("UIUniTopbar")
	self.mTrans_ResList = self:GetRectTransform("UIUniTopbar/UIUniTopbarList/Trans_ResList")
	self.mTrans_ResItemTemp = self:GetRectTransform("UIUniTopbar/UIUniTopbarList/ResourcesCommonItem")
end

function UIGuildPanelView:InitCtrl(root)
	self:SetRoot(root);
	self:__InitCtrl();
end

