---
--- Created by 6.
--- DateTime: 18/9/5 11:05
--- UICharacterSelectionView

require("UI.UIBaseView")

UICharacterSelectionView = class("UICharacterSelectionView", UIBaseView);
UICharacterSelectionView.__index = UICharacterSelectionView;

UICharacterSelectionView.mButton_Remove = nil;
UICharacterSelectionView.mGrid_GunList = nil;
UICharacterSelectionView.mButton_Return = nil;
UICharacterSelectionView.mObj_ListInfo = nil;

--筛选顶部
UICharacterSelectionView.mButton_AD = nil;
UICharacterSelectionView.mText_SortState = nil;
UICharacterSelectionView.mImage_Up = nil;
UICharacterSelectionView.mImage_Down = nil;

UICharacterSelectionView.mButton_ShowSort = nil;
UICharacterSelectionView.mText_SortType = nil;

--筛选详情 左侧
UICharacterSelectionView.mButtons_GunType = {};
UICharacterSelectionView.mObj_GunTypeSelected = {};

UICharacterSelectionView.mButtons_Grade = {};
UICharacterSelectionView.mObj_GradeSelected = {};

UICharacterSelectionView.mButtons_Star = {};
UICharacterSelectionView.mImage_Star = nil;
UICharacterSelectionView.mImage_Star2 = nil;

UICharacterSelectionView.mButtons_SortCon = {};
UICharacterSelectionView.mStringCond = {};
UICharacterSelectionView.mObj_SortConSelected = {};

--按钮重置 确认
UICharacterSelectionView.mButton_Reset = nil;
UICharacterSelectionView.mButton_ConfirmSort = nil;
UICharacterSelectionView.mButton_Confirm = nil;

--筛选面板
UICharacterSelectionView.mObj_OptPanel = nil;

UICharacterSelectionView.mDefaultStarOffset= 213;

--sort param
UICharacterSelectionView.mLastStar = 0;
UICharacterSelectionView.mSelectedStar = {};
UICharacterSelectionView.mOrgStar = 0;
UICharacterSelectionView.mOrgAncPosx = 0;

UICharacterSelectionView.mTempRankList = {0,0,0,0};
UICharacterSelectionView.mSingleIndexList = nil;

--构造
function UICharacterSelectionView:ctor()
    UICharacterSelectionView.super.ctor(self);
end

--初始化
function UICharacterSelectionView:InitCtrl(root)

    self:SetRoot(root);

    self.mButton_Remove = self:GetButton("Characters/CharacterList/CharacterRemove");
    self.mGrid_GunList = self:FindChild("Characters/CharacterList");
    self.mButton_Return = self:GetButton("TopPanel/UI_Return");

    --筛选顶部
    self.mObj_ListInfo = self:FindChild("TopPanel/ListInfo");
    self.mButton_AD = self:GetButton("TopPanel/ListInfo/Options/AD_change");
    self.mImage_Up = self:GetImage("TopPanel/ListInfo/Options/AD_change/UP");
    self.mImage_Down = self:GetImage("TopPanel/ListInfo/Options/AD_change/DOWN");
    self.mButton_ShowSort = self:GetButton("TopPanel/ListInfo/Options/FilterButton");
    self.mText_SortType = self:GetText("TopPanel/ListInfo/Options/Sort/SortType");
    self.mText_SortState = self:GetText("TopPanel/ListInfo/Options/UI_Filter/SortType");

    self.mButton_Reset = self:GetButton("CharaOptionPanel/Reset");
    self.mButton_ConfirmSort = self:GetButton("CharaOptionPanel/Confirm");
    self.mButton_Confirm = self:GetButton("RightPanel/Confirm");
    self.mImage_Star = self:GetImage("CharaOptionPanel/options/RateFilter/Button");
    self.mImage_Star2 = self:GetImage("CharaOptionPanel/options/RateFilter/Button2");
    --筛选详情

    --枪种类
    local gunTypeNode = self:FindChild("CharaOptionPanel/options/GunTypeFilter");
    for i = 0, gunTypeNode.childCount - 1 do
        local child = gunTypeNode:GetChild(i);
        self.mButtons_GunType[i + 1] = UIUtils.GetButtonListener(child.gameObject);
        self.mObj_GunTypeSelected[i + 1] = child:Find("Selected");
        self.mButtons_GunType[i + 1].paramIndex = i + 1;
    end

    --评级 （根节点有个不明物体所以从1开始）
    local gunGradeNode = self:FindChild("CharaOptionPanel/options/GradeFilter");
    for i = 1, gunGradeNode.childCount - 1 do
        local child = gunGradeNode:GetChild(i);
        self.mButtons_Grade[i] = UIUtils.GetButtonListener(child.gameObject);
        self.mObj_GradeSelected[i] = child:Find("Image");
        self.mButtons_Grade[i].paramIndex = i;
    end

    --星级
    local gunStarNode = self:FindChild("CharaOptionPanel/options/RateFilter/StarBtn");
    for i = 0, gunStarNode.childCount - 1 do
        local child = gunStarNode:GetChild(i);
        self.mButtons_Star[i + 1] = UIUtils.GetButtonListener(child.gameObject);
        self.mButtons_Star[i + 1].paramIndex = i + 1;
        self.mButtons_Star[i + 1].param = 5 - i;
    end

    --筛选条件
    local sortConNode = self:FindChild("CharaOptionPanel/options/SortBy");
    for i = 0, sortConNode.childCount - 1 do
        local child = sortConNode:GetChild(i);
        self.mButtons_SortCon[i + 1] = UIUtils.GetButtonListener(child.gameObject);
        self.mObj_SortConSelected[i + 1] = child:Find("Selected");
        self.mStringCond[i + 1] = CS.LuaUIUtils.GetText(child:Find("Text")).text;
        self.mButtons_SortCon[i + 1].paramIndex = i + 1;
    end

    --面板
    self.mObj_OptPanel = self:FindChild("CharaOptionPanel");
    if self.mObj_OptPanel == nil then
        print("self.mObj_OptPanel nil")
    else
        print("self.mObj_OptPanel not nil")
    end

    self.mSingleIndexList = List:New(CS.System.Int32);
