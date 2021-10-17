require("UI.UIBaseView")

UICarrierPartDetailPanelView = class("UICarrierPartDetailPanelView", UIBaseView);
UICarrierPartDetailPanelView.__index = UICarrierPartDetailPanelView

--@@ GF Auto Gen Block Begin
UICarrierPartDetailPanelView.mBtn_Panel_Exit = nil;
UICarrierPartDetailPanelView.mBtn_Panel_Powerup = nil;
UICarrierPartDetailPanelView.mBtn_PowerUpPanel_AddMaterial = nil;
UICarrierPartDetailPanelView.mBtn_PowerUpPanel_Back = nil;
UICarrierPartDetailPanelView.mBtn_PowerUpPanel_PowerUpButton = nil;
UICarrierPartDetailPanelView.mImage_Panel_Rank = nil;
UICarrierPartDetailPanelView.mImage_Panel_Icon = nil;
UICarrierPartDetailPanelView.mImage_PowerUpPanel_PartIcon = nil;
UICarrierPartDetailPanelView.mImage_PowerUpPanel_Rank = nil;
UICarrierPartDetailPanelView.mImage_PowerUpPanel_AftFill = nil;
UICarrierPartDetailPanelView.mImage_PowerUpPanel_CurFill = nil;
UICarrierPartDetailPanelView.mText_Panel_Type = nil;
UICarrierPartDetailPanelView.mText_Panel_Level = nil;
UICarrierPartDetailPanelView.mText_Panel_Name = nil;
UICarrierPartDetailPanelView.mText_Panel_Introduction = nil;
UICarrierPartDetailPanelView.mText_PowerUpPanel_PartName = nil;
UICarrierPartDetailPanelView.mText_PowerUpPanel_Level = nil;
UICarrierPartDetailPanelView.mText_PowerUpPanel_Type = nil;
UICarrierPartDetailPanelView.mText_PowerUpPanel_Before_CurrentLevel = nil;
UICarrierPartDetailPanelView.mText_PowerUpPanel_After_NextLevel = nil;
UICarrierPartDetailPanelView.mText_PowerUpPanel_ExpText = nil;
UICarrierPartDetailPanelView.mText_PowerUpPanel_CoinCost = nil;
UICarrierPartDetailPanelView.mTrans_Panel_PropertyLayout = nil;
UICarrierPartDetailPanelView.mTrans_PowerUpPanel = nil;
UICarrierPartDetailPanelView.mTrans_PowerUpPanel_MaterialList = nil;
UICarrierPartDetailPanelView.mTrans_PowerUpPanel_PartSelectorMark = nil;
UICarrierPartDetailPanelView.mTrans_PowerUpPanel_Before_PropertyLayout = nil;
UICarrierPartDetailPanelView.mTrans_PowerUpPanel_After_PropertyLayout = nil;
UICarrierPartDetailPanelView.mTrans_PowerUpPanel_After_MaxMask = nil;
UICarrierPartDetailPanelView.mTrans_PowerUpPanel_LVUP = nil;

function UICarrierPartDetailPanelView:__InitCtrl()

	self.mBtn_Panel_Exit = self:GetButton("UI_Panel/TitleBar/Btn_Exit");
	self.mBtn_Panel_Powerup = self:GetButton("UI_Panel/Btn_Powerup");
	self.mBtn_PowerUpPanel_AddMaterial = self:GetButton("UI_Trans_PowerUpPanel/Material/Btn_AddMaterial");
	self.mBtn_PowerUpPanel_Back = self:GetButton("UI_Trans_PowerUpPanel/ButtomBar/Btn_Back");
	self.mBtn_PowerUpPanel_PowerUpButton = self:GetButton("UI_Trans_PowerUpPanel/ButtomBar/Btn_PowerUpButton");
	self.mImage_Panel_Rank = self:GetImage("UI_Panel/IconFrame/Image_Rank");
	self.mImage_Panel_Icon = self:GetImage("UI_Panel/IconFrame/Image_Icon");
	self.mImage_PowerUpPanel_PartIcon = self:GetImage("UI_Trans_PowerUpPanel/TopBar/Icon/Image_PartIcon");
	self.mImage_PowerUpPanel_Rank = self:GetImage("UI_Trans_PowerUpPanel/TopBar/Image_Rank");
	self.mImage_PowerUpPanel_AftFill = self:GetImage("UI_Trans_PowerUpPanel/ButtomBar/Exp/FillArea/Image_AftFill");
	self.mImage_PowerUpPanel_CurFill = self:GetImage("UI_Trans_PowerUpPanel/ButtomBar/Exp/FillArea/Image_CurFill");
	self.mText_Panel_Type = self:GetText("UI_Panel/Type/Text_Type");
	self.mText_Panel_Level = self:GetText("UI_Panel/Level/Text_Level");
	self.mText_Panel_Name = self:GetText("UI_Panel/Text_Name");
	self.mText_Panel_Introduction = self:GetText("UI_Panel/Text_Introduction");
	self.mText_PowerUpPanel_PartName = self:GetText("UI_Trans_PowerUpPanel/TopBar/Name/Text_PartName");
	self.mText_PowerUpPanel_Level = self:GetText("UI_Trans_PowerUpPanel/TopBar/Lv/Text_Level");
	self.mText_PowerUpPanel_Type = self:GetText("UI_Trans_PowerUpPanel/TopBar/Type/Text_Type");
	self.mText_PowerUpPanel_Before_CurrentLevel = self:GetText("UI_Trans_PowerUpPanel/Effect/UI_Before/Top/Text_CurrentLevel");
	self.mText_PowerUpPanel_After_NextLevel = self:GetText("UI_Trans_PowerUpPanel/Effect/UI_After/Top/Text_NextLevel");
	self.mText_PowerUpPanel_ExpText = self:GetText("UI_Trans_PowerUpPanel/ButtomBar/Exp/Text_ExpText");
	self.mText_PowerUpPanel_CoinCost = self:GetText("UI_Trans_PowerUpPanel/ButtomBar/CoinCost/Text_CoinCost");
	self.mTrans_Panel_PropertyLayout = self:GetRectTransform("UI_Panel/Trans_PropertyLayout");
	self.mTrans_PowerUpPanel = self:GetRectTransform("UI_Trans_PowerUpPanel");
	self.mTrans_PowerUpPanel_MaterialList = self:GetRectTransform("UI_Trans_PowerUpPanel/Material/Trans_MaterialList");
	self.mTrans_PowerUpPanel_PartSelectorMark = self:GetRectTransform("UI_Trans_PowerUpPanel/Material/Trans_MaterialList/Trans_PartSelectorMark");
	self.mTrans_PowerUpPanel_Before_PropertyLayout = self:GetRectTransform("UI_Trans_PowerUpPanel/Effect/UI_Before/Trans_PropertyLayout");
	self.mTrans_PowerUpPanel_After_PropertyLayout = self:GetRectTransform("UI_Trans_PowerUpPanel/Effect/UI_After/Trans_PropertyLayout");
	self.mTrans_PowerUpPanel_After_MaxMask = self:GetRectTransform("UI_Trans_PowerUpPanel/Effect/UI_After/Trans_MaxMask");
	self.mTrans_PowerUpPanel_LVUP = self:GetRectTransform("UI_Trans_PowerUpPanel/ButtomBar/Exp/Trans_LVUP");
end

--@@ GF Auto Gen Block End

function UICarrierPartDetailPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end