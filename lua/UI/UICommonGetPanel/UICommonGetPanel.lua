require("UI.UIBasePanel")

UICommonGetPanel = class("UICommonGetPanel", UIBasePanel)
UICommonGetPanel.__index = UICommonGetPanel

UICommonGetPanel.GetType =
{
    Item = 1,
    Diamond = 2,
}

UICommonGetPanel.ErrorType =
{
    None = 0,
    OverFlow = 1,
    ItemNotEnough = 2,
}

UICommonGetPanel.StaminaId = GlobalConfig.StaminaId

UICommonGetPanel.currentReceiveItem = nil

UICommonGetPanel.curSelectContent = nil;
UICommonGetPanel.curSelectIndex = 1;
UICommonGetPanel.IsFirstEnter = true;

function UICommonGetPanel:ctor()
    UICommonGetPanel.super.ctor(self)
end

function UICommonGetPanel.Close()
    UIManager.CloseUI(UIDef.UICommonGetPanel)
end

function UICommonGetPanel.OnRelease()
    self = UICommonGetPanel
    UICommonGetPanel.currentReceiveItem = nil
    UICommonGetPanel.IsFirstEnter = true;
    --MessageSys:RemoveListener(9007, self.OnUpdateStaminaData)
end

function UICommonGetPanel.OnShow()
    self = UICommonGetPanel
end

function UICommonGetPanel.OnUpdateTop()
    self = UICommonGetPanel
    self:UpdateView()
end

function UICommonGetPanel.Init(root, data)
    self = UICommonGetPanel
    UICommonGetPanel.super.SetRoot(UICommonGetPanel, root)
    self = UICommonGetPanel
    self.mIsPop = true
		
	self.mView = UICommonGetView.New()
    self.mView:InitCtrl(root)

    --MessageSys:AddListener(9007, self.OnUpdateStaminaData)
end

function UICommonGetPanel.OnInit()
    self = UICommonGetPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = self.Close
    UIUtils.GetButtonListener(self.mView.mBtn_Cancel.gameObject).onClick = self.Close
    UIUtils.GetButtonListener(self.mView.mBtn_BGClose.gameObject).onClick = self.BGClose

    UIUtils.GetButtonListener(self.mView.mBtn_Confirm.gameObject).onClick = function()
        self = UICommonGetPanel
        if(not MessageBoxPanel.IsItemNotEnough) then
            self:OnBuyDataButtonClick(self.curSelectContent)
        else
            self:OnDiamandNeedGotoStoreClicked()
            MessageBoxPanel.Close()
        end
    end

    UIUtils.GetButtonListener(self.mView.mBtn_PriceDetails.gameObject).onClick = self.ShowPriceDetails;

    UIUtils.GetButtonListener(self.mView.mBtn_GrpPriceDetails.gameObject).onClick = self.HidePriceDetails;

    self:UpdateView()

    UICommonGetPanel.IsFirstEnter = false;
end

function UICommonGetPanel.OnUpdate()
    self = UICommonGetPanel
    --self.OnUpdateStaminaData()
end
function UICommonGetPanel:UpdateView()
    local flag = false;
    for i = 0, TableData.GlobalConfigData.StaminaStoreItem.Count - 1 do
        local id = TableData.GlobalConfigData.StaminaStoreItem[i]
        local data = self:InitItem(id)
        local content = self.mView.contentList[i + 1]
        self:UpdateContentByData(content, data)

        if(UICommonGetPanel.IsFirstEnter) then
            if(i == 0 and data.isItemEnough) then
                self.curSelectIndex = 1;
                flag = true;
            end
            if(i == 1 and data.isItemEnough and not flag and content.data.storeData.remain_times > 0) then
                self.curSelectIndex = 2;
            end
        end
    end

    self.OnSelectItem(self.mView.contentList[self.curSelectIndex].item.gameObject);

    local staminaData = TableData.GetItemData(UICommonGetPanel.StaminaId)
    local count = GlobalData.GetStaminaResourceItemCount(UICommonGetPanel.StaminaId)
    local maxStamina = TableData.GetPlayerCurExtraStaminaMax()
    --self.mView.mImage_ResIcon.sprite = IconUtils.GetItemSprite(staminaData.icon)
    -- if count < maxStamina then
    --     self.mView.mText_ResCount.text = string_format("<color=#279be5>{0}</color>/{1}", count, GlobalData.GetStaminaResourceMaxNum(UICommonGetPanel.StaminaId))
    -- else
    --     self.mView.mText_ResCount.text = string_format("<color=#D33131>{0}</color>/{1}", count, GlobalData.GetStaminaResourceMaxNum(UICommonGetPanel.StaminaId))
    -- end
end

function UICommonGetPanel:InitItem(storeId)
    local item = {}
    local storeData = NetCmdStoreData:GetCurStaminaStage(storeId)
    local itemId = storeData.price_type

    item.storeData = storeData
    item.itemData = TableData.GetItemData(itemId)
    item.prizeData = item.storeData.ItemNumList[0]
    item.itemCount = NetCmdItemData:GetResItemCount(itemId)
    item.isItemEnough = tonumber(item.itemCount) >= tonumber(item.storeData.price)

    return item
