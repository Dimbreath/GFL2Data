require("UI.UIBasePanel")
require("UI.UniTopbar.UIUniTopbarView")
require("UI.UniTopbar.Item.ResourcesCommonItem")
require("UI.UniTopbar.Item.UISystemCommonItem")

UIUniTopBarPanel = class("UIUniTopBarPanel",UIBasePanel)
UIUniTopBarPanel.__index = UIUniTopBarPanel

UIUniTopBarPanel.mView = nil

UIUniTopBarPanel.mCurrencyItemList = {}
UIUniTopBarPanel.mStaminaItemList = {}

UIUniTopBarPanel.mSystemItemList = {}

function  UIUniTopBarPanel:ctor()
    UIUniTopBarPanel.super.ctor(self)
end

function  UIUniTopBarPanel.Open()
    UIManager.OpenUI(UIDef.UIUniTopBarPanel)
end

function  UIUniTopBarPanel.Close()
    UIManager.CloseUI(UIDef.UIUniTopBarPanel)
end

function  UIUniTopBarPanel.OnShow()
    UIUniTopBarPanel.mUIRoot.transform:SetAsLastSibling()
end

function  UIUniTopBarPanel.Init(root, data)
    self = UIUniTopBarPanel
    UIUniTopBarPanel.super.SetRoot(UIUniTopBarPanel, root)

    self.mData = data

    self.mView = UIUniTopbarView
    self.mView:InitCtrl(root)

    self:UpdateData(data)

    MessageSys:AddListener(2020, self.OnUpdateItemData)
    MessageSys:AddListener(5000, self.OnUpdateItemData)
    MessageSys:AddListener(9007, self.OnUpdateStaminaData)
end

function  UIUniTopBarPanel.OnInit()

end

function  UIUniTopBarPanel.OnRelease()
    self = UIUniTopBarPanel
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

function UIUniTopBarPanel.OnUpdate()
    self = UIUniTopBarPanel
    if self.mStaminaItemList ~= nil and #self.mStaminaItemList > 0 then
        for _, item in ipairs(self.mStaminaItemList) do
            item:OnUpdate()
        end
    end
end

function UIUniTopBarPanel.TopBarDataUpdate(data)
    self = UIUniTopBarPanel
    self:UpdateData(data)
end

function  UIUniTopBarPanel:UpdateData(data)
    local resItemList = self:GetResourcesDataList(data.resources)
    local sysItemList = self:GetSystemItemDataList(data.system, data.system_icon)
    self:UpdateCurrencyContent(resItemList)
    self:UpdateSystemContent(sysItemList)

    UIUtils.ForceRebuildLayout(self.mView.mTrans_TopBar)
end

function UIUniTopBarPanel:UpdateCurrencyContent(currencyDataList)
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
        item:SetData(data)
    end
end

function UIUniTopBarPanel:UpdateSystemContent(systemDataList)
    if #systemDataList <= 0 or systemDataList == nil then
        for i, item in ipairs(self.mSystemItemList) do
            setactive(item:GetRoot().gameObject, false)
        end
        return
    end

    for i, item in ipairs(self.mSystemItemList) do
        setactive(item:GetRoot().gameObject, i <= #systemDataList)
    end

    for i, data in ipairs(systemDataList) do
        local item = nil
        if i > #self.mSystemItemList then
            item = UISystemCommonItem.New()
            item:InitCtrl(self.mView.mTrans_SysList.transform)
            table.insert(self.mSystemItemList, item)
        else
            item = self.mSystemItemList[i]
        end
        item:SetData(data)
    end
end

function UIUniTopBarPanel:GetResourcesDataList(str)
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

function UIUniTopBarPanel:GetSystemItemDataList(str, strIcon)
    local itemDataList = {}
    if str == "" or strIcon == "" then
        return itemDataList
    end
    local strArr = string.split(str, ',')
    local iconArr = string.split(strIcon, ',')
    for i, v in ipairs(strArr) do
        local item = {}
        item.systemIcon = iconArr[i]
        item.jumpID = tonumber(v)
        table.insert(itemDataList, item)
    end
    return itemDataList
end

function UIUniTopBarPanel.OnUpdateItemData()
    printstack("UpdateItemData")
    self = UIUniTopBarPanel
    for _, item in ipairs(self.mCurrencyItemList) do
        item:UpdateData()
    end
end

function UIUniTopBarPanel.OnUpdateStaminaData()
    self = UIUniTopBarPanel
    for _, item in ipairs(self.mStaminaItemList) do
        item:UpdateData()
    end
end


