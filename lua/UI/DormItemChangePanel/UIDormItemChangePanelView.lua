require("UI.UIBaseView")

UIDormItemChangePanelView = class("UIDormItemChangePanelView", UIBaseView);
UIDormItemChangePanelView.__index = UIDormItemChangePanelView

--@@ GF Auto Gen Block Begin
UIDormItemChangePanelView.mBtn_back = nil;
UIDormItemChangePanelView.mBtn_Ensure = nil;
UIDormItemChangePanelView.mBtn_AreaA = nil;
UIDormItemChangePanelView.mBtn_AreaB = nil;
UIDormItemChangePanelView.mBtn_AreaC = nil;
UIDormItemChangePanelView.mBtn_AreaD = nil;
UIDormItemChangePanelView.mTrans_AreaButton = nil;
UIDormItemChangePanelView.mTrans_BarList = nil;

function UIDormItemChangePanelView:__InitCtrl()

	self.mBtn_back = self:GetButton("Btn_Close");
	self.mBtn_Ensure = self:GetButton("SelectPanel/SelectBg/Btn_Ensure");
	self.mBtn_AreaA = self:GetButton("SelectPanel/Trans_AreaButton/Btn_AreaA");
	self.mBtn_AreaB = self:GetButton("SelectPanel/Trans_AreaButton/Btn_AreaB");
	self.mBtn_AreaC = self:GetButton("SelectPanel/Trans_AreaButton/Btn_AreaC");
	self.mBtn_AreaD = self:GetButton("SelectPanel/Trans_AreaButton/Btn_AreaD");
	self.mTrans_AreaButton = self:GetRectTransform("SelectPanel/Trans_AreaButton");
	self.mTrans_BarList = self:GetRectTransform("SelectPanel/SelectArea/SelectItemArea/Trans_BarList");
end

--@@ GF Auto Gen Block End

function UIDormItemChangePanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end