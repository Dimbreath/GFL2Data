TipsManager = {};
local this = TipsManager;

--这里的itemData必须用C#封装的ItemCmdData作为参数才能使用

function TipsManager.Add(gameObject, param, paramData, paramData2, paramData3, paramData4, paramData5,paramData6)
    --printstack("添加tips事件！"..gameObject.name);
    local click = UIUtils.GetButtonListener(gameObject);
    click.param = param;
    click.paramData = {paramData, paramData2, paramData3, paramData4, paramData5,paramData6};
    click.onClick = TipsManager.OnItemClick;
end

function TipsManager.OnItemClick(gameObject)
    if gameObject ~= nil then
        local click = getcomponent(gameObject, typeof(CS.ButtonEventTriggerListener));
        if click ~= nil then
            local item = click.param;
            local num = click.paramData[1];
            local needGetWay = click.paramData[2];
            local showTime = click.paramData[3]
            local relateId = click.paramData[4] or 0
            local opencallback = click.paramData[5]
            local closecallback= click.paramData[6]
            if item ~= nil then
                if opencallback then opencallback() end
                if item.type == 4 then
                    UIUnitInfoPanel.Open(UIUnitInfoPanel.ShowType.GunItem, item.args[0])
                else
                    UITipsPanel.Open(item, num, needGetWay, showTime, relateId,closecallback);
                end
            end
        end
    end
end

function TipsManager.ShowStaminaTips()
    local storeData = NetCmdStoreData:GetStoreGoodById(1)
    if storeData.remain_times > 0 then
        local prizeData = storeData.ItemAndNum
        local title = TableData.GetHintById(208)
        local hint = string_format(TableData.GetHintById(201), storeData.price, prizeData[0].num, storeData.remain_times)
        MessageBox.Show(title, hint, TableData.GetHintById(20), TableData.GetHintById(19), nil, function ()
            UIManager.OpenUIByParam(UIDef.UICommonGetPanel)
        end)
    else
        local title = TableData.GetHintById(208)
        local hint = TableData.GetHintById(203)
        MessageBox.Show(title, hint, TableData.GetHintById(18),nil, CS.MessageBox.ShowFlag.eMidBtn)
    end
end

function TipsManager.CheckStaminaIsEnough(needStamina)
    local playerStamina = GlobalData.GetStaminaResourceItemCount(GlobalConfig.StaminaId)
    if needStamina > playerStamina then
        local hint = GlobalConfig.GetCostNotEnoughStr(GlobalConfig.StaminaId)
        CS.PopupMessageManager.PopupString(hint)
        UIManager.OpenUIByParam(UIDef.UICommonGetPanel);
        return false
    end
    return true
end

function TipsManager.CheckStaminaIsEnoughOnly(needStamina)
    local playerStamina = GlobalData.GetStaminaResourceItemCount(GlobalConfig.StaminaId)
    if needStamina > playerStamina then
        local itemData = TableData.listItemDatas:GetDataById(101)
        local hint = string_format(TableData.GetHintById(200),itemData.name.str)
        local title = TableData.GetHintById(64)
        --CS.PopupMessageManager.PopupString(hint)

        MessageBoxPanel.ShowDoubleType(hint, function ()
            TipsManager.ShowBuyStamina()
        end,nil,title)
        MessageBoxPanel.IsQuickClose = true;
        return false
    end
    return true
end

function TipsManager.ShowBuyStamina()

    local jumpData = TableData.listJumpListDatas:GetDataById(7)
	local unlockId = jumpData.unlock_id;
	if(TipsManager.NeedLockTips(unlockId)) then
		return
	end

    --要等上一个弹窗完全关闭，不然sortlayer会乱，很恶心
    TimerSys:DelayCall(0.5,function(obj)
        UIManager.OpenUIByParam(UIDef.UICommonGetPanel);
    end)
    --UIManager.OpenUIByParam(UIDef.UICommonGetPanel);
end


function TipsManager.CheckTrainingCountIsEnough()
    local count = NetCmdItemData:GetResItemCount(GlobalConfig.TrainingTicket)
    if count <= 0 then
        local hint = GlobalConfig.GetCostNotEnoughStr(GlobalConfig.TrainingTicket)
        CS.PopupMessageManager.PopupString(hint)
        return false
    end
    return true
end

--- type 判断类型  默认芯片和装备都判断
function TipsManager.CheckRepositoryIsFullByType(type)
    local count = 0
    local roleCount = 0
    if type == UIRepositoryGlobal.TabType.Equip then
        count = NetCmdEquipData:GetEquipCount()
        roleCount = CS.GF2.Data.GlobalData.equip_capacity
    elseif type == UIRepositoryGlobal.TabType.Weapon then
        count = NetCmdWeaponData:GetEnhanceWeaponList(0).Count
        roleCount = CS.GF2.Data.GlobalData.weapon_capacity
    end

    if count >= roleCount then
        local hint = ""
        if type == UIRepositoryGlobal.TabType.Equip then
            hint = TableData.GetHintById(30010)
            MessageBox.Show("", hint, nil, function ()
                UIManager.JumpUIByParam(UIDef.UIRepositoryDecomposePanelV2, {UIRepositoryDecomposePanelV2.panelType.EQUIP, true})
            end , nil)
        elseif type == UIRepositoryGlobal.TabType.Weapon then
            hint = TableData.GetHintById(30009)
            MessageBox.Show("", hint, nil, function ()
                UIManager.JumpUIByParam(UIDef.UIRepositoryDecomposePanelV2, {UIRepositoryDecomposePanelV2.panelType.WEAPON, true})
            end , nil)
        end
        return true
    end

    return false
