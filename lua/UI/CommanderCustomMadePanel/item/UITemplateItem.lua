require("UI.UIBaseCtrl")

UITemplateItem = class("UITemplateItem", UIBaseCtrl);
UITemplateItem.__index = UITemplateItem
--@@ GF Auto Gen Block Begin
UITemplateItem.mBtn_TemplateUnchosen = nil;
UITemplateItem.mBtn_TemplateChosen = nil;
UITemplateItem.mText_TemplateUnchosen_Rank = nil;
UITemplateItem.mText_TemplateChosen_RankShadow = nil;
UITemplateItem.mText_TemplateChosen_Rank = nil;

UITemplateItem.mData = nil;

function UITemplateItem:__InitCtrl()

	self.mBtn_TemplateUnchosen = self:GetButton("UI_Btn_TemplateUnchosen");
	self.mBtn_TemplateChosen = self:GetButton("UI_Btn_TemplateChosen");
	self.mText_TemplateUnchosen_Rank = self:GetText("UI_Btn_TemplateUnchosen/Text_Rank");
	self.mText_TemplateChosen_RankShadow = self:GetText("UI_Btn_TemplateChosen/Text_RankShadow");
	self.mText_TemplateChosen_Rank = self:GetText("UI_Btn_TemplateChosen/Text_Rank");
end

--@@ GF Auto Gen Block End

function UITemplateItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UITemplateItem:InitData(data)
	self.mData = data;
	self.mText_TemplateUnchosen_Rank.text = data.id;
	self.mText_TemplateChosen_Rank.text = data.id;
	self.mText_TemplateChosen_RankShadow.text = data.id;
end

function UITemplateItem:SetSelect(isSelect)
	setactive(self.mBtn_TemplateUnchosen.gameObject, not isSelect);
	setactive(self.mBtn_TemplateChosen.gameObject, isSelect);
end