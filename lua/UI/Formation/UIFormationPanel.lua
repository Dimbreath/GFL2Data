--region *.lua

require("UI.UIBasePanel")
require("UI.Formation.UIFormationView")
require("UI.Formation.UIFormationTeammateItem")
require("UI.Carrier.UICarrierItem")
require("UI.Carrier.UICarrierSelectionPanel")
require("UI.Character.UICharacterSelectionPanel")

UIFormationPanel = class("UIFormationPanel", UIBasePanel);
UIFormationPanel.__index = UIFormationPanel;

UIFormationPanel.mView = nil;
UIFormationPanel.mData = nil;
UIFormationPanel.E3DModelType = gfenum({"eUnknown", "eGun", "eWeapon", "eEffect", "eVechicle"},-1)
UIFormationPanel.eUpdateStep = gfenum({"eUnknown", "eToDetail"},-1)

UIFormationPanel.mUpdateStep = nil;
UIFormationPanel.mNetTeamHandle = nil;

--当前编辑的信息
UIFormationPanel.CurrentModifyTeamID = 1;
UIFormationPanel.CurrentModifyGunID = 0;
UIFormationPanel.CurrentModifyGunMid = 0;
UIFormationPanel.CurrentModifyCarrierID = 0;

UIFormationPanel.mPath_CarrierItem = "Formation/CarrierListDetail.prefab";
UIFormationPanel.mPath_GunItem = "Formation/UnitInfo.prefab";

UIFormationPanel.mTeamModels = {};
UIFormationPanel.mTeamItems = nil;
UIFormationPanel.mCamera = nil;

UIFormationView.mCarrierObject = nil;

UIFormationPanel.mCameraNode = nil;
UIFormationPanel.mModelDetailNode = nil;

UIFormationPanel.mChosedModel = nil;

UIFormationPanel.mChosedModelMid = 0;

--构造
function UIFormationPanel:ctor()
    UIFormationPanel.super.ctor(self);
end

function UIFormationPanel.Open()
    self = UIFormationPanel;
    self.mNetTeamHandle = CS.NetCmdTeamData.Instance;

    UIManager.OpenUI(UIDef.UIFormationPanel);
    UIFormationPanel:InitMainContent();
end

function UIFormationPanel.Close()
    UIManager.CloseUI(UIDef.UIFormationPanel);
    FacilityBarrackData.ResetData();
end

function UIFormationPanel.Init(root, data)

    UIFormationPanel.super.SetRoot(UIFormationPanel, root);

    self = UIFormationPanel;

    self.mData = data;
    self.mNetTeamHandle = CS.NetCmdTeamData.Instance;
    
    self.mView = UIFormationView;
    self.mView:InitCtrl(root);
    FacilityBarrackData.InitNodeCamera();

    self.mUpdateStep = self.eUpdateStep.eUnknown;

    self:SetNode();
    self:TweenCamera();

    --初始化左边的队伍标签
    self:InitTeamTips();
    --底部枪信息
    self:InitBottomItem();
    --设置主要信息
    self:InitMainContent();
    --设置按钮事件
    self:SetListener();
end

function UIFormationPanel:SetListener()
    UIUtils.GetListener(self.mView.mButton_Return.gameObject).onClick = self.OnReturnClick;
    UIUtils.GetListener(self.mView.mCarrierItem.mObj_Carrier.gameObject).onClick = self.OnCarrierDetailClick;
    UIUtils.GetListener(self.mView.mCarrierItem.mObj_Chose.gameObject).onClick = self.OnCarrierDetailClick;
    UIUtils.GetListener(self.mView.mObj_CarrierSelect.gameObject).onClick = self.OnCarrierDetailClick;
end

function UIFormationPanel:SetNode()
    --self.mCamera = UIUtils.FindTransform(FacilityBarrackData.mCameraPath);
    --self.mCameraNode = UIUtils.FindTransform(FacilityBarrackData.mFormationCamNodePath);
    self.mModelDetailNode = UIUtils.FindTransform(FacilityBarrackData.mModelRootPath);
end

function UIFormationPanel.OnInit()
    self = UIFormationPanel;
    self.mNetTeamHandle = CS.NetCmdTeamData.Instance;
end

function UIFormationPanel.OnShow()
    self = UIFormationPanel;

end

function UIFormationPanel.OnUpdate()

end

function UIFormationPanel.OnRelease()
    
    self = UIFormationPanel;

    self.CurrentModifyTeamID = 1;
    self.CurrentModifyGunID = 0;
    self.CurrentModifyGunMid = 0;

    print("formation release");
