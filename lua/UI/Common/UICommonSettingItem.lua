require("UI.UIBaseCtrl")
---@class UICommonSettingItem : UIBaseCtrl
UICommonSettingItem = class("UICommonSettingItem", UIBaseCtrl)
UICommonSettingItem.__index = UICommonSettingItem

function UICommonSettingItem:ctor()
	self.itemId = 0
	self.itemNum = 0
	self.isItemEnough = false
	self.relateId = nil
end

function UICommonSettingItem:__InitCtrl()
	self.mText_Name = self:GetText("GrpName/Text_Name");
	self.mText_Num = self:GetText("GrpState/Trans_GrpSlider/Text_Num");
	self.mTrans_Slider = self:GetRectTransform("GrpState/Trans_GrpSlider");
	self.mTrans_GrpBtn = self:GetRectTransform("GrpState/Trans_GrpBtn");
	self.mTrans_Screen = self:GetRectTransform("GrpState/Trans_Screen");

	self.mSlider = self:GetSlider("GrpState/Trans_GrpSlider/GrpSlider");
	self.rectTransform = self:GetRectTransform("GrpState")
	self.animator = self:GetSelfAnimator()
end

function UICommonSettingItem:InitCtrl(parent, callback)
	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComSettingItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()

	self.mBtnList = {}
	self.mDropDownItemList = {}
	local screenObj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComSettingScreenItemV2.prefab", self))
	CS.LuaUIUtils.SetParent(screenObj.gameObject, self.mTrans_Screen.gameObject, true)
	self.mText_Screen = UIUtils.GetText(screenObj, "Btn_Dropdown/Text_Name")
	self.mBtn_Screen = UIUtils.GetButton(screenObj, "Btn_Dropdown")
	self.isSortDropDownActive = false

	UIUtils.GetButtonListener(self.mBtn_Screen.gameObject).onClick = function()
		if callback ~= nil then callback() end
	end
end

function UICommonSettingItem:OnDropDown()
	self.isSortDropDownActive = not self.isSortDropDownActive
	setactive(self.mList_Screen.transform, self.isSortDropDownActive)
end

function UICommonSettingItem:SetData(data)
	self.mText_Name.text = data.name;
	if data.type == nil then
		self.type = 1;
	end
	self.type = data.type;
	setactive(self.mTrans_Slider, self.type == 1)
	setactive(self.mTrans_Screen, self.type == 2)
	setactive(self.mTrans_GrpBtn, self.type == 3)
	if (data.type == 1) then
		self:SetValue(data.value)
		self.mSlider.onValueChanged:AddListener(data.listener)
	elseif (data.type == 2) then
		self:InitScreen(data)
	elseif (data.type == 3) then
		self:InitButtons(data)
	end
end

