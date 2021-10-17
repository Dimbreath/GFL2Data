--region *.lua

require("Lib.GFLib")
---@class UIBasePanel
UIBasePanel = class("UIBasePanel");
UIBasePanel.__index = UIBasePanel;

UIBasePanel.mGuid = 0;
UIBasePanel.mUIRoot = nil;--type GameObject
UIBasePanel.IsActive = false;
UIBasePanel.parent = nil;
UIBasePanel.mIsPop = false;
UIBasePanel.mIsGuidePanel = false;
UIBasePanel.mIsDontDestroyOnLoad = false;
UIBasePanel.mHideFlag = false
UIBasePanel.mShowSceneObj = false    -- 默认隐藏场景的物件

UIBasePanel.mUIAssetsList = nil;

UIBasePanel.mUITimerList = {}

UIBasePanel.RedPointType = {}
UIBasePanel.keyboardEvent = nil

--构造
function UIBasePanel:ctor()
    self.mGuid = 0;
end

function UIBasePanel:SetRoot(root)
    self.mUIRoot = root;
    ResourceManager:AddLuaToCheck(self,self.ClearAssets,root);
end

function UIBasePanel:ResetRect()

end

function UIBasePanel:AddCanvas(sort)
    UIUtils.AddCanvas(self.mUIRoot, sort)
end

function UIBasePanel:InstanceUIPrefab(path, parent)
    local asset = UIUtils.GetGizmosPrefab(path)
    if asset then
        local obj = instantiate(asset)
        if parent then
            CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
        end
        self:AddAsset(asset)
        return obj
    else
        return nil
    end
end

function UIBasePanel:AddAsset(asset)
    if(self.mUIAssetsList == nil) then
        self.mUIAssetsList = List:New();
    end
    self.mUIAssetsList:Add(asset);
end

function UIBasePanel:RegistrationKeyboard(code, btn)
    if self.keyboardEvent == nil then
        self.keyboardEvent = self.mUIRoot.gameObject:GetComponent("UIKeyboardEventMono")
    end
    self.keyboardEvent:RegistrationKeyboardWithButton(code, btn)
end

function UIBasePanel:UnRegistrationKeyboard(code)
    if self.keyboardEvent == nil then
        self.keyboardEvent = self.mUIRoot.gameObject:GetComponent("UIKeyboardEventMono")
    end
    if code then
        self.keyboardEvent:UnRegistrationKeyboard(code)
    else
        self.keyboardEvent = nil
    end
end

function UIBasePanel.ClearAssets(luaScript)
    if(luaScript.mUIAssetsList ~= nil) then
        for i = 1, #luaScript.mUIAssetsList do 
            ResourceManager:UnloadAsset(luaScript.mUIAssetsList[i]);
            --gfdebug("卸载"..luaScript.mUIAssetsList[i].name);
        end

        luaScript.mUIAssetsList:Clear();
    end
    luaScript.mUIAssetsList = nil;
end


function UIBasePanel:SetRootToParent(root, parent)
    self.mUIRoot = root;
    self.parent = parent;
    self.mUIRoot.transform:SetParent(parent);

    local rect = CS.LuaUIUtils.GetRectTransform(root.transform);
    if rect ~= nil then
        rect.anchoredPosition3D = vectorzero;
        rect.anchoredPosition = vector2zero;

        rect.sizeDelta = vector2one;
        rect.localEulerAngles = vectorzero;
        rect.localScale = vectorone;
    end
end

function UIBasePanel:Show(isShow)
    if self.mUIRoot ~= nil then
        setactive(self.mUIRoot, isShow);
    end
    UISystem:SetDirty();
    self.IsActive = isShow;
end

function UIBasePanel.Close()

end

--function UIBasePanel:SetRedPoint()
--    for _, type in ipairs(self.RedPointType) do
--        RedPointSystem:GetInstance():SetRedPointByType(type)
--    end
--end

function UIBasePanel:UpdateRedPoint()
    for _, type in ipairs(self.RedPointType) do
        self:UpdateRedPointByType(type)
    end
end

function UIBasePanel:UpdateRedPointByType(type)
    RedPointSystem:GetInstance():UpdateRedPointByType(type)
end