end

function UICommonGetPanel.ShowPriceDetails(gameObject)
	local self = UICommonGetPanel;
	local data = self.curSelectContent.data.storeData;

	setactive(self.mView.mTrans_GrpPriceDetails,true);

	local priceList = data.MultiPriceDict;

	for i = 0, self.mView.mTrans_GrpPriceDetailsContent.transform.childCount-1 do
		local obj = self.mView.mTrans_GrpPriceDetailsContent.transform:GetChild(i);
		gfdestroy(obj);
	end

	for i = 0, priceList.Count - 1 do
		local item  = UIStoreExchangePriceInfoItem.New();
		item:InitCtrl(self.mView.mTrans_GrpPriceDetailsContent);
		item:SetData(priceList[i])

		if(data.id == priceList[i].id) then
			item:SetNow()
		end
	end
end

function UICommonGetPanel.BGClose()
    self = UICommonGetPanel;

    if(self.mView.mTrans_GrpPriceDetails.gameObject.activeSelf) then
        self.HidePriceDetails(nil);
    else
        self.Close();
    end
end

function UICommonGetPanel.HidePriceDetails(gameObj)
	self = UICommonGetPanel;

	setactive(self.mView.mTrans_GrpPriceDetails,false);
end


function UICommonGetPanel:UpdateContentByData(contet, data)
    if contet == nil or data == nil then
        return
    end
    contet.data = data
    --contet.item:SetData(data.prizeData.itemid, data.prizeData.num)
    contet.imgIcon.sprite = IconUtils.GetItemSprite(data.itemData.icon)
    --contet.imgRemainItem.sprite = IconUtils.GetItemSprite(data.itemData.icon)
    --contet.txtCost.text = "x" .. data.storeData.price
    --contet.txtRemainItem.text = TableData.GetHintById(23) .. data.itemCount
    contet.txtRemainItem.text = data.itemCount
    contet.txtRemainItem.color = data.isItemEnough and ColorUtils.WhiteColor or ColorUtils.RedColor
    contet.imgRank.sprite = IconUtils.GetItemQualityIcon("Img_ItemQualityBg_".. data.itemData.rank)
    -- setactive(contet.transCan, self:CheckCanBuyStamina(data) == UICommonGetPanel.ErrorType.None)
    -- setactive(contet.transNotEnough, self:CheckCanBuyStamina(data) == UICommonGetPanel.ErrorType.ItemNotEnough)
    -- setactive(contet.transFull, self:CheckCanBuyStamina(data) == UICommonGetPanel.ErrorType.OverFlow)

    -- UIUtils.GetButtonListener(contet.btnGet.gameObject).onClick = function()
    --     self:OnBuyDataButtonClick(contet)
    -- end

    
end

function UICommonGetPanel.OnSelectItem(gameObject)
    self = UICommonGetPanel

    for i = 1, #self.mView.contentList do
        local c = self.mView.contentList[i];
        UICommonGetPanel.SetSelect(c, false)
    end

    local btn = UIUtils.GetButtonListener(gameObject);
    local index = btn.param;
    local content = self.mView.contentList[index];
    UICommonGetPanel.SetSelect(content, true)

    self.curSelectContent = content;
    self.curSelectIndex = index;

    local hint1 = TableData.GetHintById(203);
    self.mView.mTextTitle.text = string_format(hint1,content.data.itemData.name.str)

    local hint2 = TableData.GetHintById(204);
    local num1 = content.data.storeData.price;
    local name1 = content.data.itemData.name.str;
    local num2 = content.data.prizeData.num;
    local stcData = TableData.GetItemData(content.data.prizeData.itemid);
    local name2 = stcData.name.str;

    self.mView.mTextInfo.text = string_format(hint2,num1,name1,num2,name2);

    if(content.data.storeData.IsMultiPrice) then
        setactive(self.mView.mTrans_PriceDetails,true)
        setactive(self.mView.mTrans_TextNum,true);

        local stcData = TableData.GetItemData(content.data.storeData.price_type);
        self.mView.mImg_PriceDetailsImageIcon.sprite = UIUtils.GetIconSprite("Icon/Item",stcData.icon);
        self.mView.mTxt_PriceSetailsNum.text = content.data.storeData.price;

        if(content.data.storeData.remain_times == 0) then
            self.mView.mTxt_TextNum.color = ColorUtils.RedColor 
        else
            self.mView.mTxt_TextNum.color = ColorUtils.BlackColor
        end
        self.mView.mTxt_TextNum.text = content.data.storeData.remain_times;

    else
        setactive(self.mView.mTrans_PriceDetails,false)
        setactive(self.mView.mTrans_TextNum,false);
    end
end

