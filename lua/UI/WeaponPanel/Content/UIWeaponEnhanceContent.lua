require("UI.UIBasePanel")
require("UI.WeaponPanel.UIWeaponPanelView")

UIWeaponEnhanceContent = class("UIWeaponEnhanceContent", UIBasePanel)
UIWeaponEnhanceContent.__index = UIWeaponEnhanceContent

function UIWeaponEnhanceContent:ctor(data, weaponPanel)
    self.mView = nil
    self.weaponListContent = nil
    self.mData = data
    self.weaponPanel = weaponPanel
    self.itemIdList = TableData.GlobalSystemData.WeaponLevelUpItem
    self.breakItem = TableData.GlobalSystemData.WeaponLevelBreakItem
    self.breakLevel = TableData.GlobalSystemData.WeaponLevelPerBreak
    self.skillUpLevel = TableData.GlobalSystemData.WeaponSkillUpLevel
    self.weaponLowRank = TableData.GlobalSystemData.WeaponLowRank

    self.materialsList = {}
    self.itemList = {}
    self.weaponList = {}
    self.selectMaterial = {}
    self.selectItemList = {}
    self.dicLevelExp = {}
    self.isCoinEnough = false
    self.isLevelUpMode = false
    self.needBreak = false
    self.propertyList = {}
    self.skillDetail = nil
    self.itemBrief = nil
    self.recordLv = 0
    self.recordExp = 0

    self.sortContent = nil
    self.sortList = {}
    self.curSort = nil
end

function UIWeaponEnhanceContent:InitCtrl(root, weaponList)
    self.mView = UIWeaponEnhanceContentView.New()
    self.mView:InitCtrl(root, weaponList)
    self.weaponListContent = weaponList
    self.sortContent = weaponList.sortContent
    self.sortList = weaponList.sortList

    for _, btn in ipairs(self.mView.addBtnList) do
        UIUtils.GetButtonListener(btn.gameObject).onClick = function()
            self:OnClickEnhance()
        end
    end

    UIUtils.GetButtonListener(self.mView.mBtn_LevelUp.gameObject).onClick = function()
        self:OnClickLevelUp()
    end

    self.isLevelUpMode = false
    self:InitLevelToExpDic()
end

function UIWeaponEnhanceContent:OnRelease()
    self:ReleaseTimers()
end

function UIWeaponEnhanceContent:InitSortContent()
    UIUtils.GetButtonListener(self.sortContent.mBtn_Ascend.gameObject).onClick = function()
        self:OnClickAscend()
    end

    for i, sort in ipairs(self.sortList) do
        sort.sortType = i
        sort.hintID = 101000 + i
        sort.sortCfg = UIWeaponGlobal.MaterialSortCfg[i]
        sort.isAscend = true

        sort.txtName.text = TableData.GetHintById(sort.hintID)

        UIUtils.GetButtonListener(sort.btnSort.gameObject).onClick = function()
            self:OnClickSort(sort.sortType)
        end
    end
end

function UIWeaponEnhanceContent:InitVirtualList()
    self.mView.mVirtualList.itemProvider = function()
        local item = self:MaterialItemProvider()
        return item
    end

    self.mView.mVirtualList.itemRenderer = function(index, rendererData)
        self:MaterialItemRenderer(index, rendererData)
    end
end

function UIWeaponEnhanceContent:MaterialItemProvider()
    local itemView = UIWeaponMaterialItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIWeaponEnhanceContent:MaterialItemRenderer(index, rendererData)
    local itemData = self.materialsList[index + 1]
    local item = rendererData.data

    item:SetData(itemData, not self:CheckCanSelectWeapon(itemData))


    UIUtils.GetButtonListener(item.mBtn_Select.gameObject).onClick = function()
        self:OnClickItem(item)
    end

    UIUtils.GetButtonListener(item.mBtn_Reduce.gameObject).onClick = function()
        self:OnClickReduce(item)
    end
end

function UIWeaponEnhanceContent:CheckCanSelectWeapon(data)
    if self:GetSelectMaterialCount() >= UIWeaponGlobal.MaxMaterialCount then
        return false
    else
        if self.targetLevel >= self.mData.MaxBreakMaxLv then
            return false
        else
            if self.targetLevel >= self.curMaxLv then
                if data.type == UIWeaponGlobal.MaterialType.Weapon then
                    return data.stcId == self.mData.stc_id
                elseif data.type == UIWeaponGlobal.MaterialType.Item then
                    return data.isBreakItem
                end
            end
        end
    end
    return true
