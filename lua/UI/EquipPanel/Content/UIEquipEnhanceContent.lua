UIEquipEnhanceContent = class("UIEquipEnhanceContent", UIBasePanel)
UIEquipEnhanceContent.__index = UIEquipEnhanceContent

function UIEquipEnhanceContent:ctor(data)
    self.mView = nil
    self.equipData = data
    self.itemIdList = TableData.GlobalSystemData.EquipLvFoodItemList

    self.equipListPanel = nil
    self.materialsList = {}
    self.itemList = {}
    self.equipList = {}
    self.selectMaterial = {}
    self.selectItemList = {}
    self.dicLevelExp = {}
    self.breakLevel = 0
    self.isCoinEnough = false
    self.isLevelUpMode = false
    self.subProp = {}
    self.subPropLevel = {}
    self.itemBrief = nil
    self.recordLv = 0
    self.mainAttr = nil

    self.sortContent = nil
    self.sortList = {}
    self.curSort = nil
end

function UIEquipEnhanceContent:InitCtrl(root)
    self.mView = UIEquipEnhanceView.New()
    self.mView:InitCtrl(root)

    for _, btn in ipairs(self.mView.addBtnList) do
        UIUtils.GetButtonListener(btn.gameObject).onClick = function()
            self:OnClickEnhance()
        end
    end

    UIUtils.GetButtonListener(self.mView.mBtn_LevelUp.gameObject).onClick = function()
        self:OnClickLevelUp()
    end

    self:InitSubProp()
    self:UpdateEquipBaseInfo()
    self:InitLevelToExpDic()
    self:UpdatePanel()
end

function UIEquipEnhanceContent:OnRelease()
    if self.equipListPanel ~= nil then
        ResourceManager:UnloadAsset(self.equipListPanel)
    end
end

function UIEquipEnhanceContent:InitEquipList()
    if self.equipListPanel == nil then
        self.equipListPanel = UIUtils.GetUIRes(UIEquipGlobal.EquipListPanelPrefab,false)
        local obj = instantiate(self.equipListPanel)
        self.mView:InitEquipList(obj)

        UIUtils.GetButtonListener(self.mView.mBtn_CloseList.gameObject).onClick = function()
            self:CloseEnhance()
        end

        UIUtils.GetButtonListener(self.mView.mBtn_AutoSelect.gameObject).onClick = function()
            self:AutoSelect()
        end

        self.pointer = UIUtils.GetPointerClickHelper(self.mView.mTrans_ItemBrief.gameObject, function()
            self:CloseItemBrief()
        end, self.mView.mTrans_ItemBrief.gameObject)

        self:InitVirtualList()
        self:InitSortContent()
    end
end

function UIEquipEnhanceContent:InitSortContent()
    if self.sortContent == nil then
        self.sortContent = UIEquipSortItem.New()
        self.sortContent:InitCtrl(self.mView.mTrans_Sort)

        UIUtils.GetButtonListener(self.sortContent.mBtn_Sort.gameObject).onClick = function()
            self:OnClickSortList()
        end

        UIUtils.GetButtonListener(self.sortContent.mBtn_Ascend.gameObject).onClick = function()
            self:OnClickAscend()
        end
    end

    local sortList = self:InstanceUIPrefab("UICommonFramework/ComScreenDropdownListItemV2.prefab", self.mView.mTrans_SortList)
    local parent = UIUtils.GetRectTransform(sortList, "Content")
    for i = 1, 3 do
        local obj = self:InstanceUIPrefab("Character/ChrEquipSuitDropdownItemV2.prefab", parent)
        if obj then
            local sort = {}
            sort.obj = obj
            sort.btnSort = UIUtils.GetButton(obj)
            sort.txtName = UIUtils.GetText(obj, "GrpText/Text_SuitName")
            sort.sortType = i
            sort.hintID = 101000 + i
            sort.sortCfg = UIEquipGlobal.SortCfg[i]
            sort.isAscend = true

            sort.txtName.text = TableData.GetHintById(sort.hintID)

            UIUtils.GetButtonListener(sort.btnSort.gameObject).onClick = function()
                self:OnClickSort(sort.sortType)
            end

            table.insert(self.sortList, sort)
        end
    end

    UIUtils.GetUIBlockHelper(self.mView.mTrans_EquipListPanel, self.mView.mTrans_SortList, function ()
        self:CloseItemSort()
    end)
