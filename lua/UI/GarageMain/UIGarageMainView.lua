require("UI.UIBaseView")

UIGarageMainView = class("UIGarageMainView", UIBaseView);
UIGarageMainView.__index = UIGarageMainView

UIGarageMainView.mText_UI_Prefix = nil;
UIGarageMainView.mText_UI_Name = nil;
UIGarageMainView.mText_UI_BattlePower = nil;
UIGarageMainView.mText_UIDismantlingResultName = nil;
UIGarageMainView.mText_UIDismantlingResultNameNum = nil;
UIGarageMainView.mImage_UIGarageMain = nil;
UIGarageMainView.mImage_UI_ButtonExit = nil;
UIGarageMainView.mImage_UI_VehcicleCardListLayout = nil;
UIGarageMainView.mImage_UI_FilterPanel = nil;
UIGarageMainView.mImage_UI_ButtonSSR = nil;
UIGarageMainView.mImage_UI_ButtonSR = nil;
UIGarageMainView.mImage_UI_ButtonR = nil;
UIGarageMainView.mImage_UI_ButtonN = nil;
UIGarageMainView.mImage_UI_Button5 = nil;
UIGarageMainView.mImage_UI_Button4 = nil;
UIGarageMainView.mImage_UI_Button3 = nil;
UIGarageMainView.mImage_UI_Button2 = nil;
UIGarageMainView.mImage_UI_Sorting_Level = nil;
UIGarageMainView.mImage_UI_Cover_Level = nil;
UIGarageMainView.mImage_UI_Sorting_BattlePower = nil;
UIGarageMainView.mImage_UI_Cover_BattlePower = nil;
UIGarageMainView.mImage_UI_Sorting_GettingOrder = nil;
UIGarageMainView.mImage_UI_Cover_GettingOrder = nil;
UIGarageMainView.mImage_UI_Sorting_Star = nil;
UIGarageMainView.mImage_UI_Cover_Star = nil;
UIGarageMainView.mImage_UI_Sorting_HP = nil;
UIGarageMainView.mImage_UI_Cover_HP = nil;
UIGarageMainView.mImage_UI_Sorting_Team = nil;
UIGarageMainView.mImage_UI_Cover_Team = nil;
UIGarageMainView.mImage_UI_ButtonArrangePopup = nil;
UIGarageMainView.mImage_UI_ButtonArrangePopupActived = nil;
UIGarageMainView.mImage_UI_ButtonDismantlingMode = nil;
UIGarageMainView.mImage_UI_ButtonDismantlingModeActived = nil;
UIGarageMainView.mImage_UI_ButtonLockMode = nil;
UIGarageMainView.mImage_UI_ButtonLockModeActived = nil;
UIGarageMainView.mImage_UI_ButtonDismantlingComfirm = nil;
UIGarageMainView.mImage_UI_Rank = nil;
UIGarageMainView.mImage_UI_Stars = nil;
UIGarageMainView.mImage_UI_DetailButton = nil;
UIGarageMainView.mImage_UI_DismantlingResultTopWarning = nil;
UIGarageMainView.mImage_UI_DismantlingResultTop = nil;
UIGarageMainView.mImage_UIDismantlingResultItem = nil;
UIGarageMainView.mImage_UIDismantlingResultNameIcon = nil;
UIGarageMainView.mImage_UI_CancelBtn = nil;
UIGarageMainView.mImage_UI_ComfirmBtn = nil;
UIGarageMainView.mImage_UI_ComfirmBtnWarning = nil;

UIGarageMainView.mImage_UI_BarrackSortRarityFilterSelected1 = nil;
UIGarageMainView.mImage_UI_BarrackSortRarityFilterSelected2 = nil;

