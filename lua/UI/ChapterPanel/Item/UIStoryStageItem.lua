require("UI.UIBaseCtrl")

UIStoryStageItem = class("UIStoryStageItem", UIBaseCtrl)
UIStoryStageItem.__index = UIStoryStageItem

function UIStoryStageItem:ctor()
	self.storyData = nil
	self.lineItem = nil
	self.branchLineItem = nil
	self.branchList = nil
	self.challengeList = {}
	self.lineLength = 0
	self.isUnlock = false
	self.preStory = nil
	self.nextStory = nil
end

function UIStoryStageItem:__InitCtrl()
	self.mTrans_Item = self:GetSelfRectTransform()

	self.mBtn_Stage = self:GetSelfButton()

	self.mTrans_Stage = self:GetRectTransform("Root/Trans_GrpPrincipalLine")
	self.mTrans_Branch = self:GetRectTransform("Root/Trans_GrpBranchLine")
	self.mTrans_Story = self:GetRectTransform("Root/Trans_GrpPlot")

	self.mText_Title = self:GetText("Root/GrpTopLeft/Text")
	self.mText_RandomNum = self:GetText("Root/Trans_GrpBottomLeft/Text1")
	self.mText_StageName = self:GetText("Root/Trans_GrpPrincipalLine/Trans_Text_Chapter")
	self.mText_BranchName = self:GetText("Root/Trans_GrpBranchLine/Trans_Text_Name")
	self.mText_StoryName = self:GetText("Root/Trans_GrpPlot/Trans_Text_Plot")

	self.mTrans_Lock = self:GetRectTransform("Root/Trans_GrpState/Trans_GrpLocked")
	self.mTrans_UnLock = self:GetRectTransform("Root/Trans_GrpState/Trans_GrpUnLocked")
	self.mTrans_StoryLock = self:GetRectTransform("Root/Trans_GrpPlot/GrpState/Trans_GrpLocked")
	self.mTrans_StoryUnlock = self:GetRectTransform("Root/Trans_GrpPlot/GrpState/Trans_GrpUnLocked")
	self.mTrans_StoryWatch = self:GetRectTransform("Root/Trans_GrpPlot/GrpState/Trans_GrpWatched")
	self.mTrans_Completed = self:GetRectTransform("Root/Trans_GrpState/Trans_GrpCompleted")
	self.mTrans_Next = self:GetRectTransform("Root/Trans_GrpNowProgress")
	self.mTrans_ChallengeList = self:GetRectTransform("Root/Trans_GrpStage")
	self.mTrans_StageState = self:GetRectTransform("Root/Trans_GrpState")

	self.mTrans_RightPoint = self:GetImage("Root/Trans_GrpDot/Trans_ImgDotRight")
	self.mTrans_LeftPoint = self:GetImage("Root/Trans_GrpDot/Trans_ImgDotLeft")
	self.mTrans_TopPoint = self:GetImage("Root/Trans_GrpDot/Trans_ImgDotTop")
	self.mTrans_BottomPoint = self:GetImage("Root/Trans_GrpDot/Trans_ImgDotBottom")

	for i = 1, UIChapterGlobal.MaxChallengeNum do
		local challenge = {}
		local obj = self:GetRectTransform("Root/Trans_GrpStage/GrpStage" .. i)
		challenge.obj = obj
		challenge.tranOn = UIUtils.GetRectTransform(obj, "Trans_On")
		challenge.imgBg = self:GetImage("Root/Trans_GrpStage/GrpBg/ImgBg" .. i)

		table.insert(self.challengeList, challenge)
	end

	setactive(self.mTrans_TopPoint, false)
	setactive(self.mTrans_BottomPoint, false)
end

