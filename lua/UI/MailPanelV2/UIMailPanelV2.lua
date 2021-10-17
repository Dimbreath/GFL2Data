require("UI.UIBasePanel")
require("UI.MailPanelV2.UIMailPanelV2View")
require("UI.MailPanelV2.Item.UIMailLeftTabItemV2")
---@class UIMailPanelV2 : UIBasePanel
UIMailPanelV2 = class("UIMailPanelV2", UIBasePanel)
UIMailPanelV2.__index = UIMailPanelV2

--UI路径
UIMailPanelV2.mPath_MailListItem = "Mail/MailLeftTabItemV2.prefab"

--UI控件
---@type UIMailPanelV2View
UIMailPanelV2.mView = nil
--逻辑参数
---@type UIMailLeftTabItemV2
UIMailPanelV2.mCurSelMailItem = nil
UIMailPanelV2.mMailListItems = {}
UIMailPanelV2.mAttachmentIds = {}
UIMailPanelV2.mAttachmentItems = {}
UIMailPanelV2.mCachedMailList = nil
UIBasePanel.mIsSyncOn = false  --正在同步邮件

UIMailPanelV2.tipsItem = nil

function UIMailPanelV2:ctor()
    UIMailPanelV2.super.ctor(self)
end

function UIMailPanelV2.Open()
    UIMailPanelV2.OpenUI(UIDef.UIMailPanelV2)
end

function UIMailPanelV2.Close()
    UIManager.CloseUI(UIDef.UIMailPanelV2)
end

function UIMailPanelV2.Init(root)
	UIMailPanelV2.super.SetRoot(UIMailPanelV2, root)
	self = UIMailPanelV2

	self.RedPointType = {RedPointConst.Mails}
	-- self.mIsPop = true
	---@type UIMailPanelV2View
	self.mView = UIMailPanelV2View
	self.mView:InitCtrl(root)

	self.mView.mBtn_BackItem = UIUtils.GetTempBtn(self.mView:GetRectTransform("Root/GrpTop/BtnBack"))
	UIUtils.GetButtonListener(self.mView.mBtn_BackItem.gameObject).onClick = self.OnReturnClick

	self.mView.mBtn_HomeItem = UIUtils.GetTempBtn(self.mView:GetRectTransform("Root/GrpTop/BtnHome"))
	UIUtils.GetButtonListener(self.mView.mBtn_HomeItem.gameObject).onClick = self.OnCommanderCenter

	UIUtils.GetButtonListener(self.mView.mBtn_Right3Item.gameObject).onClick = self.OnAllReceive
	UIUtils.GetButtonListener(self.mView.mBtn_Left3Item.gameObject).onClick = self.OnDeleteAllBtnClicked

	MessageSys:AddListener(CS.GF2.Message.MailEvent.MailDelete, self.OnMailChangedCallBack)
	self.mView.mVirtualList.itemProvider = self.GetRenderItem

	self.mView.mVirtualList.itemRenderer = self.ItemRenderer
end

function UIMailPanelV2.GetRenderItem()
	self = UIMailPanelV2
	return self:ItemProvider()
end

function UIMailPanelV2:ItemProvider()
	---@type UICommonGrpItem
	local itemView = UICommonGrpItem.New()
	itemView:InitCtrl(self.mView.mContent_Item.transform)
	local renderDataItem = CS.RenderDataItem()
	renderDataItem.renderItem = itemView.mUIRoot.gameObject
	renderDataItem.data = itemView

	return renderDataItem
end

function UIMailPanelV2.ItemRenderer(index, renderData)
	self = UIMailPanelV2
	local itemId = self.mAttachmentIds[index + 1]
	local itemData = self.mAttachmentItems[itemId]
	---@type UICommonGrpItem
	local itemView = renderData.data
	itemView:SetByItemData(itemData, self.mCurSelMailItem.mData.attachments[itemData.id], self.mCurSelMailItem.mData.get_attachment > 0)
end

function UIMailPanelV2.OnInit()
	self = UIMailPanelV2
	self.mCachedMailList = nil
	self:InitMailList()
end

