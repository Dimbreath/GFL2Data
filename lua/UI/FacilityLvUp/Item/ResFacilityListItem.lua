require("UI.UIBaseCtrl")

ResFacilityListItem = class("ResFacilityListItem", UIBaseCtrl);
ResFacilityListItem.__index = ResFacilityListItem
--@@ GF Auto Gen Block Begin
ResFacilityListItem.mImage_StorageFill = nil;
ResFacilityListItem.mText_ResText = nil;
ResFacilityListItem.mText_StorageText = nil;
ResFacilityListItem.mText_FacilityText = nil;
ResFacilityListItem.mText_ProduceDescription = nil;
ResFacilityListItem.mText_ProduceNum = nil;
ResFacilityListItem.mText_StorageDescription = nil;
ResFacilityListItem.mText_StorageNum = nil;
ResFacilityListItem.mText_FacilityLv = nil;

function ResFacilityListItem:__InitCtrl()

	self.mImage_StorageFill = self:GetImage("Storage/Image_StorageFill");
	self.mText_ResText = self:GetText("Storage/Text_ResText");
	self.mText_StorageText = self:GetText("Storage/Text_StorageText");
	self.mText_FacilityText = self:GetText("Name/Text_FacilityText");
	self.mText_ProduceDescription = self:GetText("ProduceSpeed/Text_ProduceDescription");
	self.mText_ProduceNum = self:GetText("ProduceSpeed/Text_ProduceNum");
	self.mText_StorageDescription = self:GetText("Storage/Text_StorageDescription");
	self.mText_StorageNum = self:GetText("Storage/Text_StorageNum");
	self.mText_FacilityLv = self:GetText("Level/Text_FacilityLv");
end

--@@ GF Auto Gen Block End

function ResFacilityListItem:InitCtrl(root)

    local obj=instantiate(UIUtils.GetGizmosPrefab("Facility/ResFacilityListItem.prefab",self));

    setparent(root,obj.transform);
    obj.transform.localScale=vectorone;
    self:SetRoot(obj.transform);

	self:__InitCtrl();
end


--配置表数据
function ResFacilityListItem:SetData(cmdData)

    if cmdData ~=nil then
        setactive(self.mUIRoot.gameObject,true);

        local propData=TableData.GetFacilityPropertyData(cmdData.id,cmdData.level);

        local curNum=NetCmdFacilityData:GetFacilityResItemStorageNum(cmdData.id)
        local  facData = TableData.listFacilityDatas:GetDataById(cmdData.id);

        self.mText_FacilityText.text=facData.name;

        self.mImage_StorageFill.fillAmount=curNum/propData.storage;

        self.mText_StorageText.text=curNum;
        self.mText_FacilityLv.text=cmdData.level;

        if propData.produce_item ~=0 then

            local itemData=TableData.listItemDatas:GetDataById(propData.produce_item);
            self.mText_ResText.text=itemData.name;
            self.mText_ProduceDescription.text=propData.produce_item_description;
            self.mText_ProduceNum.text=propData.produce_speed;
            self.mText_StorageDescription.text=propData.storage_description;
            self.mText_StorageNum.text=propData.storage;
        end

        


    else
        setactive(self.mUIRoot.gameObject,false);
    end

end