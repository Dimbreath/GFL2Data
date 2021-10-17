require("UI.UIBasePanel")

UIMixPanel = class("UIMixPanel", UIBasePanel)
UIMixPanel.__index = UIMixPanel

UIMixPanel.mView = nil
UIMixPanel.mData = nil    --开始的  self.mData.itemId, self.mData.num

UIMixPanel.mElement = 0;

UIMixPanel.mCurItems = nil --包含的items
UIMixPanel.CostItemId = 2 -- 合成默认金币
UIMixPanel.mCurMergeNum = 1
UIMixPanel.mMaterialList = nil;
UIMixPanel.mMaxMergeCount = 1;
UIMixPanel.mCostItemsTab = nil;
UIMixPanel.mMergeItemsTab = nil;
UIMixPanel.mItemId = 0
UIMixPanel.mCurCost = 0
UIMixPanel.mIsSlider = true;

UIMixPanel.isCanMerge =false;

function UIMixPanel:ctor()
    UIMixPanel.super.ctor(self)
end

function UIMixPanel.Open()
    UIMixPanel.OpenUI(UIDef.UIMixPanel)
end

function UIMixPanel.Close()
    UIManager.CloseUI(UIDef.UIMixPanel)
end

function UIMixPanel.Init(root, data)
    self = UIMixPanel
    UIMixPanel.super.SetRoot(UIMixPanel, root)
    self.mIsPop = true
    self.mData = data[1]
    self.mElement = data[2]
    
end

function UIMixPanel.OnInit()
    self = UIMixPanel

    self.mView = UIMixPanelView.New()
    self.mView:InitCtrl(self.mUIRoot)


    self.mItemId = self.mData.itemId

   
    
    UIUtils.GetButtonListener(self.mView.mBtn_GrpBg_Close.gameObject).onClick = function()
        UIMixPanel:OnClose()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_GrpDialog_Close.gameObject).onClick = function()
        UIMixPanel:OnClose()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_GrpDialog_TotalMix_Mix.gameObject).onClick = function()
        UIMixPanel:OnTotalMix()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_GrpDialog_Mix_Mix.gameObject).onClick = function()
        UIMixPanel:OnClickMix()
    end
    
    self:InitVirtualList();
    
    UIUtils.GetListener(self.mView.mBtn_GrpDialog_ComBtnAdd.gameObject).onClick = function()
        UIMixPanel:OnIncreaseClicked();
    end
    
    UIUtils.GetListener(self.mView.mBtn_GrpDialog_ComBtnReduce.gameObject).onClick = function()
        UIMixPanel:OnDecreaseClicked();
    end
    
    --UIUtils.GetListener(self.mView.mBtn_AmountMaxButton.gameObject).onClick = function()
    --    UIMixPanel:OnMaxClicked();
    --end

    UIUtils.GetListener(self.mView.mBtn_GrpDialog_GrpRight_GrpBig_ResultItem.gameObject).onClick = function()
        UIMixPanel:OnClickTopIcon();
    end

    UIUtils.GetListener(self.mView.mBtn_GrpDialog_GrpLeft_LeftItem.gameObject).onClick = function()
        UIMixPanel:OnClickLeftIcon();
    end

    UIUtils.GetListener(self.mView.mBtn_GrpDialog_GrpRight_RightItem.gameObject).onClick = function()
        UIMixPanel:OnClickRightIcon();
    end

    --UIUtils.GetListener(self.mView.mBtn_BGCloseButton.gameObject).onClick = function()
    --    UIMixPanel:OnClose()
    --end

    --self.mView.mText_AmountText.onValueChanged:AddListener(function ()
	--	UIMixPanel:OnMergeCountChanged()
	--end);

    self.mView.mSlider_GrpDialog_Line.onValueChanged:AddListener(function(value)
        UIMixPanel:OnSliderChange(value)
    end)

    MessageSys:AddListener(CS.GF2.Message.UIEvent.MergeEquipSucc, UIMixPanel.MergeEquipSucc)
    MessageSys:AddListener(CS.GF2.Message.UIEvent.MergeEquipJump, UIMixPanel.OnClose)
   
   
    --self:UpdatePanel()
end

function UIMixPanel.OnShow()
    self = UIMixPanel
    self:UpdatePanel()
end

