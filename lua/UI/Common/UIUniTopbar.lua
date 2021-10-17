require("UI.UIBaseCtrl")

UIUniTopbar = class("UIUniTopbar", UIBaseCtrl);
UIUniTopbar.__index = UIUniTopbar
--@@ GF Auto Gen Block Begin
UIUniTopbar.mTrans_ResList = nil;

function UIUniTopbar:__InitCtrl()

	self.mTrans_ResList = self:GetRectTransform("Trans_ResList");
end

--@@ GF Auto Gen Block End

function UIUniTopbar:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end