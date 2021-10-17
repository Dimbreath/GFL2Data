require("UI.UIBaseCtrl")

TabDisplayItem = class("TabDisplayItem", UIBaseCtrl);
TabDisplayItem.__index = TabDisplayItem
--@@ GF Auto Gen Block Begin
TabDisplayItem.mImage_Normal = nil;
TabDisplayItem.mImage_Highlighted = nil;
TabDisplayItem.mImage_Selected = nil;
TabDisplayItem.mText_Name = nil;
TabDisplayItem.mBtn_GachaEventBtn = nil;

function TabDisplayItem:__InitCtrl()

	self.mImage_Normal = self:GetImage("Image_Normal");
	self.mImage_Highlighted = self:GetImage("Image_Highlighted");
	self.mImage_Selected = self:GetImage("Image_Selected");
	self.mText_Name = self:GetText("Text_Name");

	self.mBtn_GachaEventBtn = self:GetSelfButton();
end

--@@ GF Auto Gen Block End

TabDisplayItem.mEventData = nil;

function TabDisplayItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function TabDisplayItem:InitData(data)
	self.mEventData = data;
	
	self.mText_Name.text = data.Name;
	
	-- if(data.IsNormalEvent == false) then
	-- 	self.mText_Text.text = data.RemainTime;
	-- else
	-- 	setactive(self.mTrans_CountDown.gameObject, false);
	-- end
	
	self:SetSelect(false);
end

function TabDisplayItem:SetSelect(isSelect)
	--setactive(self.mImage_Selected.gameObject,isSelect);
	--setactive(self.mImage_Normal.gameObject,not isSelect);
	
	self.mBtn_GachaEventBtn.interactable =  (not isSelect);
end