require("UI.UIBasePanel")
require("UI.MailPanel.UIMailPanelView")
require("UI.MailPanel.Item.UIMailListItem")
require("UI.MailPanel.Item.UIMailTipsItem")

UIMailPanel = class("UIMailPanel", UIBasePanel)
UIMailPanel.__index = UIMailPanel


--UI路径
UIMailPanel.mPath_MailListItem = "Mail/UIMailListItem.prefab"

--UI控件
UIMailPanel.mView = nil
--逻辑参数
UIMailPanel.mCurSelMailItem = nil
UIMailPanel.mMailListItems = {}
UIMailPanel.mAttachmentItems = {}
UIMailPanel.mCachedMailList = nil
UIBasePanel.mIsSyncOn = false  --正在同步邮件

UIMailPanel.tipsItem = nil

function UIMailPanel:ctor()
    UIMailPanel.super.ctor(self)
end

function UIMailPanel.Open()
    UIMailPanel.OpenUI(UIDef.UIMailPanel)
end

function UIMailPanel.Close()
    UIManager.CloseUI(UIDef.UIMailPanel)
end

function UIMailPanel.Init(root)
	UIMailPanel.super.SetRoot(UIMailPanel, root)
    self = UIMailPanel

	self.RedPointType = {RedPointConst.Mails}
	-- self.mIsPop = true
	self.mView = UIMailPanelView
    self.mView:InitCtrl(root)
	
	UIUtils.GetButtonListener(self.mView.mBtn_Return.gameObject).onClick = self.OnReturnClick
	UIUtils.GetButtonListener(self.mView.mBtn_CommanderCenter.gameObject).onClick = self.OnCommanderCenter
	UIUtils.GetButtonListener(self.mView.mBtn_BottomPanel_AllReceiveButton.gameObject).onClick = self.OnAllReceive
	UIUtils.GetButtonListener(self.mView.mBtn_AllDeleteButton.gameObject).onClick = self.OnDeleteAllBtnClicked
end

function UIMailPanel.OnInit()
	self = UIMailPanel

	self:InitMailList()
end