end

function UIWeaponEnhanceContent:OnClickItem(item)
    if self:GetSelectMaterialCount() >= UIWeaponGlobal.MaxMaterialCount then
        if self:IsInSelectList(item.mData) == nil then
            UIUtils.PopupHintMessage(40010)
            return
        else
            if item:IsRemoveWeapon() then
                item:SetSelect()
                self:UpdateSelectList(item.mData)
                return
            else
                return
            end
        end
    end

    if self.needBreak and self.targetLevel < self.mData.MaxBreakMaxLv then
        if self:IsInSelectList(item.mData) == nil then
            UIUtils.PopupHintMessage(30021)
            return
        else
            if item:IsRemoveWeapon() then
                item:SetSelect()
                self:UpdateSelectList(item.mData)
                return
            else
                UIUtils.PopupHintMessage(30021)
                return
            end
        end
    else
        if self.targetLevel < self.curMaxLv then
            item:SetSelect()
        else
            if item:IsRemoveWeapon() then
                item:SetSelect()
            else
                UIUtils.PopupHintMessage(30020)
                return
            end
        end
    end

    if item.mData.selectCount > 0 then
        self:UpdateItemBrief(item.mData.id, item.mData.type)
    else
        self:CloseItemBrief()
    end

    self:UpdateSelectList(item.mData)
end

function UIWeaponEnhanceContent:OnClickReduce(item)
    item:OnReduce()
    self:UpdateSelectList(item.mData)
end

function UIWeaponEnhanceContent:IsInSelectList(itemData)
    for _, item in ipairs(self.selectMaterial) do
        if itemData.type == item.type and itemData.id == item.id then
            return item
        end
    end
    return nil
end

function UIWeaponEnhanceContent:GetSelectMaterialCount()
    local count = 0
    for _, item in ipairs(self.selectMaterial) do
        count = count + item.selectCount
    end
    return count
end

function UIWeaponEnhanceContent:UpdateSelectList(itemData)
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

function UIWeaponEnhanceContent:UpdateSelectListView()
    for _, item in ipairs(self.selectItemList) do
        item:SetData(nil)
    end

    local addExp = 0
    local costCoin = 0
    local addLevel = 0
    local count = 1
    local item = nil
    for i = 1, #self.selectMaterial do
        local data = self.selectMaterial[i]
        if data.selectCount > 1 then
            for j = 1, data.selectCount do
                if count <= #self.selectItemList then
                    item = self.selectItemList[count]
                else
                    item = UIWeaponMaterialItemS.New()
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
                item = UIWeaponMaterialItemS.New()
                item:InitCtrl(self.mView.mTrans_MaterialList)
                table.insert(self.selectItemList, item)
            end
            item:SetData(data)
            count = count + 1

            UIUtils.GetButtonListener(item.mBtn_Item.gameObject).onClick = function()
                self:InvertSelectionItem(data)
            end
        end

        if data.type == UIWeaponGlobal.MaterialType.Item then
            if data.isBreakItem then
                addLevel = addLevel + self.breakLevel * data.selectCount
            end
        elseif data.type == UIWeaponGlobal.MaterialType.Weapon then
            if data.stcId == self.mData.stc_id then
                addLevel = addLevel + self.breakLevel
            end
        end

        addExp = addExp + data.offerExp * data.selectCount
        costCoin = costCoin + data.costCoin * data.selectCount
    end

    self.isCoinEnough = GlobalData.cash >= costCoin
    self.mView.mText_CostCoin.text = costCoin
    self.mView.mText_CostCoin.color = self.isCoinEnough and ColorUtils.BlackColor or ColorUtils.RedColor
    self:UpdateLevelUpInfo(addExp, addLevel)
end

function UIWeaponEnhanceContent:InvertSelectionItem(item)
    item.selectCount = item.selectCount - 1
    self:UpdateSelectList(item)
    self.mView.mVirtualList:Refresh()
end

