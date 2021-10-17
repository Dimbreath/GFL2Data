require("UI.UIBaseCtrl")

UIExtendedPanel = class("UIExtendedPanel", UIBaseCtrl);
UIExtendedPanel.__index = UIExtendedPanel
--@@ GF Auto Gen Block Begin
UIExtendedPanel.mBtn_Close = nil;
UIExtendedPanel.mBtn_Left = nil;
UIExtendedPanel.mBtn_Right = nil;
UIExtendedPanel.mBtn_Cancel = nil;
UIExtendedPanel.mBtn_Unlock = nil;
UIExtendedPanel.mImage_Icon = nil;
UIExtendedPanel.mText_TitelName = nil;
UIExtendedPanel.mText_Prompt = nil;
UIExtendedPanel.mText_Have = nil;
UIExtendedPanel.mText_All = nil;
UIExtendedPanel.mText_GetNum = nil;
UIExtendedPanel.mText_Cost = nil;

function UIExtendedPanel:__InitCtrl()

	self.mBtn_Close = self:GetButton("Btn_Detail_Close");
	self.mBtn_Left = self:GetButton("BGPanel/GetExtra/SliderPanel/Slider/Btn_Left");
	self.mBtn_Right = self:GetButton("BGPanel/GetExtra/SliderPanel/Slider/Btn_Right");
	self.mBtn_Cancel = self:GetButton("BGPanel/GetExtra/ButtonPanel/Btn_Cancel");
	self.mBtn_Unlock = self:GetButton("BGPanel/GetExtra/ButtonPanel/Btn_Unlock");
	self.mImage_Icon = self:GetImage("BGPanel/GetExtra/ButtonPanel/Btn_Unlock/Panel/Image_Icon");
	self.mText_TitelName = self:GetText("BGPanel/TitlePanel/Text_TitelName");
	self.mText_Prompt = self:GetText("BGPanel/GetExtra/PromptPanel/Text_Prompt");
	self.mText_Have = self:GetText("BGPanel/GetExtra/DesPanel/Text_Have");
	self.mText_All = self:GetText("BGPanel/GetExtra/DesPanel/Text_All");
	self.mText_GetNum = self:GetText("BGPanel/GetExtra/SliderPanel/GetPanel/Text_GetNum");
	self.mText_Cost = self:GetText("BGPanel/GetExtra/ButtonPanel/Btn_Unlock/Panel/Text_Cost");

end

--@@ GF Auto Gen Block End

UIExtendedPanel.mSlider = nil;
UIExtendedPanel.mEachGoods = nil;
UIExtendedPanel.mType = nil;
UIExtendedPanel.mIsMax = false;
UIExtendedPanel.mEquipBuyTimes = 0

UIExtendedPanel.EQUIP_ID = 5;
UIExtendedPanel.CHIP_ID = 6;

function UIExtendedPanel:InitCtrl(parent)
    UIExtendedPanel.EQUIP_ID = TableData.GlobalSystemData.EquipmentPackageStoreid;
    UIExtendedPanel.CHIP_ID = TableData.GlobalSystemData.WeaponPackageStoreid;

    --实例化
    local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UIExtendedPanel.prefab",self));
    self:SetRoot(obj.transform);
    obj.transform:SetParent(parent,false);
    self:SetRoot(obj.transform);
    self:__InitCtrl();
    self.mSlider=self:GetSlider("BGPanel/GetExtra/SliderPanel/Slider");

    self.mSlider.onValueChanged:AddListener(function (ptc) self:OnValueChange(ptc) end);
    UIUtils.GetButtonListener(self.mBtn_Unlock.gameObject).onClick = function(obj) self:OnBtnUnlockClick() end

    UIUtils.GetButtonListener(self.mBtn_Cancel.gameObject).onClick = function(obj) self:OnBtnUnlockCancelClick() end

    UIUtils.GetButtonListener(self.mBtn_Right.gameObject).onClick = function(obj) self:OnBtnADDClick() end

    UIUtils.GetButtonListener(self.mBtn_Left.gameObject).onClick = function(obj) self:OnBtnReduceClick() end

    local itemData = TableData.GetItemData(1)
    self.mImage_Icon.sprite = IconUtils.GetItemSprite(itemData.icon)

    self:SetPosZ(-20);
end



