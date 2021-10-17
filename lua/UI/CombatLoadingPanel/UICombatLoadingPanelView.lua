require("UI.UIBaseView")

UICombatLoadingPanelView = class("UICombatLoadingPanelView", UIBaseView);
UICombatLoadingPanelView.__index = UICombatLoadingPanelView

--@@ GF Auto Gen Block Begin

function UICombatLoadingPanelView:__InitCtrl()

end

--@@ GF Auto Gen Block End

function UICombatLoadingPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end