function UIMixPanel.OnRelease()
    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.MergeEquipSucc, UIMixPanel.MergeEquipSucc)
    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.MergeEquipJump, UIMixPanel.OnClose)
    self = UIMixPanel
    UIMixPanel.mCurItems = nil --包含的items
    UIMixPanel.CostItemId = 2 -- 合成默认金币
    UIMixPanel.mCurMergeNum = 1
    UIMixPanel.mMaterialList = nil;
    UIMixPanel.mMaxMergeCount = 1;
    UIMixPanel.mItemId = 0
    
    UIMixPanel.mCostItemsTab = nil;
    UIMixPanel.mMergeItemsTab = nil;
end

function UIMixPanel:UpdatePanel()
    self.mCurMergeNum = 1;
    self.mView.mText_GrpDialog_CompoundNum.text = self.mCurMergeNum

    self.mCurItems = {}

    self:RefreshCurItems(self.mElement)
    --table.insert(self.mCurItems, self.mData);
    self:SetData(self.mData)
end

function UIMixPanel:RefreshCurItems(element)
    local mixList = nil;
    if element == 1 then
        mixList = TableData.GlobalSystemData.MentalMixListGuard;
    elseif element == 2 then
        mixList = TableData.GlobalSystemData.MentalMixListScout
    elseif element == 3 then
        mixList = TableData.GlobalSystemData.MentalMixListAssist
    elseif element == 4 then
        mixList = TableData.GlobalSystemData.MentalMixListSuppress
    elseif element == 5 then
        mixList = TableData.GlobalSystemData.MentalMixListSniper
    elseif element == 6 then
        mixList = TableData.GlobalSystemData.MentalMixListBurst
    end
    self.mCurItems = mixList;
   
end

----------------------按钮响应------------------------------------------------
function UIMixPanel:OnClose()
    self = UIMixPanel
    self:Close();
end

--  一键合成
function UIMixPanel:OnTotalMix()
    print("  OnTotalMix  ")
    local itemData = TableData.listItemDatas:GetDataById(self.mItemId, true);
    if itemData == nil then
        return ;
    end

    if self.isCanMerge == nil or self.isCanMerge == false then
        CS.PopupMessageManager.PopupString(string_format(TableData.GetHintById(40005), str))
        return
    end
    
    local coinNum = NetCmdItemData:GetResItemCount(UIMixPanel.CostItemId)
    if coinNum < self.mCurCost then
        local str = TableData.listItemDatas:GetDataById(UIMixPanel.CostItemId).name.str;
        CS.PopupMessageManager.PopupString(string_format(TableData.GetHintById(225), str))
        return;
    end

   
    
    local para = { itemList =  self.mCostItemsTab,mergeList = self.mMergeItemsTab, costNum = self.mCurCost }
    UIManager.OpenUIByParam(UIDef.UIMixConfirmPanel, para);
end

function UIMixPanel:OnClickMix()
    print("  UIMixPanel:OnClickMix  ")
    local itemData = TableData.listItemDatas:GetDataById(self.mItemId, true);
    if itemData == nil then
        return ;
    end

    if self.isCanMerge == nil or self.isCanMerge == false then
        CS.PopupMessageManager.PopupString(string_format(TableData.GetHintById(40005), str))
        return
    end
     
    local coinNum = NetCmdItemData:GetResItemCount(UIMixPanel.CostItemId)
    if coinNum < self.mCurCost then
        local str = TableData.listItemDatas:GetDataById(UIMixPanel.CostItemId).name.str;
        CS.PopupMessageManager.PopupString(string_format(TableData.GetHintById(225), str))
        return;
    end

    --local para = { itemList =  self.mCostItemsTab,mergeList = self.mMergeItemsTab, costNum = self.mCurCost }
    --local mergeList = TableTools.ReverseList(self.mMergeItemsTab)
    --local targetItemList = {}
    --for k, v in pairs(mergeList) do
    --    local targetItem =  CS.ProtoCsmsg.ComposeTargetItem()
    --    targetItem.ItemId = v.itemId
    --    targetItem.ItemNum = v.itemNum
    --    table.insert(targetItemList,targetItem)
    --end

    local mergeItem = {itemId = self.mItemId,itemNum = self.mCurMergeNum}
    local para = { itemId = self.mItemId,itemNum = self.mCurMergeNum,itemList =  self.mCostItemsTab,mergeList = self.mMergeItemsTab, costNum = self.mCurCost }
    UIManager.OpenUIByParam(UIDef.UIMixConfirmPanel, para);

    --NetCmdItemData:SendCmdComposeItemsMsg(targetItemList, function(ret)
    --    if ret == CS.CMDRet.eSuccess then
    --        printstack("合成成功")
    --        CS.PopupMessageManager.PopupString(string_format(TableData.GetHintById(30026), str))
    --        --UIManager.CloseUI(UIDef.UIMixPanel)
    --        MessageSys:SendMessage(CS.GF2.Message.UIEvent.MergeEquipSucc,nil);
    --    end
    --end)
   
