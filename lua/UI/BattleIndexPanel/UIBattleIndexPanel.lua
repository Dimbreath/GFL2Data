require("UI.UIBasePanel")
require("UI.BattleIndexPanel.UIBattleIndexPanelView")
require("UI.BattleIndexPanel.Content.UIChapterInfoPanel")
---@class UIBattleIndexPanel : UIBasePanel
UIBattleIndexPanel = class("UIBattleIndexPanel", UIBasePanel)
UIBattleIndexPanel.__index = UIBattleIndexPanel
---@type UIBattleIndexPanelView
UIBattleIndexPanel.mView = nil
UIBattleIndexPanel.currentType = -1


UIBattleIndexPanel.typeList = {}
UIBattleIndexPanel.battleList = {}

UIBattleIndexPanel.chapterItemList = {}
UIBattleIndexPanel.hardItemList = {}
UIBattleIndexPanel.simCombatList = {}
UIBattleIndexPanel.mIndexItemList = nil

UIBattleIndexPanel.BattleType = {
    Activity  = 1,  -- 活动
    PVP       = 2,  -- PVP
    SimCombat = 3, -- 模拟作战
    Campaign  = 4,  -- 主线
}

UIBattleIndexPanel.DifficultyType = {
	Normal = 1,
	Hard = 2,
}

UIBattleIndexPanel.curDiff = 1
UIBattleIndexPanel.curChapterId = 0
UIBattleIndexPanel.IsInited = false;

function UIBattleIndexPanel:ctor()
    UIBattleIndexPanel.super.ctor(self)
end

function UIBattleIndexPanel.Open()
    self = UIBattleIndexPanel
end

function UIBattleIndexPanel.Close()
    self = UIBattleIndexPanel
    for _, item in pairs(self.battleList) do
        item:OnClose()
    end
    UIManager.CloseUI(UIDef.UIBattleIndexPanel)
end

function UIBattleIndexPanel.OnHide()
    self = UIBattleIndexPanel
    if self.battleList[self.currentType] then
        self.battleList[self.currentType]:OnHide()
    end
end

function UIBattleIndexPanel.OnShow()
    self = UIBattleIndexPanel

    --self:UpdateSystemUnLockInfo()

    self.mView.mAnim_GrpPlotCombat:Play("FadeIn",0,1)

    if self.battleList[self.currentType] then
        self.battleList[self.currentType]:OnShow()
    end

    for _, item in ipairs(self.chapterItemList) do
        item:UpdateRedPoint()
    end

    for _, item in ipairs(self.hardItemList) do
        item:UpdateRedPoint()
    end
end

function UIBattleIndexPanel.Init(root, data)
    self = UIBattleIndexPanel

    UIBattleIndexPanel.super.SetRoot(UIBattleIndexPanel, root)

    UIBattleIndexPanel.mData = data
    UIBattleIndexPanel.RedPointType = {RedPointConst.Chapter, RedPointConst.Mails, RedPointConst.Notice}

    UIBattleIndexPanel.mView = UIBattleIndexPanelView
    UIBattleIndexPanel.mView:InitCtrl(root)

    UIUtils.GetButtonListener(self.mView.mBtn_Exit.gameObject).onClick = self.onClickExit
    UIUtils.GetButtonListener(self.mView.mBtn_CommandCenter.gameObject).onClick = self.onClickCommandCenter

    -- UIUtils.GetButtonListener(self.mView.mBtn_Mail.gameObject).onClick = function(gObj)
    --     if TipsManager.NeedLockTips(CS.GF2.Data.SystemList.Mail) then
    --         return
    --     end
    --     NetCmdMailData:SendReqRoleMailsCmd(function ()
    --         UIManager.OpenUI(UIDef.UIMailPanelV2)
    --     end)
    -- end

    -- UIUtils.GetButtonListener(self.mView.mBtn_Post.gameObject).onClick = function(gObj)
    --     UIManager.OpenUI(UIDef.UIPostPanelV2)
    -- end

    -- UIUtils.GetButtonListener(self.mView.mBtn_Setting.gameObject).onClick = function(gObj)
    --     UIManager.OpenUI(UIDef.UICommanderInfoPanel)
    -- end
    setactive(self.mView.mAnim_GrpHardCombat.gameObject, true)
