require("UI.UIBaseCtrl")

UIAdjutantSkinIconItem = class("UIAdjutantSkinIconItem", UIBaseCtrl)
UIAdjutantSkinIconItem.__index = UIAdjutantSkinIconItem
--@@ GF Auto Gen Block Begin
UIAdjutantSkinIconItem.mBtn_SkinIcon = nil;
UIAdjutantSkinIconItem.mImage_SkinIcon = nil;
UIAdjutantSkinIconItem.mTrans_ChoosePanel = nil;
UIAdjutantSkinIconItem.mTrans_SELPanel = nil;
UIAdjutantSkinIconItem.mTrans_LockedMask = nil;
UIAdjutantSkinIconItem.mTrans_NewPanel = nil;

function UIAdjutantSkinIconItem:__InitCtrl()

	self.mBtn_SkinIcon = self:GetButton("Btn_Image_SkinIcon");
	self.mImage_SkinIcon = self:GetImage("Btn_Image_SkinIcon");
	self.mTrans_ChoosePanel = self:GetRectTransform("Trans_ChoosePanel");
	self.mTrans_SELPanel = self:GetRectTransform("Trans_SELPanel");
	self.mTrans_LockedMask = self:GetRectTransform("Trans_LockedMask");
	self.mTrans_NewPanel = self:GetRectTransform("Trans_NewPanel");
end

--@@ GF Auto Gen Block End

UIAdjutantSkinIconItem.mData = nil
UIAdjutantSkinIconItem.IsDressed = false
UIAdjutantSkinIconItem.IsNew = false
UIAdjutantSkinIconItem.IsLocked = false
UIAdjutantSkinIconItem.IsClicked = false

UIAdjutantSkinIconItem.mPath_item = "Adjustant/UIAdjutantSkinIconItem.prefab";

function UIAdjutantSkinIconItem:InitCtrl(parent)
	local obj=instantiate(UIUtils.GetGizmosPrefab(UIAdjutantSkinIconItem.mPath_item,self));
    self:SetRoot(obj.transform);
	obj.transform:SetParent(parent,false);
    obj.transform.localScale=vectorone;
	self:__InitCtrl();
end

function UIAdjutantSkinIconItem:SetData(costumeData)
	self.mData = costumeData
	self.mImage_SkinIcon.sprite = IconUtils.GetIconSprite(CS.GF2Icon.Costumes, costumeData.icon)

	self.IsLocked = not NetCmdIllustrationData:CheckCostumeUnlocked(costumeData.id);

	self:SetState();
end

function UIAdjutantSkinIconItem:EnableSkinItem(enable)
	setactive(self:GetRoot().gameObject, enable)
end

function UIAdjutantSkinIconItem:SetState()
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

function UIAdjutantSkinIconItem:SetClicked(isClick)
	self.IsClicked = isClick
	self:SetState()
end

function UIAdjutantSkinIconItem:GetData()
	return self.mData
end
