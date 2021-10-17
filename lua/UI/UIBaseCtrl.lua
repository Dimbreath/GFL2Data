--region *.lua

require("Lib.GFLib")
---@class UIBaseCtrl
UIBaseCtrl = class("UIBaseCtrl");
UIBaseCtrl.__index = UIBaseCtrl;

UIBaseCtrl.mUIRoot = nil;

UIBaseCtrl.mUIAssetsList = nil;

UIBaseCtrl.mUITimerList = {}

UIBaseCtrl.mIsPop = false

--构造
function UIBaseCtrl:ctor()
    self.mUIAssetsList = List:New();
    self.isPlayFadeOut = false
end

--构造(root为根节点transform)
function UIBaseCtrl:SetRoot(transform)
    if transform == nil then
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!设置了空的Root!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    end
    self.mUIRoot = transform;

    ResourceManager:AddLuaToCheck(self,self.ClearAssets,transform);

    if self.mIsPop then
        local sort = UIManager.GetResourceBarSortOrder()
        self:AddCanvas(sort + 1)
    end
end

function UIBaseCtrl:AddCanvas(sort)
    UIUtils.AddCanvas(self.mUIRoot.gameObject, sort)
end

function UIBaseCtrl:InstanceUIPrefab(path, parent, isFullScreen)
    isFullScreen = (isFullScreen == true) and true or false
    local asset = UIUtils.GetGizmosPrefab(path)
    if asset then
        local obj = instantiate(asset)
        string.gsub(obj.name, "%(Clone%)", "_" .. string.sub(obj.name, -1))
        if parent then
            CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, isFullScreen)
        end
        self:AddAsset(asset)
        return obj
    else
        return nil
    end
end

function UIBaseCtrl:AddAsset(asset)
    if(self.mUIAssetsList == nil) then
        self.mUIAssetsList = List:New();
    end
    self.mUIAssetsList:Add(asset);
end

function UIBaseCtrl.ClearAssets(luaScript)
    if(luaScript.mUIAssetsList ~= nil) then
        for i = 1, #luaScript.mUIAssetsList do 
            ResourceManager:UnloadAsset(luaScript.mUIAssetsList[i]);
            --gfdebug("卸载"..luaScript.mUIAssetsList[i].name);
        end
        luaScript.mUIAssetsList:Clear();
    end
    luaScript.mUIAssetsList = nil;
end

function UIBaseCtrl:GetRoot()
    return self.mUIRoot;
end

function UIBaseCtrl:SetPosZ(zPos)
    
    local pos = self.mUIRoot.localPosition;
    local z = math.min(zPos,pos.z);
	pos.z = z;
    self.mUIRoot.localPosition = pos;
    
    UIUtils.AddSubCanvas(self.mUIRoot.gameObject,-1* zPos,true);
end

function UIBaseCtrl:DelayCall(duration, callback)
    local timer = TimerSys:DelayCall(duration, function ()
        if callback then
            callback()
        end
    end)
    table.insert(self.mUITimerList, timer)
end

function UIBaseCtrl:ReleaseTimers()
    for _, timer in ipairs(self.mUITimerList) do
        if timer then
            timer:Stop()
        end
    end
    self.mUITimerList = {}
end

function UIBaseCtrl:DestroySelf()
    if self.mUIRoot ~= nil then
        gfdestroy(self.mUIRoot)
        self.mUIRoot = nil;
    end
end

function UIBaseCtrl:SetActive(enable)
    if self.mUIRoot ~= nil then
        setactive(self.mUIRoot, enable);
    end
end

function UIBaseCtrl:FindChild(path)
	if path == "" then
		return;
    end

    return self.mUIRoot:Find(path);
end

--typeof(CS.UnityEngine.UI.Button)
function UIBaseCtrl:GetComponent(ctype)
    return CS.LuaUtils:GetComponent(self.mUIRoot, ctype.GetClassType())
