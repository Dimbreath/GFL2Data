require("UI.UIBasePanel")
---@class UIFriendBlackListPanel : UIBasePanel

UIFriendBlackListPanel = class("UIFriendBlackListPanel", UIBasePanel)
UIFriendBlackListPanel.__index = UIFriendBlackListPanel

UIFriendBlackListPanel.blackList = {}

function UIFriendBlackListPanel:ctor()
    UIFriendBlackListPanel.super.ctor(self)
end

function UIFriendBlackListPanel.Close()
    self = UIFriendBlackListPanel
    UIManager.CloseUI(UIDef.UIFriendBlackListPanel)
end

function UIFriendBlackListPanel.OnRelease()
    self = UIFriendBlackListPanel
    MessageSys:RemoveListener(CS.GF2.Message.FriendEvent.FriendListChange, UIFriendBlackListPanel.OnFriendListChange)
end

function UIFriendBlackListPanel.Init(root)
    self = UIFriendBlackListPanel

    self.mIsPop = true

    UIFriendBlackListPanel.super.SetRoot(UIFriendBlackListPanel, root)

    UIFriendBlackListPanel.mView = UIFriendBlackListPanelView.New()
    UIFriendBlackListPanel.mView:InitCtrl(root)

    NetCmdFriendData:SendGetFriendBlackList(function (ret)
        UIFriendBlackListPanel:OnFriendListCallBack(ret)
    end)
end

function UIFriendBlackListPanel.OnInit()
    self = UIFriendBlackListPanel

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UIFriendBlackListPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_BgClose.gameObject).onClick = function()
        UIFriendBlackListPanel.Close()
    end

    MessageSys:AddListener(CS.GF2.Message.FriendEvent.FriendListChange, UIFriendBlackListPanel.OnFriendListChange)
end

function UIFriendBlackListPanel.OnShow()
    self = UIFriendBlackListPanel
end

function UIFriendBlackListPanel:OnFriendListCallBack(ret)
    if ret == CS.CMDRet.eSuccess then
        local list = NetCmdFriendData:GetBlackList()
        self:InitFriendList(list)
    end
end

function UIFriendBlackListPanel:InitFriendList(list)
    self.blackList = {}
    if list ~= nil and list.Count > 0 then
        for i = 0, list.Count - 1 do
            table.insert(self.blackList, list[i])
        end
    end

    self:UpdateFriendList(self.blackList)
    self:UpdateFriendNumber()
end

function UIFriendBlackListPanel:UpdateFriendList(list)
    local virtualList = self.mView.mVirtualList
    setactive(self.mView.mTrans_BlackEmpty, #list <= 0)
    setactive(self.mView.mTrans_BlackList, #list > 0)

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

function UIFriendBlackListPanel:FriendItemProvider()
    local itemView = UIFriendBlackItem.New()
    itemView:InitCtrl()
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView.mUIRoot.gameObject
    renderDataItem.data = itemView

    return renderDataItem
end

function UIFriendBlackListPanel:FriendItemRenderer(index, renderDataItem)
    local itemData = self.blackList[index + 1]
    local item = renderDataItem.data

    item:SetData(itemData)
end

function UIFriendBlackListPanel.OnFriendListChange()
    self = UIFriendBlackListPanel
    gfdebug("friendList change")
    self:OnFriendListCallBack(CS.CMDRet.eSuccess)
end

function UIFriendBlackListPanel:UpdateFriendNumber()
    local max = TableData.GlobalSystemData.BlackListUpperLimit
    local number = #self.blackList
    self.mView.mText_Num.text = number
    self.mView.mText_AllNum.text = "/" .. max
end
