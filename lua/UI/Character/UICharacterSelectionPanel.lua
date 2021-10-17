---
--- Created by 6.
--- DateTime: 18/9/5 11:05
---
require("UI.UIBasePanel")
require("UI.Character.UICharacterSelectionView")
require("UI.Character.UICharacterItem")

UICharacterSelectionPanel = class("UICharacterSelectionPanel", UIBasePanel);
UICharacterSelectionPanel.__index = UICharacterSelectionPanel;

UICharacterSelectionPanel.mView = nil;
UICharacterSelectionPanel.mHasMember = false;
UICharacterSelectionPanel.mGunList = {};

UICharacterSelectionPanel.mNetTeamHandle=nil;
UICharacterSelectionPanel.mCurrentModifyTeamID = 0;
UICharacterSelectionPanel.mCurrentModifyGunID = 0;
UICharacterSelectionPanel.mCurrentModifyGunMid = 0;
UICharacterSelectionPanel.mCurrentModifyCarrierID = 0;
UICharacterSelectionPanel.mGunListItems = nil;

UICharacterSelectionPanel.mPath_GunItem = "Character/Character.prefab";
UICharacterSelectionPanel.mIntoType = 0;

--筛选条件
UICharacterSelectionPanel.mSortCondType = nil;--枪种类 {"HG", "SMG", "RF", "AR", "MG", "SG"}
UICharacterSelectionPanel.mCurrentChoseGunType = 0;
UICharacterSelectionPanel.mSortCondGrade = 0;--枪等级 {"S", "A", "B", "C", "D"}
UICharacterSelectionPanel.mSortCondStar = nil;--枪星级 {"Five", "Four", "Three", "Two"}
UICharacterSelectionPanel.mCurrentChoseStar = 0;
UICharacterSelectionPanel.mSortCondState = 0;--筛选的条件状态 {"Lv", "Power", "GetOrder", "Star", "Hp", "Team", "Wear"}

--升序降序（true 升，false 降）
UICharacterSelectionPanel.mSortAD = true;


--多选的  选中Gun ID
UICharacterSelectionPanel.mSelectedGunIDList=nil;
UICharacterSelectionPanel.mPreSelectedList=nil;

--剔除ID
UICharacterSelectionPanel.mExcludeGunIds = {};

function UICharacterSelectionPanel:ctor()
    UICharacterSelectionPanel.super.ctor(self);
end

function UICharacterSelectionPanel.OpenByPre(previousType, hasMember)
    self = UICharacterSelectionPanel;
    self.mIntoType = previousType;

    if self.mIntoType == UIDef.UIFormationPanel then
        self:SetMainData();
    elseif self.mIntoType == UIDef.UIMaintainPanel then
        self:SetMaintainData();
    elseif self.mIntoType == UIDef.UICharacterUpgradePanel then
        self:SetUpgradeData();
    elseif self.mIntoType == UIDef.UIExpeditionTaskPanel then
        self:SetUpgradeData();
end

    UIManager.OpenUIByParam(UIDef.UICharacterSelectionPanel, hasMember);
end

function UICharacterSelectionPanel.Open(hasMember)
    self = UICharacterSelectionPanel;
    UIManager.OpenUI(UIDef.UICharacterSelectionPanel, hasMember);

    if self.mIntoType == UIDef.UIFormationPanel then
        self:SetMainData();
    end
end

function UICharacterSelectionPanel.Close()
    UIManager.CloseUI(UIDef.UICharacterSelectionPanel);
    self = UICharacterSelectionPanel;
    if self.mIntoType == UIDef.UIFormationPanel then
        UIFormationPanel.Open();
    elseif self.mIntoType == UIDef.UIMaintainPanel then
        UIMaintainPanel.Open();
    elseif self.mIntoType == UIDef.UICharacterUpgradePanel then
        UICharacterUpgradePanel.Open(nil, self.mSelectedGunIDList:Count());
    end
end

function UICharacterSelectionPanel.Init(root, data)

    UICharacterSelectionPanel.super.SetRoot(UICharacterSelectionPanel, root);

    self = UICharacterSelectionPanel;

    --传入的是是否显示remove
    self.mData = data;

    self.mView = UICharacterSelectionView;
    self.mView:InitCtrl(root);

    print("初始化角色界面")

    setactive(self.mView.mButton_Remove.gameObject, data);

    UIUtils.GetButtonListener(self.mView.mButton_Return.gameObject).onClick = self.OnReturnClick;
    UIUtils.GetButtonListener(self.mView.mButton_Remove.gameObject).onClick = self.OnRemoveClick;

    UIUtils.GetButtonListener(self.mView.mButton_AD.gameObject).onClick = self.OnADClick;
    UIUtils.GetButtonListener(self.mView.mButton_ShowSort.gameObject).onClick = self.OnShowSortClick;
    UIUtils.GetButtonListener(self.mView.mButton_Reset.gameObject).onClick = self.OnSortResetClick;
    UIUtils.GetButtonListener(self.mView.mButton_ConfirmSort.gameObject).onClick = self.OnSortConfirmClick;

    self.mNetTeamHandle = CS.NetCmdTeamData.Instance;
    if #self.mGunList > 0 or self.mGunList == nil then
        self.mGunList = {};
    end

    self.mSelectedGunIDList = List:New(CS.System.Int32);
    self.mGunListItems = List:New(UICarrierItem);
    self.mSortCondType = List:New(CS.System.Int32);
    self.mSortCondStar = List:New(CS.System.Int32);

    self:ClearData();

    if(self.mPreSelectedList ~= nil) then
        self.mSelectedGunIDList = self.mPreSelectedList;
        self.mPreSelectedList = nil;
    end


    self:SetIntoTypeView();
    self:InitSortBtns();
    self:SetDefaultSort();
    self:InitGunListBySort();

    self:InitPreSelect();
