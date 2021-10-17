require("UI.UIBaseCtrl")

UIStoryStageHardItem = class("UIStoryStageHardItem", UIBaseCtrl)
UIStoryStageHardItem.__index = UIStoryStageHardItem

function UIStoryStageHardItem:ctor()
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

function UIStoryStageHardItem:__InitCtrl()
	self.mTrans_Item = self:GetSelfRectTransform()

	self.mBtn_Stage = self:GetSelfButton()

	self.animator = self:GetSelfAnimator()

	self.mText_RandomNum = self:GetText("Root/GrpBottomLeft/Text1");
	self.mText_Num = self:GetText("Root/GrpLeftTime/Text_Num");
	self.mText_StageName = self:GetText("Root/GrpChapterText/Text_Chapter");
	self.mText_StageNameLocked = self:GetText("Root/GrpLock/GrpText/Text_Chapter");
	self.mText_Locked = self:GetText("Root/GrpLock/GrpText/TextLock");

	self.mTrans_Lock = self:GetRectTransform("Root/GrpLock/GrpText")
	self.mTrans_Next = self:GetRectTransform("Root/Trans_GrpNowProgress");
	self.mTrans_ChallengeList = self:GetRectTransform("Root/Trans_GrpStage");
	self.mTrans_Story = self:GetRectTransform("Root/Trans_GrpDot");

	self.mTrans_TopPoint = self:GetImage("Root/Trans_GrpDot/Trans_ImgDotTop");
	self.mTrans_BottomPoint = self:GetImage("Root/Trans_GrpDot/Trans_ImgDotBottom");
	self.mTrans_RightPoint = self:GetImage("Root/Trans_GrpDot/Trans_ImgDotRight");
	self.mTrans_LeftPoint = self:GetImage("Root/Trans_GrpDot/Trans_ImgDotLeft");

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

function UIStoryStageHardItem:InitCtrl(parent)
   local obj = instantiate(UIUtils.GetGizmosPrefab("story/StoryChapterDifficultyItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)

	self:__InitCtrl()

	setactive(self.mTrans_Story.gameObject, true)
end

function UIStoryStageHardItem:SetData(data)
	self.storyData = data

	if data ~= nil then
		setactive(self.mTrans_ChallengeList, data.type == GlobalConfig.StoryType.Hard)

		self:UpdateItem()

		setactive(self.mUIRoot, true)
	else
		self.preStory = nil
		self.nextStory = nil
		setactive(self.mUIRoot, false)
	end
end

function UIStoryStageHardItem:UpdateItem()
	self:UpdateStage()

	self.mText_RandomNum.text = UIChapterGlobal:GetRandomNum()
	self.branchList = NetCmdDungeonData:GetMainStoryBranchs(self.storyData.id)
	setactive(self.mTrans_RightPoint, false)
	setactive(self.mTrans_TopPoint, false)
	setactive(self.mTrans_BottomPoint, false)
	setactive(self.mTrans_LeftPoint, false)
end

function UIStoryStageHardItem:UpdateStage()
	local stageData = TableData.GetStageData(self.storyData.stage_id)
	local stageRecord = NetCmdDungeonData:GetCmdStoryData(self.storyData.id)
	local isNext = stageRecord == nil and true or (stageRecord.first_pass_time <= 0)

	if stageData ~= nil then
		self.mText_Locked.text = TableData.GetHintById(900009)
		self.mText_StageName.text = self.storyData.name.str
		self.mText_StageNameLocked.text = self.storyData.name.str
		self.isUnlock = NetCmdDungeonData:IsUnLockStory(self.storyData.id)
		--UIUtils.SetTextAlpha(self.mText_StageName,  self.isUnlock and 1 or 0.19)
		--
		setactive(self.mTrans_Lock, not self.isUnlock)
		local leftTimes = self.storyData.daily_times - NetCmdDungeonData:DailyTimes(self.storyData.id)
		if leftTimes > 0 then
			self.mText_Num.text = leftTimes .. "/" .. self.storyData.daily_times
		else
			self.mText_Num.text = "<color=#FF5E41>" .. leftTimes .. "</color>/" .. self.storyData.daily_times;
		end

		setactive(self.mTrans_Next, isNext and self.isUnlock)
		self.animator:SetBool("LockState", self.isUnlock)
		if not self.isUnlock then
			self.animator:Play("F", 1, 1)
		end
		self:UpdateChallenge(stageRecord)
	end
end

function UIStoryStageHardItem:RefreshStage()
	if self.storyData then
		self:UpdateStage()
		self:UpdatePoint(self.isUnlock)
	end
end

function UIStoryStageHardItem:UpdateChallenge(cmdData)
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

function UIStoryStageHardItem:UpdateStagePos(delta)
	if self.storyData then
		self.mTrans_Item.anchoredPosition = Vector2(self.storyData.mSfxPos.x + delta, self.storyData.mSfxPos.y)
	end
end

function UIStoryStageHardItem:SetUpOrDownPoint()
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

function UIStoryStageHardItem:SetLine(startPos, endPos)
	if self.lineItem then
		self.lineItem:SetLinePos(startPos, endPos)
	end
	self:UpdatePoint()
end

function UIStoryStageHardItem:SetBranchLine(startPos, endPos)
	if self.branchLineItem then
		self.branchLineItem:SetBranchLine(startPos, endPos)
	end
	self:UpdatePoint()
end

function UIStoryStageHardItem:UpdatePoint()
	if self.preStory then
		self.mTrans_LeftPoint.color = self.isUnlock and ColorUtils.RedColor2 or ColorUtils.BlackColor
		if self.preStory.nextStory then
			self.mTrans_BottomPoint.color =  self.preStory.nextStory.isUnlock and ColorUtils.RedColor2 or ColorUtils.BlackColor
			self.mTrans_TopPoint.color =  self.preStory.nextStory.isUnlock and ColorUtils.RedColor2 or ColorUtils.BlackColor
		else
			self.mTrans_BottomPoint.color =  self.preStory.isUnlock and ColorUtils.RedColor2 or ColorUtils.BlackColor
			self.mTrans_TopPoint.color =  self.preStory.isUnlock and ColorUtils.RedColor2 or ColorUtils.BlackColor
		end
	end

	if self.nextStory then
		local nextUnlock = self.nextStory.isUnlock
		self.mTrans_RightPoint.color = nextUnlock and ColorUtils.RedColor2 or ColorUtils.BlackColor
	end

	if self.lineItem and self.nextStory then
		self.lineItem:UpdateHardLineColor(self.nextStory.isUnlock, true)
	end

	if self.branchLineItem and self.preStory then
		if self.preStory.nextStory then
			self.branchLineItem:UpdateHardLineColor(self.preStory.nextStory.isUnlock, true)
		else
			self.branchLineItem:UpdateHardLineColor(self.preStory.isUnlock, true)
		end
	end
end

function UIStoryStageHardItem:SetSelected(isSelect)
	self.mBtn_Stage.interactable = not isSelect
end