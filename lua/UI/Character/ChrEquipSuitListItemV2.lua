require("UI.UIBaseCtrl")

---@class ChrEquipSuitListItemV2 : UIBaseCtrl
ChrEquipSuitListItemV2 = class("ChrEquipSuitListItemV2", UIBaseCtrl);
ChrEquipSuitListItemV2.__index = ChrEquipSuitListItemV2
--@@ GF Auto Gen Block Begin
ChrEquipSuitListItemV2.mImg_Icon = nil;
ChrEquipSuitListItemV2.mText_Name = nil;
ChrEquipSuitListItemV2.mText_Type = nil;
ChrEquipSuitListItemV2.mText_NumName = nil;
ChrEquipSuitListItemV2.mText_Num = nil;

function ChrEquipSuitListItemV2:__InitCtrl()

	self.mImg_Icon = self:GetImage("GrpEquipIcon/Img_Icon");
	self.mText_Name = self:GetText("GrpTextName/Text_Name");
	self.mText_Type = self:GetText("GrpTextName/Text_Type");
	self.mText_NumName = self:GetText("GrpTextNum/TextName");
	self.mText_Num = self:GetText("GrpTextNum/Text_Num");
end

--@@ GF Auto Gen Block End
ChrEquipSuitListItemV2.mData = nil

function ChrEquipSuitListItemV2:ctor()
	self.itemList = {}
end

function ChrEquipSuitListItemV2:InitCtrl(parent)
	self.parent = parent

	local obj = instantiate(UIUtils.GetGizmosPrefab("Character/ChrEquipSuitListItemV2.prefab", self))
	self:SetRoot(obj.transform)
	obj.transform:SetParent(parent, false)
	obj.transform.localScale = vectorone

	self:SetRoot(obj.transform)
	self:__InitCtrl()

	self.mBtn_Detail = self:GetSelfButton()
end

function ChrEquipSuitListItemV2:SetData(data)
	self.mData = data
	if data then
		if data.id ~= 0 then
			self.mImg_Icon.sprite = IconUtils.GetEquipSetIcon(data.icon_large)
			self.mText_Name.text = data.name.str
			self.mText_Num.text = NetCmdEquipData:GetEquipListBySetId(data.id).Count
		end
	end
end

function ChrEquipSuitListItemV2:UpdateCount()
	self.mText_Num.text = NetCmdEquipData:GetEquipListBySetId(self.mData.id).Count
end

function ChrEquipSuitListItemV2:OnRelease()
	self.itemList = {}
end