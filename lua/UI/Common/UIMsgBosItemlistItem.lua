require("UI.UIBaseCtrl")

UIMsgBosItemlistItem = class("UIMsgBosItemlistItem", UIBaseCtrl);
UIMsgBosItemlistItem.__index = UIMsgBosItemlistItem
--@@ GF Auto Gen Block Begin
UIMsgBosItemlistItem.mImage_Massage_Image = nil;
UIMsgBosItemlistItem.mText_Massage_Text = nil;
UIMsgBosItemlistItem.mText_Massage_Cost = nil;

function UIMsgBosItemlistItem:__InitCtrl()

	self.mImage_Massage_Image = self:GetImage("Image_Image");
	self.mText_Massage_Text = self:GetText("Text_Text");
	self.mText_Massage_Cost = self:GetText("Text_Cost");
end

--@@ GF Auto Gen Block End

function UIMsgBosItemlistItem:InitCtrl(root)

    local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UIMsgBosItemlistItem.prefab",self));

    setparent(root,obj.transform);
    obj.transform.localScale=vectorone;
    self:SetRoot(obj.transform);
    self:__InitCtrl();

end


function UIMsgBosItemlistItem:SetData(cmdData)

    if cmdData ~=nil then
        itemData=TableData.listItemDatas:GetDataById(cmdData.item_id);
        self.mImage_Massage_Image.sprite = CS.IconUtils.GetIconSprite(CS.GF2Icon.Item,itemData.icon);
        self.mText_Massage_Text.text = itemData.name;
        self.mText_Massage_Cost.text = cmdData.item_num;
    end

end