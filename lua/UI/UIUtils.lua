--region *.lua
--Date

require("UI.UIManager")

UIUtils = {};


-----------------------[获取监听器]----------------------

function UIUtils.GetGraphicRaycaster(gameobj)
    return CS.LuaUIUtils.GetGraphicRaycaster(gameobj)
end

function UIUtils.GetListener(gameobj)
    return CS.LuaUIUtils.GetListener(gameobj)
end

function UIUtils.GetButtonListener(gameobj)
    return CS.LuaUIUtils.GetButtonListener(gameobj)
end

function UIUtils.GetUIContainer(gameobj)
    return CS.LuaUIUtils.GetUIContainer(gameobj)
end

function UIUtils.GetButtonIntervalListener(gameobj,interval)
    return CS.LuaUIUtils.GetButtonIntervalListener(gameobj,interval)
end

function UIUtils.GetSscrollRectDragHelper(gameobj)
    return CS.LuaUIUtils.GetSscrollRectDragHelper(gameobj)
end
function UIUtils.GetDragHelper(gameobj)
    return CS.LuaUIUtils.GetDragHelper(gameobj)
end

function UIUtils.GetBlockHelper(gameobj)
    return CS.LuaUIUtils.GetBlockHelper(gameobj)
end

function UIUtils.GetUIBlockHelper(gameobj, child, callback)
    return CS.LuaUIUtils.GetUIBlockHelper(gameobj, child, callback)
end

function UIUtils.GetLoopVerticalScrollRect(gameobj)
    return CS.LuaUIUtils.GetLoopVerticalScrollRect(gameobj)
end
function UIUtils.SetUIEnable(gameobj, enable)
    return CS.UIUtils.SetUIEnable(gameobj, enable)
end

function UIUtils.AddListItem(item, list)
    return CS.LuaUIUtils.AddListItem(item, list)
end

function UIUtils.GetVirtualList(gameobj)
    return CS.LuaUIUtils.GetVirtualList(gameobj)
end

function UIUtils.GetVirtualListEx(gameobj)
    return CS.LuaUIUtils.GetVirtualListEx(gameobj)
end

function UIUtils.GetPageScroll(gameObj)
    if gameObj then
        return CS.LuaUIUtils.GetPageScroll(gameObj)
    end
    return nil
end

function UIUtils.GetTempBtn(gameObj)
    if gameObj then
        return CS.LuaUIUtils.GetUIContainerBtn(gameObj)
    end
    return nil
end

function UIUtils.GetLoopScrollView(gameObj)
    if gameObj then
        return CS.LuaUIUtils.GetLoopScrollView(gameObj)
    end
    return nil
end

function UIUtils.GetUIRes(path)
    local sourcePrefab = ResSys:GetUIRes(path,false);
    if sourcePrefab == nil then
        print("没有资源 ："..path);
    end
    return sourcePrefab;
end


function UIUtils.GetGizmosPrefab(path,owner);
    local sourcePrefab = ResSys:GetUIGizmos(path,false);
    if sourcePrefab == nil then
        print("没有资源 ："..path);
    end

    if(owner ~= nil) then
        owner:AddAsset(sourcePrefab);
    end
    return sourcePrefab;
end

function UIUtils.GetScrollRectEx(root, path)
    local widgetScroll = UIUtils.GetWidget(root, path, 'ScrollRectEx')

    return widgetScroll
end

function UIUtils.GetImage(root, path)
    local widgetImg = UIUtils.GetWidget(root, path, 'Image')

    return widgetImg
end

function UIUtils.GetText(root, path)
    return UIUtils.GetWidget(root, path, 'Text')
end

function UIUtils.GetRectTransform(root, path)
    return UIUtils.GetWidget(root, path, "RectTransform")
end

function UIUtils.GetToggle(root, path)
    return UIUtils.GetWidget(root, path, "Toggle")
end

function UIUtils.GetButton(root, path)
    return UIUtils.GetWidget(root, path, "Button")
end

function UIUtils.GetTransform(root, path)
    return UIUtils.GetWidget(root, path, "Transform")
end

function UIUtils.GetLayoutElemnt(root, path)
    return UIUtils.GetWidget(root, path, "LayoutElement")
end

function UIUtils.GetLayoutGroup(root, path)
    return UIUtils.GetWidget(root, path, "HorizontalOrVerticalLayoutGroup")
end

function UIUtils.GetAnimator(root, path)
    return UIUtils.GetWidget(root, path, "Animator")
end

function UIUtils.GetAnimatorTime(root, path)
    return UIUtils.GetWidget(root, path, "AniTime")
end

function UIUtils.GetObject(root, path)
    if root == nil then
        return
    end

    if not path or path == "" then
        return root
    end
    local result = UIUtils.FindChild(root.transform, path)
    return result
end

