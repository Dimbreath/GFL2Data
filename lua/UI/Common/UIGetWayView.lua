require("UI.UIBaseView")
require("UI.Common.UICommonGetWayTitleItem")

UIGetWayView = class("UIGetWayView", UIBaseView)
UIGetWayView.__index = UIGetWayView

UIGetWayView.Type =
{
	Common = 1,
	Mix = 2,
}

UIGetWayView.mData = nil
UIGetWayView.mParent = nil
UIGetWayView.callback = nil
UIGetWayView.mCurMixItem = nil
UIGetWayView.mCurContent = nil
UIGetWayView.mMixItemList = {}
UIGetWayView.PrefabPath = "UICommonFramework/UIGetWay.prefab"

UIGetWayView.CostItemText = "<color=#{0}>{1}</color>/{2}"
UIGetWayView.CostItemId = 2

function UIGetWayView:ctor()
	UIGetWayView.super.ctor(self)
	UIGetWayView.mData = nil
	UIGetWayView.mParent = nil
	UIGetWayView.callback = nil
	UIGetWayView.mCurMixItem = nil
	UIGetWayView.mCurContent = nil
	UIGetWayView.mMixItemList = {}
end

function UIGetWayView:__InitCtrl()
	self.mBtn_BGCloseButton = self:GetButton("GetWayPanel/Btn_BGCloseButton")
	self.mBtn_Cancel = self:GetButton("GetWayPanel/MainPanel/BGPanel/ButtonPanel/Btn_Cancel")
	self.mBtn_Confirm = self:GetButton("GetWayPanel/MainPanel/BGPanel/ButtonPanel/Btn_Confirm")
	self.mBtn_NotMixConfirm = self:GetRectTransform("GetWayPanel/MainPanel/BGPanel/ButtonPanel/Btn_NotMixConfirm")
	self.mTransMultipleItem = self:GetRectTransform("GetWayPanel/MainPanel/BGPanel/UI_Trans_MultipleGetWay")
	self.mTransSingleItem = self:GetRectTransform("GetWayPanel/MainPanel/BGPanel/UI_Trans_SingleGetWay")
	self.mTransSingleGetWay = self:GetRectTransform("GetWayPanel/MainPanel/BGPanel/UI_Trans_SingleGetWay/GetWayList")
	self.mTransSingleMixContent = self:GetRectTransform("GetWayPanel/MainPanel/BGPanel/UI_Trans_SingleGetWay/MixPanel")
	self.mTransDisable = self:GetRectTransform("GetWayPanel/MainPanel/BGPanel/ButtonPanel/Trans_Disable")
	self.mTransMask = self:GetRectTransform("Image_Mask")

	--- 单个素材页面
	self.mSingleMixItem = self:InitPanel(self:GetRectTransform("GetWayPanel/MainPanel/BGPanel/UI_Trans_SingleGetWay"), 1)
	--- 多个素材页面
	self.mMultipleMixItem = self:InitPanel(self:GetRectTransform("GetWayPanel/MainPanel/BGPanel/UI_Trans_MultipleGetWay"), 3)
end

--- 初始化整个界面
function UIGetWayView:InitPanel(obj, mixNum)
	if obj then
		local panel = {}
		panel.mixItem = {}
		panel.getWayList = {}
		panel.transGetWayList = obj:Find("GetWayList/Viewport/Trans_GetWayList")
		panel.getWayContent = obj:Find("GetWayList")
		panel.mixContent = self:InitMixContent(obj:Find("MixPanel"))
		for i = 1, mixNum do
			local mix = obj:Find("UI_Trans_MixItem" .. i)
			table.insert(panel.mixItem, self:InitItem(mix))
		end

		return panel
	end
	return nil
end

--- 右边合成材料部分
function UIGetWayView:InitMixContent(obj)
	if obj then
		local mix = {}
		mix.obj = obj
		mix.textCost = CS.LuaUIUtils.GetText(obj:Find("UI_Trans_Gold/Text_NeedNum"))
		mix.objPlus = obj:Find("Trans_cross")
		mix.itemSingle = self:InitItem(obj:Find("UI_Trans_MaterialItemSingle"))
		mix.itemList = {}
		for i = 1, 2 do
			local material = obj:Find("UI_Trans_MaterialItem" .. i)
			table.insert(mix.itemList, self:InitItem(material))
		end

		return mix
	end
	return nil
