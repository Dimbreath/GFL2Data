require("UI.UIBaseCtrl")

---@class UIAchievementLeftTabItemV2 : UIBaseCtrl
UIAchievementLeftTabItemV2 = class("UIAchievementLeftTabItemV2", UIBaseCtrl);
UIAchievementLeftTabItemV2.__index = UIAchievementLeftTabItemV2
--@@ GF Auto Gen Block Begin
UIAchievementLeftTabItemV2.mImg_Frame = nil;
UIAchievementLeftTabItemV2.mImg_Nor = nil;
UIAchievementLeftTabItemV2.mImg_Icon = nil;
UIAchievementLeftTabItemV2.mText_Tittle = nil;
UIAchievementLeftTabItemV2.mText_Progress = nil;
UIAchievementLeftTabItemV2.mText_ = nil;
UIAchievementLeftTabItemV2.mTrans_RedPoint = nil;

function UIAchievementLeftTabItemV2:__InitCtrl()
	self.mBtn = self:GetSelfButton()
	self.mImg_Frame = self:GetImage("GrpBg/Img_Frame");
	self.mImg_Nor = self:GetImage("GrpBg/Img_Nor");
	self.mImg_Icon = self:GetImage("GrpIcon/Img_Icon");
	self.mText_Tittle = self:GetText("GrpText/Text_Tittle");
	self.mText_Progress = self:GetText("GrpText/Text_Progress");
	self.mText_ = self:GetText("GrpText/Text");
	self.mTrans_RedPoint = self:GetRectTransform("Trans_RedPoint");
	self:InstanceUIPrefab("UICommonFramework/ComRedPointItemV2.prefab", self.mTrans_RedPoint, true)
end

--@@ GF Auto Gen Block End

function UIAchievementLeftTabItemV2:InitCtrl(parent)
	local obj = instantiate(UIUtils.GetGizmosPrefab("CommanderInfo/AchievementLeftTabItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIAchievementLeftTabItemV2:SetData(data)
	self.tagId = data.id
	self.tagName = data.tag_name
	self.mData = data
	self.mText_Tittle.text = self.tagName;
	self.mImg_Icon.sprite = IconUtils.GetAchievementIconW(data.icon)
	self:RefreshData()
end

function UIAchievementLeftTabItemV2:RefreshData()
	local rewardId = NetCmdAchieveData:GetCurrentTagRewardId(self.mData.id)
	local rewardNotReceivedId = NetCmdAchieveData:GetCurrentNotReceivedTagRewardId(self.mData.id)
	local nextRewardData = nil
	local count = 0
	local rewardData = nil
	if rewardNotReceivedId == -1 then
		count = NetCmdAchieveData:GetCurrentTagRewardLevelProgress(self.mData);
		rewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId);
		if TableData.listAchievementRewardDatas:ContainsId(rewardId + 1) then
			nextRewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId + 1);
		end
		if nextRewardData ~= nil and nextRewardData.lv_exp > NetCmdItemData:GetResCount(self.mData.point_item) then
			self.mText_Progress.text = string.format("%d", math.floor(math.min(count / (nextRewardData.lv_exp - rewardData.lv_exp), 1) * 100)) .. "%"
		else
			local prevRewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId - 1);
			self.mText_Progress.text = string.format("%d", math.floor(math.min(count / (rewardData.lv_exp - prevRewardData.lv_exp), 1) * 100)) .. "%"
		end
	else
		rewardId = rewardNotReceivedId
		rewardData = TableData.listAchievementRewardDatas:GetDataById(rewardNotReceivedId);
		local prevRewardData = TableData.listAchievementRewardDatas:GetDataById(rewardId - 1);
		count = rewardData.lv_exp - prevRewardData.lv_exp
		self.mText_Progress.text = string.format("%d", math.floor(math.min(count / (rewardData.lv_exp - prevRewardData.lv_exp), 1) * 100)) .. "%"
	end

	setactive(self.mTrans_RedPoint, NetCmdAchieveData:TagRewardCanReceive(self.mData.id) or NetCmdAchieveData:CanReceiveByTagId(self.mData.id))
end

function UIAchievementLeftTabItemV2:SetItemState(isChoose)
	self.isChoose = isChoose
	UIUtils.SetInteractive(self.mUIRoot, not isChoose)
end