function UIBasePanel:SetPosZ()
    if UIManager.IsModelPanel() then
        local pos = self.mUIRoot.localPosition
        local z = math.min(-250, pos.z)
        pos.z = z
        self.mUIRoot.localPosition = pos
    end
end

function UIBasePanel:DelayCall(duration, callback)
    local timer = TimerSys:DelayCall(duration, function ()
        if callback then
            callback()
        end
    end)
    table.insert(self.mUITimerList, timer)
end

function UIBasePanel:ReleaseTimers()
    for _, timer in ipairs(self.mUITimerList) do
        if timer then
            timer:Stop()
        end
    end
    self.mUITimerList = {}
end

function UIBasePanel:CallWithAniDelay(callback)
    local root = UIUtils.GetRectTransform(self.mUIRoot, "Root")
    if root then
        local canvasGroup = root.gameObject:GetComponent("CanvasGroup")
        local aniTime = root.gameObject:GetComponent("AniTime")
        local animtor = root.gameObject:GetComponent("Animator")
        if canvasGroup and aniTime and animtor then
            canvasGroup.blocksRaycasts = false
            animtor:SetTrigger("FadeOut")
            TimerSys:DelayCall(aniTime.m_FadeOutTime, function ()
                canvasGroup.blocksRaycasts = true
                if callback then
                    callback()
                end
            end)
        else
            if callback then
                callback()
            end
        end
    else
        if callback then
            callback()
        end
    end
end

UIBasePanel.TRANS_FADE_OUT = 0.2;
UIBasePanel.TRANS_FADE_IN = 0.2;
UIBasePanel.s_Callback = nil;
UIBasePanel.s_TransitionPanel = nil;

function UIBasePanel.PlayFadeTransitionCallback()
    if(UIBasePanel.s_TransitionPanel ~= nil) then
        ResourceManager:DestroyInstance(UIBasePanel.s_TransitionPanel.gameObject);
        UIBasePanel.s_TransitionPanel = nil;
    end

    if(UIBasePanel.s_Callback ~= nil) then
        UIBasePanel.s_Callback();
        UIBasePanel.s_Callback = nil;
    end
end

function UIBasePanel.PlayScaleTransitionCallback()
    CS.UITweenManager.PlayScaleTween(self.mUIRoot.transform,vectorone, vectorone,0,0.0);
end

function UIBasePanel:PlayFadeOutEffect(Callback)
    UIBasePanel.s_TransitionPanel = CS.ResSys.Instance:GetScreenSwitchObj("UIPanelTransitionMask",true);
    UIBasePanel.s_TransitionPanel.transform:SetParent(self.mUIRoot.parent,false)
    UIBasePanel.s_Callback = Callback;

    CS.UITweenManager.PlayFadeTween(UIBasePanel.s_TransitionPanel.transform,0.0,1.0,UIBasePanel.TRANS_FADE_OUT,0.3,UIBasePanel.PlayFadeTransitionCallback);
end

function UIBasePanel:PlayFadeInEffect(Callback)
    UIBasePanel.s_TransitionPanel = CS.ResSys.Instance:GetScreenSwitchObj("UIPanelTransitionMask",true);
    UIBasePanel.s_TransitionPanel.transform:SetParent(self.mUIRoot.parent,false)
    UIBasePanel.s_Callback = Callback;

    CS.UITweenManager.PlayFadeTween(UIBasePanel.s_TransitionPanel.transform,1.0,0.0,UIBasePanel.TRANS_FADE_IN,0.2,UIBasePanel.PlayFadeTransitionCallback);
end

function UIBasePanel:PlayScaleInEffect(trans)
    CS.UITweenManager.PlayScaleTween(trans,3 * vectorone,vectorone,UIBasePanel.TRANS_FADE_IN,0.2,nil);
end

function UIBasePanel:PlayScaleOutEffect(trans)
    CS.UITweenManager.PlayScaleTween(trans,vectorone,1.5 * vectorone,UIBasePanel.TRANS_FADE_OUT,0.0,UIBasePanel.PlayScaleTransitionCallback);
end

function UIBasePanel:SetParticleRenderOrder(target)
    UIUtils.SetParticleRenderOrder(target, UIManager.GetTopPanelSortOrder() + 1)
end


--endregion
