require("UI.UIBaseView")

---@class UIMailPanelV2View : UIBaseView
UIMailPanelV2View = class("UIMailPanelV2View", UIBaseView);
UIMailPanelV2View.__index = UIMailPanelV2View

--@@ GF Auto Gen Block Begin
UIMailPanelV2View.mBtn_Left3Item = nil;
UIMailPanelV2View.mBtn_Right3Item = nil;
UIMailPanelV2View.mBtn_PowerUp = nil;
UIMailPanelV2View.mBtn_BackItem = nil;
UIMailPanelV2View.mBtn_HomeItem = nil;
UIMailPanelV2View.mText_LeftName = nil;
UIMailPanelV2View.mText_RightName = nil;
UIMailPanelV2View.mText_Title = nil;
UIMailPanelV2View.mText_MailName = nil;
UIMailPanelV2View.mText_Time = nil;
UIMailPanelV2View.mText_CountDown = nil;
UIMailPanelV2View.mText_Description = nil;
UIMailPanelV2View.mText_PowerUpName = nil;
UIMailPanelV2View.mText_Name = nil;
UIMailPanelV2View.mText_Num = nil;
UIMailPanelV2View.mContent_Material = nil;
UIMailPanelV2View.mContent_Item = nil;
UIMailPanelV2View.mScrollbar_Material = nil;
UIMailPanelV2View.mScrollbar_Mail = nil;
UIMailPanelV2View.mList_Material = nil;
UIMailPanelV2View.mList_Item = nil;
UIMailPanelV2View.mTrans_Mail = nil;
UIMailPanelV2View.mTrans_Line = nil;
UIMailPanelV2View.mTrans_Reward = nil;
UIMailPanelV2View.mTrans_CanReceive = nil;
UIMailPanelV2View.mTrans_UnLocked = nil;
UIMailPanelV2View.mTrans_None = nil;

function UIMailPanelV2View:__InitCtrl()

	self.mBtn_Left3Item = self:GetButton("Root/GrpLeft/GrpAction/BtnLeft/ComBtn3ItemV2");
	self.mBtn_Right3Item = self:GetButton("Root/GrpLeft/GrpAction/BtnRight/ComBtn3ItemV2");
	self.mBtn_PowerUp = self:GetButton("Root/GrpRight/Trans_GrpMailContent/GrpMailContentList/Trans_GrpReward/GrpAction/Trans_CanReceive/Btn_PowerUp");
	self.mText_LeftName = self:GetText("Root/GrpLeft/GrpAction/BtnLeft/ComBtn3ItemV2/Root/GrpText/Text_Name");
	self.mText_RightName = self:GetText("Root/GrpLeft/GrpAction/BtnRight/ComBtn3ItemV2/Root/GrpText/Text_Name");
	self.mText_Title = self:GetText("Root/GrpRight/Trans_GrpMailContent/GrpTextTitle/Text_Title");
	self.mText_MailName = self:GetText("Root/GrpRight/Trans_GrpMailContent/GrpTextSender/Text_Name");
	self.mText_Time = self:GetText("Root/GrpRight/Trans_GrpMailContent/GrpTextSender/Text_Time");
	self.mText_CountDown = self:GetText("Root/GrpRight/Trans_GrpMailContent/GrpTextSender/Text_CountDown");
	self.mText_Description = self:GetText("Root/GrpRight/Trans_GrpMailContent/GrpMailContentList/GrpActivationNode/Viewport/Content/Text_Description");
	self.mText_PowerUpName = self:GetText("Root/GrpRight/Trans_GrpMailContent/GrpMailContentList/Trans_GrpReward/GrpAction/Trans_CanReceive/Btn_PowerUp/Root/GrpText/Text_Name");
	self.mText_Name = self:GetText("Root/GrpRight/Trans_GrpMailContent/GrpMailContentList/Trans_GrpReward/GrpAction/Trans_UnLocked/Text_Name");
	self.mText_Num = self:GetText("Root/GrpTop/GrpText/Text_Num");
	self.mContent_Material = self:GetGridLayoutGroup("Root/GrpLeft/GrpMaterialList/Viewport/Content");
	self.mContent_Item = self:GetGridLayoutGroup("Root/GrpRight/Trans_GrpMailContent/GrpMailContentList/Trans_GrpReward/GrpItemList/Viewport/Content");
	self.mScrollbar_Material = self:GetScrollbar("Root/GrpLeft/GrpMaterialList/Scrollbar");
	self.mScrollbar_Mail = self:GetScrollbar("Root/GrpRight/Trans_GrpMailContent/GrpMailContentList/GrpActivationNode/Viewport/Scrollbar");
	self.mList_Material = self:GetScrollRect("Root/GrpLeft/GrpMaterialList");
	self.mList_Item = self:GetScrollRect("Root/GrpRight/Trans_GrpMailContent/GrpMailContentList/Trans_GrpReward/GrpItemList");
	self.mTrans_Mail = self:GetRectTransform("Root/GrpRight/Trans_GrpMailContent");
	self.mTrans_Line = self:GetRectTransform("Root/GrpRight/Trans_GrpMailContent/Trans_GrpLine");
	self.mTrans_Reward = self:GetRectTransform("Root/GrpRight/Trans_GrpMailContent/GrpMailContentList/Trans_GrpReward");
	self.mTrans_CanReceive = self:GetRectTransform("Root/GrpRight/Trans_GrpMailContent/GrpMailContentList/Trans_GrpReward/GrpAction/Trans_CanReceive");
	self.mTrans_UnLocked = self:GetRectTransform("Root/GrpRight/Trans_GrpMailContent/GrpMailContentList/Trans_GrpReward/GrpAction/Trans_UnLocked");
	self.mTrans_None = self:GetRectTransform("Root/GrpRight/Trans_GrpNone");
end

--@@ GF Auto Gen Block End

function UIMailPanelV2View:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mAnimator = self:GetComponent("Root", typeof(CS.UnityEngine.Animator))
	self.mVirtualList = UIUtils.GetVirtualList(self.mList_Item.transform)
end