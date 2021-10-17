require("UI.UIBaseCtrl")

UIExpeditionTeamDispatchItem = class("UIExpeditionTeamDispatchItem", UIBaseCtrl);
UIExpeditionTeamDispatchItem.__index = UIExpeditionTeamDispatchItem
--@@ GF Auto Gen Block Begin

UIExpeditionTeamDispatchItem.mData = nil;
UIExpeditionTeamDispatchItem.mText_ExpeditionTeamDispatchName = nil;

function UIExpeditionTeamDispatchItem:__InitCtrl()

	self.mText_ExpeditionTeamDispatchName = self:GetText("Text_ExpeditionTeamDispatchName");
end

--@@ GF Auto Gen Block End

function UIExpeditionTeamDispatchItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIExpeditionTeamDispatchItem:InitData(data)
	self.mData = data;
	self.mText_ExpeditionTeamDispatchName.text = data.Name;
end