function UIExtendedPanel:SetData(data)
    self.mSlider.value = 0;
    if data~=nil then
        setactive(self.mUIRoot,true);
        self.mType=data;
        self.mIsMax = false;
        self.mSlider.interactable = true;

        if self.mType==1 then
            self.mText_TitelName.text = TableData.GetHintById(30005);
            self.mText_All.text=AccountNetCmdHandler:GetEquipCapacityLimit();
            self.mEachGoods=NetCmdStoreData:GetStoreGoodById(UIExtendedPanel.EQUIP_ID);
            local Capacity=AccountNetCmdHandler:GetEquipCapacityNumByPct(0);
            --local prize = TableData.GetPrizeData(self.mEachGoods.prize_id);

            self.mText_GetNum.text=Capacity*5;
            self.mText_Prompt.text = TableData.GetHintReplaceById(30006,tostring(Capacity*5));
            self.mText_Cost.text=Capacity*tonumber(self.mEachGoods.price);
            self.mText_Have.text=CS.GF2.Data.GlobalData.equip_capacity + Capacity*self.mEachGoods.ItemNumList[0].num;

            if(CS.GF2.Data.GlobalData.equip_capacity >= AccountNetCmdHandler:GetEquipCapacityLimit()) then
                self.mIsMax = true;
                self.mText_GetNum.text = "MAX";
                self.mSlider.interactable = false;
                self.mText_Have.text=CS.GF2.Data.GlobalData.equip_capacity;
            end
        else
            self.mText_TitelName.text = TableData.GetHintById(30007);
            --self.mText_Have.text=CS.GF2.Data.GlobalData.weapon_capacity;
            self.mText_All.text=AccountNetCmdHandler:GetChipCapacityLimit();
            self.mEachGoods=NetCmdStoreData:GetStoreGoodById(UIExtendedPanel.CHIP_ID);
            local Capacity=AccountNetCmdHandler:GetChipCapacityNumByPct(0);
            --local prize = TableData.GetPrizeData(self.mEachGoods.prize_id);
            self.mText_GetNum.text=Capacity*5;
            self.mText_Prompt.text = TableData.GetHintReplaceById(30008,tostring(Capacity*5));
            self.mText_Cost.text=Capacity*tonumber(self.mEachGoods.price);
            self.mText_Have.text= CS.GF2.Data.GlobalData.weapon_capacity + Capacity*self.mEachGoods.ItemNumList[0].num;

            if(CS.GF2.Data.GlobalData.weapon_capacity >= AccountNetCmdHandler:GetChipCapacityLimit()) then
                self.mIsMax = true;
                self.mText_GetNum.text = "MAX";
                self.mSlider.interactable = false;
                self.mText_Have.text=CS.GF2.Data.GlobalData.weapon_capacity;
            end
        end

        self.mEquipBuyTimes = 0
        self:OnBtnADDClick(nil)
    else
        setactive(self.mUIRoot,false);
    end
end

function UIExtendedPanel:OnValueChange(pct)
    gfdebug(self.mSlider.value);
    if self.mType == 1 then
        self.mEquipBuyTimes=AccountNetCmdHandler:GetEquipCapacityNumByPct(pct);
        local goods = NetCmdStoreData:GetStoreGoodById(UIExtendedPanel.EQUIP_ID);

        if(pct < (1.0/goods.remain_times)) then
            self.mEquipBuyTimes=0;
            self:OnBtnADDClick(nil)
            return;
        end

        --local prize = TableData.GetPrizeData(goods.prize_id);
        self.mText_GetNum.text=self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
        self.mText_Cost.text=self.mEquipBuyTimes*tonumber(self.mEachGoods.price);
        self.mText_Prompt.text = TableData.GetHintReplaceById(30006,tostring(self.mEquipBuyTimes*5));
        self.mText_Have.text = CS.GF2.Data.GlobalData.equip_capacity + self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
    else

        self.mEquipBuyTimes=AccountNetCmdHandler:GetChipCapacityNumByPct(pct);
        local goods = NetCmdStoreData:GetStoreGoodById(UIExtendedPanel.CHIP_ID);

        if(pct < (1.0/goods.remain_times)) then
            self.mEquipBuyTimes=0;
            self:OnBtnADDClick(nil)
            return;
        end

        --local prize = TableData.GetPrizeData(goods.prize_id);
        self.mText_GetNum.text=self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
        self.mText_Cost.text=self.mEquipBuyTimes*tonumber(self.mEachGoods.price);
        self.mText_Prompt.text = TableData.GetHintReplaceById(30008,tostring(self.mEquipBuyTimes*5));
        self.mText_Have.text = CS.GF2.Data.GlobalData.weapon_capacity + self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
    end
end

