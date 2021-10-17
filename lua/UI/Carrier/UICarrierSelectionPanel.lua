---
--- Created by 6.
--- DateTime: 18/9/5 11:04
---

require("UI.UIBasePanel")
require("UI.Carrier.UICarrierItem")

UICarrierSelectionPanel = class("UICarrierSelectionPanel", UIBasePanel);
UICarrierSelectionPanel.__index = UICarrierSelectionPanel;

UICarrierSelectionPanel.mPath_CarrierItem = "Carrier/VehicleInfo.prefab";
UICarrierSelectionPanel.mPath_CarrierOldItem = "Formation/CarrierListDetail.prefab";

UICarrierSelectionPanel.ModCarrierCallbackType = gfenum({"None", "Dismiss", "Add", "Change", "ChangeDismiss"},-1)
UICarrierSelectionPanel.mModCarrierCBType = UICarrierSelectionPanel.ModCarrierCallbackType.None;

UICarrierSelectionPanel.mView = nil;
UICarrierSelectionPanel.mCarrierItems = nil;
UICarrierSelectionPanel.mCurrentModifyTeamID = 0;

--是否选中了当前载具
UICarrierSelectionPanel.mIsSelectedCarrierItem = false;
--当前选择的载具信息
UICarrierSelectionPanel.mCurrentSelectCarrier = nil;
--原选择载具信息
UICarrierSelectionPanel.mOriginalSelectCarrier = nil;

UICarrierSelectionPanel.mIntoType = 0;



--多选的  选中Carrier ID
UICarrierSelectionPanel.mSeclectedGunIDList=nil;

UICarrierSelectionPanel.mCurCarrierData=nil;

function UICarrierSelectionPanel:ctor()
    UICarrierSelectionPanel.super.ctor(self);
end

function UICarrierSelectionPanel.Open(previousType,carrierData)
    self = UICarrierSelectionPanel;
    self.mIntoType = previousType;
    print("UICarrierSelectionPanel.Open -- last view : " ..previousType );

    if self.mIntoType == UIDef.UIFormationPanel then
        self.mCurrentModifyTeamID = UIFormationPanel.CurrentModifyTeamID;
        print("UICarrierSelectionPanel.Open 当前选择的teamid = " ..self.mCurrentModifyTeamID);

    elseif self.mIntoType == UIDef.UIGarageVechicleDetailPanel then
        --多选逻辑
        self.mCurCarrierData=carrierData;
    end
    UIManager.OpenUI(UIDef.UICarrierSelectionPanel);

end

function UICarrierSelectionPanel.Close()
    UIManager.CloseUI(UIDef.UICarrierSelectionPanel);

    self:ClearCarrierItems();

    if self.mIntoType == UIDef.UIFormationPanel then
        UIFormationPanel.Open();
    elseif self.mIntoType == UIDef.UIGarageVechicleDetailPanel then
        UIGarageVechicleDetailPanel.SetStarUpInfo();
    end
end

function UICarrierSelectionPanel.Init(root, data)

    UICarrierSelectionPanel.super.SetRoot(UICarrierSelectionPanel, root);

    self = UICarrierSelectionPanel;

    self.mData = data;
    self.mView = UICarrierSelectionView;
    self.mView:InitCtrl(root);

    self.mNetTeamHandle = CS.NetCmdTeamData.Instance;
    self.mCarrierItems = List:New(UICarrierItem);

    if self.mIntoType == UIDef.UIFormationPanel then
        self.mCurrentModifyTeamID = UIFormationPanel.CurrentModifyTeamID;
        self:SetCarrierPanel();
        self.mOriginalSelectCarrier = CarrierNetCmdHandler:GetCarrierByTeamId(self.mCurrentModifyTeamID);

        if self.mOriginalSelectCarrier == nil then
            setactive(self.mView.mButton_Remove.gameObject, false);
        else
            setactive(self.mView.mButton_Remove.gameObject, true);
            UIUtils.GetListener(self.mView.mButton_Remove.gameObject).onClick = self.OnDismissClick;
        end
    elseif self.mIntoType == UIDef.UIGarageVechicleDetailPanel then
        setactive(self.mView.mButton_Remove.gameObject, false);
        setactive(self.mView.mButton_Confirm.gameObject, true);
        UIUtils.GetListener(self.mView.mButton_Confirm.gameObject).onClick = self.OnReturnClick;
        self:SetCarrierStarUpPanel();
    end


    UIUtils.GetListener(self.mView.mButton_Return.gameObject).onClick = self.OnReturnClick;
    --UIUtils.GetListener(self.mView.mButton_CarrierConfirm.gameObject).onClick = self.OnCarrierChoseConfirmClick;
