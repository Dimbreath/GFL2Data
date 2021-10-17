require("UI.UIBasePanel")
require("UI.FriendPanel.UIPlayerInfoPanel")
require("UI.FriendPanel.Item.UIFriendsListItem")
---@class UIFriendPanel : UIBasePanel

UIFriendPanel = class("UIFriendPanel", UIBasePanel)
UIFriendPanel.__index = UIFriendPanel

UIFriendPanel.mPath_UIFriendsListItem = "Friend/UIFriendsListItem.prefab"

UIFriendPanel.mView = nil
UIFriendPanel.curTag = nil
UIFriendPanel.curSort = nil
UIFriendPanel.tagList = {}
UIFriendPanel.sortList = {}
UIFriendPanel.friendList = {}
UIFriendPanel.canRefreshRecommend = true
UIFriendPanel.timer = 0
UIFriendPanel.refreshTime = 0
UIFriendPanel.pointer = nil
UIFriendPanel.sortContent = nil
UIFriendPanel.sortList = {}

UIFriendPanel.RedPointType = {RedPointConst.ApplyFriend}

function UIFriendPanel:ctor()
    UIFriendPanel.super.ctor(self)
end

function UIFriendPanel.Open()
    UIFriendPanel.OpenUI(UIDef.UIFriendPanel)
end

function UIFriendPanel.Close()
    UIManager.CloseUI(UIDef.UIFriendPanel)
end

function UIFriendPanel.OnRelease()
    UIFriendPanel.curTag = nil
    UIFriendPanel.tagList = {}
    UIFriendPanel.sortList = {}
    UIFriendPanel.friendList = {}
    UIFriendPanel.timer = 0
    UIFriendPanel.canRefreshRecommend = true
    UIFriendPanel.pointer = nil
    UIFriendPanel.sortContent = nil
    UIFriendPanel.sortList = {}
    UIFriendPanel.curSort = nil

    MessageSys:RemoveListener(CS.GF2.Message.FriendEvent.FriendListChange, UIFriendPanel.OnFriendListChange)
    MessageSys:RemoveListener(CS.GF2.Message.FriendEvent.FriendApproveResult, UIFriendGlobal.OnGetApproveResult)

    RedPointSystem:GetInstance():RemoveRedPointListener(RedPointConst.ApplyFriend)
end

function UIFriendPanel.Init(root)
    UIFriendPanel.super.SetRoot(UIFriendPanel, root)

    self = UIFriendPanel
    self.mView = UIFriendPanelView.New()
    self.mView:InitCtrl(self.mUIRoot)
    self.refreshTime = TableData.GlobalSystemData.FriendRefreshCd
    self.timer = 0
    self.canRefreshRecommend = true
end

function UIFriendPanel.OnInit()
    self = UIFriendPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Return.gameObject).onClick = function()
        UIFriendPanel:OnReturnClicked()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommandCenter.gameObject).onClick = function()
        UIManager.JumpToMainPanel()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Search.gameObject).onClick = function()
        UIFriendPanel:OnSearchFriend()
    end
    --
    UIUtils.GetButtonListener(self.mView.mBtn_RefreshList.gameObject).onClick = function()
        UIFriendPanel:OnRefreshRecommendList()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Past.gameObject).onClick = function()
        UIFriendPanel:OnPastUID()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_BlackList.gameObject).onClick = function()
        UIFriendPanel:OnClickBlackList()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_RefuseAll.gameObject).onClick = function()
        UIFriendPanel:OnRefuseAll()
    end

    MessageSys:AddListener(CS.GF2.Message.FriendEvent.FriendListChange, UIFriendPanel.OnFriendListChange)
    MessageSys:AddListener(CS.GF2.Message.FriendEvent.FriendApproveResult, UIFriendGlobal.OnGetApproveResult)

    self.pointer = UIUtils.GetPointerClickHelper(self.mView.mTrans_Pointer.gameObject, function()
        UIFriendPanel:CloseItemSort()
    end, self.mView.mTrans_SortList.gameObject)

    self:InitTagButton()
    self:InitSortContent()
    self:InitMaxWidht()
    self:OnClickTag(UIFriendGlobal.PanelTag.FriendList)