------------------------------邮件列表----------------------------------------
function UIMailPanelV2:InitMailList()
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_MailListItem,self)
	if(self.mCachedMailList == nil) then
		self.mCachedMailList = NetCmdMailData:GetSortedMailList()
	end

	local bIsDefaultSet = false
	local prevSelectIndex = -1

	if(self.mCurSelMailItem ~= nil) then
		printstack(self.mCurSelMailItem.mIndex)
		prevSelectIndex = self.mCurSelMailItem.mIndex
	end

	self.HideItemList()
	self.ClearSelect()

	--setactive(self.mView.mBtn_Right3Item.gameObject, self:HasNotGetAttachment())
	--setactive(self.mView.mBtn_Left3Item.gameObject, self:HasCanDelMail())
	setactive(self.mView.mTrans_Mail.gameObject, self.mCachedMailList.Count > 0)
	setactive(self.mView.mTrans_None.gameObject, self.mCachedMailList.Count <= 0)

	setactive(self.mView.mTrans_Mail.gameObject, self.mCachedMailList.Count > 0)
	setactive(self.mView.mTrans_None.gameObject, self.mCachedMailList.Count <= 0)

	for i = 0, self.mCachedMailList.Count - 1, 1 do
		local instObj = nil
		---@type UIMailLeftTabItemV2
		local item = nil

		if(#self.mMailListItems >= i+1) then
			item = self.mMailListItems[i+1]
			item:SetActive(true)
			instObj = item:GetRoot().gameObject
		else
			instObj = instantiate(itemPrefab, self.mView.mContent_Material.gameObject.transform)
			item = UIMailLeftTabItemV2.New()
		end

		item:InitCtrl(instObj.transform)
		item:InitData(self.mCachedMailList[i])
		item.mIndex = i

		local itemBtn = UIUtils.GetButtonListener(item.mUIRoot.gameObject)
		itemBtn.onClick = self.OnMailItemClicked
		itemBtn.param = item

		self.mMailListItems[i+1] = item

		if(self.mCachedMailList[i].IsExpired == false and i >= prevSelectIndex and bIsDefaultSet == false) then
			bIsDefaultSet = true
			self:SelectMail(item)
			--if not (self.mCachedMailList[i].read == 1) then
			--	NetCmdMailData:SendReqRoleMailReadCmd(item.mData.id,self.MailReadCallback)
			--end
		end
	end
	self.mView.mText_Num.text = self.mCachedMailList.Count
end

function UIMailPanelV2.OnMailItemClicked(gameObj)
	self = UIMailPanelV2

	if(self.mIsSyncOn == true) then
		return
	end

	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener))
	if eventTrigger ~= nil then
		local item = eventTrigger.param
		self.ClearSelect()
		self:SelectMail(item)
		--if not (item.mData.read == 1) then
		--	NetCmdMailData:SendReqRoleMailReadCmd(item.mData.id,self.MailReadCallback)
		--end
	end
end

function UIMailPanelV2.OnMailChangedCallBack()
	MessageBox.Show(TableData.GetHintById(60051), TableData.GetHintById(60050), MessageBox.ShowFlag.eMidBtn, nil, function () self.UpdateMailList() end, nil)
end

function UIMailPanelV2:SelectMail(item)
	if item.mData.isReq then
		item:Select()
		self.mCurSelMailItem = item
		self:UpdateMailContent(item)
	else
		local data = NetCmdMailData:GetMailDataById(item.mData.id)
		item:SetData(data)
		item:Select()
		self.mCurSelMailItem = item
		NetCmdMailData:SendMailDetail(item.mData.id, function ()
			self:MailReadCallback(item)
			self:UpdateMailContent(item)
		end)
	end
end

function UIMailPanelV2:MailReadCallback(item)
	item:SetRead(true)
	item:ClearAttachment()

	--- RedPoint
	self:UpdateRedPoint()
end

function UIMailPanelV2.ClearSelect()
	self = UIMailPanelV2

	for i = 1, #self.mMailListItems, 1 do
		self.mMailListItems[i]:UnSelect()
	end

	self.mCurSelMailItem  = nil
end

function UIMailPanelV2.HideItemList()
	self = UIMailPanelV2

	for i = 1, #self.mMailListItems, 1 do
		self.mMailListItems[i]:SetActive(false)
	end
end

function UIMailPanelV2.UpdateMailList()
	self = UIMailPanelV2
	self.mCachedMailList = nil
	self:InitMailList()
end

function UIMailPanelV2.CheckScroll(pos)
	if(pos.y > 0) then
		setactive(UIMailPanelV2.mView.mScrollbar_Material.gameObject, true);
	else
		setactive(UIMailPanelV2.mView.mScrollbar_Material.gameObject, false);
	end
