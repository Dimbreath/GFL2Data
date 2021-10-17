require("UI.UIBaseCtrl")

UIPartSlotItem = class("UIPartSlotItem", UIBaseCtrl);
UIPartSlotItem.__index = UIPartSlotItem
--@@ GF Auto Gen Block Begin
UIPartSlotItem.mImage_Icon = nil;
UIPartSlotItem.mImage_PlaceHolder_TypeIcon = nil;
UIPartSlotItem.mImage_PartInfo_RankBlank = nil;
UIPartSlotItem.mImage_PartInfo_PartIcon = nil;
UIPartSlotItem.mImage_PartInfo_TypeIcon = nil;
UIPartSlotItem.mText_PlaceHolder_TypeCN = nil;
UIPartSlotItem.mText_PlaceHolder_TypeEN = nil;
UIPartSlotItem.mText_PartInfo_PartName = nil;
UIPartSlotItem.mText_PartInfo_PartBearing = nil;
UIPartSlotItem.mText_PartInfo_PartLevel = nil;
UIPartSlotItem.mTrans_PlaceHolder = nil;
UIPartSlotItem.mTrans_PartInfo = nil;

function UIPartSlotItem:__InitCtrl()

	self.mImage_Icon = self:GetImage("Image_Icon");
	self.mImage_PlaceHolder_TypeIcon = self:GetImage("UI_Trans_PlaceHolder/Image_TypeIcon");
	self.mImage_PartInfo_RankBlank = self:GetImage("UI_Trans_PartInfo/Image_RankBlank");
	self.mImage_PartInfo_PartIcon = self:GetImage("UI_Trans_PartInfo/Image_PartIcon");
	self.mImage_PartInfo_TypeIcon = self:GetImage("UI_Trans_PartInfo/Image_PartTypeIcon");
	self.mText_PlaceHolder_TypeCN = self:GetText("UI_Trans_PlaceHolder/Text_TypeCN");
	self.mText_PlaceHolder_TypeEN = self:GetText("UI_Trans_PlaceHolder/Text_TypeEN");
	self.mText_PartInfo_PartName = self:GetText("UI_Trans_PartInfo/Text_PartName");
	self.mText_PartInfo_PartBearing = self:GetText("UI_Trans_PartInfo/Text_PartBearing");
	self.mText_PartInfo_PartLevel = self:GetText("UI_Trans_PartInfo/Text_PartLevel");
	self.mTrans_PlaceHolder = self:GetRectTransform("UI_Trans_PlaceHolder");
	self.mTrans_PartInfo = self:GetRectTransform("UI_Trans_PartInfo");
end

--@@ GF Auto Gen Block End

UIPartSlotItem.slotIndex = nil


function UIPartSlotItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end


function UIPartSlotItem:UpdateData(slotIndex,carrier)
    self.slotIndex = slotIndex
	local partTypeInt = CarrierNetCmdHandler:GetPartTypeBySlotIndex(slotIndex,carrier)
    local isEmpty = true
    for i=0,carrier.parts.Length-1 do
        local partId = carrier.parts[i]
        local partStcData = CarrierNetCmdHandler:GetCarrierPartStcData(partId)
        local partCmdData = CarrierNetCmdHandler:GetCarrierPart(partId)
        if partStcData.define_type==partTypeInt then
            isEmpty = false
            self.partID = partId
            setactive(self.mTrans_PlaceHolder,false)
            setactive(self.mTrans_PartInfo,true)
            UIUtils.SetColor(self.mImage_PartInfo_RankBlank,TableData.GetGlobalGun_Quality_Color1(partStcData.rank))
            self.mImage_PartInfo_PartIcon.sprite = IconUtils.GetIconSprite(CS.GF2Icon.CarrierPart, partStcData.icon)
            self.mText_PartInfo_PartName.text = partStcData.name
            UIUtils.SetColor(self.mText_PartInfo_PartName,TableData.GetGlobalGun_Quality_Color1(partStcData.rank))
            self.mImage_PartInfo_TypeIcon.sprite = IconUtils.GetIconSprite(CS.GF2Icon.CarrierPartType,TableData.GetPartDefineTypeData(partStcData.define_type).icon)
            self.mText_PartInfo_PartBearing.text = partStcData.bearing
            self.mText_PartInfo_PartLevel.text = partCmdData.level
        end
    end
    if isEmpty then
        setactive(self.mTrans_PlaceHolder,true)
        setactive(self.mTrans_PartInfo,false)
        self.mText_PlaceHolder_TypeCN.text = TableData.GetPartDefineTypeData(partTypeInt).name
        self.mText_PlaceHolder_TypeEN.text = TableData.GetPartDefineTypeData(partTypeInt).en_name
    end
end

