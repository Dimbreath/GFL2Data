require("UI.UIBaseView")

---@class UIPostPanelV2View : UIBaseView
UIPostPanelV2View = class("UIPostPanelV2View", UIBaseView);
UIPostPanelV2View.__index = UIPostPanelV2View

--@@ GF Auto Gen Block Begin
UIPostPanelV2View.mBtn_Bg_Close = nil;
UIPostPanelV2View.mBtn_Close = nil;
UIPostPanelV2View.mScrBar_PostListScrBar = nil;
UIPostPanelV2View.mScrBar_ContentListScrBar = nil;
UIPostPanelV2View.mVLayout_Content = nil;
UIPostPanelV2View.mScrRect_PostList = nil;
UIPostPanelV2View.mScrRect_ContentList = nil;
UIPostPanelV2View.mTrans_TabList = nil;
UIPostPanelV2View.mTrans_PostList = nil;
UIPostPanelV2View.mTrans_Content = nil;
UIPostPanelV2View.animator = nil

function UIPostPanelV2View:__InitCtrl()

	self.mBtn_Bg_Close = self:GetButton("Root/GrpBg/Btn_Close");
	self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close");
	self.mScrBar_PostListScrBar = self:GetScrollbar("Root/GrpDialog/GrpCenter/GrpLeft/GrpLeftTabItemList/Scrollbar");
	self.mScrBar_ContentListScrBar = self:GetScrollbar("Root/GrpDialog/GrpCenter/GrpRight/GrpContentList/Scrollbar");
	self.mScrRect_PostList = self:GetScrollRect("Root/GrpDialog/GrpCenter/GrpLeft/GrpLeftTabItemList");
	self.mScrRect_ContentList = self:GetScrollRect("Root/GrpDialog/GrpCenter/GrpRight/GrpContentList");
	self.mVLayout_Content = self:GetVerticalLayoutGroup("Root/GrpDialog/GrpCenter/GrpRight/GrpContentList/Viewport/Content");
	self.mTrans_TabList = self:GetRectTransform("Root/GrpDialog/GrpTop/GrpTabList/GrpTopTabItem");
	self.mTrans_PostList = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpLeft/GrpLeftTabItemList/Viewport/Content");
	self.mTrans_Content = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpRight/GrpContentList/Viewport/Content");

end

--@@ GF Auto Gen Block End

function UIPostPanelV2View:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.animator = self:GetComponent("Root", typeof(CS.UnityEngine.Animator))

end