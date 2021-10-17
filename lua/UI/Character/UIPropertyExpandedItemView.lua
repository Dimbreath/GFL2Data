require("UI.UIBaseView")

UIPropertyExpandedItemView = class("UIPropertyExpandedItemView", UIBaseView);
UIPropertyExpandedItemView.__index = UIPropertyExpandedItemView

--@@ GF Auto Gen Block Begin

function UIPropertyExpandedItemView:__InitCtrl()

end

--@@ GF Auto Gen Block End

function UIPropertyExpandedItemView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end