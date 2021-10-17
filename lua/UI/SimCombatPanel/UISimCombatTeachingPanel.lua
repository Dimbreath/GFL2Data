require("UI.UIBasePanel")
require("UI.SimCombatPanel.UISimCombatTeachingPanelView")
require("UI.SimCombatPanel.Item.SimCombatEquipItem")
require("UI.SimCombatPanel.Item.UISimCombatTabButtonItem")
require("UI.CombatLauncherPanel.UICombatLauncherPanelItem")

UISimCombatTeachingPanel = class("UISimCombatTeachingPanel", UIBasePanel)
UISimCombatTeachingPanel.__index = UISimCombatTeachingPanel

UISimCombatTeachingPanel.mView = nil

UISimCombatTeachingPanel.labelList = {}
UISimCombatTeachingPanel.levelList = {}

UISimCombatTeachingPanel.mLastChapterId = 0;

UISimCombatTeachingPanel.mLastSelectItem = nil;

function UISimCombatTeachingPanel:ctor()
    UISimCombatTeachingPanel.super.ctor(self)
end

function UISimCombatTeachingPanel.Open()
    self = UISimCombatTeachingPanel
end

function UISimCombatTeachingPanel.Close()
    self = UISimCombatTeachingPanel
    UIManager.CloseUI(UIDef.UISimCombatTeachingPanel)
end

function UISimCombatTeachingPanel.Hide()
    self = UISimCombatTeachingPanel
    self:Show(false)
end


function UISimCombatTeachingPanel.OnShow()
    self = UISimCombatTeachingPanel
    UISimCombatTeachingPanel:ResetScroll()
end

function UISimCombatTeachingPanel.Init(root, data)
    self = UISimCombatTeachingPanel

    self.RedPointType = {RedPointConst.ChapterReward}

    UISimCombatTeachingPanel.super.SetRoot(UISimCombatTeachingPanel, root)

    UISimCombatTeachingPanel.mData = data

    UISimCombatTeachingPanel.mView = UISimCombatTeachingPanelView
    UISimCombatTeachingPanel.mView:InitCtrl(root)

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function(gObj)
        UISimCombatTeachingPanel.mLastChapterId = 0;
        UISimCombatTeachingPanel:onClickExit()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CommanderCenter.gameObject).onClick = function()
        UISimCombatTeachingPanel.mLastChapterId = 0;
        UIManager.JumpToMainPanel()
    end

    
    UIUtils.GetButtonListener(self.mView.mBtn_Reward.gameObject).onClick = function(gObj)
		UISimCombatTeachingPanel:OnClickChapterReward()
	end

    UIUtils.GetButtonListener(self.mView.mBtn_Description.gameObject).onClick = function(gObj)
		--UISimCombatTeachingPanel:OnClickChapterReward()
        SimpleMessageBoxPanel.ShowByParam("test", "test");
	end

end


function UISimCombatTeachingPanel:OnClickChapterReward()
    UIManager.OpenUIByParam(UIDef.UISimCombatTeachingRewardPanel, self.chapterId)               
end

function UISimCombatTeachingPanel.OnInit()
    self = UISimCombatTeachingPanel

    self:InitData()

    -- NetCmdStageRecordData:RequestStageRecordByType(CS.GF2.Data.StageType.EquipStage, function (ret)
    --     if ret == CS.CMDRet.eSuccess then
    --         UISimCombatTeachingPanel:UpdatePanel()
    --     end
    -- end)
end

function UISimCombatTeachingPanel.OnRelease()
    self = UISimCombatTeachingPanel

    if UISimCombatTeachingPanel.combatLauncher ~= nil then
        UISimCombatTeachingPanel.combatLauncher:OnRelease()
    end
    UISimCombatTeachingPanel.combatLauncher = nil

    self.labelList = {};
    self.levelList = {};
    self.mLastSelectItem = nil;
end


function UISimCombatTeachingPanel:InitData()
    self:InitChapterList();
    self:UpdateRewardRedPoint();
end

function UISimCombatTeachingPanel:UpdateRewardRedPoint()
    setactive(self.mView.mTrans_RewardRedPoint,NetCmdSimulateBattleData:CheckTeachingRewardRedPoint())
end

function UISimCombatTeachingPanel:InitChapterList()

    for i = 0, self.mView.mTrans_Content.childCount-1 do
        gfdestroy(self.mView.mTrans_Content:GetChild(i))
    end

    local list = NetCmdSimulateBattleData:GetSimBattleTeachingChapterList();

    local prefab = UIUtils.GetGizmosPrefab("SimCombat/SimCombatTeachingChapterItemV2.prefab",self);
    local curItem = nil;
    for i = 0, list.Count-1 do
        local data = list[i]
        local item = nil

        if i + 1 <= #self.labelList then
            item = self.labelList[i + 1]
        else
            if prefab then
                local obj = instantiate(prefab)
                item = UISimCombatTeachingChapterItemV2.New()
                UIUtils.AddListItem(obj, self.mView.mTrans_Content.transform)
                item:InitCtrl(obj.transform)
                UIUtils.GetButtonListener(item.mBtn_SelfBtn.gameObject).onClick = function(gObj)
                    self:OnClickLabel(item)
                end
                table.insert(self.labelList, item)

                if(UISimCombatTeachingPanel.mLastChapterId == data.StcData.id) then
                    curItem = item;
                end
            end
        end
        item:SetData(data);
   
    end

    if(curItem ~= nil and (not curItem.mData.IsCompleted)) then
        self:OnClickLabel(curItem)
    end

    local fade = self.mView.mTrans_Content:GetComponent("MonoFindChildFadeManager")
    fade:InitFade();
end

