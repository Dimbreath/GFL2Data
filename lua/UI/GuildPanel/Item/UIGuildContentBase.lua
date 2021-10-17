require("UI.UIBaseCtrl")

UIGuildContentBase = class("UIGuildContentBase", UIBaseCtrl)
UIGuildContentBase.__index = UIGuildContentBase

UIGuildContentBase.PrefabPath = ""
UIGuildContentBase.Type = 0
UIGuildContentBase.mData = nil
UIGuildContentBase.mParent = nil
UIGuildContentBase.itemPrefab = nil
UIGuildContentBase.curContent = 0
UIGuildContentBase.contentList = {}
UIGuildContentBase.openContentList = {}

function UIGuildContentBase:ctor()
    UIGuildContentBase.super.ctor(self)
end

function UIGuildContentBase:InitCtrl(parent)
    self.itemPrefab = UIUtils.GetUIRes(self.PrefabPath,false)
    local instObj = instantiate(self.itemPrefab)

    CS.LuaUIUtils.SetParent(instObj.gameObject, parent.gameObject, true)

    self:SetRoot(instObj.transform)
    self:__InitCtrl()
    self:InitContent()
end

function UIGuildContentBase:InitContent()
    self.contentList = {}
end

function UIGuildContentBase:OpenContentByType(type, isPop)
    if self.curContent == type then
        return
    end
    if #self.openContentList > 0 and self.curContent > 0 and not isPop then
        local type = self.openContentList[#self.openContentList]
        setactive(self.contentList[type].gameObject, false)
    end
    setactive(self.contentList[type].gameObject, true)
    self.curContent = type
    table.insert(self.openContentList, type)
end

function UIGuildContentBase:ClearOpenList()
    self.openContentList = {}
    self.curContent = 0
end

function UIGuildContentBase:CloseContent()
    if #self.openContentList > 0 then
        local type = self.openContentList[#self.openContentList]
        setactive(self.contentList[type], false)
        table.remove(self.openContentList, #self.openContentList)
    end
    if #self.openContentList == 0 then
        self.curContent = 0
        return false
    else
        local type = self.openContentList[#self.openContentList]
        setactive(self.contentList[type], true)
        self.curContent = type
        self:RefreshPanel()
        return true
    end
end

function UIGuildContentBase:RefreshPanel()

end

function UIGuildContentBase:__InitCtrl()

end

function UIGuildContentBase:UpdatePanel(data, parent)
    self.mData = data
    self.mParent = parent
end

function UIGuildContentBase:OnEnable(enable)
    setactive(self.mUIRoot.gameObject, enable)
end

function UIGuildContentBase:UpdateGuildItem()
    if self.mParent then
        self.mParent:UpdateGuildItem()
    end
end

function UIGuildContentBase:OnRelease()
    if self.itemPrefab then
        ResourceManager:UnloadAsset(self.itemPrefab)
    end
    self.curContent = 0
    self.contentList = {}
    self.openContentList = {}
end