end

function UICharacterSelectionPanel.SetExcludeIdList(excludeList)
    self = UICharacterSelectionPanel;
    self.mExcludeGunIds = {};
    for i = 0, excludeList.Count-1 do
        self.mExcludeGunIds[i+1] = excludeList[i];
    end
end

function UICharacterSelectionPanel.SetSelectedIdList(list)
    self = UICharacterSelectionPanel;
    self.mPreSelectedList = list;
end

function UICharacterSelectionPanel:InitPreSelect()
    for i = 1, self.mGunListItems:Count() do
        local gunId = self.mGunListItems[i].GunInfo.id;
        if(self.mSelectedGunIDList:Contains(gunId)) then
            self.mGunListItems[i]:SelectState(UICharacterItem.mSelectType.Selected);
        end
    end    

    if self.mSelectedGunIDList:Count()>= 1 then
        self.mView.mButton_Confirm.interactable = true;
    end

    if self.mSelectedGunIDList:Count()>= 4 then
        gfdebug("选满了！");
        for i = 1, self.mGunListItems:Count() do
            local isSelected=self.mSelectedGunIDList:Contains(self.mGunListItems[i].GunInfo.id);
            if isSelected ~=true then
                self.mGunListItems[i]:SelectState(UICharacterItem.mSelectType.Unusefull);
            end
        end
    end
end

function UICharacterSelectionPanel:ClearData()
    printstack("清空选择枪列表！")
    if FacilityBarrackData.UsedUpgradeGuns ~= nil then
        FacilityBarrackData.UsedUpgradeGuns:Clear();
    end

    if self.mSelectedGunIDList ~= nil then
        self.mSelectedGunIDList:Clear();
    end
end

function UICharacterSelectionPanel:SetMainData()
    self.mCurrentModifyTeamID = UIFormationPanel.CurrentModifyTeamID;
    self.mCurrentModifyGunID = UIFormationPanel.CurrentModifyGunID;
    self.mCurrentModifyGunMid = UIFormationPanel.CurrentModifyGunMid;
    self.mCurrentModifyCarrierID = UIFormationPanel.CurrentModifyCarrierID;
end

function UICharacterSelectionPanel:SetUpgradeData()

end

function UICharacterSelectionPanel:SetIntoTypeView()
    if self.mIntoType == UIDef.UIFormationPanel then
        UIUtils.GetButtonListener(self.mView.mButton_Confirm.gameObject).onClick = self.OnSortConfirmClick;
        local index = 1;
        for i = 0, self.mNetTeamHandle.GunCount - 1 do
            local gun = self.mNetTeamHandle:GetGun(i);
            if gun.id ~= self.mCurrentModifyGunID then
                self.mGunList[index] = gun;
                index = index + 1;
            end
        end
        self:SetMainData();

    elseif self.mIntoType == UIDef.UIMaintainPanel then
        local index=0;
        for i = 0, self.mNetTeamHandle.GunCount - 1 do
            local gun=self.mNetTeamHandle:GetGun(i);
            if gun.wear_Pct>0 and gun.state==0 then
                index =index+1;
                self.mGunList[index] = gun;
            end
        end
        setactive(self.mView.mButton_Confirm.gameObject,true);
        UIUtils.GetButtonListener(self.mView.mButton_Confirm.gameObject).onClick = self.OnMaintainConfirmClick;

    elseif self.mIntoType == UIDef.UICharacterUpgradePanel then
        local index = 0;
        for i = 0, self.mNetTeamHandle.GunCount - 1 do
            local gun = self.mNetTeamHandle:GetGun(i);
            if gun.stc_gun_id == FacilityBarrackData.CurrentTrainGun.stc_gun_id
                    and gun.id ~= FacilityBarrackData.CurrentTrainGun.id then
                index = index + 1;
                self.mGunList[index] = gun;
            end
        end

        setactive(self.mView.mObj_ListInfo.gameObject,false);
        setactive(self.mView.mButton_Confirm.gameObject,true);
        UIUtils.GetButtonListener(self.mView.mButton_Confirm.gameObject).onClick = self.OnUpgradeConfirmClick;

    elseif self.mIntoType == UIDef.UIExpeditionTaskPanel then
        UIUtils.GetButtonListener(self.mView.mButton_Confirm.gameObject).onClick = self.OnSortConfirmClick;
        local index = 1;
        local types = UIExpeditionTaskPanel.mData.FitTypes;
        local sortedGunList = NetCmdTeamData:GetSortedExpeditionList(types);

        for i = 0, sortedGunList.Count - 1 do
            local gun = sortedGunList[i];
            self.mGunList[index] = gun;
            index = index + 1;
        end

        setactive(self.mView.mButton_Confirm.gameObject,true);
        self.mView.mButton_Confirm.interactable = false;
        UIUtils.GetButtonListener(self.mView.mButton_Confirm.gameObject).onClick = self.OnExpeditionConfirmClick;
    end
