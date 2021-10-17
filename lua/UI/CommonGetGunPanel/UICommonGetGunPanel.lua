require("UI.UIBasePanel")

UICommonGetGunPanel = class("UICommonGetGunPanel", UIBasePanel)
UICommonGetGunPanel.__index = UICommonGetGunPanel

UICommonGetGunPanel.itemList = {}
UICommonGetGunPanel.gunData = nil
UICommonGetGunPanel.callback = nil
UICommonGetGunPanel.gunType = 1
UICommonGetGunPanel.isLoading = false
UICommonGetGunPanel.needSkip = false

UICommonGetGunPanel.GunType =
{
    Item = 1,
    Gun = 2,
}

--- static func ---
function UICommonGetGunPanel.OpenGetGunPanel(data, callback, type, needSkip)
    UIManager.OpenUIByParam(UIDef.UICommonGetGunPanel, {data, callback, type, needSkip})
end
--- static func ---

function UICommonGetGunPanel:ctor()
    UICommonGetGunPanel.super.ctor(self)
end

function UICommonGetGunPanel.ShowNextPage()
    self = UICommonGetGunPanel
    if self.isLoading then
        return
    end
    self.isSkippedWeapon = false
    self.isChrSkipped = false

    table.remove(self.itemList, 1)
    if #self.itemList > 0 then
        self.mView.mItem_GunContent.audio:Stop()
        self.mView.mItem_WeaponContent.audio:Stop()
        setactive(self.mView.mUIRoot, false)
        UICommonGetGunPanel.OnShow()
    else
        UIManager.CloseUI(UIDef.UICommonGetGunPanel)
        if UICommonGetGunPanel.callback ~= nil then
            UICommonGetGunPanel.callback()
            UICommonGetGunPanel.callback = nil
        end
    end
end

function UICommonGetGunPanel.Close()
    UIManager.CloseUI(UIDef.UICommonGetGunPanel)
    if UICommonGetGunPanel.callback ~= nil then
        UICommonGetGunPanel.callback()
        UICommonGetGunPanel.callback = nil
    end
end

function UICommonGetGunPanel.OnRelease()
    self = UICommonGetGunPanel
    UICommonGetGunPanel.itemList = {}
    UICommonGetGunPanel.effectList = {}
    UICommonGetGunPanel.curEffect = nil
end

function UICommonGetGunPanel.Init(root, data)
    self = UICommonGetGunPanel

    UICommonGetGunPanel.super.SetRoot(UICommonGetGunPanel, root)

    self.mHideFlag = true
    self.callback = data[2]
    self.gunType = data[3] == nil and UICommonGetGunPanel.GunType.Item or data[3]
    if data[4] == nil then
        self.needSkip = false
    else
        self.needSkip = data[4]
    end

    if self.gunType == UICommonGetGunPanel.GunType.Item then
        local dataList = data[1]
        for i = 0, dataList.Length - 1 do
            local item = dataList[i]
            table.insert(self.itemList, item)
        end
    else
        self.gunData = TableData.listGunDatas:GetDataById(tonumber(data[1]))
    end

    UICommonGetGunPanel.mView = UICommonGetGunPanelView.New()
    UICommonGetGunPanel.mView:InitCtrl(root)
    if CS.GameRoot.Instance then
        if CS.GameRoot.Instance.AdapterPlatform == CS.PlatformSetting.PlatformType.PC then
            UISystem.rootCanvasTrans:GetComponent("CanvasScaler").matchWidthOrHeight = 1
            local targetWidth = 1600
            local targetHeight = 900
            local currentHeight = 720
            self.mView.mTrans_BtnSkip.anchorMin = vector2zero
            self.mView.mTrans_BtnSkip.anchorMax = vector2zero
            self.mView.mTrans_BtnSkip.sizeDelta = Vector2(targetWidth, targetHeight);
            self.mView.mTrans_BtnSkip.localScale = vectorone * currentHeight / targetHeight
        end
    end
    setactive(self.mView.mItem_Skip.btnSkip.gameObject, self.needSkip)