end

function UIEquipEnhanceContent:InitVirtualList()
    self.mView.mVirtualList.itemProvider = function()
        local item = self:MaterialItemProvider()
        return item
    end

    self.mView.mVirtualList.itemRenderer = function(index, rendererData)
        self:MaterialItemRenderer(index, rendererData)
    end
end

function UIEquipEnhanceContent:MaterialItemProvider()
    local itemView = UIEquipMaterialItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIEquipEnhanceContent:MaterialItemRenderer(index, rendererData)
    local itemData = self.materialsList[index + 1]
    local item = rendererData.data
    item:SetData(itemData)

    UIUtils.GetButtonListener(item.mBtn_Select.gameObject).onClick = function()
        self:OnClickItem(item)
    end

    UIUtils.GetButtonListener(item.mBtn_Reduce.gameObject).onClick = function()
        self:OnClickReduce(item)
    end
end

function UIEquipEnhanceContent:OnClickItem(item)
    if self:GetSelectMaterialCount() >= UIEquipGlobal.MaxMaterialCount then
        if self:IsInSelectList(item.equipData) == nil then
            UIUtils.PopupHintMessage(40010)
            return
        else
            if item:IsRemoveEquip() then
                item:SetSelect()
                self:UpdateSelectList(item.equipData)
                return
            else
                return
            end
        end
    end

    if self.targetLevel < self.targetMaxLv then
        item:SetSelect()
    else
        if item:IsRemoveEquip() then
            item:SetSelect()
        else
            local hint = TableData.GetHintById(30020)
            CS.PopupMessageManager.PopupString(hint)
            return
        end
    end

    if item.equipData.type == UIEquipGlobal.MaterialType.Equip and item.equipData.selectCount > 0 then
        self:UpdateItemBrief(item.equipData.id)
    else
        self:CloseItemBrief()
    end

    self:UpdateSelectList(item.equipData)
end

function UIEquipEnhanceContent:OnClickReduce(item)
    item:OnReduce()
    self:UpdateSelectList(item.equipData)
end

function UIEquipEnhanceContent:UpdateSelectList(itemData)
    if itemData then
        local index = 0
        for i, item in ipairs(self.selectMaterial) do
            if itemData.type == item.type and itemData.id == item.id then
                index = i
                break
            end
        end
        if index > 0 then
            local data = self.selectMaterial[index]
            if data.selectCount <= 0 then
                table.remove(self.selectMaterial, index)
            end
        else
            table.insert(self.selectMaterial, itemData)
        end

        self:UpdateSelectListView()
    end
end

function UIEquipEnhanceContent:UpdateEquipBaseInfo()
    self.mView.mImage_Pos.sprite = IconUtils.GetEquipNum(self.equipData.category, true)
    self.mView.mText_EquipName.text = self.equipData.name
end

function UIEquipEnhanceContent:OnClickEnhance()
    if self.isLevelUpMode then
        return
    end
    self.isLevelUpMode = true
    if self.equipListPanel == nil then
        self:InitEquipList()
    end
    self:UpdateEnhanceList()
    setactive(self.mView.mTrans_EquipListPanel, true)
end

function UIEquipEnhanceContent:CloseEnhance()
    if self.mView.mAniTime and self.mView.mAnimator then
        self.mView.mAnimator:SetTrigger("Fadeout")
        TimerSys:DelayCall(self.mView.mAniTime.m_FadeOutTime, function ()
            self.isLevelUpMode = false
            self:UpdatePanel()
            setactive(self.mView.mTrans_EquipListPanel, false)
        end)
    else
        self.isLevelUpMode = false
        self:UpdatePanel()
        setactive(self.mView.mTrans_EquipListPanel, false)
    end