end

function UIFormationPanel.ShowFormation(enable)
    self = UIFormationPanel;
    self:TweenCamera();
    self:Show(enable);

    if self.mTeamModels ~= nil then
        for tId, models in pairs(self.mTeamModels) do
            if self.mTeamModels[tId] ~= nil then
                for mid, model in pairs(models) do
                    if models[mid] ~= nil then
                        setactive(model.gameObject, enable);
                    end
                end
            end
        end
    end

    if self.mChosedModel ~= nil then
        setactive(self.mChosedModel.gameObject, true)
        if enable then
            self.mChosedModel.transform.localPosition = vectorzero;
            self.mChosedModel.transform.localEulerAngles = vectorzero;
        end
    end
end

function UIFormationPanel:InitMainContent()

    local carrierMain = CarrierNetCmdHandler:GetCarrierByTeamId(self.CurrentModifyTeamID);

    self:ShowMainContent(carrierMain, self.CurrentModifyTeamID);
    --if carrierMain ~= nil then
    --    print("UIFormationPanel:InitMainContent : ".."非空载具!");
    --    self:ShowMainContent(carrierMain, self.CurrentModifyTeamID);
    --else
    --    --print("UIFormationPanel:InitMainContent : ".."空载具!")
    --    self:ShowTeamTips(nil, self.CurrentModifyTeamID);
    --    self.mView.mList_TeamTips[self.CurrentModifyTeamID]:ShowSelected();
    --    self:SetCarrierTip(nil);
    --end
end

function UIFormationPanel.OnReturnClick(gameobj)
    self:Close();
    SceneSys:ReturnLast();
end

function UIFormationPanel:InitTeamTips()
    for i = 1, self.mView.mList_TeamTips:Count() do
        local tableIndex = i;
        local teamId = i;

        local carrier = CarrierNetCmdHandler:GetCarrierByTeamId(teamId);
        local clickRegularEvent = UIUtils.GetListener(self.mView.mList_TeamTips[tableIndex].mObj_Regular);
        self.mView.mList_TeamTips[tableIndex]:SetCarrierInfo(carrier);
        clickRegularEvent.onClick = self.OnTeamTipsItemClick;
        clickRegularEvent.paramIndex = tableIndex;
        clickRegularEvent.param = carrier;
    end
end

function UIFormationPanel:InitBottomItem()

    self.mTeamItems = List:New(UIFormationTeammateItem);
    for i = 1, #self.mView.mList_Characters do
        local prefab = UIUtils.GetGizmosPrefab(self.mPath_GunItem,self);
        local instObj = instantiate(prefab);
        local item = UIFormationTeammateItem.New();
        item:InitCtrl(instObj.transform);
        self.mTeamItems:Add(item);

        self.mView.mList_CharactersBtn[i].onClick = self.OnCharacterClick;
        self.mView.mList_CharactersBtn[i].paramIndex = i;
    end
end

function UIFormationPanel.OnTeamTipsItemClick(gameobj)
    if gameobj ~= nil then
        local tipsItem = getcomponent(gameobj, typeof(CS.EventTriggerListener));

        local carrier = nil;
        local index = 1;
        if tipsItem ~= nil then

            carrier = tipsItem.param;
            index = tipsItem.paramIndex;

            if carrier ~= nil then
                --print("UIFormationPanel:InitMainContent : 选择".."非空载具!".. carrier.id)
            else
                --print("UIFormationPanel:InitMainContent : 选择".."空载具!")
            end

            --print("当前点击tips index : " ..index);
        end

        self:ShowMainContent(carrier, index);
    end
end

function UIFormationPanel:ShowMainContent(carrier, index)
    self:ReleaseAllModel();
    self:InitTeamTips();
    self:ShowTeamTips(carrier, index);
    self:ShowTeammate(carrier, index);
    self:SetCarrierTip(carrier);

    if self.mCarrierObject ~= nil then
        gfdestroy(self.mCarrierObject.gameObject);
        self.mCarrierObject = nil;
    end

    if carrier ~= nil then
        self.CurrentModifyTeamID = carrier.team_id;
        self.CurrentModifyCarrierID = carrier.id;
        self.mCarrierObject = UIUtils.GetModel(self.E3DModelType.eVechicle, carrier.stc_carrier_id, CS.EGetModelUIType.eFormation);
        UIUtils.AddListItem(self.mCarrierObject.transform, self.mView.mObj_VechileNode);
    else
        self.CurrentModifyCarrierID = 0;
        self.CurrentModifyTeamID = index;
    end

    --print("UIFormationPanel:ShowMainContent 当前选择的teamid = " ..self.CurrentModifyTeamID .. " carrier id = " ..self.CurrentModifyCarrierID);
