require("UI.UIBasePanel")
require("UI.WeaponPanel.UIWeaponPanelView")

UIWeaponBreakContent = class("UIWeaponBreakContent", UIBasePanel)
UIWeaponBreakContent.__index = UIWeaponBreakContent

function UIWeaponBreakContent:ctor(data, weaponPanel)
    self.mView = nil
    self.mData = data
    self.weaponPanel = weaponPanel
    self.breakItem = TableData.GlobalSystemData.WeaponLevelBreakItem
    self.breakLevel = TableData.GlobalSystemData.WeaponLevelPerBreak
    self.weaponLowRank = TableData.GlobalSystemData.WeaponLowRank

    self.materialsList = {}
    self.itemList = {}
    self.selectMaterial = {}
    self.selectItemList = {}
    self.isLevelUpMode = false
    self.needBreak = false
    self.propertyList = {}
    self.itemBrief = nil
    self.recordLv = 0

    self.sortContent = nil
    self.sortList = {}
    self.curSort = nil
end

function UIWeaponBreakContent:InitCtrl(root, weaponList)
    self.mView = UIWeaponBreakContentView.New()
    self.mView:InitCtrl(root, weaponList)
    self.weaponListContent = weaponList
    self.sortContent = weaponList.sortContent
    self.sortList = weaponList.sortList

    for _, btn in ipairs(self.mView.addBtnList) do
        UIUtils.GetButtonListener(btn.gameObject).onClick = function()
            self:OnClickBreak()
        end
    end

    UIUtils.GetButtonListener(self.mView.mBtn_LevelUp.gameObject).onClick = function()
        self:OnClickLevelUp()
    end

    self.isLevelUpMode = false
end

function UIWeaponBreakContent:OnRelease()
    self:ReleaseTimers()
end

function UIWeaponBreakContent:InitSortContent()
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

function UIWeaponBreakContent:InitVirtualList()
    self.mView.mVirtualList.itemProvider = function()
        local item = self:MaterialItemProvider()
        return item
    end

    self.mView.mVirtualList.itemRenderer = function(index, rendererData)
        self:MaterialItemRenderer(index, rendererData)
    end
end

function UIWeaponBreakContent:MaterialItemProvider()
    local itemView = UIWeaponMaterialItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIWeaponBreakContent:MaterialItemRenderer(index, rendererData)
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

function UIWeaponBreakContent:CheckCanSelectWeapon(data)
    if self:GetSelectMaterialCount() >= UIWeaponGlobal.MaxBreakCount then
        return false
    end
    return true
end

function UIWeaponBreakContent:OnClickItem(item)
    if self:GetSelectMaterialCount() >= UIWeaponGlobal.MaxBreakCount then
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

    if self.needBreak then
        if item:IsBreakItem(self.mData.stc_id) then
            item:SetSelect()
        else
            UIUtils.PopupHintMessage(30021)
            return
        end
    end

    if item.mData.selectCount > 0 then
        self:UpdateItemBrief(item.mData.id, item.mData.type)
    else
        self:CloseItemBrief()
    end

    self:UpdateSelectList(item.mData)
end

function UIWeaponBreakContent:OnClickReduce(item)
    item:OnReduce()
    self:UpdateSelectList(item.mData)
end

function UIWeaponBreakContent:IsInSelectList(itemData)
    for _, item in ipairs(self.selectMaterial) do
        if itemData.type == item.type and itemData.id == item.id then
            return item
        end
    end
    return nil
end

function UIWeaponBreakContent:GetSelectMaterialCount()
    local count = 0
    for _, item in ipairs(self.selectMaterial) do
        count = count + item.selectCount
    end
    return count
end

function UIWeaponBreakContent:UpdateSelectList(itemData)
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

function UIWeaponBreakContent:UpdateSelectListView()
    for _, item in ipairs(self.selectItemList) do
        item:SetData(nil)
    end

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
    end
end

function UIWeaponBreakContent:InvertSelectionItem(item)
    item.selectCount = item.selectCount - 1
    self:UpdateSelectList(item)
    self.mView.mVirtualList:Refresh()
end

function UIWeaponBreakContent:UpdatePanel()
    local typeData = TableData.listGunWeaponTypeDatas:GetDataById(self.mData.Type)
    self.mView.mText_Name.text = self.mData.Name
    self.mView.mText_Level.text = self.mData.Level
    self.mView.mText_Type.text = typeData.name.str
    self.mView.mText_LevelUp.text = string_format(TableData.GetHintById(40007),  self.breakLevel)
    self.needBreak = self.mData.Level >= self.mData.CurMaxLv
    self.selectMaterial = {}

    self:UpdateSelectListView()
    self:UpdateSkill(self.mData.Skill, self.mData.NextSkill)
    self:UpdatePropertyList()
    self:UpdateWeaponInfo()
    self:UpdateStar(self.mData.BreakTimes, self.mData.MaxBreakTime)
    setactive(self.mView.mTrans_AutoSelect, false)
end

function UIWeaponBreakContent:ResetWeaponList()
    UIUtils.GetButtonListener(self.mView.mBtn_CloseList.gameObject).onClick = function()
        self:CloseBreak()
    end

    self.pointer = UIUtils.GetPointerClickHelper(self.mView.mTrans_ItemBrief.gameObject, function()
        self:CloseItemBrief()
    end, self.mView.mTrans_ItemBrief.gameObject)

    self:InitVirtualList()
    self:InitSortContent()
    self.isLevelUpMode = false
