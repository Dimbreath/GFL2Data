require("UI.UIBaseView")

UIMotherBasePanelView = class("UIMotherBasePanelView", UIBaseView);
UIMotherBasePanelView.__index = UIMotherBasePanelView

--@@ GF Auto Gen Block Begin
UIMotherBasePanelView.mBtn_ProductionDetail = nil;
UIMotherBasePanelView.mBtn_CollectRes = nil;
UIMotherBasePanelView.mBtn_FacilityManagement = nil;
UIMotherBasePanelView.mBtn_GoToStore = nil;
UIMotherBasePanelView.mBtn_GoToMail = nil;
UIMotherBasePanelView.mBtn_GoToPost = nil;
UIMotherBasePanelView.mTrans_ResourceList = nil;

function UIMotherBasePanelView:__InitCtrl()

	self.mBtn_ProductionDetail = self:GetButton("BaseResoursePanel/Panel/Btn_ProductionDetail");
	self.mBtn_CollectRes = self:GetButton("BaseResoursePanel/Btn_CollectRes");
	self.mBtn_FacilityManagement = self:GetButton("Btn_FacilityManagement");
	self.mBtn_GoToStore = self:GetButton("Btn_GoToStore");
	self.mBtn_GoToMail = self:GetButton("Btn_GoToMail");
	self.mBtn_GoToPost = self:GetButton("Btn_GoToPost");
	self.mTrans_ResourceList = self:GetRectTransform("BaseResoursePanel/Trans_ResourceList");
end

--@@ GF Auto Gen Block End

function UIMotherBasePanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end