require("UI.UIBaseView")

UIDailyQuestPanelView = class("UIDailyQuestPanelView", UIBaseView);
UIDailyQuestPanelView.__index = UIDailyQuestPanelView

--@@ GF Auto Gen Block Begin
UIDailyQuestPanelView.mBtn_DailyQuestPanel_ReceiveAll = nil;
--UIDailyQuestPanelView.mBtn_Receive = nil;
UIDailyQuestPanelView.mBtn_Close = nil;
UIDailyQuestPanelView.mBtn_CommandCenter = nil;
UIDailyQuestPanelView.mText_DailyQuestPanel_PointDetail = nil;
--UIDailyQuestPanelView.mText_Progress = nil;
UIDailyQuestPanelView.mLayout_ListPanel = nil;
UIDailyQuestPanelView.mVLayout_TypeList = nil;
UIDailyQuestPanelView.mVLayout_DailyQuestPanel_QuestList = nil;
UIDailyQuestPanelView.mHLayout_DailyQuestPanel_RewardLayout = nil;
--UIDailyQuestPanelView.mHLayout_TabBanner = nil;
--UIDailyQuestPanelView.mHLayout_QuestList = nil;
UIDailyQuestPanelView.mTrans_DailyQuestPanel = nil;
UIDailyQuestPanelView.mTrans_DailyQuestPanel_Can = nil;
UIDailyQuestPanelView.mTrans_DailyQuestPanel_Cant = nil;
UIDailyQuestPanelView.mTrans_DailyQuestPanel_Fin = nil;
UIDailyQuestPanelView.mTrans_NewbieTaskPanel = nil;
UIDailyQuestPanelView.mTrans_Can = nil;
UIDailyQuestPanelView.mTrans_Cant = nil;
UIDailyQuestPanelView.mTrans_Fin = nil;
UIDailyQuestPanelView.mTrans_CommonNode = nil;
UIDailyQuestPanelView.mAnimator = nil;