UIGarageMainView.mGridLayoutGroup_UI_VehcicleCardListLayout = nil;
UIGarageMainView.mButton_UI_ButtonExit = nil;
UIGarageMainView.mButton_UI_ButtonSSR = nil;
UIGarageMainView.mButton_UI_ButtonSR = nil;
UIGarageMainView.mButton_UI_ButtonR = nil;
UIGarageMainView.mButton_UI_ButtonN = nil;
UIGarageMainView.mButton_UI_Button5 = nil;
UIGarageMainView.mButton_UI_Button4 = nil;
UIGarageMainView.mButton_UI_Button3 = nil;
UIGarageMainView.mButton_UI_Button2 = nil;
UIGarageMainView.mButton_UI_Sorting_Level = nil;
UIGarageMainView.mCover_UI_Sorting_Level = nil;
UIGarageMainView.mButton_UI_Sorting_BattlePower = nil;
UIGarageMainView.mButton_UI_Sorting_GettingOrder = nil;
UIGarageMainView.mButton_UI_Sorting_Star = nil;
UIGarageMainView.mButton_UI_Sorting_HP = nil;
UIGarageMainView.mButton_UI_Sorting_Team = nil;
UIGarageMainView.mButton_UI_ButtonArrangePopup = nil;
UIGarageMainView.mButton_UI_ButtonDismantlingMode = nil;
UIGarageMainView.mButton_UI_ButtonLockMode = nil;
UIGarageMainView.mButton_UI_ButtonDismantlingComfirm = nil;
UIGarageMainView.mButton_UI_DetailButton = nil;
UIGarageMainView.mButton_UI_CancelBtn = nil;
UIGarageMainView.mButton_UI_ComfirmBtn = nil;
UIGarageMainView.mButton_UI_ButtonConfirm = nil;
UIGarageMainView.mBUtton_UI_ButtonReset = nil;

UIGarageMainView.mMessagePanelObj = nil;
UIGarageMainView.mMessageWarningObj = nil;
UIGarageMainView.mCamera = nil;

UIGarageMainView.mMessageConfirmCallback = nil;
UIGarageMainView.mMessageConfirmData = nil;

UIGarageMainView.mObj_Node_RankType = nil;

UIGarageMainView.mSortRankTypeList = nil;
UIGarageMainView.mSortRankTypeSelectedList = nil;

UIGarageMainView.mTempRankList = {0,0,0,0};
UIGarageMainView.mSingleIndexList = nil;
UIGarageMainView.mMaxRank = 6;
UIGarageMainView.mTabWidth = 200;