end

function UIFriendPanel:InitMaxWidht()
    UIFriendGlobal.FriendListTextMaxWidth = UIFriendGlobal:GetTextMaxWidth(self.mView.mTrans_Friend, 1)
    UIFriendGlobal.ApplyListTextMaxWidth = UIFriendGlobal:GetTextMaxWidth(self.mView.mTrans_Apply, 2)
    UIFriendGlobal.AddListTextMaxWidth = UIFriendGlobal:GetTextMaxWidth(self.mView.mTrans_Add, 1)
end

function UIFriendPanel:InitTagButton()
    for i, tagId in ipairs(UIFriendGlobal.PanelTopTab) do
        local tag = UIFriendTabItem.New()
        local list, virtualList, emptyList = self:GetTransListByTag(tagId)
        tag:InitCtrl(self.mView.mTrans_TagList)
        tag:SetData(tagId, list, virtualList, emptyList)
        if tag.tagId == UIFriendGlobal.PanelTag.ApplyFriend then
            tag:InitRedPoint()
            RedPointSystem:GetInstance():AddRedPointListener(RedPointConst.ApplyFriend, tag.mTrans_RedPoint)
            self:UpdateRedPoint()
        end

        UIUtils.GetButtonListener(tag.mBtn_Select.gameObject).onClick = function()
            self:OnClickTag(tagId)
        end

        self.tagList[tagId] = tag
    end
end

function UIFriendPanel:InitSortContent()
    if self.sortContent == nil then
        self.sortContent = UIFriendSortItem.New()
        self.sortContent:InitCtrl(self.mView.mTrans_Sort)

        UIUtils.GetButtonListener(self.sortContent.mBtn_Sort.gameObject).onClick = function()
            UIFriendPanel:OnClickSortList()
        end

        UIUtils.GetButtonListener(self.sortContent.mBtn_Ascend.gameObject).onClick = function()
            UIFriendPanel:OnClickAscend()
        end
    end
    for i = 1, 5 do
        local obj = self:InstanceUIPrefab("Character/ChrEquipSuitDropdownItemV2.prefab", self.mView.mTrans_SortItem)
        if obj then
            local sort = {}
            sort.obj = obj
            sort.btnSort = UIUtils.GetButton(obj)
            sort.txtName = UIUtils.GetText(obj, "GrpText/Text_SuitName")
            sort.sortType = i
            sort.hintID = 100014 + i
            sort.sortCfg = UIFriendGlobal.FriendListSortCfg[i]
            sort.isAscend = true

            sort.txtName.text = TableData.GetHintById(sort.hintID)

            UIUtils.GetButtonListener(sort.btnSort.gameObject).onClick = function()
                self:OnClickSort(sort.sortType)
            end

            table.insert(self.sortList, sort)
        end
    end
end

function UIFriendPanel:OnClickTag(index)
    if index and index > 0 then
        if self.curTag ~= nil and self.curTag.tagId == index then
            return
        end

        local chooseTag = self.tagList[index]
        if index ~= UIFriendGlobal.PanelTag.PersonalInformation then
            local curTag = self.curTag
            if curTag then
                curTag:SetSelect(false)
                curTag:EnableEmpty(false)
                curTag:EnableTransList(false)
            end
            chooseTag:SetSelect(true)
            chooseTag:EnableTransList(true)
            self.curTag = chooseTag
        end
        if self.mView.mAnimator then
            self.mView.mAnimator:SetInteger("SwitchTab", self.curTag.tagId - 1)
        end
        self:UpdatePanelList(chooseTag)
    end
end

