require("UI.UIBaseCtrl")
require("UI.BattleIndexPanel.Item.UIMainChapterItem")

UIChapterInfoPanel = class("UIChapterInfoPanel", UIBaseCtrl)
UIChapterInfoPanel.__index = UIChapterInfoPanel
--@@ GF Auto Gen Block Begin
UIChapterInfoPanel.mBtn_Normal = nil
UIChapterInfoPanel.mBtn_Hard = nil
UIChapterInfoPanel.mTrans_ChapterList = nil
UIChapterInfoPanel.mTrans_Normal_NormalMask = nil
UIChapterInfoPanel.mTrans_Normal_Unlock = nil
UIChapterInfoPanel.mTrans_Hard_HardMask = nil
UIChapterInfoPanel.mTrans_Hard_Unlock = nil

UIChapterInfoPanel.PrefabPath = "BattleIndex/UIMainChapterListItem.prefab"
UIChapterInfoPanel.curDiff = 1
UIChapterInfoPanel.chapterItemList = {}
UIChapterInfoPanel.isHardUnLock = false
UIChapterInfoPanel.enterLineItemList = {}
UIChapterInfoPanel.lastLineItemList = {}
UIChapterInfoPanel.pointList = {}
UIChapterInfoPanel.lastEffectList = nil
UIChapterInfoPanel.effectPoint = nil
UIChapterInfoPanel.disappearEffectPoint = nil
UIChapterInfoPanel.curChapterId = 0
UIChapterInfoPanel.lastEnterChapter = nil
UIChapterInfoPanel.enterChapter = nil
UIChapterInfoPanel.needUpdate = false

UIChapterInfoPanel.DifficultyType = {
	Normal = 1,
	Hard = 2,
}

function UIChapterInfoPanel:ctor()
	UIChapterInfoPanel.super.ctor(self)
    self.isAni = false
end

function UIChapterInfoPanel:__InitCtrl()
	self.mBtn_Normal = self:GetButton("SelectDifficulty/UI_Btn_Normal")
	self.mBtn_Hard = self:GetButton("SelectDifficulty/UI_Btn_Hard")
	self.mTrans_Bg = self:GetRectTransform("BG")
	self.mTrans_ChapterList = self:GetRectTransform("ChapterListPanel/ChapterList/Trans_ChapterList")
	self.mTrans_Normal_NormalMask = self:GetRectTransform("SelectDifficulty/UI_Btn_Normal/Trans_NormalMask")
	self.mTrans_Normal_Unlock = self:GetRectTransform("SelectDifficulty/UI_Btn_Normal/Trans_Unlock")
	self.mTrans_Hard_HardMask = self:GetRectTransform("SelectDifficulty/UI_Btn_Hard/Trans_HardMask")
	self.mTrans_Hard_Unlock = self:GetRectTransform("SelectDifficulty/UI_Btn_Hard/Trans_Unlock")
	self.mTrans_NormalSelect = self:GetRectTransform("SelectDifficulty/UI_Btn_Normal/Trans_Choose")
	self.mTrans_HardSelect = self:GetRectTransform("SelectDifficulty/UI_Btn_Hard/Trans_Choose")
	self.mTrans_Lines = self:GetRectTransform("BG/UI_Trans_Lines")
	self.mTrans_Point = self:GetRectTransform("BG/Trans_Point")

	self.mScrollRect = UIUtils.GetScrollRectEx(self.mUIRoot, "ChapterListPanel")

	UIUtils.GetButtonListener(self.mBtn_Normal.gameObject).onClick = function()
		self:OnClickDiffChange(UIChapterInfoPanel.DifficultyType.Normal)
	end

	UIUtils.GetButtonListener(self.mBtn_Hard.gameObject).onClick = function()
		self:OnClickDiffChange(UIChapterInfoPanel.DifficultyType.Hard)
	end
end

function UIChapterInfoPanel:InitCtrl(parent)
	local instObj = instantiate(UIUtils.GetGizmosPrefab(self.PrefabPath, self))

	CS.LuaUIUtils.SetParent(instObj.gameObject, parent.gameObject, true)

	self:SetRoot(instObj.transform)
	self:__InitCtrl()

	self:InitChapterPoint()
end

function UIChapterInfoPanel:InitChapterPoint()
	local point = instantiate(UIUtils.GetGizmosPrefab("BattleIndex/Effect/UIEF_UIMainChapterItem_Point.prefab", self))
	local disappearPoint = instantiate(UIUtils.GetGizmosPrefab("BattleIndex/Effect/UIEF_UIMainChapterItem_Point01.prefab", self))
	CS.LuaUIUtils.SetParent(point, self.mTrans_Point.gameObject)
	CS.LuaUIUtils.SetParent(disappearPoint, self.mTrans_Point.gameObject)
	self.effectPoint = UIUtils.GetRectTransform(point)
	self.disappearEffectPoint = UIUtils.GetRectTransform(disappearPoint)
	setactive(self.effectPoint, false)
	setactive(self.disappearEffectPoint, false)
end

