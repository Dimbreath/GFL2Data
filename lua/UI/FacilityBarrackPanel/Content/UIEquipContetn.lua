UIEquipContent = class("UIEquipContent", UIBarrackContentBase)
UIEquipContent.__index = UIEquipContent

UIEquipContent.PrefabPath = "Character/ChrEquipPanelV2.prefab"

function UIEquipContent:ctor(obj)
    self.equipSetList = {}
    self.attributeList = {}
    self.slotList = {}
    self.showAttrList = nil
    UIEquipContent.super.ctor(self, obj)
end

function UIEquipContent:__InitCtrl()
    self.mBtn_Reset = self:GetButton("Root/GrpRight/GrpAction/BtnLeft/ComBtn3ItemV2")
    self.mTrans_EmptySet = self:GetRectTransform("Root/GrpRight/GrpAttribute/AttributeList/Viewport/Content/GrpSkill/Trans_GrpEmpty")
    self.mTrans_SetList = self:GetRectTransform("Root/GrpRight/GrpAttribute/AttributeList/Viewport/Content/GrpSkill")

    self.mTrans_AttrList = self:GetRectTransform("Root/GrpRight/GrpAttribute/AttributeList/Viewport/Content/GrpAttribute")

    self.mIamge_QualityFlower = self:GetImage("Root/GrpEquip/GrpIcon/GrpIcon/Img_QualityFlower")
    self.mIamge_ChrIcon = self:GetImage("Root/GrpEquip/GrpIcon/GrpIcon/Img_ChrIcon")

    self.animator = UIUtils.GetAnimator(self.mUIRoot, "Root")
    
    for i = 1, GlobalConfig.MaxEquipCount do
        local parent = self:GetRectTransform("Root/GrpEquip/Content/EquipItem_" .. i)
        table.insert(self.slotList, self:InitEquipSlot(parent, i))
    end

    UIUtils.GetButtonListener(self.mBtn_Reset.gameObject).onClick = function()
        self:ResetEquip()
    end
end

function UIEquipContent:InitEquipSlot(parent, index)
    if parent then
        local obj = self:InstanceUIPrefab("Character/ChrEquipItemV2.prefab", parent)
        local slot = {}
        slot.obj = obj
        slot.data = nil
        slot.index = index
        slot.animator = UIUtils.GetRectTransform(obj):GetComponent("Animator")
        slot.btnEquip = UIUtils.GetRectTransform(obj)
        slot.imgBg = UIUtils.GetImage(obj, "GrpEquipInfo/GrpQualityLine/Img_Bg")
        slot.imgLine = UIUtils.GetImage(obj, "GrpEquipInfo/GrpQualityLine/Img_Line")
        slot.textLv = UIUtils.GetText(obj, "GrpEquipInfo/GrpLevel/Text_Lv")
        slot.imageIcon = UIUtils.GetImage(obj, "GrpEquipInfo/GrpEquipmentIcon/Img_Item")
        slot.imgPos = UIUtils.GetImage(obj, "GrpEquipInfo/GrpPosition/GrpPositionIcon/Img_Icon")
        slot.txtPos = UIUtils.GetText(obj, "GrpBg/Text_Num")

        slot.imgPos.sprite = IconUtils.GetEquipNum(index)
        slot.txtPos.text = "0" .. index

        return slot
    end
end

function UIEquipContent:OnShow()
    self:UpdateGeneralPanel()
end

function UIEquipContent:SetData(data, parent)
    UIEquipContent.super.SetData(self, data, parent)
    self:EnableModel(false)
    self:OnEnable(true)
    self:UpdateGeneralPanel()
end

function UIEquipContent:UpdateGeneralPanel()
    self:UpdateGunInfo()
    self:UpdateSlotList(self.slotList)
    self:UpdateEquipSet(self.equipSetList, self.mTrans_SetList, self.mTrans_EmptySet)
    self:UpdateAttribute(self.attributeList, self.mTrans_AttrList, self.mTrans_EmptyAttr)
