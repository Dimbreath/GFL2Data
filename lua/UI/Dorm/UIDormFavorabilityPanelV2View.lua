require("UI.UIBaseView")

UIDormFavorabilityPanelV2View = class("UIDormFavorabilityPanelV2View", UIBaseView);
UIDormFavorabilityPanelV2View.__index = UIDormFavorabilityPanelV2View

--@@ GF Auto Gen Block Begin
UIDormFavorabilityPanelV2View.mBtn_Close = nil;

function UIDormFavorabilityPanelV2View:__InitCtrl()

	self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"));
    self.mBtn_Home = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"));

    self.mRadarBefore = self:GetRectTransform("Root/Content/GrpCoordinate/Content/GrpState/ImageBefore"):GetComponent("SquareRadar")
    self.mRadarAfter = self:GetRectTransform("Root/Content/GrpCoordinate/Content/GrpState/ImageAfter"):GetComponent("SquareRadar")
end

--@@ GF Auto Gen Block End

UIDormFavorabilityPanelV2View.mTrans_Content = nil;

function UIDormFavorabilityPanelV2View:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end