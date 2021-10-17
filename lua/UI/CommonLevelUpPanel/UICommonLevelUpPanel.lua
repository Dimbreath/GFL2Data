require("UI.UIBasePanel")

UICommonLevelUpPanel = class("UICommonLevelUpPanel", UIBasePanel)
UICommonLevelUpPanel.__index = UICommonLevelUpPanel

UICommonLevelUpPanel.ShowType =
{
    GunLevelUp = 1,
    CommanderLevelUp = 2,
    Settlement = 3
}

UICommonLevelUpPanel.showType = 0
UICommonLevelUpPanel.lvUpData = nil
UICommonLevelUpPanel.callback = nil
UICommonLevelUpPanel.tempLv = "<size=86>Lv.</size>{0}"
UICommonLevelUpPanel.canClose = false;

--- static func ---
function UICommonLevelUpPanel.Open(type, data, showGet, showAllItems)
    UIManager.OpenUIByParam(UIDef.UICommonLevelUpPanel, {type, data, showGet, showAllItems})
end
--- static func ---

function UICommonLevelUpPanel:ctor()
    UICommonLevelUpPanel.super.ctor(self)
end

function UICommonLevelUpPanel.Close()
    self = UICommonLevelUpPanel
    if not self:StopAnimator() then
        self:OpenRewardPanel()
        AccountNetCmdHandler.IsLevelUpdate = false
        UIManager.CloseUI(UIDef.UICommonLevelUpPanel)
    end
end

function UICommonLevelUpPanel.OnRelease()
    self = UICommonLevelUpPanel

    self.mTimer:Stop()
end


function UICommonLevelUpPanel.OnShow()
    self = UICommonLevelUpPanel;
    local canvasGroup = self.mUIRoot:Find("Root"):GetComponent("CanvasGroup")
    canvasGroup.blocksRaycasts = true;
end

function UICommonLevelUpPanel.Init(root, data)
    self = UICommonLevelUpPanel

    self.mIsPop = true
    AccountNetCmdHandler.IsLevelUpdate = false

    UICommonLevelUpPanel.super.SetRoot(UICommonLevelUpPanel, root)

    UICommonLevelUpPanel.mView = UICommonLevelUpPanelView.New()
    UICommonLevelUpPanel.mView:InitCtrl(root)

    if data then
        self.showType = data[1]
        self.showGet = true
        self.showAllItems = false
        if data.Length ~= nil then
            if data.Length >= 4 then
                self.showGet = data[3]
            end
            if data.Length >= 5 then
                self.showAllItems = data[4]
            end
        else
            if data[3] ~= nil then
                self.showGet = data[3]
            end
            if data[4] ~= nil then
                self.showAllItems = data[4]
            end
        end

        if self.showType == UICommonLevelUpPanel.ShowType.CommanderLevelUp then
            self.lvUpData = self:GetCommanderLvUpData()
        elseif self.showType == UICommonLevelUpPanel.ShowType.GunLevelUp then
            self.lvUpData = data[2]
        elseif self.showType == UICommonLevelUpPanel.ShowType.Settlement then
            self.lvUpData = self:GetCommanderLvUpData()
            self.callback = data[2]
        end
    end
end

function UICommonLevelUpPanel.OnInit()
    self = UICommonLevelUpPanel

    UICommonLevelUpPanel.super.SetPosZ(UICommonLevelUpPanel)

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        if(UICommonLevelUpPanel.canClose) then
            UICommonLevelUpPanel.Close()
        end
    end

    self:UpdatePanel()
end

function UICommonLevelUpPanel:UpdatePanel()
    if self.showType == UICommonLevelUpPanel.ShowType.GunLevelUp then
        self:UpdateGunLvUpPanel()
    elseif self.showType == UICommonLevelUpPanel.ShowType.CommanderLevelUp or self.showType == UICommonLevelUpPanel.ShowType.Settlement then
        self:UpdateCommanderLvUpPanel()
    end
end

function UICommonLevelUpPanel:UpdateGunLvUpPanel()
    if self.lvUpData then
        self.mView.mText_Lv.text = string_format(UICommonLevelUpPanel.tempLv, self.lvUpData.level)
        self.mView.mText_BeforeLv.text = string_format(UICommonLevelUpPanel.tempLv, self.lvUpData.beforeLv)

        for _, prop in ipairs(self.lvUpData.propList) do
            local item = LevelUpPropertyItem.New()
            item:InitCtrl(self.mView.mTrans_PropertyList)
            item:SetData(prop)
        end
    end
