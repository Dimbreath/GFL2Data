require("UI.UIBaseCtrl")
require("UI.PanelItemHowToGet.UIHowToGetInfoItem")

UIHowToGetTypeItem = class("UIHowToGetTypeItem", UIBaseCtrl)
UIHowToGetTypeItem.__index = UIHowToGetTypeItem
--@@ GF Auto Gen Block Begin
UIHowToGetTypeItem.mText_HowToGetTypeText = nil
UIHowToGetInfoItem.getWayUpperLimit = nil

function UIHowToGetTypeItem:__InitCtrl()
	self.mText_HowToGetTypeText = self:GetText("HowToGetType/Text_HowToGetTypeText")
	self.mTrans_HowToGetList = self:GetRectTransform("HowToGetList")
end

--@@ GF Auto Gen Block End

function UIHowToGetTypeItem:ctor()
	UIHowToGetTypeItem.super.ctor(self)

	self.infoList = {}
	self.getWayUpperLimit = TableData.GlobalSystemData.GetwayStoryUpperlimit
end

function UIHowToGetTypeItem:InitCtrl(parent)
	local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UIHowToGetTypeItem.prefab",self));
	setparent(parent, obj.transform)
	obj.transform.localScale=vectorone
	obj.transform.localPosition =vectorone

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIHowToGetTypeItem:SetData(data)
	if data then
		self.mText_HowToGetTypeText.text = data.title.str
		if data.getList then
			local getList = data.getList
			if data.type == 9 then
				getList = self:FilterChapterItem(data.getList)
			end
			for i, howToGet in ipairs(getList) do
				local item = nil
				if i <= #self.infoList then
					item = self.infoList[i]
				else
					item = UIHowToGetInfoItem.New()
					item:InitCtrl(self.mTrans_HowToGetList)
					table.insert(self.infoList, item)
				end
				data.howToGetData = howToGet
				item:SetData(data)
			end
		end
		setactive(self.mUIRoot.gameObject, true)
	else
		setactive(self.mUIRoot.gameObject, false)
	end
end

function UIHowToGetTypeItem:FilterChapterItem(list)
	local showList = {}
	for i, itemData in ipairs(list) do
		local item = {}
		local jumpData = string.split(self.howToGetData.jump_code, ":")
		item.isUnLock = self:CheckIsUnLock(jumpData)
		item.data = itemData

		if i < self.getWayUpperLimit then
			table.insert(showList, item)
		else
			if item.isUnLock then
				table.remove(showList, 1)
				table.insert(showList, item)
			else
				break
			end
		end
	end

	table.sort(showList, function (a, b)
		local tValueA, tValueB
		tValueA, tValueB = (a.isUnLock == true or false), (b.isUnLock == true or false)
		if tValueA ~= tValueB then
			if tValueA then
				return true
			else
				return false
			end
		else
			if tValueA then
				return a.itemData.id > b.itemData.id
			else
				return a.itemData.id < b.itemData.id
			end
		end
	end)

	local list = {}
	for _, v in ipairs(showList) do
		table.insert(list, v.itemData)
	end

	return list
end

function UIHowToGetTypeItem:CheckIsUnLock(jump_code)
	local jumpData = string.split(jump_code, ":")
	if tonumber(jumpData[1]) == 1 then
		--- 判断章节是否解锁
		return NetCmdDungeonData:IsUnLockChapter(jumpData[2])
	elseif tonumber(jumpData[1]) == 14 then
		--- 判断关卡是否解锁
		local chapterId = TableData.listStoryDatas:GetDataById(jumpData[2]).chapter
		if NetCmdDungeonData:IsUnLockChapter(chapterId) then
			return NetCmdDungeonData:IsUnLockStory(jumpData[2])
		end
		return false
		--elseif tonumber(jumpData[1]) == 5 then
		--    local good = NetCmdStoreData:GetStoreGoodById(self.goodId)
		--    if not good then
		--        return false
		--    end
	end
	return true
end