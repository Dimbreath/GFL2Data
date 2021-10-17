-------ChrMentalMetarialCosumePanelV2--------
require("UI.UIBaseView")

UIMixConfirmPanelView = class("UIMixConfirmPanelView", UIBaseView);
UIMixConfirmPanelView.__index = UIMixConfirmPanelView

--@@ GF Auto Gen Block Begin
UIMixConfirmPanelView.mBtn_GrpBg_Close = nil;
UIMixConfirmPanelView.mBtn_Close = nil;
UIMixConfirmPanelView.mBtn_GrpBtn_BtnCancel_Cancel = nil;
UIMixConfirmPanelView.mBtn_GrpBtn_BtnConfirm_Confim = nil;
UIMixConfirmPanelView.mText_Num = nil;
UIMixConfirmPanelView.mText_GrpBtn_BtnCancel_Name = nil;
UIMixConfirmPanelView.mText_GrpBtn_BtnConfirm_Name = nil;
UIMixConfirmPanelView.mTrans_GrpBg = nil;
UIMixConfirmPanelView.mTrans_GrpTop = nil;
UIMixConfirmPanelView.mTrans_Content = nil;
UIMixConfirmPanelView.mTrans_GrpBtn = nil;
UIMixConfirmPanelView.mTrans_GrpBtn_BtnCancel = nil;
UIMixConfirmPanelView.mTrans_GrpBtn_BtnConfirm = nil;

function UIMixConfirmPanelView:__InitCtrl()

	self.mBtn_GrpBg_Close = self:GetButton("Root/GrpBg/Btn_Close");
	self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close");
	self.mBtn_GrpBtn_BtnCancel_Cancel = self:GetButton("Root/GrpDialog/GrpBtn/BtnCancel/Btn_Cancel");
	self.mBtn_GrpBtn_BtnConfirm_Confim = self:GetButton("Root/GrpDialog/GrpBtn/BtnConfirm/Btn_Confim");
	self.mText_Num = self:GetText("Root/GrpDialog/GrpCenter/GrpGoldConsume/Text_Num");
	self.mText_GrpBtn_BtnCancel_Name = self:GetText("Root/GrpDialog/GrpBtn/BtnCancel/Btn_Cancel/Root/GrpText/Text_Name");
	self.mText_GrpBtn_BtnConfirm_Name = self:GetText("Root/GrpDialog/GrpBtn/BtnConfirm/Btn_Confim/Root/GrpText/Text_Name");
	self.mTrans_GrpBg = self:GetRectTransform("Root/GrpBg");
	self.mTrans_GrpTop = self:GetRectTransform("Root/GrpDialog/GrpTop");
	self.mTrans_Content = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpItemList/Content");
	self.mTrans_GrpBtn = self:GetRectTransform("Root/GrpDialog/GrpBtn");
	self.mTrans_GrpBtn_BtnCancel = self:GetRectTransform("Root/GrpDialog/GrpBtn/BtnCancel");
	self.mTrans_GrpBtn_BtnConfirm = self:GetRectTransform("Root/GrpDialog/GrpBtn/BtnConfirm");
end

--@@ GF Auto Gen Block End

function UIMixConfirmPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

-------ChrMentalMetarialCosumePanelV2--------