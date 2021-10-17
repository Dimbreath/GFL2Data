require("UI.UIBaseView")

UILoginPanelView = class("UILoginPanelView", UIBaseView);
UILoginPanelView.__index = UILoginPanelView

--@@ GF Auto Gen Block Begin
UILoginPanelView.mBtn_BGCloseButton = nil;
UILoginPanelView.mBtn_Cancel = nil;
UILoginPanelView.mBtn_Confirm = nil;
UILoginPanelView.mText_UpdateText = nil;
UILoginPanelView.mText_MainText = nil;
UILoginPanelView.mTrans_OpeningPanel = nil;
UILoginPanelView.mTrans_StartPanel = nil;
UILoginPanelView.mTrans_HintPanel = nil;

function UILoginPanelView:__InitCtrl()

	self.mBtn_BGCloseButton = self:GetButton("Trans_HintPanel/Btn_BGCloseButton");
	self.mBtn_Cancel = self:GetButton("Trans_HintPanel/MainPanel/BGPanel/ButtonPanel/Btn_Cancel");
	self.mBtn_Confirm = self:GetButton("Trans_HintPanel/MainPanel/BGPanel/ButtonPanel/Btn_Confirm");
	self.mText_UpdateText = self:GetText("Trans_StartPanel/Text_UpdateText");
	self.mText_MainText = self:GetText("Trans_HintPanel/MainPanel/BGPanel/Text_MainText");
	self.mTrans_OpeningPanel = self:GetRectTransform("Trans_OpeningPanel");
	self.mTrans_StartPanel = self:GetRectTransform("Trans_StartPanel");
	self.mTrans_HintPanel = self:GetRectTransform("Trans_HintPanel");
end

--@@ GF Auto Gen Block End

function UILoginPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end