require("UI.UIBaseView")

UIRaidReceivePanelView = class("UIRaidReceivePanelView", UIBaseView);
UIRaidReceivePanelView.__index = UIRaidReceivePanelView

--@@ GF Auto Gen Block Begin
UIRaidReceivePanelView.mBtn_Confirm = nil;
UIRaidReceivePanelView.mText_Title = nil;
--UIRaidReceivePanelView.mHLayout_ItemList = nil;
UIRaidReceivePanelView.mTrans_ItemList = nil;

function UIRaidReceivePanelView:__InitCtrl()

	self.mBtn_Confirm = self:GetButton("Root/GrpBg/Btn_Close");
	self.mText_Title = self:GetText("Root/GrpDialog/GrpTittle/TitleText");
    self.mTextName = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpRaid/GrpChrExpUp/GrpTextLevel/GrpTextName/TexName")
	--self.mHLayout_ItemList = self:GetHorizontalLayoutGroup("ReceivePanel/ItemList/Trans_HLayout_ItemList");
	self.mTrans_ItemList = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpRaid/GrpRaidItemList/Viewport/Content");
	self.mTrans_Receive = self:GetRectTransform("Root")

	self.mTrans_RaidPanel = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpRaid")
	self.mImage_ExpBefore = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpRaid/GrpChrExpUp/GrpProgressBar/Img_ProgressBarBefore") 
	self.mImage_ExpAfter = self:GetImage("Root/GrpDialog/GrpCenter/Trans_GrpRaid/GrpChrExpUp/GrpProgressBar/Img_ProgressBarAfter") 
	self.mText_ExpAdd = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpRaid/GrpChrExpUp/GrpTextLevel/GrpTextExpAdd/Text_Add")
	self.mText_Lv = self:GetText("Root/GrpDialog/GrpCenter/Trans_GrpRaid/GrpChrExpUp/GrpTextLevel/GrpTextLv/Text_Lv")
end

--@@ GF Auto Gen Block End

function UIRaidReceivePanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

    -- self.mTextName.text = "指挥官经验"
    -- self.mText_Title.text = "获得物品"
end