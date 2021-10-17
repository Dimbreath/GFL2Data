require("UI.UIBasePanel")

---@class UISettingSubPanel : UIBasePanel
UISettingSubPanel = class("UISettingSubPanel")
UISettingSubPanel.__index = UISettingSubPanel
---@type UISettingSubPanelView
UISettingSubPanel.mView = nil
UISettingSubPanel.Tab = {
    Sound = 1,
    Graphic = 2,
    Account = 3,
    Others = 4
}

UISettingSubPanel.SoundSettings = {
    SoundEffect = 11,
    BackGround = 12,
    Voice = 13,
}

UISettingSubPanel.GraphicSettings = {
    All = 20,
    Resolution = 21,
    Render = 22,
    Shadow = 23,
    PostProcess = 24,
    Effect = 25,
    FPS = 26,
    Bloom = 27,
    AntiAliasing = 28,
    Outline = 29,
}

UISettingSubPanel.AccountButtons = {
    Exit = 31,
    Center = 32,
    Service = 33
}

UISettingSubPanel.Others = {
    Gender = 41,
    Avg = 42,
    --Language = 43,
    UAV = 43
}

function UISettingSubPanel:ctor(root)
    self = UISettingSubPanel
    self.mUIRoot = root;
    self.mTopTabViewList = {}
    self.mSettingList = {}
    self.mOthersList = {}
    self.curTab = 0

    self.mView = UISettingSubPanelView.New()
    self.mView:InitCtrl(self.mUIRoot)
    self:InitTabList()
    self:InitSoundList()
    self:InitGraphicList()
    self:InitAccount()
    self:InitOthers()
    self:OnClickTab(UISettingSubPanel.Tab.Sound)
end

function UISettingSubPanel.Show()
    self = UISettingSubPanel
    local lastTab = self.curTab
    self.curTab = 0
    self:OnClickTab(lastTab)
end

function UISettingSubPanel:InitTabList()
    for i = 1, 4 do
        ---@type UIComTabBtn1Item
        local topTab = UIComTabBtn1Item.New()
        topTab:InitCtrl(self.mView.mContent_Top.transform);
        self.mTopTabViewList[i] = topTab
        topTab:SetData({ id = 0, name = TableData.GetHintById(104000 + i) })
        UIUtils.GetListener(topTab.mBtn_Item.gameObject).onClick = function()
            self:OnClickTab(i)
        end
    end
end

function UISettingSubPanel:OnClickTab(id)
    if self.curTab == id or id == nil or id <= 0 then
        return
    end
    if self.curTab > 0 then
        local lastTab = self.mTopTabViewList[self.curTab]
        lastTab.mBtn_Item.interactable = true
    end
    ---@type UICommonLeftTabItemV2
    local curTabItem = self.mTopTabViewList[id]
    curTabItem.mBtn_Item.interactable = false
    self.curTab = id

    setactive(self.mView.mTrans_Sound, id == self.Tab.Sound)
    setactive(self.mView.mTrans_PictureQuality, id == self.Tab.Graphic)
    setactive(self.mView.mTrans_Account, id == self.Tab.Account)
    setactive(self.mView.mTrans_Other, id == self.Tab.Others)
    if (id == self.Tab.Graphic) then
        for id = 20, 29 do
            local setting = UISettingSubPanel.mSettingList[id]
            if setting ~= nil then
                setting:RefreshScreenPos()
            end
        end
    elseif (id == self.Tab.Others) then
        for id = 41, 43 do
            local setting = UISettingSubPanel.mOthersList[id]
            if setting ~= nil then
                setting:RefreshScreenPos()
            end
        end
    end
end

function UISettingSubPanel:InitSoundList()
    for id = 11, 13 do
        ---@type UICommonSettingItem
        local item = UICommonSettingItem.New()
        item:InitCtrl(self.mView.mContent_Sound);

        local data = { id = id, name = TableData.GetHintById(103998 + id), type = 1, listener = function (ptc)
            UISettingSubPanel:OnSoundValueChange(id, item, ptc)
        end };
        if (id == UISettingSubPanel.SoundSettings.SoundEffect) then
            data.value = CS.BattlePerformSetting.VolumeValue
        elseif (id == UISettingSubPanel.SoundSettings.BackGround) then
            data.value = CS.BattlePerformSetting.BGMVolumeValue
        elseif (id == UISettingSubPanel.SoundSettings.Voice) then
            data.value = CS.BattlePerformSetting.VoiceValue
        end

        item:SetData(data)
    end
