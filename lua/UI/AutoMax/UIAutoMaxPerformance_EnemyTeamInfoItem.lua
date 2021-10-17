require("UI.UIBaseCtrl")

UIAutoMaxPerformance_EnemyTeamInfoItem = class("UIAutoMaxPerformance_EnemyTeamInfoItem", UIBaseCtrl);
UIAutoMaxPerformance_EnemyTeamInfoItem.__index = UIAutoMaxPerformance_EnemyTeamInfoItem
--@@ GF Auto Gen Block Begin
UIAutoMaxPerformance_EnemyTeamInfoItem.mImage_HurtBar = nil;
UIAutoMaxPerformance_EnemyTeamInfoItem.mImage_HPbar = nil;
UIAutoMaxPerformance_EnemyTeamInfoItem.mText_TeamNumber = nil;

function UIAutoMaxPerformance_EnemyTeamInfoItem:__InitCtrl()

	self.mImage_HurtBar = self:GetImage("HPbar/Image_HurtBar");
	self.mImage_HPbar = self:GetImage("HPbar/Image_HPbar");
	self.mText_TeamNumber = self:GetText("TeamNumber/Text_TeamNumber");
end

--@@ GF Auto Gen Block End

function UIAutoMaxPerformance_EnemyTeamInfoItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end