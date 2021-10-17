require("UI.UIBaseView")

UIDormCharacterSkinPanelView = class("UIDormCharacterSkinPanelView", UIBaseView);
UIDormCharacterSkinPanelView.__index = UIDormCharacterSkinPanelView

--@@ GF Auto Gen Block Begin
UIDormCharacterSkinPanelView.mBtn_back = nil;
UIDormCharacterSkinPanelView.mBtn_Ensure = nil;
UIDormCharacterSkinPanelView.mTrans_BarList = nil;

function UIDormCharacterSkinPanelView:__InitCtrl()

	self.mBtn_back = self:GetButton("Btn_back");
	self.mBtn_Ensure = self:GetButton("SelectPanel/SelectBg/Btn_Ensure");
	self.mTrans_BarList = self:GetRectTransform("SelectPanel/SelectArea/SelectItemArea/Trans_BarList");
end

--@@ GF Auto Gen Block End

function UIDormCharacterSkinPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end