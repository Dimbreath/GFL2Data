require("UI.UIBaseView")

UICommonReceivePanelView = class("UICommonReceivePanelView", UIBaseView);
UICommonReceivePanelView.__index = UICommonReceivePanelView

--@@ GF Auto Gen Block Begin
UICommonReceivePanelView.mBtn_Confirm = nil;
UICommonReceivePanelView.mText_Title = nil;
--UICommonReceivePanelView.mHLayout_ItemList = nil;
UICommonReceivePanelView.mTrans_ItemList = nil;

function UICommonReceivePanelView:__InitCtrl()

	self.mBtn_Confirm = self:GetButton("Root/GrpBg/Btn_Close");
	self.mText_Title = self:GetText("Root/GrpDialog/GrpTittle/TitleText");
	--self.mHLayout_ItemList = self:GetHorizontalLayoutGroup("ReceivePanel/ItemList/Trans_HLayout_ItemList");
	self.mTrans_ItemList = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpItemList/Viewport/Content");
	self.mTrans_Receive = self:GetRectTransform("Root")

	self.mTrans_RaidPanel = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpRaid")
	self.mImage_ExpBefore = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpRaid/GrpChrExpUp/GrpProgressBar/Img_ProgressBarBefore") 
	self.mImage_ExpAfter = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpRaid/GrpChrExpUp/GrpProgressBar/Img_ProgressBarAfter") 
	self.mText_ExpAdd = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpRaid/GrpChrExpUp/GrpTextLevel/GrpTextExpAdd/Text_Add")
	self.mText_Lv = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpRaid/GrpChrExpUp/GrpTextLevel/GrpTextLv/Text_Lv")
end

--@@ GF Auto Gen Block End

function UICommonReceivePanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end