function UIGarageMainView:InitCtrl(root)

	self:SetRoot(root);

	self.mText_UI_Prefix = self:GetText("PanelVehicleView/UI_Prefix");
	self.mText_UI_Name = self:GetText("PanelVehicleView/UI_Name");
	self.mText_UI_BattlePower = self:GetText("PanelVehicleView/BattlePower/UI_BattlePower");
	self.mText_UIDismantlingResultName = self:GetText("UI_VehicleBodyDismantlingResult/MessagePanel/Background/Message/UI_DismantlingResultItemList/UIDismantlingResultItem/UIDismantlingResultName");
	self.mText_UIDismantlingResultNameNum = self:GetText("UI_VehicleBodyDismantlingResult/MessagePanel/Background/Message/UI_DismantlingResultItemList/UIDismantlingResultItem/UIDismantlingResultNameNum");
	self.mImage_UIGarageMain = self:GetImage("Canvas/");
	self.mImage_UI_ButtonExit = self:GetImage("UI_ButtonExit");
	self.mImage_UI_VehcicleCardListLayout = self:GetImage("PanelVehicleList/ListMask/UI_VehcicleCardListLayout");
	self.mImage_UI_FilterPanel = self:GetImage("PanelVehicleList/UI_FilterPanel");
	self.mImage_UI_ButtonSSR = self:GetImage("PanelVehicleList/UI_FilterPanel/Filter_Rarity/Layout/UI_ButtonSSR");
	self.mImage_UI_ButtonSR = self:GetImage("PanelVehicleList/UI_FilterPanel/Filter_Rarity/Layout/UI_ButtonSR");
	self.mImage_UI_ButtonR = self:GetImage("PanelVehicleList/UI_FilterPanel/Filter_Rarity/Layout/UI_ButtonR");
	self.mImage_UI_ButtonN = self:GetImage("PanelVehicleList/UI_FilterPanel/Filter_Rarity/Layout/UI_ButtonN");
	self.mImage_UI_Button5 = self:GetImage("PanelVehicleList/UI_FilterPanel/Filter_Star/Layout/UI_Button5");
	self.mImage_UI_Button4 = self:GetImage("PanelVehicleList/UI_FilterPanel/Filter_Star/Layout/UI_Button4");
	self.mImage_UI_Button3 = self:GetImage("PanelVehicleList/UI_FilterPanel/Filter_Star/Layout/UI_Button3");
	self.mImage_UI_Button2 = self:GetImage("PanelVehicleList/UI_FilterPanel/Filter_Star/Layout/UI_Button2");
	self.mImage_UI_Sorting_Level = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_Level");
	self.mImage_UI_Cover_Level = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_Level/UI_Cover");
	self.mImage_UI_Sorting_BattlePower = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_BattlePower");
	self.mImage_UI_Cover_BattlePower = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_BattlePower/UI_Cover");
	self.mImage_UI_Sorting_GettingOrder = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_GettingOrder");
	self.mImage_UI_Cover_GettingOrder = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_GettingOrder/UI_Cover");
	self.mImage_UI_Sorting_Star = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_Star");
	self.mImage_UI_Cover_Star = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_Star/UI_Cover");
	self.mImage_UI_Sorting_HP = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_HP");
	self.mImage_UI_Cover_HP = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_HP/UI_Cover");
	self.mImage_UI_Sorting_Team = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_Team");
	self.mImage_UI_Cover_Team = self:GetImage("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_Team/UI_Cover");
	self.mImage_UI_ButtonArrangePopup = self:GetImage("PanelVehicleList/UI_ButtonArrangePopup");
	self.mImage_UI_ButtonArrangePopupActived = self:GetImage("PanelVehicleList/UI_ButtonArrangePopup/UI_ButtonArrangePopupActived");
	self.mImage_UI_ButtonDismantlingMode = self:GetImage("PanelVehicleList/UI_ButtonDismantlingMode");
	self.mImage_UI_ButtonDismantlingModeActived = self:GetImage("PanelVehicleList/UI_ButtonDismantlingMode/UI_ButtonDismantlingModeActived");
	self.mImage_UI_ButtonLockMode = self:GetImage("PanelVehicleList/UI_ButtonLockMode");
	self.mImage_UI_ButtonLockModeActived = self:GetImage("PanelVehicleList/UI_ButtonLockMode/UI_ButtonLockModeActived");
	self.mImage_UI_ButtonDismantlingComfirm = self:GetImage("PanelVehicleList/UI_ButtonDismantlingComfirm");
	self.mImage_UI_Rank = self:GetImage("PanelVehicleView/UI_Rank");
	self.mImage_UI_Stars = self:GetImage("PanelVehicleView/UI_Stars");
	self.mImage_UI_DetailButton = self:GetImage("PanelVehicleView/UI_DetailButton");
	self.mImage_UI_DismantlingResultTopWarning = self:GetImage("UI_VehicleBodyDismantlingResult/MessagePanel/Background/UI_DismantlingResultTopWarning");
	self.mImage_UI_DismantlingResultTop = self:GetImage("UI_VehicleBodyDismantlingResult/MessagePanel/Background/UI_DismantlingResultTop");
	self.mImage_UIDismantlingResultItem = self:GetImage("UI_VehicleBodyDismantlingResult/MessagePanel/Background/Message/UI_DismantlingResultItemList/UIDismantlingResultItem");
	self.mImage_UIDismantlingResultNameIcon = self:GetImage("UI_VehicleBodyDismantlingResult/MessagePanel/Background/Message/UI_DismantlingResultItemList/UIDismantlingResultItem/UIDismantlingResultNameIcon");
	self.mImage_UI_CancelBtn = self:GetImage("UI_VehicleBodyDismantlingResult/MessagePanel/BtnPanel/UI_CancelBtn");
	self.mImage_UI_ComfirmBtn = self:GetImage("UI_VehicleBodyDismantlingResult/MessagePanel/BtnPanel/UI_ComfirmBtn");
	self.mImage_UI_ComfirmBtnWarning = self:GetImage("UI_VehicleBodyDismantlingResult/MessagePanel/BtnPanel/UI_ComfirmBtnWarning");
	
	self.mImage_UI_BarrackSortRarityFilterSelected1 = self:GetImage("PanelVehicleList/UI_FilterPanel/RankFilter_2/UI_BarrackSortRarityFilterSelected1");
	self.mImage_UI_BarrackSortRarityFilterSelected2 = self:GetImage("PanelVehicleList/UI_FilterPanel/RankFilter_2/UI_BarrackSortRarityFilterSelected2");
	
	self.mGridLayoutGroup_UI_VehcicleCardListLayout = self:GetGridLayoutGroup("PanelVehicleList/ListMask/UI_VehcicleCardListLayout");
	self.mButton_UI_ButtonExit = self:GetButton("UI_ButtonExit");
	self.mButton_UI_ButtonSSR = self:GetButton("PanelVehicleList/UI_FilterPanel/Filter_Rarity/Layout/UI_ButtonSSR");
	self.mButton_UI_ButtonSR = self:GetButton("PanelVehicleList/UI_FilterPanel/Filter_Rarity/Layout/UI_ButtonSR");
	self.mButton_UI_ButtonR = self:GetButton("PanelVehicleList/UI_FilterPanel/Filter_Rarity/Layout/UI_ButtonR");
	self.mButton_UI_ButtonN = self:GetButton("PanelVehicleList/UI_FilterPanel/Filter_Rarity/Layout/UI_ButtonN");
	self.mButton_UI_Button5 = self:GetButton("PanelVehicleList/UI_FilterPanel/Filter_Star/Layout/UI_Button5");
	self.mButton_UI_Button4 = self:GetButton("PanelVehicleList/UI_FilterPanel/Filter_Star/Layout/UI_Button4");
	self.mButton_UI_Button3 = self:GetButton("PanelVehicleList/UI_FilterPanel/Filter_Star/Layout/UI_Button3");
	self.mButton_UI_Button2 = self:GetButton("PanelVehicleList/UI_FilterPanel/Filter_Star/Layout/UI_Button2");
	self.mButton_UI_Sorting_Level = self:GetButton("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_Level");
	self.mButton_UI_Sorting_BattlePower = self:GetButton("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_BattlePower");
	self.mButton_UI_Sorting_GettingOrder = self:GetButton("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_GettingOrder");
	self.mButton_UI_Sorting_Star = self:GetButton("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_Star");
	self.mButton_UI_Sorting_HP = self:GetButton("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_HP");
	self.mButton_UI_Sorting_Team = self:GetButton("PanelVehicleList/UI_FilterPanel/SortingType/UI_Sorting_Team");
	self.mButton_UI_ButtonArrangePopup = self:GetButton("PanelVehicleList/UI_ButtonArrangePopup");
	self.mButton_UI_ButtonDismantlingMode = self:GetButton("PanelVehicleList/UI_ButtonDismantlingMode");
	self.mButton_UI_ButtonLockMode = self:GetButton("PanelVehicleList/UI_ButtonLockMode");
	self.mButton_UI_ButtonDismantlingComfirm = self:GetButton("PanelVehicleList/UI_ButtonDismantlingComfirm");
	self.mButton_UI_DetailButton = self:GetButton("PanelVehicleView/UI_DetailButton");
	self.mButton_UI_CancelBtn = self:GetButton("UI_VehicleBodyDismantlingResult/MessagePanel/BtnPanel/UI_CancelBtn");
	self.mButton_UI_ComfirmBtn = self:GetButton("UI_VehicleBodyDismantlingResult/MessagePanel/BtnPanel/UI_ComfirmBtn");
	self.mButton_UI_ButtonConfirm = self:GetButton("PanelVehicleList/UI_FilterPanel/Btn_ButtonConfirm");
	self.mBUtton_UI_ButtonReset = self:GetButton("PanelVehicleList/UI_FilterPanel/Btn_ButtonReset");
	
	self.mObj_Node_RankType = self:FindChild("PanelVehicleList/UI_FilterPanel/RankFilter_2/RarityBtn");
	
	self.mMessagePanelObj = self:FindChild("UI_VehicleBodyDismantlingResult");	
	self.mMessageWarningObj = self:FindChild("UI_VehicleBodyDismantlingResult/MessagePanel/Background/Message/UI_DismantlingResultWarning");	
	self.mCamera = UIUtils.FindTransform("Main Camera");
	
	UIUtils.GetListener(self.mButton_UI_ComfirmBtn.gameObject).onClick = self.OnConfirmClicked;
	UIUtils.GetListener(self.mButton_UI_CancelBtn.gameObject).onClick = self.OnCancelClicked;
	
	self.mSingleIndexList = List:New(CS.System.Int32);
	self:SetSortButton();