end

function UIEquipEnhanceContent:UpdatePanel()
    self.targetLevel = self.equipData.level
    self.targetMaxLv = self.equipData.max_level
    self.totalExp = self.dicLevelExp[self.equipData.level]
    self.selectMaterial = {}
    if self.equipData.level < self.equipData.max_level then
        local nextLevel = self.equipData.level + 1
        local exp = self.equipData:GetEquipCurNeedExpByLv(nextLevel)
        self.nextLevelExp = exp
    else
        self.nextLevelExp = 0
    end

    self:UpdateSubPropLevel()
    self:UpdateSelectListView()
    self:UpdateAttribute(self.equipData)
    self:UpdateIsMaxLevel()
end

function UIEquipEnhanceContent:UpdateSelectListView()
    for _, item in ipairs(self.selectItemList) do
        item:SetData(nil)
    end

    local addExp = 0
    local costCoin = 0
    local count = 1
    local item = nil
    for i = 1, #self.selectMaterial do
        local data = self.selectMaterial[i]
        if data.selectCount > 1 then
            for j = 1, data.selectCount do
                if count <= #self.selectItemList then
                    item = self.selectItemList[count]
                else
                    item = UIEquipMaterialItemS.New()
                    item:InitCtrl(self.mView.mTrans_MaterialList)
                    table.insert(self.selectItemList, item)
                end
                item:SetData(data)
                count = count + 1

                UIUtils.GetButtonListener(item.mBtn_Item.gameObject).onClick = function()
                    self:InvertSelectionItem(data)
                end
            end
        else
            if count <= #self.selectItemList then
                item = self.selectItemList[count]
            else
                item = UIEquipMaterialItemS.New()
                item:InitCtrl(self.mView.mTrans_MaterialList)
                table.insert(self.selectItemList, item)
            end
            item:SetData(data)
            count = count + 1

            UIUtils.GetButtonListener(item.mBtn_Item.gameObject).onClick = function()
                self:InvertSelectionItem(data)
            end
        end

        addExp = addExp + data.offerExp * data.selectCount
        costCoin = costCoin + data.costCoin * data.selectCount
    end

    self.isCoinEnough = GlobalData.cash >= costCoin
    self.mView.mText_CostCoin.text = string_format(TableData.GetHintById(805), costCoin)
    self.mView.mText_CostCoin.color = self.isCoinEnough and ColorUtils.BlackColor or ColorUtils.RedColor
    self:UpdateLevelUpInfo(addExp)
end

function UIEquipEnhanceContent:UpdateIsMaxLevel()
    local isMax = self.targetLevel >= self.equipData.max_level
    setactive(self.mView.mTrans_CostHint, not isMax)
    setactive(self.mView.mTrans_CostItemList, not isMax)
    setactive(self.mView.mTrans_CostCoin, not isMax)
    setactive(self.mView.mTrans_BtnLevelUp, not isMax)
    setactive(self.mView.mTrans_MaxLevel, isMax)
end

function UIEquipEnhanceContent:InvertSelectionItem(item)
    item.selectCount = item.selectCount - 1
    self:UpdateSelectList(item)
    self.mView.mVirtualList:Refresh()
end

function UIEquipEnhanceContent:UpdateAttribute(data)
    self:UpdateMainAttribute(data)
    self:UpdateSubAttribute(data)
end

function UIEquipEnhanceContent:UpdateMainAttribute(data)
    if data.main_prop then
        if self.mainAttr == nil then
            self.mainAttr = UICommonPropertyItem.New()
        end

        local tableData = TableData.listCalibrationDatas:GetDataById(data.main_prop.Id)
        if tableData then
            local propData = TableData.GetPropertyDataByName(tableData.property, tableData.type)
            self.mView.mText_MainPropName.text = propData.show_name.str
            if propData.show_type == 2 then
                self.mView.mText_MainPropValue.text = math.ceil(data.main_prop.Value / 10)  .. "%"
                self.mView.mText_MainPropNow.text = math.ceil(data.main_prop.Value / 10)  .. "%"
            else
                self.mView.mText_MainPropValue.text = data.main_prop.Value
                self.mView.mText_MainPropNow.text = data.main_prop.Value
            end
            self.mainAttr.mData = propData
            self.mainAttr.value = data.main_prop.Value
            self.mainAttr.upValue = 0
            setactive(self.mView.mText_MainPropValue.gameObject, true)
        end
    end