end

function UICharacterSelectionPanel.OnInit()
    UICharacterSelectionPanel.mNetTeamHandle = CS.NetCmdTeamData.Instance;
end

function UICharacterSelectionPanel.OnShow()
    self = UICharacterSelectionPanel;
end

function UICharacterSelectionPanel.OnRelease()
    self = UICharacterSelectionPanel;
    self:RemoveAllGunItem();
    self.mSortCondType:Clear();
end

function UICharacterSelectionPanel:RemoveAllGunItem()
    for i = 1, self.mGunListItems:Count() do
        self.mGunListItems[i]:DestroySelf();
    end

    self.mGunListItems:Clear();
end

function UICharacterSelectionPanel.OnUpgradeConfirmClick(gameObject)
    UICharacterSelectionPanel.Close();
end

function UICharacterSelectionPanel:SetDefaultSort()
    --self.mSortCondType = 0;
    --self.mSortCondGrade = 0;
    --self.mSortCondStar = 0;
    --self.mSortCondState = 0;
    --self.mSortAD = 0;
    self:SetSortStateText();
    self.mView:SetADChange(self.mSortAD);

    self.mView:SetSortTypeText(self.mSortCondState);
    --guntype
    for i = 1, self.mSortCondType:Count() do
        self.mView:SetGunTypeSortSelected(self.mSortCondType[i]);
    end
    --grade
    self.mView:SetGradeSortSelected(self.mSortCondGrade);
    --star
    for i = 1, self.mSortCondStar:Count() do
        self.mView:SetStarSelected(self.mSortCondStar[i]);
    end
    --state
    self.mView:SetStateSortSelected(self.mSortCondState);

    self:ResetGunListItem();
end

function UICharacterSelectionPanel:SetSortStateText()
    if self:IsStarCondition() or self.mSortCondGrade ~= 0 or self:IsGunTypeCondition() then
        self.mView:SetSortStateText(true);
    else
        self.mView:SetSortStateText(false);
    end
end

--是否存在枪的筛选条目
function UICharacterSelectionPanel:IsStarCondition()
    local hasStarCond = false;

    for i = 1, self.mSortCondStar:Count() do
        hasStarCond = true;
    end

    return hasStarCond;
end

--是否存在星级筛选条目
function UICharacterSelectionPanel:IsGunTypeCondition()
    local hasGunTypeCond = false;

    if self.mSortCondType:Count() > 0 then
        hasGunTypeCond = true;
    end

    return hasGunTypeCond;
end

function UICharacterSelectionPanel.OnReturnClick(gameobj)
    self = UICharacterSelectionPanel;

    if self.mIntoType == UIDef.UICharacterUpgradePanel then
        self.mSelectedGunIDList:Clear();
    end

    self.Close();
end

function UICharacterSelectionPanel.OnADClick(gameobj)
    if self.mSortAD then
        self.mSortAD = false;
    else
        self.mSortAD = true;
    end

    self.mView:SetADChange(self.mSortAD);
end

function UICharacterSelectionPanel.OnShowSortClick(gameobj)
    if self.mView.mObj_OptPanel.activeInHierarchy then
        setactive(self.mView.mObj_OptPanel, false);
    else
        setactive(self.mView.mObj_OptPanel, true);
    end
end

function UICharacterSelectionPanel:InitSortBtns()
    for i = 1, #self.mView.mButtons_GunType do
        self.mView.mButtons_GunType[i].onClick = self.OnGunTypeSortClick;
    end

    for i = 1, #self.mView.mButtons_Grade do
        self.mView.mButtons_Grade[i].onClick = self.OnGunGradeSortClick;
    end

    for i = 1, #self.mView.mButtons_Star do
        self.mView.mButtons_Star[i].onClick = self.OnGunStarSortClick;
    end

    for i = 1, #self.mView.mButtons_SortCon do
        self.mView.mButtons_SortCon[i].onClick = self.OnGunStateSortClick;
    end
end

function UICharacterSelectionPanel.OnGunTypeSortClick(gameobj)
    local eventTrigger = getcomponent(gameobj, typeof(CS.ButtonEventTriggerListener));
    if eventTrigger ~= nil then
        local index = eventTrigger.paramIndex;

        local isExist = false;

        if self.mSortCondType:Contains(index) then
            isExist = true;
        end

        if isExist then
            self.mSortCondType:Remove(index);
        else
            self.mSortCondType:Add(index);
        end

        self.mCurrentChoseGunType = index;
    end

    self.mView:SetGunTypeSortSelected(self.mCurrentChoseGunType);
    self:SetSortStateText();
