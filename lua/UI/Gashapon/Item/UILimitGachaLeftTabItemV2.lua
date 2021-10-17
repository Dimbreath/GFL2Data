require("UI.UIBaseCtrl")

---@class UILimitGachaLeftTabItemV2 : UIBaseCtrl
UILimitGachaLeftTabItemV2 = class("UILimitGachaLeftTabItemV2", UIBaseCtrl);
UILimitGachaLeftTabItemV2.__index = UILimitGachaLeftTabItemV2
--@@ GF Auto Gen Block Begin
UILimitGachaLeftTabItemV2.mImg_Icon = nil;
UILimitGachaLeftTabItemV2.mText_Bg = nil;
UILimitGachaLeftTabItemV2.mText_Name = nil;

function UILimitGachaLeftTabItemV2:__InitCtrl()

	self.mImg_Icon = self:GetImage("GrpIcon/Img_Icon");
	self.mText_Bg = self:GetText("GrpBg/TextBg");
	self.mText_Name = self:GetText("GrpText/Text_Name");
	self.mBtn_GachaEventBtn = self:GetSelfButton();
end

--@@ GF Auto Gen Block End

function UILimitGachaLeftTabItemV2:InitCtrl(parent)
	local obj = instantiate(UIUtils.GetGizmosPrefab("Gashapon/GashaponMainLimitOrderItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UILimitGachaLeftTabItemV2:SetData(data)
	self.mEventData = data;
	self.mText_Name.text = data.Name
	self.mImg_Icon.sprite = IconUtils.GetAtlasV2("GashaponPic", "Icon_Gashapon_" .. data.Type);
end

function UILimitGachaLeftTabItemV2:SetSelect(isSelect)
	self.mBtn_GachaEventBtn.interactable =  (not isSelect);
end
