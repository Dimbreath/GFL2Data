require("UI.UIBasePanel")
---@class UICommonAvatarModifyPanel : UIBasePanel

UICommonAvatarModifyPanel = class("UICommonAvatarModifyPanel", UIBasePanel)
UICommonAvatarModifyPanel.__index = UICommonAvatarModifyPanel

UICommonAvatarModifyPanel.avatarDataList = {}
UICommonAvatarModifyPanel.avatarList = {}
UICommonAvatarModifyPanel.displayAvatar = nil
UICommonAvatarModifyPanel.curAvatar = nil
UICommonAvatarModifyPanel.equipAvatar = nil

function UICommonAvatarModifyPanel:ctor()
    UICommonAvatarModifyPanel.super.ctor(self)
end

function UICommonAvatarModifyPanel.Close()
    self = UICommonAvatarModifyPanel
    UIManager.CloseUI(UIDef.UICommonAvatarModifyPanel)
end

function UICommonAvatarModifyPanel.OnRelease()
    self = UICommonAvatarModifyPanel

    UICommonAvatarModifyPanel.avatarDataList = {}
    UICommonAvatarModifyPanel.avatarList = {}
    UICommonAvatarModifyPanel.displayAvatar = nil
    UICommonAvatarModifyPanel.curAvatar = nil
    UICommonAvatarModifyPanel.equipAvatar = nil

    MessageSys:RemoveListener(CS.GF2.Message.CampaignEvent.ResInfoUpdate, UICommonAvatarModifyPanel.RefreshInfo)
end

function UICommonAvatarModifyPanel.Init(root, data)
    self = UICommonAvatarModifyPanel

    self.mIsPop = true
    self.confirmCallback = data[1]
    self.defaultStr = tonumber(data[2])

    UICommonAvatarModifyPanel.super.SetRoot(UICommonAvatarModifyPanel, root)

    UICommonAvatarModifyPanel.mView = UICommonAvatarModifyPanelView.New()
    UICommonAvatarModifyPanel.mView:InitCtrl(root)

    self:InitDisplayAvatar()
    self.avatarDataList = self:InitAvatarList()
end

function UICommonAvatarModifyPanel.OnInit()
    self = UICommonAvatarModifyPanel

    MessageSys:AddListener(CS.GF2.Message.CampaignEvent.ResInfoUpdate, UICommonAvatarModifyPanel.RefreshInfo)

    UIUtils.GetButtonListener(self.mView.mBtn_Confirm.gameObject).onClick = function()
        UICommonAvatarModifyPanel:OnReplaceAvatar()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UICommonAvatarModifyPanel.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CloseBg.gameObject).onClick = function()
        UICommonAvatarModifyPanel.Close()
    end

    self:UpdateAvatarList()
end

function UICommonAvatarModifyPanel:InitDisplayAvatar()
    if self.displayAvatar == nil then
        self.displayAvatar = UICommonPlayerAvatarItem.New()
        self.displayAvatar:InitCtrl(self.mView.mTrans_DisplayAvatar)
    end
end

function UICommonAvatarModifyPanel:UpdateAvatarList()
    for i, data in ipairs(self.avatarDataList) do
        local item = self.avatarList[i]
        if item == nil then
            item = UICommonPlayerAvatarItem.New()
            item:InitCtrl(self.mView.mTrans_AvatarList)
            table.insert(self.avatarList, item)
        end
        item.data = self.avatarDataList[i]
        item:SetData(self.avatarDataList[i].icon)
        item:SetLockState(self.avatarDataList[i].isLock)
        item:SetBlackState(self.avatarDataList[i].id == self.defaultStr)
        if self.avatarDataList[i].id == self.defaultStr then
            self.equipAvatar = item
        end

        UIUtils.GetButtonListener(item.mBtn_Avatar.gameObject).onClick = function()
            self:OnClickAvatar(item)
        end
    end

    self:OnClickAvatar(self.equipAvatar)
end

function UICommonAvatarModifyPanel:UpdateAvatarInfo()
    if self.curAvatar then
        self.mView.mText_AvatarDesc.text = self.curAvatar.data.itemData.introduction.str
        self.mView.mText_AvatarName.text = self.curAvatar.data.itemData.name.str
        self.displayAvatar:SetData(self.curAvatar.data.icon)

        setactive(self.mView.mTrans_Equiped, self.curAvatar.data.id == self.equipAvatar.data.id)
        setactive(self.mView.mTrans_Lock, self.curAvatar.data.id ~= self.equipAvatar.data.id and self.curAvatar.data.isLock)
        setactive(self.mView.mTrans_Replace, self.curAvatar.data.id ~= self.equipAvatar.data.id and not self.curAvatar.data.isLock)
    end
end

function UICommonAvatarModifyPanel:OnClickAvatar(item)
    if self.curAvatar then
        self.curAvatar.mBtn_Avatar.interactable = true
    end
    self.curAvatar = item
    self.curAvatar.mBtn_Avatar.interactable = false

    if self.equipAvatar then
        self.equipAvatar:SetBlackState(item.data.id ~= self.equipAvatar.data.id)
    end

    self:UpdateAvatarInfo()
end

function UICommonAvatarModifyPanel:OnReplaceAvatar()
    if self.confirmCallback and self.curAvatar then
        self.confirmCallback(self.curAvatar.data.id)
    end
end

function UICommonAvatarModifyPanel.RefreshInfo()
    self = UICommonAvatarModifyPanel
    self.defaultStr = AccountNetCmdHandler:GetRoleInfoData().Portrait
    self.equipAvatar = nil
    if self.curAvatar then
        self.curAvatar.mBtn_Avatar.interactable = true
        self.curAvatar = nil
    end
    self:UpdateAvatarList()
end

function UICommonAvatarModifyPanel:InitAvatarList()
    local list = {}
    local dataList = TableData.listPlayerAvatarDatas:GetList()
    for i = 0, dataList.Count - 1 do
        local avatar = {}
        local itemData = TableData.listItemDatas:GetDataById(dataList[i].item_id)
        if itemData then
            avatar.id = dataList[i].id
            avatar.itemData = itemData
            avatar.icon = dataList[i].icon
            avatar.isLock = not NetCmdIllustrationData:CheckAvatarIsUnlock(avatar.id)

            table.insert(list, avatar)
        end
    end

    table.sort(list, function (a, b)
        if a.itemData.sort == b.itemData.sort then
            return a.itemData.id < b.itemData.id
        else
            return a.itemData.sort < b.itemData.sort
        end
    end)

    return list
end


