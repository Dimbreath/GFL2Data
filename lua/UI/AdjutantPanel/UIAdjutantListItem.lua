require("UI.UIBaseCtrl")

UIAdjutantListItem = class("UIAdjutantListItem", UIBaseCtrl);
UIAdjutantListItem.__index = UIAdjutantListItem
--@@ GF Auto Gen Block Begin
UIAdjutantListItem.mBtn_Gun = nil;
UIAdjutantListItem.mImage_avatarImage = nil;
UIAdjutantListItem.mImage_unlock_rank = nil;
UIAdjutantListItem.mImage_unlock_rankHalf = nil;
UIAdjutantListItem.mImage_unlock_avatarImage = nil;
UIAdjutantListItem.mImage_unlock_ExpBar = nil;
UIAdjutantListItem.mImage_unlock_skillicon = nil;
UIAdjutantListItem.mText_unlock_LevelNum = nil;
UIAdjutantListItem.mTrans_locked = nil;
UIAdjutantListItem.mTrans_selected = nil;
UIAdjutantListItem.mTrans_unlock_selected = nil;
UIAdjutantListItem.mTrans_unlock_ConStars = nil;
UIAdjutantListItem.mTrans_Setting = nil;

function UIAdjutantListItem:__InitCtrl()

	self.mBtn_Gun = self:GetButton("Btn_Gun");
	self.mImage_avatarImage = self:GetImage("Trans_locked/avatarLocked/Image_avatarImage");
	self.mImage_unlock_rank = self:GetImage("UI_unlock/Image_rank");
	self.mImage_unlock_rankHalf = self:GetImage("UI_unlock/Image_rank/Image_rankHalf");
	self.mImage_unlock_avatarImage = self:GetImage("UI_unlock/avatar/Image_avatarImage");
	self.mImage_unlock_ExpBar = self:GetImage("UI_unlock/Image_ExpBar");
	self.mImage_unlock_skillicon = self:GetImage("UI_unlock/Skill/Image_skillicon");
	self.mText_unlock_LevelNum = self:GetText("UI_unlock/level/Text_LevelNum");
	self.mTrans_locked = self:GetRectTransform("Trans_locked");
	self.mTrans_unlock = self:GetRectTransform("UI_unlock");
	self.mTrans_selected = self:GetRectTransform("Trans_locked/Trans_selected");
	self.mTrans_unlock_selected = self:GetRectTransform("UI_unlock/Trans_selected");
	self.mTrans_unlock_ConStars = self:GetRectTransform("UI_unlock/Trans_ConStars");
	self.mTrans_Setting = self:GetRectTransform("Trans_Setting");
end

--@@ GF Auto Gen Block End

UIAdjutantListItem.mPath_item = "Adjustant/UIAdjutantListItem.prefab";
UIAdjutantListItem.mData = nil;

UIAdjutantListItem.mTrans_unlock = nil;

function UIAdjutantListItem:InitCtrl(parent)

	local obj=instantiate(UIUtils.GetGizmosPrefab(UIAdjutantListItem.mPath_item,self));
    self:SetRoot(obj.transform);
	--setparent(parent,obj.transform);
	obj.transform:SetParent(parent,false);
    obj.transform.localScale=vectorone;
    --self:SetRoot(obj.transform);
	self:__InitCtrl();

end


function UIAdjutantListItem:InitData(data)
	self.mData = data;

	if(data.isUnlocked) then
		setactive(self.mTrans_locked,false);
		setactive(self.mTrans_unlock,true);
	else
		setactive(self.mTrans_locked,true);
		setactive(self.mTrans_unlock,false);
	end
	self.mImage_avatarImage.sprite = IconUtils.GetCharacterHeadSprite(data.icon);
	self.mImage_unlock_avatarImage.sprite = IconUtils.GetCharacterHeadSprite(data.icon);
end

function UIAdjutantListItem:SetSelect(isSelect)
	setactive(self.mTrans_selected,isSelect);
	setactive(self.mTrans_unlock_selected,isSelect);
end