function UIStoryStageItem:InitCtrl(parent)
   local obj = instantiate(UIUtils.GetGizmosPrefab("story/StoryChapterItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIStoryStageItem:SetData(data)
	self.storyData = data

	if data ~= nil then
		setactive(self.mTrans_Stage, data.type == GlobalConfig.StoryType.Normal)
		setactive(self.mTrans_Branch, data.type == GlobalConfig.StoryType.Branch or data.type == GlobalConfig.StoryType.Hide)
		setactive(self.mTrans_Story, data.type == GlobalConfig.StoryType.Story)
		setactive(self.mTrans_StageState, data.type == GlobalConfig.StoryType.Normal or data.type == GlobalConfig.StoryType.Branch or data.type == GlobalConfig.StoryType.Hide)
		setactive(self.mTrans_ChallengeList, data.type == GlobalConfig.StoryType.Normal or data.type == GlobalConfig.StoryType.Branch)

		self:UpdateItem()

		if self.storyData.type == GlobalConfig.StoryType.Hide  then
			local isUnlockHide = NetCmdDungeonData:IsUnlockHideStory(self.storyData.chapter)
			setactive(self.mUIRoot, isUnlockHide)
		else
			setactive(self.mUIRoot, true)
		end
	else
		self.preStory = nil
		self.nextStory = nil
		setactive(self.mUIRoot, false)
	end
end

function UIStoryStageItem:UpdateItem()
	if self.storyData.type == GlobalConfig.StoryType.Normal then
		self:UpdateStage()
	elseif self.storyData.type == GlobalConfig.StoryType.Branch then
		self:UpdateBranch()
	elseif self.storyData.type == GlobalConfig.StoryType.Story then
		self:UpdateStory()
	elseif self.storyData.type == GlobalConfig.StoryType.Hide then
		self:UpdateBranch()
		self.isUnlock = self.isUnlock and NetCmdDungeonData:IsUnlockHideStory(self.storyData.chapter)
	end

	self.mText_RandomNum.text = UIChapterGlobal:GetRandomNum()
	self.branchList = NetCmdDungeonData:GetMainStoryBranchs(self.storyData.id)
	setactive(self.mTrans_RightPoint, false)
	setactive(self.mTrans_TopPoint, false)
	setactive(self.mTrans_BottomPoint, false)
	setactive(self.mTrans_LeftPoint, false)
end

function UIStoryStageItem:UpdateStage()
	local stageData = TableData.GetStageData(self.storyData.stage_id)
	local stageRecord = NetCmdDungeonData:GetCmdStoryData(self.storyData.id)
	local isNext = stageRecord == nil and true or (stageRecord.first_pass_time <= 0)

	if stageData ~= nil then
		self.mText_Title.text = TableData.GetHintById(28)
		self.mText_StageName.text = self.storyData.name.str
		self.isUnlock = NetCmdDungeonData:IsUnLockStory(self.storyData.id)
		UIUtils.SetTextAlpha(self.mText_StageName,  self.isUnlock and 1 or 0.19)

		setactive(self.mTrans_Lock, not self.isUnlock)
		setactive(self.mTrans_Next, isNext and self.isUnlock)
		if self.isUnlock then
			if stageRecord then
				setactive(self.mTrans_UnLock, stageRecord.complete_challenge.Length < UIChapterGlobal.MaxChallengeNum)
				setactive(self.mTrans_Completed, stageRecord.complete_challenge.Length >= UIChapterGlobal.MaxChallengeNum)
			else
				setactive(self.mTrans_UnLock, true)
				setactive(self.mTrans_Completed, false)
			end
		else
			setactive(self.mTrans_UnLock, false)
			setactive(self.mTrans_Completed, false)
		end

		self:UpdateChallenge(stageRecord)
	end
end

function UIStoryStageItem:UpdateBranch()
	local stageData = TableData.GetStageData(self.storyData.stage_id)
	local stageRecord = NetCmdDungeonData:GetCmdStoryData(self.storyData.id)

	if stageData ~= nil then
		self.mText_Title.text = TableData.GetHintById(29)
		self.mText_BranchName.text = self.storyData.name.str
		self.isUnlock = NetCmdDungeonData:IsUnLockStory(self.storyData.id)
		UIUtils.SetTextAlpha(self.mText_BranchName,  self.isUnlock and 1 or 0.4)
		setactive(self.mTrans_Lock, not self.isUnlock)
		setactive(self.mTrans_Next, false)

		if self.isUnlock then
			if stageRecord then
				setactive(self.mTrans_UnLock, stageRecord.complete_challenge.Length < UIChapterGlobal.MaxChallengeNum)
				setactive(self.mTrans_Completed, stageRecord.complete_challenge.Length >= UIChapterGlobal.MaxChallengeNum)
			else
				setactive(self.mTrans_UnLock, true)
				setactive(self.mTrans_Completed, false)
			end
		else
			setactive(self.mTrans_UnLock, false)
			setactive(self.mTrans_Completed, false)
		end

		self:UpdateChallenge(stageRecord)
	end
end

function UIStoryStageItem:UpdateStory()
	local stageData = TableData.GetStageData(self.storyData.stage_id)
	local stageRecord = NetCmdDungeonData:GetCmdStoryData(self.storyData.id)
	local isNext = stageRecord == nil and true or (stageRecord.first_pass_time <= 0)

	if stageData ~= nil then
		self.mText_Title.text = TableData.GetHintById(30)
		self.mText_StoryName.text = self.storyData.name.str
		self.isUnlock = NetCmdDungeonData:IsUnLockStory(self.storyData.id)

		setactive(self.mTrans_StoryLock, not self.isUnlock)
		setactive(self.mTrans_Next, isNext and self.isUnlock)

		if self.isUnlock then
			setactive(self.mTrans_StoryUnlock, stageRecord == nil)
			setactive(self.mTrans_StoryWatch, stageRecord ~= nil)
		else
			setactive(self.mTrans_StoryUnlock, false)
			setactive(self.mTrans_StoryWatch, false)
		end
	end
end

function UIStoryStageItem:RefreshStage()
	if self.storyData then
		if self.storyData.type == GlobalConfig.StoryType.Normal then
			self:UpdateStage()
		elseif self.storyData.type == GlobalConfig.StoryType.Branch then
			self:UpdateBranch()
		elseif self.storyData.type == GlobalConfig.StoryType.Story then
			self:UpdateStory()
		elseif self.storyData.type == GlobalConfig.StoryType.Hide then
			self:UpdateBranch()
		end
		self:UpdatePoint(self.isUnlock)
	end
end

function UIStoryStageItem:UpdateChallenge(cmdData)
	if cmdData then
		for i, obj in ipairs(self.challengeList) do
			UIUtils.SetAlpha(obj.imgBg, (cmdData ~= nil and cmdData.complete_challenge.Length >= i) and 1 or 0.5)
			setactive(obj.tranOn,  cmdData ~= nil and cmdData.complete_challenge.Length >= i)
		end
	else
		for i, obj in ipairs(self.challengeList) do
			UIUtils.SetAlpha(obj.imgBg, 0.5)
			setactive(obj.tranOn,  false)
		end
	end
end

function UIStoryStageItem:UpdateStagePos(delta)
	if self.storyData then
		self.mTrans_Item.anchoredPosition = Vector2(self.storyData.mSfxPos.x + delta, self.storyData.mSfxPos.y)
	end
end

function UIStoryStageItem:SetUpOrDownPoint()
	local temVec = self.mTrans_RightPoint.anchoredPosition
	if self.mTrans_Item.anchoredPosition.y >= 0 then
		-- self.mTrans_RightPoint.pivot = Vector2(1, 1)
		temVec.y = temVec.y + self.mTrans_RightPoint.sizeDelta.y / 2
	else
		-- self.mTrans_RightPoint.pivot = Vector2(1, 0)
		temVec.y = temVec.y - self.mTrans_RightPoint.sizeDelta.y / 2
	end
	self.mTrans_RightPoint.anchoredPosition = temVec
end

function UIStoryStageItem:SetLine(startPos, endPos)
	if self.lineItem then
		self.lineItem:SetLinePos(startPos, endPos)
	end
	self:UpdatePoint()
end

function UIStoryStageItem:SetBranchLine(startPos, endPos)
	if self.branchLineItem then
		self.branchLineItem:SetBranchLine(startPos, endPos)
	end
	self:UpdatePoint()
end

function UIStoryStageItem:UpdatePoint()
	if self.preStory then
		self.mTrans_LeftPoint.color = self.isUnlock and ColorUtils.OrangeColor or ColorUtils.BlackColor
		if self.preStory.nextStory then
			self.mTrans_BottomPoint.color =  self.preStory.nextStory.isUnlock and ColorUtils.OrangeColor or ColorUtils.BlackColor
			self.mTrans_TopPoint.color =  self.preStory.nextStory.isUnlock and ColorUtils.OrangeColor or ColorUtils.BlackColor
		else
			self.mTrans_BottomPoint.color =  self.preStory.isUnlock and ColorUtils.OrangeColor or ColorUtils.BlackColor
			self.mTrans_TopPoint.color =  self.preStory.isUnlock and ColorUtils.OrangeColor or ColorUtils.BlackColor
		end
	end

	if self.nextStory then
		local nextUnlock = self.nextStory.isUnlock
		self.mTrans_RightPoint.color = nextUnlock and ColorUtils.OrangeColor or ColorUtils.BlackColor
	end

	if self.lineItem and self.nextStory then
		self.lineItem:UpdateLineColor(self.nextStory.isUnlock)
	end

	if self.branchLineItem and self.preStory then
		if self.preStory.nextStory then
			self.branchLineItem:UpdateLineColor(self.preStory.nextStory.isUnlock)
		else
			self.branchLineItem:UpdateLineColor(self.preStory.isUnlock)
		end
	end
end

function UIStoryStageItem:GetIndexOfBranch(storyId)
	if self.branchList and self.branchList.Count then
		for i = 0, self.branchList.Count - 1 do
			if self.branchList[i] == storyId then
				return i
			end
		end
	end
	return -1
end

function UIStoryStageItem:SetSelected(isSelect)
	self.mBtn_Stage.interactable = not isSelect
end