end

------------------------------邮件正文----------------------------------------
function UIMailPanelV2:UpdateMailContent(item)
	if(self.mCurSelMailItem ~= item) then
		return
	end

	self.ClearAttachmentItem()

	local data = self.mCurSelMailItem.mData
	self.mView.mText_Title.text = data.title
	if string.match(data.content, "{uid}") then
		local text = string.gsub(data.content, "{uid}", AccountNetCmdHandler:GetUID())
		text = string.gsub(text, '{(https://%g-)}', function(w)
			if string.match(w, "uid") then
				local strings = string.split(w, "?")
				return "{" .. strings[1] .. "?token=" .. string.gsub(CS.AesUtils.Encode(strings[2]), "-", "") .. "}"
			else
				return w
			end
		end)
		self.mView.mText_Description.text = text
	else
		self.mView.mText_Description.text = data.content
	end
	self.mView.mText_Time.text = data.mail_date
	self.mView.mText_CountDown.text = data.remain_time;
	--gfwarning(data.remain_time)
	local attachments = data.attachments

	local i = 1
	for k,v in pairs(attachments) do
		local itemData = TableData.GetItemData(k)
		local typeData = TableData.listItemTypeDescDatas:GetDataById(itemData.type)
		local count = 1
		if typeData.pile == 0 then
			count = v
		end
		for index = 1, count do
			self.mAttachmentIds[i] = k
			i = i + 1
		end
		self.mAttachmentItems[k] = itemData
	end
	self.mView.mVirtualList.numItems = #self.mAttachmentIds
	self.mView.mVirtualList:Refresh()
	--if #self.mAttachmentIds > 7 then
	--	self.mView.mVirtualList:DelayScrollToPos(1);
	--else
		self.mView.mVirtualList.content.anchoredPosition = Vector2(0, self.mView.mVirtualList.content.anchoredPosition.y)
	--end

	if(data.hasLink == true) then
		--链接
		setactive(self.mView.mBtn_PowerUp.gameObject, false)
		setactive(self.mView.mTrans_UnLocked.gameObject, false)
	else
		setactive(self.mView.mTrans_UnLocked.gameObject,  data.hasAttachment and data.get_attachment == 1)
		if  data.get_attachment == 0 and data.hasAttachment then
			--有奖励且未领取
			setactive(self.mView.mTrans_CanReceive.gameObject, true)
			UIUtils.GetButtonListener(self.mView.mBtn_PowerUp.gameObject).onClick = function() self:OnReceiveBtnClicked() end
		else
			--已领取或者无奖励
			setactive(self.mView.mTrans_CanReceive.gameObject, false)
		end
	end
end

function UIMailPanelV2:GetAppropriateItem(itemData, itemNum)
	if itemData == nil then
		return nil;
	end
 
	if itemData.type == 8 then --武器
		---@type UICommonWeaponInfoItem
		local weaponInfoItem = UICommonWeaponInfoItem.New()
		weaponInfoItem:InitCtrl(self.mView.mContent_Item.gameObject.transform)
		weaponInfoItem:SetData(itemData.args[0], 0)
		if self.mCurSelMailItem.mData.get_attachment > 0 then
			weaponInfoItem:SetReceived(true)
		end
		return weaponInfoItem
	else
		---@type UICommonItem
		local itemView = UICommonItem.New();
		itemView:InitCtrl(self.mView.mContent_Item.gameObject.transform)
		if itemData.type == 5 then --模组
			local equipData = TableData.listGunEquipDatas:GetDataById(tonumber(itemData.args[0]))
			itemView:SetEquipData(itemData.args[0],0,nil,itemId)
		else
			itemView:SetItemData(itemData.id, itemNum)
		end

		if self.mCurSelMailItem.mData.get_attachment > 0 then
			itemView:SetReceived(true)
		end
		return itemView;
	end
end


function UIMailPanelV2.ClearAttachmentItem()
	self = UIMailPanelV2

	self.mAttachmentIds = {}
end