end

function UICharacterSelectionView:SetADChange(sortOrder)
    if sortOrder then
        self.mImage_Up.color = CS.UnityEngine.Color(0, 1, 1);
        self.mImage_Down.color = CS.UnityEngine.Color(1, 1, 1, 51 / 255);
    else
        self.mImage_Up.color = CS.UnityEngine.Color(1, 1, 1, 51 / 255);
        self.mImage_Down.color = CS.UnityEngine.Color(0, 1, 1);
    end
end

function UICharacterSelectionView:SetSortStateText(hasCond)
    if hasCond then
        self.mText_SortState.text = "筛选中";
    else
        self.mText_SortState.text = "所有";
    end
end

function UICharacterSelectionView:SetSortTypeText(type)
    if type == 0 then
        self.mText_SortType.text = "默认";
    else
        self.mText_SortType.text = self.mStringCond[type];
    end

end

function UICharacterSelectionView:SetGunTypeSortSelected(gunType)
    if gunType == 0 then
        for i = 1, #self.mObj_GunTypeSelected do
            setactive(self.mObj_GunTypeSelected[i],false);
        end
        return;
    end

    if self.mObj_GunTypeSelected[gunType].gameObject.activeSelf  then
        setactive(self.mObj_GunTypeSelected[gunType],false);
    else
        setactive(self.mObj_GunTypeSelected[gunType],true);
    end
end

function UICharacterSelectionView:SetGradeSortSelected(grade)
    for i = 1, #self.mObj_GradeSelected do
        if grade == i then
            setactive(self.mObj_GradeSelected[i],true);
        else
            setactive(self.mObj_GradeSelected[i],false);
        end
    end
end

function UICharacterSelectionView:Reset()
    self.mLastStar = 0;
    self.mSelectedStar = {};
    self.mOrgStar = 0;
    self.mOrgAncPosx = 0;
end