end

function UIGarageMainView:SetSortButton()

	self.mSortRankTypeList = {};
	self.mSortRankTypeSelectedList = {};

	for i = 1, self.mObj_Node_RankType.transform.childCount do
		local btnTrans = self.mObj_Node_RankType.transform:GetChild(i - 1);
		self.mSortRankTypeList[i] = UIUtils.GetButton(btnTrans);
		self.mSortRankTypeSelectedList[i] = btnTrans:GetChild(0);
	end
end

function UIGarageMainView:SetRankState(index, rank)
	self:ResetRarityFilter();

	print("cur index = "..index);
	for i = 1, #self.mTempRankList do
		if index == i then
			if self.mTempRankList[i] == 1 then
				self.mTempRankList[i] = 0;
			else
				self.mTempRankList[i] = 1;
			end
		end

		print("loop i =  "..self.mTempRankList[i]);
	end

	local rankGroupCount = 0;
	local startIndex = -1;
	self.mSingleIndexList:Clear();
	for i = 1, #self.mTempRankList do
		if self.mTempRankList[i] == 1 then
			local rightBorder = i + 1 <= #self.mTempRankList and self.mTempRankList[i + 1] == 1;
			local leftBorder = i - 1 >= 1 and self.mTempRankList[i - 1] == 1;


			if rightBorder or leftBorder then
				if startIndex == -1 then
					startIndex = i - 1;
					print("set startIndex = "..i);
				end
				rankGroupCount = rankGroupCount + 1;
			else
				self.mSingleIndexList:Add(i);
			end
		end
	end

	print("rankGroupCount =  "..rankGroupCount.."  startIndex = "..startIndex);
	if rankGroupCount > 0 then
		self.mImage_UI_BarrackSortRarityFilterSelected1.rectTransform.sizeDelta = CS.UnityEngine.Vector2((rankGroupCount) * self.mTabWidth, 66);
		self.mImage_UI_BarrackSortRarityFilterSelected1.rectTransform.anchoredPosition = CS.UnityEngine.Vector2(startIndex * self.mTabWidth, 0);

		if self.mSingleIndexList[1] ~= nil then
			--print("group single rarity = "..self.mSingleIndexList[1]);
			setactive(self.mImage_UI_BarrackSortRarityFilterSelected2.gameObject, true);
			self.mImage_UI_BarrackSortRarityFilterSelected2.rectTransform.sizeDelta = CS.UnityEngine.Vector2(self.mTabWidth, 66);
			local x = math.max((self.mSingleIndexList[1] - 1) * self.mTabWidth,1);
			self.mImage_UI_BarrackSortRarityFilterSelected2.rectTransform.anchoredPosition = CS.UnityEngine.Vector2(x, 0);
		end
	else
		--TODO 目前用了数量限制（之后应该对应多个背景设置显示）
		if self.mSingleIndexList:Count() > 0 then
			print("single rarity = "..#self.mSingleIndexList);
			for i = 1, #self.mSingleIndexList do
				if i > 2 then
					break;
				end

				if i == 1 then
					self.mImage_UI_BarrackSortRarityFilterSelected1.rectTransform.sizeDelta = CS.UnityEngine.Vector2(self.mTabWidth, 66);
					self.mImage_UI_BarrackSortRarityFilterSelected1.rectTransform.anchoredPosition = CS.UnityEngine.Vector2((self.mSingleIndexList[i] - 1) * self.mTabWidth, 0);
				else
					setactive(self.mImage_UI_BarrackSortRarityFilterSelected2.gameObject, true);
					self.mImage_UI_BarrackSortRarityFilterSelected2.rectTransform.sizeDelta = CS.UnityEngine.Vector2(self.mTabWidth, 66);
					self.mImage_UI_BarrackSortRarityFilterSelected2.rectTransform.anchoredPosition = CS.UnityEngine.Vector2((self.mSingleIndexList[i] - 1) * self.mTabWidth, 0);
				end
			end

		end
	end
	
end

function UIGarageMainView:ResetRarityFilter()
	self.mImage_UI_BarrackSortRarityFilterSelected1.rectTransform.sizeDelta = vector2zero;
	self.mImage_UI_BarrackSortRarityFilterSelected1.rectTransform.anchoredPosition = vector2zero;

	setactive(self.mImage_UI_BarrackSortRarityFilterSelected2.gameObject, false);
	self.mImage_UI_BarrackSortRarityFilterSelected2.rectTransform.sizeDelta = vector2zero;
	self.mImage_UI_BarrackSortRarityFilterSelected2.rectTransform.anchoredPosition = vector2zero;
	
	
end

function UIGarageMainView:ResetSort()
	for i = 1, #self.mTempRankList do
		self.mTempRankList[i] = 0;
	end
	
	self:ResetRarityFilter();
end


function UIGarageMainView:ShowMessage(num, hasWarning, callback,data)
	setactive(self.mMessagePanelObj,true);
	self.mText_UIDismantlingResultNameNum.text = num;
	
	if hasWarning then
		setactive(self.mMessageWarningObj,true);
	else
		setactive(self.mMessageWarningObj,false);
	end
	
	self.mMessageConfirmCallback = callback;
	self.mMessageConfirmData = data;
	
end

function UIGarageMainView:HideMessage()
	setactive(self.mMessagePanelObj,false);
end

function UIGarageMainView.OnCancelClicked(gameobj)
	self = UIGarageMainView;
	self:HideMessage();
end

function UIGarageMainView.OnConfirmClicked(gameobj)
	self = UIGarageMainView;
	self.mMessageConfirmCallback(self.mMessageConfirmData);
end