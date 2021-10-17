require("UI.UIBaseCtrl")

UIIntegralItem = class("UIIntegralItem", UIBaseCtrl);
UIIntegralItem.__index = UIIntegralItem
--@@ GF Auto Gen Block Begin
UIIntegralItem.mText_Integral = nil;
UIIntegralItem.mCanvasG_Complete = nil;

function UIIntegralItem:__InitCtrl()

	self.mText_Integral = self:GetText("CanvasG_Complete/Text_Integral");
	self.mCanvasG_Complete = self:GetCanvasGroup("CanvasG_Complete");
end

--@@ GF Auto Gen Block End

function UIIntegralItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIIntegralItem:SetData()
	self.mText_Integral.text = BattleNetCmdHandler.TempIntergal
end