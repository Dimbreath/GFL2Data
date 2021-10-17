require("UI.UIBaseCtrl")

UICommonReceiveItem = class("UICommonReceiveItem", UIBaseCtrl);
UICommonReceiveItem.__index = UICommonReceiveItem
--@@ GF Auto Gen Block Begin
UICommonReceiveItem.mBtn_Confirm = nil;
UICommonReceiveItem.mText_Title = nil;
UICommonReceiveItem.mHLayout_ItemList = nil;
UICommonReceiveItem.mTrans_ItemList = nil;

function UICommonReceiveItem:__InitCtrl()

    self.mBtn_Confirm = self:GetButton("Btn_Confirm");
    self.mText_Title = self:GetText("Title/Text_Title");
    self.mHLayout_ItemList = self:GetHorizontalLayoutGroup("ItemList/Trans_HLayout_ItemList");
    self.mTrans_ItemList = self:GetRectTransform("ItemList/Trans_HLayout_ItemList");
end

--@@ GF Auto Gen Block End


UICommonReceiveItem.mItemViewList = nil;

function UICommonReceiveItem:InitCtrl(parent)
    --实例化
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonReceiveItem.prefab",self));
    self:SetRoot(obj.transform);
    setparent(parent, obj.transform);
    obj.transform.localScale = vectorone;
    obj.transform.localPosition = vectorzero;
    obj.transform.anchoredPosition = CS.Vector2.zero;
    obj.transform.offsetMin = CS.Vector2.zero;
    obj.transform.offsetMax = CS.Vector2.zero;
    self:SetRoot(obj.transform);
    self:__InitCtrl();

    self.mItemViewList = List:New();
end

function UICommonReceiveItem:SetData(itemlist, titleStr)

    if itemlist ~= nil then
        setactive(self:GetRoot().gameObject, true);

        local datas = itemlist;

        --for i = 1, self.mItemViewList:Count() do
        -- self.mItemViewList[i]:SetData(nil,nil);
        --end

        for i = 1, self.mItemViewList:Count() do
            self.mItemViewList[i]:SetData(nil)
        end

        local i = 0
        for itemId, num in pairs(datas) do
            if i < self.mItemViewList:Count() then
                self.mItemViewList[i + 1]:InitData(itemId, num);
            else
                local itemview = UICommonItemS.New();
                local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonItemS.prefab",self));
                setparent(self.mTrans_ItemList, obj.transform);
                obj.transform.localScale = vectorone;
                itemview:InitCtrl(obj.transform);
                self.mItemViewList:Add(itemview);
                itemview:InitData(itemId, num);
            end

            i = i + 1
        end
        --self:SetPosZ(-10)
    else
        setactive(self:GetRoot().gameObject, false);
    end

    if titleStr ~= nil then
        self.mText_Title.text = titleStr
    end
end