function UIUtils.GetIconSprite(pack,path)
    --local sourceSprite = ResSys:GetIcon(pack,path);
    local sourceSprite = CS.IconUtils.GetIconV2(pack,path);
    if sourceSprite == nil then
        print("没有资源 ："..path);
    end
    return sourceSprite;
end

function UIUtils.GetIconTexture(pack,path)
    local tex =  ResSys:GetIconTexture(pack,path);
    if tex == nil then
        print("没有资源 ："..path);
    end
    return tex;
end

function UIUtils.GetGunMessageSprite(spritename)
    return CS.LuaUIUtils.GetGunMessageSprite(spritename)
end

function UIUtils.OpenNoticeUIPanel(msg)
    CS.LuaUIUtils.OpenNoticePanel(msg)
end

function UIUtils.StringFormat(param,...)
    return CS.LuaUIUtils.StringFormat(param,...);
end

function UIUtils.FindTransform(path)
    local trans = CS.UnityEngine.GameObject.Find(path);
    if trans ~= nil then
        return trans.transform;
    end
    return nil;
end

function UIUtils.FindGameObject(path)
    local trans = CS.UnityEngine.GameObject.Find(path);
    if trans ~= nil then
        return trans;
    end
    return nil;
end

function UIUtils.GetModel(type, tableId, getModelUIType,weaponID)
    return CS.UI3DModelManager.Instance:GetModel(type, tableId, getModelUIType,weaponID);
end

function UIUtils.GetModelNoWeapon(type, tableId, getModelUIType)
    return CS.UI3DModelManager.Instance:GetModel(type, tableId, getModelUIType);
end

function UIUtils.FindChild(transform, path)
    return transform:Find(path);
end

function UIUtils.ForceUpdateCanvases()
    print("force update !!!!!!!")
    CS.UnityEngine.Canvas.ForceUpdateCanvases();
end

function UIUtils.AddSubCanvas(gameObject,order,autoIncrease)
    CS.LuaUIUtils.AddSubCanvas(gameObject,order,autoIncrease);
end

function UIUtils.SetColor(ctrl, color)
    CS.LuaUIUtils.SetColor(ctrl, color);
end

function UIUtils.SetAlpha(ctrl, alpha)
    CS.LuaUIUtils.SetAlpha(ctrl, alpha);
end

function UIUtils.SetTextAlpha(ctrl, alpha)
    CS.LuaUIUtils.SetTxtAlpha(ctrl, alpha);
end

function UIUtils.SetCanvasGroupValue(obj, alpha)
    CS.LuaUIUtils.SetCanvasGroupValue(obj, alpha)
end

function UIUtils.SetInteractive(trans,activity)
    CS.LuaUIUtils.SetInteractive(trans,activity)
end

function UIUtils.ForceRebuildLayout(rectTrans)
    CS.LuaUIUtils.ForceRebuildLayout(rectTrans)
end

function UIUtils.ForceRebuildCanvas()
    CS.LuaUIUtils.ForceRebuildCanvas()
end

function UIUtils.SetChildrenScale(trans,scale,includeSelf)
    CS.LuaUIUtils.SetChildrenScale(trans,scale,includeSelf);
end

function UIUtils.SetGachaEffectMaterailColor(trans,color)
	CS.LuaUIUtils.SetGachaEffectMaterailColor(trans,color);
end

function UIUtils.GetPanelTopZPos(panel)
    return CS.LuaUIUtils.GetPanelTopZPos(panel);
end

function UIUtils.GetPointerClickHelper(go, callback, selfArea)
    return CS.LuaUIUtils.GetPointerClickHelper(go, callback, selfArea)
end

function UIUtils.SetParticleRenderOrder(gameObject, order)
    CS.LuaUIUtils.SetParticleRenderOrder(gameObject, order)
end
function UIUtils.NumberToRomeString(szNum)
    local rmNum = {"Ⅰ","Ⅱ","Ⅲ","Ⅳ","Ⅴ","Ⅵ","Ⅶ","Ⅷ","Ⅸ","Ⅹ"};
    return rmNum[szNum];
end

function UIUtils.GetWidget(root, path, widgetName)
    if root == nil then
        return
    end

    local tObj = nil
    if path == nil or path == "" then
        tObj = root
    else
        tObj = UIUtils.FindChild(root.transform, path)
    end
    if tObj == nil then
        return nil
    end

    local com = tObj:GetComponent(widgetName)
    return com
end

function UIUtils.SplitStrToVector(str, char)
    if str == nil or str == "" then
        return
    end
    char = char == nil and "," or char
    local strArr = string.split(str, char)
    if #strArr < 2 then
        return vectorzero
    end

    if #strArr == 2 then
        return Vector2(tonumber(strArr[1]), tonumber(strArr[2]))
    elseif #strArr == 3 then
        return Vector3(tonumber(strArr[1]), tonumber(strArr[2]), tonumber(strArr[3]))
    end