end

--typeof(CS.UnityEngine.UI.Button)
function UIBaseCtrl:GetComponent(path, ctype)

    child = self:FindChild(path)
	
	if child == nil then
		return;
	end

    return CS.LuaUtils.GetComponent(child, ctype)
end

-----------------------[获取按钮]----------------------
function UIBaseCtrl:GetSelfButton()
    return CS.LuaUIUtils.GetButton(self.mUIRoot)
end

function UIBaseCtrl:GetButton(path)
    child = self:FindChild(path)
	
	if child == nil then
		return;
	end

    return CS.LuaUIUtils.GetButton(child)
end

-----------------------[获取图片]----------------------
function UIBaseCtrl:GetSelfImage()
    return CS.LuaUIUtils.GetImage(self.mUIRoot)
end

function UIBaseCtrl:GetImage(path)
    child = self:FindChild(path)
	
	if child == nil then
		return;
	end

    return CS.LuaUIUtils.GetImage(child)
end

-----------------------[获取静态图片]----------------------
function UIBaseCtrl:GetSelfRawImage()
    return CS.LuaUIUtils.GetRawImage(self.mUIRoot)
end

function UIBaseCtrl:GetRawImage(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end
    return CS.LuaUIUtils.GetRawImage(child)
end


-----------------------[获取文字]----------------------
function UIBaseCtrl:GetSelfText()
    return CS.LuaUIUtils.GetText(self.mUIRoot)
end

function UIBaseCtrl:GetText(path)
    child = self:FindChild(path)
	
	if child == nil then
		return;
	end

    return CS.LuaUIUtils.GetText(child)
end

-----------------------[获取rect]----------------------
function UIBaseCtrl:GetSelfRectTransform()
    return CS.LuaUIUtils.GetRectTransform(self.mUIRoot)
end

function UIBaseCtrl:GetRectTransform(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetRectTransform(child)
end

-----------------------[获取GridLayout]----------------------
function UIBaseCtrl:GetSelfGridLayoutGroup()
    return CS.LuaUIUtils:GetGridLayoutGroup(self.mUIRoot)
end

function UIBaseCtrl:GetGridLayoutGroup(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetGridLayoutGroup(child)
end

--endregion

-----------------------[获取VerticalLayoutGroup]----------------------
function UIBaseCtrl:GetVerticalLayoutGroup()
    return CS.LuaUIUtils.GetVerticalLayoutGroup(self.mUIRoot)
end

function UIBaseCtrl:GetVerticalLayoutGroup(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetVerticalLayoutGroup(child)
end
--endregion

-----------------------[获取VerticalLayoutGroup]----------------------
function UIBaseCtrl:GetHorizontalLayoutGroup()
    return CS.LuaUIUtils:GetHorizontalLayoutGroup(self.mUIRoot)
end

function UIBaseCtrl:GetHorizontalLayoutGroup(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetHorizontalLayoutGroup(child)
end
--endregion

-----------------------[获取CanvasGroup]----------------------
function UIBaseCtrl:GetCanvasGroup()
    return CS.LuaUIUtils:GetCanvasGroup(self.mUIRoot)
end

function UIBaseCtrl:GetCanvasGroup(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetCanvasGroup(child)
end
--endregion

-----------------------[获取CanvasGroup]----------------------
function UIBaseCtrl:GetSelfCanvas()
	return CS.LuaUIUtils.GetCanvas(self.mUIRoot)
end
--endregion

-----------------------[获取Toggle]----------------------
function UIBaseCtrl:GetToggle()
    return CS.LuaUIUtils:GetToggle(self.mUIRoot)
end

function UIBaseCtrl:GetGFToggle(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetGFToggle(child)
end

function UIBaseCtrl:GetToggle(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetToggle(child)
end

--endregion

-----------------------[获取Toggle]----------------------
function UIBaseCtrl:GetScrollCircle()
    return CS.LuaUIUtils:GetScrollCircle(self.mUIRoot)
end

function UIBaseCtrl:GetScrollCircle(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetScrollCircle(child)
end

--endregion
-----------------------[获取Slider]----------------------
function UIBaseCtrl:GetSlider()
    return CS.LuaUIUtils:GetSlider(self.mUIRoot)
end

function UIBaseCtrl:GetSlider(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetSlider(child)
end

--endregion


-----------------------[获取Scrollbar]----------------------
function UIBaseCtrl:GetScrollbar()
    return CS.LuaUIUtils:GetScrollbar(self.mUIRoot)
end

function UIBaseCtrl:GetScrollbar(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetScrollbar(child)
end

--endregion

-----------------------[获取InputField]----------------------
function UIBaseCtrl:GetInputField()
    return CS.LuaUIUtils:GetInputField(self.mUIRoot)
end

function UIBaseCtrl:GetInputField(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetInputField(child)
end

--endregion

-----------------------[获取GetScrollRect]----------------------
function UIBaseCtrl:GetScrollRect()
    return CS.LuaUIUtils:GetScrollRect(self.mUIRoot)
end

function UIBaseCtrl:GetScrollRect(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetScrollRect(child)
end

--endregion


-----------------------[获取UniWebView]----------------------
function UIBaseCtrl:GetUniWebView()
    return CS.LuaUIUtils:UniWebView(self.mUIRoot)
end

function UIBaseCtrl:GetUniWebView(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetUniWebView(child)
end

--------------------------[获取camera]----------------------------
function UIBaseCtrl:GetCamera()
    return CS.LuaUIUtils:GetCamera(self.mUIRoot)
end

function UIBaseCtrl:GetCamera(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetCamera(child)
end

--------------------------[获取Animator]----------------------------
function UIBaseCtrl:GetSelfAnimator()
    return CS.LuaUIUtils.GetAnimator(self.mUIRoot)
end

function UIBaseCtrl:GetRootAnimator()
    return self:GetAnimator("Root")
end

function UIBaseCtrl:GetAnimator(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetAnimator(child)
end


-----------------------[获取ContentSizeFitter]----------------------
function UIBaseCtrl:GetContentSizeFitter()
    return CS.LuaUIUtils:GetContentSizeFitter(self.mUIRoot)
end

function UIBaseCtrl:GetContentSizeFitter(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetContentSizeFitter(child)
end

--endregion

-----------------------[获取DropDown]----------------------
function UIBaseCtrl:GetDropDown()
    return CS.LuaUIUtils:GetDropdown(self.mUIRoot)
end

function UIBaseCtrl:GetDropDown(path)
    child = self:FindChild(path)

    if child == nil then
        return;
    end

    return CS.LuaUIUtils.GetDropdown(child)
end

function UIBaseCtrl:PlayAniWithCallback(callback)
    if self.isPlayFadeOut then
        return
    end

    local root = self:GetRectTransform("Root")
    if root then
        local animator = getcomponent(root, typeof(CS.UnityEngine.Animator))
        local timeData = getcomponent(root, typeof(CS.AniTime))
        if animator then
            if timeData == nil then
                if callback then
                    callback()
                end
            else
                if timeData.m_FadeOutTime > 0 then
                    TimerSys:DelayCall(timeData.m_FadeOutTime, function ()
                        self.isPlayFadeOut = false
                        if callback then
                            callback()
                        end
                    end)
                else
                    if callback then
                        callback()
                    end
                end

                local param = animator.parameters
                for i = 0, param.Length - 1 do
                    local aniName = string.lower(param[i].name)
                    if aniName ~= nil and string.match(aniName, "fadeout") ~= nil then
                        animator:SetTrigger(param[i].name)
                        self.isPlayFadeOut = true
                    end
                end
            end
        else
            if callback then
                callback()
            end
        end
    end
end



--endregion