end

function UIBattleIndexPanel.OnInit()
    self = UIBattleIndexPanel

    if UIBattleIndexPanel.currentType <= 0 then
        UIBattleIndexPanel.currentType = UIBattleIndexPanel.BattleType.Campaign
    end

    -- if( UIBattleIndexPanel.currentType == UIBattleIndexPanel.BattleType.Campaign) then
    --     self:PlayFadeInEffect();
    --     TimerSys:DelayCall(0.1 ,function(idx) 
    --         self = UIBattleIndexPanel
    --         self:PlayScaleInEffect(self.mUIRoot.transform);
    --     end,0);
    -- end
    
    self.mIndexItemList = List:New(BattleIndexListItem);

    --self:InitBattleType()
    self:ReqSimCombatData()
    self:addListeners()
    -- self:UpdateRedPoint()

    self:InitCampaignList();
    self:InitHardList();
    self:InitSimList();

    local curStoryData = NetCmdDungeonData:GetCurrentStory();
	local data = TableData.GetStorysByChapterID(curStoryData.chapter)
	local total = data.Count * 3
	local stars = NetCmdDungeonData:GetCurStarsByChapterID(curStoryData.chapter) + NetCmdDungeonData:GetFinishChapterStoryCountByChapterID(curStoryData.chapter) * 3
    local stageData = TableData.listStageDatas:GetDataById(curStoryData.StageId)

    self.mView.mText_CurName.text = stageData.name.str;
    self.mView.mText_CurProgress.text = curStoryData.name.str;
    self.mView.mText_CurPercent.text = tostring(math.ceil((stars / total) * 100)) .. "%"


    MessageSys:AddListener(CS.GF2.Message.UIEvent.SystemUnlockEvent, UIBattleIndexPanel.SystemUnLock)
end


function UIBattleIndexPanel:addListeners()
    MessageSys:AddListener(1025,self.OnSwitchByChapterID)

    RedPointSystem:GetInstance():AddRedPointListener(RedPointConst.Chapter, nil, function ()
        self:UpdateRedPointByType(UIBattleIndexPanel.BattleType.Campaign)
    end)

end

function UIBattleIndexPanel:removeListeners()
    MessageSys:RemoveListener(1025,self.OnSwitchByChapterID)

    RedPointSystem:GetInstance():RemoveRedPointListener(RedPointConst.Chapter)
end

function UIBattleIndexPanel.OnUpdateTop()
    self = UIBattleIndexPanel
end

function UIBattleIndexPanel.OnUpdate()
    self = UIBattleIndexPanel
    if self.currentType == UIBattleIndexPanel.BattleType.Campaign then
        if self.battleList[UIBattleIndexPanel.BattleType.Campaign] ~= nil then
            self.battleList[UIBattleIndexPanel.BattleType.Campaign]:OnUpdate()
        end
    end
end

function UIBattleIndexPanel.OnRelease()
    self = UIBattleIndexPanel
    -- self.currentType = -1
    for _, item in pairs(self.battleList) do
        item:OnRelease()
    end

    UIBattleIndexPanel.IsInited = false

    self.typeList = {}
    self.battleList = {}
    self.chapterItemList = {}
    self.hardItemList = {}
    self.simCombatList = {}
    self:removeListeners()
    self.mIndexItemList:Clear();
    self.curDiff = 1

    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.SystemUnlockEvent, UIBattleIndexPanel.SystemUnLock)
end

function UIBattleIndexPanel:ReqSimCombatData()
    NetCmdSimulateBattleData:ReqSimCombatInfo(UIBattleIndexPanel.ReqSimCombatInfoCallback)
end