end

function UICommonLevelUpPanel:UpdateCommanderLvUpPanel()
    if self.lvUpData then
        self.mView.mText_Lv_1.text = self.lvUpData.level % 10;
        self.mView.mText_BeforeLv_1.text = self.lvUpData.beforeLv % 10;

        local before = math.floor(self.lvUpData.beforeLv / 10);
        local after = math.floor(self.lvUpData.level / 10);
        self.mView.mText_Lv_2.text = after;
        self.mView.mText_BeforeLv_2.text = before;

        local beforeStamina = TableData.listPlayerLevelDatas:GetDataById(self.lvUpData.beforeLv).exta_stamina;
        local curStamina = TableData.listPlayerLevelDatas:GetDataById(self.lvUpData.level).exta_stamina;
        local itemName =  TableData.listItemDatas:GetDataById(6).name.str
        local hint = TableData.GetHintById(901021)
        self.mView.mTextName.text = string_format(hint, itemName,(curStamina-beforeStamina));
        

        UICommonLevelUpPanel.mTimer = TimerSys:DelayCall(3, function ()
            self.mView.mAnimText_1:SetTrigger("NumUp")
            if(after > before) then
                self.mView.mAnimText_2:SetTrigger("NumUp")
            end
            UICommonLevelUpPanel.canClose = true;
        end)

        -- self.mView.mTweenNumber.NumberFrom = self.lvUpData.beforeLv;
        -- self.mView.mTweenNumber.NumberTo = self.lvUpData.level;

        -- local t = (self.lvUpData.level - self.lvUpData.beforeLv) * 0.2;
        -- self.mView.mTweenNumber.duration = t;
        -- self.mView.mTweenNumber:Play();

        for _, prop in ipairs(self.lvUpData.propList) do
            local item = LevelUpPropertyItem.New()
            item:InitCtrl(self.mView.mTrans_PropertyList)
            item:SetDataByName(prop.name, prop.beforeValue, prop.afterValue)
        end

        if(self.lvUpData.level== self.lvUpData.beforeLv) then
            UICommonLevelUpPanel.canClose = true;
        else
            UICommonLevelUpPanel.canClose = false;

            TimerSys:DelayCall(1 ,function(idx) 
                setactive(self.mView.mTrans_LvUp,true)
                --setactive(self.mView.mTrans_Text,false)
                --UICommonLevelUpPanel.canClose = true;
            end,0);
        end
    end
end


function UICommonLevelUpPanel:GetCommanderLvUpData()
    local lvUpData = {}
    lvUpData.beforeLv = AccountNetCmdHandler.mLevelPre
    lvUpData.level = AccountNetCmdHandler:GetLevel()
    lvUpData.propList = {}
    lvUpData.rewardList = {}

    local prop = {}
    local itemData = TableData.listItemDatas:GetDataById(GlobalConfig.MaxStaminaId)
    local levelData = TableData.listPlayerLevelDatas:GetDataById(lvUpData.level)
    prop.name = itemData.introduction.str
    prop.beforeValue = AccountNetCmdHandler.mMaxStaminaPre
    prop.afterValue = GlobalData.GetStaminaResourceMaxNum(GlobalConfig.StaminaId)
    table.insert(lvUpData.propList, prop)

    for id, value in pairs(levelData.reward_show) do
        local item = {}
        item.ItemId = id
        item.ItemNum = value
        table.insert(lvUpData.rewardList, item)
    end
    return lvUpData
end

function UICommonLevelUpPanel:OpenRewardPanel()
    if self.lvUpData then
        if self.showType == UICommonLevelUpPanel.ShowType.CommanderLevelUp or self.showType == UICommonLevelUpPanel.ShowType.Settlement then
            if self.showGet then
                if self.showAllItems then
                    UIManager.OpenUIByParam(UIDef.UICommonReceivePanel, {nil, self.callback, {}, true})
                else
                    UIManager.OpenUIByParam(UIDef.UICommonReceivePanel, {self.lvUpData.rewardList, self.callback, {}})
                end

            end
        end
    end
end

function UICommonLevelUpPanel:StopAnimator()
    if self.mView.mAnimator then
        local animationState = self.mView.mAnimator:GetCurrentAnimatorStateInfo(0)
        if animationState:IsName("UICharacterLevelUpPop") and animationState.normalizedTime < 1 then
            self.mView.mAnimator:Play("UICharacterLevelUpPop", 0, 1)
            return true
        end
    end
    return false
end