function UIExtendedPanel:OnBtnUnlockClick(obj)

    if(self.mIsMax) then
        self:SetData(nil);
        return;
    end
    --判断是否有足够的钻石
    local needNum=self.mEquipBuyTimes*tonumber(self.mEachGoods.price);
    local curNum=NetCmdItemData:GetResItemCount(1);
    if needNum>curNum then
        MessageBox.Show("钻石不足", "钻石不足，是否前往购买", nil, self.OnDiamandNeedGotoStoreClicked, nil);
        return;
    end

    if self.mType == 1 then
        NetCmdStoreData:SendStoreBuy(UIExtendedPanel.EQUIP_ID,self.mEquipBuyTimes,function() self:OnBtnUnlockCancelClick() end);
    else
        NetCmdStoreData:SendStoreBuy(UIExtendedPanel.CHIP_ID,self.mEquipBuyTimes,function() self:OnBtnUnlockCancelClick() end);
    end
end


function UIExtendedPanel.OnDiamandNeedGotoStoreClicked(gameObj)
    self = UIExtendedPanel;
    gfdestroy(self.mUIRoot)
    QuickStorePurchase.RedirectToStoreTag(1,nil)
    
    MessageSys:SendMessage(CS.GF2.Message.UIEvent.UIEquipmentUpdate,nil);
end

function UIExtendedPanel:OnBtnUnlockCancelClick()
    gfdestroy(self.mUIRoot)

    MessageSys:SendMessage(CS.GF2.Message.UIEvent.UIEquipmentUpdate,nil);
end

function UIExtendedPanel:OnBtnADDClick(obj)
    if(self.mIsMax) then
        return;
    end

    if self.mType == 1 then
        self.mEquipBuyTimes = AccountNetCmdHandler:GetEquipCapacityNumByCur(self.mEquipBuyTimes+1);
        local goods = NetCmdStoreData:GetStoreGoodById(UIExtendedPanel.EQUIP_ID);
        --local prize = TableData.GetPrizeData(goods.prize_id);
        self.mText_GetNum.text=self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
        self.mText_Cost.text=self.mEquipBuyTimes*tonumber(self.mEachGoods.price);
        self.mText_Prompt.text = TableData.GetHintReplaceById(30006,tostring(self.mEquipBuyTimes*5));
        self.mSlider.value=self.mEquipBuyTimes/goods.remain_times;

        self.mText_Have.text = CS.GF2.Data.GlobalData.equip_capacity + self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
    else
        self.mEquipBuyTimes = AccountNetCmdHandler:GetChipCapacityNumByCur(self.mEquipBuyTimes+1);
        local goods = NetCmdStoreData:GetStoreGoodById(UIExtendedPanel.CHIP_ID);
        --local prize = TableData.GetPrizeData(goods.prize_id);
        self.mText_GetNum.text=self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
        self.mText_Cost.text=self.mEquipBuyTimes*tonumber(self.mEachGoods.price);
        self.mText_Prompt.text = TableData.GetHintReplaceById(30008,tostring(self.mEquipBuyTimes*5));
        self.mSlider.value=self.mEquipBuyTimes/goods.remain_times;

        self.mText_Have.text = CS.GF2.Data.GlobalData.weapon_capacity + self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
    end
end

function UIExtendedPanel:OnBtnReduceClick(obj)
    if(self.mIsMax) then
        return;
    end

    if self.mType == 1 then
        self.mEquipBuyTimes = AccountNetCmdHandler:GetEquipCapacityNumByCur(self.mEquipBuyTimes-1);
        local goods = NetCmdStoreData:GetStoreGoodById(UIExtendedPanel.EQUIP_ID);
        --local prize = TableData.GetPrizeData(goods.prize_id);
        self.mText_GetNum.text=self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
        self.mText_Cost.text=self.mEquipBuyTimes*tonumber(self.mEachGoods.price);
        self.mText_Prompt.text = TableData.GetHintReplaceById(30006,tostring(self.mEquipBuyTimes*5));
        self.mSlider.value=self.mEquipBuyTimes/goods.remain_times;

        self.mText_Have.text = CS.GF2.Data.GlobalData.equip_capacity + self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
    else

        self.mEquipBuyTimes = AccountNetCmdHandler:GetChipCapacityNumByCur(self.mEquipBuyTimes-1);
        local goods = NetCmdStoreData:GetStoreGoodById(UIExtendedPanel.CHIP_ID);
        --local prize = TableData.GetPrizeData(goods.prize_id);
        self.mText_GetNum.text=self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
        self.mText_Cost.text=self.mEquipBuyTimes*tonumber(self.mEachGoods.price);
        self.mText_Prompt.text = TableData.GetHintReplaceById(30008,tostring(self.mEquipBuyTimes*5));
        self.mSlider.value=self.mEquipBuyTimes/goods.remain_times;

        self.mText_Have.text = CS.GF2.Data.GlobalData.weapon_capacity + self.mEquipBuyTimes*self.mEachGoods.ItemNumList[0].num;
    end
end



