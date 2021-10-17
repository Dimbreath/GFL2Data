require("UI.UIBaseCtrl")

UIEquipMaterialItemS = class("UIEquipMaterialItemS", UIBaseCtrl)
UIEquipMaterialItemS.__index = UIEquipMaterialItemS

function UIEquipMaterialItemS:ctor()
    self.mData = nil
end

function UIEquipMaterialItemS:__InitCtrl()
    self.mBtn_Item = self:GetSelfButton()
    self.mImage_Icon = self:GetImage("GrpItem/Img_Item")
    self.mText_Count = self:GetText("Trans_GrpNum/ImgBg/Text_Num")
    self.mImage_Rank = self:GetImage("GrpBg/Img_Bg")
    self.mTrans_EquipIndex = self:GetRectTransform("Trans_GrpEquipNum")
    self.mImage_EquipIndex = self:GetImage("Trans_GrpEquipNum/Img_Icon")
end

function UIEquipMaterialItemS:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab", self))
    CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIEquipMaterialItemS:InitObj(obj)
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIEquipMaterialItemS:SetData(data)
    if data then
        self.mData = data
        self.mImage_Rank.sprite = IconUtils.GetQuiltyByRank(data.rank)
        if data.type == UIEquipGlobal.MaterialType.Item then
            self.mImage_Icon.sprite = IconUtils.GetItemIconSprite(data.id)
            self.mText_Count.text = 1
        elseif data.type == UIEquipGlobal.MaterialType.Equip then
            local rankColor = TableData.GetGlobalGun_Quality_Color2(data.rank)
            self.mImage_Icon.sprite = IconUtils.GetEquipSprite(data.icon .. "_1")
            self.mImage_EquipIndex.sprite = IconUtils.GetEquipNum(data.category, true)
            self.mText_Count.text = "Lv." .. data.level
        end
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end
