require("UI.UIBaseView")

UIDormCharacterSelectPanelView = class("UIDormCharacterSelectPanelView", UIBaseView);
UIDormCharacterSelectPanelView.__index = UIDormCharacterSelectPanelView

--@@ GF Auto Gen Block Begin
UIDormCharacterSelectPanelView.mBtn_CharacterSlotsAdd = nil;
UIDormCharacterSelectPanelView.mBtn_Ensure = nil;
UIDormCharacterSelectPanelView.mBtn_CommandCenter = nil;
UIDormCharacterSelectPanelView.mBtn_Close = nil;
UIDormCharacterSelectPanelView.mTrans_characterSelect = nil;

function UIDormCharacterSelectPanelView:__InitCtrl()

	self.mBtn_CharacterSlotsAdd = self:GetButton("CharacterSelectArea/SelectArea/Btn_CharacterSlotsAdd");
	self.mBtn_Ensure = self:GetButton("Trans_characterSelect/bg/Btn_Ensure");
	self.mBtn_CommandCenter = self:GetButton("Btn_CommandCenter");
	self.mBtn_Close = self:GetButton("Btn_Close");
	self.mTrans_characterSelect = self:GetRectTransform("Trans_characterSelect");
end

--@@ GF Auto Gen Block End

UIDormCharacterSelectPanelView.mTrans_AddSlotList = nil;
UIDormCharacterSelectPanelView.mTrans_AddCharacterList = nil;

function UIDormCharacterSelectPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mTrans_AddSlotList = self:GetRectTransform("CharacterSelectArea/SelectArea/CharacterSlots/content");
	self.mTrans_AddCharacterList = self:GetRectTransform("Trans_characterSelect/bg/scroll/viewport/content");
end