end

function UIUtils.TransformPoint(rect1, rect2)
    return CS.LuaUIUtils.TransformPoint(rect1, rect2)
end

function UIUtils.CreateGameObj(pos, parent)
    return CS.LuaUIUtils.CreateGameObj(pos, parent)
end

function UIUtils.AddCanvas(obj, sort)
    CS.LuaUIUtils.AddCanvas(obj, sort)
end

function UIUtils.AddHyperTextListener(obj, func)
    CS.LuaUIUtils.AddHyperTextListener(obj, func)
end

function UIUtils.PopupHintMessage(hintId)
    local hint = TableData.GetHintById(hintId)
    if hint == nil then
        hint = ""
    end
    CS.PopupMessageManager.PopupString(hint)
end

function UIUtils.PopupPositiveHintMessage(hintId)
    local hint = TableData.GetHintById(hintId)
    if hint == nil then
        hint = ""
    end
    CS.PopupMessageManager.PopupPositiveString(hint)
end

--- 计算字符个数
function UIUtils.GetStringWordNum(str)
    local lenInByte = #str
    local count = 0
    local i = 1
    while true do
        local curByte = string.byte(str, i)
        if i > lenInByte then
            break
        end
        local byteCount = 1
        if curByte > 0 and curByte < 128 then
            byteCount = 1
        elseif curByte>=128 and curByte<224 then
            byteCount = 2
        elseif curByte>=224 and curByte<240 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        else
            break
        end
        i = i + byteCount
        count = count + 1
    end
    return count
end

function UIUtils.GetEffectMaxDuration(gameObj)
	local duration = 0;
	local particleComponents = getparticlesinchildren(gameObj);
	for i = 0, particleComponents.Length - 1 do
		if particleComponents[i].main.duration > duration then
			duration = particleComponents[i].main.duration;
		end
	end
	return duration;
end

function UIUtils.CallWithAniDelay(obj, callback, aniName)
    local root = UIUtils.GetRectTransform(obj, "Root")
    if root then
        local aniTime = root.gameObject:GetComponent("AniTime")
        local animtor = root.gameObject:GetComponent("Animator")
        if aniTime and animtor then
            if aniName == nil then
                animtor:SetTrigger("FadeOut")
            else
                animtor:SetTrigger(aniName)
            end

            TimerSys:DelayCall(aniTime.m_FadeOutTime, function ()
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


-- 阿拉伯数字转中文大写
function UIUtils.NumberToString(szNum)
    local szChMoney = ""
    local iLen = 0
    local iNum = 0
    local iAddZero = 0
    local hzUnit = {"", "十"}
    local hzNum = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九"}
    if nil == tonumber(szNum) then
        return tostring(szNum)
    end
    iLen =string.len(szNum)
    if iLen > 3 or iLen == 0 or tonumber(szNum) < 0 then
        return tostring(szNum)
    end
    for i = 1, iLen  do
        iNum = string.sub(szNum,i,i)
        if iNum == 0 and i ~= iLen then
            iAddZero = iAddZero + 1
        else
            if iAddZero > 0 then
                szChMoney = szChMoney..hzNum[1]
            end
            szChMoney = szChMoney..hzNum[iNum + 1] --//转换为相应的数字
            iAddZero = 0
        end
        if (iAddZero < 4) and (0 == (iLen - i) % 4 or 0 ~= tonumber(iNum)) then
            szChMoney = szChMoney..hzUnit[iLen-i+1]
        end
    end
    local function removeZero(num)
        --去掉末尾多余的 零
        num = tostring(num)
        local szLen = string.len(num)
        local zero_num = 0
        for i = szLen, 1, -3 do
            szNum = string.sub(num,i-2,i)
            if szNum == hzNum[1] then
                zero_num = zero_num + 1
            else
                break
            end
        end
        num = string.sub(num, 1,szLen - zero_num * 3)
        szNum = string.sub(num, 1,6)
        -- 开头的 "一十" 转成 "十" , 贴近人的读法
        if szNum == hzNum[2]..hzUnit[2] then
            num = string.sub(num, 4, string.len(num))
        end
        return num
    end
    return removeZero(szChMoney)
end

function UIUtils.CheckInputIsLegal(input)
    return CS.LuaUIUtils.CheckInputIsLegal(input)
end

function UIUtils.ScrollRectGotoSelect(selected, scrollRect, viewport)
    CS.LuaUIUtils.ScrollRectGotoSelect(selected, scrollRect, viewport)
end

function UIUtils.BreviaryText(message, textComp, maxLength)
    return CS.LuaUIUtils.BreviaryText(message, textComp, maxLength)
end

function UIUtils.GetFontWidth(message, textComp)
    return CS.LuaUIUtils.GetFontWidth(message, textComp)
end

--endregion