end

function UICarrierSelectionPanel.OnInit()
end

function UICarrierSelectionPanel.OnShow()
    self = UICarrierSelectionPanel;

end

function UICarrierSelectionPanel.OnRelease()

    self = UICarrierSelectionPanel;
end

function UICarrierSelectionPanel:ClearCarrierItems()

    for i = 1, self.mCarrierItems:Count() do
        gfdestroy(self.mCarrierItems[i]:GetRoot());
    end

    self.mCarrierItems:Clear();
end

function UICarrierSelectionPanel:GetItemPrefab(path)
    local sourcePrefab = UIUtils.GetGizmosPrefab(path,self);
    if sourcePrefab == nil then
        print("没有资源 ："..path);
    end
    return sourcePrefab;
end

function UICarrierSelectionPanel.OnReturnClick(gameobj)
    self.Close();
end

--设置载具列表数据
function UICarrierSelectionPanel:SetCarrierPanel()
    self:ClearCarrierItems();

    local prefab = UIUtils.GetGizmosPrefab(self.mPath_CarrierOldItem,self);
    for i = 1, CarrierNetCmdHandler.CarrierCount do
        local carrier = CarrierNetCmdHandler:GetCarrier(i - 1);

        if carrier.team_id ~= self.mCurrentModifyTeamID then
            local prefabInst = instantiate(prefab);
            local carrierItem = UICarrierItem.New();
            carrierItem:InitCtrl(prefabInst.transform);

            UIUtils.AddListItem(prefabInst, self.mView.mGrid_CarrierSelect);
            carrierItem:SetCarriedItemData(carrier);

            local carrierBtn = UIUtils.GetListener(carrierItem.mButton_ItemSelect.gameObject);
            carrierBtn.onClick = self.OnCarrierItemClick;
            carrierBtn.param = carrierItem;
            carrierBtn.paramData = carrier;

            self.mCarrierItems:Add(carrierItem);
        end
        --if carrier.team_id == 0 then
        --    UIUtils.SetUIEnable(prefabInst, true);
        --    carrierItem:SetSelectEnable(true);
        --else
        --    --被设置置灰
        --    UIUtils.SetUIEnable(prefabInst, false);
        --end
    end
end


--设置载具升阶时  列表数据
function UICarrierSelectionPanel:SetCarrierStarUpPanel()
    self:ClearCarrierItems();


    local prefab = UIUtils.GetGizmosPrefab(self.mPath_CarrierOldItem,self);
    for i = 1, CarrierNetCmdHandler.CarrierCount do
        local carrier = CarrierNetCmdHandler:GetCarrier(i - 1);

        if carrier.stc_carrier_id == self.mCurCarrierData.stc_carrier_id and carrier.id ~=self.mCurCarrierData.id  and carrier.locked ==0 then

            local prefabInst = instantiate(prefab);
            local carrierItem = UICarrierItem.New();
            carrierItem:InitCtrl(prefabInst.transform);

            UIUtils.AddListItem(prefabInst, self.mView.mGrid_CarrierSelect);
            carrierItem:SetCarriedItemData(carrier);

            local carrierBtn = UIUtils.GetListener(carrierItem.mButton_ItemSelect.gameObject);
            carrierBtn.onClick = self.OnMultiCarrierItemClick;
            carrierBtn.param = carrierItem;
            carrierBtn.paramData = carrier;


            --如果早选中列表中
            if (CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList:Contains(carrier.id)) then
                carrierItem:SeclectState(UICharacterItem.mSelectType.Selected);
            end

            self.mCarrierItems:Add(carrierItem);
        end
        --if carrier.team_id == 0 then
        --    UIUtils.SetUIEnable(prefabInst, true);
        --    carrierItem:SetSelectEnable(true);
        --else
        --    --被设置置灰
        --    UIUtils.SetUIEnable(prefabInst, false);
        --end
    end
