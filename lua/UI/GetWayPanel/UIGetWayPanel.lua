require("UI.UIBasePanel")


UIGetWayPanel = class("UIGetWayPanel", UIBasePanel)
UIGetWayPanel.__index = UIGetWayPanel

UIGetWayPanel.mView = nil
UIGetWayPanel.mData = nil
UIGetWayPanel.mItemGetlist = nil;

function UIGetWayPanel:ctor()
    UIGetWayPanel.super.ctor(self)
end

function UIGetWayPanel.Open()
    UIGetWayPanel.OpenUI(UIDef.UIGetWayPanel)
end

function UIGetWayPanel.Close()
    UIManager.CloseUI(UIDef.UIGetWayPanel)
end

function UIGetWayPanel.Init(root,data)
    self = UIGetWayPanel
    UIGetWayPanel.super.SetRoot(UIGetWayPanel, root)
    self.mData = data
    self.mIsPop = true
end

function UIGetWayPanel.OnInit()
    self = UIGetWayPanel

    self.mView = UIGetWayPanelView.New()
    self.mView:InitCtrl(self.mUIRoot)

    
    UIUtils.GetButtonListener(self.mView.mBtn_Cancel.gameObject).onClick = function()
        UIGetWayPanel:OnClose()
    end

    UIUtils.GetListener(self.mView.mBtn_BGCloseButton.gameObject).onClick = function()
        UIGetWayPanel:OnClose()
    end
    MessageSys:AddListener(CS.GF2.Message.UIEvent.MergeEquipJump, UIGetWayPanel.OnClose)
    self:InitVirtualList();
    
    self:SetData(self.mData)
    self:UpdatePanel()
end

function UIGetWayPanel.OnShow()
    self = UIGetWayPanel
end

function UIGetWayPanel.OnRelease()
    self = UIGetWayPanel
    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.MergeEquipJump, UIGetWayPanel.OnClose)
    UIGetWayPanel.mData = nil
    UIGetWayPanel.mItemGetlist = nil;
end

function UIGetWayPanel:UpdatePanel()
    
end


function UIGetWayPanel:OnClose()
    self = UIGetWayPanel;
    self:Close();
end


function UIGetWayPanel:SetData(item)
    local itemData = TableData.listItemDatas:GetDataById(item.itemId);
    self.mView.mText_OwnerNum.text = tostring(NetCmdItemData:GetResCount(item.itemId))
    self.mView.mImage_IconImage.sprite = IconUtils.GetItemSprite(itemData.icon)
    self.mView.mImage_GoodsRate.color = TableData.GetGlobalGun_Quality_Color2(itemData.rank)
    self.mView.mText_ItemName.text = itemData.name.str;


    local getList = string.split(itemData.get_list, ",")
    local itemDataList = self:GetItemGetType(getList)

   
    self.mItemGetlist = {};
    for key, list in pairs(itemDataList) do
        printstack(key)

        local itemHowToGetData = TableData.listItemHowToGetDatas:GetDataById(key)
        for k,v in pairs(list) do
            local dataParam =
            {
                title = itemHowToGetData.title.str,
                type = key,
                getList = v,
                itemData = itemData,
                howToGetData = v,
                root = self
            }
            table.insert(self.mItemGetlist,dataParam)
        end
        
        --UIUtils.ForceRebuildLayout(self.mCurContent.transGetWayList)
    end
    
    self.mView.mVirtualList.numItems = #self.mItemGetlist
    self.mView.mVirtualList:Refresh()
    
end

function UIGetWayPanel:InitVirtualList()
    self.mView.mVirtualList.itemProvider = function()
        local item = self:ItemProvider()
        return item
    end

    self.mView.mVirtualList.itemRenderer = function(index, renderDataItem)
        self:ItemRenderer(index, renderDataItem)
    end
end

function UIGetWayPanel:ItemProvider()
    local itemView = UICommonGetWayItem.New()
    itemView:InitCtrlNoPara()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView.mUIRoot.gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIGetWayPanel:ItemRenderer(index, renderDataItem)
    local itemData = self.mItemGetlist[index+1]
    local item = renderDataItem.data
    item:SetData(itemData)

end


function UIGetWayPanel:GetItemGetType(getList)
    local typeList = {}
    local getWayStoryUpperLimit  = TableData.GlobalSystemData.GetwayStoryUpperlimit
    if getList ~= "" then
        for _, item in ipairs(getList) do
            if item ~= "" then
               
                local getListData = TableData.listItemGetListDatas:GetDataById(tonumber(item))
                if getListData then
                    if typeList[getListData.type] == nil then
                        typeList[getListData.type] = {}
                    end
                    table.insert(typeList[getListData.type], getListData)
                end
            end
        end
    end

    if typeList[9] ~= nil and #typeList[9] > getWayStoryUpperLimit then
        table.sort(typeList[9], function (a, b)
            local tValueA, tValueB
            tValueA, tValueB = (
                    self:CheckIsUnLock(a.jump_code) == true or false), ( self:CheckIsUnLock(b.jump_code)  == true or false)
            if tValueA ~= tValueB then
                if tValueA then
                    return true
                else
                    return false
                end
            else
                if tValueA then
                    return a.id > b.id
                else
                    return a.id < b.id
                end
            end
        end)

        local typeListJumpLevel = {}
        for i=1,  getWayStoryUpperLimit do
            table.insert(typeListJumpLevel, typeList[9][i])
        end
        typeList[9] = typeListJumpLevel
    end
    


    return typeList
end


function UIGetWayPanel:CheckIsUnLock(jump_code)
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





