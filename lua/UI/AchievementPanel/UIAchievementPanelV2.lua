---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 18/11/7 20:31
---

require("UI.UIBasePanel")
require("UI.AchievementPanel.UIAchievementPanelV2View");

UIAchievementPanelV2 = class("UIAchievementPanelV2", UIBasePanel);
UIAchievementPanelV2.__index = UIAchievementPanelV2;
---@type UIAchievementPanelV2View
UIAchievementPanelV2.mView = nil;
UIAchievementPanelV2.mData = nil;
UIAchievementPanelV2.mCurTagItem = nil;
UIAchievementPanelV2.mAchieveItemList = {};
UIAchievementPanelV2.mUICommonReceiveItem=nil;
UIAchievementPanelV2.mUICommonReceiveItemData = nil;
UIAchievementPanelV2.allClicked = false

UIAchievementPanelV2.mPath_UICommonTabButtonItem = "UICommonFramework/UI_CommonTabButtonItem.prefab"

function UIAchievementPanelV2:ctor()
    UIAchievementPanelV2.super.ctor(self);
end

function UIAchievementPanelV2.Open()
    self = UIAchievementPanelV2;
end

function UIAchievementPanelV2.Close()
    UIManager.CloseUI(UIDef.UIAchievementPanel);
end

function UIAchievementPanelV2.Hide()
    self = UIAchievementPanelV2;
    self:Show(false);
end

function UIAchievementPanelV2.Init(root, data)
    self = UIAchievementPanelV2;
    self.mData = data;
    self:SetRoot(root);
end


function UIAchievementPanelV2.OnInit()
    self = UIAchievementPanelV2;

    self.mView = UIAchievementPanelV2View;
    self.mView:InitCtrl(self.mUIRoot);
    self.RedPointType = {RedPointConst.Achievement}
    self.allClicked = false
    UIUtils.GetButtonListener(UIAchievementPanelV2.mView.mBtn_Back.gameObject).onClick = self.OnReturnClicked;
    UIUtils.GetButtonListener(UIAchievementPanelV2.mView.mBtn_Home.gameObject).onClick = function()
        CS.BattlePerformSetting.RefreshGraphicSetting();
        UIManager.JumpToMainPanel();
    end
    UIUtils.GetButtonListener(UIAchievementPanelV2.mView.mBtn_GetAll.gameObject).onClick = self.OnAllReceiveClick;
    UIUtils.GetButtonListener(UIAchievementPanelV2.mView.mBtn_CompleteQuest.gameObject).onClick = self.OnTagRewardReceive;

    self.mView.mText_CompleteQuest.text = TableData.GetHintById(901001)
    self.mView.mText_TextUnCompleted.text = TableData.GetHintById(901002)
    self.mView.mText_TextCompleted.text = TableData.GetHintById(901003)
    self.mView.mText_Name1.text = TableData.GetHintById(901002)
    self.mView.mText_Name.text = TableData.GetHintById(901003)

    self.mView.mVirtualList_Achievement.itemProvider = self.itemProvider

    self.mItemViewList = List:New();
    self.mLeftTabViewList = List:New();
    self:InitAchieveTagList();
end

function UIAchievementPanelV2.OnShow()
    self = UIAchievementPanelV2;

    self:UpdatePanel()
end

function UIAchievementPanelV2.itemProvider()
    self = UIAchievementPanelV2
    ---@type UIAchievementItemV2
    local itemView = UIAchievementItemV2.New()
    itemView:InitCtrl(self.mView.mTrans_Achievement.gameObject);
    local renderDataItem = CS.RenderDataItem()
    renderDataItem.renderItem = itemView:GetRoot().gameObject
    renderDataItem.data = itemView
    table.insert(self.mAchieveItemList, itemView)
    return renderDataItem
end

function UIAchievementPanelV2:ItemRenderer(index, renderData)
    local data = self.list[index]
    ---@type UIAchievementItemV2
    local item = renderData.data
    item:SetData(data)
    local itemBtn1 = UIUtils.GetButtonListener(item.mBtn_GotoQuest.gameObject);
    itemBtn1.onClick = self.OnGotoClick;
    itemBtn1.param = data;

    itemBtn1 = UIUtils.GetButtonListener(item.mBtn_CompleteQuest.gameObject);
    itemBtn1.onClick = self.OnReceiveClick;
    itemBtn1.param = data;
end