end

function UICharacterSelectionPanel.OnGunGradeSortClick(gameobj)
    local eventTrigger = getcomponent(gameobj, typeof(CS.ButtonEventTriggerListener));
    if eventTrigger ~= nil then
        self.mSortCondGrade = eventTrigger.paramIndex;
    end

    self.mView:SetGradeSortSelected(self.mSortCondGrade);
    self.mView:SetSortStateText(true);
end

function UICharacterSelectionPanel.OnGunStarSortClick(gameobj)
    local eventTrigger = getcomponent(gameobj, typeof(CS.ButtonEventTriggerListener));
    if eventTrigger ~= nil then
        local index = eventTrigger.paramIndex;
        local rank = eventTrigger.param;
        if self.mSortCondStar:Contains(rank) then
            self.mSortCondStar:Remove(rank);
        else
            self.mSortCondStar:Add(rank);
            self.mView:SetSortStateText(true);
        end

        self.mView:SetStarSelected(index, rank);
        --local parInd = eventTrigger.paramIndex;
--
        --local isNext = false;
        --local starCondCount = 0;
        ----检查相邻
        --for starIndex, star in pairs(self.mSortCondStar) do
        --    if self.mSortCondStar[starIndex] ~= 0 then
        --        if math.abs(parInd - self.mSortCondStar[starIndex]) == 1 then
        --            --print("之前点过得星级："..starIndex);
        --            isNext = true;
        --        end
--
        --        starCondCount = starCondCount + 1;
        --    end
        --end
--
        --if self.mSortCondStar[parInd] == 0 and starCondCount == 0 then
        --    self:AddStarCond(parInd);
        --else
        --    if isNext then
        --        self:AddStarCond(parInd);
        --    else
        --        for starIndex, star in pairs(self.mSortCondStar) do
        --            if self.mSortCondStar[starIndex] ~= 0 then
        --                self.mSortCondStar[starIndex] = 0;
        --            end
        --        end
--
        --        self:AddStarCond(parInd);
        --    end
        --end
    end
end

function UICharacterSelectionPanel:AddStarCond(parInd)
    self.mSortCondStar[parInd] = parInd;

    self.mCurrentChoseStar = parInd;
    self.mView:SetStarSelected(parInd);
    self.mView:SetSortStateText(true);
end

function UICharacterSelectionPanel.OnGunStateSortClick(gameobj)
    local eventTrigger = getcomponent(gameobj, typeof(CS.ButtonEventTriggerListener));
    if eventTrigger ~= nil then
        if self.mSortCondState == 0 then
            self.mSortCondState = eventTrigger.paramIndex;
        else
            if self.mSortCondState == eventTrigger.paramIndex then
                self.mSortCondState = 0;
            else
                self.mSortCondState = eventTrigger.paramIndex;
            end
        end
    end

    self.mView:SetStateSortSelected(self.mSortCondState);
    self.mView:SetSortStateText(true);
end

--筛选确认  有存在的条件才筛选
function UICharacterSelectionPanel.OnSortConfirmClick(gameobj)
    self:InitGunListBySort();
end


--维护功能 确定按钮
function UICharacterSelectionPanel.OnMaintainConfirmClick(gameobj)
    local mtp=0;
    local costtime=0;

    local num=self.mSelectedGunIDList:Count();

    if num >=1 then

        for i = 1, self.mSelectedGunIDList:Count() do
            mtp=mtp+NetTeamHandle:GetMaintainGunCost(self.mSelectedGunIDList[i]);

            local time=NetTeamHandle:GetMaintainGunTime(self.mSelectedGunIDList[i]);
            if time>costtime then
                costtime=time;
            end
        end
        local costTimeStr=CS.CGameTime.ReturnDurationBySec(costtime*60);
        MessageBox.ShowMaintainMsg("维护消耗",tostring(mtp),costTimeStr,"确定","取消",MessageBox.ShowFlag.eNone,nil,self.OnMainTainConfirm, nil);
    end
end

--远征功能 确定按钮
function UICharacterSelectionPanel.OnExpeditionConfirmClick(gameobj)
    self = UICharacterSelectionPanel;
    local num = self.mSelectedGunIDList:Count();

    if num > 0 then
        UIExpeditionTaskPanel.OnSelectionCallback(self.mSelectedGunIDList);
        UICharacterSelectionPanel:Close();
    end
end

function UICharacterSelectionPanel.OnMainTainConfirm(data)
    self = UICharacterSelectionPanel;
    NetTeamHandle:SendReqGunMaintain(self.mSelectedGunIDList);
    UICharacterSelectionPanel:Close();
end

