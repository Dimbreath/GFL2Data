require("UI.UIBaseCtrl")

UIChapterLineItem = class("UIChapterLineItem", UIBaseCtrl)
UIChapterLineItem.__index = UIChapterLineItem
--@@ GF Auto Gen Block Begin
UIChapterLineItem.mTrans_Line = nil

function UIChapterLineItem:__InitCtrl()
	self.mTrans_Line = self:GetSelfRectTransform()
	self.mImage_Line = self:GetSelfImage()
end

--@@ GF Auto Gen Block End

UIChapterLineItem.parent = nil
UIChapterLineItem.supportLine = nil

function UIChapterLineItem:InitCtrl(parent)
	self.parent = parent
	local obj = instantiate(UIUtils.GetGizmosPrefab("story/StoryChapterLineItemV2.prefab",self))
	CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	self:SetRoot(obj.transform)

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIChapterLineItem:EnableLine(enable)
	setactive(self.mUIRoot.gameObject, enable)
end

function UIChapterLineItem:EnableSupportLine(enable)
	if self.supportLine ~= nil then
		setactive(self.supportLine.gameObject, enable)
	end
end

function UIChapterLineItem:SetParent(parent)
	self.parent = parent
	CS.LuaUIUtils.SetParent(self.mUIRoot.gameObject, parent.gameObject, false)
	if self.supportLine ~= nil then
		CS.LuaUIUtils.SetParent(self.supportLine.gameObject, parent.gameObject, false)
	end
end

function UIChapterLineItem:SetLinePos(startPos, endPos, isComplete)
	local temEnd  = Vector3(startPos.x, endPos.y, startPos.z)

	if math.abs(endPos.y - startPos.y) < 0.1 then
		self.mTrans_Line.sizeDelta = Vector2(math.abs(endPos.x - startPos.x), self.mTrans_Line.sizeDelta.y)
		local angle = math.deg(math.atan(temEnd.y - startPos.y, temEnd.x - startPos.x))
		self.mTrans_Line.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, angle)
		self.mTrans_Line.anchoredPosition = Vector2(0, 0)
	else
		--self.mTrans_Line.sizeDelta = Vector2(math.abs(endPos.y - startPos.y), self.mTrans_Line.sizeDelta.y)
		--local angle = math.deg(math.atan(temEnd.y - startPos.y, temEnd.x - startPos.x))
		--self.mTrans_Line.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, angle)
		--self.mTrans_Line.anchoredPosition = Vector2(0, startPos.y)
		--
		---- 需要辅助线
		--if math.abs(endPos.x - startPos.x) > 0.1  then
		--	if self.supportLine ~= nil then
		--		setactive(self.supportLine.gameObject, true)
		--	else
		--		local obj = instantiate(UIUtils.GetGizmosPrefab("Story/StoryChapterLineItemV2.prefab",self))
		--		setparent(self.parent, obj.transform)
		--		obj.transform.localScale = vectorone
		--		self.supportLine = CS.LuaUIUtils.GetRectTransform(obj)
		--	end
		--
		--	local tempStart = Vector3(temEnd.x - self.mTrans_Line.sizeDelta.y / 2, temEnd.y)
		--	self.supportLine.sizeDelta = Vector2(Vector3.Distance(tempStart, endPos), self.supportLine.sizeDelta.y)
		--	local angle = math.deg(math.atan(endPos.y - temEnd.y, endPos.x - temEnd.x))
		--	self.supportLine.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, angle)
		--	self.supportLine.anchoredPosition = Vector2(0, -tempStart.y)
		--else
		--	if self.supportLine ~= nil then
		--		setactive(self.supportLine.gameObject, false)
		--	end
		--end
	end
end

function UIChapterLineItem:SetBranchLine(startPos, endPos, isComplete)
	local temEnd  = Vector3(startPos.x, endPos.y, startPos.z)
	if math.abs(endPos.y - startPos.y) > 4 then
		self.mTrans_Line.sizeDelta = Vector2(math.abs(endPos.y - startPos.y), self.mTrans_Line.sizeDelta.y)
		local angle = math.deg(math.atan(temEnd.y - startPos.y, temEnd.x - startPos.x))
		self.mTrans_Line.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, angle)
		self.mTrans_Line.anchoredPosition = Vector2(-(endPos.x - startPos.x), -(endPos.y - startPos.y))

		-- 需要辅助线
		if math.abs(endPos.x - startPos.x) > 4  then
			if self.supportLine ~= nil then
				setactive(self.supportLine.gameObject, true)
			else
				local obj = instantiate(UIUtils.GetGizmosPrefab("Story/StoryChapterLineItemV2.prefab",self))
				CS.LuaUIUtils.SetParent(obj.gameObject, self.parent.gameObject, false)
				obj.transform.localScale = vectorone
				self.supportLine = CS.LuaUIUtils.GetRectTransform(obj)
			end

			local tempStart = Vector3(temEnd.x - self.mTrans_Line.sizeDelta.y / 2, temEnd.y)
			self.supportLine.sizeDelta = Vector2(Vector3.Distance(tempStart, endPos), self.supportLine.sizeDelta.y)
			local angle = math.deg(math.atan(endPos.y - temEnd.y, endPos.x - temEnd.x))
			self.supportLine.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, angle)
			self.supportLine.anchoredPosition = Vector2(-(endPos.x - startPos.x + self.supportLine.sizeDelta.y / 2), 0)
		else
			if self.supportLine ~= nil then
				setactive(self.supportLine.gameObject, false)
			end
		end
	end
end

function UIChapterLineItem:UpdateLineColor(isComplete)
	local color = isComplete and ColorUtils.OrangeColor or ColorUtils.BlackColor
	self.mImage_Line.color = color
	if self.supportLine ~= nil then
		UIUtils.GetImage(self.supportLine).color = color
	end
end

function UIChapterLineItem:UpdateHardLineColor(isComplete, isHard)
	local color = isComplete and isHard and ColorUtils.RedColor2 or ColorUtils.OrangeColor or ColorUtils.BlackColor
	self.mImage_Line.color = color
	if self.supportLine ~= nil then
		UIUtils.GetImage(self.supportLine).color = color
	end
end

function UIChapterLineItem:OnRelease()
	self.supportLine = nil
	self.parent = nil
end