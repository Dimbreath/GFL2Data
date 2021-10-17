---@class UILevelUpContent : UIBarrackContentBase
UILevelUpContent = class("UILevelUpContent", UIBarrackContentBase)
UILevelUpContent.__index = UILevelUpContent

UILevelUpContent.PrefabPath = "Character/ChrLevelUpDialogV2.prefab"

function UILevelUpContent:ctor(obj)
    self.attributeList = {}
    self.expItems = {}
    self.currentItem = nil
    self.isLongPress = false
    self.pressType = 0
    self.framer = 0
    self.dicLevelExp = {}
    self.curExp = 0
    self.curLevel = 0
    self.canAddItemOnce = true
    self.costNum = 0
    self.topBar = nil
    -- self.isPlayAni = false
    self.pressUpdateFrame, self.pressAddCount = FacilityBarrackGlobal:GetPressParam()

    UILevelUpContent.super.ctor(self, obj)
end

function UILevelUpContent:__InitCtrl()
    self.mBtn_LevelUp = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpAction/BtnConfirm"))
    self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_Goto = self:GetButton("Trans_LevelUpConfirm/Trans_LevelMaxPanel/Btn_ConfirmButton")
    self.mBtn_LevelUpCancel = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpAction/BtnCancel"))
    self.mBtn_EmptyArea = self:GetButton("Root/GrpBg/Btn_Close")
    self.mText_Lv = self:GetText("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextLevel/GrpTextLevel/Text_LevelNow")
    self.mText_LvMax = self:GetText("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextLevel/GrpTextLevel/Text_LevelMax")
    self.mText_Exp = self:GetText("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextLevel/GrpTextExp/Text_Exp")
    self.mText_Cost = self:GetText("Root/GrpDialog/GrpCenter/GrpGoldConsume/Text_Num")

    self.mTrans_ItemList = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpItemList/Content")
    self.mText_ConfirmAddExp = self:GetText("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextLevel/GrpTextAdd/Text_Add")
    self.mImage_ExpBefore = self:GetImage("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpProgressBar/Img_ProgressBarBefore")
    self.mImage_ExpAfter = self:GetImage("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpProgressBar/Img_ProgressBarAfter")

    self.mTrans_Topbar = self:GetRectTransform("Root/GrpTop/GrpCurrency")

    --UIUtils.GetButtonListener(self.mBtn_LevelUpConfirm.gameObject).onClick = function()
    --    if self.mData.level >= self.gunMaxLevel then
    --        local hint = TableData.GetHintById(60002)
    --        CS.PopupMessageManager.PopupString(hint)
    --        return
    --    end
    --    self:OnClickLevelUpConfirm()
    --end

    UIUtils.GetButtonListener(self.mBtn_LevelUp.gameObject).onClick = function()
        self:OnClickLevelUp()
    end

    --UIUtils.GetButtonListener(self.mBtn_Goto.gameObject).onClick = function()
    --    self:OnClickGoto()
    --end

    UIUtils.GetButtonListener(self.mBtn_LevelUpCancel.gameObject).onClick = function()
        self:OnClickCloseLevelUp()
    end

    UIUtils.GetButtonListener(self.mBtn_EmptyArea.gameObject).onClick = function()
        self:OnClickCloseLevelUp()
    end

    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = function()
        self:OnClickCloseLevelUp()
    end

    self:InitAttributeList()
    self:InitTopbar()
    self:InitLevelToExpDic()
end

function UILevelUpContent:SetData(data, parent)
    UILevelUpContent.super.SetData(self, data, parent)
    self:UpdateLevelInfo(data)
    self:UpdateAttributeList()
    self:OnClickLevelUpConfirm()
    self:UpdateTopbar()
    self:ResetExpItem()

    self:OnEnable(true)
end

function UILevelUpContent:UpdateLevelInfo(cmdData)
    self.gunMaxLevel = cmdData.MaxGunLevel
    self.maxLevelTotalExp = TableData.GunExpToLevel(self.gunMaxLevel)

    self.mText_Lv.text = cmdData.level
    self.mText_LvMax.text = "/" .. self.gunMaxLevel
end

function UILevelUpContent:GetEquipWeaponValue(cmdData, name)
    local equipValue = cmdData:GetGunEquipValueByName(name)
    local weaponValue = cmdData:GetWeaponValueByName(name)
    return equipValue + weaponValue
end

