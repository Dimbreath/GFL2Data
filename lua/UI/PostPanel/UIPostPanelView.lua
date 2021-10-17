require("UI.UIBaseView")

UIPostPanelView = class("UIPostPanelView", UIBaseView);
UIPostPanelView.__index = UIPostPanelView

--@@ GF Auto Gen Block Begin
UIPostPanelView.mBtn_ActivityPost = nil;
UIPostPanelView.mBtn_GamePost = nil;
UIPostPanelView.mBtn_Return = nil;
UIPostPanelView.mTrans_ActivityPost_Chosen = nil;
UIPostPanelView.mTrans_ActivityPost_Unchosen = nil;
UIPostPanelView.mTrans_GamePost_Chosen = nil;
UIPostPanelView.mTrans_GamePost_Unchosen = nil;
UIPostPanelView.mTrans_Triangle = nil;
UIPostPanelView.mTrans_ContentLayout = nil;
UIPostPanelView.mTrans_PostList = nil;
UIPostPanelView.animator = nil

function UIPostPanelView:__InitCtrl()

	self.mBtn_ActivityPost = self:GetButton("Post/PostPanel/UI_Btn_ActivityPost");
	self.mBtn_GamePost = self:GetButton("Post/PostPanel/UI_Btn_GamePost");
	self.mBtn_Return = self:GetButton("Post/Btn_Return");
	self.mTrans_ActivityPost_Chosen = self:GetRectTransform("Post/PostPanel/UI_Btn_ActivityPost/Trans_Chosen");
	self.mTrans_ActivityPost_Unchosen = self:GetRectTransform("Post/PostPanel/UI_Btn_ActivityPost/Trans_Unchosen");
	self.mTrans_GamePost_Chosen = self:GetRectTransform("Post/PostPanel/UI_Btn_GamePost/Trans_Chosen");
	self.mTrans_GamePost_Unchosen = self:GetRectTransform("Post/PostPanel/UI_Btn_GamePost/Trans_Unchosen");
	self.mTrans_Triangle = self:GetRectTransform("Post/PostPanel/PostListPanel/Trans_Triangle");
	self.mTrans_ContentLayout = self:GetRectTransform("Post/PostPanel/MainText/PostDetailPanel/ContentPanel/Mask/Trans_ContentLayout");
	self.mTrans_PostList = self:GetRectTransform("Post/PostPanel/PostListPanel/PostList/Trans_PostList");
	self.mContentScrollView = self:GetScrollRect("Post/PostPanel/MainText/PostDetailPanel")

	self.animator = self.mUIRoot.gameObject:GetComponent("Animator")
end

--@@ GF Auto Gen Block End

UIPostPanelView.mScrollView = nil;
--UIPostPanelView.mArrow = nil;

function UIPostPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mScrollView = self:GetScrollRect("Post/PostPanel/PostListPanel/PostList");
	--self.mArrow = self:GetImage("Post/PostPanel/MainText/Image (8)");
end