function UICharacterSelectionPanel:InitGunListBySort()

    if not self:IsGunTypeCondition() and self.mSortCondGrade == 0 and not self:IsStarCondition() == true and self.mSortCondState == 0 then
        print("无条件！");
        self:InitGunList();
    else
        print("有条件！"..self.mSortCondGrade.. " state  "..self.mSortCondState );
        self:SetSortStateText();
        --self:RemoveAllGunItem();
        self:SortAndSetGunList();
        self:SetSortResultShow();
    end
    setactive(self.mView.mObj_OptPanel, false);
end

function UICharacterSelectionPanel.OnSortResetClick(gameobj)
    self.mCurrentChoseGunType = 0;
    self.mSortCondGrade = 0;
    self.mCurrentChoseStar = 0;
    self.mSortCondState = 0;
    self.mSortAD = true;
    self.mView:Reset();

    for i = 1, self.mSortCondType:Count() do
        self.mView:SetGunTypeSortSelected(self.mSortCondType[i]);
    end
    --grade
    self.mView:SetGradeSortSelected(self.mSortCondGrade);
    --star
    for i = 1, self.mSortCondStar:Count() do
        self.mView:SetStarSelected(self.mSortCondStar[i]);
    end

    self.mSortCondStar:Clear();
    self.mSortCondType:Clear();

    self:SetDefaultSort();
end