function UICommonGetPanel.SetSelect(content, isSelect)
    setactive(content.transChoose, isSelect)
    setactive(content.tranSel, isSelect)
end

function UICommonGetPanel:OnBuyDataButtonClick(content)
    if not content then
        return
    end
    self.currentReceiveItem = content
    local item = content.data
    local type = content.type
    if self:NeedShowBuyTips(item, type) then
        return
    else
        if (self.curSelectContent.data.storeData.remain_times == 0 and self.curSelectIndex == 2) then
            CS.PopupMessageManager.PopupString(TableData.GetHintById(106012))
            return;
        end

        if self:StaminaOverFlowWarning(item.prizeData.num) then
            return
        else
            NetCmdStoreData:SendStoreBuy(item.storeData.id, 1, self.TakeQuestRewardCallBack)
        end
    end
end

function UICommonGetPanel:OnDiamandNeedGotoStoreClicked()
    MessageBoxPanel.IsItemNotEnough = false
    if self.currentReceiveItem then
        if self.currentReceiveItem.type == UICommonGetPanel.GetType.Diamond then    --- 钻石跳转到钻石页签
            SceneSwitch:SwitchByID(5)
        elseif self.currentReceiveItem.type == UICommonGetPanel.GetType.Item then
            SceneSwitch:SwitchByID(19)
        end
        UIRaidPanel.Close();
        UICommonGetPanel.Close()
        UIStoreExchangePriceChangeDialog.Close()
    end
end


function UICommonGetPanel.TakeQuestRewardCallBack()
    self=UICommonGetPanel
    self:CheckMultiPriceChange();
    self=UICommonGetPanel
    self:UpdateView()

    -- local itemAndNum = self.currentReceiveItem.data.prizeData
    -- CS.PopupMessageManager.PopupItem(itemAndNum.itemid, itemAndNum.num)

    local hint = TableData.GetHintById(106013)
    CS.PopupMessageManager.PopupPositiveString(hint)
end

function UICommonGetPanel:CheckMultiPriceChange()
	local view = self.curSelectContent;

	if(view.data.storeData.IsMultiPrice and view.data.storeData.remain_times == 0 and view.data.storeData.jump_id > 0) then
		UIManager.OpenUIByParam(UIDef.UIStoreExchangePriceChangeDialog,view.data.storeData)
	end
end

function UICommonGetPanel:CheckCanBuyStamina(item)
    if self:CheckStaminaIsOverFlow() then
        return UICommonGetPanel.ErrorType.OverFlow
    elseif not item.isItemEnough then
        return UICommonGetPanel.ErrorType.ItemNotEnough
    else
        return UICommonGetPanel.ErrorType.None
    end
end

function UICommonGetPanel:NeedShowBuyTips(item, type)
    local error = self:CheckCanBuyStamina(item)
    if error == UICommonGetPanel.ErrorType.OverFlow then
        CS.PopupMessageManager.PopupString(TableData.GetHintById(212))
        return true
    elseif error == UICommonGetPanel.ErrorType.ItemNotEnough then
        if type == UICommonGetPanel.GetType.Item then
            CS.PopupMessageManager.PopupString(string_format(TableData.GetHintById(225), item.itemData.name.str))
        elseif type == UICommonGetPanel.GetType.Diamond then
            --MessageBoxPanel.ShowItemNotEnoughMessage(item.itemData.id, function () self:OnDiamandNeedGotoStoreClicked() end)
            CS.PopupMessageManager.PopupString(string_format(TableData.GetHintById(225), item.itemData.name.str))
        end
        return true
    end
    return false
end

--- 体力是否溢出
function UICommonGetPanel:CheckStaminaIsOverFlow()
    local playerStamina = GlobalData.GetStaminaResourceItemCount(UICommonGetPanel.StaminaId)
    local maxStamina = TableData.GetPlayerCurExtraStaminaMax()
    if playerStamina >= maxStamina then
        return true
    end
    return false
end

--- 体力溢出警告
function UICommonGetPanel:StaminaOverFlowWarning(addNum)
    local playerStamina =  GlobalData.GetStaminaResourceItemCount(UICommonGetPanel.StaminaId)
    local maxStamina = TableData.GetPlayerCurExtraStaminaMax()
    if playerStamina < maxStamina and playerStamina + addNum > maxStamina then
        local hint = TableData.GetHintById(211)
        MessageBoxPanel.ShowDoubleType(hint, function () NetCmdStoreData:SendStoreBuy(self.currentReceiveItem.data.storeData.id, 1, self.TakeQuestRewardCallBack) end)
        return true
    end
    return false
end

-- function UICommonGetPanel.OnUpdateStaminaData()
--     self = UICommonGetPanel
--     local count = GlobalData.GetStaminaResourceItemCount(UICommonGetPanel.StaminaId)
--     self.mView.mText_ResCount.text = string_format("{0}/{1}", count, GlobalData.GetStaminaResourceMaxNum(UICommonGetPanel.StaminaId))
-- end