function UIMailPanelV2:OnReceiveBtnClicked(gameObj)
	--
	--if(self.mCurSelMailItem.mData.IsExpired == true) then
	--	MessageBox.Show(TableData.GetHintById(60051), TableData.GetHintById(60052), MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
	--	return
	--end
	if self.mCurSelMailItem.mData then
		local attachments = self.mCurSelMailItem.mData.attachments
		if TipsManager.CheckItemListIsOverflow(attachments) then
			return
		end
	end

	local id = self.mCurSelMailItem.mData.id

	NetCmdMailData:SendReqRoleMailGetAttachmentCmd(id, function (ret)
		self:OnReceiveAttachmentCallback(ret)
	end)
end

function UIMailPanelV2.OnDeleteBtnClicked(gameObj)
	self = UIMailPanelV2
	local id = self.mCurSelMailItem.mData.id
	local ids = {}
	ids[1] = id

	NetCmdMailData:SendReqRoleMailDelCmd(ids, self.OnMailDeleteCallback)
	self.mIsSyncOn = true
end

function UIMailPanelV2:OnDeleteAllBtnClicked(gameObj)
	self = UIMailPanelV2
	if self:HasCanDelMail() then
		MessageBox.Show(TableData.GetHintById(60003), TableData.GetHintById(60004), MessageBox.ShowFlag.eNone, nil, self.ConfirmMailTips, nil)
	else
		CS.PopupMessageManager.PopupString(TableData.GetHintById(60057))
	end
end

function UIMailPanelV2.OnLinkBtnClicked(gameObj)
	self = UIMailPanelV2

	if(self.mCurSelMailItem.mData.IsExpired == true) then
		MessageBox.Show(TableData.GetHintById(60051), TableData.GetHintById(60052), MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
		return
	end
end

function UIMailPanelV2.OnAllReceive(gameObj)
	self = UIMailPanelV2
	if self:HasNotGetAttachment() then
		local firstOverflow = self:CheckAllReceiveItem()
		if not firstOverflow then
			NetCmdMailData:SendReqRoleMailGetAttachmentsCmd(self.GetRewardCallBack)
		end
	else
		CS.PopupMessageManager.PopupString(TableData.GetHintById(60056))
	end
end

function UIMailPanelV2:OnReceiveAttachmentCallback(ret)

	if ret == CS.CMDRet.eSuccess then
		local rewardList = self.mCurSelMailItem.mData.attachments
		local title = TableData.GetHintById(60001)

		self.mCachedMailList:Clear()
		self.mCachedMailList = nil
		self.mCurSelMailItem  = nil
		self:UpdateMailList()
		--setactive(self.mView.mBtn_Left3Item.gameObject, self:HasCanDelMail())
		--setactive(self.mView.mBtn_Right3Item.gameObject, self:HasNotGetAttachment())

		--- RedPoint
		self:UpdateRedPoint()

		if AccountNetCmdHandler.IsLevelUpdate==true then
            UICommonLevelUpPanel.Open(UICommonLevelUpPanel.ShowType.CommanderLevelUp, nil, true, true)
		else
			UIManager.OpenUIByParam(UIDef.UICommonReceivePanel)
        end
	else
		gfdebug("领取失败")
		MessageBox.Show(TableData.GetHintById(64), TableData.GetHintById(70041), MessageBox.ShowFlag.eMidBtn, nil, function ()
			UIMailPanelV2.mCachedMailList:Remove(UIMailPanelV2.mCurSelMailItem.mData)
			if UIMailPanelV2.mCurSelMailItem.mIndex + 1 > UIMailPanelV2.mCachedMailList.Count then
				UIMailPanelV2.mCurSelMailItem = nil
				UIMailPanelV2.mView.mTrans_MailList.offsetMax = Vector2(UIMailPanelV2.mView.mTrans_MailList.offsetMax.x, 0)
			end
			UIMailPanelV2:UpdateMailList()
		end , nil)
	end
end

function UIMailPanelV2.OnMailDeleteCallback(ret)
	self = UIMailPanelV2
	self.mIsSyncOn = false

	if ret == CS.CMDRet.eSuccess then
		gfdebug("删除邮件成功")
		self.mCachedMailList:Remove(self.mCurSelMailItem.mData)
		if self.mCurSelMailItem.mIndex + 1 > self.mCachedMailList.Count then
			self.mCurSelMailItem = nil
			self.mView.mTrans_MailList.offsetMax = Vector2(self.mView.mTrans_MailList.offsetMax.x, 0)
		end
		self:UpdateMailList()
	else
		gfdebug("删除邮件失败")
		MessageBox.Show(TableData.GetHintById(60053), TableData.GetHintById(60054), MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
	end

end

function UIMailPanelV2.OnAllMailDeleteCallback(ret)
	self = UIMailPanelV2
	self.mIsSyncOn = false

	if ret == CS.CMDRet.eSuccess then
		gfdebug("删除邮件成功")
		self.mCachedMailList:Clear()
		self.mCachedMailList = nil
		self.mCurSelMailItem  = nil
		self:UpdateMailList()
		self.mView.mScrollbar_Material.value = 1

		--- redPoint
		self:UpdateRedPoint()
	else
		gfdebug("删除邮件失败")
		MessageBox.Show(TableData.GetHintById(60053), TableData.GetHintById(60054), MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
	end
end

function UIMailPanelV2.OnReturnClick(gameObj)
    self = UIMailPanelV2
	UIMailPanelV2.Close()
end

function UIMailPanelV2.OnCommanderCenter()
	UIManager.JumpToMainPanel()
end

function UIMailPanelV2.OnRelease()
    self = UIMailPanelV2

	self.mCurSelMailItem = nil
	self.mMailListItems = {}
	self.mAttachmentIds = {}
	self.mAttachmentItems = {}
	self.mCachedMailList = nil
	self.mIsSyncOn = false
	self.tipsItem = nil

	MessageSys:RemoveListener(10007, self.OnAvgOver)
	MessageSys:RemoveListener(CS.GF2.Message.MailEvent.MailDelete, self.OnMailChangedCallBack)

end

function UIMailPanelV2.GetRewardCallBack(ret)
	self = UIMailPanelV2

	if ret == CS.CMDRet.eSuccess then
		local rewardList = NetCmdMailData:GetAllAttachments()
		local title = TableData.GetHintById(60001)

		self.mCachedMailList:Clear()
		self.mCachedMailList = nil
		self.mCurSelMailItem  = nil
		self:UpdateMailList()
		-- self.mView.mScrollBar.value = 1

		--- redPoint
		self:UpdateRedPoint()

		if AccountNetCmdHandler.IsLevelUpdate==true then
			UICommonLevelUpPanel.Open(UICommonLevelUpPanel.ShowType.CommanderLevelUp, nil, true, true)
		else
			UIManager.OpenUIByParam(UIDef.UICommonReceivePanel)
		end
	else
		printstack("一键领取邮件失败")
	end
end

-- 筛选邮件（已读邮件，已领附件邮件）
function UIMailPanelV2:FiltrateMail()
	local mailList = {}
	for _, item in pairs(self.mCachedMailList) do
		if item.read == 1 then
			if item.hasAttachment then
				if item.get_attachment == 1 then
					table.insert(mailList, item.id)
				end
			else
				table.insert(mailList, item.id)
			end
		end
	end
	return mailList
end

function UIMailPanelV2:HasNotGetAttachment()
	for _,item in pairs(self.mCachedMailList) do
		if item.hasAttachment and item.get_attachment == 0 then
			return true
		end
	end
	return false
end

function UIMailPanelV2:CheckAllReceiveItem()
	for _, item in pairs(self.mCachedMailList) do
		if item.hasAttachment and item.get_attachment == 0 then
			if TipsManager.CheckItemListIsOverflow(item.attachments, true) then
				return true
			end
		end
	end

	return false
end

function UIMailPanelV2:HasCanDelMail()
	for _, item in pairs(self.mCachedMailList) do
		if item.read == 1 then
			if item.hasAttachment then
				if item.get_attachment == 1 then
					return true
				end
			else
				return true
			end
		end
	end
	return false
end

function UIMailPanelV2.ConfirmMailTips(param)
	self = UIMailPanelV2

	if self.tipsItem then
		self.tipsItem:CloseTips()
	end

	local ids = self:FiltrateMail()
	NetCmdMailData:SendReqRoleMailDelCmd(ids, self.OnAllMailDeleteCallback)
end

function UIMailPanelV2:CollectItem(itemList)
	local dicItem = {}
	for id, num in pairs(itemList) do
		local itemData = TableData.GetItemData(id)
		if itemData then
			local maxCount = 0
			local type = itemData.type
			local typeData = TableData.listItemTypeDescDatas:GetDataById(type)
			if typeData.related_item and typeData.related_item > 0 then
				if dicItem[typeData.related_item] == nil then
					dicItem[typeData.related_item] = 0
				end
				dicItem[typeData.related_item] = dicItem[typeData.related_item] + num
			else
				dicItem[id] = num
			end
		end
	end

	return dicItem
end