function UILevelUpContent:OnClickLevelUpConfirm()
    local nextLevel = self.mData.level >= self.gunMaxLevel and self.gunMaxLevel or self.mData.level + 1
    self.nextLevelExp = TableData.listGunLevelExpDatas:GetDataById(nextLevel).exp
    self.targetLevel = self.mData.level
    self.curLevel = self.mData.level  --- 记录当前等级，表现需要
    self.curExp = 0

    self:UpdateLevelUpItem()
    self:UpdateLevelUpInfo()
end

function UILevelUpContent:UpdateLevelUpItem()
    local itemList = NetCmdItemData:GetExpItemList()
    for i = 0, itemList.Count - 1 do
        local item = nil
        if i + 1 <= #self.expItems then
            item = self.expItems[i + 1]
        else
            item = UIGunExpItem.New()
            item:InitCtrl(self.mTrans_ItemList)
            table.insert(self.expItems, item)
        end
        self:AddItemListener(item)
        item:SetData(itemList[i])
    end
end

function UILevelUpContent:UpdateLevelUpInfo()
    local exp = 0
    for _, item in ipairs(self.expItems) do
        exp = exp + item:GetItemExp()
    end

    self.targetLevel = self:CalculateLevel(self.mData.exp + exp + self.dicLevelExp[self.mData.level])
    self.totalExp = self.dicLevelExp[self.mData.level] + self.mData.exp + exp
    self.costNum = self.mData.level == self.targetLevel and 0 or self:CalculateCost()
    self:UpdateLevelPreview(exp)
end

function UILevelUpContent:CalculateCost()
    local gold = 0
    for i = self.mData.level + 1, self.targetLevel do
        gold = TableData.listGunLevelExpDatas:GetDataById(i).gold + gold
    end
    return gold
end

function UILevelUpContent:UpdateLevelPreview(exp)
    if not exp then
        return
    end
    local nextLevel = 0
    local currentExp = 0
    local maxExp = 0
    local sliderBeforeValue = 0
    local sliderAfterValue = 0
    local strLevel = self.targetLevel >= self.gunMaxLevel and self.gunMaxLevel or self.targetLevel
    if self.mData.exp + exp >= self.nextLevelExp then
        nextLevel = (self.targetLevel >= self.gunMaxLevel) and self.gunMaxLevel or (self.targetLevel + 1)
        maxExp = TableData.listGunLevelExpDatas:GetDataById(nextLevel).exp
        if self.targetLevel >= self.gunMaxLevel then
            currentExp = maxExp
        else
            currentExp = self.dicLevelExp[self.mData.level] + self.mData.exp + exp - self.dicLevelExp[self.targetLevel]
        end
        sliderBeforeValue = 0
        sliderAfterValue = currentExp / maxExp
    else
        maxExp = self.nextLevelExp
        if self.targetLevel >= self.gunMaxLevel then
            currentExp = maxExp
            sliderBeforeValue = 1
            sliderAfterValue = 1
        else
            currentExp = self.mData.exp + exp
            sliderBeforeValue = self.mData.exp / self.nextLevelExp
            sliderAfterValue = (self.mData.exp + exp) / self.nextLevelExp
        end
    end

    self.mText_Lv.text = strLevel
    self.mText_Exp.text = string_format("{0}/{1}", currentExp, maxExp)
    self.mText_ConfirmAddExp.text = "+" .. exp
    self.mImage_ExpBefore.fillAmount = sliderBeforeValue
    self.mImage_ExpAfter.fillAmount= sliderAfterValue
    self.canLevelUp = exp > 0
    self.mText_Cost.text = self.costNum
end

function UILevelUpContent:AddItemListener(item)
    if item then
        UIUtils.GetButtonListener(item.mBtn_Select.gameObject).onClick = function()
            self:OnClickItem(item, FacilityBarrackGlobal.PressType.Plus)
        end

        UIUtils.GetButtonListener(item.mBtn_Minus.gameObject).onClick = function()
            self:OnClickItem(item, FacilityBarrackGlobal.PressType.Minus)
        end

        local longPress = CS.LongPressTriggerListener.Set(item.mBtn_Select.gameObject,0.5,true)
        longPress.longPressStart = function() self:OnItemPressed(item, FacilityBarrackGlobal.PressType.Plus) end
        longPress.longPressEnd = function() self:OnItemPressedOver(item) end

        longPress = CS.LongPressTriggerListener.Set(item.mBtn_Minus.gameObject,0.5,true)
        longPress.longPressStart = function() self:OnItemPressed(item, FacilityBarrackGlobal.PressType.Minus) end
        longPress.longPressEnd = function() self:OnItemPressedOver(item) end
    end
end

