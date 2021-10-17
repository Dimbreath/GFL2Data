require("UI.Common.PropertyItemS")
---@class UIMentalContent : UIBarrackContentBase
UIMentalContent = class("UIMentalContent", UIBarrackContentBase)
UIMentalContent.__index = UIMentalContent

UIMentalContent.PrefabPath = "Character/ChrMentalPanelV2.prefab"

function UIMentalContent:ctor(obj)
    self.curType = 0
    self.rankId = 0
    self.nodeNum = 0
    self.rankNum = 1
    self.nodeList = {}
    self.attributeList = {}
    self.breakAttrList = {}
    self.mentalAttrList = {}
    self.mentalInfoAttr = {}
    self.lightList = {}
    self.curNode = nil
    self.isItemEnough = false
    self.mixPanel = nil
    self.itemList = nil
    self.costItem = nil
    self.mentalCostItem = nil
    UIMentalContent.super.ctor(self, obj)
end

function UIMentalContent:__InitCtrl()
    self.mBtn_NodeUpgrade = self:GetButton("Root/GrpRight/GrpAction/BtnRight/ComBtn3ItemV2")
    self.mBtn_Mix = self:GetButton("Root/GrpRight/GrpAction/BtnLeft/ComBtn3ItemV2")
    self.mBtn_CancelConfirm = self:GetButton("Root/GrpPopup/ChrMentalCpuUpPanelV2/Root/GrpDialog/GrpBtn/BtnCancel/Btn_Cancel")
    self.mBtn_Confirm = self:GetButton("Root/GrpPopup/ChrMentalCpuUpPanelV2/Root/GrpDialog/GrpBtn/BtnConfirm/Btn_Cancel")
    self.mBtn_MentalInfoClose = self:GetButton("Root/GrpPopup/ChrMentalInfoPanelV2/Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_RankBreakClose = self:GetButton("Root/GrpPopup/ChrMentalCpuUpPanelV2/Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_MentalInfoCloseBg = self:GetButton("Root/GrpPopup/ChrMentalInfoPanelV2/Root/GrpBg/Btn_Close")
    self.mBtn_RankBreakCloseBg = self:GetButton("Root/GrpPopup/ChrMentalCpuUpPanelV2/Root/GrpBg/Btn_Close")

    self.mImage_CoreName = self:GetImage("Root/GrpCenter/GrpStageUp/Activation5/BarrackMentalItemV2/Btn_GrpMental/GrpContent/GrpLeft/ImgBg2")
    self.mImage_CoreName2 = self:GetImage("Root/GrpCenter/GrpStageUp/GrpInfo/GrpNumber/Img_Num")
    self.mText_CoreName2 = self:GetText("Root/GrpCenter/GrpStageUp/GrpInfo/GrpNumber/Text_Subject")
    self.mTrans_MentalProp = self:GetRectTransform("Root/GrpRight/GrpAttribute/GrpActivationNow/AttributeUpList/Viewport/Content")
    self.mTrans_NodeProperty = self:GetRectTransform("Root/GrpRight/GrpAttribute/Trans_GrpActivationNode/Trans_AttributeUpNodeList/Viewport/Content")
    self.mTrans_AttrUp = self:GetRectTransform("Root/GrpRight/GrpAttribute/Trans_GrpActivationNode")
    self.mTrans_Cost = self:GetRectTransform("Root/GrpRight/GrpAttribute/Trans_GrpConsume")
    self.mTrans_CostItem = self:GetRectTransform("Root/GrpRight/GrpAttribute/Trans_GrpConsume/Trans_GrpItem/ComItemV2")
    self.mTrans_NodeUpgradeCost = self:GetRectTransform("Root/GrpRight/GrpAttribute/Trans_GrpConsume/Trans_GrpItem")
    self.mTrans_RankUpgradeCost = self:GetRectTransform("Root/GrpRight/GrpAttribute/Trans_GrpConsume/Trans_GrpGoldConsume")
    self.mImage_CostItemIcon = self:GetImage("Root/GrpRight/GrpAttribute/Trans_GrpConsume/Trans_GrpGoldConsume/GrpGoldIcon/Img_Bg")
    self.mText_CostItemCount = self:GetText("Root/GrpRight/GrpAttribute/Trans_GrpConsume/Trans_GrpGoldConsume/Text_Num")
    self.mText_Title = self:GetText("Root/GrpRight/GrpAttribute/Trans_GrpActivationNode/GrpTextNode/GrpTittle/TextTittle")

    self.mTrans_MentalInfo = self:GetRectTransform("Root/GrpPopup/ChrMentalInfoPanelV2")
    self.mTrans_RankBreak = self:GetRectTransform("Root/GrpPopup/ChrMentalCpuUpPanelV2")

    self.mTrans_BtnUpgrade = self:GetRectTransform("Root/GrpRight/GrpAction/BtnRight")
    self.mTrans_BtnMix = self:GetRectTransform("Root/GrpRight/GrpAction/BtnLeft")
    self.mTrans_MaxLevel = self:GetRectTransform("Root/GrpRight/GrpAction/Trans_MaxLevel")

    self.mTrans_BreakAttrList = self:GetRectTransform("Root/GrpPopup/ChrMentalCpuUpPanelV2/Root/GrpDialog/GrpCenter/GrpAttributeUp/GrpAttribute")

    self.mTrans_MentalInfoAttr = self:GetRectTransform("Root/GrpPopup/ChrMentalInfoPanelV2/Root/GrpDialog/GrpCenter/GrpAttributeUp/GrpAttribute")
    self.mTrans_MentalInfoCost = self:GetRectTransform("Root/GrpPopup/ChrMentalInfoPanelV2/Root/GrpDialog/GrpCenter/GrpConsume/GrpItem/ComItemV2")

    self.animator = UIUtils.GetAnimator(self.mUIRoot, "Root")

    --self.mTrans_BreakUnLock = self:GetRectTransform("mentalDetail/attribute/nodeChange/UI_Trans_CoreStat/Btn_CoreUpButton/Trans_Unlock")

    for i = 1, FacilityBarrackGlobal.MaxMentalNode do
        local obj = self:GetRectTransform("Root/GrpCenter/GrpStageUp/Activation5/BarrackMentalItemV2/Btn_GrpMental/GrpContent/GrpProgress/GrpLight" .. i)
        local light = UIUtils.GetRectTransform(obj, "Trans_ImgLightOn")
        table.insert(self.lightList, light)
    end

    UIUtils.GetButtonListener(self.mBtn_NodeUpgrade.gameObject).onClick = function()
        self:OnClickUpgrade()
    end

    UIUtils.GetButtonListener(self.mBtn_Mix.gameObject).onClick = function()
        self:OnMixItem()
    end

    UIUtils.GetButtonListener(self.mBtn_CancelConfirm.gameObject).onClick = function()
        self:OnClickCancel()
    end

    UIUtils.GetButtonListener(self.mBtn_Confirm.gameObject).onClick = function()
        self:ReqMentalUpdate()
    end

    UIUtils.GetButtonListener(self.mBtn_MentalInfoClose.gameObject).onClick = function()
        self:OnClickMentalInfoClose()
    end

    UIUtils.GetButtonListener(self.mBtn_RankBreakClose.gameObject).onClick = function()
        self:OnClickCancel()
    end

    UIUtils.GetButtonListener(self.mBtn_MentalInfoCloseBg.gameObject).onClick = function()
        self:OnClickMentalInfoClose()
    end

    UIUtils.GetButtonListener(self.mBtn_RankBreakCloseBg.gameObject).onClick = function()
        self:OnClickCancel()
    end

    self:InitNodeList()
end

function UIMentalContent:InitNodeList()
    for i = 1, FacilityBarrackGlobal.MaxMentalNode do
        local node = {}
        local obj = self:GetRectTransform("Root/GrpCenter/GrpStageUp/Activation" .. i)
        node.obj = obj.gameObject
        node.index = i
        node.btnMental = UIUtils.GetButton(obj, "BarrackMentalItemV2/Btn_GrpMental")
        node.transOn = UIUtils.GetRectTransform(obj, "BarrackMentalItemV2/Btn_GrpMental/GrpContent/Trans_GrpCompleted")
        node.transSelect = UIUtils.GetRectTransform(obj, "BarrackMentalItemV2/Btn_GrpMental/GrpContent/Trans_GrpNow")
        node.transLock = UIUtils.GetRectTransform(obj, "BarrackMentalItemV2/Btn_GrpMental/GrpContent/Trans_GrpLocked")
        node.transActivationEffect = UIUtils.GetRectTransform(obj, "ChrMentalPanelV2_Effect_Light01")
        node.transSuccessEffect = UIUtils.GetRectTransform(obj, "ChrMentalPanelV2_Effect0" .. i)
        setactive(node.transSuccessEffect, false)
        UIUtils.GetButtonListener(node.btnMental.gameObject).onClick = function()
            self:OnClickNode(node)
        end

        table.insert(self.nodeList, node)
    end

    self.node5 = {}
    local obj = self:GetRectTransform("Root/GrpCenter/GrpStageUp/Activation5")
    self.node5.obj = obj.gameObject
    self.node5.transSuccessEffect = UIUtils.GetRectTransform(obj, "ChrMentalPanelV2_Effect05")
    setactive(self.node5.transSuccessEffect, false)
end

function UIMentalContent:InitCostItem(obj)
    if obj then
        local item = {}
        item.obj = obj
        item.imgIcon = UIUtils.GetImage(obj, "image_iconImage")
        item.txtNum = UIUtils.GetText(obj, "")
    end
end

function UIMentalContent:OnShow()
    self:OnUpdateItemData()
end

function UIMentalContent:OnHide()
    if self.mixPanel then
        self.mixPanel:ClosePanel()
    end
    self:ReleaseTimers()
end

function UIMentalContent:SetData(data, parent)
    UIMentalContent.super.SetData(self, data, parent)
    self:UpdateContent()
    self:EnableModel(false)
    self:OnEnable(true)
end

function UIMentalContent:OnEnable(enable)
    UIMentalContent.super.OnEnable(self, enable)
    if not enable then
        self:ReleaseTimers()
    end
end

function UIMentalContent:UpdateContent()
    self.curNode = nil
    self.mentalData = TableData.listMentalCircuitDatas:GetDataById(self.mData.stc_gun_id)
    if self.mData.current_mental_node == nil then
        self.nodeNum = 0
        self.rankNum = 1
    else
        self.nodeNum = self.mData.current_mental_node.Level
        self.rankNum = self:GetRankNum(self.mData.current_mental_node.Id)
    end
    self.rankId = self.mentalData.rank_list[self.rankNum - 1]
    local isLastRank = self.rankNum >= self.mentalData.rank_list.Count
    local rankData = TableData.listMentalRankDatas:GetDataById(self.rankId)

    if self.nodeNum < 4 then
        self.curType = FacilityBarrackGlobal.MentalUpgradeType.NodeUpgrade
    elseif self.nodeNum >= 4 then
        if isLastRank then
            self.curType = FacilityBarrackGlobal.MentalUpgradeType.RankMax
        else
            self.curType = FacilityBarrackGlobal.MentalUpgradeType.RankBreak
        end
    end

    self:UpdateNodeContent(rankData)
    self:UpdateCore(rankData)
    self:UpdateUpgradeContent()
    self:UpdateCostItem(self.itemList)
end

function UIMentalContent:UpdateCore(rankData)
    self.mImage_CoreName.sprite = self:GetRomaNumberIcon(self.rankNum)
    for i, light in ipairs(self.lightList) do
        setactive(light, i <= self.nodeNum)
    end
end

function UIMentalContent:UpdateNodeContent(rankData)
    for i = 0, rankData.node_list.Count - 1 do
        local nodeData = TableData.listMentalNodeDatas:GetDataById(rankData.node_list[i])
        local nodeItem = self.nodeList[i + 1]
        nodeItem.data = nodeData
        nodeItem.name = rankData.name.str .. (i + 1)
        setactive(nodeItem.transOn, i < self.nodeNum)
        setactive(nodeItem.transSelect, i == self.nodeNum)
        setactive(nodeItem.transLock, i > self.nodeNum)
        setactive(nodeItem.transActivationEffect, i < self.nodeNum)
        setactive(nodeItem.transSuccessEffect, false)

        if i == self.nodeNum then
            setactive(nodeItem.transSelect, true)
            self.curNode = nodeItem
            self:UpdateNodeInfo(nodeItem)
            self:UpdateUpgradeContent()
        end
    end

    setactive(self.node5.transSuccessEffect, false)
end

function UIMentalContent:UpdateBreakContent()
    local nextRankData = TableData.listMentalRankDatas:GetDataById(self.mentalData.rank_list[self.rankNum])
    self.mText_Title.text = TableData.GetHintById(30032)
    self.itemList = nextRankData.item_list
    self:UpdateBreakCostItem(nextRankData.item_list)
    self:UpdateAttributeList(nextRankData.property_list, self.breakAttrList, self.mTrans_BreakAttrList, false, false)

    self:ResetAllNode()
end

function UIMentalContent:OnClickNode(node)
    if node then
        self:ShowMentalNodeInfo(node)
    end
end

function UIMentalContent:ShowMentalNodeInfo(node)
    if node then
        self.itemList = node.data.item_list
        self:UpdateAttributeList(node.data.property_list, self.mentalInfoAttr, self.mTrans_MentalInfoAttr, false, true)
        self:UpdateMentalInfoCost(node.data.item_list, self.mTrans_MentalInfoCost)
        setactive(self.mTrans_MentalInfo, true)
        self:ShowEffect(false)
    end
end

function UIMentalContent:UpdateNodeInfo(node)
    if node then
        self.itemList = node.data.item_list
        self:UpdateAttributeList(node.data.property_list, self.attributeList, self.mTrans_NodeProperty, false, false)
    end
end

function UIMentalContent:UpdateUpgradeContent()
    setactive(self.mTrans_NodeUpgradeCost, self.curType == FacilityBarrackGlobal.MentalUpgradeType.NodeUpgrade)
    setactive(self.mTrans_RankUpgradeCost, self.curType == FacilityBarrackGlobal.MentalUpgradeType.RankBreak)
    setactive(self.mTrans_AttrUp, self.curType == FacilityBarrackGlobal.MentalUpgradeType.NodeUpgrade)
    setactive(self.mTrans_BtnMix.gameObject, self.curType == FacilityBarrackGlobal.MentalUpgradeType.NodeUpgrade)
    setactive(self.mTrans_MaxLevel, self.curType == FacilityBarrackGlobal.MentalUpgradeType.RankMax)
    setactive(self.mTrans_Cost, self.curType ~= FacilityBarrackGlobal.MentalUpgradeType.RankMax)
    setactive(self.mTrans_BtnUpgrade, self.curType ~= FacilityBarrackGlobal.MentalUpgradeType.RankMax)

    self.mImage_CoreName2.sprite = self:GetRomaNumberIcon(self.rankNum)
    self.mText_CoreName2.text = string_format(TableData.GetHintById(102107), tostring(self.rankNum))

    if self.curType == FacilityBarrackGlobal.MentalUpgradeType.NodeUpgrade then
        self.mText_Title.text = string_format(TableData.GetHintById(30031), self.curNode.index)
    elseif self.curType == FacilityBarrackGlobal.MentalUpgradeType.RankBreak then
        self:UpdateBreakContent()
    end

    self:UpdateMentalProp()
end

function UIMentalContent:UpdateMentalProp()
    if self.mData.current_mental_node ~= nil then
        local propList = self.mData:GetMentalProp()
        self:UpdateAttributeList(propList, self.mentalAttrList, self.mTrans_MentalProp, false, false)
    else
        self:UpdateAttributeList(nil, self.mentalAttrList)
    end
end

function UIMentalContent:UpdateAttributeList(propertyList, list, parent, needLine, needBg)
    if propertyList == nil then
        for _, item in ipairs(list) do
            item:SetData(nil)
        end
        return
    end

    for _, item in ipairs(list) do
        item:SetData(nil)
    end

    local attrList = propertyList
    local tempList = {}
    for name, value in pairs(attrList) do
        local prop = {}
        prop.data = TableData.GetPropertyDataByName(name, 1)
        prop.value = value
        table.insert(tempList, prop)
    end
    table.sort(tempList, function (a, b) return a.data.order < b.data.order end)

    local count = 1
    local counter = 0
    for i = 1, #tempList do
        local item = nil
        if i <= #list then
            item = list[i]
        else
            item = UICommonPropertyItem.New()
            item:InitCtrl(parent)
            table.insert(list, item)
        end

        item:SetData(tempList[i].data, tempList[i].value, needLine, false, needBg)
    end
end

function UIMentalContent:UpdateCostItem(itemList)
    if itemList then
        local list = {}
        for id, num in pairs(itemList) do
            local item = {}
            item.itemId = id
            item.num = num
            table.insert(list, item)
        end

        for _, item in ipairs(list) do
            if self.costItem == nil then
                self.costItem = UICommonItem.New()
                self.costItem:InitObj(self.mTrans_CostItem)
            end
            self.costItem:SetItemData(item.itemId, item.num, true,true)
            self.isItemEnough = self.costItem:IsItemEnough()
            --不能合成的道具不显示合成按钮
            local itemData = TableData.GetItemData(item.itemId)
            local mix_item_list = itemData.mix_item_list
            setactive(self.mTrans_BtnMix.gameObject, self.curType ~= FacilityBarrackGlobal.MentalUpgradeType.RankMax and mix_item_list ~= nil and mix_item_list ~= "")
        end
    end
end

function UIMentalContent:UpdateMentalInfoCost(itemList)
    if itemList then
        local list = {}
        for id, num in pairs(itemList) do
            local item = {}
            item.itemId = id
            item.num = num
            table.insert(list, item)
        end

        for _, item in ipairs(list) do
            if self.mentalCostItem == nil then
                self.mentalCostItem = UICommonItem.New()
                self.mentalCostItem:InitObj(self.mTrans_MentalInfoCost)
            end
            self.mentalCostItem:SetItemData(item.itemId, item.num, true,true)
        end
    end
end

function UIMentalContent:UpdateBreakCostItem(itemList)
    if itemList then
        local list = {}
        for id, num in pairs(itemList) do
            local item = {}
            item.itemId = id
            item.num = num
            table.insert(list, item)
        end

        for _, item in ipairs(list) do
            local itemData = TableData.listItemDatas:GetDataById(item.itemId)
            local resCount = NetCmdItemData:GetItemCountById(item.itemId)
            self.isItemEnough = resCount >= item.num
            local text = self.isItemEnough and FacilityBarrackGlobal.ItemCountRichText or FacilityBarrackGlobal.ItemCountNotEnoughText
            self.mImage_CostItemIcon.sprite = IconUtils.GetItemIconSprite(item.itemId)
            self.mText_CostItemCount.text = string_format(text, resCount, item.num)
        end
    end
end

function UIMentalContent:GetMixMaterialList(str)

    if str ~= nil and str ~= "" then
        local list = {}
        local mixItemsArray = string.split(str, ',')
        for k, v in pairs(mixItemsArray) do
            local itemSplitData = string.split(v, ':')
            local item = {
                itemId = tonumber(itemSplitData[1]),
                itemNum = tonumber(itemSplitData[2])
            }
            table.insert(list, item)
        end
        return list
    end
    return nil
end

function UIMentalContent:OnMixItem()
    if self.costItem then
        local itemData = {}
        itemData.itemId = self.costItem.itemId
        itemData.num = self.costItem.itemNum
        local itemTableData = TableData.listItemDatas:GetDataById(itemData.itemId);

        local materialList = self:GetMixMaterialList(itemTableData.mix_item_list);
        if materialList ~= nil and #materialList ~= 0 then
            local gunData = TableData.GetGunData(self.mData.stc_gun_id)
            local para = { itemData, gunData.duty };
            UIManager.OpenUIByParam(UIDef.UIMixPanel, para);
        else
            UIManager.OpenUIByParam(UIDef.UIGetWayPanel, itemData);
        end
    end
end

function UIMentalContent:OnUpdateItemData()
    if self.curType == FacilityBarrackGlobal.MentalUpgradeType.NodeUpgrade then
        self:UpdateCostItem(self.itemList)
    elseif self.curType == FacilityBarrackGlobal.MentalUpgradeType.RankBreak then
        self:UpdateBreakCostItem(self.itemList)
    end
end

function UIMentalContent:OnClickUpgrade()
    if not self.isItemEnough then
        CS.PopupMessageManager.PopupString(TableData.GetHintById(40005))
        return
    end
    setactive(self.mTrans_RankBreak, self.curType == FacilityBarrackGlobal.MentalUpgradeType.RankBreak)
    self:ShowEffect(false)
    if self.curType == FacilityBarrackGlobal.MentalUpgradeType.NodeUpgrade then
        self:ReqMentalUpdate()
    end
end

function UIMentalContent:ReqMentalUpdate()
    local rankId = 0
    if self.nodeNum < 4 then
        rankId = self.rankId
    else
        rankId = self.mentalData.rank_list[self.rankNum]
    end

    NetCmdTeamData:SendReqMentalUpdate(self.mData.stc_gun_id, function (ret)
        if ret == CS.CMDRet.eSuccess then
            printstack("心智升级成功")
            local curNode = nil
            if self.curNode then
                curNode = self.curNode
                self:SetData(self.mData, self.mParent)
                setactive(curNode.transSuccessEffect, true)
            else
                curNode = self.node5
                setactive(self.node5.transSuccessEffect, true)
                self:EnableMask(true)
                self:DelayCall(3, function()
                    self:SetData(self.mData, self.mParent)

                    self:EnableMask(false)
                end)
            end
            self:OnClickCancel()
        end
    end)
end

function UIMentalContent:GetRankNum(rankId)
    for i = 0, self.mentalData.rank_list.Count - 1 do
        if self.mentalData.rank_list[i] == rankId then
            return (i + 1)
        end
    end
    printstack("找不到对应rankId" .. rankId)
    return 1
end

function UIMentalContent:ResetAllNode()
    for _, item in ipairs(self.nodeList) do
        setactive(item.transSelect, false)
    end

    self.curNode = nil
end

function UIMentalContent:ShowEffect(show)
    for i = 0, TableData.listMentalRankDatas:GetDataById(self.rankId).node_list.Count - 1 do
        local nodeItem = self.nodeList[i + 1]
        setactive(nodeItem.transActivationEffect, show and i < self.nodeNum)
    end
end

function UIMentalContent:OnClickCancel()
    setactive(self.mTrans_RankBreak, false)
    self:ShowEffect(true)
end

function UIMentalContent:OnClickMentalInfoClose()
    setactive(self.mTrans_MentalInfo, false)
    self:ShowEffect(true)
end

function UIMentalContent:CheckCanUnLockSkill(rankNum)
    local gunData = TableData.GetGunData(self.mData.stc_gun_id)
    local skillId = -1
    local unLockList = TableData.GlobalSystemData.SkillUnlockRank
    if rankNum == unLockList[0] then       --- 普攻
    skillId = gunData.skill_normal_attack
    elseif rankNum == unLockList[1] then
        skillId = gunData.skill_active   --- 主动
    elseif rankNum == unLockList[2] then
        skillId = gunData.skill_super   --- 大招
    end
    if skillId > 0 then
        return TableData.listBattleSkillDatas:GetDataById(skillId + 1)
    else
        return nil
    end
end

function UIMentalContent:GetRomaNumberIcon(number)
    return IconUtils.GetMentalIcon(FacilityBarrackGlobal.RomaIconPrefix .. number)
end

function UIMentalContent:OnRelease()
    UIMentalContent.super.OnRelease(self)
    self:ReleaseTimers()
end