end

function UIEquipEnhanceContent:UpdateSubAttribute(data)
    if data.sub_props then
        local item = nil
        for _, item in ipairs(self.subProp) do
            item:SetData(nil)
        end

        for i = 0, data.sub_props.Length - 1 do
            local prop = data.sub_props[i]
            if i + 1 <= #self.subProp then
                item = self.subProp[i + 1]
            else
                item = UICommonPropertyItem.New()
                item:InitCtrl(self.mView.mTrans_PropList)
                table.insert(self.subProp, item)
            end
            local tableData = TableData.listCalibrationDatas:GetDataById(prop.Id)
            local propData = TableData.GetPropertyDataByName(tableData.property, tableData.type)
            item:SetData(propData, prop.Value, true, false, false, false)
        end
    end
end

function UIEquipEnhanceContent:UpdateLvUpAttr()
    self:UpdateLvUpMainAttr()
    self:UpdateLvUpSubAttr()
end

function UIEquipEnhanceContent:UpdateLvUpMainAttr()
    local level = self.targetLevel - self.equipData.level
    setactive(self.mView.mTrans_MainPropAdd, level > 0)
    setactive(self.mView.mText_MainPropValue.gameObject, level <= 0)
    if level > 0 then
        local tableData = TableData.listCalibrationDatas:GetDataById(self.equipData.main_prop.Id)
        local levelUpValue = math.ceil((tableData.grow_range[0] * level))
        levelUpValue = self.equipData.main_prop.Value + levelUpValue
        local propData = self.mainAttr.mData
        if propData.show_type == 2 then
            self.mView.mText_MainPropAfter.text = math.ceil(levelUpValue / 10) .. "%"
        else
            self.mView.mText_MainPropAfter.text = levelUpValue
        end

        self.mainAttr.upValue = levelUpValue
    end
end

function UIEquipEnhanceContent:UpdateLvUpSubAttr()
    local subCount = self:CheckCanUpdateSubProp(self.targetLevel)
    -- printstack(subCount)
    if subCount then
        for _, item in ipairs(self.subProp) do
            item:SetData(nil)
        end
        for i, item in ipairs(self.subProp) do
            if i <= self.equipData.sub_props.Length then
                local tableData = TableData.listCalibrationDatas:GetDataById(self.equipData.sub_props[i - 1].Id)
                local propData = TableData.GetPropertyDataByName(tableData.property, tableData.type)
                item:SetData(propData, self.equipData.sub_props[i - 1].Value, true, false, false, false)
            else
                if i <= subCount and i > self.equipData.sub_props.Length then
                    if i > TableData.GlobalSystemData.EquipSubPropertyToplimit then
                        item:SetTipsName(20013, subCount - TableData.GlobalSystemData.EquipSubPropertyToplimit)
                    else
                        item:SetTipsName(20012)
                    end
                end
            end
        end
    end
end

function UIEquipEnhanceContent:UpdateLevelUpInfo(exp)
    self.targetLevel = self:CalculateLevel(self.equipData.exp + exp + self.dicLevelExp[self.equipData.level])
    self.totalExp = self.dicLevelExp[self.equipData.level] + self.equipData.exp + exp
    self:UpdateEquipInfo(exp)
end

