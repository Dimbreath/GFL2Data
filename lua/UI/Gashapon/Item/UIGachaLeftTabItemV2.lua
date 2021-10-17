require("UI.UIBaseCtrl")

---@class UIGachaLeftTabItemV2 : UIBaseCtrl
UIGachaLeftTabItemV2 = class("UIGachaLeftTabItemV2", UIBaseCtrl);
UIGachaLeftTabItemV2.__index = UIGachaLeftTabItemV2
--@@ GF Auto Gen Block Begin
UIGachaLeftTabItemV2.mImg_Icon = nil;
UIGachaLeftTabItemV2.mText_Name = nil;

function UIGachaLeftTabItemV2:__InitCtrl()

	self.mImg_Icon = self:GetImage("GrpIcon/Img_Icon");
	self.mText_Name = self:GetText("GrpText/Text_Name");

	self.mBtn_GachaEventBtn = self:GetSelfButton();
end

--@@ GF Auto Gen Block End

function UIGachaLeftTabItemV2:InitCtrl(parent)
	local obj = instantiate(UIUtils.GetGizmosPrefab("Gashapon/GashaponMainLeftTabItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIGachaLeftTabItemV2:SetData(data)
	self.mEventData = data;
	self.mText_Name.text = data.Name
	self.mImg_Icon.sprite = IconUtils.GetAtlasV2("GashaponPic", "Icon_Gashapon_" .. data.Type);
end

function UIGachaLeftTabItemV2:SetSelect(isSelect)
	self.mBtn_GachaEventBtn.interactable =  (not isSelect);
end