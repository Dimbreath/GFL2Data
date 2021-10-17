require("UI.UIBaseCtrl")
require("UI.Common.UICommonGetWayItem")

UICommonGetWayTitleItem = class("UICommonGetWayTitleItem", UIBaseCtrl)
UICommonGetWayTitleItem.__index = UICommonGetWayTitleItem
--@@ GF Auto Gen Block Begin
UICommonGetWayTitleItem.mText_HowToGetTypeText = nil
UICommonGetWayTitleItem.getWayUpperLimit = nil

function UICommonGetWayTitleItem:__InitCtrl()
    self.mText_HowToGetTypeText = self:GetText("HowToGetType/Text_Titlename")
    self.mTrans_HowToGetList = self:GetRectTransform("HowToGetList")
end

--@@ GF Auto Gen Block End

function UICommonGetWayTitleItem:ctor()
    UICommonGetWayTitleItem.super.ctor(self)

    self.getWayUpperLimit = TableData.GlobalSystemData.GetwayStoryUpperlimit
    self.infoList = {}
end

function UICommonGetWayTitleItem:InitCtrl(parent)
    local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonGetWayTitleItem.prefab",self));
    setparent(parent, obj.transform)
    obj.transform.localScale=vectorone
    obj.transform.localPosition =vectorone

    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UICommonGetWayTitleItem:SetData(data)
    if data then
        self.mText_HowToGetTypeText.text = data.title
        if data.getList then
            local getList = data.getList
            if data.type == 9 then
                getList = self:FilterChapterItem(data.getList)
            end
            for _, item in ipairs(self.infoList) do
                item:SetData(nil)
            end

            for i, howToGet in ipairs(getList) do
                local item = nil
                if i <= #self.infoList then
                    item = self.infoList[i]
                else
                    item = UICommonGetWayItem.New()
                    item:InitCtrl(self.mTrans_HowToGetList)
                    table.insert(self.infoList, item)
                end
                data.howToGetData = howToGet
                item:SetData(data)
            end
        end
        setactive(self.mUIRoot.gameObject, true)
    else
        setactive(self.mUIRoot.gameObject, false)
    end
end

function UICommonGetWayTitleItem:FilterChapterItem(list)
    local showList = {}
    for i, itemData in ipairs(list) do
        local item = {}
        item.isUnLock = self:CheckIsUnLock(itemData.jump_code)
        item.data = itemData

        if i <= self.getWayUpperLimit then
            table.insert(showList, item)
        else
            if item.isUnLock then
                table.remove(showList, 1)
                table.insert(showList, item)
            else
                break
            end
        end
    end

    table.sort(showList, function (a, b)
        local tValueA, tValueB
        tValueA, tValueB = (a.isUnLock == true or false), (b.isUnLock == true or false)
        if tValueA ~= tValueB then
            if tValueA then
                return true
            else
                return false
            end
        else
            if tValueA then
                return a.data.id > b.data.id
            else
                return a.data.id < b.data.id
            end
        end
    end)

    local list = {}
    for _, v in ipairs(showList) do
        table.insert(list, v.data)
    end

    return list
end

function UICommonGetWayTitleItem:CheckIsUnLock(jump_code)
    local jumpData = string.split(jump_code, ":")
    if tonumber(jumpData[1]) == 1 then
        --- 判断章节是否解锁
        return NetCmdDungeonData:IsUnLockChapter(jumpData[2])
    elseif tonumber(jumpData[1]) == 14 then
        --- 判断关卡是否解锁
        local chapterId = TableData.listStoryDatas:GetDataById(tonumber(jumpData[2])).chapter
        if NetCmdDungeonData:IsUnLockChapter(chapterId) then
            return NetCmdDungeonData:IsUnLockStory(jumpData[2])
        end
        return false
        --elseif tonumber(jumpData[1]) == 5 then
        --    local good = NetCmdStoreData:GetStoreGoodById(self.goodId)
        --    if not good then
        --        return false
        --    end
    end
    return true
end