function UILevelUpContent:OnUpdate()
    if self.isLongPress and self.currentItem then
        self.framer = self.framer + 1
        if self.framer >= self.pressUpdateFrame then
            if self.pressType == FacilityBarrackGlobal.PressType.Plus then
                self:OnLongPressAdd(self.pressAddCount)
            elseif self.pressType == FacilityBarrackGlobal.PressType.Minus then
                self:OnLongPressMinus(-self.pressAddCount)
            end
            self.framer = 0
        end
    end
end

function UILevelUpContent:OnClickItem(item, type)
    if item then
        if type == FacilityBarrackGlobal.PressType.Plus then
            if item:IsOutOfNum() or not self:CanAddItem() then
                if self:CheckIsMaxLevel() then
                    local hint = TableData.GetHintById(60002)
                    CS.PopupMessageManager.PopupString(hint)
                end
                return
            end
        end

        if self.canAddItemOnce then
            item:OnClickItem(type)
            self:UpdateLevelUpInfo()
        else
            self.canAddItemOnce = true
        end
    end
end

function UILevelUpContent:OnItemPressed(item, type)
    if item then
        self:SetLongPress(item.mData.ItemTableData.id)
        self:EnableLongPress(true, type)
    end
end

function UILevelUpContent:SetLongPress(itemId)
    for i = 1, #self.expItems do
        if self.expItems[i].mData.ItemTableData.id == itemId then
            self.currentItem = self.expItems[i]
            return
        end
    end
end

function UILevelUpContent:EnableLongPress(enable, pressType)
    self.isLongPress = enable
    self.pressType = pressType
    if not enable then
        self.currentItem = nil
        self.pressType = 0
    end
end

function UILevelUpContent:OnLongPressAdd(count)
    if self.currentItem:IsOutOfNum() or not self:CanAddItem() then
        if self:CheckIsMaxLevel() then
            local hint = TableData.GetHintById(60002)
            CS.PopupMessageManager.PopupString(hint)
        end
        return
    end
    count = self.currentItem:GetItemCount(count)
    local addExp = self.currentItem:GetItemAddExp(count)
    local constraintValue = self:ConstraintExpItem(addExp)
    if constraintValue >= 0 then
    	count = math.ceil(constraintValue / self.currentItem.offerExp)
    end
    self.currentItem:UpdateData(count)
    self:UpdateLevelUpInfo()
end

function UILevelUpContent:OnLongPressMinus(count)
    if self.currentItem.mCurrentCount <= 0 then
        self:EnableLongPress(false)
        return
    end
    count = self.currentItem.mCurrentCount + count <= 0 and -self.currentItem.mCurrentCount or count
    self.currentItem:UpdateData(count)
    self:UpdateLevelUpInfo()
end

function UILevelUpContent:OnItemPressedOver(item)
    if item then
        self:EnableLongPress(false)
        self.canAddItemOnce = false
    end
end

function UILevelUpContent:OnClickCloseLevelUp()
    setactive(self.mUIRoot, false)
    self:ResetExpItem()
end

function UILevelUpContent:OnClickLevelUp()
    if self.canLevelUp then
        if NetCmdItemData:GetItemCountById(GlobalConfig.CoinId) >= self.costNum then
            self:SendLevelUpReq()
        else
            local hint = GlobalConfig.GetCostNotEnoughStr(GlobalConfig.CoinId)
            CS.PopupMessageManager.PopupString(hint)
            return
        end
    else
        local hint = TableData.GetHintById(60009)
        CS.PopupMessageManager.PopupString(hint)
    end
end

function UILevelUpContent:SendLevelUpReq()
    self.mParent:EnableMask(true)
    NetCmdTrainGunData:SendCmdGunLevelUp(self.mData.id, self:GetCurrentExpList(), function (ret)
        self:OnLevelUpCallBack(ret)
    end)
end

