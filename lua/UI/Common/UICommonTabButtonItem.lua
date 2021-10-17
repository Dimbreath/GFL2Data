require("UI.UIBaseCtrl")

UICommonTabButtonItem = class("UICommonTabButtonItem", UIBaseCtrl)
UICommonTabButtonItem.__index = UICommonTabButtonItem

function UICommonTabButtonItem:__InitCtrl()
	self.mText_CommonTabButtonItem_TabButtonNormal_TabName = self:GetText("UI_Trans_TabButtonNormal/Text_TabName")
	self.mText_CommonTabButtonItem_TabButtonNormal_TabName2 = self:GetText("UI_Trans_TabButtonNormal/Text_TabName2")
	self.mText_CommonTabButtonItem_TabButtonSelected_TabName = self:GetText("UI_Trans_TabButtonSelected/Text_TabName")
	self.mText_CommonTabButtonItem_TabButtonSelected_TabName2 = self:GetText("UI_Trans_TabButtonSelected/Text_TabName2")
	self.mTrans_CommonTabButtonItem_TabButtonNormal = self:GetRectTransform("UI_Trans_TabButtonNormal")
	self.mTrans_CommonTabButtonItem_TabButtonSelected = self:GetRectTransform("UI_Trans_TabButtonSelected")
	self.mTrans_CommonTabButtonItem_RedPoint = self:GetRectTransform("Trans_RedPoint")
	self.mTrans_Locked = self:GetRectTransform("Trans_locked")
	self.mBtn_ClickTab = self:GetSelfButton()
end

function UICommonTabButtonItem:ctor()
	self.data = nil
	self.tagId = 0
	self.systemId = 0
	self.isChoose = false
	self.callback = nil
	self.isLock = false
end

function UICommonTabButtonItem:InitCtrl(root)

	self:SetRoot(root)

	self:__InitCtrl()
end

function UICommonTabButtonItem:SetData(data)
	self.data = data
	if data then
		self.mText_CommonTabButtonItem_TabButtonNormal_TabName.text = data.type_name.str
		self.mText_CommonTabButtonItem_TabButtonNormal_TabName2.text = data.type_english_name
		self.mText_CommonTabButtonItem_TabButtonSelected_TabName.text = data.type_name.str
		self.mText_CommonTabButtonItem_TabButtonSelected_TabName2.text = data.type_english_name

		setactive(self.mUIRoot, true)
	else
		setactive(self.mUIRoot, false)
	end
end

function UICommonTabButtonItem:SetName(id, name, en_name)
	if name then
		self.tagId = id
		self.mText_CommonTabButtonItem_TabButtonNormal_TabName.text = name
		self.mText_CommonTabButtonItem_TabButtonNormal_TabName2.text = en_name
		self.mText_CommonTabButtonItem_TabButtonSelected_TabName.text = name
		self.mText_CommonTabButtonItem_TabButtonSelected_TabName2.text = en_name

		setactive(self.mUIRoot, true)
	else
		setactive(self.mUIRoot, false)
	end

	self:UpdateAchieveTag()
end

function UICommonTabButtonItem:SetItemState(isChoose)
	self.isChoose = isChoose
	setactive(self.mTrans_CommonTabButtonItem_TabButtonNormal.gameObject, not self.isChoose)
	setactive(self.mTrans_CommonTabButtonItem_TabButtonSelected.gameObject, self.isChoose)
end

function UICommonTabButtonItem:UpdateRedPoint()
	printstack(self.data.type)
	local hasNew = NetCmdQuestData:CheckIshaveGetReward(self.data.type)
	if self.data.type == 2 then
		for i = 1, 4 do
			local state = NetCmdQuestData:CheckCanGetWeeklyRewardByID(i)
			if state == 1 then
				hasNew = true
				break
			end
		end
	end
	setactive(self.mTrans_CommonTabButtonItem_RedPoint, hasNew)
end

function UICommonTabButtonItem:UpdateSystemLock()
	if self.systemId == 0 or self.systemId == nil then
		self.isLock = false
	else
		self.isLock = not AccountNetCmdHandler:CheckSystemIsUnLock(self.systemId)
	end
	setactive(self.mTrans_Locked, self.isLock)
end

function UICommonTabButtonItem:UpdateAchieveTag()
	setactive(self.mTrans_CommonTabButtonItem_RedPoint, false)
end

function UICommonTabButtonItem:SetEnable(enable)
	setactive(self.mUIRoot, enable)
end
