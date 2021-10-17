require("UI.UIBaseCtrl")
---@class UIWeaponPartSortItem : UIBaseCtrl

UIWeaponPartSortItem = class("UIWeaponPartSortItem", UIBaseCtrl)
UIWeaponPartSortItem.__index = UIWeaponPartSortItem

function UIWeaponPartSortItem:ctor()
    self.curSort = nil
    self.sortFunc = nil
end

function UIWeaponPartSortItem:__InitCtrl()
    self.mBtn_Sort = self:GetButton("Btn_Dropdown")
    self.mBtn_Ascend = self:GetButton("Btn_Screen")
    self.mText_SortName = self:GetText("Btn_Dropdown/Text_SuitName")
end

function UIWeaponPartSortItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComScreenItemV2.prefab", self))
    if parent then
        CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
    end

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIWeaponPartSortItem:SetData(data)
    self.curSort = data
    self.mText_SortName.text = TableData.GetHintById(data.hintID)
    self.sortFunc = self:GetSortFunc(1, self.curSort.sortCfg, self.curSort.isAscend)
end

function UIWeaponPartSortItem:GetSortFunc(tabIndex, sortCfg, isAscend)
    isAscend = isAscend ~= false and true or false
    self.curGunId = self.curGunId ~= 0 and self.curGunId or 0
    local tArrRefer   = sortCfg
    local tLength     = #tArrRefer
    --无需组排序或者参数有误
    if tLength == 0 or tabIndex < 1 or tabIndex > tLength then
        return nil
    end
    local function compareFunction(a1, a2, index)
        if index <= tLength then
            local attrName = tArrRefer[index]
            if index <= tLength then
                if a1[attrName] < a2[attrName] then
                    return isAscend
                elseif a1[attrName] > a2[attrName] then
                    return not isAscend
                else
                    return compareFunction(a1, a2, index + 1)
                end
            else
                return false
            end
        end
        return false
    end
    return function (a1, a2)
        return compareFunction(a1, a2, tabIndex)
    end
end