end

function UIMixPanel:OnIncreaseClicked()
    print("  UIMixPanel:OnIncreaseClicked  ")
    if self.mCurMergeNum>= self.mMaxMergeCount then
        return;
    end
    self.mIsSlider = false;
    self.mCurMergeNum = self.mCurMergeNum + 1;
    self.mView.mText_GrpDialog_CompoundNum.text = self.mCurMergeNum;

    
    self:RefreshCoinAndItemNum(false);
    self.mIsSlider = true;
end

function UIMixPanel:OnDecreaseClicked()
    print("  UIMixPanel:OnDecreaseClicked  ")
    if self.mCurMergeNum == 1 then
        return;
    end
    self.mIsSlider = false;
    self.mCurMergeNum = self.mCurMergeNum - 1;
    self.mView.mText_GrpDialog_CompoundNum.text = self.mCurMergeNum;
    self:RefreshCoinAndItemNum(false);
    self.mIsSlider = true;
end

function UIMixPanel:OnMaxClicked()
    print("  UIMixPanel:OnMaxClicked  ")
    if self.mMaxMergeCount == 0 then
        return;
    end
    
    self.mCurMergeNum = self.mMaxMergeCount
    self.mView.mText_GrpDialog_CompoundNum.text = self.mCurMergeNum;
    self:RefreshCoinAndItemNum(false);
end

