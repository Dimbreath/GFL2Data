UIWeaponPartsReplaceContent = class("UIWeaponPartsReplaceContent", UIBaseCtrl)
UIWeaponPartsReplaceContent.__index = UIWeaponPartsReplaceContent

function UIWeaponPartsReplaceContent:ctor()
    UIWeaponPartsReplaceContent.super.ctor(self)
    self.partData = nil
    self.type = 0
    self.weaponData = 0
    self.partDetail = nil
    self.compareDetail = nil
    self.weaponPartsList = {}
    self.curContent = 0
    self.isCompareMode = false
    self.curReplacePart = nil
    self.sortContent = nil
    self.sortList = {}
    self.curSort = nil
    self.weaponPartContent = nil

    self.replaceCallback = nil
    self.lockCallback = nil
    self.closeCallback = nil
    self.clickPartCallback = nil
end

function UIWeaponPartsReplaceContent:InitCtrl(parent, parentObj)
    self.mParentObj = parentObj
    local obj = instantiate(UIUtils.GetGizmosPrefab("Character/ChrWeaponPartsDetailsItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIWeaponPartsReplaceContent:__InitCtrl()
    self.mBtn_Back = UIUtils.GetTempBtn(self:GetRectTransform("Trans_GrpWeaponPartsList/Content/GrpClose/BtnBack"))
    self.mBtn_Equip = UIUtils.GetTempBtn(self:GetRectTransform("GrpWeaponPartsInfo/GrpAction/Trans_BtnEquipe"))
    self.mBtn_Replace = UIUtils.GetTempBtn(self:GetRectTransform("GrpWeaponPartsInfo/GrpAction/Trans_BtnReplace"))
    self.mBtn_Enhance = UIUtils.GetTempBtn(self:GetRectTransform("GrpWeaponPartsInfo/GrpAction/Trans_BtnPowerUp"))
    self.mBtn_Uninstall = UIUtils.GetTempBtn(self:GetRectTransform("GrpWeaponPartsInfo/GrpAction/Trans_BtnUninstall"))
    self.mToggle_DetailCompare = self:GetGFToggle("GrpWeaponPartsInfo/Trans_BtnContrast/Btn_Contrast")

    self.mTrans_Compare = self:GetRectTransform("GrpWeaponPartsInfo/Trans_BtnContrast")
    self.mTrans_WeaponPartDetail = self:GetRectTransform("GrpWeaponPartsInfo")
    self.mTrans_CompareDetail = self:GetRectTransform("GrpWeaponPartsInfo/Trans_GrpWeaponPartsInfo")
    self.mTrans_Uninstall = self:GetRectTransform("GrpWeaponPartsInfo/GrpAction/Trans_BtnUninstall")
    self.mTrans_ReplaceBtn = self:GetRectTransform("GrpWeaponPartsInfo/GrpAction/Trans_BtnReplace")
    self.mTrans_EquipBtn = self:GetRectTransform("GrpWeaponPartsInfo/GrpAction/Trans_BtnEquipe")

    self.mTrans_Replace = self:GetRectTransform("Trans_GrpWeaponPartsList")
    self.mTrans_ReplaceScroll = self:GetRectTransform("Trans_GrpWeaponPartsList/Content/Trans_GrpWeaponPartsList")
    self.mTrans_Empty = self:GetRectTransform("Trans_GrpWeaponPartsList/Content/Trans_GrpEmpty")

    self.mText_WeaponPartType = self:GetText("Trans_GrpWeaponPartsList/Content/GrpTextTittle/Text_Name")

    self.mTrans_Sort = self:GetRectTransform("Trans_GrpWeaponPartsList/Content/GrpAction/GrpScreen/BtnScreen")
    self.mTrans_SortList = self:GetRectTransform("Trans_GrpWeaponPartsList/Content/GrpAction/GrpScreen/Trans_GrpScreenList")

    self.mTrans_Enhance = self:GetRectTransform("GrpWeaponPartsInfo/GrpAction/Trans_BtnPowerUp")
    self.mTrans_MaxLevel = self:GetRectTransform("GrpWeaponPartsInfo/GrpAction/Trans_TextMax")
    self.mTrans_CantEnhance = self:GetRectTransform("GrpWeaponPartsInfo/GrpAction/Trans_TextCantPowerUp")

    self.ReplaceVirtual = UIUtils.GetVirtualList(self.mTrans_ReplaceScroll)
    self.mListAnimator = UIUtils.GetAnimator(self.mUIRoot)
    self.mListAniTime = UIUtils.GetAnimatorTime(self.mUIRoot)
    self.fadeManager = self:GetRectTransform("Trans_GrpWeaponPartsList/Content/Trans_GrpWeaponPartsList/Viewport/Content"):GetComponent("MonoScrollerFadeManager")

    self.partDetail = UIBarrackWeaponPartInfoItem.New()
    self.partDetail:InitCtrl(self.mTrans_WeaponPartDetail, function (id, isLock)
        self:UpdateWeaponPartLock(id, isLock)
    end)

    self.compareDetail = UIBarrackBriefItem.New()
    self.compareDetail:InitCtrl(self.mTrans_CompareDetail, function (id, isLock)
        self:UpdateWeaponPartLock(id, isLock)
    end)

    self.compareDetail:EnableCurrentWeapon(true)
    self.compareDetail:EnableLock(true)

    UIUtils.GetButtonListener(self.mBtn_Enhance.gameObject).onClick = function()
        self:OnClickEnhance()
    end

    UIUtils.GetButtonListener(self.mBtn_Equip.gameObject).onClick = function()
        self:OnClickReplace()
    end

    UIUtils.GetButtonListener(self.mBtn_Replace.gameObject).onClick = function()
        self:OnClickReplace()
    end

    UIUtils.GetButtonListener(self.mBtn_Uninstall.gameObject).onClick = function()
        self:OnClickUninstall()
    end

    UIUtils.GetButtonListener(self.mBtn_Back.gameObject).onClick = function()
        self:CloseContent()
    end

    self.mToggle_DetailCompare.onValueChanged:AddListener(function (isOn)
        self:OnClickCompare()
    end)

    self:InitVirtualList()
    self:InitSortContent()
end

function UIWeaponPartsReplaceContent:SetData(data, type, weaponId)
    self.partData = nil
    self.type = nil
    self.curReplacePart = nil
    self.weaponData = NetCmdWeaponData:GetWeaponById(weaponId)
    if data then
        self.partData = NetCmdWeaponPartsData:GetWeaponPartById(data.id)
        self.type = self.partData.type
        self:UpdateReplaceList()
    else
        if type then
            self.type = type
            self:UpdateReplaceList()
            if #self.weaponPartsList > 0 then
                if self.curReplacePart == nil then
                    self.curReplacePart = self.weaponPartsList[1]
                    self.curReplacePart.isSelect = true
                    if self.clickPartCallback then
                        self.clickPartCallback(self.curReplacePart.id)
                    end
                end
            end
        end
    end
    if self.curReplacePart then
        self:UpdateReplaceDetail(self.curReplacePart.id)
    else
        self:UpdateReplaceDetail(nil)
    end

    self:UpdateButton()
    self:UpdateCompareDetail()
    self:UpdateWeaponPartType()
    setactive(self.mUIRoot, true)
    setactive(self.mTrans_Empty, #self.weaponPartsList <= 0)
end

function UIWeaponPartsReplaceContent:SetReplaceCallback(callback)
    self.replaceCallback = callback
end

function UIWeaponPartsReplaceContent:SetLockCallback(callback)
    self.lockCallback = callback
end

function UIWeaponPartsReplaceContent:SetCloseCallback(callback)
    self.closeCallback = callback
end

function UIWeaponPartsReplaceContent:SetClickPartCallback(callback)
    self.clickPartCallback = callback
end

function UIWeaponPartsReplaceContent:InitVirtualList()
    self.ReplaceVirtual.itemProvider = function()
        local item = self:PartItemProvider()
        return item
    end

    self.ReplaceVirtual.itemRenderer = function(index, rendererData)
        self:PartItemRenderer(index, rendererData)
    end
end

function UIWeaponPartsReplaceContent:InitSortContent()
    if self.sortContent == nil then
        self.sortContent = UIWeaponPartSortItem.New()
        self.sortContent:InitCtrl(self.mTrans_Sort)

        UIUtils.GetButtonListener(self.sortContent.mBtn_Sort.gameObject).onClick = function()
            self:OnClickSortList()
        end

        UIUtils.GetButtonListener(self.sortContent.mBtn_Ascend.gameObject).onClick = function()
            self:OnClickAscend()
        end
    end

    local sortList = self:InstanceUIPrefab("UICommonFramework/ComScreenDropdownListItemV2.prefab", self.mTrans_SortList)
    local parent = UIUtils.GetRectTransform(sortList, "Content")
    for i = 1, 4 do
        local obj = self:InstanceUIPrefab("Character/ChrEquipSuitDropdownItemV2.prefab", parent)
        if obj then
            local sort = {}
            sort.obj = obj
            sort.btnSort = UIUtils.GetButton(obj)
            sort.txtName = UIUtils.GetText(obj, "GrpText/Text_SuitName")
            sort.sortType = i
            sort.hintID = 101000 + i
            sort.sortCfg = UIWeaponGlobal.WeaponPartsSortCfg[i]
            sort.isAscend = false

            sort.txtName.text = TableData.GetHintById(sort.hintID)

            UIUtils.GetButtonListener(sort.btnSort.gameObject).onClick = function()
                self:OnClickSort(sort.sortType)
            end

            table.insert(self.sortList, sort)
        end
    end

    UIUtils.GetUIBlockHelper(self.mParentObj, self.mTrans_SortList, function ()
        self:CloseItemSort()
    end)
end

function UIWeaponPartsReplaceContent:RotateWeapon()
    local trans = self.weaponModel.transform
    CS.UITweenManager.PlayRotationTweenLoop(trans, 8)
end

function UIWeaponPartsReplaceContent:OnClickEnhance()
    local partData = nil
    if self.curReplacePart ~= nil then
        partData = self.curReplacePart.id
    else
        partData = self.partData.id
    end
    UIManager.OpenUIByParam(UIDef.UIWeaponPartPanel, {partData, UIWeaponGlobal.WeaponPartPanelTab.Enhance})
end

function UIWeaponPartsReplaceContent:OnClickReplace()
    self:ReplaceWeaponPart()
end

function UIWeaponPartsReplaceContent:OnClickUninstall()
    if self.curReplacePart then
        local index = self.weaponData:GetIndexBySlotId(self.type)
        NetCmdWeaponPartsData:ReqWeaponPartBelong(0, self.weaponData.id, index,function (ret) self:OnUninstallCallback(ret) end)
    end
end

function UIWeaponPartsReplaceContent:OnClickBack()
    setactive(self.mUIRoot, false)
end

function UIWeaponPartsReplaceContent:UpdateReplaceContent()
    self:UpdateReplaceList()
    self:UpdateCompareDetail()
    self.isCompareMode = false
    setactive(self.mTrans_Compare.gameObject, false)
    setactive(self.mTrans_ReplaceBtn, false)
    setactive(self.mTrans_EquipBtn, false)
    setactive(self.mTrans_Uninstall, true)
end

function UIWeaponPartsReplaceContent:ReplaceWeaponPart()
    if self.curReplacePart.weaponId > 0 then
        local weaponName = NetCmdWeaponData:GetWeaponById(self.curReplacePart.weaponId).Name
        MessageBoxPanel.ShowDoubleType(string_format(TableData.GetHintById(40015), weaponName), function () self:OnReplaceWeaponPart() end)
    else
        self:OnReplaceWeaponPart()
    end
end

function UIWeaponPartsReplaceContent:OnReplaceWeaponPart()
    if self.curReplacePart then
        local index = self.weaponData:GetIndexBySlotId(self.type)
        NetCmdWeaponPartsData:ReqWeaponPartBelong(self.curReplacePart.id, self.weaponData.id, index,function (ret) self:OnReplaceCallback(ret) end)
    end
end

function UIWeaponPartsReplaceContent:OnReplaceCallback(ret)
    if ret == CS.CMDRet.eSuccess then
        self.partData = NetCmdWeaponPartsData:GetWeaponPartById(self.curReplacePart.id)
        self.curReplacePart = nil
        if self.isCompareMode then
            self.mToggle_DetailCompare.isOn = false
        end
        self:UpdateReplaceContent()

        if self.replaceCallback then
            self.replaceCallback()
        end
    end
end

function UIWeaponPartsReplaceContent:OnUninstallCallback(ret)
    if ret == CS.CMDRet.eSuccess then
        self.curReplacePart = nil
        self.partData = nil
        if self.isCompareMode then
            self.mToggle_DetailCompare.isOn = false
        end
        self:UpdateReplaceContent()
        self:UpdateReplaceDetail(nil)

        if self.replaceCallback then
            self.replaceCallback()
        end
    end
end

function UIWeaponPartsReplaceContent:OnClickCompare(isOn)
    self.isCompareMode = not self.isCompareMode
    -- self.mToggle_DetailCompare.isOn = isOn
    setactive(self.mTrans_CompareDetail, self.isCompareMode)
end

function UIWeaponPartsReplaceContent:OnClickSortList()
    setactive(self.mTrans_SortList, true)
end

function UIWeaponPartsReplaceContent:CloseItemSort()
    setactive(self.mTrans_SortList, false)
end

function UIWeaponPartsReplaceContent:OnClickSort(type)
    if type then
        if self.curSort then
            if self.curSort.sortType ~= type then
                self.curSort.btnSort.interactable = true
            end
        end
        self.curSort = self.sortList[type]
        self.curSort.isAscend = false
        self.curSort.btnSort.interactable = false
        self.sortContent:SetData(self.curSort)

        self:UpdateListBySort()
        self:CloseItemSort()
    end
end

function UIWeaponPartsReplaceContent:OnClickAscend()
    if self.curSort then
        self.curSort.isAscend = not self.curSort.isAscend
        self.sortContent:SetData(self.curSort)

        self:UpdateListBySort()
    end
end

function UIWeaponPartsReplaceContent:UpdateReplaceList()
    local weaponPartsList = NetCmdWeaponPartsData:GetReplaceWeaponPartsListByType(self.type, self.weaponData.stc_id)
    self.weaponPartsList = self:UpdateWeaponPartsList(weaponPartsList)

    self:OnClickSort(UIWeaponGlobal.ReplaceSortType.Rank)
end

function UIWeaponPartsReplaceContent:UpdateListBySort()
    local sortFunc = self.sortContent.sortFunc
    table.sort(self.weaponPartsList, sortFunc)

    self.ReplaceVirtual.numItems = #self.weaponPartsList
    self.ReplaceVirtual:Refresh()

    self:ResetWeaponPartIndex(self.weaponPartsList)
end

function UIWeaponPartsReplaceContent:UpdateWeaponPartsList(list)
    if list then
        local itemList = {}
        for i = 0, list.Count - 1 do
            local data = UIWeaponGlobal:GetWeaponPartSimpleData(list[i])
            if self.partData then
                if data.id == self.partData.id then
                    self.curReplacePart = data
                    data.isSelect = true
                end
            end

            table.insert(itemList, data)
        end
        return itemList
    end
end

function UIWeaponPartsReplaceContent:ResetWeaponPartIndex(list)
    if list then
        for i, item in ipairs(list) do
            item.index = i - 1
        end
    end
end

function UIWeaponPartsReplaceContent:GetPartDataById(id)
    for i, part in ipairs(self.weaponPartsList) do
        if part.id == id then
            return part
        end
    end
    return nil
end

function UIWeaponPartsReplaceContent:PartItemProvider()
    local itemView = UIWeaponPartItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIWeaponPartsReplaceContent:PartItemRenderer(index, renderDataItem)
    local itemData = self.weaponPartsList[index + 1]
    local item = renderDataItem.data
    item:SetData(itemData)
    if self.partData then
        item:SetNowEquip(self.partData.id == itemData.id)
    else
        item:SetNowEquip(false)
    end

    UIUtils.GetButtonListener(item.mBtn_Part.gameObject).onClick = function()
        self:OnClickWeaponPart(item)
    end
end

function UIWeaponPartsReplaceContent:OnClickWeaponPart(part)
    if self.curReplacePart then
        if self.curReplacePart.id == part.partData.id then
            return
        end
        self.curReplacePart.isSelect = false
        self.ReplaceVirtual:RefreshItem(self.curReplacePart.index)
    end
    part.partData.isSelect = true
    part:SetItemSelect(true)
    self.curReplacePart = part.partData
    self:UpdateReplaceDetail(part.partData.id)
    self:UpdateButton()

    if self.clickPartCallback then
        self.clickPartCallback(part.partData.id)
    end
end

function UIWeaponPartsReplaceContent:UpdateButton()
    if self.partData then
        setactive(self.mTrans_CompareDetail, self.isCompareMode and (self.curReplacePart.id ~= self.partData.id))
        setactive(self.mTrans_Compare.gameObject, self.curReplacePart.id ~= self.partData.id)
        setactive(self.mTrans_ReplaceBtn, self.curReplacePart.id ~= self.partData.id)
        setactive(self.mTrans_Uninstall, self.curReplacePart.id == self.partData.id)
        setactive(self.mTrans_EquipBtn, false)
    else
        setactive(self.mTrans_Compare.gameObject, false)
        setactive(self.mTrans_CompareDetail, false)
        setactive(self.mTrans_ReplaceBtn, false)
        setactive(self.mTrans_Uninstall, false)
        setactive(self.mTrans_EquipBtn, true)
    end
end

function UIWeaponPartsReplaceContent:UpdateReplaceDetail(partId)
    if partId == nil then
        self.partDetail:SetData(nil)
    else
        local data = NetCmdWeaponPartsData:GetWeaponPartById(partId)
        if data then
            self.partDetail:SetData(data)
            self.mBtn_Enhance.interactable = data.isCanEnhance
            setactive(self.mTrans_CantEnhance, not data.isCanEnhance)
            setactive(self.mTrans_MaxLevel, data.isCanEnhance and not data.isCanLevelUp)
            if data.isCanEnhance then
                setactive(self.mTrans_Enhance, data.isCanLevelUp)
            else
                setactive(self.mTrans_Enhance, true)
            end
        end
    end
end

function UIWeaponPartsReplaceContent:UpdateCompareDetail()
    if self.partData then
        self.compareDetail:SetData(UIBarrackBriefItem.ShowType.WeaponPart, self.partData.id)
    end
end

function UIWeaponPartsReplaceContent:UpdateWeaponPartLock(id, isLock)
    local data = nil
    for _, item in ipairs(self.weaponPartsList) do
        if item.id == id then
            data = item
            item.isLock = isLock
            break
        end
    end
    if data then
        self.ReplaceVirtual:RefreshItem(data.index)
    end
    if self.lockCallback then
        self.lockCallback(id)
    end
end

function UIWeaponPartsReplaceContent:CloseContent()
    if self.mListAniTime and self.mListAnimator then
        self.mListAnimator:SetTrigger("FadeOut")
        self:DelayCall(self.mListAniTime.m_FadeOutTime, function ()
            if self.closeCallback then
                self.closeCallback()
            end
        end)
    else
        if self.closeCallback then
            self.closeCallback()
        end
    end
end

function UIWeaponPartsReplaceContent:UpdateWeaponPartType()
    local typeData = TableData.listWeaponPartTypeDatas:GetDataById(self.type)
    self.mText_WeaponPartType.text = string_format(TableData.GetHintById(40029), typeData.name)
end


function UIWeaponPartsReplaceContent:UpdateWeaponPartPos()
    if self.curReplacePart then
        self.ReplaceVirtual:DelayScrollToPosByIndex(self.curReplacePart.index + 1)
    end
end