end

function UIWeaponBreakContent:UpdateStar(star, maxStar)
    self.mView.stageItem:ResetMaxNum(maxStar)
    self.mView.stageItem:SetData(star)
end

function UIWeaponBreakContent:UpdateSkill(skill1, skill2)
    if skill2 == nil then
        for i = 1, 2 do
            local skill = self.mView.skillList[i]
            skill.data = nil
            setactive(skill.obj, false)
        end
        return
    end

    local skill = self.mView.skillList[1]
    if skill1 then
        skill.data = skill1
        skill.txtName.text = skill1.name.str
        skill.txtLv.text = GlobalConfig.LVText .. skill1.level
        skill.txtDesc.text = skill1.description.str
    else
        skill.data = nil
        setactive(skill.obj, false)
    end

    skill = self.mView.skillList[2]
    if skill2 then
        skill.data = skill2
        skill.txtName.text = skill2.name.str
        skill.txtLv.text = GlobalConfig.LVText .. skill2.level
        skill.txtDesc.text = skill2.description.str
    else
        skill.data = nil
        setactive(skill.obj, false)
    end
end

function UIWeaponBreakContent:UpdatePropertyList()
    local attrList = {}

    local nextBreak = math.min(self.mData.BreakTimes + 1, self.mData.MaxBreakTime)
    local expandList = self.mData:GetBreakUpProp(nextBreak)
    for i = 0, expandList.Count - 1 do
        local lanData =TableData.GetPropertyDataByName(expandList[i], 1)
        if(lanData.type == 1) then
            local value = self.mData:GetPropertyByLevelAndSysName(lanData.sys_name, self.mData.Level, self.mData.BreakTimes, false)
            local attr = {}
            attr.propData = lanData
            attr.value = value
            table.insert(attrList, attr)
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
    end
end

function UIWeaponBreakContent:OnClickBreak()
    if self.isLevelUpMode then
        return
    end
    self.isLevelUpMode = true
    self:UpdateEnhanceList()
    setactive(self.mView.mTrans_EnhanceContent, true)
end

function UIWeaponBreakContent:CloseBreak()
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

function UIWeaponBreakContent:UpdateEnhanceList()
    local list = NetCmdWeaponData:GetBreakWeaponList(self.mData.id)
    self.materialsList = self:UpdateMaterialList(list)

    self:OnClickSort(UIWeaponGlobal.MaterialSortType.Rank)

    setactive(self.mView.mTrans_Empty, #self.materialsList <= 0)
end

function UIWeaponBreakContent:UpdateListBySort()
    local sortFunc = self.sortContent.sortFunc
    table.sort(self.materialsList, sortFunc)

    self.mView.mVirtualList.numItems = #self.materialsList
    self.mView.mVirtualList:Refresh()
end

function UIWeaponBreakContent:UpdateMaterialList(list)
    if list then
        self.itemList = {}
        self.weaponList = {}
        local itemList = {}

        --- 先走item
        local data = UIWeaponGlobal:GetMaterialSimpleData(self.breakItem, UIWeaponGlobal.MaterialType.Item)
        if data then
            data.isBreakItem = true
            table.insert(itemList, data)
            table.insert(self.itemList, data)
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

function UIWeaponBreakContent:UpdateWeaponInfo()
    self:UpdatePropChangeValue()
end

function UIWeaponBreakContent:UpdatePropChangeValue()
    for _, item in ipairs(self.propertyList) do
        local value = 0
        local propName = item.mData.sys_name
        local nextBreak = math.min(self.mData.BreakTimes + 1, self.mData.MaxBreakTime)
        value = self.mData:GetPropertyByLevelAndSysName(propName, self.mData.Level, nextBreak, false)
        item:SetValueUp(value)
    end
end

function UIWeaponBreakContent:OnClickLevelUp()
    local itemList, weaponList = self:GetMaterialList()
    if #weaponList >= 1 then
        NetCmdWeaponData:SendGunWeaponBreak(self.mData.id, weaponList[1], function (ret) self:LevelUpCallback(ret) end)
    else
        UIUtils.PopupHintMessage(40019)
        return
    end
end

function UIWeaponBreakContent:LevelUpCallback(ret)
    if ret == CS.CMDRet.eSuccess then
        UIManager.OpenUIByParam(UIDef.UICommonBreakSucPanel)

        self.mData = NetCmdWeaponData:GetWeaponById(self.mData.id)
        self:UpdatePanel()
        self:UpdateEnhanceList()
        self.weaponPanel:RefreshPanel()
    end
end

function UIWeaponBreakContent:GetMaterialList()
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

function UIWeaponBreakContent:UpdateItemBrief(id, type)
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

function UIWeaponBreakContent:CloseItemBrief()
    if self.itemBrief ~= nil then
        self.itemBrief:SetData(nil)
    end
end

function UIWeaponBreakContent:OnClickSort(type)
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

function UIWeaponBreakContent:OnClickAscend()
    if self.curSort then
        self.curSort.isAscend = not self.curSort.isAscend
        self.sortContent:SetData(self.curSort)

        self:UpdateListBySort()
    end
end