function UIChapterInfoPanel:CreatePoint(pos, index)
	local point = {}
	local obj = UIUtils.CreateGameObj(pos, self.mTrans_Point)
	if obj then
		obj.name = "point_" .. index
	end

	point.transform = UIUtils.GetRectTransform(obj)
	return point
end

function UIChapterInfoPanel:OnEnable(enable)
	setactive(self.mUIRoot, enable)
end

function UIChapterInfoPanel:OnShow()
	self.needUpdate = true
	self:SetData()
end

function UIChapterInfoPanel:OnHide()
	self:ResetDisappearLine()
	self.needUpdate = false
end

function UIChapterInfoPanel:OnRelease()
	UIChapterInfoPanel.chapterItemList = {}
	UIChapterInfoPanel.enterLineItemList = {}
	UIChapterInfoPanel.pointList = {}
	UIChapterInfoPanel.lastLineItemList = {}

	if UIChapterInfoPanel.effectPoint then
		ResourceManager:DestroyInstance(UIChapterInfoPanel.effectPoint)
		UIChapterInfoPanel.effectPoint = nil
	end

	if UIChapterInfoPanel.disappearEffectPoint then
		ResourceManager:DestroyInstance(UIChapterInfoPanel.disappearEffectPoint)
		UIChapterInfoPanel.disappearEffectPoint = nil
	end
end

function UIChapterInfoPanel:OnClose()
	-- UIChapterInfoPanel.curChapterId = 0
end

function UIChapterInfoPanel:SetData()
	local data = UIChapterInfoPanel.curDiff == UIChapterInfoPanel.DifficultyType.Normal and TableData.GetNormalChapterList() or TableData.GetHardChapterList()
	local curChapter = nil
	if data then
		for _, item in ipairs(self.chapterItemList) do
			item:SetData(nil)
		end

		for i = 0, data.Count - 1 do
			local item = nil
			if i + 1 > #self.chapterItemList then
				item = UIMainChapterItem.New()
				item:InitCtrl(self.mTrans_ChapterList.transform)

				local pointPos = Vector3(data[i].mLocation.x, data[i].mLocation.y, 0)
				local point = self:CreatePoint(pointPos, i + 1)
				table.insert(self.chapterItemList, item)
				table.insert(self.pointList, point)
			else
				item = self.chapterItemList[i + 1]
			end
			if item then
				item:SetData(data[i], UIChapterInfoPanel.curDiff == UIChapterInfoPanel.DifficultyType.Hard, i + 1)
				UIUtils.GetButtonListener(item.mBtn_StoryChapter.gameObject).onClick = function()
					self:OnClickChapter(item)
				end

				if UIChapterInfoPanel.curChapterId == 0 then
					if item.isUnLock then
						curChapter = item
					end
				else
					if UIChapterInfoPanel.curChapterId == data[i].id then
						curChapter = item
					end
				end
			end
		end

		if data.Count > 0 then
			self:UpdateCombatContent(data[0], data[data.Count - 1], self.chapterItemList[1]:GetItemSize())
			setactive(self.mTrans_Hard_Unlock, UIChapterInfoPanel.curDiff == UIChapterInfoPanel.DifficultyType.Normal and
					                                   not(self:CheckHardModeIsUnLock(data[0])))
		end

		self.needUpdate = true
		self:ScrollToMid(curChapter.mRectTransform, false)

		self:UpdateModeButton()
		self:UpdateLine()

		setactive(self.mUIRoot.gameObject, true)
	end

	setactive(self.mTrans_Lines, true)
end

function UIChapterInfoPanel:OnClickChapter(item)
    if self.isAni then
        return
    end

	if not item.isUnLock then
		local hint = UIChapterInfoPanel.curDiff == UIChapterInfoPanel.DifficultyType.Normal and TableData.GetHintById(70003) or TableData.GetHintById(70002)
		CS.PopupMessageManager.PopupString(hint)
		return
	end

    self.isAni = true
	self:ScrollToMid(item.mRectTransform, true,function ()
		self:EnterChapter(item)
        self.isAni = false
	end)
end

function UIChapterInfoPanel:EnterChapter(item)
	if item.data.id and item.isUnLock then
		local chapterId = item.data.id > 100 and item.data.id - 100 or item.data.id
		UIChapterInfoPanel.curChapterId = item.data.id

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

function UIChapterInfoPanel:OnSwitchByChapterID(msg)
	if(msg.Sender == 1)then
		local paramArray = msg.Content
		local chapterID = tonumber(paramArray[0])
		for _, item in ipairs(self.chapterItemList) do
			if item.data.id == chapterID then
				self:OnClickChapter(item)
			end
		end
	end
end

function UIChapterInfoPanel:CheckHardModeIsUnLock(firstChapter)
	local isUnLock = false
	if firstChapter then
		local diffData = TableData.GetDiffChapterDataByNormChapterID(firstChapter.id)
		if diffData then
			isUnLock = (NetCmdDungeonData:IsUnLockChapter(diffData.id))
		end
	end
	self.IsHardModeUnLocked = isUnLock
	return isUnLock
end

