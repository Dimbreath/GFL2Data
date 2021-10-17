require("UI.UIBaseView")

UIAutoBattleEndPanelView = class("UIAutoBattleEndPanelView", UIBaseView);
UIAutoBattleEndPanelView.__index = UIAutoBattleEndPanelView

--@@ GF Auto Gen Block Begin
UIAutoBattleEndPanelView.mBtn_PanelButton = nil;
UIAutoBattleEndPanelView.mImage_FillAft = nil;
UIAutoBattleEndPanelView.mImage_FillCur = nil;
UIAutoBattleEndPanelView.mText_endReason = nil;
UIAutoBattleEndPanelView.mText_PlusExp = nil;
UIAutoBattleEndPanelView.mText_ExpBar = nil;
UIAutoBattleEndPanelView.mText_LV = nil;
UIAutoBattleEndPanelView.mText_LVPlus = nil;
UIAutoBattleEndPanelView.mTrans_EndReason = nil;
UIAutoBattleEndPanelView.mTrans_itemRoot = nil;
UIAutoBattleEndPanelView.mTrans_DollRoot = nil;

function UIAutoBattleEndPanelView:__InitCtrl()

	self.mBtn_PanelButton = self:GetButton("Btn_PanelButton");
	self.mImage_FillAft = self:GetImage("Panel/CommenderExpGet/Back/commanderExp/Back/Image_FillAft");
	self.mImage_FillCur = self:GetImage("Panel/CommenderExpGet/Back/commanderExp/Back/Image_FillCur");
	self.mText_endReason = self:GetText("Trans_EndReason/Text_endReason");
	self.mText_PlusExp = self:GetText("Panel/CommenderExpGet/Back/commanderExp/Text_PlusExp");
	self.mText_ExpBar = self:GetText("Panel/CommenderExpGet/Back/commanderExp/Text_ExpBar");
	self.mText_LV = self:GetText("Panel/CommenderExpGet/Back/commanderExp/Text_LV");
	self.mText_LVPlus = self:GetText("Panel/CommenderExpGet/Back/commanderExp/Text_LVPlus");
	self.mTrans_EndReason = self:GetRectTransform("Trans_EndReason");
	self.mTrans_itemRoot = self:GetRectTransform("Panel/itemGet/ItemList/Trans_itemRoot");
	self.mTrans_DollRoot = self:GetRectTransform("Panel/DollExpGet/DollList/Trans_DollRoot");
end

--@@ GF Auto Gen Block End

function UIAutoBattleEndPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end