require("UI.UIBaseCtrl")

UIAutoMaxRewardItemItem = class("UIAutoMaxRewardItemItem", UIBaseCtrl);
UIAutoMaxRewardItemItem.__index = UIAutoMaxRewardItemItem
--@@ GF Auto Gen Block Begin
UIAutoMaxRewardItemItem.mImage_Icon = nil;

function UIAutoMaxRewardItemItem:__InitCtrl()

	self.mImage_Icon = self:GetImage("Image_Icon");
end

--@@ GF Auto Gen Block End

function UIAutoMaxRewardItemItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end