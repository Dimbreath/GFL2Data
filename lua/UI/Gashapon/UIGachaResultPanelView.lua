require("UI.UIBaseView")

UIGachaResultPanelView = class("UIGachaResultPanelView", UIBaseView);
UIGachaResultPanelView.__index = UIGachaResultPanelView

--@@ GF Auto Gen Block Begin
UIGachaResultPanelView.mBtn_Confirm = nil;
UIGachaResultPanelView.mBtn_GetOne = nil;
UIGachaResultPanelView.mBtn_GetTen = nil;
UIGachaResultPanelView.mText_100Must = nil;
UIGachaResultPanelView.mText_X = nil;
UIGachaResultPanelView.mText_GetOneCost = nil;
UIGachaResultPanelView.mText_CostGroup_CostPanel_X = nil;
UIGachaResultPanelView.mText_CostGroup_CostPanel_GetOneCost = nil;
UIGachaResultPanelView.mText_CostGroup_CostPanel_GetTenCost = nil;
UIGachaResultPanelView.mTrans_Confirm_CanClickOrange = nil;
UIGachaResultPanelView.mTrans_Confirm_CanClickWhite = nil;
UIGachaResultPanelView.mTrans_Confirm_NotClickGrey = nil;
UIGachaResultPanelView.mTrans_Confirm_Details = nil;
UIGachaResultPanelView.mTrans_BtnGetOne = nil;
UIGachaResultPanelView.mTrans_GetOne_CanClickOrange = nil;
UIGachaResultPanelView.mTrans_GetOne_CanClickWhite = nil;
UIGachaResultPanelView.mTrans_GetOne_NotClickGrey = nil;
UIGachaResultPanelView.mTrans_GetOne_Details = nil;
UIGachaResultPanelView.mTrans_BtnGetTen = nil;
UIGachaResultPanelView.mTrans_GetTen_CanClickOrange = nil;
UIGachaResultPanelView.mTrans_GetTen_CanClickWhite = nil;
UIGachaResultPanelView.mTrans_GetTen_NotClickGrey = nil;
UIGachaResultPanelView.mTrans_GetTen_Details = nil;

function UIGachaResultPanelView:__InitCtrl()

	self.mBtn_Confirm = self:GetButton("GetGachaBTNPanel/BtnConfirm/UI_Btn_Confirm");
	self.mBtn_GetOne = self:GetButton("GetGachaBTNPanel/Trans_BtnGetOne/UI_Btn_GetOne");
	self.mBtn_GetTen = self:GetButton("GetGachaBTNPanel/Trans_BtnGetTen/UI_Btn_GetTen");
	self.mText_100Must = self:GetText("100MustGet/Img100MustGetBg/Text_100Must");
	self.mText_X = self:GetText("GetGachaBTNPanel/BtnConfirm/CostGroup/CostPanel/Cost/Text_X");
	self.mText_GetOneCost = self:GetText("GetGachaBTNPanel/BtnConfirm/CostGroup/CostPanel/Cost/Text_GetOneCost");
	self.mText_CostGroup_CostPanel_X = self:GetText("GetGachaBTNPanel/Trans_BtnGetOne/UI_CostGroup/UI_CostPanel/Cost/Text_X");
	self.mText_CostGroup_CostPanel_GetOneCost = self:GetText("GetGachaBTNPanel/Trans_BtnGetOne/UI_CostGroup/UI_CostPanel/Cost/Text_GetOneCost");
	self.mText_CostGroup_CostPanel_GetTenCost = self:GetText("GetGachaBTNPanel/Trans_BtnGetTen/UI_CostGroup/UI_CostPanel/Cost/Text_GetTenCost");
	self.mTrans_Confirm_CanClickOrange = self:GetRectTransform("GetGachaBTNPanel/BtnConfirm/UI_Btn_Confirm/Trans_CanClickOrange");
	self.mTrans_Confirm_CanClickWhite = self:GetRectTransform("GetGachaBTNPanel/BtnConfirm/UI_Btn_Confirm/Trans_CanClickWhite");
	self.mTrans_Confirm_NotClickGrey = self:GetRectTransform("GetGachaBTNPanel/BtnConfirm/UI_Btn_Confirm/Trans_NotClickGrey");
	self.mTrans_Confirm_Details = self:GetRectTransform("GetGachaBTNPanel/BtnConfirm/UI_Btn_Confirm/Trans_Details");
	self.mTrans_BtnGetOne = self:GetRectTransform("GetGachaBTNPanel/Trans_BtnGetOne");
	self.mTrans_GetOne_CanClickOrange = self:GetRectTransform("GetGachaBTNPanel/Trans_BtnGetOne/UI_Btn_GetOne/Trans_CanClickOrange");
	self.mTrans_GetOne_CanClickWhite = self:GetRectTransform("GetGachaBTNPanel/Trans_BtnGetOne/UI_Btn_GetOne/Trans_CanClickWhite");
	self.mTrans_GetOne_NotClickGrey = self:GetRectTransform("GetGachaBTNPanel/Trans_BtnGetOne/UI_Btn_GetOne/Trans_NotClickGrey");
	self.mTrans_GetOne_Details = self:GetRectTransform("GetGachaBTNPanel/Trans_BtnGetOne/UI_Btn_GetOne/Trans_Details");
	self.mTrans_BtnGetTen = self:GetRectTransform("GetGachaBTNPanel/Trans_BtnGetTen");
	self.mTrans_GetTen_CanClickOrange = self:GetRectTransform("GetGachaBTNPanel/Trans_BtnGetTen/UI_Btn_GetTen/Trans_CanClickOrange");
	self.mTrans_GetTen_CanClickWhite = self:GetRectTransform("GetGachaBTNPanel/Trans_BtnGetTen/UI_Btn_GetTen/Trans_CanClickWhite");
	self.mTrans_GetTen_NotClickGrey = self:GetRectTransform("GetGachaBTNPanel/Trans_BtnGetTen/UI_Btn_GetTen/Trans_NotClickGrey");
	self.mTrans_GetTen_Details = self:GetRectTransform("GetGachaBTNPanel/Trans_BtnGetTen/UI_Btn_GetTen/Trans_Details");
end

--@@ GF Auto Gen Block End

UIGachaResultPanelView.mTrans_ListLayout = nil;

function UIGachaResultPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	
	self.mTrans_ListLayout = self:GetRectTransform("CardList/Viewport/Content");

end

function UIGachaResultPanelView.ShowSkip()
	self = UIGachaResultPanelView;
	--setactive(self.mBtn_GetTen,false);
	--setactive(self.mBtn_GetOne,false);
	--setactive(self.mBtn_SkipFlipBtn,true);
	--setactive(self.mBtn_ConfirmBtn,false);
end


function UIGachaResultPanelView.ShowConfirm()
	self = UIGachaResultPanelView;
	--setactive(self.mBtn_GetOne,true);
	--setactive(self.mBtn_GetTen,true);
	--setactive(self.mBtn_SkipFlipBtn,false);
	--setactive(self.mBtn_Confirm,true);
end

function UIGachaResultPanelView.HideConfirm()
	self = UIGachaResultPanelView;
	--setactive(self.mBtn_Confirm,false);
end


function UIGachaResultPanelView.HideDrawButtons()
	self = UIGachaResultPanelView;
	--setactive(self.mBtn_GetTen,false);
	--setactive(self.mBtn_GetOne,false);
	--setactive(self.mBtn_Confirm,false);
end