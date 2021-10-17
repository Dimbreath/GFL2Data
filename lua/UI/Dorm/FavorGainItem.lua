require("UI.UIBaseCtrl")

FavorGainItem = class("FavorGainItem", UIBaseCtrl);
FavorGainItem.__index = FavorGainItem
--@@ GF Auto Gen Block Begin
FavorGainItem.mText_Level = nil;
FavorGainItem.mSlider_ActualSlider = nil;
FavorGainItem.mSlider_VirtualSilder = nil;

function FavorGainItem:__InitCtrl()

	self.mText_Level = self:GetText("FavorLevel/Text_Level");
	self.mSlider_ActualSlider = self:GetSlider("Slider_ActualSlider");
	self.mSlider_VirtualSilder = self:GetSlider("Slider_ActualSlider/Slider_VirtualSilder");
end

--@@ GF Auto Gen Block End

function FavorGainItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end