function UIBattleIndexPanel:UpdateChapterList()
    if self.battleList[UIBattleIndexPanel.BattleType.Campaign] ~= nil then
        self.battleList[UIBattleIndexPanel.BattleType.Campaign]:SetData()
    end
end


----------------回调！----------------
function UIBattleIndexPanel.ReqSimCombatInfoCallback(ret)
    self = UIBattleIndexPanel
    self:UpdateSystemUnLockInfo()
end

function UIBattleIndexPanel:OnBattleTypeChange(type)
    
end

UIBattleIndexPanel.ChapterClickFlag = true;

function UIBattleIndexPanel:OnChapterClicked(item)

    if(UIBattleIndexPanel.ChapterClickFlag == false) then
        return;
    end

    if(UIBattleIndexPanel.IsInited == true) then
        if self.mView.mAnim_GrpHardCombat.enabled then
            self.mView.mAnim_GrpHardCombat:SetTrigger("FadeOut")
        end
        if self.mView.mAnim_GrpSimCombat.enabled then
            self.mView.mAnim_GrpSimCombat:SetTrigger("FadeOut")
        end
        self.mView.mAnim_GrpPlotCombat.enabled = true
        self.mView.mAnim_GrpPlotCombat:Play("FadeIn",0,0)

        setactive(self.mView.mTrans_ChapterGrp,true);

        UIBattleIndexPanel.ChapterClickFlag = false;
        TimerSys:DelayCall(0.5, function ()
            setactive(self.mView.mTrans_SimGrp,false);
            setactive(self.mView.mTrans_HardGrp,false);

            if self.mView.mAnim_GrpHardCombat.enabled then
                self.mView.mAnim_GrpHardCombat:ResetTrigger("FadeOut")
                self.mView.mAnim_GrpHardCombat.enabled = false
            end

            if self.mView.mAnim_GrpSimCombat.enabled then
                self.mView.mAnim_GrpSimCombat:ResetTrigger("FadeOut")
                self.mView.mAnim_GrpSimCombat.enabled = false
            end

            UIBattleIndexPanel.ChapterClickFlag = true;
        end)

        UIBattleIndexPanel.curDiff = UIBattleIndexPanel.DifficultyType.Normal
    else
        self.mView.mAnim_GrpPlotCombat:Play("FadeIn",0,1)

        self.mView.mAnim_GrpHardCombat.enabled = false
        self.mView.mAnim_GrpSimCombat.enabled = false

        setactive(self.mView.mTrans_ChapterGrp,true);
        setactive(self.mView.mTrans_HardGrp,false);
        setactive(self.mView.mTrans_SimGrp,false);
    end

    UIBattleIndexPanel.IsInited = true
    setactive(self.mView.mTrans_TextGrp,true);

    self:UnAllSelectTab();
    item:SetSelected(true);

    --UIBattleIndexPanel.curDiff = UIBattleIndexPanel.DifficultyType.Normal

    self.mView.mImage_BG.sprite = IconUtils.GetAtlasV2("BattleIndexBg", item.mData.background);

    for _, item in ipairs(self.chapterItemList) do
        item:UpdateRedPoint()
    end

end