function UIAchievementPanelV2:InitAchieveTagList()
    for i = 0, TableData.listAchievementTagDatas.Count - 1 do
        local tagData = TableData.listAchievementTagDatas[i]
        ---@type UIAchievementLeftTabItemV2
        local tagItem = UIAchievementLeftTabItemV2.New()
        tagItem:InitCtrl(self.mView.mContent_Material)
        self.mLeftTabViewList:Add(tagItem)
        tagItem:SetData(tagData);
        UIUtils.GetButtonListener(tagItem:GetSelfButton().gameObject).onClick = function()
            self.OnClickTag(tagItem)
        end

        if tagData.id == self.mData then
            self.OnClickTag(tagItem)
        end
        i  = i + 1;
    end  
end


function UIAchievementPanelV2:UpdateAchieveList()
    self.list = NetCmdAchieveData:GetAchieveDataListByTag(self.mCurTagItem.tagId);
    local canReceive = {}
    local allComplete = true
    self.mView.mVirtualList_Achievement.itemRenderer = function(index, renderDataItem)
        self:ItemRenderer(index, renderDataItem)
    end

    for i = 0, self.list.Count - 1 do
        local data = self.list[i];
        if data.IsCompleted and not data.IsReceived then
            table.insert(canReceive, data.Id)
        end

        allComplete = data.Progress == 1
    end
    self.mView.mVirtualList_Achievement.numItems = self.list.Count
    self.mView.mVirtualList_Achievement:Refresh()
    self.mView.mVirtualList_Achievement.content.anchoredPosition = vector2zero
    self.mView.mVirtualList_Achievement:StopMovement()
    UIUtils.GetButtonListener(self.mView.mBtn_GetAll.gameObject).param = canReceive
    setactive(self.mView.mTrans_Receive, #canReceive > 0)
    setactive(self.mView.mTrans_TextCompleted, self.list.Count > 0 and allComplete and #canReceive == 0)
    setactive(self.mView.mTrans_TextUnCompleted, not allComplete and #canReceive == 0 or self.list.Count == 0)

    self:UpdateAchieveAll(self.mCurTagItem.mData)
end

function UIAchievementPanelV2:UpdateAchieveAll(data)
    self.mView.mText_Tittle.text = data.tag_name
    self.mView.mImg_Icon.sprite = IconUtils.GetAchievementIcon(data.icon)
    local rewardNotReceivedId = NetCmdAchieveData:GetCurrentNotReceivedTagRewardId(data.id)
    local rewardId = NetCmdAchieveData:GetCurrentTagRewardId(data.id)
    local count = 0
    local rewardData = nil
    local nextRewardData = nil
    local reward = nil
    if rewardNotReceivedId == -1 then
        count = NetCmdAchieveData:GetCurrentTagRewardLevelProgress(data);
        rewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId);
        if TableData.listAchievementRewardDatas:ContainsId(rewardId + 1) then
            nextRewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId + 1);
        end
        if nextRewardData ~= nil and nextRewardData.lv_exp > NetCmdItemData:GetResCount(data.point_item) then
            self.mView.mText_ProgressNum.text = count .. "/" .. (nextRewardData.lv_exp - rewardData.lv_exp);
            self.mView.mImg_ProgressBar.fillAmount = count / (nextRewardData.lv_exp - rewardData.lv_exp);
        else
            local prevRewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId - 1);
            self.mView.mText_ProgressNum.text = count .. "/" .. (rewardData.lv_exp - prevRewardData.lv_exp);
            self.mView.mImg_ProgressBar.fillAmount = count / (rewardData.lv_exp - prevRewardData.lv_exp);
        end
        self.mView.mText_Content.text = "Lv." .. rewardData.tag_lv
        reward = nextRewardData.Reward
    else
        rewardId = rewardNotReceivedId
        rewardData = TableData.listAchievementRewardDatas:GetDataById(rewardNotReceivedId);
        local prevRewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId - 1);
        count = rewardData.lv_exp - prevRewardData.lv_exp
        self.mView.mText_ProgressNum.text = count .. "/" .. (rewardData.lv_exp - prevRewardData.lv_exp);
        self.mView.mImg_ProgressBar.fillAmount = count / (rewardData.lv_exp - prevRewardData.lv_exp);
        self.mView.mText_Content.text = "Lv." .. prevRewardData.tag_lv
        reward = rewardData.Reward
    end

    for _, item in ipairs(self.mItemViewList) do
        gfdestroy(item:GetRoot());
    end

    for itemId, num in pairs(reward) do
        local itemview = UICommonItem.New();
        itemview:InitCtrl(self.mView.mContent_All);
        itemview:SetItemData(itemId, num);
        self.mItemViewList:Add(itemview);
        itemview.mUIRoot:SetAsFirstSibling();

        local stcData = TableData.GetItemData(itemId)
        TipsManager.Add(itemview.mUIRoot, stcData)
    end

    local canReceive = NetCmdAchieveData:TagRewardCanReceive(data.id);
    local allCompleted = NetCmdAchieveData:TagRewardAllCompleted(data.id);
    setactive(self.mView.mTrans_BtnPick, canReceive)
    setactive(self.mView.mTrans_CompletedAll, not canReceive and allCompleted)
    setactive(self.mView.mTrans_UnCompletedAll, not canReceive and not allCompleted)