function UISimCombatTeachingPanel:InitLevelist(data)

    for i = 0, self.mView.mTrans_ChapterDetailCurrent.childCount-1 do
        gfdestroy(self.mView.mTrans_ChapterDetailCurrent:GetChild(i))
    end


    local prefab = UIUtils.GetGizmosPrefab("SimCombat/SimCombatTeachingChapterItemV2.prefab",self);

    local obj = instantiate(prefab)
    local item = UISimCombatTeachingChapterItemV2.New()
    obj.transform:SetParent(self.mView.mTrans_ChapterDetailCurrent.transform,false)
    item:InitCtrl(obj.transform)
    item:SetData(data);
    item:SetDisable();

    --local list = NetCmdSimulateBattleData:GetSimBattleTeachingLevelList(data.StcData.id);
    local list = data.LevelDataList;
    prefab = UIUtils.GetGizmosPrefab("SimCombat/SimCombatTeachingLevelItemV2.prefab",self);

    for i = 0, self.mView.mTrans_LevelContent.childCount-1 do
        gfdestroy(self.mView.mTrans_LevelContent:GetChild(i))
    end

    for i = 0, list.Count-1 do
        local data = list[i]
        local item = nil

        local obj = instantiate(prefab)
        item = UISimCombatTeachingLevelItemV2.New()
        UIUtils.AddListItem(obj, self.mView.mTrans_LevelContent.transform)
        item:InitCtrl(obj.transform)
        UIUtils.GetButtonListener(item.mBtn_SelfBtn.gameObject).onClick = function(gObj)
            self:OnClickLevel(item)
        end

        item:SetData(data);
    end
end

function UISimCombatTeachingPanel:UpdatePanel()
    
end

function UISimCombatTeachingPanel:OnClickLabel(item)
    if(not item.mData.IsPrevCompleted) then
        CS.PopupMessageManager.PopupString(TableData.GetHintById(103037))
        return
    end

    if(not item.mData.IsUnlocked) then
        CS.PopupMessageManager.PopupString(item.mData.StcData.unlcok_tips)
        return
    end

    item.mData:RemoveRedPoint()
    self:UpdateRedPoint()
    item:UpdateRedPoint();
    UIBattleIndexPanel:UpdateRedPoint()
    UIBattleIndexPanel:UpdateSimRedPoint()

    setactive(self.mView.mTrans_ChapterList,false)
    setactive(self.mView.mTrans_ChapterDetail,true)

    self:InitLevelist(item.mData)

    UISimCombatTeachingPanel.mLastChapterId = item.mData.StcData.id;
end

function UISimCombatTeachingPanel:OnClickLevel(item)

    if(item.mData.IsUnlocked == false) then
        CS.PopupMessageManager.PopupString(TableData.GetHintById(103015))
        return;
    end

    for i = 0, self.mView.mTrans_CombatLauncher.childCount-1 do
        gfdestroy(self.mView.mTrans_CombatLauncher:GetChild(i))
    end

    local record = NetCmdStageRecordData:GetStageRecordById(item.mData.StageData.id)

    local launcherItem = UICombatLauncherItem.New();
	launcherItem:InitCtrl(self.mView.mTrans_CombatLauncher.transform);
    launcherItem:InitSimTeachingData(item.mData,record,true)

	self.mCombatLauncher = launcherItem

	UIUtils.GetButtonListener(launcherItem.mBtn_Close.gameObject).onClick = function(gObj)
		UISimCombatTeachingPanel:OnClickCloseLauncher()
        self:ResetScroll()

        if(UISimCombatTeachingPanel.mLastSelectItem ~= nil) then
            UISimCombatTeachingPanel.mLastSelectItem:SetSelected(false)
        end
	end

    setactive(self.mView.mTrans_CombatLauncher,true)

    self:ScrollMoveToMid(-item.mUIRoot.transform.localPosition.x, true)

    if(UISimCombatTeachingPanel.mLastSelectItem ~= nil) then
        UISimCombatTeachingPanel.mLastSelectItem:SetSelected(false)
    end
    item:SetSelected(true)
    UISimCombatTeachingPanel.mLastSelectItem = item;
end

function UISimCombatTeachingPanel:ScrollMoveToMid(toPosX,needSlide)
    
    local xMax = self.mView.mUIRoot.rect.size.x/2 - 456;

    if(-1 * toPosX < xMax) then
        return
    end

    local toPos = Vector3(toPosX, self.mView.mTrans_LevelList.localPosition.y, 0)
    
    if needSlide then
        CS.UITweenManager.PlayLocalPositionTween(self.mView.mTrans_LevelList, self.mView.mTrans_LevelList.localPosition, toPos, 0.3)
    else
        combatList.localPosition = toPos
    end    
    
end

function UISimCombatTeachingPanel:ResetScroll()
    local toPos = Vector3(0, self.mView.mTrans_LevelList.localPosition.y, 0)
    CS.UITweenManager.PlayLocalPositionTween(self.mView.mTrans_LevelList, self.mView.mTrans_LevelList.localPosition, toPos, 0.3)
end


function UISimCombatTeachingPanel:OnClickCloseLauncher()
	if self.mCombatLauncher == nil then
		return
	end

	self.mCombatLauncher:PlayAniWithCallback(function ()
		setactive(self.mView.mTrans_CombatLauncher.gameObject, false)
	end)

end

function UISimCombatTeachingPanel:onClickExit()
    if(self.mView.mTrans_ChapterDetail.gameObject.activeSelf) then
        setactive(self.mView.mTrans_ChapterList,true)
        setactive(self.mView.mTrans_ChapterDetail,false)
        self:ResetScroll()
        UISimCombatTeachingPanel.mLastSelectItem = nil;
    else
        self.curLabelId = -1
        UISimCombatTeachingPanel.Close()
    end
    UISimCombatTeachingPanel.mLastChapterId = 0;
end