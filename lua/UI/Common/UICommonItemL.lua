require("UI.UIBaseCtrl")

UICommonItemL = class("UICommonItemL", UIBaseCtrl)
UICommonItemL.__index = UICommonItemL

function UICommonItemL:ctor()
    self.mData = nil
    self.itemId = 0
    self.itemCount = 0
    self.isItemEnough = false
    self.starList = {}
end

function UICommonItemL:__InitCtrl()
    self.mBtn_Select = self:GetButton("Btn_Select")
    self.mImage_Icon = self:GetImage("Image_Icon")
    self.mImage_Rank = self:GetImage("Image_Rank")
    self.mText_Count = self:GetText("Text_Count")
    self.mTrans_Equip = self:GetRectTransform("EquipIconBase")
    self.mImage_EquipBase = self:GetImage("EquipIconBase/UI_base")
    self.mImage_EquipIcon = self:GetImage("EquipIconBase/UI_base/mask/avatareImage")
    self.mTrans_Select = self:GetRectTransform("Trans_Selected")
    self.mTrans_Stars = self:GetRectTransform("Trans_GradeDetail")
    self.mText_Index = self:GetText("EquipIconBase/UI_position/Text")
    self.mTrans_Lock = self:GetRectTransform("Trans_Locked")
    self.mTrans_Equiped = self:GetRectTransform("Trans_Equipped")
    self.mImage_GunIcon = self:GetImage("Trans_Equipped/HeadFrame/Image_HeadIcon")
    for i = 1, 6 do
        local obj = self:GetRectTransform("Trans_GradeDetail/Trans_Star" .. i)
        table.insert(self.starList, obj)
    end
end

function UICommonItemL:InitCtrl(parent)
    self.parent = parent

    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonItemL.prefab", self))

    if parent then
        setparent(parent, obj.transform)
        obj.transform.localScale = vectorone
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonItemL:InitItem(obj)
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end


--- just for show
function UICommonItemL:SetData(id, num)
    self.itemId = id
    self.itemCount = num
    local stcData = TableData.GetItemData(id)
    self.mImage_Icon.sprite = IconUtils.GetItemIconSprite(stcData.id)
    self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(stcData.rank)
    self.mText_Count.text = num

    setactive(self.mTrans_Lock, false)
    setactive(self.mTrans_Equip, false)
    setactive(self.mImage_Icon.gameObject, true)
    setactive(self.mTrans_Stars, false)
end

function UICommonItemL:SetItemData(id, num ,needItemCount, needGetWay, tipsCount)
    needGetWay = needGetWay == true and true or false
    needItemCount = needItemCount == true and true or false

    self.itemId = id
    self.itemCount = num
    local stcData = TableData.GetItemData(id)
    self.mImage_Icon.sprite = IconUtils.GetItemIconSprite(stcData.id)
    self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(stcData.rank)

    if needItemCount then
        local itemOwn = 0
        if(stcData.type == 1) then
            itemOwn = NetCmdItemData:GetResItemCount(id)
        else
            itemOwn = NetCmdItemData:GetItemCount(id)
        end
        
        if(itemOwn < num) then
            self.mText_Count.text = "<color=red>"..itemOwn.."</color>/"..num
            self.isItemEnough = false
        else
            self.mText_Count.text = itemOwn.."/"..num
            self.isItemEnough = true
        end

        tipsCount = itemOwn
    else
        self.mText_Count.text = num
    end

    setactive(self.mTrans_Lock, false)
    setactive(self.mTrans_Stars, false)
    setactive(self.mTrans_Equip, false)
    setactive(self.mTrans_Equiped, false)
    setactive(self.mImage_Icon.gameObject, true)

    TipsManager.Add(self.mBtn_Select.gameObject, stcData, tipsCount, needGetWay)
end

function UICommonItemL:SetWeaponData(data, callback)
    self.mData = data

    self.mImage_Icon.sprite = IconUtils.GetWeaponSprite(data.icon)
    self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(data.rank)
    self.mText_Count.text = "lv." .. data.level
    self:SetSelect(data.isChoose)
    self:SetStar(data.rank)
    self:SetGun(data.gunId)

    setactive(self.mTrans_Lock, data.isLock)
    setactive(self.mTrans_Stars, true)
    setactive(self.mTrans_Equip, false)
    setactive(self.mImage_Icon.gameObject, true)

    UIUtils.GetButtonListener(self.mBtn_Select.gameObject).onClick = function()
        if callback then callback(self) end
    end
end

function UICommonItemL:SetEquipData(data, callback)
    self.mData = data

    local rankColor = TableData.GetGlobalGun_Quality_Color2(data.rank)
    self.mImage_Rank.color = rankColor
    self.mText_Count.text = "lv." .. data.level
    self.mImage_EquipIcon.sprite = IconUtils.GetEquipSprite(data.icon .. "_1")
    self.mImage_EquipBase.color = rankColor
    self.mText_Index.text = data.category
    self:SetSelect(data.isChoose)
    self:SetStar(data.rank)
    self:SetGun(data.gunId)

    setactive(self.mTrans_Lock, data.isLock)
    setactive(self.mTrans_Stars, true)
    setactive(self.mTrans_Equip, true)
    setactive(self.mImage_Icon.gameObject, false)

    UIUtils.GetButtonListener(self.mBtn_Select.gameObject).onClick = function()
        if callback then callback(self) end
    end
end

function UICommonItemL:SetSelect(isSelect)
    setactive(self.mTrans_Select, isSelect)
end

function UICommonItemL:SetStar(rank)
    for i = 1, #self.starList do
        setactive(self.starList[i], rank >= i)
    end
end

function UICommonItemL:IsItemEnough()
    return self.isItemEnough
end

function UICommonItemL:SetGun(gunId)
    setactive(self.mTrans_Equiped, gunId ~= 0)
    if gunId ~= 0 then
        local gunData = TableData.listGunDatas:GetDataById(gunId)
        self.mImage_GunIcon.sprite = IconUtils.GetCharacterHeadSprite(gunData.code)
    end
end