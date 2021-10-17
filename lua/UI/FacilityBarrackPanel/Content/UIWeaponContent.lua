UIWeaponContent = class("UIWeaponContent", UIBarrackContentBase)
UIWeaponContent.__index = UIWeaponContent

UIWeaponContent.PrefabPath = "Character/ChrWeaponPanelV2.prefab"

function UIWeaponContent:ctor(obj)
    self.weaponData = nil
    self.weaponDetail = nil
    self.compareDetail = nil
    self.weaponModel = nil
    self.weaponList = {}
    self.curContent = 0
    self.isCompareMode = false
    self.curReplaceWeapon = nil
    self.selectWeapon = nil
    self.sortContent = nil
    self.sortList = {}
    self.curSort = nil
    self.partsList = {}
    self.weaponPartInfo = nil
    self.curSlot = nil
    UIWeaponContent.super.ctor(self, obj)
end

function UIWeaponContent:__InitCtrl()
    self.mAnimator = UIUtils.GetAnimator(self.mUIRoot, "Root")

    self.mBtn_Replace = UIUtils.GetTempBtn(self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/GrpWeaponInfo/Trans_GrpAction/Trans_BtnReplace"))
    self.mBtn_Enhance = UIUtils.GetTempBtn(self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/GrpWeaponInfo/Trans_GrpAction/Trans_BtnPowerUp"))
    self.mToggle_DetailCompare = self:GetGFToggle("Root/Trans_GrpWeaponDetails_0/GrpWeaponInfo/Trans_BtnContrast/Btn_Contrast")

    self.mTrans_Compare = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/GrpWeaponInfo/Trans_BtnContrast")
    self.mTrans_WeaponDetail = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/GrpWeaponInfo")
    self.mTrans_CompareDetail = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/GrpWeaponInfo/Trans_GrpWeaponInfo")

    self.mTrans_Replace = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/Trans_GrpWeaponList")
    self.mTrans_ReplaceScroll = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/Trans_GrpWeaponList/GrpWeaponList")

    self.mTrans_Sort = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/Trans_GrpWeaponList/GrpScreen/BtnScreen")
    self.mTrans_SortList = self:GetRectTransform("Root/Trans_GrpWeaponDetails_0/Trans_GrpWeaponList/GrpScreen/Trans_GrpScreenList")

    self.mTrans_PartInfo = self:GetRectTransform("Root/Trans_GrpWeaponPartsInfo/Trans_GrpTextInfo")
    self.mTrans_WeaponParts = self:GetRectTransform("Root/Trans_GrpWeaponPartsInfo/GrpWeaponParts")
    self.mTrans_WeaponPartInfo = self:GetRectTransform("Root/Trans_GrpWeaponPartsDetails_1")

    self.ReplaceVirtual = UIUtils.GetVirtualList(self.mTrans_ReplaceScroll)
    self.mListAnimator = UIUtils.GetAnimator(self.mUIRoot, "Root/Trans_GrpWeaponDetails_0/Trans_GrpWeaponList")
    self.mListAniTime = UIUtils.GetAnimatorTime(self.mUIRoot, "Root/Trans_GrpWeaponDetails_0/Trans_GrpWeaponList")

    self.weaponDetail = UIBarrackWeaponInfoItem.New()
    self.weaponDetail:InitCtrl(self.mTrans_WeaponDetail, function (id, isLock)
        self:UpdateWeaponLock(id, isLock)
    end)

    self.compareDetail = UIBarrackBriefItem.New()
    self.compareDetail:InitCtrl(self.mTrans_CompareDetail, function (id, isLock)
        self:UpdateWeaponLock(id, isLock)
    end)
    self.compareDetail:EnableCurrentWeapon(true)
    self.compareDetail:EnableLock(true)

    UIUtils.GetButtonListener(self.mBtn_Enhance.gameObject).onClick = function()
        self:OnClickEnhance()
    end

    UIUtils.GetButtonListener(self.mBtn_Replace.gameObject).onClick = function()
        self:OnClickReplace()
    end

    self.mToggle_DetailCompare.onValueChanged:AddListener(function (isOn)
        self:OnClickCompare()
    end)

    self:InitVirtualList()
    self:InitSortContent()
end

function UIWeaponContent:OnShow()
    if self.curSlot then
        self:OnClickPart(self.curSlot)
    else
        self.weaponDetail:SetData(self.selectWeapon)
    end

    if self.curContent == UIWeaponGlobal.ContentType.Replace then
        self:UpdateReplaceList()
        self:ResetWeaponIndex(self.weaponList)
    end

    self:UpdateWeaponPartsList(self.selectWeapon)
    self:EnableTabs(self.curContent ~= UIWeaponGlobal.ContentType.Replace)
end

function UIWeaponContent:OnRelease()
    UIWeaponContent.super.OnRelease(self)
    if self.weaponModel ~= nil then
		UIModelToucher.ReleaseWeaponToucher()
        CS.UITweenManager.KillTween(self.weaponModel.transform)
        ResourceManager:DestroyInstance(self.weaponModel)
        self.weaponModel = nil
        UIWeaponGlobal.weaponModel = nil
        self:ReleaseTimers()
    end
end

function UIWeaponContent:OnEnable(enable)
    UIWeaponContent.super.OnEnable(self, enable)
    if not enable then
		UIModelToucher.ReleaseWeaponToucher()
        if self.weaponModel ~= nil then
            CS.UITweenManager.KillTween(self.weaponModel.transform)
            ResourceManager:DestroyInstance(self.weaponModel)
            self.weaponModel = nil
        end
        self:ReleaseTimers()
	else
		UIModelToucher.SwitchToucher(2);
    end
end

function UIWeaponContent:SetData(data, parent)
    UIWeaponContent.super.SetData(self, data, parent)
    self.weaponData = NetCmdWeaponData:GetWeaponById(self.mData.WeaponId)
    self.curSlot = nil
    self.sortContent:SetGunId(self.weaponData.gun_id)
    self:InitWeaponModel()
    self:EnableModel(false)
    self:OnEnable(true)
    self:ResetContent()

    self.mAnimator:SetInteger("Switch", 0)
end

function UIWeaponContent:InitVirtualList()
    self.ReplaceVirtual.itemProvider = function()
        local item = self:WeaponItemProvider()
        return item
    end

    self.ReplaceVirtual.itemRenderer = function(index, rendererData)
        self:WeaponItemRenderer(index, rendererData)
    end
end

function UIWeaponContent:InitSortContent()
    if self.sortContent == nil then
        self.sortContent = UIWeaponSortItem.New()
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
            sort.sortCfg = UIWeaponGlobal.ReplaceSortCfg[i]
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

function UIWeaponContent:InitWeaponModel()
    if(self.weaponModel ~= nil) then
        CS.UITweenManager.KillTween(self.weaponModel.transform)
        ResourceManager:DestroyInstance(self.weaponModel)
    end
	self.weaponModel = UIModelToucher.CreateWeapon(self.weaponData);
    UIWeaponGlobal.weaponModel = self.weaponModel
end

function UIWeaponContent:UpdateWeaponModel(weaponData)
    if(self.weaponModel ~= nil) then
        CS.UITweenManager.KillTween(self.weaponModel.transform)
        ResourceManager:DestroyInstance(self.weaponModel)
    end
    self.weaponModel = UIModelToucher.CreateWeapon(weaponData)
    UIWeaponGlobal.weaponModel = self.weaponModel
end

function UIWeaponContent:RotateWeapon()
    local trans = self.weaponModel.transform
    CS.UITweenManager.PlayRotationTweenLoop(trans, 8)
end

function UIWeaponContent:OnClickEnhance()
    local weaponId = self.selectWeapon.id
    -- self:CloseReplaceContent()
    UIManager.OpenUIByParam(UIDef.UIWeaponPanel, {weaponId, UIWeaponGlobal.WeaponPanelTab.Enhance})
end

function UIWeaponContent:OnClickReplace()
    if self.curContent == UIWeaponGlobal.ContentType.Replace then
        self:ReplaceWeapon()
    else
        self.curContent = UIWeaponGlobal.ContentType.Replace
        self:UpdateReplaceContent()
        self:EnableTabs(false)
        self:EnableSwitchGun(false)
    end
end

function UIWeaponContent:UpdateReplaceContent()
    self.isCompareMode = false
    self:UpdateReplaceList()
    self:UpdateCompareDetail()
    self:UpdateButton()
    setactive(self.mTrans_Replace, true)
end

function UIWeaponContent:ReplaceWeapon()
    if self.selectWeapon.gun_id ~= 0 then
        local gunName2 = TableData.listGunDatas:GetDataById(self.selectWeapon.gun_id).name.str
        MessageBoxPanel.ShowDoubleType(string_format(TableData.GetHintById(40015), gunName2), function () self:OnReplaceWeapon() end)
    else
        self:OnReplaceWeapon()
    end
end

function UIWeaponContent:OnReplaceWeapon()
    local gunID = self.weaponData.gun_id
    NetCmdWeaponData:SendGunWeaponBelong(self.selectWeapon.id, gunID, function (ret) self:OnReplaceCallback(ret) end)
end

function UIWeaponContent:OnReplaceCallback(ret)
    if ret == CS.CMDRet.eSuccess then
        self.weaponData = NetCmdWeaponData:GetWeaponById(self.selectWeapon.id)
        self.selectWeapon = self.weaponData
        self.curReplaceWeapon = nil
        if self.isCompareMode then
            self.mToggle_DetailCompare.isOn = false
        end
        self:UpdateReplaceContent()
        self:InitWeaponModel()
        MessageSys:SendMessage(CS.GF2.Message.UIEvent.OnChangeWeapon, nil)
    end
end

function UIWeaponContent:CloseReplaceContent()
    if self.mListAniTime and self.mListAnimator then
        self.mListAnimator:SetTrigger("FadeOut")
        self:DelayCall(self.mListAniTime.m_FadeOutTime, function ()
            if self.selectWeapon.id ~= self.weaponData.id then
                self:UpdateWeaponModel(self.weaponData)
            end
            self:ResetContent()
            self:EnableTabs(true)
            self:EnableSwitchGun(true)
        end)
    else
        if self.selectWeapon.id ~= self.weaponData.id then
            self:UpdateWeaponModel(self.weaponData)
        end
        self:ResetContent()
        self:EnableTabs(true)
        self:EnableSwitchGun(true)
    end
end

function UIWeaponContent:ResetContent()
    self.curContent = UIWeaponGlobal.ContentType.Info
    self.isCompareMode = false
    self.selectWeapon = self.weaponData
    self.curReplaceWeapon = nil
    self.mToggle_DetailCompare.isOn = false
    self.mBtn_Replace.interactable = true
    setactive(self.mTrans_Compare.gameObject, false)
    setactive(self.mTrans_Replace, false)
    setactive(self.mTrans_CompareDetail, false)

    self:UpdateDetail(self.weaponData)
end

function UIWeaponContent:OnClickCompare(isOn)
    self.isCompareMode = not self.isCompareMode
    setactive(self.mTrans_CompareDetail, self.isCompareMode)
end

function UIWeaponContent:OnClickSortList()
    setactive(self.mTrans_SortList, true)
end

function UIWeaponContent:CloseItemSort()
    setactive(self.mTrans_SortList, false)
end

function UIWeaponContent:OnClickSort(type)
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

function UIWeaponContent:OnClickAscend()
    if self.curSort then
        self.curSort.isAscend = not self.curSort.isAscend
        self.sortContent:SetData(self.curSort)

        self:UpdateListBySort()
    end
end

function UIWeaponContent:UpdateReplaceList()
    local weaponList = NetCmdWeaponData:GetReplaceWeaponList(self.weaponData.id)
    self.weaponList = self:UpdateWeaponList(weaponList)

    self:OnClickSort(UIWeaponGlobal.ReplaceSortType.Rank)

    self.ReplaceVirtual:SetVerticalNormalizedPosition(1)
end

function UIWeaponContent:UpdateListBySort()
    local sortFunc = self.sortContent.sortFunc
    table.sort(self.weaponList, sortFunc)

    self.ReplaceVirtual.numItems = #self.weaponList
    self.ReplaceVirtual:Refresh()

    self:ResetWeaponIndex(self.weaponList)
end

function UIWeaponContent:UpdateWeaponList(list)
    if list then
        local itemList = {}
        for i = 0, list.Count - 1 do
            local data = UIWeaponGlobal:GetWeaponSimpleData(list[i])
            if self.curReplaceWeapon then
                if self.curReplaceWeapon.id == data.id then
                    self.curReplaceWeapon = data
                end
                data.isSelect = self.curReplaceWeapon.id == data.id
            end
            table.insert(itemList, data)
        end

        return itemList
    end
end

function UIWeaponContent:ResetWeaponIndex(list)
    if list then
        for i, item in ipairs(list) do
            item.index = i - 1
        end
    end
end

function UIWeaponContent:WeaponItemProvider()
    local itemView = UIWeaponReplaceItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIWeaponContent:WeaponItemRenderer(index, renderDataItem)
    local itemData = self.weaponList[index + 1]
    local item = renderDataItem.data
    item:SetData(itemData)
    item:SetNowEquip(self.weaponData.id == itemData.id)

    UIUtils.GetButtonListener(item.mBtn_Weapon.gameObject).onClick = function()
        self:OnClickWeapon(item)
    end
end

function UIWeaponContent:OnClickWeapon(weapon)
    if self.curReplaceWeapon then
        if self.curReplaceWeapon.id == weapon.weaponData.id then
            return
        end
        self.curReplaceWeapon.isSelect = false
        self.ReplaceVirtual:RefreshItem(self.curReplaceWeapon.index)
    end
    weapon.weaponData.isSelect = true
    weapon:SetSelect(true)
    self.curReplaceWeapon = weapon.weaponData
    self.selectWeapon = weapon.cmdData
    self:UpdateDetail(self.selectWeapon)
    self:UpdateButton()
    self:UpdateWeaponModel(self.selectWeapon)
end

function UIWeaponContent:UpdateButton()
    self.mBtn_Replace.interactable = self.selectWeapon.id ~= self.weaponData.id
    setactive(self.mTrans_Compare.gameObject, self.selectWeapon.id ~= self.weaponData.id)
    setactive(self.mTrans_CompareDetail,  self.isCompareMode and (self.selectWeapon.id ~= self.weaponData.id))
end

function UIWeaponContent:UpdateDetail(weaponData)
    if weaponData then
        self.weaponDetail:SetData(weaponData)
        self:UpdateWeaponPartsList(weaponData)
    end
end

function UIWeaponContent:UpdateCompareDetail()
    if self.weaponData then
        self.compareDetail:SetData(UIBarrackBriefItem.ShowType.Weapon, self.weaponData.id)
    end
end

function UIWeaponContent:UpdateWeaponLock(id, isLock)
    if self.curContent == UIWeaponGlobal.ContentType.Replace then
        for _, item in ipairs(self.weaponList) do
            if item.id == id then
                item.isLock = isLock
                break
            end
        end
        self.ReplaceVirtual:Refresh()
    end
end

function UIWeaponContent:UpdateWeaponPartsList(data)
    if not AccountNetCmdHandler:CheckSystemIsUnLock(SystemList.GundetailWeaponpart) then
        setactive(self.mTrans_PartInfo, false)
        return
    end

    if data == nil then
        return
    end

    for i, part in ipairs(self.partsList) do
        part:SetData(nil, nil)
    end

    local slotList = data.slotList
    for i = 0, slotList.Count - 1 do
        local item = self.partsList[i + 1]
        if item == nil then
            item = UIWeaponSlotItem.New()
            item:InitCtrl(self.mTrans_WeaponParts)
            table.insert(self.partsList, item)
        end
        local data = data:GetWeaponPartByIndex(slotList[i])
        item:SetData(data, slotList[i])
        UIUtils.GetButtonListener(item.mBtn_Part.gameObject).onClick = function()
            self:OnClickPart(item)
        end
    end

    setactive(self.mTrans_PartInfo, data.BuffSkillId > 0)
end

function UIWeaponContent:UpdateWeaponPartsListByType(type, partId)
    if partId == nil then
        return
    end

    local curSlot = nil
    for _, slot in ipairs(self.partsList) do
        if slot.slotId and slot.slotId == type then
            curSlot = slot
            break
        end
    end
    local data = NetCmdWeaponPartsData:GetWeaponPartById(partId)
    curSlot:SetData(data, curSlot.slotId)
end

function UIWeaponContent:OnClickPart(item)
    if self.weaponPartInfo == nil then
        self.weaponPartInfo = UIWeaponPartsReplaceContent.New()
        self.weaponPartInfo:InitCtrl(self.mTrans_WeaponPartInfo, self.mParentObj)
        self.weaponPartInfo:SetReplaceCallback(function ()
            if self.selectWeapon then
                self:UpdateWeaponPartsList(self.selectWeapon)
            end
            self.ReplaceVirtual:Refresh()
        end)

        self.weaponPartInfo:SetLockCallback(function (id)
            self:UpdateWeaponPartStateById(id)
        end)

        self.weaponPartInfo:SetCloseCallback(function ()
            self:CloseWeaponPartRelpace()
        end)

        self.weaponPartInfo:SetClickPartCallback(function (partId)
            self:UpdateWeaponPartsListByType(self.curSlot.slotId, partId)
        end)
    end

    self:EnableTabs(false)
    self:EnableSwitchGun(false)
    self:UpdateWeaponPartsList(self.selectWeapon)
    if self.curSlot then
        self.curSlot:SetItemSelect(false)
    end
    self.curSlot = item
    self.curSlot:SetItemSelect(true)
    self.weaponDetail:SetData(nil)
    self.weaponPartInfo:SetData(self.curSlot.partData, self.curSlot.slotId, self.selectWeapon.id)
    self:EnableReplaceContent(false)
    setactive(self.mTrans_WeaponPartInfo, true)
    self.mAnimator:SetInteger("Switch", 1)
    self.weaponPartInfo:UpdateWeaponPartPos()
end

function UIWeaponContent:EnableReplaceContent(enable)
    setactive(self.mTrans_Compare.gameObject, enable)
    setactive(self.mTrans_Replace, enable)
    setactive(self.mTrans_CompareDetail, enable and self.isCompareMode)
end

function UIWeaponContent:CloseWeaponPartRelpace()
    self:UpdateDetail(self.selectWeapon)
    self.curSlot:SetItemSelect(false)
    self.curSlot = nil
    if self.curContent == UIWeaponGlobal.ContentType.Replace then
        self:EnableReplaceContent(true)
        self:EnableTabs(false)
        self:EnableSwitchGun(false)
    else
        self:EnableTabs(true)
        self:EnableSwitchGun(true)
    end
    self.mAnimator:SetInteger("Switch", 0)
    setactive(self.mTrans_WeaponPartInfo, false)
end

function UIWeaponContent:UpdateWeaponPartStateById(id)
    for i, part in ipairs(self.partsList) do
        if part.partData and part.partData.id == id then
            local data = NetCmdWeaponPartsData:GetWeaponPartById(id)
            part:SetData(data, part.slotId)
            return
        end
    end
end