function UILevelUpContent:OnLevelUpCallBack(ret)
    if ret == CS.CMDRet.eSuccess then
        gfdebug("人形升级成功")
        local targetLv = 0
        printstack(self.mData.level)
        if self.mData.level >= self.gunMaxLevel then
            targetLv = self.gunMaxLevel
        else
            targetLv = self.mData.level + self.mData.exp / TableData.listGunLevelExpDatas:GetDataById(self.mData.level + 1).exp
        end

        self.mData:SetLevelUp(self.mData.level, self.mData.exp)
        if self.curLevel ~= self.mData.level then
            self:OpenLevelUpPanel()
        end
        self:UpdateLevelInfo(self.mData)
        self:UpdateAttributeList()

        self:ResetExpItem()
        self:OnClickLevelUpConfirm()
        self:UpdateTopbar()
        self.mParent:EnableMask(false)
        self.mParent:UpdateLevelInfo()
        self.mParent:UpdateGunLevelLock()
        self.mParent:UpdateAttributeList()
        self.mParent:UpdateFightingCapacity()
    else
        self.mParent:EnableMask(false)
        gfdebug("人形升级失败")
        MessageBox.Show("出错了", "人形升级失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
    end
end

--function UILevelUpContent:PlayLevelUpAni(startLv, endLv)
--    self.mImage_ExpAfter.fillAmount = 0
--     self.isPlayAni = true
--    CS.ProgressBarAnimationHelper.Play(self.mImage_ExpBefore, startLv, endLv,2,
--            function (lv)
--                print(lv)
--                self.mText_ConfirmLv.text = string_format(FacilityBarrackGlobal.LvRichText2, lv, self.gunMaxLevel)
--            end,
--            function ()
--                print("over")
--                self:ResetExpItem()
--                self:OnClickLevelUpConfirm()
--                self.isPlayAni = false
--                self:EnableMask(false)
--            end)
--end

function UILevelUpContent:OpenLevelUpPanel()
    local lvUpData = CommonLvUpData.New(self.curLevel, self.mData.level)
    for _, item in ipairs(self.attributeList) do
        item.upValue = self.mData:GetGunPropertyValueByType(item.mData.sys_name)
    end

    lvUpData:SetGunLvUpData(self.attributeList)
    UIManager.OpenUIByParam(UIDef.UICommonLvUpPanel, lvUpData)
end

function UILevelUpContent:UpdateAttributeList()
    for _, item in ipairs(self.attributeList) do
        item.value = self.mData:GetGunPropertyValueByType(item.mData.sys_name)
    end
end

function UILevelUpContent:ResetExpItem()
    self.isLongPress = false
    self.currentItem = nil

    for _, item in ipairs(self.expItems) do
        item:ResetItem()
    end
end

function UILevelUpContent:InitLevelToExpDic()
    if self.dicLevelExp == nil then
        self.dicLevelExp = {}
    end
    local totalExp = 0
    for i = 0, TableData.listGunLevelExpDatas.Count - 1 do
        local data = TableData.listGunLevelExpDatas[i]
        totalExp = totalExp + data.exp
        self.dicLevelExp[data.level] = totalExp
    end
end

function UILevelUpContent:InitAttributeList()
    local propList = {}
    for i = 0, TableData.listLanguagePropertyDatas.Count - 1 do
        local propData = TableData.listLanguagePropertyDatas[i]
        if propData then
            if propData.barrack_show ~= 0 then
                table.insert(propList, propData)
            end
        end
    end

    table.sort(propList, function (a, b) return a.barrack_show < b.barrack_show end)
    for _, prop in ipairs(propList) do
        local item = UICommonPropertyItem.New()
        item.mData = prop
        table.insert(self.attributeList, item)
    end
end

function UILevelUpContent:CheckIsMaxLevel()
    return self.targetLevel >= self.gunMaxLevel
end

function UILevelUpContent:CalculateLevel(exp)
    for i = 1, TableData.listGunLevelExpDatas.Count - 1 do
        local data = TableData.listGunLevelExpDatas[i]
        local needExp = self.dicLevelExp[data.level]
        local lastExp = self.dicLevelExp[data.level - 1]
        if lastExp <= exp and exp < needExp then
            return data.level - 1
        end
    end
    return TableData.listGunLevelExpDatas[TableData.listGunLevelExpDatas.Count - 1].level
end

function UILevelUpContent:ConstraintExpItem(exp)
    if (self.totalExp + exp) - self.maxLevelTotalExp >= 0 then
        return self.maxLevelTotalExp - self.totalExp
    end
    return -1
end

function UILevelUpContent:CanAddItem()
    return self.targetLevel < self.gunMaxLevel
end

function UILevelUpContent:OnClickGoto()
    self:OnClickCloseLevelUp()
    self:ChangeTab(FacilityBarrackGlobal.PowerUpType.Mental)
end

function UILevelUpContent:GetCurrentExpList()
    local list = {}
    for _, item in ipairs(self.expItems) do
        if item.mCurrentCount > 0 then
            list[item.mData] = item.mCurrentCount
        end
    end
    return list
end

function UILevelUpContent:InitTopbar()
    if self.topBar == nil then
        self.topBar = ResourcesCommonItem.New()
        self.topBar:InitCtrl(self.mTrans_Topbar, true)
    end
end

function UILevelUpContent:UpdateTopbar()
    if self.topBar then
        self.topBar:SetData({ id = GlobalConfig.CoinId})
    end
end