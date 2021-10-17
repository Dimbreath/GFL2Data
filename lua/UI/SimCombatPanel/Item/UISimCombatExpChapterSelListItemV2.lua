require("UI.UIBaseCtrl")

---@class UISimCombatExpChapterSelListItemV2 : UIBaseCtrl
UISimCombatExpChapterSelListItemV2 = class("UISimCombatExpChapterSelListItemV2", UIBaseCtrl);
UISimCombatExpChapterSelListItemV2.__index = UISimCombatExpChapterSelListItemV2
--@@ GF Auto Gen Block Begin
UISimCombatExpChapterSelListItemV2.mImg_Icon = nil;
UISimCombatExpChapterSelListItemV2.mText_Name = nil;
UISimCombatExpChapterSelListItemV2.mText_1 = nil;
UISimCombatExpChapterSelListItemV2.mText_2 = nil;
UISimCombatExpChapterSelListItemV2.mText_Chapter = nil;
UISimCombatExpChapterSelListItemV2.mTrans_Chapter = nil;
UISimCombatExpChapterSelListItemV2.mTrans_Unlock = nil;
UISimCombatExpChapterSelListItemV2.mTrans_Lock = nil;
UISimCombatExpChapterSelListItemV2.mTrans_On = nil;
UISimCombatExpChapterSelListItemV2.mTrans_On1 = nil;
UISimCombatExpChapterSelListItemV2.mTrans_On2 = nil;
UISimCombatExpChapterSelListItemV2.mImg_Icon = nil;

function UISimCombatExpChapterSelListItemV2:__InitCtrl()

	self.mImg_Icon = self:GetImage("Root/GrpState/Trans_GrpUnlocked/Img_Icon");
	self.mText_Name = self:GetText("Root/GrpTopLeft/Text");
	self.mText_1 = self:GetText("Root/GrpBottomLeft/Text1");
	self.mText_2 = self:GetText("Root/GrpBottomLeft/Text2");
	self.mText_Chapter = self:GetText("Root/GrpSimCombatLine/Trans_Text_Chapter");
	self.mTrans_Chapter = self:GetRectTransform("Root/GrpSimCombatLine/Trans_Text_Chapter");
	self.mTrans_Unlock = self:GetRectTransform("Root/GrpState/Trans_GrpUnlocked");
	self.mTrans_Lock = self:GetRectTransform("Root/GrpState/Trans_GrpLocked");
	self.mTrans_challenge1 = self:GetRectTransform("Root/GrpStage/GrpStage1/Trans_On");
	self.mTrans_challenge2 = self:GetRectTransform("Root/GrpStage/GrpStage2/Trans_On");
	self.mTrans_challenge3 = self:GetRectTransform("Root/GrpStage/GrpStage3/Trans_On");
	self.mImg_Icon = self:GetImage("Root/GrpState/Trans_GrpUnlocked/Img_Icon");

end

--@@ GF Auto Gen Block End

UISimCombatExpChapterSelListItemV2.mData = nil
UISimCombatExpChapterSelListItemV2.stageData = nil
UISimCombatExpChapterSelListItemV2.isUnLock = false

UISimCombatExpChapterSelListItemV2.OrangeColor = Color(246 / 255, 113 / 255, 25 / 255, 255 / 255)
UISimCombatExpChapterSelListItemV2.WhiteColor = Color(1, 1, 1, 0.6)

function UISimCombatExpChapterSelListItemV2:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	self.mBtn_Equip = self:GetSelfButton();
	self.mTrans_Root = self:GetRectTransform("Root")
end

function UISimCombatExpChapterSelListItemV2:SetData(data, typeData, isLastItem)
	if data then
		self.mData = data
		self.recordData = NetCmdStageRecordData:GetStageRecordById(data.stage_id)
		self.stageData = TableData.listStageDatas:GetDataById(data.stage_id)
		self.mImg_Icon.sprite = IconUtils.GetCharacterItemSprite(data.icon)
		self.mText_Chapter.text = data.number
		self.mText_Name.text = typeData.label_name.str
		self.mText_1.text = UIChapterGlobal:GetRandomNum()

		self:UpdateState(false)

		self.isUnLock = self:UpdateLockState()
		setactive(self.mTrans_Lock.gameObject, not self.isUnLock)
		setactive(self.mTrans_Unlock.gameObject, self.isUnLock)

		local isDone = NetCmdSimulateBattleData:CheckStageIsUnLock(self.mData.id)

		self:UpdateChallenge()

		setactive(self.mUIRoot.gameObject, true)
	else
		setactive(self.mUIRoot.gameObject, false)
	end
end

function UISimCombatExpChapterSelListItemV2:UpdateState(isChoose)
	self.mBtn_Equip.interactable = not isChoose
end

function UISimCombatExpChapterSelListItemV2:SetLineColor(isComplete)
	local color = isComplete and UISimCombatExpChapterSelListItemV2.OrangeColor or UISimCombatExpChapterSelListItemV2.WhiteColor
	for _, v in ipairs(self.lineList) do
		v.color = color
	end
end

function UISimCombatExpChapterSelListItemV2:UpdateLockState()
	if self.mData.unlock_stage == nil or self.mData.unlock_stage == 0 then
		return true
	else
		return NetCmdSimulateBattleData:CheckStageIsUnLock(self.mData.unlock_stage)
	end
end

function UISimCombatExpChapterSelListItemV2:UpdateChallenge()
	for i = 1, GlobalConfig.MaxChallenge do
		setactive(self["mTrans_challenge" .. i],  self.recordData ~= nil and self.recordData.complete_challenge.Length >= i)
	end
end