function UIEquipEnhanceContent:UpdateEquipInfo(exp)
    local maxExp = 0
    local curExp = 0
    local sliderBeforeValue = 0
    local sliderAfterValue = 0
    local maxLevel = self.equipData.max_level
    local curExpData = self.dicLevelExp[self.equipData.level]
    local targetExpData = self.dicLevelExp[self.targetLevel]

    if self.equipData.exp + exp >= self.nextLevelExp then
        local nextLevel = (self.targetLevel >= maxLevel) and maxLevel or (self.targetLevel + 1)
        maxExp = self.equipData:GetEquipCurNeedExpByLv(nextLevel)
        if self.targetLevel >= maxLevel then
            curExp = maxExp
        else
            curExp = curExpData + self.equipData.exp + exp - targetExpData
        end
        sliderBeforeValue = self.equipData.level >= maxLevel and 1 or 0
        sliderAfterValue = curExp / maxExp
    else
        maxExp = self.nextLevelExp
        if self.targetLevel >= maxLevel then
            curExp = maxExp
            sliderAfterValue = 1
            sliderBeforeValue = 1
        else
            curExp = self.equipData.exp + exp
            sliderBeforeValue = self.equipData.exp / self.nextLevelExp
            sliderAfterValue = (self.equipData.exp + exp) / self.nextLevelExp
        end
    end

    self.mView.mText_Exp.text = string_format("{0}/{1}", curExp, maxExp)
    self.mView.mText_Level.text = string_format(UIEquipGlobal.EquipEnhanceLvRichText, self.targetLevel, maxLevel)
    self.mView.mText_AddExp.text = "+" .. exp
    self.mView.mImage_ExpAfter.fillAmount = sliderAfterValue
    self.mView.mImage_ExpBefore.fillAmount = sliderBeforeValue
    self.canLevelUp = exp > 0
    -- setactive(self.mView.mTrans_EnableLevelUp, self.isCoinEnough and self.canLevelUp)

    self:UpdateLvUpAttr()
    -- self.mView.mVirtualList:Refresh()
end

function UIEquipEnhanceContent:CalculateLevel(exp)
    for i = 1, TableData.listEquipmentExpDatas.Count - 1 do
        local data = TableData.listEquipmentExpDatas[i]
        local needExp = self.dicLevelExp[data.level]
        local lastExp = self.dicLevelExp[data.level - 1]
        if lastExp <= exp and exp < needExp then
            return data.level - 1
        end
    end
    return TableData.listEquipmentExpDatas[TableData.listEquipmentExpDatas.Count - 1].level
end

