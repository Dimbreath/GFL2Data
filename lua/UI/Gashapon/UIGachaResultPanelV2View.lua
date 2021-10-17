require("UI.UIBaseView")

---@class UIGachaResultPanelV2View : UIBaseView
UIGachaResultPanelV2View = class("UIGachaResultPanelV2View", UIBaseView);
UIGachaResultPanelV2View.__index = UIGachaResultPanelV2View

--@@ GF Auto Gen Block Begin
UIGachaResultPanelV2View.mBtn_Close = nil;
UIGachaResultPanelV2View.mImg_Icon = nil;
UIGachaResultPanelV2View.mText_Next = nil;
UIGachaResultPanelV2View.mText_Name = nil;
UIGachaResultPanelV2View.mText_X = nil;
UIGachaResultPanelV2View.mText_Num = nil;
UIGachaResultPanelV2View.mContent_Card = nil;
UIGachaResultPanelV2View.mList_Card = nil;

function UIGachaResultPanelV2View:__InitCtrl()

	self.mBtn_Close = self:GetButton("Root/Btn_Close");
	self.mImg_Icon = self:GetImage("Root/GrpExtraGet/GrpIcon/Img_Icon");
	self.mText_Next = self:GetText("Root/GrpTextNext/NextText");
	self.mText_Name = self:GetText("Root/GrpExtraGet/GrpTextName/Text_Name");
	self.mText_Num = self:GetText("Root/GrpExtraGet/GrpTextNum/Text_Num");
	self.mContent_Card = self:GetHorizontalLayoutGroup("Root/GrpCard/GrpCardList/Viewport/Content");
	self.mList_Card = self:GetScrollRect("Root/GrpCard/GrpCardList");
end

--@@ GF Auto Gen Block End

function UIGachaResultPanelV2View:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end