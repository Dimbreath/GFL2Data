---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 18/11/7 20:31
---

--- 这个panle的数据接入统一走金大人下发的道具信息

require("UI.UIBasePanel")

UIRaidReceivePanel = class("UIRaidReceivePanel", UIBasePanel)
UIRaidReceivePanel.__index = UIRaidReceivePanel

UIRaidReceivePanel.mView = nil

UIRaidReceivePanel.itemList = {}
UIRaidReceivePanel.gunList = nil
UIRaidReceivePanel.itemViewList = {}
UIRaidReceivePanel.hasGun = false
UIRaidReceivePanel.callback = nil
UIRaidReceivePanel.mergeItem = false

function UIRaidReceivePanel:ctor()
	UIRaidReceivePanel.super.ctor(self)
end

function UIRaidReceivePanel.Open()
	self = UIRaidReceivePanel
end

function UIRaidReceivePanel.Close()
	self = UIRaidReceivePanel

	UIManager.CloseUI(UIDef.UIRaidReceivePanel)
	

	if UIRaidReceivePanel.callback ~= nil then
		UIRaidReceivePanel.callback()
		UIRaidReceivePanel.callback = nil
	end

	if AccountNetCmdHandler.IsLevelUpdate==true then
		UICommonLevelUpPanel.Open(UICommonLevelUpPanel.ShowType.CommanderLevelUp)
	end 
end

function UIRaidReceivePanel.Hide()
	self = UIRaidReceivePanel
	self:Show(false)
end

function UIRaidReceivePanel.Init(root, data)
	self = UIRaidReceivePanel

	self.mIsPop = true

	UIRaidReceivePanel.super.SetRoot(UIRaidReceivePanel, root)
	UIRaidReceivePanel.mView = UIRaidReceivePanelView
	UIRaidReceivePanel.mView:InitCtrl(root)

	if data then
		if data[4] == nil then
			self.mergeItem = false
		else
			self.mergeItem = true
		end
		self.itemlist = data[1] == nil and self:InitItemList(NetCmdItemData:GetUserDropCache()) or data[1]

		self.callback = data[2]
		if data[3] ~= nil and next(data[3]) == nil then
			self.gunList = nil
		else
			self.gunList = data[3] == nil and NetCmdItemData:GetUserDropGunChache()
		end

		if data[5] ~= nil and data[5] == true then
			self:UpdateRaid()
		end
	else
		self.itemlist = self:InitItemList(NetCmdItemData:GetUserDropCache())
		self.gunList = NetCmdItemData:GetUserDropGunChache()
		self.callback = nil
		self.mergeItem = false
	end

	
end

function UIRaidReceivePanel.OnInit()
	self = UIRaidReceivePanel
	

	UIUtils.GetButtonListener(self.mView.mBtn_Confirm.gameObject).onClick = function()
		UIRaidReceivePanel.Close()
	end

	-- self:UpdatePanel()
end