function UIMixPanel:OnClickRenderItem(itemData)
    print("  UIMixPanel:OnClickRenderItem  ")
    --local  itemCount = #self.mCurItems
    --if  itemData.itemId == self.mCurItems[itemCount].itemId then
    --    print("  点击的是当前这个 ")
    --    return;
    --end
    
    --local index = 0
    --for i = 1, #self.mCurItems do
    --    local item = self.mCurItems[i]
    --    if item.itemId == itemData.itemId then
    --        index = i
    --        break
    --    end
    --end
    --
    --for i = 1, #self.mCurItems - index do
    --    table.remove(self.mCurItems, #self.mCurItems)
    --end

    self:SetData(itemData);
    
end

function UIMixPanel:OnClickTopIcon()
    print("  UIMixPanel:OnClickTopIcon ")
end

function UIMixPanel:OnClickLeftIcon()
    print("   UIMixPanel:OnClickLeftIcon ")
    if self.mMaterialList == nil then
        return;
    end
    
    if #self.mMaterialList  <2 then
        return;
    end
    self:AddItem(self.mMaterialList[1]);
end

function UIMixPanel:OnClickRightIcon()
    print("   UIMixPanel:OnClickRightIcon ")
    if self.mMaterialList == nil then
        return;
    end
    if #self.mMaterialList  <2 then
        self:AddItem(self.mMaterialList[1]);
        return;
    end
    self:AddItem(self.mMaterialList[2]);
end

function UIMixPanel:OnMergeCountChanged()

    local num = tonumber(self.mView.mText_GrpDialog_CompoundNum.text);

    if(num == nil or num <= 0) then
        num = 1;
    end
    if self.mMaxMergeCount == 0 then
        self.mMaxMergeCount = 1;
    end
    if self.mMaxMergeCount ~=0 and self.mMaxMergeCount < num then
        num = self.mMaxMergeCount
    end 
    self.mCurMergeNum = num
    self.mView.mText_GrpDialog_CompoundNum.text = self.mCurMergeNum;
    local itemData = TableData.listItemDatas:GetDataById(self.mItemId);
    self.mMaterialList = self:GetMixMaterialList(itemData.mix_item_list);
    self:RefreshCoinAndItemNum(false);
    
end


function UIMixPanel:OnSliderChange(value)
    --local num = tonumber(self.mView.mText_GrpDialog_CompoundNum.text);
    if self.mIsSlider == false then
        return;
    end
    local num = math.floor(value*self.mMaxMergeCount)
    if(num == nil or num <= 0) then
        num = 1;
    end

   
    if self.mMaxMergeCount == 0 or self.mMaxMergeCount == 1 then
        self.mView.mSlider_GrpDialog_Line.value = 1;
        self.mMaxMergeCount = 1;
    end
    
    if self.mMaxMergeCount ~=0 and self.mMaxMergeCount < num then
        num = self.mMaxMergeCount
    end
    self.mCurMergeNum = num
    self.mView.mText_GrpDialog_CompoundNum.text = self.mCurMergeNum;
    local itemData = TableData.listItemDatas:GetDataById(self.mItemId);
    self.mMaterialList = self:GetMixMaterialList(itemData.mix_item_list);
    self:RefreshCoinAndItemNum(true);
end


--------------------------------------------------------------------------
function UIMixPanel:MergeEquipSucc(msg)
    self = UIMixPanel
    --self:UpdatePanel()

    local data = {itemId = self.mItemId,itemNum = 1}
    self:SetData(data);
    
end


function UIMixPanel:AddItem(item)
    --local  itemCount = #self.mCurItems
    --if  item.itemId == self.mCurItems[itemCount].itemId then
    --    print("  点击的是当前这个 ")
    --    return;
    --end
    local itemData = TableData.listItemDatas:GetDataById(item.itemId);
    local materialList = self:GetMixMaterialList(itemData.mix_item_list);

    if materialList ~= nil and #materialList ~= 0 then
        --table.insert(self.mCurItems, #self.mCurItems+1,item);
        self:SetData(item);
    else

        local count = 0
        if(itemData.type == 1) then
            count = NetCmdItemData:GetResItemCount(itemData.id)
        else
            count = NetCmdItemData:GetItemCount(itemData.id)
        end
        if itemData ~= nil then
            if itemData.type == 4 then
                UIUnitInfoPanel.Open(UIUnitInfoPanel.ShowType.GunItem, itemData.args[0])
            else
                UITipsPanel.Open(itemData, count, true, 0, 0);
            end
        end
        --TipsManager.Add(gameObject, itemData, nil, true)
        --UIManager.OpenUIByParam(UIDef.UIGetWayPanel, item);
    end
    
end



function UIMixPanel:SetData(item)

    --print("   element    "..self.mElement)
    self.mCurMergeNum = 1;

    self.mItemId = item.itemId

    local itemData = TableData.listItemDatas:GetDataById(item.itemId);
    self.mMaterialList = self:GetMixMaterialList(itemData.mix_item_list);
    --item.itemId, item.num

    self.mView.mText_GrpDialog_CompoundNum.text = self.mCurMergeNum;
    --顶端
    self.mView.mText_GrpDialog_GrpRight_GrpBig_Num.text = tostring(NetCmdItemData:GetResCount(item.itemId))
    self.mView.mImage_GrpDialog_GrpRight_GrpBig_Item.sprite = IconUtils.GetItemSprite(itemData.icon)
    self.mView.mImage_GrpDialog_GrpRight_GrpBig_Bg.sprite = IconUtils.GetQuiltyByRank(itemData.rank)

    if self.mMaterialList == nil or (self.mMaterialList ~= nil and #self.mMaterialList == 0) then
        --materialList 里面有两个
        UIManager.OpenUIByParam(UIDef.UIGetWayPanel, item);
        return ;
    end

    --可以合成的数量
    if item.itemId == self.mData.itemId then
        self.mMaxMergeCount = FormatNum( self:MergeEquipNum(item));
    else
        self.mMaxMergeCount = FormatNum( self:MergeJustChildEquipNum(item));
    end

    self.mView.mText_GrpDialog_MinNum.text = 1
    self.mView.mText_GrpDialog_MaxNum.text = self.mMaxMergeCount
   
	local isMaxCountZero = self.mMaxMergeCount== 0 and true or false

    self:RefreshCoinAndItemNum(false);
    self:RefreshLeftList()

    if isMaxCountZero == false and (self.isCanMerge == nil or self.isCanMerge == false) then
        self.mView.mText_GrpDialog_MaxNum.text = "1";
    end
    
    if isMaxCountZero == true and  (self.isCanMerge == nil or self.isCanMerge == false) then
        self.mView.mText_GrpDialog_MinNum.text = "0";
		self.mView.mText_GrpDialog_MaxNum.text = "0";
        self.mView.mText_GrpDialog_CostNum.text = "0"
        local costTxtColor = "000000"
        self.mView.mText_GrpDialog_CostNum.text = string_format("<color=#{0}>{1}</color>",costTxtColor,0);
        self.mView.mText_GrpDialog_CompoundNum.text = "0"
    end

end

function UIMixPanel:RefreshItemsAndLine()

    local costTxtColor = "FFFFFF";
    
    if #self.mMaterialList ==2 then

        setactive(self.mView.mTrans_GrpDialog_GrpLeft.gameObject,true);
        --左下角
        local item1 = self.mMaterialList[1];
        local itemData1 = TableData.listItemDatas:GetDataById(item1.itemId);
        local item1Count = NetCmdItemData:GetResCount(item1.itemId)
       
        if item1Count >= item1.itemNum * self.mCurMergeNum then
            costTxtColor = "FFFFFF";
        else
            costTxtColor = "FF0000";
        end

        self.mView.mText_GrpDialog_GrpLeft_Num.text =  string_format("<color=#{0}>{1}</color>/{2}", costTxtColor,item1Count, item1.itemNum * self.mCurMergeNum);
        self.mView.mImage_GrpDialog_GrpLeft_Item.sprite = IconUtils.GetItemSprite(itemData1.icon)
        self.mView.mImage_GrpDialog_GrpLeft_Bg.sprite = IconUtils.GetQuiltyByRank(itemData1.rank)
        --右下角
        local item2 = self.mMaterialList[2];
        local itemData2 = TableData.listItemDatas:GetDataById(item2.itemId);
        local item2Count = NetCmdItemData:GetResCount(item2.itemId)
        if item2Count >= item2.itemNum * self.mCurMergeNum then
            costTxtColor = "FFFFFF";
        else
            costTxtColor = "FF0000";
        end

        self.mView.mText_GrpDialog_GrpRight_Num.text =  string_format("<color=#{0}>{1}</color>/{2}", costTxtColor,item2Count, item2.itemNum * self.mCurMergeNum);
        self.mView.mImage_GrpDialog_GrpRight_Item.sprite = IconUtils.GetItemSprite(itemData2.icon)
        self.mView.mImage_GrpDialog_GrpRight_Bg.sprite = IconUtils.GetQuiltyByRank(itemData2.rank)

    elseif #self.mMaterialList == 1 then

        --右下角
        setactive(self.mView.mTrans_GrpDialog_GrpLeft.gameObject,false);
        local item2 = self.mMaterialList[1];
        local itemData2 = TableData.listItemDatas:GetDataById(item2.itemId);
        local item2Count = NetCmdItemData:GetResCount(item2.itemId)
        if item2Count >= item2.itemNum * self.mCurMergeNum then
            costTxtColor = "FFFFFF";
        else
            costTxtColor = "FF0000";
        end
        self.mView.mText_GrpDialog_GrpRight_Num.text = string_format("<color=#{0}>{1}</color>/{2}", costTxtColor, item2Count, item2.itemNum * self.mCurMergeNum);
        self.mView.mImage_GrpDialog_GrpRight_Item.sprite = IconUtils.GetItemSprite(itemData2.icon)
        self.mView.mImage_GrpDialog_GrpRight_Bg.sprite = IconUtils.GetQuiltyByRank(itemData2.rank)
    end 
    
end

function UIMixPanel:RefreshCoinAndItemNum(isSlider)

    self:RefreshItemsAndLine();
    local itemData = TableData.listItemDatas:GetDataById(self.mItemId);
    self.mCostItemsTab = {};
    self.mMergeItemsTab ={};

      self.mCurCost = 0;
   -- if self.mItemId == self.mData.itemId then
   --     self.isCanMerge = self:CostEquipItem(self.mItemId, self.mCurMergeNum, self.mCostItemsTab, true)
   --     if  self.isCanMerge == true then
   --         self:MergeItemList(self.mItemId, self.mCurMergeNum,self.mMergeItemsTab,true);
	--	else
	--		self.mCurCost = self.mCurMergeNum * itemData.mix_cost
   --     end

        --setactive(self.mView.mTrans_GrpDialog_Mix.gameObject, false)
        --setactive(self.mView.mTrans_GrpDialog_TotalMix.gameObject, true)
        --self.mView.mBtn_GrpDialog_TotalMix_Mix.interactable = self.isCanMerge;
       
    
        setactive(self.mView.mTrans_GrpDialog_Mix.gameObject, true)
        setactive(self.mView.mTrans_GrpDialog_TotalMix.gameObject, false)

        self.isCanMerge = self:CheckChildEnough(self.mItemId,self.mCurMergeNum, self.mCostItemsTab,self.mMergeItemsTab);
        --self.mView.mBtn_GrpDialog_Mix_Mix.interactable = self.isCanMerge;

   

    -- 消耗材料 
    
    local coinNum = NetCmdItemData:GetResItemCount(UIMixPanel.CostItemId)
    local costTxtColor = coinNum < self.mCurCost and "F8001B" or "000000"
    self.mView.mText_GrpDialog_CostNum.text = string_format("<color=#{0}>{1}</color>",costTxtColor,self.mCurCost);
    self.mView.mText_GrpDialog_CostNum.color = costTxtColor;
    if isSlider == false then
        self.mView.mSlider_GrpDialog_Line.value = self.mCurMergeNum /  self.mMaxMergeCount
    end
    
end

function UIMixPanel:RefreshLeftList()
    clearallchild(self.mView.mTrans_GrpDialog_Content.transform)
    
    for i = 0, self.mCurItems.Length - 1 do
        local curItem = self.mCurItems[i]
        if curItem ~= nil then
            local itemPrefab = UIUtils.GetGizmosPrefab("Character/BarrackMentalComposeItemV2.prefab", self)
            local obj = instantiate(itemPrefab)
            setparent(self.mView.mTrans_GrpDialog_Content, obj.transform);
            local listItem = UIMixListItem.New();
            obj.transform.localScale = vectorone;
            obj.transform.localPosition = Vector3(obj.transform.localPosition.x, obj.transform.localPosition.y, 0);
            listItem:InitCtrl(obj.transform);
            local isSelect = self.mItemId == curItem and true or false
            local data = {itemId = curItem,itemNum = 1}
            listItem:SetData(data, isSelect);

            if isSelect == true then
                local scrollRect = self.mView.mTrans_GrpDialog_ScrollRect.transform:GetComponent("ScrollRect");
                UIUtils.ScrollRectGotoSelect(obj, scrollRect, self.mView.mTrans_GrpDialog_Content)
            end

            UIUtils.GetButtonListener(obj).onClick = function()
                UIMixPanel:OnClickRenderItem(data)
            end
        end
    end

end


function UIMixPanel:InitVirtualList()
    --self.mView.mVirtualList.itemProvider = function()
    --    local item = self:ItemProvider()
    --    return item
    --end
    --
    --self.mView.mVirtualList.itemRenderer = function(index, renderDataItem)
    --    self:ItemRenderer(index, renderDataItem)
    --end
end

function UIMixPanel:ItemProvider()
    local itemView = UIMixListItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView.mUIRoot.gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIMixPanel:ItemRenderer(index, renderDataItem)
    local itemData = self.mCurItems[index+1]
    local item = renderDataItem.data
    local isSelect = index+1 == #self.mCurItems and true or false
    item:SetData(itemData,isSelect)

    UIUtils.GetButtonListener(item.mBtn_BG.gameObject).onClick = function()
        UIMixPanel:OnClickRenderItem(itemData)
    end
end


function UIMixPanel:GetMixMaterialList(str)
    if str ~= nil and str ~= ""  then
        local list = {}
        local mixItemsArray = string.split(str, ',')
        for k, v in pairs(mixItemsArray) do
            local itemSplitData = string.split(v , ':')
            local item =
            {
                itemId = tonumber(itemSplitData[1]),
                itemNum = tonumber(itemSplitData[2])
            }
            table.insert(list,item)
        end
        return list
    end
    return nil
end

function UIMixPanel:MergeEquipNum(item)
    --item.itemId
    --item.itemNum
    local itemData = TableData.listItemDatas:GetDataById(item.itemId);
    if itemData ~= nil then
        local materialList = self:GetMixMaterialList(itemData.mix_item_list);
        if materialList ~= nil and #materialList == 1 then
            local hasItem1Count = NetCmdItemData:GetResCount(materialList[1].itemId)
            local canMerget1ChildNum = self:MergeEquipNum(materialList[1]) -- 合成的第一个物体
            local item1MergeNum = math.floor((canMerget1ChildNum + hasItem1Count) / materialList[1].itemNum)
            return item1MergeNum;
        end
        
        if materialList ~= nil and #materialList == 2 then
            local hasItem1Count = NetCmdItemData:GetResCount(materialList[1].itemId)
            local hasItem2Count = NetCmdItemData:GetResCount(materialList[2].itemId)
            local canMerget1ChildNum = self:MergeEquipNum(materialList[1]) -- 合成的第一个物体
            local canMerget2ChildNum = self:MergeEquipNum(materialList[2]) -- 合成的第二个物体
            local item1MergeNum = math.floor((canMerget1ChildNum + hasItem1Count) / materialList[1].itemNum)
            local item2MergeNum = math.floor((canMerget2ChildNum + hasItem2Count) / materialList[2].itemNum)
            local curItemCount = item1MergeNum > item2MergeNum and item2MergeNum or item1MergeNum;
            return curItemCount;
        end
    end
	return 0;

end

function UIMixPanel:MergeJustChildEquipNum(item)
    local itemData = TableData.listItemDatas:GetDataById(item.itemId);
    if itemData ~= nil then
        local materialList = self:GetMixMaterialList(itemData.mix_item_list);
        if materialList ~= nil and #materialList == 1 then

            local hasItem1Count = NetCmdItemData:GetResCount(materialList[1].itemId)
            local item1MergeNum = math.floor(( hasItem1Count) / materialList[1].itemNum)
            return item1MergeNum;
            
        end
        
        if materialList ~= nil and #materialList == 2 then
            local hasItem1Count = NetCmdItemData:GetResCount(materialList[1].itemId)
            local hasItem2Count = NetCmdItemData:GetResCount(materialList[2].itemId)
            local item1MergeNum = math.floor(( hasItem1Count) / materialList[1].itemNum)
            local item2MergeNum = math.floor(( hasItem2Count) / materialList[2].itemNum)
            local curItemCount = item1MergeNum > item2MergeNum and item2MergeNum or item1MergeNum;
            return curItemCount;
        end
    end
end

function UIMixPanel:CostEquipItem(itemId, itemNum, costItemsTab, isRoot)
    
    
        local result1 = false;
        local result2 = false;
        -- 需要合成
        local itemData = TableData.listItemDatas:GetDataById(itemId);
        if itemData ~= nil then
            local materialList = self:GetMixMaterialList(itemData.mix_item_list);
            if materialList ~= nil and #materialList == 1 then
                local hasItem1Count = NetCmdItemData:GetResCount(materialList[1].itemId)
                if hasItem1Count < itemNum * materialList[1].itemNum then
                    result1 = self:CostEquipItem(materialList[1].itemId, (itemNum * materialList[1].itemNum - hasItem1Count), costItemsTab, false)

                    if hasItem1Count > 0 then
                        local item = {
                            itemId = materialList[1].itemId,
                            itemNum = hasItem1Count
                        }
                        table.insert(costItemsTab, item)
                    end
                else
                    local item = {
                        itemId = materialList[1].itemId,
                        itemNum = itemNum * materialList[1].itemNum
                    }
                    table.insert(costItemsTab, item)
                    result1 = true;
                end
                if result1 == true then
                    return true;
                end
            end
            
            if materialList ~= nil and #materialList == 2 then
                local hasItem1Count = NetCmdItemData:GetResCount(materialList[1].itemId)
                if hasItem1Count < itemNum * materialList[1].itemNum then
                    result1 = self:CostEquipItem(materialList[1].itemId, (itemNum * materialList[1].itemNum - hasItem1Count), costItemsTab, false)

                    if hasItem1Count > 0 then
                        local item = {
                            itemId = materialList[1].itemId,
                            itemNum = hasItem1Count
                        }
                        table.insert(costItemsTab, item)
                    end
                else
                    local item = {
                        itemId = materialList[1].itemId,
                        itemNum = itemNum * materialList[1].itemNum
                    }
                    table.insert(costItemsTab, item)
                    result1 = true;
                end

                local hasItem2Count = NetCmdItemData:GetResCount(materialList[2].itemId)
                if hasItem2Count < itemNum * materialList[2].itemNum then
                    result2 = self:CostEquipItem(materialList[2].itemId, (itemNum * materialList[2].itemNum - hasItem2Count), costItemsTab, false)
                    if hasItem2Count > 0 then
                        local item = {
                            itemId = materialList[2].itemId,
                            itemNum = hasItem2Count
                        }
                        table.insert(costItemsTab, item)
                    end
                else
                    local item = {
                        itemId = materialList[2].itemId,
                        itemNum = itemNum * materialList[2].itemNum
                    }
                    table.insert(costItemsTab, item)
                    result2 = true;
                end
            else

                if isRoot == false then
                    local hasItemCount = NetCmdItemData:GetResCount(itemId)
                    if hasItemCount >= itemNum then
                        local item = {
                            itemId = itemId,
                            itemNum = itemNum
                        }
                        table.insert(costItemsTab, item)
                    end
                end
               
            end
            if result1 == true and result2 == true then
                return true;
            end
        end

end

function UIMixPanel:MergeItemList(itemId, itemNum, mergeItemsTab, isRoot)

    local itemData = TableData.listItemDatas:GetDataById(itemId);
    if isRoot == true then
        local item = {
            itemId = itemId,
            itemNum = itemNum
        }
        table.insert(mergeItemsTab, item)
        self.mCurCost =self.mCurCost+ itemNum * itemData.mix_cost
    end

    local result1 = false;
    local result2 = false;
    local hasItemCount = NetCmdItemData:GetResCount(itemId)

  

    if itemData ~= nil then
        local materialList = self:GetMixMaterialList(itemData.mix_item_list);

        if materialList ~= nil and #materialList == 1 then
            local hasItem1Count = NetCmdItemData:GetResCount(materialList[1].itemId)
            if hasItem1Count < itemNum * materialList[1].itemNum then
                result1 = self:MergeItemList(materialList[1].itemId, (itemNum * materialList[1].itemNum - hasItem1Count), mergeItemsTab,true)
            else
                result1 = true
            end

        end
        
        if materialList ~= nil and #materialList == 2 then
            local hasItem1Count = NetCmdItemData:GetResCount(materialList[1].itemId)
            if hasItem1Count < itemNum * materialList[1].itemNum then
                result1 = self:MergeItemList(materialList[1].itemId, (itemNum * materialList[1].itemNum - hasItem1Count), mergeItemsTab,true)
            else
                result1 = true
            end

            local hasItem2Count = NetCmdItemData:GetResCount(materialList[2].itemId)
            if hasItem2Count < itemNum * materialList[2].itemNum then
                result2 = self:MergeItemList(materialList[2].itemId, (itemNum * materialList[2].itemNum - hasItem2Count), mergeItemsTab,true)
            else
                result2 = true
            end
        end
    end
end

function UIMixPanel:CheckChildEnough(itemId, itemNum,costItemsTab,mergeItemsTab)
    local result1 = false;
    local result2 = false;

    local itemData = TableData.listItemDatas:GetDataById(itemId);

    if itemData ~= nil then
        local materialList = self:GetMixMaterialList(itemData.mix_item_list);

        if materialList ~= nil and #materialList == 1 then
            
            local hasItem1Count = NetCmdItemData:GetResCount(materialList[1].itemId)
            self.mCurCost = self.mCurCost+ itemNum * itemData.mix_cost

            if hasItem1Count >= itemNum * materialList[1].itemNum then
                result1 = true
                local item = {
                    itemId = materialList[1].itemId,
                    itemNum = itemNum * materialList[1].itemNum
                }
                table.insert(costItemsTab, item)
                table.insert(mergeItemsTab, item)
                return true;
            end

        elseif materialList ~= nil and #materialList == 2 then
            local hasItem1Count = NetCmdItemData:GetResCount(materialList[1].itemId)

            self.mCurCost = self.mCurCost+ itemNum * itemData.mix_cost

            if hasItem1Count >= itemNum * materialList[1].itemNum then
                result1 = true
                local item = {
                    itemId = materialList[1].itemId,
                    itemNum = itemNum * materialList[1].itemNum
                }
                table.insert(costItemsTab, item)
            end

            local hasItem2Count = NetCmdItemData:GetResCount(materialList[2].itemId)
            if hasItem2Count >= itemNum * materialList[2].itemNum then
                result2 = true

                local item = {
                    itemId = materialList[2].itemId,
                    itemNum = itemNum * materialList[2].itemNum
                }
                table.insert(costItemsTab, item)
            end

            if result1 == true and result2 == true then
                local item = {
                    itemId = itemId,
                    itemNum = itemNum
                }
                table.insert(mergeItemsTab, item)

                return true;
            end
        else
            self.mCurCost = self.mCurMergeNum * itemData.mix_cost
            return false
        end
    end
end
     






