require("UI.UIBaseCtrl")

UISkinIconItem = class("UISkinIconItem", UIBaseCtrl)
UISkinIconItem.__index = UISkinIconItem
--@@ GF Auto Gen Block Begin
UISkinIconItem.mBtn_SkinIcon = nil
UISkinIconItem.mImage_SkinIcon = nil
UISkinIconItem.mTrans_ChoosePanel = nil
UISkinIconItem.mTrans_SELPanel = nil
UISkinIconItem.mTrans_LockedMask = nil
UISkinIconItem.mTrans_UnavailableMask = nil
UISkinIconItem.mTrans_NewPanel = nil

function UISkinIconItem:__InitCtrl()

	self.mBtn_SkinIcon = self:GetButton("Btn_Image_SkinIcon")
	self.mImage_SkinIcon = self:GetImage("Btn_Image_SkinIcon")
	self.mTrans_ChoosePanel = self:GetRectTransform("Trans_ChoosePanel")
	self.mTrans_SELPanel = self:GetRectTransform("Trans_SELPanel")
	self.mTrans_LockedMask = self:GetRectTransform("Trans_LockedMask")
	self.mTrans_UnavailableMask = self:GetRectTransform("Trans_LockedMask/Trans_UnavailableMask")
	self.mTrans_NewPanel = self:GetRectTransform("Trans_NewPanel")
end

--@@ GF Auto Gen Block End

UISkinIconItem.mData = nil
UISkinIconItem.IsDressed = false
UISkinIconItem.IsNew = false
UISkinIconItem.IsLocked = false
UISkinIconItem.IsClicked = false

function UISkinIconItem:InitCtrl(root)

	self:SetRoot(root)

	self:__InitCtrl()

end

function UISkinIconItem:SetData(costumeData)
	self.mData = costumeData
	self.mImage_SkinIcon.sprite = IconUtils.GetIconSprite(CS.GF2Icon.Costumes, costumeData.icon)
end

function UISkinIconItem:EnableSkinItem(enable)
	setactive(self:GetRoot().gameObject, enable)
end

function UISkinIconItem:SetState()
	setactive(self.mTrans_SELPanel.gameObject, self.IsDressed)
	setactive(self.mTrans_ChoosePanel.gameObject, self.IsClicked)
	if self.IsDressed then
		setactive(self.mTrans_NewPanel.gameObject, false)
		setactive(self.mTrans_LockedMask.gameObject, false)
	else
		setactive(self.mTrans_NewPanel.gameObject, self.IsNew)
		setactive(self.mTrans_LockedMask.gameObject, self.IsLocked)
	end
end

function UISkinIconItem:SetClicked(isClick)
	self.IsClicked = isClick
	self:SetState()
end

function UISkinIconItem:GetData()
	return self.mData
end