function UIBattleIndexPanel:OnHardClicked(item)

    if(item.mIsLock) then
        local prompt = TableData.listUnlockDatas:GetDataById(item.mData.unlock).prompt.str
        CS.PopupMessageManager.PopupString(prompt)
        return
    end

    if(UIBattleIndexPanel.ChapterClickFlag == false) then
        return;
    end

    if self.mView.mAnim_GrpPlotCombat.enabled then
        self.mView.mAnim_GrpPlotCombat:SetTrigger("FadeOut")
    end
    if self.mView.mAnim_GrpSimCombat.enabled then
        self.mView.mAnim_GrpSimCombat:SetTrigger("FadeOut")
    end
    self.mView.mAnim_GrpHardCombat.enabled = true
    self.mView.mAnim_GrpHardCombat:Play("FadeIn",0,0)
    --self.mView.mAnim_GrpSimCombat:SetTrigger("FadeIn")

    setactive(self.mView.mTrans_HardGrp,true);
    UIBattleIndexPanel.ChapterClickFlag = false;
    TimerSys:DelayCall(0.5, function ()
        setactive(self.mView.mTrans_ChapterGrp,false);
        setactive(self.mView.mTrans_SimGrp,false);

        if self.mView.mAnim_GrpPlotCombat.enabled then
            self.mView.mAnim_GrpPlotCombat:ResetTrigger("FadeOut")
            self.mView.mAnim_GrpPlotCombat.enabled = false
        end

        if self.mView.mAnim_GrpSimCombat.enabled then
            self.mView.mAnim_GrpSimCombat:ResetTrigger("FadeOut")
            self.mView.mAnim_GrpSimCombat.enabled = false
        end

        UIBattleIndexPanel.ChapterClickFlag = true;
        UIBattleIndexPanel.curDiff = UIBattleIndexPanel.DifficultyType.Hard
    end)

    self:UnAllSelectTab();
    item:SetSelected(true);

    setactive(self.mView.mTrans_TextGrp,false);

    self.mView.mImage_BG.sprite = IconUtils.GetAtlasV2("BattleIndexBg", item.mData.background);

    --UIBattleIndexPanel.curDiff = UIBattleIndexPanel.DifficultyType.Hard

    for _, item in ipairs(self.hardItemList) do
        item:UpdateRedPoint()
    end
end

function UIBattleIndexPanel:OnSimClicked(item)

    if(item.mIsLock) then
        local prompt = TableData.listUnlockDatas:GetDataById(item.mData.unlock).prompt.str
        CS.PopupMessageManager.PopupString(prompt)
        return
    end

    if(UIBattleIndexPanel.ChapterClickFlag == false) then
        return;
    end

    if self.mView.mAnim_GrpPlotCombat.enabled then
        self.mView.mAnim_GrpPlotCombat:SetTrigger("FadeOut")
    end
    if self.mView.mAnim_GrpHardCombat.enabled then
        self.mView.mAnim_GrpHardCombat:SetTrigger("FadeOut")
    end
    self.mView.mAnim_GrpSimCombat.enabled = true
    self.mView.mAnim_GrpSimCombat:Play("FadeIn",0,0)

    setactive(self.mView.mTrans_SimGrp,true);
    UIBattleIndexPanel.ChapterClickFlag = false;
    TimerSys:DelayCall(0.5, function ()
        setactive(self.mView.mTrans_ChapterGrp,false);
        setactive(self.mView.mTrans_HardGrp,false);

        if self.mView.mAnim_GrpPlotCombat.enabled then
            self.mView.mAnim_GrpPlotCombat:ResetTrigger("FadeOut")
            self.mView.mAnim_GrpPlotCombat.enabled = false
        end

        if self.mView.mAnim_GrpHardCombat.enabled then
            self.mView.mAnim_GrpHardCombat:ResetTrigger("FadeOut")
            self.mView.mAnim_GrpHardCombat.enabled = false
        end

        UIBattleIndexPanel.ChapterClickFlag = true;
    end)

    self:UnAllSelectTab();
    item:SetSelected(true);

    setactive(self.mView.mTrans_TextGrp,false);

    self.mView.mImage_BG.sprite = IconUtils.GetAtlasV2("BattleIndexBg", item.mData.background);
end


function UIBattleIndexPanel:UnAllSelectTab()
	local count = self.mIndexItemList:Count();
	for i = 1, count, 1 do
		local item = self.mIndexItemList[i];
		item:SetSelected(false);
	end
end

function UIBattleIndexPanel:UpdateSimRedPoint()
    local count = self.mIndexItemList:Count();
	for i = 1, count, 1 do
		local item = self.mIndexItemList[i];
        if(item.bIsSim) then
		    item:UpdateRedPoint();
        end
	end
end

