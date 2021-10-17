---
--- Created by 6队.
--- DateTime: 18/8/9 16:03
---

require("UI.UIBaseView")



UICampaignMissionView = class("UICampaignMissionView", UIBaseView);
UICampaignMissionView.__index = UICampaignMissionView;


UICampaignMissionView.mButton_Return = nil;
UICampaignMissionView.mMissionListObj = nil;
UICampaignMissionView.mText_CurMissionName = nil;
UICampaignMissionView.mImage_CurMissionName = nil;
UICampaignMissionView.mText_CurMissionZoneName = nil;
UICampaignMissionView.mText_CurMissionDes = nil;
UICampaignMissionView.mText_CurMissionRequest = nil;
UICampaignMissionView.mText_CurMissionReward = nil;
UICampaignMissionView.mButton_CurMission = nil;
UICampaignMissionView.mImage_CurMission = nil;
UICampaignMissionView.mText_CurMission = nil;
UICampaignMissionView.mText_CurMissionNum = nil;
UICampaignMissionView.mImage_DetailIcon = nil;
UICampaignMissionView.mText_MissionType = nil;
UICampaignMissionView.mText_MissionLocation = nil;
UICampaignMissionView.mObj_MissionRewardList = nil;


function UICampaignMissionView:ctor()
    UICampaignMissionView.super.ctor(self);
end

function UICampaignMissionView:InitCtrl(root)

    self:SetRoot(root);

    self.mText_CurTeamNum = self:GetText("ChosenTeamText");

    self.mButton_Exit = self:GetButton("CloseButton");
    self.mButton_Confirm = self:GetButton("ConfirmButton");

    self.mGrid_TeamList = self:FindChild("TeamListMask/List");

    self.mButton_Return = self:GetButton("Return");


    self.mMissionListObj = self:FindChild("Missions/MissionList");

    self.mText_CurMissionName = self:GetText("MissionsDetail/MissionName/Text");
    self.mImage_CurMissionName=self:GetImage("MissionsDetail/MissionName");
    self.mText_CurMissionZoneName = self:GetText("MissionsDetail/MissionLocation/Text");
    self.mText_CurMissionDes = self:GetText("MissionsDetail/MissionDescription/Text");
    self.mText_CurMissionRequest = self:GetText("MissionsDetail/MissionRequest/RequestList/MissionRequestItem/Text");
    self.mText_CurMissionReward = self:GetText("MissionsDetail/MissionReward/Image/Text");
    self.mButton_CurMission = self:GetButton("MissionStart");
    self.mText_CurMissionNum=self:GetText("MissionFinishedNum/Num");

    self.mObj_MissionRewardList=self:FindChild("MissionsDetail/MissionReward/RewardList/List");

    self.mText_CurMission= self:GetText("MissionStart/Text");
    self.mText_MissionType=self:GetText("MissionsDetail/MissionType/Text");
    self.mImage_DetailIcon=self:GetImage("MissionsDetail/Icon");

    self.mImage_CurMission=self:GetImage("MissionStart");

    self.mText_MissionLocation=self:GetText("MissionsDetail/MissionLocation/Text");

    --拿到编队信息  刷新界面



end

