require("UI.UIBaseCtrl")

UIAutoMaxPerformance_PlayerTeamInfoItem = class("UIAutoMaxPerformance_PlayerTeamInfoItem", UIBaseCtrl);
UIAutoMaxPerformance_PlayerTeamInfoItem.__index = UIAutoMaxPerformance_PlayerTeamInfoItem
--@@ GF Auto Gen Block Begin
UIAutoMaxPerformance_PlayerTeamInfoItem.mImage_HurtBar = nil;
UIAutoMaxPerformance_PlayerTeamInfoItem.mImage_HPbar = nil;
UIAutoMaxPerformance_PlayerTeamInfoItem.mText_TeamNumber = nil;

function UIAutoMaxPerformance_PlayerTeamInfoItem:__InitCtrl()

	self.mImage_HurtBar = self:GetImage("HPbar/Image_HurtBar");
	self.mImage_HPbar = self:GetImage("HPbar/Image_HPbar");
	self.mText_TeamNumber = self:GetText("TeamNumber/Text_TeamNumber");
end

--@@ GF Auto Gen Block End

function UIAutoMaxPerformance_PlayerTeamInfoItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end