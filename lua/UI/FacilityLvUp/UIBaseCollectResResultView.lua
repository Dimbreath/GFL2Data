require("UI.UIBaseView")

UIBaseCollectResResultView = class("UIBaseCollectResResultView", UIBaseView);
UIBaseCollectResResultView.__index = UIBaseCollectResResultView

--@@ GF Auto Gen Block Begin
UIBaseCollectResResultView.mBtn_ComfirmBtn = nil;
UIBaseCollectResResultView.mTrans_Massage_BaseCollectResItemList = nil;

function UIBaseCollectResResultView:__InitCtrl()

	self.mBtn_ComfirmBtn = self:GetButton("MessagePanel/BtnPanel/Btn_ComfirmBtn");
	self.mTrans_Massage_BaseCollectResItemList = self:GetRectTransform("MessagePanel/Background/UI_Massage/Trans_BaseCollectResItemList");
end

--@@ GF Auto Gen Block End

function UIBaseCollectResResultView:InitCtrl(root)
	self:SetRoot(root);
	self:__InitCtrl();


end