end


--载具升阶的 多选 逻辑
function UICarrierSelectionPanel.OnMultiCarrierItemClick(gameobj)
    self=UICarrierSelectionPanel;
    local eventTrigger = getcomponent(gameobj, typeof(CS.EventTriggerListener));
    if eventTrigger ~= nil and eventTrigger.paramData ~= nil then

        --点击选中单位  取消选中
        local contains=CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList:Contains(eventTrigger.paramData.id);
        if contains then

            CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList:Remove(eventTrigger.paramData.id);


            for i = 1, self.mCarrierItems:Count() do
                local cointasn=CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList:Contains(self.mCarrierItems[i].mData.id);
                if cointasn ==false then
                    self.mCarrierItems[i]:SeclectState(UICharacterItem.mSelectType.UnSelected);
                else
                    self.mCarrierItems[i]:SeclectState(UICharacterItem.mSelectType.Selected);
                end
            end


            return;
        end


        --如果选中列表的数量 等于 需要升星的数量 则无反应
        if CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList.Count == CarrierTrainNetCmdHandler.mStarUpNum  then
            return;
        end

        --该单位不在选中列表中，点击 选中
        if contains == false then
            CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList:Add(eventTrigger.paramData.id);
            eventTrigger.param:SeclectState(UICharacterItem.mSelectType.Selected);
            gfdebug("选中了 ID："..eventTrigger.paramData.id);

        end

        --检测是否满空闲仓位，满了的话  其余显示禁止选中

        if CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList.Count == CarrierTrainNetCmdHandler.mStarUpNum  then
            gfdebug("选满了！");

            for i = 1, self.mCarrierItems:Count() do

                local cointasn=CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList:Contains(self.mCarrierItems[i].mData.id);
                if cointasn ==false then
                    self.mCarrierItems[i]:SeclectState(UICharacterItem.mSelectType.Unusefull);
                end
            end

        end

    end
end


function UICarrierSelectionPanel.OnCarrierItemClick(gameobj)
    local btnTrigger = getcomponent(gameobj, typeof(CS.EventTriggerListener));
    if btnTrigger ~= nil then
        if btnTrigger.param ~= nil then
            local carrierItem = btnTrigger.param;
            local carrier = nil;
            if btnTrigger.paramData ~= nil then
                carrier = btnTrigger.paramData;
                if carrier ~= nil then
                    self.mIsSelectedCarrierItem = true;
                    self.mCurrentSelectCarrier = carrier;

                    --if carrier.team_id == self.mCurrentModifyTeamID then
                    --和上次点一样的
                    --if carrierItem.mObj_Select.activeSelf then
                    --    carrierItem:SetSelectEnable(false);
                    --    self.mIsSelectedCarrierItem = false;
                    --else
                    --    self.mCurrentSelectCarrier = carrier;
                    --    carrierItem:SetSelectEnable(true);
                    --    self.mIsSelectedCarrierItem = true;
                    --end
                    --else
                    --if carrier.team_id == 0 then
                    --if carrierItem.mObj_Select.activeSelf then
                    --    carrierItem:SetSelectEnable(false);
                    --    self.mIsSelectedCarrierItem = false;
                    --else
                    --    self.mCurrentSelectCarrier = carrier;
                    --    carrierItem:SetSelectEnable(true);
                    --   self.mIsSelectedCarrierItem = true;
                    --end
                    --end
                    --end

                    self:PrepareToSend();
                    --self.mLastSelectCarrierID = carrier.id;
                    --for i = 1, self.mCarrierItems:Count() do
                    --    if carrier.id ~= self.mCarrierItems[i].mData.id then
                    --        setactive(self.mCarrierItems[i].mObj_Select, false);
                    --    end
                    --end
                end
            end
        end
    end
end

