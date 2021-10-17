---
--- Created by firwg.
--- DateTime: 18/9/6 15:53
---

require("UI.UIBasePanel")
require("UI.Campaign.UICampaignMissionView")
require("UI.Common.RewardItem")

UICampaignMissionPanel = class("UICampaignMissionPanel", UIBasePanel);
UICampaignMissionPanel.__index = UICampaignMissionPanel;

UICampaignMissionPanel.mView=nil;

UICampaignMissionPanel.mMissionItemList=nil;--任务Item

UICampaignMissionPanel.mSelectID=nil;

UICampaignMissionPanel.mRewardItemList=nil;--任务Item





function UICampaignMissionPanel:ctor()
    UICampaignMissionPanel.super.ctor(self);
end

function UICampaignMissionPanel.Open()
    UIManager.OpenUI(UIDef.UICampaignMissionPanel);
end

function UICampaignMissionPanel.Close()
    UIManager.CloseUI(UIDef.UICampaignMissionPanel);
end

function UICampaignMissionPanel.Init(root, data)


    UICampaignMissionPanel.super.SetRoot(UICampaignMissionPanel,root);

    self = UICampaignMissionPanel;

    self.mView = UICampaignMissionView;
    self.mView:InitCtrl(root);

    CS.GF2.Message.MessageSys.Instance:AddListener(9002,self.UpdateMessage);

    UIUtils.GetListener(self.mView.mButton_Return.gameObject).onClick = self.OnExitBtnClick;
    UIUtils.GetListener(self.mView.mButton_CurMission.gameObject).onClick = self.CurMissionClick;

    self.mRewardItemList=List:New();
    self.mMissionItemList=List:New();
    self.mSelectID=0;

    local list=CampaignPool:GetCampaignMissionList();--拿到任务列表

    for i = 1, list.Count do
        local itemView=UICampaignMissionItem.New();
        itemView:InitCril(self.mView.mMissionListObj);
        self.mMissionItemList:Add(itemView);
        local mBtnClick=UIUtils.GetButtonListener(itemView.mButton_Select.gameObject);
        mBtnClick.onClick = self.SelectMissionClick;
        mBtnClick.param=list[i-1].mission_id;
        itemView.mMissionID=list[i-1].mission_id;
        mBtnClick:AddListener();
    end

    if (self.mSelectID ==0) then
        if list.Count >0 then
            self:SelectMission(list[0].mission_id);
        else
            gfdebug("没有任务列表 ");
        end
    end

end



--选择一个任务
function UICampaignMissionPanel.SelectMissionClick(gameobj)
    local mClick=UIUtils.GetButtonListener(gameobj);
    --改变当前选择的任务ID
    self = UICampaignMissionPanel;
    self:SelectMission(mClick.param);
end

function UICampaignMissionPanel:SelectMission(missionid)
    self = UICampaignMissionPanel;
    if self.mSelectID ~=missionid then
        for i = 1, self.mMissionItemList:Count() do
            if self.mMissionItemList[i].mMissionID==missionid then
                self.mMissionItemList[i]:SetSelected(true);
            elseif self.mMissionItemList[i].mMissionID~=missionid then
                self.mMissionItemList[i]:SetSelected(false);
            end
        end
        self.mSelectID=missionid;
        self:UpdateView();
    end

end






--当前任务的按钮的点击---开始任务---放弃任务--已在任务中
function UICampaignMissionPanel.CurMissionClick(gameobj)
    self=UICampaignMissionPanel;
    local mission= CampaignPool:GetCampaingMissonByID(self.mSelectID);
    local tempmission=CampaignPool:GetCurCampaingMisson();
    local missionData=TableData.listCampaignMissionDatas:GetDataById(self.mSelectID);

    if missionData ~=nil and mission ~=nil  then
        if mission.state ==1 then
            --messagebox  放弃任务

            local info = "确认放弃该任务？放弃任务会使当前战区重置。";
            MessageBox.Show("放弃任务", info, mission, self.OnGiveUpTaskConfirm);

        else
            if tempmission~=nil then


            else
                --如果当前没有任务
                --messagebox  开始任务
                CampaignPool:SendReqCampaignMissionAccept(self.mSelectID);
            end
        end
    else
        gfdebug("没有任务数据！ID："..self.mSelectID);
    end


end