end


function UIAchievementPanelV2.OnClickTag(item)
    self = UIAchievementPanelV2;
    if self.mCurTagItem ~= nil then
        if item.tagId ~= self.mCurTagItem.tagId then
            self.mCurTagItem:SetItemState(false)
        else
            return
        end
    end
    self.allClicked = false
    item:SetItemState(true)
    self.mCurTagItem = item
    self:UpdatePanel()
end

function UIAchievementPanelV2:UpdatePanel()
    for _, item in ipairs(self.mLeftTabViewList) do
        item:RefreshData()
    end
    self.allClicked = false
    self.mView.mText_Num.text = NetCmdAchieveData:GetTotalPoints()
    self:UpdateAchieveList();
    self:UpdateRedPoint()
end

function UIAchievementPanelV2.OnGotoClick(gameObject)
    self = UIAchievementPanelV2;

    local itemBtn = UIUtils.GetButtonListener(gameObject)
	local dailyData = itemBtn.param
	local paramArray = {}
    if dailyData.SwitchParamArray ~= nil then
        for i = 0, dailyData.SwitchParamArray.Length - 1 do
            if dailyData.SwitchParamArray[i] ~= nil then
                paramArray[i + 1] = tonumber(dailyData.SwitchParamArray[i])
            end
        end
    end
	SceneSwitch:SwitchByID(dailyData.SwitchType,paramArray)
end

function UIAchievementPanelV2.OnAllReceiveClick(gameObject)
    self = UIAchievementPanelV2;
    local itemBtn = UIUtils.GetButtonListener(gameObject)
    local receiveList = itemBtn.param
    if receiveList ~= nil and #receiveList > 0 then
        if self.allClicked then
            return
        end
        self.allClicked = true
        NetCmdAchieveData:SendReqTakeAchievementRewardCmd(receiveList, self.OnReceivedCallback);
    else
        self.allClicked = false
    end
end

function UIAchievementPanelV2.OnTagRewardReceive(gameObject)
    self = UIAchievementPanelV2;
    NetCmdAchieveData:GetFirstTagRewardById(self.mCurTagItem.mData.id, self.OnReceivedCallback);
end

function UIAchievementPanelV2.OnReceiveClick(gameObject)
    self = UIAchievementPanelV2;
    local itemBtn = UIUtils.GetButtonListener(gameObject)
    local dailyData = itemBtn.param
    self.mUICommonReceiveItemData = itemBtn.param;
    local idList = {}
    table.insert(idList, dailyData.Id)
    NetCmdAchieveData:SendReqTakeAchievementRewardCmd(idList, self.OnReceivedCallback);
end

function UIAchievementPanelV2.OnReceivedCallback(ret)
    self = UIAchievementPanelV2;

    if ret == CS.CMDRet.eSuccess then
        gfdebug("领取成功");

        if AccountNetCmdHandler.IsLevelUpdate==true then
            UICommonLevelUpPanel.Open(UICommonLevelUpPanel.ShowType.CommanderLevelUp, nil, true, true)
        else
            UIManager.OpenUIByParam(UIDef.UICommonReceivePanel, {nil,nil,nil,true})
        end
        TimerSys:DelayCall(0.4, function()
            UIAchievementPanelV2:UpdatePanel()
        end);
	else
		gfdebug("领取失败");
        self.allClicked = false
	end	
end

function UIAchievementPanelV2.CloseTakeQuestRewardCallBack(data)
    self=UIAchievementPanelV2;

    if self.mUICommonReceiveItem~=nil then
        self.mUICommonReceiveItem:SetData(nil);
    end
end

function UIAchievementPanelV2.OnReturnClicked(gameObject)
    self = UIAchievementPanelV2;
    self.Close();
end

function UIAchievementPanelV2.OnRelease()
    self = UIAchievementPanelV2;
    self.mCurTagItem = nil;
    self.mAchieveItemList = {}
    self.mUICommonReceiveItemData = nil; 
    self.mUICommonReceiveItem = nil;
end