require("UI.UIBaseView")

UIUniTopbarView = class("UIUniTopbarView", UIBaseView);
UIUniTopbarView.__index = UIUniTopbarView

--@@ GF Auto Gen Block Begin
UIUniTopbarView.mImage_TipsPanel = nil;
UIUniTopbarView.mTrans_ResList = nil;
UIUniTopbarView.mTrans_SysList = nil;
UIUniTopbarView.mTrans_TipsPanel = nil;

function UIUniTopbarView:__InitCtrl()
	self.mTrans_TopBar = self:GetRectTransform("UIUniTopbarList")
	self.mImage_TipsPanel = self:GetImage("Trans_Image_TipsPanel");
	self.mTrans_ResList = self:GetRectTransform("UIUniTopbarList/Trans_ResList");
	self.mTrans_SysList = self:GetRectTransform("UIUniTopbarList/Trans_SysList");
	self.mTrans_TipsPanel = self:GetRectTransform("Trans_Image_TipsPanel");
end

--@@ GF Auto Gen Block End

function UIUniTopbarView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end