function UICampaignMissionPanel.OnGiveUpTaskConfirm(data)
    self = UICampaignMissionPanel;
    if data ~= nil then
        CampaignPool:SendReqCampaignMissionAbort(data.mission_id);
    end
end



--消息监听
function UICampaignMissionPanel.UpdateMessage(msg)
    self = UICampaignMissionPanel;
    self:UpdateView();
end


--界面刷新
function UICampaignMissionPanel:UpdateView()
    self=UICampaignMissionPanel;
    if (self.mSelectID ~=0) then


        --详细面板更新
        local mission= CampaignPool:GetCampaingMissonByID(self.mSelectID);
        local missionData=TableData.listCampaignMissionDatas:GetDataById(self.mSelectID);

        if missionData ~=nil and mission ~=nil  then

            local missionZoneData=TableData.listCampaignZoneDatas:GetDataById(missionData.zone_id);

            self.mView.mText_CurMissionName.text = missionData.name;
            self.mView.mText_CurMissionZoneName.text = missionData.zone_id;
            self.mView.mText_CurMissionDes.text = missionData.description;
            self.mView.mText_CurMissionRequest.text = nil;
            --self.mView.mText_CurMissionReward.text = missionData.prize_reward;
            self.mView.mText_CurMissionNum.text=mission.times;
            self.mView.mText_MissionLocation.text = missionZoneData.name;


            if missionData.type==1 then
                self.mView.mImage_DetailIcon.sprite=CS.ResSys.Instance:GetSprite("MissionIcon/Campaign_Mission_Icon_MainQuest");
                self.mView.mImage_CurMissionName.color=CS.GF2.UI.UITool.StringToColor("FF5500FF");
                self.mView.mText_MissionType.text="主线";

            elseif missionData.type==2 then
                self.mView.mImage_DetailIcon.sprite=CS.ResSys.Instance:GetSprite("MissionIcon/Campaign_Mission_Icon_SideQuest");
                self.mView.mImage_CurMissionName.color=CS.GF2.UI.UITool.StringToColor("219CA7FF");
                self.mView.mText_MissionType.text="支线";
            end



            if mission.state ==1 then
                self.mView.mText_CurMission.text="放弃任务";
                self.mView.mImage_CurMission.color=CS.GF2.UI.UITool.StringToColor("ff5967FF");
            else
                local tempmission=CampaignPool:GetCurCampaingMisson();
                if tempmission~=nil then
                    self.mView.mText_CurMission.text="已有任务进行中";
                    self.mView.mImage_CurMission.color=CS.GF2.UI.UITool.StringToColor("FFFFFF80");
                else
                    self.mView.mText_CurMission.text="开始任务";
                    self.mView.mImage_CurMission.color=CS.GF2.UI.UITool.StringToColor("FFB400FF");
                end
            end



            --任务奖励
            for i = 1, self.mRewardItemList:Count() do
                self.mRewardItemList[i]:SetData(nil);
            end



            local prizeData = missionData:GetPrizeDataByTimes(mission.times);

            if prizeData ~=nil then
                for i = 1, prizeData.itemlist.Count do
                    local rewardItem;
                    if i<=self.mRewardItemList:Count() then
                        rewardItem=self.mRewardItemList[i];
                    else
                        rewardItem =RewardItem.New();
                        rewardItem:InitCtrl(self.mView.mObj_MissionRewardList);
                        self.mRewardItemList:Add(rewardItem);
                    end

                    rewardItem:SetData(prizeData.itemlist[i-1]);

                end
            else
                gfdebug("没有奖励配置数据！ID："..self.mSelectID);
            end



        else
            gfdebug("没有任务数据！ID："..self.mSelectID);
        end


        --列表Item刷新
        for i = 1, self.mMissionItemList:Count() do
            local mBtnClick=UIUtils.GetButtonListener(self.mMissionItemList[i].mButton_Select.gameObject);
            local mission= CampaignPool:GetCampaingMissonByID(mBtnClick.param);
            self.mMissionItemList[i]:InitData(mission);
        end
    else
        gfdebug("当前没有选中的任务！");
    end



end


--返回上级菜单
function UICampaignMissionPanel.OnExitBtnClick(gameObject)
    UICampaignMissionPanel.Close();
end



function UICampaignMissionPanel.OnRelease()
    self = UICampaignMissionPanel;
    CS.GF2.Message.MessageSys.Instance:RemoveListener(9002,self.UpdateMessage);
end