function UIDailyQuestPanelView:__InitCtrl()

	self.mBtn_DailyQuestPanel_ReceiveAll = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpRight/Trans_GrpDailyQuest/GrpBottom/GrpAction/Trans_BtnReceive"));
	--self.mBtn_Receive = self:GetButton("Trans_NewbieTaskPanel/BottomPanel/Btn_Receive");
	self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"));
	self.mBtn_CommandCenter = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"));
	self.mText_DailyQuestPanel_PointDetail = self:GetText("Root/GrpRight/Trans_GrpDailyQuest/GrpBottom/GrpText/GrpTextNum/Text_Num");
	self.mText_DailyQuestPanel_PointDetailAll = self:GetText("Root/GrpRight/Trans_GrpDailyQuest/GrpBottom/GrpText/GrpTextNum/Text_NumAll");
	--self.mText_Progress = self:GetText("Trans_NewbieTaskPanel/BottomPanel/ProgressPanel/Text_Progress");
	self.mLayout_ListPanel = self:GetGridLayoutGroup("Trans_NewbieTaskPanel/BottomPanel/RewardShow/Layout_ListPanel");
	self.mVLayout_TypeList = self:GetVerticalLayoutGroup("Root/GrpLeft/Content/GrpTabList/Viewport/Content");
	self.mVLayout_DailyQuestPanel_QuestList = self:GetRectTransform("Root/GrpRight/Trans_GrpDailyQuest/GrpQuestList/Viewport/Content");
	self.mHLayout_DailyQuestPanel_RewardLayout = self:GetHorizontalLayoutGroup("Root/GrpRight/Trans_GrpDailyQuest/GrpBottom/GrpReward/GrpItem");
	--self.mHLayout_TabBanner = self:GetHorizontalLayoutGroup("Trans_NewbieTaskPanel/HLayout_TabBanner");
	--self.mHLayout_QuestList = self:GetHorizontalLayoutGroup("Trans_NewbieTaskPanel/ListPanel/QuestList/HLayout_QuestList");
	self.mTrans_DailyQuestPanel = self:GetRectTransform("Root/GrpRight/Trans_GrpDailyQuest");
	self.mTrans_DailyQuestPanel_Can = self:GetRectTransform("Root/GrpRight/Trans_GrpDailyQuest/GrpBottom/GrpAction/Trans_BtnReceive");
	self.mTrans_DailyQuestPanel_Cant = self:GetRectTransform("UI_Trans_DailyQuestPanel/ActiveReward/Btn_ReceiveAll/Trans_Cant");
	self.mTrans_DailyQuestPanel_Fin = self:GetRectTransform("Root/GrpRight/Trans_GrpDailyQuest/GrpBottom/GrpAction/Trans_TextCompleted");

	self.mTrans_NewbieTaskPanel = self:GetRectTransform("Root/GrpRight/Trans_GrpRookieQuest");
	self.mTrans_NewbieTaskTabList = self:GetRectTransform("Root/GrpRight/Trans_GrpRookieQuest/GrpTopTab")
	self.mTrans_NewbieTaskItemList = self:GetRectTransform("Root/GrpRight/Trans_GrpRookieQuest/GrpRookieQuestList/Viewport/Content") 
	self.mImage_NewbieProgress = self:GetImage("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted/GrpCenterBar/GrpProgressBar/Img_ProgressBar")
	self.mText_NewbieProgressNum = self:GetText("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted/GrpCenterBar/GrpTextNum/Text_Num")
	self.mText_NewbieProgressNumAll = self:GetText("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted/GrpCenterBar/GrpTextNum/Text_NumAll")
	self.mTrans_Can = self:GetRectTransform("Trans_NewbieTaskPanel/BottomPanel/Btn_Receive/Trans_Can");
	self.mTrans_Cant = self:GetRectTransform("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted");
	self.mTrans_Fin = self:GetRectTransform("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Completed");

	self.mTrans_RewardItem1 = self:GetRectTransform("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted/GrpLeftItem/GrpItem/GrpItem1");
	self.mTrans_RewardItem2 = self:GetRectTransform("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted/GrpLeftItem/GrpItem/GrpItem2");
	self.mTrans_RewardItem3 = self:GetRectTransform("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted/GrpLeftItem/GrpItem/GrpItem3");
	self.mAnimator = self:GetAnimator("Root");
	-- self.mBtn_RewardItem1 = self:GetButton("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted/GrpLeftItem/GrpItem/GrpItem1/Btn_Item");
	-- self.mBtn_RewardItem2 = self:GetButton("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted/GrpLeftItem/GrpItem/GrpItem2/Btn_Item");
	-- self.mBtn_RewardItem3 = self:GetButton("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted/GrpLeftItem/GrpItem/GrpItem3/Btn_Item");

	-- local obj1 = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab"))
	-- local obj2 = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab"))
	-- local obj3 = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab"))

	-- CS.LuaUIUtils.SetParent(obj1.gameObject, self.mTrans_RewardItem1.gameObject, true)
	-- CS.LuaUIUtils.SetParent(obj2.gameObject, self.mTrans_RewardItem2.gameObject, true)
	-- CS.LuaUIUtils.SetParent(obj3.gameObject, self.mTrans_RewardItem3.gameObject, true)


	-- self.mBtn_RewardItem1 = obj1:GetComponent("GFButton")
	-- self.mBtn_RewardItem2 = obj2:GetComponent("GFButton")
	-- self.mBtn_RewardItem3 = obj3:GetComponent("GFButton")


	-- self.mImg_RewardItemRank1 = UIUtils.GetImage(self.mBtn_RewardItem1.transform,"GrpBg/Img_Bg");
	-- self.mImg_RewardItemRank2 = UIUtils.GetImage(self.mBtn_RewardItem2.transform,"GrpBg/Img_Bg");
	-- self.mImg_RewardItemRank3 = UIUtils.GetImage(self.mBtn_RewardItem3.transform,"GrpBg/Img_Bg");

	-- self.mImg_RewardItemIcon1 = UIUtils.GetImage(self.mBtn_RewardItem1.transform,"GrpItem/Img_Item");
	-- self.mImg_RewardItemIcon2 = UIUtils.GetImage(self.mBtn_RewardItem2.transform,"GrpItem/Img_Item");
	-- self.mImg_RewardItemIcon3 = UIUtils.GetImage(self.mBtn_RewardItem3.transform,"GrpItem/Img_Item");

	-- self.mText_RewardItemNum1 = UIUtils.GetText(self.mBtn_RewardItem1.transform,"Trans_GrpNum/ImgBg/Text_Num");
	-- self.mText_RewardItemNum2 = UIUtils.GetText(self.mBtn_RewardItem2.transform,"Trans_GrpNum/ImgBg/Text_Num");
	-- self.mText_RewardItemNum3 = UIUtils.GetText(self.mBtn_RewardItem3.transform,"Trans_GrpNum/ImgBg/Text_Num");

	self.mTrans_NewbieReceive = self:GetRectTransform("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted/GrpAction/Trans_BtnReceive");
	self.mTrans_NewbieUnCompleted = self:GetRectTransform("Root/GrpRight/Trans_GrpRookieQuest/GrpBottom/Trans_Uncompleted/GrpAction/Trans_TextUnCompleted");
	self.mBtn_NewbieReceive = UIUtils.GetTempBtn(self.mTrans_NewbieReceive);
	self.mTrans_CommonNode = self:GetRectTransform("Root");
end

--@@ GF Auto Gen Block End


UIDailyQuestPanelView.mDailyScrollBar = nil;
UIDailyQuestPanelView.mSrollBarRect = nil;

UIDailyQuestPanelView.mWeekScrollBar = nil;
UIDailyQuestPanelView.mImageWeeklyRewardList=nil;
UIDailyQuestPanelView.mWeeklyRewardBoxList=nil;
UIDailyQuestPanelView.mTransWeeklyRewardDetailList=nil;