function UIFriendPanel:UpdatePanelList(chooseTag)
    local index = chooseTag.tagId
    if index == UIFriendGlobal.PanelTag.FriendList then
        if chooseTag.isFirstClick then
            self:OnFriendListCallBack(CS.CMDRet.eSuccess)
            self:UpdateFriendNumber()
            self:OnClickSort(UIFriendGlobal.FriendListSortType.OnlineTime)
        else
            self:InitFriendList(NetCmdFriendData:GetFriendList())
            self:UpdateFriendNumber()
            self:OnClickSort(self.curSort.sortType)
        end
    elseif index == UIFriendGlobal.PanelTag.AddFriend then
        if chooseTag.isFirstClick then
            NetCmdFriendData:SendSocialFriendRecommend(function (ret)
                self:OnFriendListCallBack(ret)
                self:SortListByType(UIFriendGlobal.FriendListSortType.OnlineTime, true)
            end)
        else
            self:InitFriendList(NetCmdFriendData:GetRecommendList())
            self:SortListByType(UIFriendGlobal.FriendListSortType.OnlineTime, true)
        end
    elseif index == UIFriendGlobal.PanelTag.ApplyFriend then
        if chooseTag.isFirstClick then
            NetCmdFriendData:SendSocialFriendApplyList(function (ret)
                self:OnFriendListCallBack(ret)
            end)
        else
            self:InitFriendList(NetCmdFriendData:GetApplyList())
        end
        NetCmdFriendData:ReadAllApplyList()
        self:UpdateRedPoint()
    end
end

function UIFriendPanel:OnFriendListCallBack(ret)
    if ret == CS.CMDRet.eSuccess then
        self.curTag:SetIsFristClick(false)
        local tagId = self.curTag.tagId
        local list = nil
        local virtualList = nil

        if tagId == UIFriendGlobal.PanelTag.ApplyFriend then
            list = NetCmdFriendData:GetApplyList()
        elseif tagId == UIFriendGlobal.PanelTag.AddFriend then
            list = NetCmdFriendData:GetRecommendList()
        elseif tagId == UIFriendGlobal.PanelTag.FriendList then
            list = NetCmdFriendData:GetFriendList()
        end
        self:InitFriendList(list)
    end
end

function UIFriendPanel:InitFriendList(list)
    self.friendList = {}
    if list ~= nil and list.Count > 0 then
        for i = 0, list.Count - 1 do
            table.insert(self.friendList, list[i])
        end
    end

    self:UpdateFriendList(self.friendList)
end