------------------------------邮件列表----------------------------------------
function UIMailPanel:InitMailList()
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

	--setactive(self.mView.mBtn_BottomPanel_AllReceiveButton.gameObject, self:HasNotGetAttachment())
	--setactive(self.mView.mBtn_AllDeleteButton.gameObject, self:HasCanDelMail())
	setactive(self.mView.mTrans_MailDetailPanel.gameObject, self.mCachedMailList.Count > 0)
	setactive(self.mView.mTrans_EmptyDetail.gameObject, self.mCachedMailList.Count <= 0)
	
	for i = 0, self.mCachedMailList.Count - 1, 1 do
		local instObj = nil
		local item = nil
		
		if(#self.mMailListItems >= i+1) then
			item = self.mMailListItems[i+1]
			item:SetActive(true)
			instObj = item:GetRoot().gameObject
		else
			instObj = instantiate(itemPrefab)
			item = UIMailListItem.New()
		end
		
		item:InitCtrl(instObj.transform)
		item:InitData(self.mCachedMailList[i])
		item.mIndex = i
		
		local itemBtn = UIUtils.GetButtonListener(item.mUIRoot.gameObject)
		itemBtn.onClick = self.OnMailItemClicked
		itemBtn.param = item
		
		UIUtils.AddListItem(instObj,self.mView.mTrans_MailList.transform)
		
		self.mMailListItems[i+1] = item
		
		if(self.mCachedMailList[i].IsExpired == false and i >= prevSelectIndex and bIsDefaultSet == false) then
			bIsDefaultSet = true
			self:SelectMail(item)
			--if not (self.mCachedMailList[i].read == 1) then
			--	NetCmdMailData:SendReqRoleMailReadCmd(item.mData.id,self.MailReadCallback)
			--end
		end
	end
	self.mView.mText_BottomPanel_MailAmount.text = self.mCachedMailList.Count

end

function UIMailPanel.OnMailItemClicked(gameObj)
	self = UIMailPanel	
	
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

function UIMailPanel:SelectMail(item)
	if item.mData.isReq then
		item:Select()
		self.mCurSelMailItem = item
		self:UpdateMailContent()
	else
		NetCmdMailData:SendMailDetail(item.mData.id, function ()
			local data = NetCmdMailData:GetMailDataById(item.mData.id)
			item:SetData(data)
			item:Select()
			self.mCurSelMailItem = item
			self:UpdateMailContent()
			self:MailReadCallback()
		end)
	end
end

function UIMailPanel:MailReadCallback()
	self.mCurSelMailItem:SetRead(true)
	self.mCurSelMailItem:ClearAttachment()

	--- RedPoint
	self:UpdateRedPoint()
end

function UIMailPanel.ClearSelect()
	self = UIMailPanel	
	
	for i = 1, #self.mMailListItems, 1 do
		self.mMailListItems[i]:UnSelect()
	end
	
	self.mCurSelMailItem  = nil
end

function UIMailPanel.HideItemList()
	self = UIMailPanel	
	
	for i = 1, #self.mMailListItems, 1 do
		self.mMailListItems[i]:SetActive(false)
	end
end

function UIMailPanel.UpdateMailList()
	self = UIMailPanel	
	self:InitMailList()
end

------------------------------邮件正文----------------------------------------
function UIMailPanel:UpdateMailContent()
	if(self.mCurSelMailItem == nil) then
		return
	end
	
	self.ClearAttachmentItem()
	
	local data = self.mCurSelMailItem.mData
	self.mView.mText_MailTitle.text = self.mCurSelMailItem.title
	self.mView.mText_MainText.text = data.content
	self.mView.mText_ReceivedTime.text = data.mail_date
	gfdebug(data.remain_time)
	local attachments = data.attachments
	local prefab =  UIUtils.GetGizmosPrefab(UICommonItemS.Path_UICommonItemS,self)
	
	local i = 1
	for k,v in pairs(attachments) do
		local instObj = instantiate(prefab)
		local item = UICommonItemS.New()
		item:InitCtrl(instObj.transform)
		item:InitData(k,v)
		UIUtils.AddListItem(instObj,self.mView.mTrans_AttachmentList.transform)
		
		self.mAttachmentItems[i] = item
		i = i + 1
	end
	if(data.hasLink == true) then
		--链接
		setactive(self.mView.mBtn_ReceiveButton.gameObject, false)
		setactive(self.mView.mTrans_Received.gameObject, false)
	else
		setactive(self.mView.mTrans_Received.gameObject,  data.hasAttachment and data.get_attachment == 1)
		if  data.get_attachment == 0 and data.hasAttachment then
			--有奖励且未领取
			setactive(self.mView.mBtn_ReceiveButton.gameObject, true)
			UIUtils.GetButtonListener(self.mView.mBtn_ReceiveButton.gameObject).onClick = function() self:OnReceiveBtnClicked() end
		else
			--已领取或者无奖励
			setactive(self.mView.mBtn_ReceiveButton.gameObject, false)
		end
	end
end

function UIMailPanel.ClearAttachmentItem()
	self = UIMailPanel
	for i = 1, #self.mAttachmentItems, 1 do
		self.mAttachmentItems[i]:DestroySelf()
	end
	
	self.mAttachmentItem = {}
end


function UIMailPanel:OnReceiveBtnClicked(gameObj)
	--
	--if(self.mCurSelMailItem.mData.IsExpired == true) then
	--	MessageBox.Show("很遗憾", "当前邮件已过期!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
	--	return
	--end
	if self.mCurSelMailItem.mData then
		local attachments = self.mCurSelMailItem.mData.attachments
		for id, num in pairs(attachments) do
			if TipsManager.CheckItemIsOverflow(id, num) then
				return
			end
		end
	end

	local id = self.mCurSelMailItem.mData.id

	NetCmdMailData:SendReqRoleMailGetAttachmentCmd(id, function (ret)
		self:OnReceiveAttachmentCallback(ret)
	end)
end

function UIMailPanel.OnDeleteBtnClicked(gameObj)
	self = UIMailPanel
	local id = self.mCurSelMailItem.mData.id
	local ids = {}
	ids[1] = id

	NetCmdMailData:SendReqRoleMailDelCmd(ids, self.OnMailDeleteCallback)
	self.mIsSyncOn = true
end

function UIMailPanel:OnDeleteAllBtnClicked(gameObj)
	self = UIMailPanel
	if self:HasCanDelMail() then
		if self.tipsItem == nil then
			self.tipsItem = UIMailTipsItem.New()
			self.tipsItem:InitCtrl(self.mView.mUIRoot)

			UIUtils.GetButtonListener(self.tipsItem.mBtn_Cancel.gameObject).onClick = self.CloseMailTips
			UIUtils.GetButtonListener(self.tipsItem.mBtn_Confirm.gameObject).onClick = self.ConfirmMailTips
		end
		local title = TableData.GetHintById(60003)
		local context = TableData.GetHintById(60004)
		self.tipsItem:InitData(title, context)
	end
end

function UIMailPanel.OnLinkBtnClicked(gameObj)
	self = UIMailPanel
	
	if(self.mCurSelMailItem.mData.IsExpired == true) then
		MessageBox.Show("很遗憾", "当前邮件已过期!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
		return
	end
end

function UIMailPanel.OnAllReceive(gameObj)
	self = UIMailPanel
	if self:HasNotGetAttachment() then
		local firstOverflow = self:CheckAllReceiveItem()
		if firstOverflow ~= nil then
			if TipsManager.CheckItemIsOverflow(firstOverflow.id, firstOverflow.num) then
				return
			end
		end
		NetCmdMailData:SendReqRoleMailGetAttachmentsCmd(self.GetRewardCallBack)
	end
end

function UIMailPanel:OnReceiveAttachmentCallback(ret)
	
	if ret == CS.CMDRet.eSuccess then
		local rewardList = self.mCurSelMailItem.mData.attachments
		local title = TableData.GetHintById(60001)
		UIManager.OpenUIByParam(UIDef.UICommonReceivePanel)

		self.mCachedMailList:Clear()
		self.mCachedMailList = nil
		self.mCurSelMailItem  = nil
		self:UpdateMailList()
		--setactive(self.mView.mBtn_AllDeleteButton.gameObject, self:HasCanDelMail())
		--setactive(self.mView.mBtn_BottomPanel_AllReceiveButton.gameObject, self:HasNotGetAttachment())

		--- RedPoint
		self:UpdateRedPoint()
	else
		gfdebug("领取失败")
		MessageBox.Show("出错了", TableData.GetHintById(70041), MessageBox.ShowFlag.eMidBtn, nil, function ()
			UIMailPanel.mCachedMailList:Remove(UIMailPanel.mCurSelMailItem.mData)
			if UIMailPanel.mCurSelMailItem.mIndex + 1 > UIMailPanel.mCachedMailList.Count then
				UIMailPanel.mCurSelMailItem = nil
				UIMailPanel.mView.mTrans_MailList.offsetMax = Vector2(UIMailPanel.mView.mTrans_MailList.offsetMax.x, 0)
			end
			UIMailPanel:UpdateMailList()
		end , nil)
	end
end

function UIMailPanel.OnMailDeleteCallback(ret)
	self = UIMailPanel
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
		MessageBox.Show("出错了", "删除邮件失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
	end
	
end

function UIMailPanel.OnAllMailDeleteCallback(ret)
	self = UIMailPanel
	self.mIsSyncOn = false
	
	if ret == CS.CMDRet.eSuccess then
		gfdebug("删除邮件成功")	
		self.mCachedMailList:Clear()
		self.mCachedMailList = nil
		self.mCurSelMailItem  = nil
		self:UpdateMailList()
		-- self.mView.mScrollBar.value = 1

		--- redPoint
		self:UpdateRedPoint()
	else
		gfdebug("删除邮件失败")
		MessageBox.Show("出错了", "删除邮件失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
	end
end

function UIMailPanel.OnReturnClick(gameObj)	
    self = UIMailPanel
	self.Close()
end

function UIMailPanel.OnCommanderCenter()
	UIManager.JumpToMainPanel()
end

function UIMailPanel.OnRelease()
    self = UIMailPanel
	
	self.mCurSelMailItem = nil
	self.mMailListItems = {}
	self.mAttachmentItems = {}
	self.mCachedMailList = nil
	self.mIsSyncOn = false
	self.tipsItem = nil
	
	MessageSys:RemoveListener(10007, self.OnAvgOver)
end

function UIMailPanel.GetRewardCallBack(ret)
	self = UIMailPanel

	if ret == CS.CMDRet.eSuccess then
		local rewardList = NetCmdMailData:GetAllAttachments()
		local title = TableData.GetHintById(60001)
		UIManager.OpenUIByParam(UIDef.UICommonReceivePanel)

		self.mCachedMailList:Clear()
		self.mCachedMailList = nil
		self.mCurSelMailItem  = nil
		self:UpdateMailList()
		-- self.mView.mScrollBar.value = 1

		--- redPoint
		self:UpdateRedPoint()
	else
		printstack("一键领取邮件失败")
	end
end

-- 筛选邮件（已读邮件，已领附件邮件）
function UIMailPanel:FiltrateMail()
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

function UIMailPanel:HasNotGetAttachment()
	for _,item in pairs(self.mCachedMailList) do
		if item.hasAttachment and item.get_attachment == 0 then
			return true
		end
	end
	return false
end

function UIMailPanel:CheckAllReceiveItem()
	local firstItem = nil
	for _, item in pairs(self.mCachedMailList) do
		if item.hasAttachment and item.get_attachment == 0 then
			for id, num in pairs(item.attachments) do
				if firstItem == nil then
					firstItem = {}
					firstItem.id = id
					firstItem.num = num
				end
				if not TipsManager.CheckItemIsOverflow(id, num, false) then
					return nil
				end
			end
		end
	end

	return firstItem
end

function UIMailPanel:HasCanDelMail()
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

function UIMailPanel.CloseMailTips()
	self = UIMailPanel
	if self.tipsItem then
		self.tipsItem:CloseTips()
	end
end

function UIMailPanel.ConfirmMailTips()
	self = UIMailPanel

	if self.tipsItem then
		self.tipsItem:CloseTips()
	end

	local ids = self:FiltrateMail()
	NetCmdMailData:SendReqRoleMailDelCmd(ids, self.OnAllMailDeleteCallback)
end

function UIMailPanel:CollectItem(itemList)
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
