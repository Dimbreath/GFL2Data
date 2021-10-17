require("UI.UIBaseCtrl")

NRTPVPGunItem = class("NRTPVPGunItem", UIBaseCtrl)
NRTPVPGunItem.__index = NRTPVPGunItem

function NRTPVPGunItem:ctor()
    self.starList = {}
end

function NRTPVPGunItem:__InitCtrl()
    self.mBtn_OpenDetail = self:GetButton("Root/Btn_OpenDetail")
    self.mImage_Icon = self:GetImage("Root/HeadMask/Image_CharacterPic")
    self.mText_Level = self:GetText("Root/Detail/Text_Level")
    self.mImage_Element = self:GetImage("Root/Detail/Image_Attribute")
    self.mImage_Rank = self:GetImage("Root/Detail/Image_GunColor")

    for i = 1, UIPVPGlobal.GunMaxStar do
        local obj = self:GetRectTransform("Root/Detail/Trans_GradeDetail/Trans_Star" .. i)
        table.insert(self.starList, obj)
    end
end
--@@ GF Auto Gen Block End

function NRTPVPGunItem:InitCtrl(parent)
    local itemPrefab = UIUtils.GetGizmosPrefab("PVP/UINRTPVPGunItem.prefab",self);
    local instObj = instantiate(itemPrefab)

    UIUtils.AddListItem(instObj.gameObject, parent.gameObject)

    self:SetRoot(instObj.transform)
    self:__InitCtrl()
end


function NRTPVPGunItem:SetData(data)
    self.data = data
    if data then
        local gunData = TableData.listGunDatas:GetDataById(data.Id)
        local elementData = TableData.listLanguageElementDatas:GetDataById(gunData.element)
        self.mText_Level.text = data.Level
        self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color1(gunData.rank)
        self.mImage_Icon.sprite = IconUtils.GetCharacterHeadSprite(gunData.code)
        self.mImage_Element.sprite = IconUtils.GetElementIcon(elementData.icon .. "_M")
        self:SetGunRank(data.Grade)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function NRTPVPGunItem:SetGunRank(rank)
    if rank then
        for i = 1, #self.starList do
            setactive(self.starList[i], i <= rank)
        end
    end
end
