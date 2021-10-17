require("UI.UIBaseView")

StoreBuyPanelView = class("StoreBuyPanelView", UIBaseView);
StoreBuyPanelView.__index = StoreBuyPanelView

--@@ GF Auto Gen Block Begin
StoreBuyPanelView.mBtn_TagButton1 = nil;
StoreBuyPanelView.mBtn_TagButton2 = nil;
StoreBuyPanelView.mBtn_TagButton3 = nil;
StoreBuyPanelView.mBtn_TagButton4 = nil;
StoreBuyPanelView.mBtn_TagButton5 = nil;
StoreBuyPanelView.mBtn_TagButton6 = nil;
StoreBuyPanelView.mBtn_TagButton7 = nil;
StoreBuyPanelView.mBtn_TagButton8 = nil;
StoreBuyPanelView.mText_Title = nil;
StoreBuyPanelView.mText_RefreshTime = nil;
StoreBuyPanelView.mText_TagButton1_Tag1 = nil;
StoreBuyPanelView.mText_TagButton1_TagButtonSelected1_Tag1 = nil;
StoreBuyPanelView.mText_TagButton2_Tag2 = nil;
StoreBuyPanelView.mText_TagButton2_TagButtonSelected2_Tag2 = nil;
StoreBuyPanelView.mText_TagButton3_Tag3 = nil;
StoreBuyPanelView.mText_TagButton3_TagButtonSelected3_Tag3 = nil;
StoreBuyPanelView.mText_TagButton4_Tag4 = nil;
StoreBuyPanelView.mText_TagButton4_TagButtonSelected4_Tag4 = nil;
StoreBuyPanelView.mText_TagButton5_Tag5 = nil;
StoreBuyPanelView.mText_TagButton5_TagButtonSelected5_Tag5 = nil;
StoreBuyPanelView.mText_TagButton6_Tag6 = nil;
StoreBuyPanelView.mText_TagButton6_TagButtonSelected6_Tag6 = nil;
StoreBuyPanelView.mText_TagButton7_Tag7 = nil;
StoreBuyPanelView.mText_TagButton7_TagButtonSelected7_Tag7 = nil;
StoreBuyPanelView.mText_TagButton8_Tag8 = nil;
StoreBuyPanelView.mText_TagButton8_TagButtonSelected8_Tag8 = nil;
StoreBuyPanelView.mTrans_TagList = nil;
StoreBuyPanelView.mTrans_TagButton1_TagButtonSelected1 = nil;
StoreBuyPanelView.mTrans_TagButton1_RedPoint = nil;
StoreBuyPanelView.mTrans_TagButton2_TagButtonSelected2 = nil;
StoreBuyPanelView.mTrans_TagButton2_RedPoint = nil;
StoreBuyPanelView.mTrans_TagButton3_TagButtonSelected3 = nil;
StoreBuyPanelView.mTrans_TagButton3_RedPoint = nil;
StoreBuyPanelView.mTrans_TagButton4_TagButtonSelected4 = nil;
StoreBuyPanelView.mTrans_TagButton4_RedPoint = nil;
StoreBuyPanelView.mTrans_TagButton5_TagButtonSelected5 = nil;
StoreBuyPanelView.mTrans_TagButton5_RedPoint = nil;
StoreBuyPanelView.mTrans_TagButton6_TagButtonSelected6 = nil;
StoreBuyPanelView.mTrans_TagButton6_RedPoint = nil;
StoreBuyPanelView.mTrans_TagButton7_TagButtonSelected7 = nil;
StoreBuyPanelView.mTrans_TagButton7_RedPoint = nil;
StoreBuyPanelView.mTrans_TagButton8_TagButtonSelected8 = nil;
StoreBuyPanelView.mTrans_TagButton8_RedPoint = nil;
StoreBuyPanelView.mTrans_GoodsList = nil;
StoreBuyPanelView.mTrans_Big = nil;