--function UICharacterSelectionView:SetStarSelected(star)
--    if star == 0 then
--        self.mImage_Star.rectTransform.anchoredPosition =
--        CS.UnityEngine.Vector2(0, 0);
--        self.mImage_Star.rectTransform.sizeDelta =
--        CS.UnityEngine.Vector2(0, self.mImage_Star.rectTransform.sizeDelta.y);
--
--        self.mLastStar = 0;
--        self.mSelectedStar = {};
--        return;
--    end
--
--    if star == self.mLastStar then
--        --print("星级重复！")
--        return;
--    end
--
--    if self.mSelectedStar[star] ~= nil then
--        --print("已存在星级：" .. star);
--        return;
--    end
--
--    local count = 5 - star;
--
--    local isNext = false;
--    local isIndexNext = math.abs(star - self.mOrgStar) == 1;
--    local countStar = 0;
--
--    for starIndex, starCount in pairs(self.mSelectedStar) do
--        --print("队列 星级："..starIndex.. "  "..starCount);
--        if math.abs(star - self.mSelectedStar[starIndex]) == 1 then
--            --print("之前点过得星级："..starIndex);
--            isNext = true;
--        end
--        countStar = countStar + 1;
--    end
--
--    --相邻
--    if math.abs(star - self.mLastStar) == 1 or isNext or isIndexNext then
--        local currentPosx = self.mImage_Star.rectTransform.anchoredPosition.x;
--        if star - self.mLastStar > 0 then
--            self.mImage_Star.rectTransform.anchoredPosition =
--            CS.UnityEngine.Vector2(currentPosx - self.mDefaultStarOffset, 0);
--        end
--        self.mImage_Star.rectTransform.sizeDelta =
--        CS.UnityEngine.Vector2(self.mDefaultStarOffset * (countStar + 1),
--                self.mImage_Star.rectTransform.sizeDelta.y);
--
--        self.mSelectedStar[star] = star;
--    else
--        self:Reset();
--        for starIndex, star in pairs(self.mSelectedStar) do
--            if self.mSelectedStar[starIndex] ~= nil then
--                self.mSelectedStar[starIndex] = nil;
--            end
--        end
--
--        self.mOrgStar = star;
--        self.mImage_Star.rectTransform.anchoredPosition =
--        CS.UnityEngine.Vector2(self.mDefaultStarOffset * count, 0);
--        self.mImage_Star.rectTransform.sizeDelta =
--        CS.UnityEngine.Vector2(self.mDefaultStarOffset, self.mImage_Star.rectTransform.sizeDelta.y);
--
--        self.mSelectedStar[star] = star;
--    end
--
--    self.mLastStar = star;
--end

function UICharacterSelectionView:SetStarSelected(index, rank)
    self:ResetRarityFilter();

    for i = 1, #self.mTempRankList do
        if index == i then
            if self.mTempRankList[i] == 1 then
                self.mTempRankList[i] = 0;
            else
                self.mTempRankList[i] = 1;
            end
        end
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
                end
                rankGroupCount = rankGroupCount + 1;
            else
                self.mSingleIndexList:Add(i);
            end
        end
    end

    if rankGroupCount > 0 then
        self.mImage_Star.rectTransform.sizeDelta = CS.UnityEngine.Vector2((rankGroupCount) * 213, 66);
        self.mImage_Star.rectTransform.anchoredPosition = CS.UnityEngine.Vector2(startIndex * 213, 0);

        if self.mSingleIndexList[1] ~= nil then
            --print("group single rarity = "..self.mSingleIndexList[1]);
            setactive(self.mImage_Star2.gameObject, true);
            self.mImage_Star2.rectTransform.sizeDelta = CS.UnityEngine.Vector2(213, 66);
            self.mImage_Star2.rectTransform.anchoredPosition = CS.UnityEngine.Vector2((self.mSingleIndexList[1] - 1) * 213, 0);
        end
    else
        --TODO 目前用了数量限制（之后应该对应多个背景设置显示）
        if self.mSingleIndexList:Count() > 0 then
            for i = 1, #self.mSingleIndexList do
                if i > 2 then
                    break;
                end

                if i == 1 then
                    self.mImage_Star.rectTransform.sizeDelta = CS.UnityEngine.Vector2(213, 66);
                    self.mImage_Star.rectTransform.anchoredPosition = CS.UnityEngine.Vector2((self.mSingleIndexList[i] - 1) * 213, 0);
                else
                    setactive(self.mImage_Star2.gameObject, true);
                    self.mImage_Star2.rectTransform.sizeDelta = CS.UnityEngine.Vector2(213, 66);
                    self.mImage_Star2.rectTransform.anchoredPosition = CS.UnityEngine.Vector2((self.mSingleIndexList[i] - 1) * 213, 0);
                end
            end

        end
    end
end

function UICharacterSelectionView:ResetRarityFilter()
    self.mImage_Star.rectTransform.sizeDelta = vector2zero;
    self.mImage_Star.rectTransform.anchoredPosition = vector2zero;

    setactive(self.mImage_Star2.gameObject, false);
    self.mImage_Star2.rectTransform.sizeDelta = vector2zero;
    self.mImage_Star2.rectTransform.anchoredPosition = vector2zero;
end

function UICharacterSelectionView:SetStateSortSelected(state)
    for i = 1, #self.mObj_SortConSelected do
        if state == i then
            setactive(self.mObj_SortConSelected[i],true);
        else
            setactive(self.mObj_SortConSelected[i],false);
        end
    end

    self:SetSortTypeText(state);
end

function UICharacterSelectionView:SetDefaultSortView(gunType, grade, star, state)
    self:SetGunTypeSortSelected(gunType);
    self:SetGradeSortSelected(grade);
    self:SetStarSelected(star);
    self:SetStateSortSelected(state);
end