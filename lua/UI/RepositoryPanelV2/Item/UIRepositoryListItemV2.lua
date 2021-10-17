require("UI.UIBaseCtrl")

---@class UIRepositoryListItemV2 : UIBaseCtrl
UIRepositoryListItemV2 = class("UIRepositoryListItemV2", UIBaseCtrl);
UIRepositoryListItemV2.__index = UIRepositoryListItemV2
--@@ GF Auto Gen Block Begin
UIRepositoryListItemV2.mImg_Icon = nil;
UIRepositoryListItemV2.mText_Name = nil;
UIRepositoryListItemV2.mText_Sub = nil;

function UIRepositoryListItemV2:__InitCtrl()

	self.mImg_Icon = self:GetImage("GrpTittleItem/GrpIcon/Img_Icon");
	self.mText_Name = self:GetText("GrpTittleItem/GrpTittle/TextName");
	self.mText_Sub = self:GetText("GrpTittleItem/TextSub");

	self.mTrans_ItemList = self:GetRectTransform("GrpResList")
end

--@@ GF Auto Gen Block End

function UIRepositoryListItemV2:ctor()
	self.itemList = {}
end

function UIRepositoryListItemV2:InitCtrl(parent)
	self.parent = parent

	local obj = instantiate(UIUtils.GetGizmosPrefab("Repository/RepositoryListItemV2.prefab", self))
	self:SetRoot(obj.transform)
	obj.transform:SetParent(parent, false)
	obj.transform.localScale = vectorone

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIRepositoryListItemV2:SetData(data)
	self.mData = data
	if data then
		self.mText_Name.text = data.title.str
		self.mImg_Icon.sprite = IconUtils.GetRepositoryIcon(data.icon)
	end
end

function UIRepositoryListItemV2:UpdateItemList()
	if self.mData then
		local itemDataList = NetCmdItemData:GetRepositoryItemListByType(self.mData.item_type)
		for i = 0, itemDataList.Count - 1 do
			local itemData = itemDataList[i]
			local item = nil
			if i + 1 > #self.itemList then
				item = UICommonItem.New()
				item:InitCtrl(self.mTrans_ItemList)
				table.insert(self.itemList, item)
			else
				item = self.itemList[i + 1]
			end
			item:SetItemData(itemData.item_id, itemData.item_num, false, false, itemData.item_num)
		end
	end
end

function UIRepositoryListItemV2:OnRelease()
	self.itemList = {}
end