end

--- 初始化通用物品
function UIGetWayView:InitItem(obj)
	if obj then
		local item = {}
		item.obj = obj
		item.data = nil
		item.materialList = nil
		item.isEnough = false
		if obj:Find("Text_ItemName") ~= nil then
			item.textName = CS.LuaUIUtils.GetText(obj:Find("Text_ItemName"))
		else
			item.textName = nil
		end
		item.btnItem = obj:Find("ImageFrame")
		item.textCurrentNum = CS.LuaUIUtils.GetText(obj:Find("Text_CurrentNum"))
		item.textNeedNum = CS.LuaUIUtils.GetText(obj:Find("Text_NeedNum"))
		item.imageIcon = CS.LuaUIUtils.GetImage(obj:Find("Image_ItemIcon"))
		item.imageShadow = CS.LuaUIUtils.GetImage(obj:Find("Image_ItemShadow"))

		return item
	end
	return nil
end

--function UIGetWayView:InitMaterialItem(obj)
--	if obj then
--		local material = {}
--		material.obj = obj
--		material.data = nil
--		material.materialList = nil
--		material.isEnough = false
--		material.textCurrentNum = CS.LuaUIUtils.GetText(obj:Find("Text_CurrentNum"))
--		material.textNeedNum = CS.LuaUIUtils.GetText(obj:Find("Text_NeedNum"))
--		material.imageIcon = CS.LuaUIUtils.GetImage(obj:Find("Image_itemIcon"))
--
--		return material
--	end
--	return nil
--end


--- callback  物品合成和快速购买成功的回调
function UIGetWayView:InitCtrl(parent, callback, needCanvas)
	needCanvas = needCanvas == nil and false or needCanvas
	self.mParent = parent
	self.callback = callback

	local itemPrefab = UIUtils.GetUIRes(self.PrefabPath)
	local instObj = instantiate(itemPrefab)

	CS.LuaUIUtils.SetParent(instObj.gameObject, parent.gameObject, true)

	self:SetRoot(instObj.transform)

	self:__InitCtrl()


	UIUtils.GetButtonListener(self.mBtn_Confirm.gameObject).onClick = function()
		self:ReqComposeItems()
	end

	UIUtils.GetButtonListener(self.mBtn_Cancel.gameObject).onClick = function ()
		self:ClosePanel()
	end

	UIUtils.GetButtonListener(self.mBtn_NotMixConfirm.gameObject).onClick = function()
		self:ClosePanel()
	end

	if needCanvas then
		UIUtils.AddSubCanvas(self.mUIRoot.gameObject, 10, false)
	end
end