function UIChapterInfoPanel:UpdateCombatContent(first, last, delta)
	local panelSize = delta.x * 2
	local delta = last.mPosition.x - first.mPosition.x
	self.mTrans_ChapterList.sizeDelta = Vector2(panelSize + delta, 0)
end

function UIChapterInfoPanel:OnClickDiffChange(mode)
	if UIChapterInfoPanel.curDiff == mode then
		return
	end
	if mode == UIChapterInfoPanel.DifficultyType.Hard then
		if not self.IsHardModeUnLocked then
			local hint = TableData.GetHintById(70002)
			CS.PopupMessageManager.PopupString(hint)
			return
		end
	end
	UIChapterInfoPanel.curDiff = mode
	self:SetData()
	self:UpdateRedPoint()
end

function UIChapterInfoPanel:UpdateModeButton()
	setactive(self.mTrans_NormalSelect.gameObject, UIChapterInfoPanel.curDiff == UIChapterInfoPanel.DifficultyType.Normal)
	setactive(self.mTrans_HardSelect.gameObject, UIChapterInfoPanel.curDiff == UIChapterInfoPanel.DifficultyType.Hard)
end

function UIChapterInfoPanel:UpdateLine()
	--if self.enterLineItemList then
	--	for _, v in ipairs(self.enterLineItemList) do
	--		v:EnableLine(false)
	--	end
	--end
	if not self.needUpdate then
		return
	end

	local isItemChange = false
	local curChapter = nil
	for i = 1, #self.chapterItemList do
		local chapter = self.chapterItemList[i]
		if chapter.data == nil then
			break
		end
		if self.mScrollRect:IsIntersects(chapter.mRectTransform) then
			local lineList = {}
			local item = nil
			local point = self.pointList[i].transform
			local pointPos = point.anchoredPosition
			for j = 1, #chapter.pointList do
				if j <= #self.enterLineItemList then
					item = self.enterLineItemList[j]
					item:EnableLine(true)
				else
					item = UIBattleIndexLine.New()
					item:InitCtrl(self.mTrans_Lines)
					table.insert(self.enterLineItemList, item)
				end
				local temVec1 = chapter.pointList[j].localPosition
				local temVec2 = UIUtils.TransformPoint(chapter.mTrans_PointList, point)

				table.insert(lineList, item)
				item:SetLineDir(pointPos, temVec1, temVec2)
			end

			if self.effectPoint then
				self.effectPoint.anchoredPosition = pointPos
				setactive(self.effectPoint, true	)
			end
			chapter:SetEffectObj(lineList)

			if self.enterChapter == nil then
				self.enterChapter = chapter
			end
			if self.enterChapter.data.id ~= chapter.data.id then
				self.lastEnterChapter = self.enterChapter
				self.enterChapter = chapter
				self.enterChapter:PlayLineAni(true)
				isItemChange = true
			end
			curChapter = chapter
			break
		end
	end

	if self.lastEnterChapter then
		local item = nil
		local lineList = {}
		local point = self.pointList[self.lastEnterChapter.index].transform
		local pointPos = point.anchoredPosition
		for j = 1, #self.lastEnterChapter.pointList do
			if j <= #self.lastLineItemList then
				item = self.lastLineItemList[j]
				item:EnableLine(true)
			else
				item = UIBattleIndexLine.New()
				item:InitCtrl(self.mTrans_Lines)
				table.insert(self.lastLineItemList, item)
			end

			local temVec1 = self.lastEnterChapter.pointList[j].localPosition
			local temVec2 = UIUtils.TransformPoint(self.lastEnterChapter.mTrans_PointList, point)

			table.insert(lineList, item)

			item:SetLineDir(pointPos, temVec1, temVec2)
		end

		if isItemChange then
			self.lastEnterChapter:SetEffectObj(lineList)
			self.lastEnterChapter:PlayLineAni(false)
			if self.disappearEffectPoint then
				self.disappearEffectPoint.anchoredPosition = pointPos
				setactive(self.disappearEffectPoint, true)
			end
		end
	end
end

function UIChapterInfoPanel:OnUpdate()
	self:UpdateLine()
end

function UIChapterInfoPanel:UpdateRedPoint()
	for _, item in ipairs(self.chapterItemList) do
		item:UpdateRedPoint()
	end
end

function UIChapterInfoPanel:ScrollToMid(itemRect, needAni, callback)
	local vec = UIUtils.TransformPoint(self:GetSelfRectTransform(), itemRect)
	local tempVec = self.mTrans_ChapterList.anchoredPosition
	tempVec.x = tempVec.x - vec.x
	if needAni then
		DOTween.DoAnchorsPosMove(self.mTrans_ChapterList, tempVec, 0.3, 0, callback)
	else
		self.mTrans_ChapterList.anchoredPosition = tempVec
	end
end

function UIChapterInfoPanel:ResetDisappearLine()
	if self.lastLineItemList then
		for _, item in ipairs(self.lastLineItemList) do
			item:EnableLine(false)
		end
		setactive(self.disappearEffectPoint, false)
		self.lastEnterChapter = nil
	end
end