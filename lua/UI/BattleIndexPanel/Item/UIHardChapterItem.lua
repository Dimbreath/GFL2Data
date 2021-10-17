require("UI.UIBaseCtrl")
---@class UIHardChapterItem : UIBaseCtrl
UIHardChapterItem = class("UIHardChapterItem", UIBaseCtrl)
UIHardChapterItem.__index = UIHardChapterItem
--@@ GF Auto Gen Block Begin
UIHardChapterItem.mBtn_StoryChapter = nil
UIHardChapterItem.mImage_FrameImage = nil
UIHardChapterItem.mImage_IconImage = nil
UIHardChapterItem.mText_ChapterCount = nil
UIHardChapterItem.mText_ChapterName = nil
UIHardChapterItem.mText_ChapterNumber = nil
UIHardChapterItem.mText_StoryChapterSchedule_Schedule = nil
UIHardChapterItem.mText_StoryChapterSchedule_ChapterScheduleCount = nil
UIHardChapterItem.mTrans_RedPoint = nil
UIHardChapterItem.mTrans_Normal = nil
UIHardChapterItem.mTrans_ChapterSignImage = nil
UIHardChapterItem.mTrans_ChapterNew = nil
UIHardChapterItem.mTrans_LockMask = nil

UIHardChapterItem.PrefabPath = "BattleIndex/DifficultyCombatChapterItemV2.prefab"

function UIHardChapterItem:ctor()
	--self.pointList = {}
	--self.lineList = {}
	self.pointObj = nil
	self.index = 0
end

function UIHardChapterItem:__InitCtrl()
	self.mRectTransform = self:GetSelfRectTransform()
	self.mBtn_StoryChapter = self:GetSelfButton();
 	self.animator = self:GetSelfAnimator()
	self.mImage_IconImage = self:GetImage("GrpContent/GrpBgScene/Img_Bg");
	self.mImage_ChapterNumberBG = self:GetImage("GrpContent/GrpChapterNum/GrpBg/Img_Bg");
	self.mImage_ChapterNumber = self:GetImage("GrpContent/GrpChapterNum/GrpNum/Img_Bg");
	self.mText_ChapterScheduleCount = self:GetText("GrpContent/ProgressNum/Text_Progress");
	self.mText_Limit = self:GetText("GrpContent/LevelLimit/Text_Limit");
	self.mText_ChapterCount = self:GetText("GrpContent/ChapterText/Text_Name");
	self.mTrans_LevelLimit = self:GetRectTransform("GrpContent/LevelLimit")
	self.mTrans_LockMask = self:GetRectTransform("GrpContent/GrpState/Trans_GrpLocked");
	self.mTrans_Next = self:GetRectTransform("GrpContent/GrpState/Trans_GrpNowProgress");
	self.mTrans_RedPoint = self:GetRectTransform("GrpContent/GrpState/Trans_GrpRedPoint");
end

--@@ GF Auto Gen Block End

function UIHardChapterItem:InitCtrl(parent)
	local instObj = instantiate(UIUtils.GetGizmosPrefab(self.PrefabPath, self))

	CS.LuaUIUtils.SetParent(instObj.gameObject, parent.gameObject)

	self:SetRoot(instObj.transform)
	self:__InitCtrl()
end

function UIHardChapterItem:SetData(data, isHard, index)
	if data ~= nil then
		setactive(self.mUIRoot, true)
		self.data = data
		self.index = index
		self.isUnLock = NetCmdDungeonData:UnCompletePrevChapterId(data.id)
		self.levelUnlocked = AccountNetCmdHandler:GetLevel() >= data.level
		self.isHard = isHard
		self.isNext = self.isUnLock == 0 and self.levelUnlocked and NetCmdDungeonData:UpdateChapterRedPoint(data.id) > 0
		self.isNew = not(AccountNetCmdHandler:IsWatchedChapter(data.id))
		self.mText_Limit.text = string_format(TableData.GetHintById(103031), AccountNetCmdHandler:GetLevel())

		setactive(self.mTrans_LevelLimit, not self.levelUnlocked)

		self:UpdateChapterItem()
		self:InitChapterPos(data.mPosition)
	else
		setactive(self.mUIRoot, false)
	end
end

function UIHardChapterItem:UpdateChapterItem()
	local chapterNum = self.data.id > 100 and self.data.id - 100 or self.data.id
	--self.mText_ChapterNumber.text = chapterNum < 10 and "0" .. chapterNum or chapterNum

	self.mImage_ChapterNumber.sprite =  IconUtils.GetAtlasV2("Icon/BattleIndexPic","Img_BattleIndex_Chapter"..chapterNum);
	self.mImage_IconImage.sprite = IconUtils.GetStageIcon(self.data.background)
	self.mText_ChapterCount.text = self.data.name.str
	setactive(self.mTrans_LockMask, self.isUnLock > 0 or not self.levelUnlocked)
	setactive(self.mTrans_Next, self.isNext)
	self:CalculatePercent()
	self:SetLocked();
end

function UIHardChapterItem:SetLocked()
	if(self.isUnLock > 0 or not self.levelUnlocked) then
		self.mImage_ChapterNumber.color = ColorUtils.StringToColor("A0A0A0")
		self.mImage_IconImage.color = ColorUtils.StringToColor("A0A0A0")
		self.mText_ChapterScheduleCount.color = ColorUtils.StringToColor("A0A0A0")
		self.mImage_ChapterNumberBG.color = ColorUtils.StringToColor("333333")
	end	
end

function UIHardChapterItem:CalculatePercent()
	local data = TableData.GetStorysByChapterID(self.data.id)
	local total = data.Count * 3
	local stars = NetCmdDungeonData:GetCurStarsByChapterID(self.data.id) + NetCmdDungeonData:GetFinishChapterStoryCountByChapterID(self.data.id) * 3
	self.mText_ChapterScheduleCount.text = tostring(math.ceil((stars / total) * 100)) .. "%"

	if(stars / total < 1) then
		self.mText_ChapterScheduleCount.color = ColorUtils.WhiteColor;
	end
	
end

function UIHardChapterItem:InitChapterPos(pos)
	if pos then
		local rect = self:GetSelfRectTransform()
		rect.anchoredPosition = Vector2(pos.x + rect.rect.size.x, pos.y)
	end
end

function UIHardChapterItem:GetItemSize()
	local rect = self:GetSelfRectTransform()
	return rect.rect.size
end

function UIHardChapterItem:UpdateRedPoint()
	if self.data == nil then
		return
	end
	setactive(self.mTrans_RedPoint, self.isUnLock == 0 and self.levelUnlocked and NetCmdDungeonData:UpdateChatperRewardRedPoint(self.data.id) > 0)
	self.animator:SetBool("LockState", self.isUnLock == 0 and self.levelUnlocked)
	if self.isUnLock > 0 or not self.levelUnlocked then
		self.animator:Play("F", 1, 1)
	end
end

-- function UIHardChapterItem:SetEffectObj(lineList, point)
-- 	self.lineList = lineList
-- 	self.pointObj = point
-- end

-- function UIHardChapterItem:PlayLineAni(enable)
-- 	if self.lineList then
-- 		for _, line in ipairs(self.lineList) do
-- 			line:PlayLineAni(enable)
-- 		end
-- 	end
-- end