require("UI.UIBaseCtrl")

UIGuildWelfareItem = class("UIGuildWelfareItem", UIBaseCtrl);
UIGuildWelfareItem.__index = UIGuildWelfareItem

UIGuildWelfareItem.timeData = nil
UIGuildWelfareItem.mData = nil
UIGuildWelfareItem.time = 0
UIGuildWelfareItem.costItem = 0
UIGuildWelfareItem.price = 0
UIGuildWelfareItem.guildLevel = 0
UIGuildWelfareItem.timer = nil
UIGuildWelfareItem.parent = nil
UIGuildWelfareItem.timeStr = ""

function UIGuildWelfareItem:ctor()
    UIGuildWelfareItem.super.ctor(self)
end

function UIGuildWelfareItem:__InitCtrl()
    self.mTrans_BuffPanel = self:GetRectTransform("UI_Trans_BuffPanel")
    self.mTrans_GoodsPanel = self:GetRectTransform("UI_Trans_GoodsPanel")
    self.mText_ItemName = self:GetText("Text_ItemName")
    self.mText_Price = self:GetText("Btn_Confirm/Text_Price")
    self.mTrans_LockPanel = self:GetRectTransform("UI_Trans_LockPanel")
    self.mTrans_LeftTime = self:GetRectTransform("UI_Trans_BuffPanel/Trans_LeftTimePanel")
    self.mText_LeftTime = self:GetText("UI_Trans_BuffPanel/Trans_LeftTimePanel/Text_LeftTime")
    self.mImage_BuffIcon = self:GetImage("UI_Trans_BuffPanel/Image_BuffIcon")
    self.mImage_ItemIcon = self:GetImage("UI_Trans_GoodsPanel/Image_ItemIcon")
    self.mText_DurationTime = self:GetText("UI_Trans_BuffPanel/Text_DurationTime")
    self.mImage_CostIcon = self:GetImage("Btn_Confirm/Image_CurrencyIcon")
    self.mBtn_Confirm = self:GetButton("Btn_Confirm")
    self.mText_ChLockInfo = self:GetText("UI_Trans_LockPanel/Text_UnlockText")
    self.mText_EnLockInfo = self:GetText("UI_Trans_LockPanel/Text_EnUnlockText")
end

function UIGuildWelfareItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("Guild/UIGuildWelfareItem.prefab",self))
    self:SetRoot(obj.transform)
    setparent(parent, obj.transform)
    obj.transform.localScale = vectorone
    self:__InitCtrl()

    UIUtils.GetButtonListener(self.mBtn_Confirm.gameObject).onClick = function()
        self:OnClickConfirm()
    end
end

function UIGuildWelfareItem:SetData(data, guildLevel, parent)
    self.mData = data
    self.guildLevel = guildLevel
    self.parent = parent
    if data then
        local guildData = NetCmdGuildData:GetCurGuildData()

        setactive(self.mTrans_BuffPanel, data.type == UIGuildGlobal.WelfareType.Buff)
        setactive(self.mTrans_GoodsPanel, data.type == UIGuildGlobal.WelfareType.Item)
        setactive(self.mTrans_LockPanel, data.unlock_level > 0 and data.unlock_level > guildLevel)
        if data.unlock_level > 0 and data.unlock_level > guildLevel then
            local cnText, enText = UIGuildGlobal:GetItemLockHint(data.unlock_level)
            self.mText_ChLockInfo.text = cnText
            self.mText_EnLockInfo.text = enText
        end
        self.mText_ItemName.text = data.name
        self:UpdatePrice(data.price)

        if data.type == UIGuildGlobal.WelfareType.Buff then
            self.mImage_BuffIcon.sprite = IconUtils.GetWelfareIcon(data.icon)
            self.mText_DurationTime.text = string.split(data.welfarelist, ":")[2] .. "H"
            local time = guildData:GetBuffItem(data.id)
            setactive(self.mTrans_LeftTime, time > 0)
            if time > 0 then
                self.time = time
                self.timeData = UIGuildGlobal:FormatDiffUnixTime2Tb(time)
                self.mText_LeftTime.text = UIGuildGlobal:GetTimeText(self.timeData)

                self.timer = TimerSys:DelayCall(1, handler(self, self.UpdateTimeData), nil, -1)
            end
        elseif data.type == UIGuildGlobal.WelfareType.Item then
            self.mImage_ItemIcon.sprite = IconUtils.GetWelfareIcon(data.icon)
        end
    end
end

function UIGuildWelfareItem:UpdateItem()
    local guildData = NetCmdGuildData:GetCurGuildData()
    if self.mData.type == UIGuildGlobal.WelfareType.Buff then
        local time = guildData:GetBuffItem(self.mData.id)
        setactive(self.mTrans_LeftTime, time > 0)
        if time > 0 then
            self.time = time
            self.timeData = UIGuildGlobal:FormatDiffUnixTime2Tb(time)
            self.mText_LeftTime.text = UIGuildGlobal:GetTimeText(self.timeData)

            if self.timer == nil then
                self.timer = TimerSys:DelayCall(1, handler(self, self.UpdateTimeData), nil, -1)
            end
        end
    end
end

function UIGuildWelfareItem:UpdateTimeData()
    self.time = self.time - 1
    self.timeData.ss = self.timeData.ss - 1
    if self.time <= 0 then
        if self.parent then
            self.parent:UpdateMainWelfareList()
        end
        setactive(self.mTrans_LeftTime, false)
        self.timer:Stop()
        -- TimerSys:Remove(self.timer)
        return
    end

    if self.timeData.ss < 0 then
        self.timeData = UIGuildGlobal:FormatDiffUnixTime2Tb(self.time)
    end
    local timeStr = UIGuildGlobal:GetTimeText(self.timeData)
    self.mText_LeftTime.text = timeStr
    self.timeStr = timeStr
    if self.parent then
        self.parent:UpdateBuffTime(self.mData.id, timeStr)
    end
end

function UIGuildWelfareItem:OnRelease()
    if self.timer then
        self.timer:Stop()
        -- TimerSys:Remove(self.timer)
        self.timer = nil
    end
end

function UIGuildWelfareItem:UpdatePrice(item)
    for id, num in pairs(item) do
        self.price = num
        self.costItem = id
        self.mImage_CostIcon.sprite = IconUtils.GetItemIconSprite(id)
        self.mText_Price.text = num
    end
end

function UIGuildWelfareItem:OnClickConfirm()
    if not NetCmdGuildData:IsManager() then
        return
    end

    local result = 0
    local canBuy = true
    if NetCmdGuildData:IsGuildItemEnough(self.costItem, self.price) then
        if self.mData.type == UIGuildGlobal.WelfareType.Buff then
            canBuy = NetCmdGuildData:CanBuyBuff(self.mData.id)
            if not canBuy then
                result = 60046
            end
        end
    else
        result = 60031
        canBuy = false
    end
    if canBuy then
        NetCmdGuildData:SendGuildBuyGood(self.mData.id, function ()
            NetCmdGuildData:UseGuildItem(self.costItem, self.price)
            NetCmdGuildData:BuyGuildItem(self.mData.id)
            self:UpdateItem()
            self.parent:UpdateGuildItem()
        end)
    else
        UIGuildGlobal:PopupHintMessage(result)
    end
end