function UICharacterSelectionPanel:InitGunList()
    local prefab = UIUtils.GetGizmosPrefab(self.mPath_GunItem,self);
    gfdebug(#self.mGunList)
    for i = 1, #self.mGunList do
        local gun = self.mGunList[i];

        local gunItem = nil;
        local prefabInst = nil;

        if self.mGunListItems[i] ~= nil then
            gunItem = self.mGunListItems[i];
            gunItem.GunInfo = gun;
            prefabInst = gunItem:GetRoot();

            local click = getcomponent(gunItem.mButton_Gun.gameObject, typeof(CS.ButtonEventTriggerListener));
            click.param = gunItem;
            click.paramData = gun;

            gunItem:SetData(gun);
        else
            if prefab ~= nil then
                prefabInst = instantiate(prefab);
                local gunListItem = UICharacterItem.New();
                gunListItem:InitCtrl(prefabInst.transform);

                gunListItem.GunInfo = gun;
                UIUtils.AddListItem(prefabInst, self.mView.mGrid_GunList);

                local gunItemBtn = UIUtils.GetButtonListener(gunListItem.mButton_Gun.gameObject);
                gunItemBtn.param = gunListItem;
                gunItemBtn.paramData = gun;
                self:SetItemClick(gunItemBtn);
                gunListItem:SetData(gun);
                self.mGunListItems:Add(gunListItem);
                gunItem = gunListItem;
            end
        end

        self:SetItemActive(gunItem, gun, prefabInst);
    end
end

function UICharacterSelectionPanel:SetItemActive(gunItem, gun, prefabInst)
    if gunItem ~= nil then
        if self.mIntoType == UIDef.UIFormationPanel then
            --if gun.team_id ~= 0 then
            --    if gun.team_id == self.mCurrentModifyTeamID then
            --        setactive(prefabInst, false);
            --    end
            --else
            --    setactive(prefabInst, true);
            --end
        end

        if self.mIntoType == UIDef.UICharacterUpgradePanel then
            if gun.state ~= 0 then
                gunItem:SelectState(UICharacterItem.mSelectType.Unusefull);
            end
        end

        if self.mIntoType == UIDef.UIExpeditionTaskPanel then
            for i = 1, #self.mExcludeGunIds do
                if(gun.id == self.mExcludeGunIds[i]) then
                    setactive(prefabInst,false);
                end
            end
        end
    end
end

function UICharacterSelectionPanel:SetItemClick(gunItemBtn)

    if self.mIntoType == UIDef.UIFormationPanel then
        gunItemBtn.onClick = self.OnNormalGunListItemClick;
        
    elseif self.mIntoType == UIDef.UIMaintainPanel then
        gunItemBtn.onClick = self.OnMaintainGunListItemClick;
        local contains=NetTeamHandle:CheckGunMaintainListContains(gunItemBtn.paramData.id);
        if contains then
            gunItemBtn.param:SelectState(UICharacterItem.mSelectType.Unusefull);
            return;
        end

    elseif self.mIntoType == UIDef.UICharacterUpgradePanel then
        gunItemBtn.onClick = self.OnUpgradeGunListItemClick;

    elseif self.mIntoType == UIDef.UIExpeditionTaskPanel then
        gunItemBtn.onClick = self.OnExpeditionGunListItemClick;
    end
end

function UICharacterSelectionPanel.OnUpgradeGunListItemClick(gameObject)
    local eventTrigger = getcomponent(gameObject, typeof(CS.ButtonEventTriggerListener));
    if eventTrigger ~= nil and eventTrigger.paramData ~= nil then
        local gun = eventTrigger.paramData;
        if gun.state ~= 0 then
            MessageBox.Show(UICNWords.Caution, UICNWords.CannotReplace, MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
        else
            if self.mSelectedGunIDList:Contains(gun.id) then
                printstack("移除id="..gun.id)
                self.mSelectedGunIDList:Remove(gun.id)
                eventTrigger.param:SelectState(UICharacterItem.mSelectType.UnSelected);
            else
                if self.mSelectedGunIDList:Count() >= FacilityBarrackData.CurrentTrainGunCostGunCount then
                    MessageBox.Show(UICNWords.Caution, UICNWords.OverGunLimit, MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
                else
                    printstack("添加id="..gun.id)
                    self.mSelectedGunIDList:Add(gun.id)
                    eventTrigger.param:SelectState(UICharacterItem.mSelectType.Selected);
                end
            end
        end
    end
end

function UICharacterSelectionPanel.OnNormalGunListItemClick(gameobj)
    local eventTrigger = getcomponent(gameobj, typeof(CS.ButtonEventTriggerListener));
    if eventTrigger ~= nil and eventTrigger.paramData ~= nil then
        local gun = eventTrigger.paramData;
        if gun.state ~= 0 then
            MessageBox.Show(UICNWords.Caution, UICNWords.CannotReplace, MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
        else
            self:SendModeTeamGunCmd(eventTrigger.paramData, self.ModeGunCallBack);
        end
    end
end

--维护界面过来时的 多选 逻辑
function UICharacterSelectionPanel.OnMaintainGunListItemClick(gameobj)
    self=UICharacterSelectionPanel;
    local eventTrigger = getcomponent(gameobj, typeof(CS.ButtonEventTriggerListener));
    if eventTrigger ~= nil and eventTrigger.paramData ~= nil then
        --该单位正在维护，点击无反应
        local contains=NetTeamHandle:CheckGunMaintainListContains(eventTrigger.paramData.id);
        if contains then
            eventTrigger.param:SelectState(UICharacterItem.mSelectType.Unusefull);
            return;
        end

        --该单位在选中列表中，点击取消选中
        local isSelect=self.mSelectedGunIDList:Contains(eventTrigger.paramData.id);
        if isSelect then
            self.mSelectedGunIDList:Remove(eventTrigger.paramData.id);
            eventTrigger.param:SelectState(UICharacterItem.mSelectType.UnSelected);

            for i = 1, self.mGunListItems:Count() do
                local isSelected=self.mSelectedGunIDList:Contains(self.mGunListItems[i].GunInfo.id);
                if isSelected ~=true then
                    self.mGunListItems[i]:SelectState(UICharacterItem.mSelectType.UnSelected);
                end
            end

            return;
        end

        --选中数量是否达到空闲维护仓位上限的话 点击无反应
        local maintainGunList=NetTeamHandle:GetGunMaintainList();
        local SpaceNum=NetTeamHandle:GetMyGunMaintainSpaceNum();

        if self.mSelectedGunIDList:Count()>(SpaceNum-maintainGunList.Count-1) then
            return;
        end


        --该单位不在 选中列表 中，点击选中，检测是否满空闲仓位，满了的话  其余显示禁止选中

        self.mSelectedGunIDList:Add(eventTrigger.paramData.id);
        eventTrigger.param:SelectState(UICharacterItem.mSelectType.Selected);
        gfdebug("选中了 ID："..eventTrigger.paramData.id);


        if self.mSelectedGunIDList:Count()>(SpaceNum-maintainGunList.Count-1) then

            gfdebug("选满了！");
            for i = 1, self.mGunListItems:Count() do
                local isSelected=self.mSelectedGunIDList:Contains(self.mGunListItems[i].GunInfo.id);
                if isSelected ~=true then
                    self.mGunListItems[i]:SelectState(UICharacterItem.mSelectType.Unusefull);
                end
            end

            return;
        end


    end
end

function UICharacterSelectionPanel.OnExpeditionGunListItemClick(gameobj)
    self=UICharacterSelectionPanel;
    local eventTrigger = getcomponent(gameobj, typeof(CS.ButtonEventTriggerListener));
    if eventTrigger ~= nil and eventTrigger.paramData ~= nil then
        local gun = eventTrigger.paramData;

        self.mView.mButton_Confirm.interactable = false;

        --该单位在选中列表中，点击取消选中
        local isSelect=self.mSelectedGunIDList:Contains(eventTrigger.paramData.id);
        if isSelect then
            self.mSelectedGunIDList:Remove(eventTrigger.paramData.id);
            eventTrigger.param:SelectState(UICharacterItem.mSelectType.UnSelected);

            for i = 1, self.mGunListItems:Count() do
                local isSelected=self.mSelectedGunIDList:Contains(self.mGunListItems[i].GunInfo.id);
                if isSelected ~=true then
                    self.mGunListItems[i]:SelectState(UICharacterItem.mSelectType.UnSelected);
                end
            end

            if self.mSelectedGunIDList:Count()>= 1 then
                self.mView.mButton_Confirm.interactable = true;
            end
            return;
        end

        if self.mSelectedGunIDList:Count()>= 4 then
            self.mView.mButton_Confirm.interactable = true;
            return;
        end
        
        self.mSelectedGunIDList:Add(eventTrigger.paramData.id);
        eventTrigger.param:SelectState(UICharacterItem.mSelectType.Selected);
        gfdebug("选中了 ID："..eventTrigger.paramData.id);
        self.mView.mButton_Confirm.interactable = true;

        if self.mSelectedGunIDList:Count()>= 4 then
            gfdebug("选满了！");
            for i = 1, self.mGunListItems:Count() do
                local isSelected=self.mSelectedGunIDList:Contains(self.mGunListItems[i].GunInfo.id);
                if isSelected ~=true then
                    self.mGunListItems[i]:SelectState(UICharacterItem.mSelectType.Unusefull);
                end
            end
        end
    end
end


function UICharacterSelectionPanel.OnRemoveClick(gameobj)
    local guns = self.mNetTeamHandle:GetTeamById(self.mCurrentModifyTeamID);

    local gunsMid = List:New(CS.Cmd.GunMid)
    if guns ~= nil then
        for i, gun in array_ipairs(guns) do
            if gun ~= nil then
                if gun.id ~= self.mCurrentModifyGunID then
                    local mId = CS.Cmd.GunMid();
                    mId.gun_id = gun.id;
                    mId.m_id = gun.m_id;
                    gunsMid:Add(mId);
                end
            end
        end
    end
    CS.PlayerNetCmdHandler.Instance:SendModTeamGunCmd(self.mCurrentModifyTeamID, gunsMid, self.ModeGunCallBack);
end

--向服务起发送的始终是当前经过修改的队伍信息
function UICharacterSelectionPanel:SendModeTeamGunCmd(gunInfo, callBack)
    local guns = self.mNetTeamHandle:GetTeamById(self.mCurrentModifyTeamID);

    printstack("+++++++++++++枪ID为 : " ..self.mCurrentModifyGunID.. " 当前gunid：" ..gunInfo.id);
    local gunsMid = List:New(CS.Cmd.GunMid)
    --printstack("+++++++++++++当前的槽位ID为 : " ..self.mCurrentModifyGunMid.. " 当前gunid：" ..gunInfo.id);
    if guns == nil then
        local gunMid = CS.Cmd.GunMid();
        gunMid.gun_id = gunInfo.id;
        gunMid.m_id = self.mCurrentModifyGunMid;
        gunsMid:Add(gunMid)
    else
        if self.mCurrentModifyGunID == 0 then
            --print("-----------当前的槽位枪ID为0!-------------");
            local isExist = false;
            --print("新增ID : " ..gunInfo.id.. " mid ：" ..self.mCurrentModifyGunMid);

            for i = 0, guns.Length - 1 do
                local orgGun = guns[i];
                if orgGun ~= nil then
                    if self.mCurrentModifyGunID ~= orgGun.id then
                        local gunMid = CS.Cmd.GunMid();
                        if gunInfo.id == orgGun.id then
                            isExist = true;
                            gunMid.gun_id = gunInfo.id;
                            gunMid.m_id = self.mCurrentModifyGunMid;
                        else
                            gunMid.gun_id = orgGun.id;
                            gunMid.m_id = orgGun.m_id;
                        end
                        gunsMid:Add(gunMid);
                    end
                    --print("已经存在的ID为 : " ..orgGun.id.. " mid ：" ..orgGun.m_id);
                end
            end

            if not isExist then
                local gunToCmd = CS.Cmd.GunMid();
                gunToCmd.gun_id = gunInfo.id;
                gunToCmd.m_id = self.mCurrentModifyGunMid;
                gunsMid:Add(gunToCmd);
            end
        else
            --print("+++++++++++++当前的槽位枪ID不为0!++++++++++++++++");
            printstack("+++++++++++++当前的槽位ID为 : " ..self.mCurrentModifyGunMid);
            local isExist = false;
            for i = 0, guns.Length - 1 do
                local orgGun = guns[i];
                if orgGun ~= nil then
                    if self.mCurrentModifyGunID ~= orgGun.id then
                        local gunMid = CS.Cmd.GunMid();
                        if orgGun.id == gunInfo.id then
                            gunMid.gun_id = gunInfo.id;
                            gunMid.m_id = self.mCurrentModifyGunMid;
                            --print("覆盖ID为 : " ..gunInfo.id);
                        else
                            gunMid.gun_id = orgGun.id;
                            gunMid.m_id = orgGun.m_id;
                            --print("已经存在的ID为 : " ..orgGun.id.. " mid ：" ..orgGun.m_id);
                        end
                        gunsMid:Add(gunMid);
                    end

                    if gunInfo.id == orgGun.id then
                        isExist = true;
                    end
                end
            end

            if not isExist then
                local gunMid = CS.Cmd.GunMid();
                gunMid.gun_id = gunInfo.id;
                gunMid.m_id = self.mCurrentModifyGunMid;
                gunsMid:Add(gunMid);
            end
        end
    end

    CS.PlayerNetCmdHandler.Instance:SendModTeamGunCmd(self.mCurrentModifyTeamID, gunsMid, callBack);
end

function UICharacterSelectionPanel.ModeGunCallBack(ret)
    if ret == CS.CMDRet.eSuccess then
        if self.mIntoType == UIDef.UIFormationPanel then

            print("编队回调返回数据！")
            self.Close();
            UIFormationPanel.Open();
        end
    end
end

function UICharacterSelectionPanel:ResetGunListItem()
    for i = 1, self.mGunListItems:Count() do
        local gunListItem = self.mGunListItems[i];
        if gunListItem ~= nil then
            if gunListItem.GunInfo.team_id ~= self.mCurrentModifyTeamID then
                gunListItem:SetActive(true);
            end
        end
    end
end

function UICharacterSelectionPanel:SetSortResultShow()
    --print("mSortCondType : "..self.mSortCondType .."  mSortCondGrade : "..self.mSortCondGrade .."mSortCondStar : "..self.mCurrentChoseStar)
    for i = 1, self.mGunListItems:Count() do
        local gunListItem = self.mGunListItems[i];
        if gunListItem ~= nil then
            local gunData = TableData.GetGunData(self.mGunListItems[i].GunInfo.stc_gun_id);

            local isFollowCond = true;

            ---------------------guntype-------------------
            local isContainType = self:IsFollowCondGunType(gunData.typeInt);

            ---------------------star-------------------
            local isContainStar = self:IsFollowCondStarType(gunData.rank);

            ---------------------final---------------
            isFollowCond = isContainType and isContainStar;
            if isFollowCond then
                --print("显示！  ")
                gunListItem:SetActive(true);
            else
                gunListItem:SetActive(false);
            end
        end
    end
end

function UICharacterSelectionPanel:IsFollowCondGunType(gunType)
    local isContainType = false;
    local typeCondCount = 0;

    for i = 1, self.mSortCondType:Count() do
        typeCondCount = typeCondCount + 1;
        if self.mSortCondType[i] == gunType then
            isContainType = true;
        end
    end

    if typeCondCount == 0 then
        isContainType = true;
    end

    return isContainType;
end

function UICharacterSelectionPanel:IsFollowCondStarType(star)
    local isContainStar = false;
    local starCondCount = 0;

    for i = 1, self.mSortCondStar:Count() do
        starCondCount = starCondCount + 1;
        if self.mSortCondStar[i] == star then
            isContainStar = true;
        end
    end

    if starCondCount == 0 then
        isContainStar = true;
    end

    return isContainStar;
end

function UICharacterSelectionPanel:SortAndSetGunList()
    --CommonGunUtils.SortGunByKeyState(self.mSortCondState, self.mSortAD, self.mGunList);
    table.sort(self.mGunList, self.SortGunList);
    --self.mGunList:Sort(self.SortGunList);
    self:InitGunList();
end

function UICharacterSelectionPanel.SortGunList(gunAItem, gunBItem)
    --local gunA = gunAItem.GunInfo;
    --local gunB = gunBItem.GunInfo;

    local gunATableData = TableData.GetGunData(gunAItem.stc_gun_id);
    local gunBTableData = TableData.GetGunData(gunBItem.stc_gun_id);

    if self.mSortCondState == 1 then
        if (gunAItem.level == gunBItem.Level) then
            return false;
        else
            if self.mSortAD then
                return (gunAItem.level > gunBItem.level);
            else
                return (gunAItem.level < gunBItem.level);
            end
        end
    end

    if self.mSortCondState == 2 then
    end

    if self.mSortCondState == 3 then
    end

    if self.mSortCondState == 4 then
        if (gunATableData.rank == gunBTableData.rank) then
            return false;
        else
            if self.mSortAD then
                return (gunATableData.rank > gunBTableData.rank);
            else
                return (gunATableData.rank < gunBTableData.rank)
            end
        end
    end

    if self.mSortCondState == 5 then
        if (gunAItem.hp == gunBItem.hp) then
            return false;
        else
            if self.mSortAD then
                return (gunAItem.hp > gunBItem.hp);
            else
                return (gunAItem.hp < gunBItem.hp);
            end
        end
    end

    if self.mSortCondState == 6 then
        if (gunAItem.team_id == gunBItem.team_id) then
            return false;
        else
            if self.mSortAD then
                return (gunAItem.team_id > gunBItem.team_id);
            else
                return (gunAItem.team_id < gunBItem.team_id);
            end
        end
    end

    if self.mSortCondState == 7 then
        if (gunAItem.wear == gunBItem.wear) then
            return false;
        else
            if self.mSortAD then
                return (gunAItem.wear < gunBItem.wear);
            else
                return (gunAItem.wear > gunBItem.wear);
            end
        end
    end

    return false;
end


function UICharacterSelectionPanel:SetMaintainData()
    self.mCurrentModifyTeamID = UIFormationPanel.CurrentModifyTeamID;
    self.mCurrentModifyGunID = UIFormationPanel.CurrentModifyGunID;
    self.mCurrentModifyGunMid = UIFormationPanel.CurrentModifyGunMid;
    self.mCurrentModifyCarrierID = UIFormationPanel.CurrentModifyCarrierID;
end