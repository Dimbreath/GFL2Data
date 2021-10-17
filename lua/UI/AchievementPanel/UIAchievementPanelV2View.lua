require("UI.UIBaseView")

---@class UIAchievementPanelV2View : UIBaseView
UIAchievementPanelV2View = class("UIAchievementPanelV2View", UIBaseView);
UIAchievementPanelV2View.__index = UIAchievementPanelV2View

--@@ GF Auto Gen Block Begin
UIAchievementPanelV2View.mImg_Icon = nil;
UIAchievementPanelV2View.mImg_ProgressBar = nil;
UIAchievementPanelV2View.mText_Num = nil;
UIAchievementPanelV2View.mText_Tittle = nil;
UIAchievementPanelV2View.mText_Content = nil;
UIAchievementPanelV2View.mText_ProgressNum = nil;
UIAchievementPanelV2View.mText_Name = nil;
UIAchievementPanelV2View.mText_Completed = nil;
UIAchievementPanelV2View.mText_Name1 = nil;
UIAchievementPanelV2View.mText_UnCompleted = nil;
UIAchievementPanelV2View.mText_TextCompleted = nil;
UIAchievementPanelV2View.mText_TextUnCompleted = nil;
UIAchievementPanelV2View.mContent_Material = nil;
UIAchievementPanelV2View.mContent_All = nil;
UIAchievementPanelV2View.mContent_Achievement = nil;
UIAchievementPanelV2View.mScrollbar_Material = nil;
UIAchievementPanelV2View.mScrollbar_Achievement = nil;
UIAchievementPanelV2View.mList_Material = nil;
UIAchievementPanelV2View.mList_Achievement = nil;
UIAchievementPanelV2View.mTrans_Receive = nil;
UIAchievementPanelV2View.mTrans_TextCompleted = nil;
UIAchievementPanelV2View.mTrans_TextUnCompleted = nil;

function UIAchievementPanelV2View:__InitCtrl()
	self.mBtn_Back = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"));
	self.mBtn_Home = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"));

	self.mImg_Icon = self:GetImage("Root/GrpRight/GrpAchievementAll/GrpIcon/Img_Icon");
	self.mImg_ProgressBar = self:GetImage("Root/GrpRight/GrpAchievementAll/GrpCenterText/GrpProgressBar/Img_ProgressBar");
	self.mText_Num = self:GetText("Root/GrpTop/GrpAchievementPoint/GrpPoint/Text_Num");
	self.mText_Tittle = self:GetText("Root/GrpRight/GrpAchievementAll/GrpCenterText/Text_Tittle");
	self.mText_Content = self:GetText("Root/GrpRight/GrpAchievementAll/GrpCenterText/Text_Content");
	self.mText_ProgressNum = self:GetText("Root/GrpRight/GrpAchievementAll/GrpCenterText/Text_ProgressNum");
	self.mText_Name = self:GetText("Root/GrpRight/GrpAchievementAll/GrpState/GrpTextCompleted/TextName");
	self.mText_Completed = self:GetText("Root/GrpRight/GrpAchievementAll/GrpState/GrpTextCompleted/Text");
	self.mText_Name1 = self:GetText("Root/GrpRight/GrpAchievementAll/GrpState/GrpTextUnCompleted/TextName");
	self.mText_UnCompleted = self:GetText("Root/GrpRight/GrpAchievementAll/GrpState/GrpTextUnCompleted/Text");
	self.mText_TextCompleted = self:GetText("Root/GrpRight/GrpBottom/GrpAction/Trans_TextCompleted/Text");
	self.mText_TextUnCompleted = self:GetText("Root/GrpRight/GrpBottom/GrpAction/Trans_TextUnCompleted/Text");
	self.mContent_Material = self:GetGridLayoutGroup("Root/GrpLeft/GrpMaterialList/Viewport/Content");
	self.mContent_All = self:GetGridLayoutGroup("Root/GrpRight/GrpAchievementAll/GrpItem/Content");
	self.mTrans_Achievement = self:GetRectTransform("Root/GrpRight/GrpAchievementList/Viewport/Content");
	self.mScrollbar_Material = self:GetScrollbar("Root/GrpLeft/GrpMaterialList/Scrollbar");
	self.mScrollbar_Achievement = self:GetScrollbar("Root/GrpRight/GrpAchievementList/Scrollbar");
	self.mList_Material = self:GetScrollRect("Root/GrpLeft/GrpMaterialList");
	self.mVirtualList_Achievement = UIUtils.GetVirtualListEx(self:GetRectTransform("Root/GrpRight/GrpAchievementList"));
	self.mTrans_Receive = self:GetRectTransform("Root/GrpRight/GrpBottom/GrpAction/Trans_BtnReceive");
	self.mTrans_TextCompleted = self:GetRectTransform("Root/GrpRight/GrpBottom/GrpAction/Trans_TextCompleted");
	self.mTrans_TextUnCompleted = self:GetRectTransform("Root/GrpRight/GrpBottom/GrpAction/Trans_TextUnCompleted");

	self.mBtn_GetAll = UIUtils.GetTempBtn(self.mTrans_Receive);
end

--@@ GF Auto Gen Block End

function UIAchievementPanelV2View:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	self.mTrans_CompletedAll = self:GetRectTransform("Root/GrpRight/GrpAchievementAll/GrpState/GrpTextCompleted")
	self.mTrans_UnCompletedAll = self:GetRectTransform("Root/GrpRight/GrpAchievementAll/GrpState/GrpTextUnCompleted")
	self.mTrans_BtnPick = self:GetRectTransform("Root/GrpRight/GrpAchievementAll/GrpState/BtnPick")
	local pickObj = instantiate(UIUtils.GetGizmosPrefab("CommanderInfo/AchievementBtnPickItemV2.prefab", self))
	CS.LuaUIUtils.SetParent(pickObj, self.mTrans_BtnPick.gameObject, false)
	self.mBtn_CompleteQuest = CS.LuaUIUtils.GetButton(pickObj.transform)
	self.mText_CompleteQuest = UIUtils.GetText(self.mBtn_CompleteQuest, "Root/GrpText/TextName")
end