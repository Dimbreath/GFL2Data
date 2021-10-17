require("UI.UIBaseCtrl")

UISettlementAwardItem = class("UISettlementAwardItem", UIBaseCtrl);
UISettlementAwardItem.__index = UISettlementAwardItem
--@@ GF Auto Gen Block Begin
UISettlementAwardItem.mImage_AwardQualityImage = nil;
UISettlementAwardItem.mImage_AwardIconImage = nil;
UISettlementAwardItem.mText_AwardNumber = nil;
UISettlementAwardItem.mTrans_ChallengeAwardText = nil;
UISettlementAwardItem.mTrans_DropAwardText = nil;

function UISettlementAwardItem:__InitCtrl()

	self.mImage_AwardQualityImage = self:GetImage("Image_AwardQualityImage");
	self.mImage_AwardIconImage = self:GetImage("Image_AwardQualityImage/Image_AwardIconImage");
	self.mText_AwardNumber = self:GetText("Image_AwardQualityImage/Text_AwardNumber");
	self.mTrans_ChallengeAwardText = self:GetRectTransform("Image_AwardQualityImage/Trans_ChallengeAwardText");
	self.mTrans_DropAwardText = self:GetRectTransform("Image_AwardQualityImage/Trans_DropAwardText");
end

--@@ GF Auto Gen Block End

function UISettlementAwardItem:InitCtrl(root,type)

	self:SetRoot(root);

	self:__InitCtrl();
	setactive(self.mTrans_ChallengeAwardText.gameObject, type == 1);
	setactive(self.mTrans_DropAwardText.gameObject, type == 2);
end


function UISettlementAwardItem:InitData(id,num, needGetWay)
	needGetWay = needGetWay == true and true or false
	local itemData = TableData.GetItemData(id);
	self.mImage_AwardIconImage.sprite = CS.IconUtils.GetItemIconSprite(id);
	self.mImage_AwardQualityImage.sprite = UIUtils.GetIconSprite("CommonRes/Res",RankFrame[itemData.rank]);
	self.mText_AwardNumber.text = num;

	TipsManager.Add(self.mImage_AwardIconImage.gameObject, itemData, num, needGetWay);
end