function UIWeaponEnhanceContent:UpdateLevelUpInfo(exp, addLevel)
    self.targetLevel = math.min(self:CalculateLevel(self.mData.CurExp + exp + self.dicLevelExp[self.mData.Level]), self.targetMaxLv)
    self.targetMaxLv = math.min(self.curMaxLv + addLevel, self.mData.MaxBreakMaxLv)
    self.needBreak = self.targetLevel >= self.curMaxLv
    if self.needBreak then
        self.targetLevel = self.curMaxLv
        self.totalExp = self.dicLevelExp[self.curMaxLv]
    else

        self.totalExp = self.dicLevelExp[self.mData.Level] + self.mData.CurExp + exp
    end

    self:UpdateWeaponInfo(exp)
end

function UIWeaponEnhanceContent:CalculateLevel(exp)
    for i = 1, TableData.listGunWeaponExpDatas.Count - 1 do
        local data = TableData.listGunWeaponExpDatas[i]
        local needExp = self.dicLevelExp[data.level]
        local lastExp = self.dicLevelExp[data.level - 1]
        if lastExp <= exp and exp < needExp then
            return data.level - 1
        end
    end
    return TableData.listGunWeaponExpDatas[TableData.listGunWeaponExpDatas.Count - 1].level
end

function UIWeaponEnhanceContent:UpdatePanel()
    local typeData = TableData.listGunWeaponTypeDatas:GetDataById(self.mData.Type)
    self.mView.mText_Name.text = self.mData.Name
    self.mView.mText_Type.text = typeData.name.str
    self.targetLevel = self.mData.Level
    self.targetMaxLv = self.mData.CurMaxLv
    self.curMaxLv = self.mData.CurMaxLv
    self.totalExp = self.dicLevelExp[self.mData.Level]
    self.needBreak = self.mData.Level >= self.mData.CurMaxLv
    self.recordLv = self.mData.Level
    self.recordExp = self.mData.CurExp
    self:UpdateStar(self.mData.BreakTimes, self.mData.MaxBreakTime)
    self.selectMaterial = {}
    if self.mData.Level < self.mData.MaxBreakMaxLv then
        local nextLevel = self.mData.Level + 1
        local exp = self.mData:GetWeaponCurNeedExpByLv(nextLevel)
        self.nextLevelExp = exp
    else
        self.nextLevelExp = 0
    end

    self:UpdateSelectListView()
    self:UpdateWeaponInfo(0)
    self:UpdatePropertyList()
    self:UpdateIsMaxLevel()
    setactive(self.mView.mTrans_AutoSelect, true)
end

function UIWeaponEnhanceContent:ResetWeaponList()
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
    self.isLevelUpMode = false
end

function UIWeaponEnhanceContent:UpdateStar(star, maxStar)
    self.mView.stageItem:ResetMaxNum(maxStar)
    self.mView.stageItem:SetData(star)
end

function UIWeaponEnhanceContent:UpdateSkill(skill1)
    local skill = self.mView.skillItem
    if skill1 then
        skill.data = skill1
        skill.txtName.text = skill1.name.str
        skill.txtLv.text = GlobalConfig.LVText .. skill1.level
        skill.txtDesc.text = skill1.description.str
    else
        skill.data = nil
        setactive(skill.obj, false)
    end
end

function UIWeaponEnhanceContent:UpdatePropertyList()
    local attrList = {}

    local expandList = TableData.GetPropertyExpandList()
    for i = 0, expandList.Count - 1 do
        local lanData = expandList[i]
        if(lanData.type == 1) then
            local value = self.mData:GetPropertyByLevelAndSysName(lanData.sys_name, self.mData.CurLv, self.mData.BreakTimes, false)
            if self.targetLevel >= self.mData.MaxBreakMaxLv then
                if(value > 0) then
                    local attr = {}
                    attr.propData = lanData
                    attr.value = value
                    table.insert(attrList, attr)
                end
            else
                if(value > 0) and lanData.statue == 1 then
                    local attr = {}
                    attr.propData = lanData
                    attr.value = value
                    table.insert(attrList, attr)
                end
            end
        end
    end

    table.sort(attrList, function (a, b) return a.propData.order < b.propData.order end)

    for _, item in ipairs(self.propertyList) do
        item:SetData(nil)
    end

    for i = 1, #attrList do
        local item = nil
        if i <= #self.propertyList then
            item = self.propertyList[i]
        else
            item = UICommonPropertyItem.New()
            item:InitCtrl(self.mView.mTrans_PropList)
            table.insert(self.propertyList, item)
        end
        item:SetData(attrList[i].propData, attrList[i].value, true, false, false, false)
        item:SetTextColor(attrList[i].propData.statue == 2 and ColorUtils.OrangeColor or ColorUtils.BlackColor)
    end
