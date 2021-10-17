require("UI.UIBaseCtrl")

UICommonHintItem = class("UICommonHintItem", UIBaseCtrl);
UICommonHintItem.__index = UICommonHintItem
--@@ GF Auto Gen Block Begin
UICommonHintItem.mBtn_Background = nil;
UICommonHintItem.mText_Hint = nil;

function UICommonHintItem:__InitCtrl()

	self.mBtn_Background = self:GetButton("Btn_Background");
	self.mText_Hint = self:GetText("Hint/Text_Hint");
end

--@@ GF Auto Gen Block End

function UICommonHintItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	UIUtils.GetButtonListener(self.mBtn_Background.gameObject).onClick = function()self:OnClick(); end
end

function UICommonHintItem:ShowHint(msg)
	self:SetActive(true);
	self.mUIRoot.transform:SetAsLastSibling();
	self.mText_Hint.text = msg;
	if self.timer ~= nil then
		self.timer:Abort();
	end
	self.timer = TimerSys:DelayCall(TableDataMgr.CommonhintDelaytime,function()
		self:SetActive(false);
		self.timer = nil;
	end,0);
end

function UICommonHintItem:OnClick()
	if self.timer ~= nil then
		self.timer:Abort();
		self.timer = nil;
	end
	self:SetActive(false);
end