end

function UISettingSubPanel:OnSoundValueChange(id, item, value)
    if (id == UISettingSubPanel.SoundSettings.SoundEffect) then
        CS.BattlePerformSetting.VolumeValue = value;
    elseif (id == UISettingSubPanel.SoundSettings.BackGround) then
        CS.BattlePerformSetting.BGMVolumeValue = value;
    elseif (id == UISettingSubPanel.SoundSettings.Voice) then
        CS.BattlePerformSetting.VoiceValue = value;
    end
    item.mText_Num.text = FormatNum(math.floor(value * 100));
end

function UISettingSubPanel:InitGraphicList()

    for id = 20, 20 do
        ---@type UICommonSettingItem
        local item = UICommonSettingItem.New()
        item:InitCtrl(self.mView.mTrans_GlobalSetting, function() UISettingSubPanel:OnClickDropDown(item) end);
        local data = { id = id, type = 2 };
        if (id == UISettingSubPanel.GraphicSettings.All) then
            data.name = TableData.GetHintById(104015)
            data.list = {
                TableData.GetHintById(104024),
                TableData.GetHintById(104025),
                TableData.GetHintById(104026),
                TableData.GetHintById(104027),
                TableData.GetHintById(104028),
            }
            data.value = CS.BattlePerformSetting.AllQualityVale + 1 --默认多一个自定义
            data.listener = function (ptc)
                UISettingSubPanel:OnDropDownAllQualityValueChange(ptc)
            end
        end
        item:SetData(data)
        self.mSettingList[id] = item;
    end

    local start = 22
    if (CS.GameRoot.Instance.AdapterPlatform == CS.PlatformSetting.PlatformType.PC) then
        start = 21
    end
    for id = start, 29 do
        ---@type UICommonSettingItem
        local item = UICommonSettingItem.New()
        item:InitCtrl(self.mView.mTrans_OtherSettings, function() UISettingSubPanel:OnClickDropDown(item) end);

        local data = { id = id, name = TableData.GetHintById(103994 + id), type = 2, listener = function (ptc)
            UISettingSubPanel:OnGraphicValueChange(id, ptc)
        end };
        if (id == UISettingSubPanel.GraphicSettings.Resolution) then
            data.name = TableData.GetHintById(104046)
            data.list = {}
            local resolutions = CS.GraphicsSettingsManager.Instance.Resolutions
            for i = 0, resolutions.Count - 1 do
                if i == 0 then
                    table.insert(data.list, TableData.GetHintById(104047))
                else
                    local resolution = resolutions[i]
                    table.insert(data.list, resolution.width .. " * " .. resolution.height)
                end
            end
            if (CS.GameRoot.Instance.AdapterPlatform == CS.PlatformSetting.PlatformType.PC) then
                data.value = CS.BattlePerformSetting.Resolution
            else
                data.value = 0
            end
        elseif (id == UISettingSubPanel.GraphicSettings.Render) then
            data.value = CS.BattlePerformSetting.RenderQualityVale
            data.list = {
                TableData.GetHintById(104025),
                TableData.GetHintById(104026),
                TableData.GetHintById(104042),
                TableData.GetHintById(104027),
                TableData.GetHintById(104028),
            }
        elseif (id == UISettingSubPanel.GraphicSettings.Shadow) then
            data.value = CS.BattlePerformSetting.ShadowValue
            data.list = {
                TableData.GetHintById(104031),
                TableData.GetHintById(104032),
                TableData.GetHintById(104033),
                TableData.GetHintById(104034)
            }
        elseif (id == UISettingSubPanel.GraphicSettings.PostProcess) then
            data.value = CS.BattlePerformSetting.PostprocessingValue
            data.list = {
                TableData.GetHintById(104030),
                TableData.GetHintById(104031),
                TableData.GetHintById(104032),
                TableData.GetHintById(104033)
            }
        elseif (id == UISettingSubPanel.GraphicSettings.Effect) then
            data.value = CS.BattlePerformSetting.EffectValue
            data.list = {
                TableData.GetHintById(104031),
                TableData.GetHintById(104032),
                TableData.GetHintById(104033),
                TableData.GetHintById(104034)
            }
        elseif (id == UISettingSubPanel.GraphicSettings.FPS) then
            data.value = CS.BattlePerformSetting.FPSValue
            data.list = {
                "30", "60"
            }
        elseif (id == UISettingSubPanel.GraphicSettings.Bloom) then
            data.value = CS.BattlePerformSetting.BloomValue
            data.list = {
                TableData.GetHintById(104030),
                TableData.GetHintById(104029),
            }
        elseif (id == UISettingSubPanel.GraphicSettings.AntiAliasing) then
            data.value = CS.BattlePerformSetting.AntiAliasingValue
            data.list = {
                TableData.GetHintById(104030),
                TableData.GetHintById(104031),
                TableData.GetHintById(104032),
                TableData.GetHintById(104033)
            }
        elseif (id == UISettingSubPanel.GraphicSettings.Outline) then
            data.value = CS.BattlePerformSetting.OutlineValue
            data.list = {
                TableData.GetHintById(104031),
                TableData.GetHintById(104032),
                TableData.GetHintById(104033),
                TableData.GetHintById(104034)
            }
        end

        item:SetData(data)
        self.mSettingList[id] = item
    end