function UIBattleIndexPanel:InitCampaignList()
    local indexList = BattleIndexListItem.New();
    local indexData = TableData.listStageIndexDatas:GetDataById(1);
    indexList.mData = indexData
    indexList:InitCtrl(self.mView.mTrans_ChapterIndexList.transform)
    indexList:SetData(indexData.name.str,indexData.name_en.str, string.format("%02d", indexData.rank),false);
    self.mIndexItemList:Add(indexList);
    UIUtils.GetButtonListener(indexList.mBtn_Self.gameObject).onClick = function()
        self:OnChapterClicked(indexList)
    end

    local data = UIBattleIndexPanel.curDiff == UIBattleIndexPanel.DifficultyType.Normal and TableData.GetStageIndexNormalChapterList() or TableData.GetHardChapterList()
	local curChapter = nil
	if data then
		for _, item in ipairs(self.chapterItemList) do
			item:SetData(nil)
		end

		for i = 0, data.Count - 1 do
			local item = nil
			if i + 1 > #self.chapterItemList then
				item = UIMainChapterItem.New()
				item:InitCtrl(self.mView.mTrans_ChapterList.transform)
                self.chapterItemList[i + 1] = item;
			else
				item = self.chapterItemList[i + 1]
			end
			if item then
				item:SetData(data[i], UIBattleIndexPanel.curDiff == UIBattleIndexPanel.DifficultyType.Hard, i + 1)
				UIUtils.GetButtonListener(item.mBtn_StoryChapter.gameObject).onClick = function()
					self:OnClickChapter(item)
				end

				if UIBattleIndexPanel.curChapterId == 0 then
					if item.isUnLock == 0 then
						curChapter = item
					end
				else
					if UIBattleIndexPanel.curChapterId == data[i].id then
						curChapter = item
					end
				end
			end
		end
		--self:UpdateModeButton()

		setactive(self.mUIRoot.gameObject, true)
	end

    self:OnChapterClicked(indexList)
end

function UIBattleIndexPanel:InitHardList()
    local hardList = BattleIndexListItem.New();
    local indexData = TableData.listStageIndexDatas:GetDataById(3);
    hardList.mData = indexData
    hardList:InitCtrl(self.mView.mTrans_HardIndexList.transform)
    hardList:SetData(indexData.name.str,indexData.name_en.str, string.format("%02d", indexData.rank),not AccountNetCmdHandler:CheckSystemIsUnLock(indexData.unlock));
    TimerSys:DelayCall(0.1, function ()
        hardList:SetLock(not AccountNetCmdHandler:CheckSystemIsUnLock(indexData.unlock))
    end)

    self.mHardIndexItem = hardList;

    self.mIndexItemList:Add(hardList);
    UIUtils.GetButtonListener(hardList.mBtn_Self.gameObject).onClick = function()
        self:OnHardClicked(hardList)
    end

    local data = TableData.GetHardChapterList()
    local curChapter = nil
    if data then
        for _, item in ipairs(self.hardItemList) do
            item:SetData(nil)
        end

        for i = 0, data.Count - 1 do
            local item = nil
            if i + 1 > #self.hardItemList then
                item = UIHardChapterItem.New()
                item:InitCtrl(self.mView.mTrans_HardList.transform)
                self.hardItemList[i + 1] = item;
            else
                item = self.hardItemList[i + 1]
            end
            if item then
                item:SetData(data[i], true, i + 1)
                UIUtils.GetButtonListener(item.mBtn_StoryChapter.gameObject).onClick = function()
                    self:OnClickChapter(item)
                end

                if UIBattleIndexPanel.curChapterId == 0 then
                    if item.isUnLock == 0 then
                        curChapter = item
                    end
                else
                    if UIBattleIndexPanel.curChapterId == data[i].id then
                        curChapter = item
                    end
                end
            end
        end
        --self:UpdateModeButton()

        setactive(self.mUIRoot.gameObject, true)
    end

end