function UICarrierSelectionPanel:PrepareToSend()
    local tip = "CAUTION";
    local title = "";
    --取消一个载具，并且【确认】修改后，有以下逻辑
    --if not self.mIsSelectedCarrierItem and self.mOriginalSelectCarrier ~= nil then
    --    title = "反选载具后，原编队将解散，是否确认？";
    --    self.mModCarrierCBType = CS.EModCarrierCallbackType.eDismiss;
    --    MessageBox.Show(tip, title, self.OnConfirmClick, self.OnCancelClick);
    --end

    --当A载重量＜B时，出现二次确认弹窗提示：更换载具后，原先的编队将解散，是否确认？点击【确认】后该梯队即解散，载具替换成功
    if self.mOriginalSelectCarrier ~= nil then
        if self.mCurrentSelectCarrier.team_id ~= 0 then
            title = UICNWords.IfReplaceCurTeam;
            MessageBox.Show(tip, title, nil, self.OnReplaceOtherCarrierConfirm, nil);
        else
            self:SendModeCarrierCmd(self.ModeGunCallBack);
        end
    else
        if self.mCurrentSelectCarrier.team_id ~= 0 then
            --选择了载具并且是新设置
            title = UICNWords.IfReplaceSure;
            MessageBox.Show(tip, title, nil, self.OnReplaceOtherCarrierConfirm, nil);
        else
            self:SendModeCarrierCmd(self.ModeGunCallBack);

        end
    end
end

function UICarrierSelectionPanel.OnReplaceOtherCarrierConfirm(gameobj)
    print("发送替换载具消息！")
    self:SendModeCarrierCmd(self.ModeGunCallBack);
end

--向服务起发送的始终是当前经过修改的队伍信息
function UICarrierSelectionPanel:SendModeCarrierCmd(callBack)
    --local guns = self.mNetTeamHandle:GetTeamById(self.mCurrentModifyTeamID);
    --
    --if guns == nil then
    --    self:SendModTeamReplace(callBack);
    --    return;
    --end
    --
    --local ids = List:New(CS.Cmd.GunMid)
    --for i, v in array_ipairs(guns) do
    --    if v ~= nil then
    --        local gunMid = CS.Cmd.GunMid();
    --        gunMid.gun_id = v.id;
    --        gunMid.m_id = v.m_id;
    --        ids:Add(gunMid);
    --    end
    --end

    CS.PlayerNetCmdHandler.Instance:SendModCarrierCmd(self.mCurrentModifyTeamID, self.mCurrentSelectCarrier.id, callBack);
end

function UICarrierSelectionPanel.OnDismissClick(gameobj)
    local title = UICNWords.Caution;
    local content = UICNWords.IfDismissTeam;
    MessageBox.Show(title, content, nil, self.OnDismissClickConfirm, nil);
end

function UICarrierSelectionPanel.OnDismissClickConfirm(gameobj)
    CS.PlayerNetCmdHandler.Instance:SendReqDismissTeam(self.mCurrentModifyTeamID, self.ModeGunCallBack);
end

function UICarrierSelectionPanel.OnConfirmClick()
    if self.mOriginalSelectCarrier == nil or self.mModCarrierCBType == CS.EModCarrierCallbackType.eNone then
        return
    end

    if self.mModCarrierCBType == CS.EModCarrierCallbackType.eDismiss then
        CS.PlayerNetCmdHandler.Instance:SendReqDismissTeam(self.mOriginalSelectCarrier.team_id, self.ModeGunCallBack);
    else
        if self.mModCarrierCBType == CS.EModCarrierCallbackType.eChangeDismiss then
            self:SendModTeamReplace(self.ModeGunCallBack);
        end
    end

    self.mModCarrierCBType = CS.EModCarrierCallbackType.eNone;
    self.mOriginalSelectCarrier = nil;
end

--载具荷载不足
function UICarrierSelectionPanel:SendModTeamReplace(callBack)
    CS.PlayerNetCmdHandler.Instance:SendModCarrierCmd(self.mCurrentSelectCarrier.id, self.mCurrentSelectCarrier.id, callBack);
end

function UICarrierSelectionPanel.ModeGunCallBack(ret)
    if ret == CS.CMDRet.eSuccess then
        self.Close();
    end
end

function UICarrierSelectionPanel:CarrierReturnClick(gameobj)
    self.Close();
end