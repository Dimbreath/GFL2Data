require("UI.UIBaseCtrl")

ResourcesCommonItem = class("ResourcesCommonItem", UIBaseCtrl)
ResourcesCommonItem.__index = ResourcesCommonItem

function ResourcesCommonItem:ctor()
	self.itemID = 0
	self.switchID = 0
end

function ResourcesCommonItem:__InitCtrl()
	self.mBtn_Plus = self:GetButton("GrpRight")
	self.mTrans_Right = self:GetRectTransform("GrpRight")
	self.mImage_ResRank = self:GetImage("GrpBg/ImgBg")
	self.mImage_ResourceIcon = self:GetImage("GrpItemIcon/Img_Icon")
	self.mText_Num = self:GetText("Text_Num")
	self.mBtn_SelfButton = self:GetSelfButton()
	self.mAnimator = self:GetSelfAnimator()
end

function ResourcesCommonItem:InitCtrl(parent,isCommandCenter)
	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComBtnCurrencyItemV2.prefab", self))
	--local obj = instantiate(UIUtils.GetGizmosPrefab("Currency/ResourcesCommonItem.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end
    self:SetRoot(obj.transform)
    self:__InitCtrl()
	self.mAnimator = obj:GetComponent("Animator");
	if self.mAnimator ~= nil and isCommandCenter ~= nil and isCommandCenter == true then
		self.mAnimator:SetBool("CommandCenterW", false);
	elseif self.mAnimator ~= nil then
		self.mAnimator:SetBool("CommandCenterW", true);
	end
end

function ResourcesCommonItem:OnShow()
	if self.mAnimator ~= nil and isCommandCenter ~= nil and isCommandCenter == true then
		self.mAnimator:SetBool("CommandCenterW", false);
	elseif self.mAnimator ~= nil then
		self.mAnimator:SetBool("CommandCenterW", true);
	end
end

function ResourcesCommonItem:OnRelease()
	self:DestroySelf()
end

function  ResourcesCommonItem:OnUpdate()
	self:UpdateStaminaData()
end

function  ResourcesCommonItem:SetData(itemData,paramData)
	self.itemID = itemData["id"]
	self.switchID = itemData["jumpID"]
	self.jumpParam = itemData["param"]
	self.mImage_ResourceIcon.sprite = IconUtils.GetItemIconSprite(self.itemID)
	--self.mImage_ResRank.color = TableData.GetGlobalGun_Quality_Color2(TableData.GetItemData(self.itemID).rank)

	setactive(self.mTrans_Right.gameObject, self.switchID ~= nil)
	if self.switchID then
		UIUtils.GetButtonListener(self.mBtn_Plus.gameObject).onClick = function()
			self:OnAddResBtnClicked()
		end
	end

	self:UpdateData(paramData)
end

function ResourcesCommonItem:UpdateData(paramData)
	local itemData = TableData.GetItemData(self.itemID)
	local count = 0
	if itemData then
		count = NetCmdItemData:GetItemCountById(self.itemID)
		--if itemData.type == 1 then
		--	count = NetCmdItemData:GetResItemCount(self.itemID)
		--elseif itemData.type == 3 then
		--	count = NetCmdItemData:GetItemCount(self.itemID)
		--elseif itemData.type == 6 then
		--	count = GlobalData.GetStaminaResourceItemCount(self.itemID)
		--end
	end

	-- 如果是爬塔的体力要判断
	if self.itemID == 9 then
		self.mText_Num.text = count .. "/" .. TableData.GlobalConfigData.SimtrainingTimes
	elseif itemData.type == GlobalConfig.ItemType.StaminaType then
		self.mText_Num.text = count .. "/".. GlobalData.GetStaminaResourceMaxNum(self.itemID)

		if(self.switchID~= nil) then
			local jumpData = TableData.listJumpListDatas:GetDataById(self.switchID)
			local unlockId = jumpData.unlock_id;
			if(not AccountNetCmdHandler:CheckSystemIsUnLock(unlockId)) then
				setactive(self.mTrans_Right,false)
			end
		end
	else
		local strCount = self.ChangeNumDigit(tonumber(count))
		self.mText_Num.text = strCount
	end
	if paramData~=nil then
		TipsManager.Add(self.mBtn_SelfButton.gameObject, itemData, count, false, itemData.type == 6,
				nil,paramData[1],paramData[2])
	else
		TipsManager.Add(self.mBtn_SelfButton.gameObject, itemData, count, false, itemData.type == 6)
	end
end

function ResourcesCommonItem:UpdateStaminaData()
	local itemData = TableData.GetItemData(self.itemID)
	if itemData.type == GlobalConfig.ItemType.StaminaType then
		local count = GlobalData.GetStaminaResourceItemCount(self.itemID)
		self.mText_Num.text = count .. "/"..GlobalData.GetStaminaResourceMaxNum(self.itemID)
	end
end

function ResourcesCommonItem:OnAddResBtnClicked()
	if self.itemID == GlobalConfig.StaminaId then
		UIManager.OpenUIByParam(UIDef.UICommonGetPanel)
	else
		local paramArray = {self.jumpParam}
		SceneSwitch:SwitchByID(self.switchID, paramArray)
	end
end

--- 数量转化
function ResourcesCommonItem.ChangeNumDigit(num)
	if type(num) ~= "number" then
		return num
	end
	if num < 10^6 then
		return num
	elseif num >= 10^6 and num < 10^7 then
		return string.format('%dK',math.modf(num/10^3))
	elseif num >= 10^7 and num < 10^10 then
		return string.format('%dM',math.modf(num/10^6))
	elseif num >= 10^10 and num < 10^13 then
		return string.format('%dB', math.modf(num/10^9))
	else
		return  num
	end
end