end

function UIFormationPanel:ShowTeamTips(carrier, index)
    local teamId = 1;
    if carrier ~= nil then
        teamId = carrier.team_id;
    else
        teamId = index;
    end

    for i = 1, self.mView.mList_TeamTips:Count() do

        local teamIndexId = i;

        local uiTip = self.mView.mList_TeamTips[i];
        local carrierInfo = uiTip.CarrierInfo;

        if carrierInfo ~= nil then
            if teamId ~= 0 then
                if teamId == carrierInfo.team_id then
                    uiTip:ShowSelected();
                else
                    uiTip:ShowRegular();
                end
            else
                if index == i then
                    uiTip:ShowSelected();
                else
                    uiTip:ShowRegular();
                end
            end
        else

            if teamId == teamIndexId then
                uiTip:ShowSelected();
            else
                uiTip:ShowRegular();
            end
        end
    end
end

function UIFormationPanel:ShowTeammate(carrier, index)
    local teamId = 1;
    if carrier ~= nil then
        teamId = carrier.team_id;
    else
        teamId = index;
    end

    --print("设置的teamid"..teamId)
    local guns = self.mNetTeamHandle:GetTeamById(teamId);

    local models = {};
    if self.mTeamModels[teamId] ~= nil then
        models = self.mTeamModels[teamId];
    end

    for i = 1, #self.mView.mObj_3DCharacterNodes do
        local isExist = false;

        if self:SetTeammateInfo(guns, i, models) then
            isExist = true;
        end

        if not isExist then
            if models[i] ~= nil then
                models[i]:Die();
            end

            self.mView.mList_CharactersBtn[i].param = nil;
            self:SetMateItem(i, nil);
            setactive(self.mView.mObj_NoneCharacterNodes[i], true);
        end
    end

    self.mTeamModels[teamId] = models;
end

function UIFormationPanel:SetTeammateInfo(guns, index, models)
    if guns == nil or guns.Length <= 0  then
        return false;
    end

    local curMid = index;
    for m = 0, guns.Length - 1 do
        local gun = guns[m];
        if gun ~= nil then
            if gun.m_id == curMid then
                local gunModel = UIUtils.GetModel(self.E3DModelType.eGun, gun.model_id, CS.EGetModelUIType.eFormation);

                if gunModel == nil then
                    print("模型空！")
                else
                    gunModel.transform.parent = self.mView.mObj_3DCharacterNodes[index];
                    gunModel.transform.localPosition = vectorzero;
                    gunModel.transform.rotation = CS.Quaternion.identity;

                    models[curMid] = gunModel;
                    self:SetMateItem(curMid, gun);
                    setactive(self.mView.mObj_NoneCharacterNodes[index], false);
                end
                return true;
            end
        else

        end
    end

    return false;
end

function UIFormationPanel:SetMateItem(mid, gun)

    local curUIIndex = mid;
    local teammateItem = self.mTeamItems[curUIIndex];

    teammateItem:SetData(gun);

    if gun ~= nil then
        teammateItem:SetActive(true);
    else
        teammateItem:SetActive(false);
    end

    teammateItem:SetParent(self.mView.mList_Characters[curUIIndex]);

    local click = UIUtils.GetListener(teammateItem.mButton_IntoGunDetail.gameObject);
    click.onClick = self.OnTeammateItemClick;
    click.param = gun;
    click.paramIndex = mid;

    self.mView.mList_CharactersBtn[curUIIndex].paramIndex = mid;

    if gun ~= nil then
        self.mView.mList_CharactersBtn[curUIIndex].param = gun.id;
        --print("初始化队员选择按钮 ".. " mid = " ..mid .." id = " .. gun.id);
    else
        self.mView.mList_CharactersBtn[curUIIndex].param = 0;
        --print("初始化队员选择按钮 ".. " mid = " ..mid .." id = " .. 0);
    end
end

function UIFormationPanel:SetCarrierTip(carrier)
    if carrier ~= nil then
        self.mView.mCarrierItem:SetActive(true);
        self.mView.mCarrierItem:ShowCarrier();
        self.mView.mCarrierItem:SetSample(carrier);

        self.mView:SetCarrierSelected(false);
    else
        self.mView:SetCarrierSelected(true);
        self.mView.mCarrierItem:SetActive(false);
    end
