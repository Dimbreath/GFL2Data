require("UI.UIBaseView")

UIBaseResourceDetailPanelView = class("UIBaseResourceDetailPanelView", UIBaseView);
UIBaseResourceDetailPanelView.__index = UIBaseResourceDetailPanelView

--@@ GF Auto Gen Block Begin
UIBaseResourceDetailPanelView.mBtn_DetailReturn = nil;
UIBaseResourceDetailPanelView.mBtn_FacilityLvUpShortCut = nil;
UIBaseResourceDetailPanelView.mBtn_CollectBtn = nil;
UIBaseResourceDetailPanelView.mTrans_ResFacilityList = nil;

function UIBaseResourceDetailPanelView:__InitCtrl()

	self.mBtn_DetailReturn = self:GetButton("Btn_DetailReturn");
	self.mBtn_FacilityLvUpShortCut = self:GetButton("Btn_FacilityLvUpShortCut");
	self.mBtn_CollectBtn = self:GetButton("Btn_CollectBtn");
	self.mTrans_ResFacilityList = self:GetRectTransform("List/Trans_ResFacilityList");
end

--@@ GF Auto Gen Block End

function UIBaseResourceDetailPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end