end

function UISettingSubPanel:OnClickDropDown(item)
    for id = 20, 29 do
        local setting = UISettingSubPanel.mSettingList[id]
        if setting ~= nil then
            if item ~= setting or setting.isSortDropDownActive then
                setting.isSortDropDownActive = false
                setactive(setting.mList_Screen.transform, setting.isSortDropDownActive)
            else
                setting.isSortDropDownActive = not setting.isSortDropDownActive
                setactive(setting.mList_Screen.transform, setting.isSortDropDownActive)
            end
        end
    end
end

function UISettingSubPanel:OnDropDownAllQualityValueChange(value)
    if value == 0 then
        return;
    end
    value = value - 1

    CS.BattlePerformSetting.SetAllQualityValue(value); -- 设置全部变量

    self.mSettingList[self.GraphicSettings.Render]:SetDropDownValue(CS.BattlePerformSetting.RenderQualityVale)
    self.mSettingList[self.GraphicSettings.Shadow]:SetDropDownValue(CS.BattlePerformSetting.ShadowValue)
    self.mSettingList[self.GraphicSettings.PostProcess]:SetDropDownValue(CS.BattlePerformSetting.PostprocessingValue)
    self.mSettingList[self.GraphicSettings.Effect]:SetDropDownValue(CS.BattlePerformSetting.EffectValue)
    --self.mView.mDropDownFPS.value = CS.BattlePerformSetting.FPSValue
    self.mSettingList[self.GraphicSettings.Bloom]:SetDropDownValue(CS.BattlePerformSetting.BloomValue)
    self.mSettingList[self.GraphicSettings.AntiAliasing]:SetDropDownValue(CS.BattlePerformSetting.AntiAliasingValue)
    self.mSettingList[self.GraphicSettings.Outline]:SetDropDownValue(CS.BattlePerformSetting.OutlineValue)

    CS.BattlePerformSetting.AllQualityVale = value;
end

function UISettingSubPanel:OnGraphicValueChange(id, value)
    if (id == UISettingSubPanel.GraphicSettings.All) then
        CS.BattlePerformSetting.AllQualityVale = value--默认多一个自定义
    elseif (id == UISettingSubPanel.GraphicSettings.Resolution) then
        CS.BattlePerformSetting.Resolution = value
    elseif (id == UISettingSubPanel.GraphicSettings.Render) then
        CS.BattlePerformSetting.RenderQualityVale = value
    elseif (id == UISettingSubPanel.GraphicSettings.Shadow) then
        CS.BattlePerformSetting.ShadowValue = value
    elseif (id == UISettingSubPanel.GraphicSettings.PostProcess) then
        CS.BattlePerformSetting.PostprocessingValue = value
    elseif (id == UISettingSubPanel.GraphicSettings.Effect) then
        CS.BattlePerformSetting.EffectValue = value
    elseif (id == UISettingSubPanel.GraphicSettings.FPS) then
        CS.BattlePerformSetting.FPSValue = value
    elseif (id == UISettingSubPanel.GraphicSettings.Bloom) then
        CS.BattlePerformSetting.BloomValue = value
    elseif (id == UISettingSubPanel.GraphicSettings.AntiAliasing) then
        CS.BattlePerformSetting.AntiAliasingValue = value
    elseif (id == UISettingSubPanel.GraphicSettings.Outline) then
        CS.BattlePerformSetting.OutlineValue = value
    end
    self.mSettingList[20]:SetDropDownValue(0)
    CS.BattlePerformSetting.AllQualityVale = -1;
