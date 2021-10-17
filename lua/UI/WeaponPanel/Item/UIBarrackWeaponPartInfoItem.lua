require("UI.UIBaseCtrl")

UIBarrackWeaponPartInfoItem = class("UIBarrackWeaponPartInfoItem", UIBaseCtrl)
UIBarrackWeaponPartInfoItem.__index = UIBarrackWeaponPartInfoItem

function UIBarrackWeaponPartInfoItem:ctor()
    UIBarrackWeaponPartInfoItem.super.ctor(self)
    self.data = nil
    self.lockCallback = nil
    self.skill = nil
    self.attribute = nil
    self.elementItem = nil
    self.stageItem = nil
end

function UIBarrackWeaponPartInfoItem:__InitCtrl()
    self.mText_Name = self:GetText("GrpWeaponPartsInfo/GrpTextName/Text_Name")
    self.mImage_Rank = self:GetImage("AttributeList/Viewport/Content/GrpLine/Img_Line")
    self.mText_Type = self:GetText("GrpWeaponPartsInfo/GrpType/Text_Name")
    self.mTrans_AttrList = self:GetRectTransform("AttributeList/Viewport/Content/GrpAttribute")

    self.skill = UIWeaponSkillItem.New()
    self.skill:InitCtrl(self:GetRectTransform("AttributeList/Viewport/Content/GrpSkill"))
    self.skill:EnableSkillIcon(true)
    self.skill:EnableInfoBtn(false)

    self.attribute = UICommonPropertyItem.New()
    self.attribute:InitCtrl(self.mTrans_AttrList)

    self:InitLockItem()

    UIUtils.GetButtonListener(self.mBtn_Lock.gameObject).onClick = function()
        self:OnClickLock()
    end
end

function UIBarrackWeaponPartInfoItem:InitLockItem()
    local parent = self:GetRectTransform("GrpWeaponPartsInfo/GrpLock")
    local obj = self:InstanceUIPrefab("UICommonFramework/ComLockItemV2.prefab", parent, true)
    self.mBtn_Lock = UIUtils.GetButton(obj)
    self.mTrans_Lock = UIUtils.GetRectTransform(obj, "ImgLocked")
    self.mTrans_Unlock = UIUtils.GetRectTransform(obj, "ImgUnLocked")
end


function UIBarrackWeaponPartInfoItem:OnClickLock()
    NetCmdWeaponPartsData:ReqWeaponPartLockUnlock(self.data.id, function()
        if self.lockCallback ~= nil then
            self.lockCallback(self.data.id, self.data.IsLocked)
        end
        self:UpdateLockStatue()
    end)
end

function UIBarrackWeaponPartInfoItem:UpdateLockStatue()
    setactive(self.mTrans_Unlock, not self.data.IsLocked)
    setactive(self.mTrans_Lock, self.data.IsLocked)
end

function UIBarrackWeaponPartInfoItem:InitCtrl(root, lockCallback)
    self:SetRoot(root)
    self:__InitCtrl()

    self.lockCallback = lockCallback
end

function UIBarrackWeaponPartInfoItem:SetData(data)
    if data then
        self.data = data
        local typeData = TableData.listWeaponPartTypeDatas:GetDataById(data.type)
        self.mText_Name.text = data.name
        self.mText_Type.text = typeData.name
        self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(data.rank)
        self:UpdateLockStatue()
        self:UpdateAttribute()
        self.skill:SetDataBySkillData(data.affixSkill, true)
        self.skill:SetLevel(data.affixLevel)
        setactive(self.mUIRoot, true)
    else
        setactive(self.mUIRoot, false)
    end
end

function UIBarrackWeaponPartInfoItem:UpdateStar(star, maxStar)
    self.stageItem:ResetMaxNum(maxStar)
    self.stageItem:SetData(star)
end

function UIBarrackWeaponPartInfoItem:UpdateAttribute()
    self.attribute:SetDataByName(self.data.attribute, self.data.attributeValue, true, false, false)
end