function UIGetWayView:SetData(itemId, targetNum)
	if itemId then
		local item = {}
		item.itemid = itemId
		item.num = targetNum

		table.insert(self.mMixItemList, item)

		setactive(self.mUIRoot,true)
		setactive(self.mTransSingleItem.gameObject, #self.mMixItemList == 1)
		setactive(self.mTransMultipleItem.gameObject, #self.mMixItemList > 1)

		if #self.mMixItemList > 1 then
			self.mCurContent = self.mMultipleMixItem
		else
			self.mCurContent = self.mSingleMixItem
		end
		self:UpdateMixContent(self.mCurContent, self.mMixItemList)
	else
		setactive(self.mUIRoot,false)
	end
end

function UIGetWayView:UpdatePanel()
	if not self.mMixItemList or #self.mMixItemList <= 0 then
		return
	end
	setactive(self.mUIRoot,true)
	setactive(self.mTransSingleItem.gameObject, #self.mMixItemList == 1)
	setactive(self.mTransMultipleItem.gameObject, #self.mMixItemList > 1)

	if #self.mMixItemList > 1 then
		self.mCurContent = self.mMultipleMixItem
	else
		self.mCurContent = self.mSingleMixItem
	end
	self:UpdateMixContent(self.mCurContent, self.mMixItemList)
end

function UIGetWayView:UpdateMixContent(item ,data)
	if item then
		for i = 1, #item.mixItem do
			if i <= #data then
				self:UpdateItem(item.mixItem[i], data[i])
				UIUtils.GetButtonListener(item.mixItem[i].btnItem.gameObject).onClick = function()
					self:onClickMixItem(data[i])
				end
			else
				self:UpdateItem(item.mixItem[i], nil)
			end
		end
		self.mCurMixItem = item.mixItem[1]
		self:UpdateMaterialContent()
	end
end

function UIGetWayView:UpdateMaterialContent()
	if self.mCurMixItem and self.mCurContent then
		local curMixItem = self.mCurMixItem
		local curContent = self.mCurContent
		if #curMixItem.materialList <= 0 or not curMixItem.materialList then
			setactive(curContent.mixContent.obj.gameObject, false)
			setactive(curContent.getWayContent.gameObject, true)
			setactive(self.mTransDisable.gameObject, true)
			setactive(self.mBtn_Confirm.gameObject, false)
			setactive(self.mBtn_NotMixConfirm.gameObject, true)
			self:UpdateGetWay()
		else
			setactive(curContent.mixContent.obj.gameObject, true)
			setactive(curContent.getWayContent.gameObject, false)
			local materialContent = curContent.mixContent

			local totalCost = curMixItem.itemData.mix_cost
			local res = NetCmdItemData:GetResItemCount(UIGetWayView.CostItemId)
			local color = res < totalCost and "F8001B" or "FFFFFF"
			materialContent.textCost.text = string_format(UIGetWayView.CostItemText, color, totalCost, res)
			for i = 1, #materialContent.itemList do
				self:UpdateItem(materialContent.itemList[i], nil)
			end
			self:UpdateItem(materialContent.itemSingle, nil)

			if #curMixItem.materialList >= 2 then
				for i = 1, #materialContent.itemList do
					if i <= #curMixItem.materialList then
						self:UpdateItem(materialContent.itemList[i], curMixItem.materialList[i])
						UIUtils.GetButtonListener(materialContent.itemList[i].btnItem.gameObject).onClick = function()
							self:onClickMaterialItem(curMixItem.materialList[i])
						end
					else
						self:UpdateItem(materialContent.itemList[i], nil)
					end
				end
			else
				self:UpdateItem(materialContent.itemSingle, curMixItem.materialList[1])
				UIUtils.GetButtonListener(materialContent.itemSingle.btnItem.gameObject).onClick = function()
					self:onClickMaterialItem(curMixItem.materialList[1])
				end
			end

			setactive(curContent.mixContent.objPlus.gameObject, #curMixItem.materialList >= 2)
			setactive(curContent.mixContent.obj.gameObject, true)
			setactive(self.mTransDisable.gameObject, not self:CheckCanMix())
			setactive(self.mBtn_Confirm.gameObject, self:CheckCanMix())
			setactive(self.mBtn_NotMixConfirm.gameObject, false)
		end
	end
end

function UIGetWayView:UpdateItem(item, data)
	if data then
		local itemData = TableData.listItemDatas:GetDataById(data.itemid)
		local resNum = 0
		if itemData.type == 1 then
			resNum = NetCmdItemData:GetResItemCount(data.itemid)
		elseif itemData.type == 6 then
			resNum = GlobalData.GetStaminaResourceItemCount(data.itemid)
		else
			resNum = NetCmdItemData:GetItemCount(data.itemid)
		end

		item.data = data
		item.itemData = itemData
		item.materialList = self:GetMixMaterialList(itemData.mix_item_list)
		if item.textName then
			item.textName.text = itemData.name.str
		end

		setactive(item.textNeedNum.gameObject, data.num ~= nil)
		if data.num then
			item.textNeedNum.text = "/" .. data.num
			item.textCurrentNum.color = resNum < data.num and CS.GF2.UI.UITool.StringToColor("F8001B") or CS.GF2.UI.UITool.StringToColor("00F814")
			item.isEnough = resNum >= data.num
		else
			item.textNeedNum.text = ""
			item.textCurrentNum.color = CS.GF2.UI.UITool.StringToColor("000000")
			item.isEnough = false
		end

		item.textCurrentNum.text = resNum
		item.imageIcon.sprite = IconUtils.GetItemSprite(itemData.icon)
		item.imageShadow.sprite = IconUtils.GetItemSprite(itemData.icon)

		setactive(item.obj.gameObject, true)
	else
		item.data = nil
		setactive(item.obj.gameObject, false)
	end
end

function UIGetWayView:UpdateGetWay()
	local data = self.mCurMixItem.itemData

	local getList = string.split(data.get_list, ",")
	local itemDataList = self:GetItemGetType(getList)

	local count = 0

	for _, item in ipairs(self.mCurContent.getWayList) do
		item:SetData(nil)
	end

	for key, list in pairsBySort(itemDataList, function (a, b) return a < b end) do
		printstack(key)
		local item = nil
		if count + 1 <=  #self.mCurContent.getWayList then
			item = self.mCurContent.getWayList[count + 1]
		else
			item = UICommonGetWayTitleItem.New()
			item:InitCtrl(self.mCurContent.transGetWayList)
			table.insert(self.mCurContent.getWayList, item)
		end

		local itemHowToGetData = TableData.listItemHowToGetDatas:GetDataById(key)
		local getList = list

		local dataParam =
		{
			title = itemHowToGetData.title.str,
			type = key,
			getList = getList,
			itemData = data,
			howToGetData = nil,
			root = self
		}
		item:SetData(dataParam)
		UIUtils.ForceRebuildLayout(self.mCurContent.transGetWayList)
	end
end

function UIGetWayView:ClosePanel()
	self.mMixItemList = {}
	self.mCurMixItem = nil
	self.mCurContent = nil
	setactive(self.mUIRoot.gameObject, false)
end

function UIGetWayView:CheckCanMix()
	if self.mCurContent and self.mCurMixItem then
		local count = 0
		if #self.mCurMixItem.materialList <= 1 then
			if self.mCurContent.mixContent.itemSingle.data then
				count = count + 1
				if not self.mCurContent.mixContent.itemSingle.isEnough then
					return false
				end
			end
		else
			for i = 1, #self.mCurContent.mixContent.itemList do
				if self.mCurContent.mixContent.itemList[i].data then
					count = count + 1
					if not self.mCurContent.mixContent.itemList[i].isEnough then
						return false
					end
				end
			end
		end

		local totalCost = self.mCurMixItem.itemData.mix_cost
		local res = NetCmdItemData:GetResItemCount(UIGetWayView.CostItemId)
		if res < totalCost then
			return false
		end
		if count <= 0 then
			return false
		end
		return true
	end
	return false
end

function UIGetWayView:onClickMixItem(item)
	if item.itemid == self.mCurMixItem.data.itemid or not self.mCurContent then
		return
	end

	local index = 0
	for i = 1, #self.mMixItemList do
		local mix = self.mMixItemList[i]
		if mix then
			if mix.itemid == item.itemid then
				index = i
				break
			end
		end
	end
	for i = 1, index - 1 do
		table.remove(self.mMixItemList, 1)
	end
	self:UpdatePanel()
end

function UIGetWayView:ReqComposeItems()
	if self.mCurMixItem then
		printstack(self.mCurMixItem.data.itemid)
		setactive(self.mTransMask.gameObject, true)
		NetCmdItemData:SendCmdComposeItemsMsg(self.mCurMixItem.data.itemid, function (ret)
			if ret == CS.CMDRet.eSuccess then
				printstack("合成成功" .. self.mCurMixItem.data.itemid)
				self:UpdatePanel()
				if self.callback then
					self.callback()
				end
				setactive(self.mTransMask.gameObject, false)
			end
		end)
	end
end

function UIGetWayView:onClickMaterialItem(item)
	if item.itemid == self.mCurMixItem.data.itemid then
		return
	end
	table.insert(self.mMixItemList,1, item)
	self:UpdatePanel()
end

function UIGetWayView:GetMixMaterialList(str)
	if str then
		local list = {}
		for id, itemNum in pairs(str) do
			local item =
			{
				itemid = id,
				num = itemNum
			}
			table.insert(list,item)
		end
		return list
	end
	return nil
end

function UIGetWayView:GetItemGetType(getList)
	local typeList = {}
	if getList ~= "" then
		for _, item in ipairs(getList) do
			if item ~= "" then
				local getListData = TableData.listItemGetListDatas:GetDataById(tonumber(item))
				if getListData then
					if typeList[getListData.type] == nil then
						typeList[getListData.type] = {}
					end
					table.insert(typeList[getListData.type], getListData)
				end
			end
		end
	end


	return typeList
end
