require("UI.UIBaseCtrl")

UIPartListElementItem = class("UIPartListElementItem", UIBaseCtrl);
UIPartListElementItem.__index = UIPartListElementItem
--@@ GF Auto Gen Block Begin
UIPartListElementItem.mImage_PartsList_PartIcon = nil;
UIPartListElementItem.mImage_PartsList_PartTypeIcon = nil;
UIPartListElementItem.mImage_PartsList_NameLabelBG = nil;
UIPartListElementItem.mText_PartsList_PartLevel = nil;
UIPartListElementItem.mText_PartsList_PartName = nil;
UIPartListElementItem.mText_PartsList_UnavailableReason = nil;
UIPartListElementItem.mTrans_PartsList_SelectedFrame = nil;
UIPartListElementItem.mTrans_PartsList_UnavailableMark = nil;

function UIPartListElementItem:__InitCtrl()

	self.mImage_PartsList_PartIcon = self:GetImage("Image_PartIcon");
	self.mImage_PartsList_PartTypeIcon = self:GetImage("Image_PartTypeIcon");
	self.mImage_PartsList_NameLabelBG = self:GetImage("Image_NameLabelBG");
	self.mText_PartsList_PartLevel = self:GetText("LevelLayout/Text_PartLevel");
	self.mText_PartsList_PartName = self:GetText("Text_PartName");
	self.mText_PartsList_UnavailableReason = self:GetText("Trans_UnavailableMark/BG/Text_UnavailableReason");
	self.mTrans_PartsList_SelectedFrame = self:GetRectTransform("Trans_SelectedFrame");
	self.mTrans_PartsList_UnavailableMark = self:GetRectTransform("Trans_UnavailableMark");
end

--@@ GF Auto Gen Block End

function UIPartListElementItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	self:OnInit()

end

function UIPartListElementItem:OnInit()
	setactive(self.mTrans_PartsList_SelectedFrame,false)
end


function UIPartListElementItem:SetData(part,carrier)
	setactive(self.mUIRoot,true)
	local partStcData = CarrierNetCmdHandler:GetCarrierPartStcData(part.id)
	self.mImage_PartsList_PartIcon.sprite =IconUtils.GetIconSprite(CS.GF2Icon.CarrierPart, partStcData.icon)
	gfwarning(partStcData.define_type)
	gfwarning(TableData.GetPartDefineTypeData(partStcData.define_type).icon)
	self.mImage_PartsList_PartTypeIcon.sprite = IconUtils.GetIconSprite(CS.GF2Icon.CarrierPartType,TableData.GetPartDefineTypeData(partStcData.define_type).icon)
	UIUtils.SetColor(self.mImage_PartsList_NameLabelBG,TableData.GetGlobalGun_Quality_Color1(partStcData.rank))
	self.mText_PartsList_PartName.text = partStcData.name
	self.mText_PartsList_PartLevel.text = part.level

--检测过载和占用
	local beUsed = CarrierNetCmdHandler:IsPartBeUsed(part.id)
	local currentPart = UIGarageVechicleDetailPanel.GetCurCarrierPart()
	local currentLoad = 0
	if(currentPart~=nil)then
		currentLoad = CarrierNetCmdHandler:GetCarrierPartStcData(currentPart.id).bearing
	end

	if beUsed then
		UIUtils.SetInteractive(self.mUIRoot,false)
		setactive(self.mTrans_PartsList_UnavailableMark,true)
		self.mText_PartsList_UnavailableReason.text = UICNWords.PartIsOccupy
		elseif partStcData.bearing-currentLoad+CarrierNetCmdHandler:GetCarrierCurrentLoad(carrier.id)>carrier.prop.max_bearing then
		UIUtils.SetInteractive(self.mUIRoot,false)
		setactive(self.mTrans_PartsList_UnavailableMark,true)
		self.mText_PartsList_UnavailableReason.text = UICNWords.PartIsOverweight
	end


end


function UIPartListElementItem:Reset()
	setactive(self.mUIRoot,false)
	UIUtils.SetInteractive(self.mUIRoot,true)
	setactive(self.mTrans_PartsList_UnavailableMark,false)
	setactive(self.mTrans_PartsList_SelectedFrame,false)
	UIUtils.SetInteractive(self.mUIRoot,true)
end

function UIPartListElementItem:ActiveSelf(activity)
	setactive(self.mTrans_PartsList_SelectedFrame,activity)
end