end

function UISettingSubPanel:InitAccount()
    UIUtils.GetListener(self.mView.mBtn_Exit.gameObject).onClick = function()
        UISettingSubPanel:OnClickLogOut();
    end


    UIUtils.GetListener(self.mView.mBtn_Center.gameObject).onClick = function()
        UISettingSubPanel:OnClickUserCenter();
    end

    UIUtils.GetListener(self.mView.mBtn_Service.gameObject).onClick = function()
        UISettingSubPanel:OnClickCustomerCenter();
    end
end

function UISettingSubPanel:OnClickLogOut()
    UICommanderInfoPanelV2:OnClose()
    AccountNetCmdHandler:Logout()
end

function UISettingSubPanel:OnClickUserCenter()
    CS.GF2.SDK.PlatformLoginManager.Instance:UserCenter()
end

function UISettingSubPanel:OnClickCustomerCenter()
    CS.GF2.SDK.PlatformLoginManager.Instance:CustomerCenter()
end

function UISettingSubPanel:InitOthers()
    for id = 41, 43 do
        ---@type UICommonSettingItem
        local item = UICommonSettingItem.New()
        item:InitCtrl(self.mView.mContent_Other, function() UISettingSubPanel:OnClickOthersDropDown(item) end);

        local data = { id = id, type = 2, listener = function (ptc)
            UISettingSubPanel:OnOthersValueChange(id, ptc)
        end };
        if id == self.Others.Gender then
            data.value = AccountNetCmdHandler.Gender
            data.name = TableData.GetHintById(104012)
            data.list = {
                TableData.GetHintById(104013),
                TableData.GetHintById(104014)
            }
        elseif (id == UISettingSubPanel.Others.Avg) then
            data.value = AccountNetCmdHandler.AvgRepetion
            data.name = TableData.GetHintById(104035)
            data.list = {
                TableData.GetHintById(104036),
                TableData.GetHintById(104037)
            }
        elseif (id == UISettingSubPanel.Others.Language) then
            data.value = AccountNetCmdHandler.AvgVoice
            data.name = TableData.GetHintById(104038)
            data.list = {
                TableData.GetHintById(104039),
                TableData.GetHintById(104040),
                TableData.GetHintById(104041),
            }
        elseif (id == UISettingSubPanel.Others.UAV) then
            data.value = AccountNetCmdHandler.UAVHint
            data.name = TableData.GetHintById(104043)
            data.list = {
                TableData.GetHintById(104044),
                TableData.GetHintById(104045)
            }
        end
        item:SetData(data)
        self.mOthersList[id] = item
    end
end

function UISettingSubPanel:OnClickOthersDropDown(item)
    for id = 41, 43 do
        local other = UISettingSubPanel.mOthersList[id]
        if item ~= other or other.isSortDropDownActive then
            other.isSortDropDownActive = false
            setactive(other.mList_Screen.transform, other.isSortDropDownActive)
        else
            other.isSortDropDownActive = not other.isSortDropDownActive
            setactive(other.mList_Screen.transform, other.isSortDropDownActive)
        end
    end
end

function UISettingSubPanel:OnOthersValueChange(id, value)
    if (id == UISettingSubPanel.Others.Gender) then
        AccountNetCmdHandler.Gender = value--默认多一个自定义
    elseif (id == UISettingSubPanel.Others.Avg) then
        AccountNetCmdHandler.AvgRepetion = value;
    elseif (id == UISettingSubPanel.Others.Language) then
        AccountNetCmdHandler.AvgVoice = value;
    elseif (id == UISettingSubPanel.Others.UAV) then
        AccountNetCmdHandler.UAVHint = value;
    end
end
