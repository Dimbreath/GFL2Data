--region *.lua

require("UI.UIBaseView")

UIAutoMaxPanelView = class("UIAutoMaxPanelView",UIBaseView);
UIAutoMaxPanelView.__index = UIAutoMaxPanelView;


------------------------------------[�ؼ�]---------------------
UIAutoMaxPanelView.mPanel_DetailInfoPanel = nil;
UIAutoMaxPanelView.mText_DetailText = nil;
UIAutoMaxPanelView.mButton_DetailReturn = nil;



--����
function UIAutoMaxPanelView:ctor()
	UIAutoMaxPanelView.super.ctor(self)
end

function UIAutoMaxPanelView:InitCtrl(root)
	self:SetRoot(root)
	self.mPanel_DetailInfoPanel = self:FindChild("SettlementInfo/DetailInfoPanel")
	self.mText_DetailText = self:GetText("SettlementInfo/DetailInfoPanel/TurnListAlpha/Text")
	self.mButton_DetailReturn = self:GetButton("SettlementInfo/DetailInfoPanel/ButtonReturn")
end
