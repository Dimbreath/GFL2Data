require("UI.UIBaseCtrl")
UIUAVContentBase = class("UIUAVContentBase", UIBaseCtrl)
UIUAVContentBase.__index = UIUAVContentBase

UIUAVContentBase.PrefabPath = nil

function UIUAVContentBase:ctor()
    UIUAVContentBase.super.ctor(self)

    self.mData = nil
    self.mParent = nil
    self.mParentObj = nil
    self.itemPrefab = nil
    self.needModel = false
    self.instobj=nil
end

function UIUAVContentBase:InitCtrl(obj)
    local instObj = nil
    if self.PrefabPath ~= nil then
        self.mParentObj = obj
        instObj = self:InstantiatePrefab(obj)
    else
        self.mParentObj = nil
        instObj = obj
    end
    self.instobj=instObj
    self:SetRoot(instObj.transform)
    self:__InitCtrl()
end

function UIUAVContentBase:InstantiatePrefab(parent)
    self.itemPrefab = UIUtils.GetUIRes(self.PrefabPath)
    local instObj = instantiate(self.itemPrefab)
    CS.LuaUIUtils.SetParent(instObj.gameObject, parent.gameObject, true)

    return instObj
end

function UIUAVContentBase:__InitCtrl()

end

function UIUAVContentBase:SetData(data, parent)
    self.mData = data
    self.mParent = parent
end

function UIUAVContentBase:OnEnable(enable)
    setactive(self.mUIRoot.gameObject, enable)
end

function UIUAVContentBase:OnUpdateTop()

end

function UIUAVContentBase:Close()
    if self.mParent then
        self.mParent:CloseChildPanel()
    end
end

function UIUAVContentBase:EnableModel(enable)
    if self.mParent then
        self.needModel = enable
        self.mParent:EnableCharacterModel(enable)
    end
end

function UIUAVContentBase:EnableMask(enable)
    if self.mParent then
        setactive(self.mParent.mView.mTrans_Mask, enable)
    end
end

function UIUAVContentBase:EnableSwitchGun(enable)
    if self.mParent then
        self.mParent:EnableSwitchContent(enable)
    end
end

function UIUAVContentBase:ChangeTab(tabId)
    if self.mParent and tabId then
        self.mParent:OnClickTab(tabId)
    end
end

function UIUAVContentBase:EnableTabs(enable)
    if self.mParent then
        self.mParent:EnableTabs(enable)
    end
end

function UIUAVContentBase:RefreshGun()
    if self.mParent then
        self.mParent:RefreshGun()
    end
end

function UIUAVContentBase:UpdateRedPoint()
    if self.mParent then
        self.mParent:UpdateRedPoint()
    end
end

function UIUAVContentBase:OnRelease()
    if self.itemPrefab then
        ResourceManager:UnloadAsset(self.itemPrefab)
    end
end

