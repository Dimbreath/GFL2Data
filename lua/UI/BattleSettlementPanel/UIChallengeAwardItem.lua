require("UI.UIBaseCtrl")

UIChallengeAwardItem = class("UIChallengeAwardItem", UIBaseCtrl);
UIChallengeAwardItem.__index = UIChallengeAwardItem
UIChallengeAwardItem.mTween = nil;
UIChallengeAwardItem.isOver = false;
--@@ GF Auto Gen Block Begin
UIChallengeAwardItem.mImage_AwardItem_AwardQualityImage = nil;
UIChallengeAwardItem.mImage_AwardItem_AwardIconImage = nil;
UIChallengeAwardItem.mText_1 = nil;
UIChallengeAwardItem.mText_2 = nil;
UIChallengeAwardItem.mText_ChallengeName = nil;
UIChallengeAwardItem.mText_ChallengeDescription = nil;
UIChallengeAwardItem.mText_AwardItem_AwardNumber = nil;
UIChallengeAwardItem.mCanvasG_Complete = nil;

function UIChallengeAwardItem:__InitCtrl()

	self.mImage_AwardItem_AwardQualityImage = self:GetImage("UI_AwardItem/Image_AwardQualityImage");
	self.mImage_AwardItem_AwardIconImage = self:GetImage("UI_AwardItem/Image_AwardQualityImage/Image_AwardIconImage");
	self.mText_1 = self:GetText("IncompleteBG/Text_Number_1");
	self.mText_2 = self:GetText("CanvasG_Complete/Text_Number_2");
	self.mText_ChallengeName = self:GetText("Text_ChallengeName");
	self.mText_ChallengeDescription = self:GetText("Text_ChallengeDescription");
	self.mText_AwardItem_AwardNumber = self:GetText("UI_AwardItem/Image_AwardQualityImage/Text_AwardNumber");
	self.mCanvasG_Complete = self:GetCanvasGroup("CanvasG_Complete");
end

--@@ GF Auto Gen Block End

function UIChallengeAwardItem:InitCtrl(root,index)

	self:SetRoot(root);

	self:__InitCtrl();
	self.mTween = getcomponent(self.mCanvasG_Complete.gameObject,typeof(CS.TweenFade));
	self.mText_1.text = string.format("0%d.",index);
	self.mText_2.text = string.format("0%d.",index);
end

function UIChallengeAwardItem:SetComplete(delay)
	if self.mCompleteStatus == 1 then
		self.mTween.delay = delay;
		self.mTween:Play();
		return true;
	end
	return false;
end

function UIChallengeAwardItem:FinishTweener()
	if self.mTween ~= nil and self.mCompleteStatus == 1 then
		self.mTween:Play();
		self.mTween:Goto(1);
		self.mTween = nil;
		self.mCompleteStatus = 2;
	end
end

function UIChallengeAwardItem:InitData(id,completeStatus)
	print(id .. "  "..completeStatus);
	self.mCompleteStatus = completeStatus;
	local challengeData = TableData.GetStageChallengeData(id);
	self.mText_ChallengeName.text = challengeData.title.str;
	self.mText_ChallengeDescription.text = challengeData.description.str;
	-- local reward = string.split(challengeData.reward,":");
	for itemId, num in pairs(challengeData.reward) do
		local itemData = TableData.GetItemData(itemId);
		self.mText_AwardItem_AwardNumber.text = "x" .. num;
		self.mImage_AwardItem_AwardIconImage.sprite = CS.IconUtils.GetItemIconSprite(itemId);
		self.mImage_AwardItem_AwardQualityImage.sprite = UIUtils.GetIconSprite("CommonRes/Res",RankFrame[itemData.rank]);
		if self.mCompleteStatus == 2 then
			self.mCanvasG_Complete.alpha = 1;
		else
			self.mCanvasG_Complete.alpha = 0;
		end
	end

end