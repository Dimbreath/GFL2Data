require("UI.UIBaseCtrl")

UIAutoMaxSettlement_RewardItemItem = class("UIAutoMaxSettlement_RewardItemItem", UIBaseCtrl);
UIAutoMaxSettlement_RewardItemItem.__index = UIAutoMaxSettlement_RewardItemItem
--@@ GF Auto Gen Block Begin
UIAutoMaxSettlement_RewardItemItem.mImage_ItemRank = nil;
UIAutoMaxSettlement_RewardItemItem.mImage_ItemIcon = nil;
UIAutoMaxSettlement_RewardItemItem.mText_Count = nil;

function UIAutoMaxSettlement_RewardItemItem:__InitCtrl()

	self.mImage_ItemRank = self:GetImage("Image_ItemRank");
	self.mImage_ItemIcon = self:GetImage("Image_ItemRank/Image_ItemIcon");
	self.mText_Count = self:GetText("Count/Text_Count");
end

--@@ GF Auto Gen Block End

function UIAutoMaxSettlement_RewardItemItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end