end

function UIFormationPanel.OnCarrierDetailClick(gameobj)
    UICarrierSelectionPanel.Open(UIDef.UIFormationPanel);
end

function UIFormationPanel.OnTeammateItemClick(gameObject)
    local listener = UIUtils.GetListener(gameObject, typeof(CS.EventTriggerListener));
    if listener ~= nil then
        self.mUpdateStep = self.eUpdateStep.eToDetail;
        self.mChosedModelMid = listener.paramIndex;
        local gunModel = self.mTeamModels[self.CurrentModifyTeamID][listener.paramIndex];
        if gunModel ~= nil then
            self.mChosedModel = gunModel;
            DOTween.DelaySetPosition(gunModel.gameObject, self.mModelDetailNode.position, 0, FacilityBarrackData.mTweenCameraTime * 0.7);
            DOTween.DelaySetEuler(gunModel.gameObject, self.mModelDetailNode.eulerAngles, 0, FacilityBarrackData.mTweenCameraTime * 0.7);
        end

        UIFormationPanel.ShowFormation(false);
        UICharacterDetailPanel.Open(UIDef.UIFormationPanel, listener.param);
    end
end

function UIFormationPanel:GetModel(gunModelId, resume)
    if gunModelId ~= self.mChosedModel.TableId then
        gfdestroy(self.mChosedModel.gameObject);

        local gunModel = UIUtils.GetModel(self.E3DModelType.eGun, gunModelId, CS.EGetModelUIType.eFormation);
        gunModel.transform.parent = self.mView.mObj_3DCharacterNodes[self.mChosedModelMid];
        if resume then
            gunModel.transform.localPosition = vectorzero;
        else
            gunModel.transform.position = self.mModelDetailNode.position;
        end
        gunModel.transform.rotation = CS.Quaternion.identity;
        self.mTeamModels[self.CurrentModifyTeamID][self.mChosedModelMid] = gunModel;
        self.mChosedModel = gunModel;
    end

    return self.mChosedModel;
end

function UIFormationPanel.OnCharacterClick(gameobj)
    if self.CurrentModifyCarrierID == 0 then
        MessageBox.Show("注意", "未选择载具！", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
        return;
    end

    if self.CurrentModifyTeamID == 0 then
        --print("!!!!!!!!!!!!!!!!!!!!!!!!!!teamId = 0");
        return;
    end

    local listener = getcomponent(gameobj, typeof(CS.EventTriggerListener));
    if listener ~= nil then
        local gunId = listener.param;

        local gunMid = listener.paramIndex;
        if gunMid ~= nil then
            self.CurrentModifyGunMid = gunMid;
        end

        if gunId ~= 0 then
            self.CurrentModifyGunID = gunId;
            UICharacterSelectionPanel.OpenByPre(UIDef.UIFormationPanel, true);
        else
            self.CurrentModifyGunID = 0;
            UICharacterSelectionPanel.OpenByPre(UIDef.UIFormationPanel, false);
        end
    end
end

function UIFormationPanel:ReleaseAllModel()
    if self.mTeamModels == nil then
        return;
    end

    for tId, tModels in pairs(self.mTeamModels) do
        --print("进入循环");
        if tId ~= teamId then
            --print("遍历的teamid"..tId);
            for mid, mod in pairs(tModels) do
                --print("遍历的mid"..mid);
                tModels[mid]:Die();
            end

            tModels = {};
        end
    end
    self.mTeamModels = {};
end

function UIFormationPanel:TweenCamera()
    FacilityBarrackData.TweenCamToFormation();
    --DOTween.TweenPosition(self.GetCamTweenPos, self.SetCamTweenPos, self.mCameraNode.position, FacilityBarrackData.mTweenCameraTime);
    --DOTween.TweenPosition(self.GetCamTweenRot, self.SetCamTweenRot, self.mCameraNode.forward, FacilityBarrackData.mTweenCameraTime);
end

--function UIFormationPanel.GetCamTweenPos()
--    return UIFormationPanel.mCamera.position;
--end
--
--function UIFormationPanel.SetCamTweenPos(position)
--    UIFormationPanel.mCamera.position = position;
--end
--
--function UIFormationPanel.GetCamTweenRot()
--    return UIFormationPanel.mCamera.forward;
--end
--
--function UIFormationPanel.SetCamTweenRot(forward)
--    UIFormationPanel.mCamera.forward = forward;
--end
