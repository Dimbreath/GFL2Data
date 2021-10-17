require("UI.UIBaseCtrl")

UICommonSoldToGetItem = class("UICommonSoldToGetItem", UIBaseCtrl);
UICommonSoldToGetItem.__index = UICommonSoldToGetItem
--@@ GF Auto Gen Block Begin
UICommonSoldToGetItem.mBtn_Cancel = nil;
UICommonSoldToGetItem.mBtn_Confirm = nil;
UICommonSoldToGetItem.mText_Title = nil;
UICommonSoldToGetItem.mText_Des = nil;
UICommonSoldToGetItem.mHLayout_ItemList = nil;
UICommonSoldToGetItem.mScrRect_ItemList = nil;
UICommonSoldToGetItem.mTrans_ItemList = nil;

function UICommonSoldToGetItem:__InitCtrl()

	self.mBtn_Cancel = self:GetButton("BG/ButtonPanel/Btn_Cancel");
	self.mBtn_Confirm = self:GetButton("BG/ButtonPanel/Btn_Confirm");
	self.mText_Title = self:GetText("BG/Title/Text_Title");
	self.mText_Des = self:GetText("BG/DesPanel/Text_Des");
	self.mHLayout_ItemList = self:GetHorizontalLayoutGroup("BG/ItemList/ScrRect_Trans_HLayout_ItemList");
	self.mScrRect_ItemList = self:GetScrollRect("BG/ItemList/ScrRect_Trans_HLayout_ItemList");
	self.mTrans_ItemList = self:GetRectTransform("BG/ItemList/Trans_HLayout_ItemList");
end

--@@ GF Auto Gen Block End

function UICommonSoldToGetItem:InitCtrl(parent)
    --实例化
    local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonSoldToGetItem.prefab",self));
    self:SetRoot(obj.transform);
    obj.transform:SetParent(parent,false);
    --setparent(parent,obj.transform);
    -- obj.transform.anchorMin = vector2zero;
    -- obj.transform.anchorMax = vector2one;
    -- obj.transform.pivot = 0.5 * vector2one;
    -- obj.transform.localScale=vectorone;
    -- obj.transform.localPosition=vectorzero;
    -- obj.transform.anchoredPosition = vector2zero;
    -- obj.transform.offsetMin = 0;
    -- obj.transform.offsetMax = 0;
    --self:SetRoot(obj.transform);
    self:__InitCtrl();
end



function UICommonSoldToGetItem:SetData(data)
    if data~=nil then
        setactive(self.mUIRoot,true);
    else
        setactive(self.mUIRoot,false);
    end
end