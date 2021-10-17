--region *.lua


UITopResourceBar = {};
local this = UITopResourceBar;

UITopResourceBar.mCurrencyItemList = {}
UITopResourceBar.mStaminaItemList = {}
UITopResourceBar.mIsCommandCenter = false;
UITopResourceBar.mParent = nil;

UITopResourceBar.mIndex = 0;
function UITopResourceBar.Init(root, resources, white)
    self = UITopResourceBar
    printstack("    UITopResourceBar   Init    ")
    self.mIsCommandCenter = white
    self:UpdateCurrencyContent(root, resources)

    self.mParent = root
end

function UITopResourceBar:UpdateCurrencyContent(root,resources)

    UITopResourceBar.Release()
    self = UITopResourceBar
    self.mCurrencyItemList = {};
    self.mStaminaItemList = {};
   

    local currencyParent = CS.TransformUtils.DeepFindChild(root, "GrpCurrency");
    if (currencyParent == nil) then
        return;
    end

    --self.mIsCommandCenter = false;
    --
    --if (root.name == "UICommandCenterPanel(Clone)") then
    --    self.mIsCommandCenter = true
    --end
  
    local resItemList = self:GetResourcesDataList(resources)
  	
    for i, data in ipairs(resItemList) do
        local item = nil
        if i > #self.mCurrencyItemList then
            item = ResourcesCommonItem.New()
            item:InitCtrl(currencyParent, self.mIsCommandCenter)
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

    MessageSys:AddListener(2020, self.OnUpdateItemData)
    MessageSys:AddListener(5000, self.OnUpdateItemData)
    MessageSys:AddListener(9007, self.OnUpdateStaminaData)
end

function UITopResourceBar.OnInit()

end

function UITopResourceBar.Hide()
    self = UITopResourceBar
    local currencyParent = CS.TransformUtils.DeepFindChild(self.mParent, "GrpCurrency");
    if (currencyParent == nil) then
        return;
    end

    setactive(currencyParent,false)
end

function UITopResourceBar.Show()
    self = UITopResourceBar
    local currencyParent = CS.TransformUtils.DeepFindChild(self.mParent, "GrpCurrency");
    if (currencyParent == nil) then
        return;
    end

    setactive(currencyParent,true)

    for _, item in ipairs(self.mCurrencyItemList) do
        item:OnShow()
    end
end

function UITopResourceBar:GetResourcesDataList(str)
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

function UITopResourceBar.OnUpdate()
    self = UITopResourceBar
    self.OnUpdateStaminaData();
end

function  UITopResourceBar.Release()

    printstack("      UITopResourceBar.Release       ")
    
    self = UITopResourceBar
    if self.mCurrencyItemList ~= nil then
        for _, item in ipairs(self.mCurrencyItemList) do
            item:OnRelease()
        end
        self.mCurrencyItemList = {}
        self.mStaminaItemList = {}
    end

    MessageSys:RemoveListener(2020, self.OnUpdateItemData)
    MessageSys:RemoveListener(5000, self.OnUpdateItemData)
    MessageSys:RemoveListener(9007, self.OnUpdateStaminaData)
end

function UITopResourceBar.OnUpdateItemData()
   -- printstack("OnUpdateItemData")
    
    self = UITopResourceBar
    for _, item in ipairs(self.mCurrencyItemList) do
        item:UpdateData()
    end
end

function UITopResourceBar.OnUpdateStaminaData()
    

    self = UITopResourceBar
    self.mIndex = self.mIndex + 1;
    if (self.mIndex < 30) then
        return ;
    end

    if (self.mIndex == 30) then
        self.mIndex = 0;
    end
   -- printstack("OnUpdateStaminaData")
    for _, item in ipairs(self.mStaminaItemList) do
        item:UpdateData()
    end
end

function UITopResourceBar.UpdateParent(parent, isCommandCenter)
    self = UITopResourceBar
    for _, item in ipairs(self.mCurrencyItemList) do
        CS.LuaUIUtils.SetParent(item:GetRoot().gameObject, parent.gameObject, true)
        if isCommandCenter ~= nil then
            UIUtils.GetAnimator(item:GetRoot()):SetBool("CommandCenterW", isCommandCenter)
        end
    end
end