function UIEquipEnhanceContent:UpdateEnhanceList()
    local list = NetCmdEquipData:GetEnhanceEquipList(self.equipData.id)
    self.materialsList = self:UpdateMaterialList(list)

    self:OnClickSort(UIEquipGlobal.SortType.Rank)
    setactive(self.mView.mTrans_EquipListEmpty, #self.materialsList <= 0)
end

function UIEquipEnhanceContent:UpdateListBySort()
    local sortFunc = self.sortContent.sortFunc
    table.sort(self.materialsList, sortFunc)

    self.mView.mVirtualList.numItems = #self.materialsList
    self.mView.mVirtualList:Refresh()
end

function UIEquipEnhanceContent:UpdateMaterialList(list)
    if list then
        self.itemList = {}
        self.equipList = {}
        local itemList = {}

        --- 先走item
        for i = 0, self.itemIdList.Count - 1 do
            local id = self.itemIdList[i]
            local data = UIEquipGlobal:GetMaterialSimpleData(id, UIEquipGlobal.MaterialType.Item)
            if data then
                table.insert(itemList, data)
                table.insert(self.itemList, data)
            end
        end

        for i = 0, list.Count - 1 do
            local data = UIEquipGlobal:GetMaterialSimpleData(list[i], UIEquipGlobal.MaterialType.Equip)
            table.insert(itemList, data)
            table.insert(self.equipList, data)
        end

        return itemList
    end
end

function UIEquipEnhanceContent:OnClickLevelUp()
    if not self.isCoinEnough then
        UIUtils.PopupHintMessage(40005)
        return
    end
    if not self.canLevelUp then
        UIUtils.PopupHintMessage(40009)
        return
    end
    local itemList, equipList = self:GetMaterialList()
    self.recordLv = self.equipData.level
    NetCmdGunEquipData:SendEquipLevelUpCmd(self.equipData.id, equipList, itemList, function (ret) self:LevelUpCallback(ret) end)
end

function UIEquipEnhanceContent:LevelUpCallback(ret)
    if ret == CS.CMDRet.eSuccess then
        gfdebug("强化武器成功")
        local tempPropList = deep_copy(self.subProp)
        local tempMain = deep_copy(self.mainAttr)
        self.equipData = NetCmdEquipData:GetEquipById(self.equipData.id)
        self:UpdatePanel()
        self:UpdateEnhanceList()

        if self.recordLv < self.targetLevel then
            self:OpenLevelUpPanel(tempMain, tempPropList)
        end
    else
        gfdebug("强化武器失败")
        MessageBox.Show("出错了", "强化武器失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil)
    end
end

function UIEquipEnhanceContent:OpenLevelUpPanel(tempMain, tempPropList)
    local lvUpData = CommonLvUpData.New(self.recordLv, self.targetLevel)
    lvUpData:SetEquipLvUpData(tempMain, tempPropList, self.subProp)
    UIManager.OpenUIByParam(UIDef.UICommonLvUpPanel, lvUpData)
end

function UIEquipEnhanceContent:GetMaterialList()
    local itemList = {}
    local equipList = {}
    for _, item in ipairs(self.selectMaterial) do
        if item.type == UIEquipGlobal.MaterialType.Item then
            itemList[item.id] = item.selectCount
        elseif item.type == UIEquipGlobal.MaterialType.Equip then
            table.insert(equipList, item.id)
        end
    end
    return itemList, equipList
end

function UIEquipEnhanceContent:IsInSelectList(itemData)
    for _, item in ipairs(self.selectMaterial) do
        if itemData.type == item.type and itemData.id == item.id then
            return item
        end
    end
    return nil
end

function UIEquipEnhanceContent:GetSelectMaterialCount()
    local count = 0
    for _, item in ipairs(self.selectMaterial) do
        count = count + item.selectCount
    end
    return count
end

function UIEquipEnhanceContent:InitLevelToExpDic()
    local exp = 0
    for i = 0, self.equipData.max_level do
        local expData = TableData.listEquipmentExpDatas:GetDataById(i)
        self.dicLevelExp[i] =  math.ceil(exp + expData.equip_exp * self.equipData.TableData.ExpRate / 1000)
        exp = self.dicLevelExp[i]
    end
end

function UIEquipEnhanceContent:InitSubProp()
    local maxSubCount = TableData.GlobalSystemData.EquipSubPropertyToplimit
    local item = nil
    for i = 1, maxSubCount + 1 do
        item = UICommonPropertyItem.New()
        item:InitCtrl(self.mView.mTrans_PropList)
        table.insert(self.subProp, item)

        item:SetData(nil)
    end
end

function UIEquipEnhanceContent:CheckCanUpdateSubProp(targetLevel)
    local subCount = 0
    local tempLevel = 0
    for level, count in pairs(self.subPropLevel) do
        if targetLevel >= level and tempLevel < level then
            tempLevel = level
            subCount = count
        end
    end
    return subCount
end

function UIEquipEnhanceContent:UpdateSubPropLevel()
    local subLevel = TableData.GlobalSystemData.EquipSubPropertyLevel
    local step = self.equipData.max_level / subLevel
    local count = self.equipData.sub_props.Length
    self.subPropLevel[self.equipData.level] = count
    for i = 1, step do
        if self.equipData.level < subLevel * i then
            count = count + 1
            -- printstack(subLevel * i .. "                " .. count)
            self.subPropLevel[subLevel * i] = count
        end
    end
end

function UIEquipEnhanceContent:UpdateItemBrief(id)
    if self.itemBrief == nil then
        self.itemBrief = UIBarrackBriefItem.New()
        self.itemBrief:InitCtrl(self.mView.mTrans_ItemBrief)

        self.itemBrief:EnableLock(false)
        self.itemBrief:EnableButtonGroup(false)
    end
    self.pointer.isInSelf = true
    self.itemBrief:SetData(UIBarrackBriefItem.ShowType.Equip, id)
end

function UIEquipEnhanceContent:CloseItemBrief()
    if self.itemBrief ~= nil then
        self.itemBrief:SetData(nil)
    end
end

function UIEquipEnhanceContent:OnClickSortList()
    setactive(self.mView.mTrans_SortList, true)
end

function UIEquipEnhanceContent:CloseItemSort()
    setactive(self.mView.mTrans_SortList, false)
end

function UIEquipEnhanceContent:OnClickSort(type)
    if type then
        if self.curSort then
            if self.curSort.sortType ~= type then
                self.curSort.btnSort.interactable = true
            end
        end
        self.curSort = self.sortList[type]
        self.curSort.isAscend = true
        self.curSort.btnSort.interactable = false
        self.sortContent:SetData(self.curSort)

        self:UpdateListBySort()
        self:CloseItemSort()
    end
end

function UIEquipEnhanceContent:OnClickAscend()
    if self.curSort then
        self.curSort.isAscend = not self.curSort.isAscend
        self.sortContent:SetData(self.curSort)

        self:UpdateListBySort()
    end
end

function UIEquipEnhanceContent:AutoSelect()
    if self.targetLevel >= self.equipData.max_level or self:GetSelectMaterialCount() >= UIEquipGlobal.MaxMaterialCount then
        return
    end
    local maxLevelExp = self.dicLevelExp[self.equipData.max_level]
    local needExp = maxLevelExp - self.totalExp

    table.sort(self.itemList, function (a, b) return a.offerExp > b.offerExp end)
    for i, item in ipairs(self.itemList) do
        if self:GetSelectMaterialCount() >= UIEquipGlobal.MaxMaterialCount or needExp <= 0 then
            break
        end

        local lastCount = UIEquipGlobal.MaxMaterialCount - self:GetSelectMaterialCount()
        local selectCount = math.min(needExp / item.offerExp, item.count)
        if i == #self.itemList then   --- 最后一个了，梭哈
            item.selectCount = math.ceil(selectCount)
            item.selectCount = math.min(item.selectCount, item.count)
            item.selectCount = math.min(item.selectCount, lastCount)
            local selectItem = self:IsInSelectList(item)
            if selectItem then
                selectItem.selectCount = item.selectCount
            else
                table.insert(self.selectMaterial, item)
            end
        else
            if selectCount >= 1 then
                selectCount = math.min(selectCount, UIEquipGlobal.MaxMaterialCount - self:GetSelectMaterialCount())
                item.selectCount = item.selectCount + math.floor(selectCount)
                item.selectCount = math.min(item.selectCount, item.count)
                local selectItem = self:IsInSelectList(item)
                if selectItem ~= nil then
                    selectItem.selectCount = item.selectCount
                else
                    table.insert(self.selectMaterial, item)
                end
            end
        end

        needExp = needExp - item.offerExp * item.selectCount
    end

    if needExp > 0 and self:GetSelectMaterialCount() < UIEquipGlobal.MaxMaterialCount then
        table.sort(self.equipList, function (a, b)
            if a.rank == b.rank then
                if a.offerExp == b.offerExp then
                    if a.stcId == b.stcId then
                        return a.id < b.id
                    end
                else
                    return a.offerExp < b.offerExp
                end
            else
                return a.rank < b.rank
            end
        end)

        for _, item in ipairs(self.equipList) do
            if self:GetSelectMaterialCount() >= UIEquipGlobal.MaxMaterialCount or needExp <= 0 then
                break
            end
            if item.selectCount <= 0 then
                item.selectCount = 1
                table.insert(self.selectMaterial, item)
                needExp = needExp - item.offerExp
            end
        end
    end

    self.mView.mVirtualList:Refresh()
    self:UpdateSelectListView()
end