end

function UICommonGetGunPanel.OnInit()
    self = UICommonGetGunPanel

    UIUtils.GetButtonListener(self.mView.mItem_Skip.btnSkip.gameObject).onClick = function()
        UICommonGetGunPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mItem_Skip.btnClose.gameObject).onClick = self.OnSkip
end

function UICommonGetGunPanel.OnSkip()
    self = UICommonGetGunPanel
    if self.gunType == UICommonGetGunPanel.GunType.Gun or self.itemData and self.itemData.type ~= GlobalConfig.ItemType.Weapon then
        if self.isChrSkipped then
            UICommonGetGunPanel.ShowNextPage()
        else
            self.isChrSkipped = true
            local resultBg = self.mView.bgJump:JumpTo()
            local resultChr = self.mView.chrJump:JumpTo()
            if not resultBg and not resultChr then
                UICommonGetGunPanel.ShowNextPage()
            end
        end
    else
        if self.isSkippedWeapon then
            UICommonGetGunPanel.ShowNextPage()
        else
            self.isSkippedWeapon = true
            local resultBg = self.mView.bgJump:JumpTo()
            local resultWeapon = self.mView.weaponJump:JumpTo()
            if not resultBg and not resultWeapon then
                UICommonGetGunPanel.ShowNextPage()
            end
        end
    end
end

function UICommonGetGunPanel.OnShow()
    self = UICommonGetGunPanel
    setactive(self.mView.mUIRoot.gameObject, true)
    self:UpdatePanel()
end

function UICommonGetGunPanel:UpdatePanel()
    if self.gunType == UICommonGetGunPanel.GunType.Item then
        local item = self.itemList[1]
        self:UpdateItemPanel(item)
    else
        self:UpdateGunContent(self.gunData)
        setactive(self.mView.mItem_GunContent.gameObject, true)
        setactive(self.mView.mItem_WeaponContent.gameObject, false)
    end
end

function UICommonGetGunPanel:UpdateItemPanel(data)
    if data == nil then
        return;
    end
    local itemData = TableData.GetItemData(data.ItemId)
    setactive(self.mView.mItem_GunContent.gameObject, itemData.type == GlobalConfig.ItemType.GunType)
    setactive(self.mView.mItem_WeaponContent.gameObject, itemData.type == GlobalConfig.ItemType.Weapon)
    if itemData.type == GlobalConfig.ItemType.Weapon then
        local weaponData = TableData.listGunWeaponDatas:GetDataById(itemData.args[0])
        self:UpdateWeaponContent(weaponData)
        setactive(self.mView.mItem_WeaponContent.transNew, NetCmdIllustrationData:CheckItemIsFirstTime(itemData.type, weaponData.id, true))
        setactive(self.mView.mItem_ExtraGet.gameObject, false)
    elseif itemData.type == GlobalConfig.ItemType.GunType then
        local gunData = TableData.listGunDatas:GetDataById(itemData.args[0])
        local isFirst = NetCmdIllustrationData:CheckItemIsFirstTime(itemData.type, gunData.id, true)
        self:UpdateGunContent(gunData)
        if not isFirst then
            self:UpdateItemList(gunData.sold_get1)
        end
        setactive(self.mView.mItem_GunContent.transNew, isFirst)
        setactive(self.mView.mItem_ExtraGet.gameObject, not isFirst)
    end
    self.itemData = itemData
end