end

function TipsManager.CheckRepositoryIsFull()
    if TipsManager.CheckRepositoryIsFullByType(UIRepositoryGlobal.TabType.Equip) then
        return true
    elseif TipsManager.CheckRepositoryIsFullByType(UIRepositoryGlobal.TabType.Weapon) then
        return true
    end
    return false
end

function TipsManager.NeedLockTips(type)
    if type == 0 or type == nil then
        return false
    end
    if not AccountNetCmdHandler:CheckSystemIsUnLock(type) then
        local lockInfo = TableData.GetUnLockInfoByType(type)
        if lockInfo then
            CS.PopupMessageManager.PopupString(lockInfo.prompt.str)
        end
        return true
    end
    return false
end

function TipsManager.CheckItemIsOverflow(itemId, count, needShowMessage)
    count = count == nil and 0 or count
    needShowMessage = needShowMessage == nil and true or needShowMessage
    local itemData = TableData.GetItemData(itemId)
    if itemData then
        local maxCount = 0
        local maxLimit = TableData.listItemLimitDatas:GetDataById(itemId, true)
        if maxLimit then
            maxCount = maxLimit.max_limit
        else
            local type = itemData.type
            local typeData = TableData.listItemTypeDescDatas:GetDataById(type)
            if typeData.related_item and typeData.related_item > 0 then
                local maxLimit = NetCmdItemData:GetItemCountById(typeData.related_item)
                maxCount = maxLimit
            else
                maxCount = typeData.max_limit
            end
        end
        if maxCount <= 0 then
            return false
        else
            local ownCount = NetCmdItemData:GetItemCountById(itemId)
            if ownCount + count > maxCount then
                if needShowMessage then
                    if itemData.type == GlobalConfig.ItemType.Weapon then
                        local hint = string_format(TableData.GetHintById(40006),TableData.GetHintById(30007))
                        MessageBoxPanel.ShowGotoType(hint, function ()
                            UIManager.OpenUIByParam(UIDef.UIRepositoryPanelV2, UIRepositoryGlobal.TabType.Weapon)
                        end, nil, nil, TableData.GetHintById(20))
                    elseif itemData.type == GlobalConfig.ItemType.EquipmentType then
                        local hint = string_format(TableData.GetHintById(40006),TableData.GetHintById(30005))
                        MessageBoxPanel.ShowGotoType(hint, function ()
                            UIManager.OpenUIByParam(UIDef.UIRepositoryPanelV2, UIRepositoryGlobal.TabType.Equip)
                        end, nil, nil, TableData.GetHintById(20))
                    else
                        local hint = TableData.GetHintById(40006)
                        MessageBoxPanel.ShowSingleType(string_format(hint, itemData.name.str))
                    end
                end
                return true
            else
                return false
            end
        end
    end

    return false
end

function TipsManager.CheckItemListIsOverflow(list, needShowMessage)
    local allNum = 0
    for itemId, num in pairs(list) do
        needShowMessage = needShowMessage == nil and true or needShowMessage
        local itemData = TableData.GetItemData(itemId)
        if itemData then
            local maxCount = 0
            local maxLimit = TableData.listItemLimitDatas:GetDataById(itemId, true)
            if maxLimit then
                maxCount = maxLimit.max_limit
            else
                local type = itemData.type
                local typeData = TableData.listItemTypeDescDatas:GetDataById(type)
                if typeData.related_item and typeData.related_item > 0 then
                    local maxLimit = NetCmdItemData:GetItemCountById(typeData.related_item)
                    maxCount = maxLimit
                else
                    maxCount = typeData.max_limit
                end
            end
            if maxCount <= 0 then
                return false
            else
                local ownCount = NetCmdItemData:GetItemCountById(itemId)
                allNum = allNum + num;
                if ownCount + allNum > maxCount then
                    if needShowMessage then
                        if itemData.type == GlobalConfig.ItemType.Weapon then
                            local hint = string_format(TableData.GetHintById(40006),TableData.GetHintById(30007))
                            MessageBoxPanel.ShowGotoType(hint, function ()
                                UIManager.OpenUIByParam(UIDef.UIRepositoryPanelV2, UIRepositoryGlobal.TabType.Weapon)
                            end, nil, nil, TableData.GetHintById(20))
                        elseif itemData.type == GlobalConfig.ItemType.EquipmentType then
                            local hint = string_format(TableData.GetHintById(40006),TableData.GetHintById(30005))
                            MessageBoxPanel.ShowGotoType(hint, function ()
                                UIManager.OpenUIByParam(UIDef.UIRepositoryPanelV2, UIRepositoryGlobal.TabType.Equip)
                            end, nil, nil, TableData.GetHintById(20))
                        else
                            local hint = TableData.GetHintById(40006)
                            MessageBoxPanel.ShowSingleType(string_format(hint, itemData.name.str))
                        end
                    end
                    return true
                end
            end
        end
    end


    return false
end



