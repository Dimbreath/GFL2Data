require("UI.UIBaseCtrl")
require("UI.Tips.TipsManager")

UICombatLauncherDropListItem = class("UICombatLauncherDropListItem", UIBaseCtrl);
UICombatLauncherDropListItem.__index = UICombatLauncherDropListItem
--@@ GF Auto Gen Block Begin
UICombatLauncherDropListItem.mImage_ItemQualityImage = nil;
UICombatLauncherDropListItem.mImage_Icon = nil;
UICombatLauncherDropListItem.mText_Count = nil;
UICombatLauncherDropListItem.mTrans_ItemNumberbg = nil;

function UICombatLauncherDropListItem:__InitCtrl()

	self.mImage_ItemQualityImage = self:GetImage("Image_ItemQualityImage");
	self.mImage_Icon = self:GetImage("IconMask/Image_Icon");
	self.mImage_Head = self:GetImage("IconMask/Trans_HeadBG/mask/Image_Head")
	self.mText_Count = self:GetText("Text_Count");
	self.mTrans_ItemNumberbg = self:GetRectTransform("Trans_ItemNumberbg");
	self.mTrans_HeadBG = self:GetRectTransform("IconMask/Trans_HeadBG")
end

--@@ GF Auto Gen Block End

function UICombatLauncherDropListItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UICombatLauncherDropListItem:InitData(itemId, itemNum, needGetWay)
	needGetWay = needGetWay == true and true or false
	local itemData = TableData.GetItemData(itemId);
	if not itemData then
		printstack("找不到ItemID为： " .. itemId .. "的物品")
		return
	end
	setactive(self.mImage_Icon.gameObject, itemData.type ~= 4)
	setactive(self.mTrans_HeadBG.gameObject, itemData.type == 4)

	self.mImage_ItemQualityImage.color = self:GetColorByRank(itemData.rank)
	self.mText_Count.text = itemNum;
	if itemData.type ~= 4 then
		self.mImage_Icon.sprite = IconUtils.GetItemIconSprite(itemData.id)
	else
		self.mImage_Head.sprite = IconUtils.GetItemIconSprite(itemData.id)
	end

	local show = tonumber(itemNum) > 0;
	local itemCount = itemNum > 0 and itemNum or nil
	setactive(self.mText_Count.gameObject,show);
	-- setactive(self.mTrans_ItemNumberbg.gameObject,show);
	TipsManager.Add(self.mUIRoot.gameObject, itemData, itemCount, needGetWay);
end

function UICombatLauncherDropListItem:GetColorByRank(rank)
	local color = ""
	if rank == 1 then
		color = "ececec"
	elseif rank == 2 then
		color = "aef300"
	elseif rank == 3 then
		color = "52c9ff"
	elseif rank == 4 then
		color = "8f66f7"
	elseif rank == 5 then
		color = "ff5001"
	elseif rank == 6 then
		 color = "ffc000"
	end
	return CS.GF2.UI.UITool.StringToColor(color)
end
