require("UI.UIBaseCtrl")

UICommonHintTipsItem = class("UICommonHintTipsItem", UIBaseCtrl);
UICommonHintTipsItem.__index = UICommonHintTipsItem
--@@ GF Auto Gen Block Begin
UICommonHintTipsItem.mText_Hint = nil;
UICommonHintTipsItem.timer = nil;
UICommonHintTipsItem.idx = 0;
function UICommonHintTipsItem:__InitCtrl()

	self.mText_Hint = self:GetText("Hint/Text_Hint");
end

--@@ GF Auto Gen Block End

function UICommonHintTipsItem:InitCtrl(root,idx)

	self:SetRoot(root);

	self:__InitCtrl();
	self.idx= idx;
end

function UICommonHintTipsItem:ShowHint(msg)
	self:SetActive(true);
	self.mUIRoot.transform:SetAsLastSibling();
	self.mText_Hint.text = msg;
	if self.timer ~= nil then
		self.timer:Abort();
	end
	self.timer = TimerSys:DelayCall(TableDataMgr.CommonhintTipsDelaytime,function()
	self:SetActive(false);
	self.timer = nil;
	end,0);
end