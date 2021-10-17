require("UI.UIBaseCtrl")

UISimCombatItem = class("UISimCombatItem", UIBaseCtrl);
UISimCombatItem.__index = UISimCombatItem
--@@ GF Auto Gen Block Begin
UISimCombatItem.mImage_SimCombat_IconImage = nil;
--UISimCombatItem.mImage_SimCombat_FrameImage = nil;
UISimCombatItem.mImage_SimCombat_SimCombatAward_SimCombatAwardIcon = nil;
--UISimCombatItem.mImage_SimCombatUnOpen_IconImage = nil;
--UISimCombatItem.mImage_SimCombatUnOpen_FrameImage = nil;
UISimCombatItem.mText_SimCombat_SimCombatName = nil;
UISimCombatItem.mText_SimCombat_TitleText = nil;
--UISimCombatItem.mText_SimCombat_SimCombatInfo = nil;
UISimCombatItem.mText_SimCombatName = nil;
--UISimCombatItem.mTrans_SimCombat_Title = nil;
UISimCombatItem.mTrans_SimCombat_SimCombatNewbg = nil;
UISimCombatItem.mTrans_SimCombat_LockMask = nil;
UISimCombatItem.mTrans_OpenTime = nil;

UISimCombatItem.mType = nil

function UISimCombatItem:__InitCtrl()

	self.mImage_SimCombat_IconImage = self:GetImage("GrpContent/GrpBgScene/Img_Bg");
	--self.mImage_SimCombat_FrameImage = self:GetImage("UI_SimCombat/Image_FrameImage");
	--self.mImage_SimCombat_SimCombatAward_SimCombatAwardIcon = self:GetImage("UI_SimCombat/UI_SimCombatAward/Image_SimCombatAwardIcon");
	--self.mImage_SimCombatUnOpen_IconImage = self:GetImage("UI_SimCombatUnOpen/Image_IconImage");
	--self.mImage_SimCombatUnOpen_FrameImage = self:GetImage("UI_SimCombatUnOpen/Image_FrameImage");
	self.mText_SimCombat_SimCombatName = self:GetText("GrpContent/GrpText/Text_Name");
	--self.mText_SimCombat_SimCombatInfo = self:GetText("UI_SimCombat/Text_SimCombatInfo");
	self.mText_SimCombatName = self:GetText("GrpContent/OpenTime/Text");
	--self.mTrans_SimCombat_Title = self:GetRectTransform("UI_SimCombat/Trans_Title");
	self.mTrans_SimCombat_LockMask = self:GetRectTransform("GrpContent/GrpState/Trans_GrpLocked");
	self.mTrans_OpenTime = self:GetRectTransform("GrpContent/OpenTime");
	self.mTrans_SimCombat = self:GetSelfRectTransform()
	--self.mTrans_SimCombatAward = self:GetRectTransform("UI_SimCombat/UI_SimCombatAward")
	--self.mTrans_SimCombatUnOpen = self:GetRectTransform("UI_SimCombat/Trans_SimCombatUnOpen")
	self.mTrans_RedPoint = self:GetRectTransform("GrpContent/GrpState/Trans_GrpRedPoint")
end

--@@ GF Auto Gen Block End

function UISimCombatItem:InitCtrl(parent)

	local instObj = instantiate(UIUtils.GetGizmosPrefab("BattleIndex/SimCombatChapterItemV2.prefab",self));
	CS.LuaUIUtils.SetParent(instObj.gameObject, parent.gameObject)

	self:SetRoot(instObj.transform)
	self:__InitCtrl()
end

function UISimCombatItem:SetData(data)
	if data then
		self:SetSimCombatType(data.id)

		self.mImage_SimCombat_IconImage.sprite = IconUtils.GetStageIcon(data.image)
		self.mText_SimCombat_SimCombatName.text = data.name.str
		--self.mText_SimCombat_SimCombatInfo.text = data.award_name.str
		--self.mImage_SimCombat_SimCombatAward_SimCombatAwardIcon.sprite = IconUtils.GetItemSprite(data.award_icon)
		self.mText_SimCombatName.text = data.open_time.str

		self:CheckSimCombatIsUnLock()
		--setactive(self.mTrans_RedPoint.gameObject, self:CheckSimCombatIsNew())

		self:CheckIsNoComplete(data.nocomplete)
		setactive(self.mUIRoot.gameObject, true)

		self:UpdateRedPoint();

		UIUtils.ForceRebuildLayout(self.mTrans_OpenTime)
	else
		setactive(self.mUIRoot.gameObject, false)
	end
end

function UISimCombatItem:CheckIsNoComplete(noComplete)
	--setactive(self.mTrans_SimCombat_Title.gameObject, noComplete ~= 1)
	--setactive(self.mText_SimCombat_SimCombatInfo.gameObject, noComplete ~= 1)
	--setactive(self.mTrans_SimCombatAward.gameObject, noComplete ~= 1)
	setactive(self.mTrans_OpenTime.gameObject, noComplete ~= 1)
	--setactive(self.mTrans_SimCombatUnOpen.gameObject, noComplete == 1)
end

function UISimCombatItem:CheckSimCombatIsUnLock()
	local isLock = AccountNetCmdHandler:CheckSystemIsUnLock(self.mType)
	setactive(self.mTrans_SimCombat_LockMask, not isLock)
end

function UISimCombatItem:UpdateRedPoint()
	
	if(self.mType == CS.GF2.Data.SystemList.BattleSimTutorial) then
		local b = NetCmdSimulateBattleData:CheckTeachingRewardRedPoint() or NetCmdSimulateBattleData:CheckTeachingUnlockRedPoint();
		setactive(self.mTrans_RedPoint, b)
	end
end

function UISimCombatItem:SetSimCombatType(simType)
	if simType == 1 then
		self.mType = CS.GF2.Data.SystemList.BattleSimEquip
	elseif simType == 2 then
		self.mType = CS.GF2.Data.SystemList.BattleSimCircuit
	elseif simType == 3 then
		self.mType = CS.GF2.Data.SystemList.BattleSimTraining
	elseif simType == 4 then
		self.mType = CS.GF2.Data.SystemList.BattleSimWeekly
	elseif simType == 5 then
		self.mType = CS.GF2.Data.SystemList.BattleSimMythic
	elseif simType == 6 then
		self.mType = CS.GF2.Data.SystemList.BattleSimCash
	elseif simType == 7 then
		self.mType = CS.GF2.Data.SystemList.BattleSimExp
	elseif simType == 8 then
		self.mType = CS.GF2.Data.SystemList.BattleSimTutorial
	else
		self.mType = CS.GF2.Data.SystemList.None
	end
end

function UISimCombatItem:CheckSimCombatIsNew()
	return false
end