function UIRaidReceivePanel.OnShow()
	self = UIRaidReceivePanel
	if(#self.itemlist == 0) then
		UIRaidReceivePanel.Close()
		return;
	end
	
	UIRaidReceivePanel:UpdatePanel()
	local canvasGroup = self.mUIRoot:Find("Root"):GetComponent("CanvasGroup")
	if(canvasGroup ~= nil and not canvasGroup:Equals(nil) ) then
    	canvasGroup.blocksRaycasts = true;
	end
end

function UIRaidReceivePanel:UpdatePanel()
	if self.itemlist ~= nil then
		for _, item in ipairs(self.itemlist) do
			local itemView = self:GetAppropriateItem(item.ItemId, item.ItemNum, item.RelateId);
		end
	end

	setactive(self.mView.mTrans_Receive, self.gunList == nil or self.gunList.Length <= 0)

	self:CheckHasGun()
end

function UIRaidReceivePanel:GetAppropriateItem(itemId,itemNum,relateId)

	local itemData = TableData.GetItemData(itemId)
	if itemData == nil then
		return nil;
	end

	if itemData.type == 8 then --武器
		local weaponInfoItem = UICommonWeaponInfoItem.New()
		weaponInfoItem:InitCtrl(self.mView.mTrans_ItemList)
		weaponInfoItem:SetData(itemData.args[0], 0)
		 
		return weaponInfoItem
	else
		---@type UICommonItem
		local itemView = UICommonItem.New();
		itemView:InitCtrl(self.mView.mTrans_ItemList)
		if itemData.type == 5 then --模组
			itemView:SetEquipData(itemData.args[0],0,nil,itemId, relateId)
		else
			itemView:SetItemData(itemId, itemNum)
		end
		return itemView;
	end
end


function UIRaidReceivePanel:UpdateRaid()

	setactive(self.mView.mTrans_RaidPanel,true)
	local levelup = AFKBattleManager.PlayerExpData.curLevel - AFKBattleManager.PlayerExpData.beginLevel;
    self.mView.mText_ExpAdd.text = "+"..AFKBattleManager.PlayerExpData:GetAddExp();
    self.mView.mText_Lv.text = "Lv."..AFKBattleManager.PlayerExpData.beginLevel;
    self.mView.mImage_ExpBefore.fillAmount = AFKBattleManager.PlayerExpData:GetOldExpPct();

    local last_level = AFKBattleManager.PlayerExpData.beginLevel + AFKBattleManager.PlayerExpData:GetOldExpPct();
    local cur_level = AFKBattleManager.PlayerExpData.curLevel + AFKBattleManager.PlayerExpData:GetExpPct();

	if last_level >= TableData.GlobalSystemData.CommanderLevel then
		last_level = TableData.GlobalSystemData.CommanderLevel;
		self.mView.mImage_ExpBefore.fillAmount = 1;
	end

	if cur_level > TableData.GlobalSystemData.CommanderLevel then
		cur_level = TableData.GlobalSystemData.CommanderLevel;
	end

    CS.ProgressBarAnimationHelper.Play(self.mView.mImage_ExpAfter,last_level,cur_level,2,
    function (lv)
        print(lv);
        self.mView.mText_Lv.text = "Lv."..lv
		setactive(self.mView.mImage_ExpBefore.transform,false);
    end,
    function ()
        if AccountNetCmdHandler.IsLevelUpdate==true then
            UICommonLevelUpPanel.Open(UICommonLevelUpPanel.ShowType.CommanderLevelUp)
        end 
    end);
end

function UIRaidReceivePanel.OnRelease()
	self = UIRaidReceivePanel
	UIRaidReceivePanel.itemList = {}
	UIRaidReceivePanel.gunList = nil
	UIRaidReceivePanel.itemViewList = {}
end

function UIRaidReceivePanel:CheckHasGun()
	if self.gunList ~= nil and self.gunList.Length > 0 then
		UICommonGetGunPanel.OpenGetGunPanel(self.gunList ,function () setactive(self.mView.mTrans_Receive, true) end)
	end
end

function UIRaidReceivePanel:InitItemList(data)
	local itemList = {}
	local dicExItem = {}
	for i = 0, data.Count - 1 do
		local itemId = data[i].ItemId
		local itemData = TableData.GetItemData(itemId)
		local typeData = TableData.listItemTypeDescDatas:GetDataById(itemData.type)
		if itemData.type == GlobalConfig.ItemType.GunType and data[i].ItemNum <= 0 then
			for id, num in pairs(data[i].ExtItems) do
				if dicExItem[id] then
					dicExItem[id] = dicExItem[id] + num
				else
					dicExItem[id] = num
				end
			end
		else
			if self.mergeItem and typeData.pile > 0 then
				if dicExItem[itemId] then
					dicExItem[itemId] = dicExItem[itemId] + data[i].ItemNum
				else
					dicExItem[itemId] = data[i].ItemNum
				end
			else
				table.insert(itemList, data[i])
			end
		end
	end

	for id, num in pairs(dicExItem) do
		local item = {}
		item.ItemId	 = id
		item.ItemNum = num
		item.RelateId = 0

		table.insert(itemList, item)
	end

	table.sort(itemList, function (a, b)
		local data1 = TableData.GetItemData(a.ItemId)
		local data2 = TableData.GetItemData(b.ItemId)
		local typeData1 = TableData.listItemTypeDescDatas:GetDataById(data1.type)
		local typeData2 = TableData.listItemTypeDescDatas:GetDataById(data2.type)

		if typeData1.rank == typeData2.rank then
			if data1.rank == data2.rank then
				return a.RelateId < b.RelateId
			end
			return data1.rank > data2.rank
		end
		return typeData1.rank > typeData2.rank
	end)
	return itemList
end