UIDailyQuestPanelView.weeklyTaskRewardList = nil;

function UIDailyQuestPanelView:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mDailyScrollBar = self:GetImage("Root/GrpRight/Trans_GrpDailyQuest/GrpBottom/GrpReward/GrpProgressBar/Img_ProgressBar");

	self.mSrollBarRect = self:GetRectTransform("Root/GrpRight/Trans_GrpDailyQuest/GrpBottom/GrpReward/GrpProgressBar")
    self.mWeekScrollBar = self:GetScrollbar("UI_Trans_WeeklyQuestListPanel/UI_WeeklyActiveReward/Trans_RewardPanel/Scrollbar");

    self.mImageWeeklyRewardList=List:New();
    self.mImageWeeklyRewardList:Add(self.mImage_WeeklyQuestDetail_WeeklyReward1_Box);
    self.mImageWeeklyRewardList:Add(self.mImage_WeeklyQuestDetail_WeeklyReward2_Box);
	self.mImageWeeklyRewardList:Add(self.mImage_WeeklyQuestDetail_WeeklyReward3_Box);
	self.mImageWeeklyRewardList:Add(self.mImage_WeeklyQuestDetail_WeeklyReward4_Box);

	self.mTransWeeklyRewardDetailList = List:New();
	self.mTransWeeklyRewardDetailList:Add({
		self.mTrans_GetRewardDetail_WeeklyRewardDetail1_Received,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail1_Now,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail1_Unfinished,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail1_ItemList
	});
	self.mTransWeeklyRewardDetailList:Add({
		self.mTrans_GetRewardDetail_WeeklyRewardDetail2_Received,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail2_Now,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail2_Unfinished,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail2_ItemList
	});
	self.mTransWeeklyRewardDetailList:Add({
		self.mTrans_GetRewardDetail_WeeklyRewardDetail3_Received,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail3_Now,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail3_Unfinished,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail3_ItemList
	});
	self.mTransWeeklyRewardDetailList:Add({
		self.mTrans_GetRewardDetail_WeeklyRewardDetail4_Received,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail4_Now,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail4_Unfinished,
		self.mTrans_GetRewardDetail_WeeklyRewardDetail4_ItemList
	});


	self.mWeeklyRewardBoxList=List:New();
	self.mWeeklyRewardBoxList:Add({
		self.mTrans_WeeklyQuestDetail_WeeklyReward1_ReceivedBox,
		self.mTrans_WeeklyQuestDetail_WeeklyReward1_UnreceivedBox,
		self.mTrans_WeeklyQuestDetail_WeeklyReward1_UnfinishedBox
	});
	self.mWeeklyRewardBoxList:Add({
		self.mTrans_WeeklyQuestDetail_WeeklyReward2_ReceivedBox,
		self.mTrans_WeeklyQuestDetail_WeeklyReward2_UnreceivedBox,
		self.mTrans_WeeklyQuestDetail_WeeklyReward2_UnfinishedBox
	});
	self.mWeeklyRewardBoxList:Add({
		self.mTrans_WeeklyQuestDetail_WeeklyReward3_ReceivedBox,
		self.mTrans_WeeklyQuestDetail_WeeklyReward3_UnreceivedBox,
		self.mTrans_WeeklyQuestDetail_WeeklyReward3_UnfinishedBox
	});
	self.mWeeklyRewardBoxList:Add({
		self.mTrans_WeeklyQuestDetail_WeeklyReward4_ReceivedBox,
		self.mTrans_WeeklyQuestDetail_WeeklyReward4_UnreceivedBox,
		self.mTrans_WeeklyQuestDetail_WeeklyReward4_UnfinishedBox
	});
end


function UIDailyQuestPanelView:SetFinished()
	setactive(self.mTrans_DailyQuestPanel_Can.gameObject,false);
	setactive(self.mTrans_DailyQuestPanel_Fin.gameObject,true);
	--setactive(self.mTrans_DailyQuestPanel_Cant.gameObject,false);
end

function UIDailyQuestPanelView:SetCanGetReward()
	setactive(self.mTrans_DailyQuestPanel_Can.gameObject,true);
	setactive(self.mTrans_DailyQuestPanel_Fin.gameObject,false);
	--self.mBtn_DailyQuestPanel_ReceiveAll.interactable = true;
	--setactive(self.mTrans_DailyQuestPanel_Cant.gameObject,false);
end

function UIDailyQuestPanelView:SetNotCanGetReward()
	setactive(self.mTrans_DailyQuestPanel_Can.gameObject,true);
	setactive(self.mTrans_DailyQuestPanel_Fin.gameObject,false);
	--self.mBtn_DailyQuestPanel_ReceiveAll.interactable = false;
	--setactive(self.mTrans_DailyQuestPanel_Cant.gameObject,true);
end