function UIBattleIndexPanel:OnClickChapter(item)
    if self.isAni then
        return
    end

    if(UIBattleIndexPanel.ChapterClickFlag == false) then
        return;
    end

    if item.isUnLock > 0 then
        local preData = TableData.listChapterDatas:GetDataById(item.isUnLock)
        local hint = string_format(TableData.GetHintById(103030), preData.name.str)
        CS.PopupMessageManager.PopupString(hint)
        return
    elseif item.isHard and not item.levelUnlocked then
        local preData = TableData.listChapterDatas:GetDataById(item.data.pre_chapter)
        local hint = string_format(TableData.GetHintById(103031), preData.level)
        CS.PopupMessageManager.PopupString(hint)
        return
    end
    if UIBattleIndexPanel.curDiff == UIBattleIndexPanel.DifficultyType.Normal then
        self:EnterChapter(item)
    else
        self:EnterHard(item)
    end

end

function UIBattleIndexPanel:EnterChapter(item)
    if item.data.id and item.isUnLock == 0 then
        local chapterId = item.data.id > 100 and item.data.id - 100 or item.data.id
        UIBattleIndexPanel.curChapterId = item.data.id

        if item.isNew then
            AccountNetCmdHandler:UpdateWatchedChapter(item.data.id)
            item.isNew = false

            local story = TableData.GetFirstStoryByChapterID(item.data.id)
            CS.AVGController.PlayAVG(story.stage_id, 10, function ()
                UIManager.OpenUIByParam(UIDef.UIChapterPanel, chapterId)
            end)
        else
            UIManager.OpenUIByParam(UIDef.UIChapterPanel, chapterId)
        end
    end
end

function UIBattleIndexPanel:EnterHard(item)
	if item.data.id and item.isUnLock == 0 then
		local chapterId = item.data.id
		UIBattleIndexPanel.curChapterId = item.data.id

		if item.isNew then
			AccountNetCmdHandler:UpdateWatchedChapter(item.data.id)
			item.isNew = false
		end
        UIManager.OpenUIByParam(UIDef.UIChapterHardPanel, chapterId)
	end
end

function UIBattleIndexPanel:InitSimList()
    local indexList = BattleIndexListItem.New();
    local indexData = TableData.listStageIndexDatas:GetDataById(2);
    indexList.mData = indexData
    indexList:InitCtrl(self.mView.mTrans_SimIndexList.transform)

    indexList:SetData(indexData.name.str,indexData.name_en.str, string.format("%02d", indexData.rank),not AccountNetCmdHandler:CheckSystemIsUnLock(indexData.unlock));

    self.mSimIndexItem = indexList;

    indexList:UpdateRedPoint();
    self.mIndexItemList:Add(indexList);
    UIUtils.GetButtonListener(indexList.mBtn_Self.gameObject).onClick = function()
        self:OnSimClicked(indexList)
    end

    for _, item in ipairs(self.simCombatList) do
		item:SetData(nil)
	end

	local dataList = TableData.GetStageIndexSimCombatList() 

	local item = nil
	for i = 0, dataList.Count - 1 do
		if i + 1 <= #self.simCombatList then
			item = self.simCombatList[i + 1]
		else
			item = UISimCombatItem.New()
			item:InitCtrl(self.mView.mTrans_SimList.transform)
			table.insert(self.simCombatList, item)
		end
		local data = dataList[i]
		item:SetData(data)
		local type = item.mType
		UIUtils.GetButtonListener(item.mTrans_SimCombat.gameObject).onClick = function()
			if data.nocomplete == 1 then
				return
			end
			self:OnClickSimCombat(data.id, type)
		end
	end

	self:UpdateUnLockInfo()
end

UIBattleIndexPanel.mSimIndexItem = nil;
UIBattleIndexPanel.mHardIndexItem = nil;