function UICommonGetGunPanel:UpdateGunContent(gunData)
    if gunData then
        local characterData = TableData.listGunCharacterDatas:GetDataById(gunData.character_id)
        local dutyData = TableData.listGunDutyDatas:GetDataById(gunData.duty)
        self.mView.mItem_GunContent.imgIcon1.sprite = IconUtils.GetGunCharacterIcon("Icon_Character_" .. characterData.en_name)
        self.mView.mItem_GunContent.imgIcon2.sprite = IconUtils.GetGunCharacterIcon("Icon_Character_" .. characterData.en_name .. "_W")
        self.mView.mItem_GunContent.txtBody.text = characterData.body_id.str
        self.mView.mItem_GunContent.txtBrand.text = characterData.brand.str
        self.mView.mItem_GunContent.txtName.text = gunData.name.str
        self.mView.mItem_GunContent.imgAvatar.sprite = IconUtils.GetCharacterWholeSprite(gunData.code)
        self.mView.mItem_GunContent.imgQuality.color = TableData.GetGlobalGun_Quality_Color2(gunData.rank)
        self.mView.mItem_GunContent.imgFlower.color = TableData.GetGlobalGun_Quality_Color1(gunData.rank)
        self.mView.mItem_GunContent.imgLodingIcon.sprite = IconUtils.GetGunCharacterIcon("Icon_Character_" .. characterData.en_name .. "_W")
        self.mView.mItem_GunContent.imgLodingBg.color = ColorUtils.StringToColor(characterData.color)
        self.mView.mItem_GunContent.txtDialog.text = gunData.dialogue.str
        self.mView.mItem_GunContent.imgDutyIcon.sprite = IconUtils.GetGunTypeSprite(dutyData.icon)
        self.mView.mItem_GunContent.animator:SetInteger("Color", gunData.rank)
        setactive(self.mView.mItem_ExtraGet.gameObject, false)

        local starCount = TableData.GlobalSystemData.QualityStar[gunData.rank - 1]
        for i, star in ipairs(self.mView.mItem_GunContent.starList) do
            setactive(star, i <= starCount)
        end
        self.mView.animator:SetInteger("BGFadeIn", 0)
        self.mView.animator:Play("Chr_FadeIn", 1, 0)
    end
end

function UICommonGetGunPanel:UpdateWeaponContent(weaponData)
    local weaponTypeData = TableData.listGunWeaponTypeDatas:GetDataById(weaponData.type)
    local elementData = TableData.listLanguageElementDatas:GetDataById(weaponData.element)
    self.mView.mItem_WeaponContent.txtName.text = weaponData.name.str
    self.mView.mItem_WeaponContent.imgQuality.color = TableData.GetGlobalGun_Quality_Color2(weaponData.rank)
    self.mView.mItem_WeaponContent.imgFlower.color = TableData.GetGlobalGun_Quality_Color1(weaponData.rank)
    self.mView.mItem_WeaponContent.imgAvatar.sprite = IconUtils.GetWeaponSpriteL(weaponData.res_code)
    self.mView.mItem_WeaponContent.imgIcon.sprite = IconUtils.GetGunCharacterIcon(weaponTypeData.icon)
    self.mView.mItem_WeaponContent.txtType.text = weaponTypeData.name.str
    self.mView.mItem_WeaponContent.animator:SetInteger("Color", weaponData.rank)
    self.mView.mItem_WeaponContent.imgElementIcon.sprite = IconUtils.GetElementIcon(elementData.icon)
    local starCount = TableData.GlobalSystemData.QualityStar[weaponData.rank - 1]
    for i, star in ipairs(self.mView.mItem_WeaponContent.starList) do
        setactive(star, i <= starCount)
    end
    self.mView.animator:SetInteger("BGFadeIn", 1)
    self.mView.animator:Play("Weapon_FadeIn", 1, 0)
end

function UICommonGetGunPanel:SetGunRank(rank)
    if rank then
        for i = 1, #self.mView.starList do
            setactive(self.mView.starList[i], i <= rank)
        end
    end
end

function UICommonGetGunPanel:UpdateItemList(itemDataList)
    local item = {}
    for itemId, num in pairs(itemDataList) do
        item.id = itemId
        item.num = num
    end
    local itemData = TableData.listItemDatas:GetDataById(item.id)
    self.mView.mItem_ExtraGet.imgIcon.sprite = IconUtils.GetItemIconSprite(item.id)
    self.mView.mItem_ExtraGet.txtNum.text = item.num
    self.mView.mItem_ExtraGet.txtName.text = itemData.name.str
end




