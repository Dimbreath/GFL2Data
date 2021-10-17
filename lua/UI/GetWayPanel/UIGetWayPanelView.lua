require("UI.UIBaseView")

UIGetWayPanelView = class("UIGetWayPanelView", UIBaseView);
UIGetWayPanelView.__index = UIGetWayPanelView

--@@ GF Auto Gen Block Begin
UIGetWayPanelView.mBtn_BGCloseButton = nil;
UIGetWayPanelView.mBtn_Cancel = nil;
UIGetWayPanelView.mBtn_Jump = nil;
UIGetWayPanelView.mImage_GoodsRate = nil;
UIGetWayPanelView.mImage_IconImage = nil;
UIGetWayPanelView.mText_OwnerNum = nil;
UIGetWayPanelView.mText_ItemName = nil;
UIGetWayPanelView.mText_Title = nil;
UIGetWayPanelView.mText_Way = nil;
UIGetWayPanelView.mTrans_GetWayList = nil;
UIGetWayPanelView.mTrans_Disable = nil;

function UIGetWayPanelView:__InitCtrl()

	self.mBtn_BGCloseButton = self:GetButton("Btn_BGCloseButton");
	self.mBtn_Cancel = self:GetButton("BG/Btn_Cancel");
	self.mBtn_Jump = self:GetButton("GetWayList/Viewport/Trans_GetWayList/UICommonGetWayItem/Btn_Jump");
	self.mImage_GoodsRate = self:GetImage("GoodsView/GoodsIcon/Image_GoodsRate");
	self.mImage_IconImage = self:GetImage("GoodsView/GoodsIcon/Image_IconImage");
	self.mText_OwnerNum = self:GetText("GoodsView/Owner/Text_OwnerNum");
	self.mText_ItemName = self:GetText("Name/Text_ItemName");
	self.mText_Title = self:GetText("GetWayList/Viewport/Trans_GetWayList/UICommonGetWayItem/GetWayname/Text_Title");
	self.mText_Way = self:GetText("GetWayList/Viewport/Trans_GetWayList/UICommonGetWayItem/GetWayname/Text_Way");
	self.mTrans_GetWayList = self:GetRectTransform("GetWayList/Viewport/Trans_GetWayList");
	self.mTrans_Disable = self:GetRectTransform("GetWayList/Viewport/Trans_GetWayList/UICommonGetWayItem/Trans_Disable");

	self.mVirtualList = UIUtils.GetVirtualList(self:GetRectTransform("GetWayList"))
end

--@@ GF Auto Gen Block End

function UIGetWayPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end