function UIBattleIndexPanel.SystemUnLock()
    self = UIBattleIndexPanel;

    local indexData = TableData.listStageIndexDatas:GetDataById(2);
    self.mSimIndexItem:SetLock(not AccountNetCmdHandler:CheckSystemIsUnLock(indexData.unlock))

    indexData = TableData.listStageIndexDatas:GetDataById(3);
    self.mHardIndexItem:SetLock(not AccountNetCmdHandler:CheckSystemIsUnLock(indexData.unlock))
end

function UIBattleIndexPanel:OnClickSimCombat(simType, unlockType)
	if TipsManager.NeedLockTips(unlockType) then
		return
	end

    if(UIBattleIndexPanel.ChapterClickFlag == false) then
        return;
    end
    
	if simType == 1 then
		UIManager.OpenUI(UIDef.UISimCombatEquipPanel)
	elseif simType == 2 then
		UIManager.OpenUI(UIDef.UISimCombatRunesPanel)
	elseif simType == 3 then
		UIManager.OpenUI(UIDef.SimTrainingListPanel)
	elseif simType == 4 then
		UIManager.OpenUI(UIDef.UISimCombatWeeklyPanel)
	elseif simType == 5 then
		UIManager.OpenUI(UIDef.UISimCombatMythicPanel)
    elseif simType == 6 then
        UIManager.OpenUI(UIDef.UISimCombatGoldPanel)
    elseif simType == 7 then
        UIManager.OpenUI(UIDef.UISimCombatExpPanel)
	elseif simType == 8 then
        UIManager.OpenUI(UIDef.UISimCombatTeachingPanel)
	end
end

function UIBattleIndexPanel:UpdateUnLockInfo()
	for _, item in ipairs(self.simCombatList) do
		item:CheckSimCombatIsUnLock()
	end
end

function UIBattleIndexPanel:UpdateRedPoint()
	for _, item in ipairs(self.simCombatList) do
		item:UpdateRedPoint()
	end
end


function UIBattleIndexPanel:OnClickPVP()
    if TipsManager.NeedLockTips(CS.GF2.Data.SystemList.Nrtpvp) then
        return
    end
    if not NetCmdPvPData.PVPIsOpen then
        CS.PopupMessageManager.PopupString(TableData.GetHintById(226))
        return
    end
    NetCmdPvPData:RequestPVPInfo(UIBattleIndexPanel.OnPVPInfoRespond)
end

function UIBattleIndexPanel.OnPVPInfoRespond()
    UIManager.OpenUI(UIDef.UINRTPVPPanel)
end

function UIBattleIndexPanel.OnSwitchByChapterID(msg)
    self = UIBattleIndexPanel
    if self.battleList[UIBattleIndexPanel.BattleType.Campaign] ~= nil then
        self.battleList[UIBattleIndexPanel.BattleType.Campaign]:OnSwitchByChapterID(msg)
    end
end

function UIBattleIndexPanel.ClearUIRecordData()
    UIBattleIndexPanel.currentType = -1
    UIBattleIndexPanel.curDiff = 1
end

function UIBattleIndexPanel.onClickExit()
    UIBattleIndexPanel.Close()
    UIBattleIndexPanel.ClearUIRecordData()
end

function UIBattleIndexPanel.onClickCommandCenter()
    UIManager:JumpToMainPanel()
end

function UIBattleIndexPanel:UpdateSystemUnLockInfo()
    --setactive(self.typeList[UIBattleIndexPanel.BattleType.SimCombat].transLocked, self:CheckSystemIsLock(CS.GF2.Data.SystemList.BattleSim))
    --setactive(self.typeList[UIBattleIndexPanel.BattleType.PVP].transLocked, self:CheckSystemIsLock(CS.GF2.Data.SystemList.Nrtpvp))
end

function UIBattleIndexPanel:CheckSystemIsLock(type)
    return not AccountNetCmdHandler:CheckSystemIsUnLock(type)
end

function UIBattleIndexPanel:UpdateRedPointByType(type)
    if self.battleList[type] ~= nil then
        self.battleList[type]:UpdateRedPoint()
    end
end