end

function UIEquipContent:UpdateGunInfo()
    local tableData = TableData.listGunDatas:GetDataById(self.mData.id)

    self.mIamge_QualityFlower.sprite = IconUtils.GetGunEpiphyllumIcon("Img_Epiphyllum_"..tableData.code)
    
    local characterData = TableData.listGunCharacterDatas:GetDataById(tableData.character_id)
    if characterData~= nil then
        self.mIamge_ChrIcon.sprite =  IconUtils.GetGunCharacterIcon("Icon_Character_"..characterData.en_name)
    end
end

function UIEquipContent:UpdateSlotList(list)
    for _, slot in ipairs(list) do
        local equipData = self.mData:GetEquipBar(slot.index - 1)
        self:UpdateSlot(slot, equipData)
    end
end

function UIEquipContent:UpdateSlot(slot, data)
    if data then
        slot.data = data
        slot.animator:SetBool("EquipStated", data.HasEquip)
        if data.HasEquip then
            local equipData = data.EquipData
            slot.imageIcon.sprite = IconUtils.GetEquipSprite(equipData.icon)
            slot.textLv.text = GlobalConfig.LVText .. equipData.level
            slot.imgBg.color = TableData.GetGlobalGun_Quality_Color2(equipData.rank)
            slot.imgLine.color = TableData.GetGlobalGun_Quality_Color2(equipData.rank)
            UIUtils.SetAlpha(slot.imgBg, 49 / 255)
        end

        UIUtils.GetButtonListener(slot.btnEquip.gameObject).onClick = function()
            self:OnClickSlot(slot)
        end
    end
end

function UIEquipContent:OnClickSlot(slot)
    self:OnClickGeneralSlot(slot)
end

function UIEquipContent:OnClickGeneralSlot(slot)
    UIManager.OpenUIByParam(UIDef.UICharacterEquipPanel, {self.mData.id, slot.index})
end

function UIEquipContent:UpdateEquipSet(itemList, parent, transEmpty)
    local setList = self.mData:GetGunEquipSet()

    for _, item in ipairs(itemList) do
        item:SetData(nil)
    end

    local item = nil
    local count = 0
    for id, num in pairs(setList) do
        for i = 1, num do
            count = count + 1
            if count <= #itemList then
                item = itemList[count]
            else
                item = UIEquipSetItem.New()
                item:InitCtrl(parent)
                table.insert(itemList, item)
            end
            local count = self.mData:GetEquipSetById(id)
            item:SetData(id, count)
        end
    end

   setactive(transEmpty, count <= 0)
end

function UIEquipContent:UpdateAttribute(itemList, parent, transEmpty)
    for _, item in ipairs(itemList) do
        item:SetData(nil)
    end

    if self.showAttrList == nil then
        self.showAttrList = {}
        self.showAttrList = self:GetEquipShowPropList()
    end
    local item = nil
    for i = 1, #self.showAttrList do
        if i <= #itemList then
            item = itemList[i]
        else
            item = UICommonPropertyItem.New()
            item:InitCtrl(parent)
            table.insert(itemList, item)
        end
        local value = self.mData:GetGunEquipValueByName(self.showAttrList[i].sys_name)
        item:SetData(self.showAttrList[i], value, true, false, false, true)
    end

    -- setactive(transEmpty, list.Count <= 0)
end

function UIEquipContent:ResetEquip()
    if self:CheckHadEquip(self.slotList) then
        NetCmdGunEquipData:SendEquipBelongCmd(self.mData.id, 0, 0, function (ret)
            if ret == CS.CMDRet.eSuccess then
                self:UpdateGeneralPanel()
            end
        end)
    end
end

function UIEquipContent:GetEquipShowPropList()
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

    return propList
end

function UIEquipContent:CheckHadEquip(list)
    for _, slot in ipairs(list) do
        if slot.data.HasEquip then
            return true
        end
    end
    return false
end
