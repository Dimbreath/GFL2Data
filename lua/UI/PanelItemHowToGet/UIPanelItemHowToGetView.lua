require("UI.UIBaseView")
require("UI.PanelItemHowToGet.UIHowToGetTypeItem")

UIPanelItemHowToGetView = class("UIPanelItemHowToGetView", UIBaseView);
UIPanelItemHowToGetView.__index = UIPanelItemHowToGetView

--@@ GF Auto Gen Block Begin
UIPanelItemHowToGetView.mText_TitleText = nil;
UIPanelItemHowToGetView.mScrRect_HowToGet = nil;

function UIPanelItemHowToGetView:ctor()
	UIPanelItemHowToGetView.super.ctor(self)

	self.typeList = {}
end

function UIPanelItemHowToGetView:__InitCtrl()
	self.mText_TitleText = self:GetText("Title/Text_TitleText");
	self.mTrans_HowToGetLayout = self:GetRectTransform("UI_ScrRect_HowToGet/UI_HowToGetLayout")
	self.mTrans_Close = self:GetRectTransform("Background")

	UIUtils.GetButtonListener(self.mTrans_Close.gameObject).onClick = function(gameObj)
		self:onClickClose()
	end
end

--@@ GF Auto Gen Block End

UIPanelItemHowToGetView.mData = nil
UIPanelItemHowToGetView.parent = nil

function UIPanelItemHowToGetView:InitCtrl(parent)
	local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UIPanelItemHowToGet.prefab",self));
	CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)

	self.parent = parent

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIPanelItemHowToGetView:SetData(data)
	if data then
		self.mData = data
		self.mText_TitleText.text = data.name.str .. TableData.GetHintById(70021)
		local getList = string.split(self.mData.get_list, ",")
		local itemDataList = self:GetItemGetType(getList)

		local count = 0
		for key, list in pairsBySort(itemDataList, function (a, b) return a < b end) do
			printstack(key)
			local item = nil
			if count + 1 <= #self.typeList then
				item = self.typeList[count + 1]
			else
				item = UIHowToGetTypeItem.New()
				item:InitCtrl(self.mTrans_HowToGetLayout)
				table.insert(self.typeList, item)
			end

			local itemHowToGetData = TableData.listItemHowToGetDatas:GetDataById(key)
			local getList = list

			local dataParam =
			{
				title = itemHowToGetData.title.str,
				type = itemHowToGetData.type,
				getList = getList,
				itemData = data,
				howToGetData = nil,
				root = self.parent
			}
			item:SetData(dataParam)
			UIUtils.ForceRebuildLayout(self.mTrans_HowToGetLayout)
		end

		--for i = 0, itemDataList.Length - 1 do
		--	local item = nil
		--	if i + 1 <= #self.typeList then
		--		item = self.typeList[i + 1]
		--	else
		--		item = UIHowToGetTypeItem.New()
		--		item:InitCtrl(self.mTrans_HowToGetLayout)
		--		table.insert(self.typeList, item)
		--	end
		--	local itemHowToGetData = TableData.listItemHowToGetDatas:GetDataById(itemDataList[i])
		--	local getList = self:GetHowToGetList(itemDataList[i])
		--
		--	local dataParam =
		--	{
		--		title = itemHowToGetData.title.str,
		--		getList = getList,
		--		itemData = data,
		--		howToGetData = nil,
		--		root = self.parent
		--	}
		--	item:SetData(dataParam)
		--	UIUtils.ForceRebuildLayout(self.mTrans_HowToGetLayout)
		--end
		setactive(self.mUIRoot, true)
	else
		setactive(self.mUIRoot, false)
	end
end

function UIPanelItemHowToGetView:onClickClose()
	if self.mUIRoot then
		setactive(self.mUIRoot.gameObject, false)
	end
end

function UIPanelItemHowToGetView:GetHowToGetList(getType)
	if getType then
		if #self.mData.get_list <= 0 then
			return nil
		end
		local getList = string.split(self.mData.get_list, ",")
		local list = {}
		for _, id in ipairs(getList) do
			local data = TableData.listItemGetListDatas:GetDataById(tonumber(id))
			if data.type == getType then
				table.insert(list, data)
			end
		end
		return list
	end
	return nil
end

function UIPanelItemHowToGetView:GetItemGetType(getList)
	local typeList = {}
	for _, item in ipairs(getList) do
		local getListData = TableData.listItemGetListDatas:GetDataById(tonumber(item))
		if typeList[getListData.type] == nil then
			typeList[getListData.type] = {}
		end
		table.insert(typeList[getListData.type], getListData)
	end

	return typeList
end