function StoreBuyPanelView:__InitCtrl()

	self.mBtn_TagButton1 = self:GetButton("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton1");
	self.mBtn_TagButton2 = self:GetButton("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton2");
	self.mBtn_TagButton3 = self:GetButton("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton3");
	self.mBtn_TagButton4 = self:GetButton("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton4");
	self.mBtn_TagButton5 = self:GetButton("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton5");
	self.mBtn_TagButton6 = self:GetButton("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton6");
	self.mBtn_TagButton7 = self:GetButton("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton7");
	self.mBtn_TagButton8 = self:GetButton("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton8");
	self.mText_Title = self:GetText("Canvas/UIStorePanel//Text_Store_Title");
	self.mText_RefreshTime = self:GetText("Canvas/UIStorePanel//Text_RefreshTime");
	self.mText_TagButton1_Tag1 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton1/Text_Tag1");
	self.mText_TagButton1_TagButtonSelected1_Tag1 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton1/UI_Trans_TagButtonSelected1/Text_Tag1");
	self.mText_TagButton2_Tag2 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton2/Text_Tag2");
	self.mText_TagButton2_TagButtonSelected2_Tag2 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton2/UI_Trans_TagButtonSelected2/Text_Tag2");
	self.mText_TagButton3_Tag3 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton3/Text_Tag3");
	self.mText_TagButton3_TagButtonSelected3_Tag3 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton3/UI_Trans_TagButtonSelected3/Text_Tag3");
	self.mText_TagButton4_Tag4 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton4/Text_Tag4");
	self.mText_TagButton4_TagButtonSelected4_Tag4 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton4/UI_Trans_TagButtonSelected4/Text_Tag4");
	self.mText_TagButton5_Tag5 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton5/Text_Tag5");
	self.mText_TagButton5_TagButtonSelected5_Tag5 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton5/UI_Trans_TagButtonSelected5/Text_Tag5");
	self.mText_TagButton6_Tag6 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton6/Text_Tag6");
	self.mText_TagButton6_TagButtonSelected6_Tag6 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton6/UI_Trans_TagButtonSelected6/Text_Tag6");
	self.mText_TagButton7_Tag7 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton7/Text_Tag7");
	self.mText_TagButton7_TagButtonSelected7_Tag7 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton7/UI_Trans_TagButtonSelected7/Text_Tag7");
	self.mText_TagButton8_Tag8 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton8/Text_Tag8");
	self.mText_TagButton8_TagButtonSelected8_Tag8 = self:GetText("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton8/UI_Trans_TagButtonSelected8/Text_Tag8");
	self.mTrans_TagList = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList");
	self.mTrans_TagButton1_TagButtonSelected1 = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton1/UI_Trans_TagButtonSelected1");
	self.mTrans_TagButton1_RedPoint = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton1/Trans_RedPoint");
	self.mTrans_TagButton2_TagButtonSelected2 = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton2/UI_Trans_TagButtonSelected2");
	self.mTrans_TagButton2_RedPoint = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton2/Trans_RedPoint");
	self.mTrans_TagButton3_TagButtonSelected3 = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton3/UI_Trans_TagButtonSelected3");
	self.mTrans_TagButton3_RedPoint = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton3/Trans_RedPoint");
	self.mTrans_TagButton4_TagButtonSelected4 = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton4/UI_Trans_TagButtonSelected4");
	self.mTrans_TagButton4_RedPoint = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton4/Trans_RedPoint");
	self.mTrans_TagButton5_TagButtonSelected5 = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton5/UI_Trans_TagButtonSelected5");
	self.mTrans_TagButton5_RedPoint = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton5/Trans_RedPoint");
	self.mTrans_TagButton6_TagButtonSelected6 = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton6/UI_Trans_TagButtonSelected6");
	self.mTrans_TagButton6_RedPoint = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton6/Trans_RedPoint");
	self.mTrans_TagButton7_TagButtonSelected7 = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton7/UI_Trans_TagButtonSelected7");
	self.mTrans_TagButton7_RedPoint = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton7/Trans_RedPoint");
	self.mTrans_TagButton8_TagButtonSelected8 = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton8/UI_Trans_TagButtonSelected8");
	self.mTrans_TagButton8_RedPoint = self:GetRectTransform("Canvas/UIStorePanel//StoreTagPanel/Trans_TagList/UI_Btn_TagButton8/Trans_RedPoint");
	self.mTrans_GoodsList = self:GetRectTransform("Canvas/UIStorePanel//Goods/Trans_GoodsList");
	self.mTrans_Big = self:GetRectTransform("Canvas/UIStorePanel//Goods_big/Trans_GoodsList_Big");
end

--@@ GF Auto Gen Block End

function StoreBuyPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end