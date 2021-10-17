require("UI.UIBaseCtrl")

UICommonSoldGetItem = class("UICommonSoldGetItem", UIBaseCtrl);
UICommonSoldGetItem.__index = UICommonSoldGetItem
--@@ GF Auto Gen Block Begin
UICommonSoldGetItem.mImage_Icon = nil;
UICommonSoldGetItem.mText_GetNum = nil;

function UICommonSoldGetItem:__InitCtrl()

	self.mImage_Icon = self:GetImage("Image_Icon");
	self.mText_GetNum = self:GetText("Text_GetNum");
end

--@@ GF Auto Gen Block End

function UICommonSoldGetItem:InitCtrl(parent)

	local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonSoldGetItem.prefab",self));
    self:SetRoot(obj.transform);
    setparent(parent,obj.transform);
    obj.transform.localScale=vectorone;
    self:SetRoot(obj.transform);
    self:__InitCtrl();

end


function UICommonSoldGetItem:SetData(itemId, itemNum)

    if itemId~=nil then
        setactive(self.mUIRoot,true);
        local itemData = TableData.GetItemData(itemId);
        self.mText_GetNum.text = itemNum;
        self.mImage_Icon.sprite = CS.IconUtils.GetItemIconSprite(itemId);
        --self.mText_Name.text = itemData.name;
    else
        setactive(self.mUIRoot,false);
    end
end


function UICommonSoldGetItem:SetCoin(data)

    setactive(self.mUIRoot,true);
    self.mText_GetNum.text = data;
    self.mImage_Icon.sprite = CS.IconUtils.GetItemIconSprite(2);

end