require("UI.UIBaseCtrl")

UISystemCommonItem = class("UISystemCommonItem", UIBaseCtrl)
UISystemCommonItem.__index = UISystemCommonItem

function UISystemCommonItem:__InitCtrl()

	self.mBtn_ShowSys = self:GetButton("Btn_ShowSys")
	self.mImage_SysBG = self:GetImage("Btn_ShowSys/Image_SysBG")
	self.mImage_SystemIcon = self:GetImage("Btn_ShowSys/Image_SystemIcon")
	self.mTrans_RedPoint = self:GetRectTransform("Btn_ShowSys/Trans_RedPoint")
end

function UISystemCommonItem:InitCtrl(parent)
	local obj = instantiate(UIUtils.GetGizmosPrefab("Currency/UISystemCommonItem.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end
	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UISystemCommonItem:OnRelease()
	RedPointSystem:GetInstance():RemoveRedPointListener(self.redPointType)
	self:DestroySelf()
end

function UISystemCommonItem:SetData(itemData, parent)
	self.systemIcon = itemData.systemIcon
	self.switchID = itemData.jumpID
	self.parentTrans = parent
	self.redPointType = self:GetRedPointType(itemData.jumpID)
	self.mImage_SystemIcon.sprite = IconUtils.GetSystemIcon(self.systemIcon)

	setactive(self.mTrans_RedPoint, false)

	UIUtils.GetButtonListener(self.mBtn_ShowSys.gameObject).onClick = function()
		self:onClickSystemBtn()
	end

	RedPointSystem:GetInstance():AddRedPointListener(self.redPointType, self.mTrans_RedPoint)
end

function UISystemCommonItem:onClickSystemBtn()
	SceneSwitch:SwitchByID(self.switchID)
end

function UISystemCommonItem:GetRedPointType(jumpId)
	if jumpId == 8 then
		return RedPointConst.Mails
	else
		return nil
	end
end