require("UI.UIBaseCtrl")

UIArchivesCampInfoEnteranceItem = class("UIArchivesCampInfoEnteranceItem", UIBaseCtrl);
UIArchivesCampInfoEnteranceItem.__index = UIArchivesCampInfoEnteranceItem
--@@ GF Auto Gen Block Begin
UIArchivesCampInfoEnteranceItem.mBtn_OpenDetail = nil;
UIArchivesCampInfoEnteranceItem.mImage_CampIcon = nil;
UIArchivesCampInfoEnteranceItem.mText_CampCurrency = nil;
UIArchivesCampInfoEnteranceItem.mText_UnlockInfo = nil;
UIArchivesCampInfoEnteranceItem.mTrans_Choose = nil;

function UIArchivesCampInfoEnteranceItem:__InitCtrl()

	self.mBtn_OpenDetail = self:GetButton("Btn_OpenDetail");
	self.mImage_CampIcon = self:GetImage("Image_CampIcon");
	self.mText_CampCurrency = self:GetText("CamInfoPanel/Text_CampCurrency");
	self.mText_UnlockInfo = self:GetText("CamInfoPanel/Text_UnlockInfo");
	self.mTrans_Choose = self:GetRectTransform("Trans_Choose");
end

--@@ GF Auto Gen Block End

function UIArchivesCampInfoEnteranceItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end