function UIFriendPanel:UpdateFriendList(list)
    local virtualList = self.curTag.virtualList
    self.curTag:EnableEmpty(#list <= 0)
    if self.curTag.tagId == UIFriendGlobal.PanelTag.ApplyFriend then
        setactive(self.mView.mTrans_RefuseAll, #list > 0)
    end

    virtualList.itemProvider = function()
        local item = self:FriendItemProvider()
        return item
    end

    virtualList.itemRenderer = function(index, renderDataItem)
        self:FriendItemRenderer(index, renderDataItem)
    end

    virtualList.numItems = #list
    virtualList:Refresh()
end

function UIFriendPanel:FriendItemProvider()
    local itemView = UIFriendsListItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView.mUIRoot.gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIFriendPanel:FriendItemRenderer(index, renderDataItem)
    local itemData = self.friendList[index + 1]
    local item = renderDataItem.data

    item:SetData(itemData, self.curTag.tagId)
end

function UIFriendPanel:UpdateFriendNumber()
    local max = TableData.GetFriendLimit()
    local number = #self.friendList
    self.mView.mText_FriendNum.text = number
    self.mView.mText_FriendNumAll.text = "/" .. max
end

function UIFriendPanel:OnSearchFriend()
    local txt = self.mView.mText_InputField.text
    if(txt == "") then
        return
    end

    local selfData = AccountNetCmdHandler:GetRoleInfoData()
    if selfData.UID == tonumber(txt) then
        UIPlayerInfoPanel.OpenByParam(selfData)
    else
        NetCmdFriendData:SendSocialFriendSearch(txt, function (ret)
            if ret == CS.CMDRet.eSuccess then
                self:OnSearchFriendCallBack()
            end
        end)
    end
end

function UIFriendPanel:OnPastUID()
    self.mView.mText_InputField.text = ""
    self.mView.mText_InputField.text = self.mView.mText_InputField.text .. CS.UnityEngine.GUIUtility.systemCopyBuffer
end

function UIFriendPanel:OnSearchFriendCallBack()
    local player = NetCmdFriendData:GetCurSearchFriendData()
    if player then
        UIPlayerInfoPanel.OpenByParam(player)
    else
        UIUtils.PopupHintMessage(100024)
    end
end

function UIFriendPanel:OnClickBlackList()
    UIManager.OpenUIByParam(UIDef.UIFriendBlackListPanel)
end

function UIFriendPanel:OnClickSortList()
    setactive(self.mView.mTrans_SortList, true)
    self.pointer.isInSelf = true
end

function UIFriendPanel:CloseItemSort()
    setactive(self.mView.mTrans_SortList, false)
end

function UIFriendPanel:OnClickSort(type)
    if type then
        if self.curSort then
            if self.curSort.sortType ~= type then
                self.curSort.btnSort.interactable = true
            end
        end
        self.curSort = self.sortList[type]
        self.curSort.isAscend = true
        self.curSort.btnSort.interactable = false
        self.sortContent:SetData(self.curSort)

        table.sort(self.friendList, self.sortContent.sortFunc)
        self.curTag.virtualList:Refresh()
    end
end

function UIFriendPanel:OnClickAscend()
    if self.curSort then
        self.curSort.isAscend = not self.curSort.isAscend
        self.sortContent:SetData(self.curSort)

        table.sort(self.friendList, self.sortContent.sortFunc)
        self.curTag.virtualList:Refresh()
    end
end

function UIFriendPanel.OnFriendListChange()
    self = UIFriendPanel
    gfdebug("friendList change")
    self:UpdatePanelList(self.curTag)
end

function UIFriendPanel:OnRefreshRecommendList()
    if self.canRefreshRecommend then
        NetCmdFriendData:SendSocialFriendRecommend(function (ret)
            UIUtils.PopupPositiveHintMessage(100046)
            self:OnFriendListCallBack(ret)
        end)
        self.canRefreshRecommend = false
    end
end

function UIFriendPanel:OnRefuseAll()
    NetCmdFriendData:SendFriendApproveApplication(0, false)
end

function UIFriendPanel:OnReturnClicked()
    for _, tag in ipairs(self.tagList) do
        tag.isFirstClick = false
    end
	self.Close()
end

function UIFriendPanel:SortListByType(sortType, isAscend)
    local sort = self.sortList[sortType]
    local sortFunc = nil
    if self.sortContent then
        sortFunc = self.sortContent:GetSortFunc(1, sort.sortCfg, isAscend)
        table.sort(self.friendList, sortFunc)
        self.curTag.virtualList:Refresh()
    end
end

--function UIFriendPanel:UpdateRedPoint()
--    local showRedPoint = NetCmdFriendData:HasFriendApplication()
--    setactive(self.mView.mTrans_ApplicationList_RedPoint, showRedPoint)
--end

function UIFriendPanel.OnUpdate()
    if not UIFriendPanel.canRefreshRecommend then
        UIFriendPanel.timer = UIFriendPanel.timer + CS.UnityEngine.Time.deltaTime
        if UIFriendPanel.timer >= UIFriendPanel.refreshTime then
            UIFriendPanel.timer = 0
            UIFriendPanel.canRefreshRecommend = true
        end
    end
end

function UIFriendPanel:GetTransListByTag(tagId)
    if tagId == UIFriendGlobal.PanelTag.FriendList then
        return self.mView.mTrans_Friend, self.mView.mFriendVirtualList, self.mView.mTrans_FriendListEmpty
    elseif tagId == UIFriendGlobal.PanelTag.ApplyFriend then
        return self.mView.mTrans_Apply, self.mView.mApplyVirtualList, self.mView.mTrans_ApplListEmpty
    elseif tagId == UIFriendGlobal.PanelTag.AddFriend then
        return self.mView.mTrans_Add, self.mView.mAddVirtualList, self.mView.mTrans_AddEmpty
    end
    return nil, nil, nil
end
