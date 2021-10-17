require("UI.UIBaseCtrl")
---@class UIBarrackContentBase : UIBaseCtrl
UIBarrackContentBase = class("UIBarrackContentBase", UIBaseCtrl)
UIBarrackContentBase.__index = UIBarrackContentBase

UIBarrackContentBase.PrefabPath = nil

function UIBarrackContentBase:ctor()
    UIBarrackContentBase.super.ctor(self)

    self.mData = nil
    self.mParent = nil
    self.mParentObj = nil
    self.itemPrefab = nil
    self.needModel = false
end

function UIBarrackContentBase:InitCtrl(obj)
    local instObj = nil
    if self.PrefabPath ~= nil then
        self.mParentObj = obj
        instObj = self:InstantiatePrefab(obj)
    else
        self.mParentObj = nil
        instObj = obj
    end
    self:SetRoot(instObj.transform)
    self:__InitCtrl()
end

function UIBarrackContentBase:InstantiatePrefab(parent)
    self.itemPrefab = UIUtils.GetUIRes(self.PrefabPath,false)
    local instObj = instantiate(self.itemPrefab)
    CS.LuaUIUtils.SetParent(instObj.gameObject, parent.gameObject, true)

    return instObj
end

function UIBarrackContentBase:__InitCtrl()

end

function UIBarrackContentBase:SetData(data, parent)
    self.mData = data
    self.mParent = parent
end

function UIBarrackContentBase:OnEnable(enable)
    setactive(self.mUIRoot.gameObject, enable)
end

function UIBarrackContentBase:OnUpdateTop()

end

function UIBarrackContentBase:Close()
    if self.mParent then
        self.mParent:CloseChildPanel()
    end
end

function UIBarrackContentBase:EnableModel(enable)
    if self.mParent then
        self.needModel = enable
        self.mParent:EnableCharacterModel(enable)
    end
end

function UIBarrackContentBase:EnableMask(enable)
    if self.mParent then
        setactive(self.mParent.mView.mTrans_Mask, enable)
    end
end

function UIBarrackContentBase:EnableSwitchGun(enable)
    if self.mParent then
        self.mParent:EnableSwitchContent(enable)
    end
end

function UIBarrackContentBase:ChangeTab(tabId)
    if self.mParent and tabId then
        self.mParent:OnClickTab(tabId)
    end
end

function UIBarrackContentBase:EnableTabs(enable)
    if self.mParent then
        self.mParent:EnableTabs(enable)
    end
end

function UIBarrackContentBase:RefreshGun()
    if self.mParent then
        self.mParent:RefreshGun()
    end
end

function UIBarrackContentBase:UpdateRedPoint()
    if self.mParent then
        self.mParent:UpdateRedPoint()
    end
end

function UIBarrackContentBase:PlaySwitchAni(step)
    if self.animator then
        if step == 1 then
            self.animator:SetTrigger("Next")
        elseif step == -1 then
             self.animator:SetTrigger("Previous")
        end
    end
end

function UIBarrackContentBase:OnRelease()
    if self.itemPrefab then
        ResourceManager:UnloadAsset(self.itemPrefab)
    end
end

