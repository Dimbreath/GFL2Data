require("UI.UIBaseView")

UIGachaMainPanelView = class("UIGachaMainPanelView", UIBaseView);
UIGachaMainPanelView.__index = UIGachaMainPanelView

--@@ GF Auto Gen Block Begin
UIGachaMainPanelView.mBtn_GetOne = nil;
UIGachaMainPanelView.mBtn_GetTen = nil;
UIGachaMainPanelView.mBtn_OpenGachaList = nil;
UIGachaMainPanelView.mBtn_Shop = nil;
UIGachaMainPanelView.mBtn_Close = nil;
UIGachaMainPanelView.mImage_Background = nil;
UIGachaMainPanelView.mImage_GetOne_Normal = nil;
UIGachaMainPanelView.mImage_GetTen_Normal = nil;
UIGachaMainPanelView.mImage_Normal = nil;
UIGachaMainPanelView.mImage_Highlighted = nil;
UIGachaMainPanelView.mImage_Selected = nil;
UIGachaMainPanelView.mText_GetOne_GetOneCost = nil;
UIGachaMainPanelView.mText_GetTen_GetTenCost = nil;
UIGachaMainPanelView.mText_100Must = nil;
UIGachaMainPanelView.mText_Name = nil;
UIGachaMainPanelView.mTrans_100Must = nil;

function UIGachaMainPanelView:__InitCtrl()

	self.mBtn_GetOne = self:GetButton("Root/GetGachaBTNPanel/UI_Btn_GetOne");
	self.mBtn_GetTen = self:GetButton("Root/GetGachaBTNPanel/UI_Btn_GetTen");
	self.mBtn_OpenGachaList = self:GetButton("Root/Btn_OpenGachaList");
	self.mBtn_Shop = self:GetButton("Root/Btn_Shop");
	self.mBtn_Close = self:GetButton("Root/Btn_Close");
	self.mImage_Background = self:GetImage("Root/Image_Banner/Image_Background");
	self.mImage_GetOne_Normal = self:GetImage("Root/GetGachaBTNPanel/UI_Btn_GetOne/Image_Normal");
	self.mImage_GetTen_Normal = self:GetImage("Root/GetGachaBTNPanel/UI_Btn_GetTen/Image_Normal");
	--self.mImage_Normal = self:GetImage("Root/CardList/Viewport/Content/CardDisplayItem/Image_Normal");
	--self.mImage_Highlighted = self:GetImage("Root/CardList/Viewport/Content/CardDisplayItem/Image_Highlighted");
	--self.mImage_Selected = self:GetImage("Root/CardList/Viewport/Content/CardDisplayItem/Image_Selected");
	self.mText_GetOne_GetOneCost = self:GetText("Root/GetGachaBTNPanel/UI_Btn_GetOne/CostPanel/Cost/Text_GetOneCost");
	self.mText_GetTen_GetTenCost = self:GetText("Root/GetGachaBTNPanel/UI_Btn_GetTen/GACHAInfoPanel/Panel/Text_GetTenCost");
	self.mText_100Must = self:GetText("Root/Trans_Text_100Must");
	--self.mText_Name = self:GetText("Root/CardList/Viewport/Content/CardDisplayItem/Text_Name");
	self.mTrans_100Must = self:GetRectTransform("Root/Trans_Text_100Must");
end

--@@ GF Auto Gen Block End

UIGachaMainPanelView.mLayout_TabList = nil;

UIGachaMainPanelView.mVideoBgCanvas = nil;
UIGachaMainPanelView.mText_Lefttime = nil;

function UIGachaMainPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mLayout_TabList = self:GetRectTransform("Root/CardList/Viewport/Content");
	self.mVideoBgCanvas = CS.UnityEngine.GameObject.Find("3DFormationCanvasBG");
	self.mText_Lefttime = self:GetText("Root/Text_Lefttime");

end