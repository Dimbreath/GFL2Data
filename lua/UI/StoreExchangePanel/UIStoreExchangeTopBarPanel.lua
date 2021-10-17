require("UI.UIBasePanel")
require("UI.UniTopbar.UIUniTopbarView")
require("UI.UniTopbar.Item.ResourcesCommonItem")
require("UI.UniTopbar.Item.UISystemCommonItem")

UIStoreExchangeTopBarPanel = class("UIStoreExchangeTopBarPanel",UIBasePanel)
UIStoreExchangeTopBarPanel.__index = UIStoreExchangeTopBarPanel

UIStoreExchangeTopBarPanel.mView = nil

UIStoreExchangeTopBarPanel.mCurrencyItemList = {}
UIStoreExchangeTopBarPanel.mStaminaItemList = {}

UIStoreExchangeTopBarPanel.mSystemItemList = {}

function  UIStoreExchangeTopBarPanel:ctor()
    UIStoreExchangeTopBarPanel.super.ctor(self)
end

function  UIStoreExchangeTopBarPanel.Open()
    UIManager.OpenUI(UIDef.UIStoreExchangeTopBarPanel)
end

function  UIStoreExchangeTopBarPanel.Close()
    UIManager.CloseUI(UIDef.UIStoreExchangeTopBarPanel)
end

function  UIStoreExchangeTopBarPanel.OnShow()
    UIStoreExchangeTopBarPanel.mUIRoot.transform:SetAsLastSibling()
end

function  UIStoreExchangeTopBarPanel.Init(root, data)
    UIStoreExchangeTopBarPanel.super.SetRoot(UIStoreExchangeTopBarPanel, root);

    self = UIStoreExchangeTopBarPanel;

    self.mData = data;
    self.mIsPop = true

    self.mView = UIStoreExchangeTopBarPanelView;
    self.mView:InitCtrl(root);

    MessageSys:AddListener(2020, self.OnUpdateItemData)
    MessageSys:AddListener(5000, self.OnUpdateItemData)
    MessageSys:AddListener(9007, self.OnUpdateStaminaData)
end


function  UIStoreExchangeTopBarPanel.OnInit()

end

function  UIStoreExchangeTopBarPanel.OnRelease()
    self = UIStoreExchangeTopBarPanel
    if self.mCurrencyItemList ~= nil then
        for _, item in ipairs(self.mCurrencyItemList) do
            item:OnRelease()
        end
        self.mCurrencyItemList = {}
        self.mStaminaItemList = {}
    end

    if self.mSystemItemList ~= nil then
        for i, item in ipairs(self.mSystemItemList) do
            item:OnRelease()
        end
        self.mSystemItemList = {}
    end

    MessageSys:RemoveListener(2020, self.OnUpdateItemData)
    MessageSys:RemoveListener(5000, self.OnUpdateItemData)
    MessageSys:RemoveListener(9007, self.OnUpdateStaminaData)
end

function UIStoreExchangeTopBarPanel.OnUpdate()
    self = UIStoreExchangeTopBarPanel
    if self.mStaminaItemList ~= nil and #self.mStaminaItemList > 0 then
        for _, item in ipairs(self.mStaminaItemList) do
            item:OnUpdate()
        end
    end
end

function UIStoreExchangeTopBarPanel.OnUpdateData(data)
    self = UIStoreExchangeTopBarPanel
    self:UpdateData(data)
end

function  UIStoreExchangeTopBarPanel:UpdateData(data)
    local resItemList = self:GetResourcesDataList(data)
    self:UpdateCurrencyContent(resItemList)
end

function UIStoreExchangeTopBarPanel:UpdateCurrencyContent(currencyDataList)
    self.mStaminaItemList = {}

    for i, item in ipairs(self.mCurrencyItemList) do
        setactive(item:GetRoot().gameObject, i <= #currencyDataList)
    end

    for i, data in ipairs(currencyDataList) do
        local item = nil
        if i > #self.mCurrencyItemList then
            item = ResourcesCommonItem.New()
            item:InitCtrl(self.mView.mTrans_ResList.transform)
            table.insert(self.mCurrencyItemList, item)
        else
            item = self.mCurrencyItemList[i]
        end

        local itemData = TableData.GetItemData(data["id"])
        if itemData.type == 6 then
            table.insert(self.mStaminaItemList, item)
        end
        UIUtils.ForceRebuildLayout(self.mView.mTrans_ResList.transform)
        item:SetData(data)
    end
end

function UIStoreExchangeTopBarPanel:GetResourcesDataList(str)
    local itemDataList = {}
    local strArr = string.split(str, ',')
    for _, v in ipairs(strArr) do
        local item = {}
        local temStr = string.split(v, ':')
        item.id = tonumber(temStr[1])
        item.jumpID = tonumber(temStr[2])
        item.param = tonumber(temStr[3])
        table.insert(itemDataList, item)
    end
    return itemDataList
end

function UIStoreExchangeTopBarPanel.OnUpdateItemData()
    printstack("UpdateItemData")
    self = UIStoreExchangeTopBarPanel
    for _, item in ipairs(self.mCurrencyItemList) do
        item:UpdateData()
    end
end

function UIStoreExchangeTopBarPanel.OnUpdateStaminaData()
    printstack("OnUpdateStaminaData")
    self = UIStoreExchangeTopBarPanel
    for _, item in ipairs(self.mStaminaItemList) do
        item:UpdateData()
    end
end


