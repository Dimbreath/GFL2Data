require("UI.UIBaseCtrl")
---@class UIWeaponListContent : UIBaseCtrl

UIWeaponListContent = class("UIWeaponListContent", UIBaseCtrl)
UIWeaponListContent.__index = UIWeaponListContent

function UIWeaponListContent:ctor()
    self.sortList = {}
    self.sortContent = nil
    self.pointer = nil
end

function UIWeaponListContent:__InitCtrl()
    self.mBtn_CloseList = UIUtils.GetTempBtn(self:GetRectTransform("GrpClose/BtnBack"))
    self.mBtn_AutoSelect = UIUtils.GetTempBtn(self:GetRectTransform("GrpAction/BtnSelect"))
    self.mTrans_Sort = self:GetRectTransform("GrpAction/GrpScreen/BtnScreen")
    self.mTrans_SortList = self:GetRectTransform("GrpAction/GrpScreen/Trans_GrpScreenList")
    self.mTrans_WeaponScroll = self:GetRectTransform("Trans_GrpWeaponList")
    self.mTrans_ItemBrief = self:GetRectTransform("Trans_GrpWeaponInfo")
    self.mTrans_AutoSelect = self:GetRectTransform("GrpAction/BtnSelect")
    self.mTrans_Empty = self:GetRectTransform("Trans_GrpEmpty")
    self.mVirtualList = UIUtils.GetVirtualList(self.mTrans_WeaponScroll)
    self.mListAnimator = UIUtils.GetAnimator(self.mUIRoot)
    self.mListAniTime = UIUtils.GetAnimatorTime(self.mUIRoot)
end

function UIWeaponListContent:InitCtrl(obj)
    self:SetRoot(obj.transform)
    self:__InitCtrl()

    self:InitSortContent()
end

function UIWeaponListContent:InitSortContent()
    if self.sortContent == nil then
        self.sortContent = UIWeaponSortItem.New()
        self.sortContent:InitCtrl(self.mTrans_Sort)

        UIUtils.GetButtonListener(self.sortContent.mBtn_Sort.gameObject).onClick = function()
            self:OnClickSortList()
        end
    end

    local sortList = self:InstanceUIPrefab("UICommonFramework/ComScreenDropdownListItemV2.prefab", self.mTrans_SortList)
    local parent = UIUtils.GetRectTransform(sortList, "Content")
    for i = 1, 3 do
        local obj = self:InstanceUIPrefab("Character/ChrEquipSuitDropdownItemV2.prefab", parent)
        if obj then
            local sort = {}
            sort.obj = obj
            sort.btnSort = UIUtils.GetButton(obj)
            sort.txtName = UIUtils.GetText(obj, "GrpText/Text_SuitName")

            table.insert(self.sortList, sort)
        end
    end

    UIUtils.GetUIBlockHelper(self.mUIRoot, self.mTrans_SortList, function ()
        self:CloseItemSort()
    end)
end

function UIWeaponListContent:OnClickSortList()
    setactive(self.mTrans_SortList, true)
end

function UIWeaponListContent:CloseItemSort()
    setactive(self.mTrans_SortList, false)
end