end

function UIWeaponEnhanceContent:OnClickEnhance()
    if self.isLevelUpMode then
        return
    end
    self.isLevelUpMode = true
    self:UpdateEnhanceList()
    setactive(self.mView.mTrans_EnhanceContent, true)
end

function UIWeaponEnhanceContent:CloseEnhance()
    if self.mView.mListAniTime and self.mView.mListAnimator then
        self.mView.mListAnimator:SetTrigger("Fadeout")
        self:DelayCall(self.mView.mListAniTime.m_FadeOutTime, function ()
            self.isLevelUpMode = false
            self:UpdatePanel()
            setactive(self.mView.mTrans_EnhanceContent, false)
        end)
    else
        self.isLevelUpMode = false
        self:UpdatePanel()
        setactive(self.mView.mTrans_EnhanceContent, false)
    end
end

function UIWeaponEnhanceContent:UpdateEnhanceList()
    local list = NetCmdWeaponData:GetEnhanceWeaponList(self.mData.id)
    self.materialsList = self:UpdateMaterialList(list)

    self:OnClickSort(UIWeaponGlobal.MaterialSortType.Rank)

    setactive(self.mView.mTrans_Empty, #self.materialsList <= 0)
end

function UIWeaponEnhanceContent:UpdateListBySort()
    local sortFunc = self.sortContent.sortFunc
    table.sort(self.materialsList, sortFunc)

    self.mView.mVirtualList.numItems = #self.materialsList
    self.mView.mVirtualList:Refresh()
end

function UIWeaponEnhanceContent:UpdateMaterialList(list)
    if list then
        self.itemList = {}
        self.weaponList = {}
        local itemList = {}

        --- 先走item
        for i = 0, self.itemIdList.Count - 1 do
            local id = self.itemIdList[i]
            local data = UIWeaponGlobal:GetMaterialSimpleData(id, UIWeaponGlobal.MaterialType.Item)
            if data then
                data.isBreakItem = (id == self.breakItem)
                table.insert(itemList, data)
                table.insert(self.itemList, data)
            end
        end

        for i = 0, list.Count - 1 do
            local data = UIWeaponGlobal:GetMaterialSimpleData(list[i], UIWeaponGlobal.MaterialType.Weapon)
            table.insert(itemList, data)
            if data.level == 0 and data.rank <= self.weaponLowRank then
                table.insert(self.weaponList, data)
            end
        end

        return itemList
    end
end

function UIWeaponEnhanceContent:UpdateWeaponInfo(exp)
    local maxExp = 0
    local curExp = 0
    local sliderBeforeValue = 0
    local sliderAfterValue = 0
    local maxLevel = self.curMaxLv
    local levelUp = self.targetMaxLv - self.curMaxLv
    local curExpData = self.dicLevelExp[self.mData.Level]
    local targetExpData = self.dicLevelExp[self.targetLevel]
    --if levelUp > 0 then
    --     self.mView.mText_LevelUp.text = string_format(TableData.GetHintById(40007),  levelUp)
    --end
    -- setactive(self.mView.mText_LevelUp.gameObject, levelUp > 0)

    if self.mData.CurExp + exp >= self.nextLevelExp then
        local nextLevel = (self.targetLevel >= maxLevel) and maxLevel or (self.targetLevel + 1)
        maxExp = self.mData:GetWeaponCurNeedExpByLv(nextLevel)
        if self.targetLevel >= maxLevel then
            curExp = maxExp
        else
            curExp = curExpData + self.mData.CurExp + exp - targetExpData
        end

        sliderBeforeValue = self.mData.Level >= maxLevel and 1 or 0
        sliderAfterValue = curExp / maxExp
    else
        maxExp = self.nextLevelExp
        if self.targetLevel >= maxLevel then
            curExp = maxExp
            sliderBeforeValue = 1
            sliderAfterValue = 1
        else
            curExp = self.mData.CurExp + exp
            sliderBeforeValue = self.mData.CurExp / self.nextLevelExp
            sliderAfterValue = (self.mData.CurExp + exp) / self.nextLevelExp
        end
    end

    self.mView.mText_Exp.text = string_format("{0}/{1}", curExp, maxExp)
    self.mView.mText_LevelNow.text = self.targetLevel
    self.mView.mText_LevelMax.text = "/" .. self.curMaxLv
    self.mView.mText_AddExp.text = "+" .. exp
    self.mView.mImage_ExpAfter.fillAmount = sliderAfterValue
    self.mView.mImage_ExpBefore.fillAmount = sliderBeforeValue
    self.canLevelUp = exp > 0

    self:UpdatePropChangeValue()
    setactive(self.mView.mTrans_ExpAdd, exp > 0)
end


function UIWeaponEnhanceContent:UpdatePropChangeValue()
    for _, item in ipairs(self.propertyList) do
        local value = 0
        if self.targetLevel ~= self.mData.CurLv then
            local propName = item.mData.sys_name
            value = self.mData:GetPropertyByLevelAndSysName(propName, self.targetLevel, self.mData.BreakTimes, false)
        end
        item:SetValueUp(value)
    end
end

function UIWeaponEnhanceContent:OnClickLevelUp()
    if not self.isCoinEnough then
        UIUtils.PopupHintMessage(40005)
        return
    end
    if not self.canLevelUp then
        UIUtils.PopupHintMessage(40019)
        return
    end
    local itemList, weaponList = self:GetMaterialList()
    self.recordLv = self.mData.Level
    self.recordExp = self.mData.CurExp
    NetCmdWeaponData:SendGunWeaponLvUp(self.mData.id, weaponList, itemList, function (ret) self:LevelUpCallback(ret) end)
end

function UIWeaponEnhanceContent:LevelUpCallback(ret)
    if ret == CS.CMDRet.eSuccess then
        gfdebug("强化武器成功")
        if self.recordLv < self.targetLevel or self.targetMaxLv - self.curMaxLv > 0 then
            self:OpenLevelUpPanel()

            self.mData = NetCmdWeaponData:GetWeaponById(self.mData.id)
            self:UpdatePanel()
            self:UpdateEnhanceList()
            if self.needBreak and self.mData.Level < self.mData.MaxBreakMaxLv then
                self.weaponPanel:RefreshPanel()
            end
        else
            setactive(self.mView.mTrans_Mask, true)
            local start = self.mData.Level + self.recordExp / self.nextLevelExp
            local endLv = self.mData.Level + self.mData.CurExp / self.nextLevelExp
            CS.ProgressBarAnimationHelper.Play(self.mView.mImage_ExpBefore, start, endLv,0.5, nil, function ()
                self.mData = NetCmdWeaponData:GetWeaponById(self.mData.id)
                self:UpdatePanel()
                self:UpdateEnhanceList()
                if self.needBreak and self.mData.Level < self.mData.MaxBreakMaxLv then
                    self.weaponPanel:RefreshPanel()
                end
                setactive(self.mView.mTrans_Mask, false)
            end)
        end
    end
end

function UIWeaponEnhanceContent:OpenLevelUpPanel()
    local lvUpData = CommonLvUpData.New(self.recordLv, self.targetLevel, 102103)
    lvUpData:SetWeaponLvUpData(self.propertyList)
    UIManager.OpenUIByParam(UIDef.UICommonLvUpPanel, lvUpData)
end

function UIWeaponEnhanceContent:GetMaterialList()
    local itemList = {}
    local weaponList = {}
    for _, item in ipairs(self.selectMaterial) do
        if item.type == UIWeaponGlobal.MaterialType.Item then
            itemList[item.id] = item.selectCount
        elseif item.type == UIWeaponGlobal.MaterialType.Weapon then
            table.insert(weaponList, item.id)
        end
    end
    return itemList, weaponList
end

function UIWeaponEnhanceContent:InitLevelToExpDic()
    local exp = 0
    for i = 0, self.mData.MaxBreakMaxLv do
        local expData = TableData.listGunWeaponExpDatas:GetDataById(i)
        self.dicLevelExp[i] = math.ceil(exp + expData.weapon_exp * self.mData.StcData.ExpRate / 1000)
        exp = self.dicLevelExp[i]
    end
end

function UIWeaponEnhanceContent:UpdateItemBrief(id, type)
    if self.itemBrief == nil then
        self.itemBrief = UIBarrackBriefItem.New()
        self.itemBrief:InitCtrl(self.mView.mTrans_ItemBrief)

        self.itemBrief:EnableLock(false)
        self.itemBrief:EnableButtonGroup(false)
    end
    self.pointer.isInSelf = true
    if type == UIWeaponGlobal.MaterialType.Item then
        self.itemBrief:SetData(UIBarrackBriefItem.ShowType.Item, id)
    elseif type == UIWeaponGlobal.MaterialType.Weapon then
        self.itemBrief:SetData(UIBarrackBriefItem.ShowType.Weapon, id)
    end
end

function UIWeaponEnhanceContent:CloseItemBrief()
    if self.itemBrief ~= nil then
        self.itemBrief:SetData(nil)
    end
end

function UIWeaponEnhanceContent:UpdateIsMaxLevel()
    local isMax = self.targetLevel >= self.mData.MaxBreakMaxLv
    setactive(self.mView.mTrans_CostHint, not isMax)
    setactive(self.mView.mTrans_CostItemList, not isMax)
    setactive(self.mView.mTrans_CostCoin, not isMax)
    setactive(self.mView.mTrans_BtnLevelUp, not isMax)
    setactive(self.mView.mTrans_MaxLevel, isMax)
    setactive(self.mView.mTrans_SkillList, isMax)
    if isMax then
        self:UpdateSkill(self.mData.Skill)
    end

end

function UIWeaponEnhanceContent:OnClickSort(type)
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
        self.weaponListContent:CloseItemSort()
    end
end

function UIWeaponEnhanceContent:OnClickAscend()
    if self.curSort then
        self.curSort.isAscend = not self.curSort.isAscend
        self.sortContent:SetData(self.curSort)

        self:UpdateListBySort()
    end
end

function UIWeaponEnhanceContent:AutoSelect()
    if self.targetLevel >= self.curMaxLv or self:GetSelectMaterialCount() >= UIWeaponGlobal.MaxMaterialCount then
        return
    end
    local isLowRank = (self.mData.Rank <= self.weaponLowRank) and (self.curMaxLv < self.mData.MaxBreakMaxLv)
    local maxLevelExp = self.dicLevelExp[self.curMaxLv]
    local needExp = maxLevelExp - self.totalExp

    table.sort(self.itemList, function (a, b) return a.offerExp > b.offerExp end)
    for i, item in ipairs(self.itemList) do
        if self:GetSelectMaterialCount() >= UIWeaponGlobal.MaxMaterialCount or item.isBreakItem or needExp <= 0 then
            break
        end

        local lastCount = UIWeaponGlobal.MaxMaterialCount - self:GetSelectMaterialCount()
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
                selectCount = math.min(selectCount, UIWeaponGlobal.MaxMaterialCount - self:GetSelectMaterialCount())
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

    if needExp > 0 and self:GetSelectMaterialCount() < UIWeaponGlobal.MaxMaterialCount and isLowRank then    --- 低等级的先拎出来
        local lowRankList = {}
        for _, item in ipairs(self.weaponList) do
            if item.stcId == self.mData.stc_id then
                table.insert(lowRankList, item)
            end
        end
        table.sort(lowRankList, function (a, b) return a.id < b.id end)
        for _, item in ipairs(lowRankList) do
            if self:GetSelectMaterialCount() >= UIWeaponGlobal.MaxMaterialCount or needExp <= 0 then
                break
            end
            if item.selectCount <= 0 then
                item.selectCount = 1
                table.insert(self.selectMaterial, item)
                needExp = needExp - item.offerExp
            end
        end
    end

    if needExp > 0 and self:GetSelectMaterialCount() < UIWeaponGlobal.MaxMaterialCount then
        table.sort(self.weaponList, function (a, b)
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

        for _, item in ipairs(self.weaponList) do
            if self:GetSelectMaterialCount() >= UIWeaponGlobal.MaxMaterialCount or needExp <= 0 then
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