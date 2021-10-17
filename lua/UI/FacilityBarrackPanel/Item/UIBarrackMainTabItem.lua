require("UI.UIBaseCtrl")

---@class UIBarrackMainTabItem : UIBaseCtrl
UIBarrackMainTabItem = class("UIBarrackMainTabItem", UIBaseCtrl)
UIBarrackMainTabItem.__index = UIBarrackMainTabItem

function UIBarrackMainTabItem:__InitCtrl()
	self.mBtn = self:GetSelfButton()
	self.mImage_Icon = self:GetImage("GrpElement/ImgIcon")
	self.mImage_IconBg = self:GetImage("GrpElement/ImgBg")
	self.mText_Name = self:GetText("GrpText/Text_Name")
	self.mText_ENName = self:GetText("GrpText/Text_ENName")
	self.mText_ENNameplete = self:GetText("GrpText/Text_ENNameComplete")
end

--@@ GF Auto Gen Block End

function UIBarrackMainTabItem:InitCtrl(parent)
	local obj = instantiate(UIUtils.GetGizmosPrefab("Character/ChrCardMainTabListItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIBarrackMainTabItem:InitObj(obj)
	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIBarrackMainTabItem:SetData(data)
	if data then
		self.type = data.id
		if data.id ~= 0 then
			self.mImage_Icon.sprite = IconUtils.GetGunTypeIcon(data.icon)
			self.mText_Name.text = data.name.str
		else
			self.mText_Name.text = TableData.GetHintById(101006)
		end
		UIUtils.SetInteractive(self.mUIRoot, true)
	else
		UIUtils.SetInteractive(self.mUIRoot, false)
	end
end