function UICommonSettingItem:RefreshScreenPos()
	local pos = self.mList_Screen.transform.localPosition
	if self.mData.id == UISettingSubPanel.GraphicSettings.Resolution then
		self.mList_Screen.transform.offsetMax = Vector2(0, -55)
		self.mList_Screen.transform.offsetMin = Vector2(0, -600)
	else
		self.mList_Screen.transform.localPosition = Vector3(pos.x, - 140 + (5 - #self.list) * 20, pos.z)
		TimerSys:DelayCall(0.1, function()
			local position = CS.UnityEngine.RectTransformUtility.CalculateRelativeRectTransformBounds(UISystem.rootCanvasTrans, self.mContent_Screen.transform).center;
			if position.y - #self.list * 20 / 2 < - UISystem.rootCanvasTrans:GetComponent("CanvasScaler").referenceResolution.y / 2 then
				self.mList_Screen.transform.localPosition = Vector3(pos.x, 140 - (5 - #self.list) * 20, pos.z)
			end
		end)
	end
end

function UICommonSettingItem:InitScreen(data)
	self.list = data.list
	self.mData = data
	local sortOptionPrefab = UIUtils.GetGizmosPrefab("UICommonFramework/ComSettingDropDownItemV2.prefab", self)
	if(data.id == UISettingSubPanel.GraphicSettings.Resolution) then
		self.mList_Screen = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComSettingViewModeDropDownListItemV2.prefab", self))
	else
		self.mList_Screen = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComSettingDropDownListItemV2.prefab", self))
	end
	CS.LuaUIUtils.SetParent(self.mList_Screen.gameObject, self.mTrans_Screen.gameObject, true)
	self.mContent_Screen = UIUtils.GetRectTransform(self.mList_Screen, "GrpScreenList/Viewport/Content")
	UIUtils.GetBlockHelper(self.mList_Screen).onHide = function()
		self.isSortDropDownActive = false
		setactive(self.mList_Screen.transform, self.isSortDropDownActive)
		self.animator:SetTrigger("Normal")
	end
	setactive(self.mList_Screen.transform, self.isSortDropDownActive)
	for i = 1, #data.list do
		---@type UICommonSettingDropDownItem
		local item = UICommonSettingDropDownItem.New()
		local obj = instantiate(sortOptionPrefab, self.mContent_Screen.transform)
		item:InitCtrl(obj.transform)
		item:SetData({id = i, name = data.list[i]})
		UIUtils.GetButtonListener(item.mBtn_Select.gameObject).onClick = function()
			if data.id == UISettingSubPanel.GraphicSettings.FPS and item.id == 2 and CS.GameRoot.Instance.AdapterPlatform == CS.PlatformSetting.PlatformType.Mobile then
				MessageBox.Show(TableData.GetHintById(64), TableData.GetHintById(104050), nil, function()
					self:OnClickDropDown(item.id)
					data.listener(item.id - 1)
				end, function()
					self:OnDropDown()
				end , 0, 100)
			else
				self:OnClickDropDown(item.id)
				data.listener(item.id - 1)
			end
		end
		self.mDropDownItemList[i] = item
		if (i == data.value + 1) then
			item.mBtn_Select.interactable = false
		end
	end
	self:SetDropDownValue(data.value)
end

function UICommonSettingItem:SetDropDownValue(value)
	self.selected = value + 1
	self.mText_Screen.text = self.list[self.selected]
	for i = 1, #self.list do
		if (self.selected == i) then
			self.mDropDownItemList[i].mBtn_Select.interactable = false
		else
			self.mDropDownItemList[i].mBtn_Select.interactable = true
		end
	end
end

function UICommonSettingItem:OnClickDropDown(index)
	self.selected = index
	self.mText_Screen.text = self.list[index]
	for i = 1, #self.list do
		if (index == i) then
			self.mDropDownItemList[i].mBtn_Select.interactable = false
		else
			self.mDropDownItemList[i].mBtn_Select.interactable = true
		end
	end
	setactive(self.mList_Screen.transform, false)
	self.isSortDropDownActive = false
end

function UICommonSettingItem:SetValue(value)
	self.mSlider.value = value;
	self.mText_Num.text = FormatNum(math.floor(value * 100));
end

function UICommonSettingItem:InitButtons(data)
	self.list = data.list
	local button = UIUtils.GetGizmosPrefab("CommanderInfo/CommanderInfoBtnItemV2.prefab", self)

	for i = 1, #data.list do
		---@type UICommonSettingButtonItem
		local item = UICommonSettingButtonItem.New()
		local obj = instantiate(button, self.mTrans_GrpBtn)
		item:InitCtrl(obj.transform)
		item:SetData({id = i, name = data.list[i]})
		UIUtils.GetButtonListener(item.mBtn_Select.gameObject).onClick = function()
			self:OnClickButton(item)
			data.listener(item.id - 1)
		end
		self.mBtnList[i] = item
	end
	self:SetButtonGroupValue(data.value)
end

function UICommonSettingItem:SetButtonGroupValue(value)
	self:OnClickButton(self.mBtnList[value + 1])
end

function UICommonSettingItem:OnClickButton(item)
	for i = 1, #self.mBtnList do
		if item ~= self.mBtnList[i] then
			self.mBtnList[i].mBtn_Select.interactable = true
		else
			self.mBtnList[i].mBtn_Select.interactable = false
		end
	end
end
