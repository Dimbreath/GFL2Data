require("UI.UIBaseCtrl")

Btn_CharacterSlotsItem = class("Btn_CharacterSlotsItem", UIBaseCtrl);
Btn_CharacterSlotsItem.__index = Btn_CharacterSlotsItem
--@@ GF Auto Gen Block Begin
Btn_CharacterSlotsItem.mBtn_CharacterSlotsItem = nil;
Btn_CharacterSlotsItem.mImage_characterPic = nil;
Btn_CharacterSlotsItem.mText_characterName = nil;
Btn_CharacterSlotsItem.mTrans_Unlocked = nil;
Btn_CharacterSlotsItem.mTrans_Chosen = nil;

function Btn_CharacterSlotsItem:__InitCtrl()

	self.mBtn_CharacterSlotsItem = self:GetSelfButton();
	self.mImage_characterPic = self:GetImage("Image_characterPic");
	self.mText_characterName = self:GetText("Image_characterPic/Text_characterName");
	self.mTrans_Unlocked = self:GetRectTransform("Trans_Unlocked");
	self.mTrans_Chosen = self:GetRectTransform("Image_characterPic/Trans_Chosen");
end

--@@ GF Auto Gen Block End

Btn_CharacterSlotsItem.mPath_item = "Dorm/Btn_CharacterSlotsItem.prefab";
Btn_CharacterSlotsItem.mData = nil;

function Btn_CharacterSlotsItem:InitCtrl(parent)

	local obj=instantiate(UIUtils.GetGizmosPrefab(Btn_CharacterSlotsItem.mPath_item,self));
    self:SetRoot(obj.transform);
	obj.transform:SetParent(parent,false);
    obj.transform.localScale=vectorone;
	self:__InitCtrl();

end


function Btn_CharacterSlotsItem:SetData(data)
	self.mData = data

	setactive(self.mImage_characterPic.gameObject,true);
	
	self.mText_characterName.text = data.name.str;
end


function Btn_CharacterSlotsItem:SetSelect(isSelect)
	setactive(self.mTrans_Chosen.gameObject,isSelect);
end