require("UI.UIBaseCtrl")

---@class UIBarrackCardDisplayItem : UIBaseCtrl
UIBarrackCardDisplayItem = class("UIBarrackCardDisplayItem", UIBaseCtrl)
UIBarrackCardDisplayItem.__index = UIBarrackCardDisplayItem

--@@ GF Auto Gen Block End
UIBarrackCardDisplayItem.starList = {}

UIBarrackCardDisplayItem.mData = nil
UIBarrackCardDisplayItem.PrefabPath = "Character/ChrCardDisplayItemV2.prefab"

function UIBarrackCardDisplayItem:ctor()
    UIBarrackCardDisplayItem.super.ctor(self)
    self.starList = {}
    self.upgradeList = {}
    self.equipList = {}

    self.tableData = nil
    self.cmdData = nil
    self.dutyItem = nil
    self.curChipNum = 0
    self.unLockNeedNum = 0
end

function UIBarrackCardDisplayItem:__InitCtrl()
    self.mBtn_Gun = self:GetSelfButton()
    self.mImg_Figure = self:GetImage("GrpChr/GrpChrFigure/Img_Figure")
    self.mImg_Line = self:GetImage("GrpChr/GrpQualityLine/Img_Line")
    self.mImg_Num = self:GetImage("GrpChr/GrpBottom/GrpMental/GrpNumber/Img_Num")
    self.mText_WeaponName = self:GetText("GrpChr/GrpWeaponType/Text_WeaponName")
    self.mText_ = self:GetText("GrpChr/GrpBottom/GrpLevel/GrpLine/Text")
    self.mText_Level = self:GetText("GrpChr/GrpBottom/GrpLevel/Text_Level")
    self.mTrans_Duty = self:GetRectTransform("GrpChr/GrpDuty")

    self.mText_UnLockNum = self:GetText("GrpChr/Trans_GrpFragment/Text_NumNow")
    self.mText_UnLockTotal = self:GetText("GrpChr/Trans_GrpFragment/Text_NumTotal")

    self.mTrans_RedPoint = self:GetRectTransform("GrpChr/Trans_RedPoint")

    self.animator = self.mUIRoot:GetComponent("Animator")

    for i = 1, TableData.GlobalSystemData.GunMaxGrade do
        local upgrade = self:GetRectTransform("GrpChr/GrpStage/GrpStage/ComStage2ItemV2/GrpStage" .. i .. "/Trans_On")
        table.insert(self.upgradeList, upgrade)
    end

    for i = 1, GlobalConfig.MaxEquipCount do
        local equip = self:GetImage("GrpChr/GrpBottom/GrpEquip/GrpEquip/Trans_Equip" .. i)
        table.insert(self.equipList, equip)
    end

    self.dutyItem = UICommonDutyItem.New()
    self.dutyItem:InitCtrl(self.mTrans_Duty)
end

function UIBarrackCardDisplayItem:InitCtrl(parent)
    local itemPrefab = UIUtils.GetGizmosPrefab(self.PrefabPath, self)
    local instObj = instantiate(itemPrefab)

    UIUtils.AddListItem(instObj.gameObject, parent.gameObject)

    self:SetRoot(instObj.transform)
    self:__InitCtrl()
end

function UIBarrackCardDisplayItem:SetBaseData(gunId)
    if gunId then
        self.tableData = TableData.listGunDatas:GetDataById(gunId)
        local dutyData = TableData.listGunDutyDatas:GetDataById(self.tableData.duty)
        local avatar = IconUtils.GetCharacterGachaSprite(self.tableData.code)
        local color = TableData.GetGlobalGun_Quality_Color2(self.tableData.rank)
        self.mImg_Line.color = color
        self.mImg_Figure.sprite = avatar
        self.mText_WeaponName.text = dutyData.abbr.str
        self.dutyItem:SetData(dutyData)
        self:SetNetData(gunId)
        setactive(self.mUIRoot, true)
        self.animator:SetBool("LockState", self.isUnLock)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIBarrackCardDisplayItem:SetNetData(gunId)
    self.cmdData = NetCmdTeamData:GetGunByID(gunId)
    self.isUnLock = (self.cmdData ~= nil)

    if self.cmdData then
        self.mText_Level.text = self.cmdData.level
        self:SetUpgrade(self.cmdData.upgrade)
        self:SetEquipSlot()
        self:SetMental()
    else
        self.itemData = TableData.listItemDatas:GetDataById(self.tableData.core_item_id)
        local curChipNum = NetCmdItemData:GetItemCount(self.itemData.id)
        local unLockNeedNum = tonumber(self.tableData.unlock_cost)
        self.mText_UnLockNum.text = curChipNum
        self.mText_UnLockTotal.text = "/" .. unLockNeedNum
    end

    self:UpdateRedPoint()
end

function UIBarrackCardDisplayItem:UpdateData()
    local cmdData = NetCmdTeamData:GetGunByID(self.tableData.id)
    self:SetNetData(cmdData)
end

function UIBarrackCardDisplayItem:Enable(enable)
    setactive(self.mUIRoot, enable)
end

function UIBarrackCardDisplayItem:SetGunRank(rank)
    if rank then
        for i = 1, #self.starList do
            setactive(self.starList[i], i <= rank)
        end
    end
end

function UIBarrackCardDisplayItem:SetUpgrade(upgrade)
    if upgrade then
        for i = 1, #self.upgradeList do
            setactive(self.upgradeList[i], i <= upgrade)
        end
    end
end

function UIBarrackCardDisplayItem:SetEquipSlot()
    for i = 1, #self.equipList do
        local equipData = self.cmdData:GetEquipBar(i - 1)
        setactive(self.equipList[i].gameObject, equipData.HasEquip)
        if equipData.HasEquip then
            self.equipList[i].color = TableData.GetGlobalGun_Quality_Color2(equipData.EquipData.rank)
        end
    end
end

function UIBarrackCardDisplayItem:SetMental()
    local rankNum = 0
    local mentalData = TableData.listMentalCircuitDatas:GetDataById(self.cmdData.id)
    if self.cmdData.current_mental_node ~= nil then
        for i = 0, mentalData.rank_list.Count - 1 do
            if mentalData.rank_list[i] == self.cmdData.current_mental_node.Id then
                rankNum = i
            end
        end
    end

    local rankId = mentalData.rank_list[rankNum]
    local rankData = TableData.listMentalRankDatas:GetDataById(rankId)
    self.mImg_Num.sprite = IconUtils.GetMentalIcon(FacilityBarrackGlobal.RomaIconPrefix .. rankNum + 1)
end

function UIBarrackCardDisplayItem:UpdateRedPoint()
    local count = 0
    if self.cmdData then
        count = NetCmdTeamData:UpdateUpgradeRedPoint(self.cmdData)
    else
        count = NetCmdTeamData:UpdateLockRedPoint(self.tableData)
    end
    setactive(self.mTrans_RedPoint, count > 0)
end