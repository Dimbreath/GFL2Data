require("UI.UIBaseCtrl")

---@class UICommonLeftTabItemV2 : UIBaseCtrl
UICommonLeftTabItemV2 = class("UICommonLeftTabItemV2", UIBaseCtrl);
UICommonLeftTabItemV2.__index = UICommonLeftTabItemV2
--@@ GF Auto Gen Block Begin
UICommonLeftTabItemV2.mText_Name = nil;
UICommonLeftTabItemV2.mTrans_Locked = nil;

function UICommonLeftTabItemV2:__InitCtrl()

	self.mText_Name = self:GetText("Text_Name");
	self.mTrans_Locked = self:GetRectTransform("Trans_GrpLocked");
	self.mTrans_RedPoint = self:GetRectTransform("Trans_RedPoint");
end

--@@ GF Auto Gen Block End

function UICommonLeftTabItemV2:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mBtn = self:GetSelfButton();
end

function UICommonLeftTabItemV2:SetName(id, name)
	if name then
		self.tagId = id
		self.mText_Name.text = name

		setactive(self.mUIRoot, true)
	else
		setactive(self.mUIRoot, false)
	end
end

function UICommonLeftTabItemV2:SetItemState(isChoose)
	self.isChoose = isChoose
	UIUtils.SetInteractive(self.mUIRoot, not self.isChoose)
end

function UICommonLeftTabItemV2:SetUnlock(id)
	if id > 0 then
		setactive(self.mTrans_Locked, not AccountNetCmdHandler:CheckSystemIsUnLock(id))
	end
end