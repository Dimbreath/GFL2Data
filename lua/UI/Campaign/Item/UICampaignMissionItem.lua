---
--- Created by firwg.
--- DateTime: 18/8/9 16:04
---

require("UI.UIBaseView")
require("UI.Common.HeadViewItem")


UICampaignMissionItem = class("UICampaignMissionItem", UIBaseView);
UICampaignMissionItem.__index = UICampaignMissionItem;

--控件按照从左到右的顺序
UICampaignMissionItem.mObj_Root = nil;

UICampaignMissionItem.mText_MissionName = nil;
UICampaignMissionItem.mText_Progress = nil;
UICampaignMissionItem.mText_suggest_lv = nil;

UICampaignMissionItem.mObj_Progress = nil;
UICampaignMissionItem.mButton_Select = nil;
UICampaignMissionItem.mObj_Finished = nil;
UICampaignMissionItem.mMissionID = nil;
UICampaignMissionItem.mObj_Selected = nil;
UICampaignMissionItem.mImg_Top = nil;
UICampaignMissionItem.mImg_Icon = nil;

function UICampaignMissionItem:ctor()
    UICampaignMissionItem.super.ctor(self);
end

function UICampaignMissionItem:InitCril(root)

    local obj=instantiate(UIUtils.GetGizmosPrefab("CampaignMission/MissionItem.prefab",self));

    self:SetRoot(obj.transform);
    setparent(root,obj.transform);
    obj.transform.localScale=vectorone;

    --Carrier
    self.mText_MissionName = self:GetText("Root/MissionName");
    self.mText_suggest_lv = self:GetText("Root/SuggestLevel/Num");

    self.mObj_Progress=self:FindChild("Root/InProgress");
    self.mText_Progress = self:GetText("Root/InProgress/Text");
    self.mObj_Finished=self:FindChild("Root/Finished");
    self.mObj_Root=self:GetRectTransform("Root");
    self.mButton_Select = self:GetSelfButton();

    self.mImg_Icon = self:GetImage("Root/Icon");
    self.mObj_Selected = self:FindChild("Root/Selected");
    self.mImg_Top = self:GetImage("Root/Background/Top");


end


function UICampaignMissionItem:InitData(mission)

    local missionData=TableData.listCampaignMissionDatas:GetDataById(mission.mission_id);

    self.mText_MissionName.text =missionData.name;
    self.mText_suggest_lv.text=missionData.suggest_lv;

    --主线
    if missionData.type==1 then
        self.mImg_Top.color=CS.GF2.UI.UITool.StringToColor("FF5500FF");

        self.mImg_Icon.sprite=CS.UISystem.Instance.mCampaignAtlas:GetSprite("Campaign_Mission_Icon_MainQuest_s");
        --CS.UISystem.Instance.mCampaignAtlas.GetSprite("Campaign_Mission_Icon_MainQuest_s");
        --CS.ResSys.Instance.GetSprite("MissionIcon/Campaign_Mission_Icon_MainQuest");
    elseif missionData.type==2 then
        self.mImg_Top.color=CS.GF2.UI.UITool.StringToColor("219CA7FF");
        self.mImg_Icon.sprite=CS.UISystem.Instance.mCampaignAtlas:GetSprite("Campaign_Mission_Icon_SideQuest_s");
        --CS.ResSys.Instance.GetSprite("MissionIcon/Campaign_Mission_Icon_SideQuest");
    end



    if mission.state==1 then
        --self.mText_Progress.text="进行中";
        setactive(self.mObj_Progress,true);
        setactive(self.mObj_Finished,false);
    elseif mission.state==2 then
        --self.mText_Progress.text="未完成";
        setactive(self.mObj_Progress,false);
        setactive(self.mObj_Finished,false);
    end
    if mission.state==3 then
        setactive(self.mObj_Progress,false);
        setactive(self.mObj_Finished,true);
    end



end


function UICampaignMissionItem:SetSelected(active)

    if active==true then
        self.mObj_Root.anchoredPosition=CS.UnityEngine.Vector2(35,0);
        setactive(self.mObj_Selected,true);
    elseif active==false then
        self.mObj_Root.anchoredPosition=CS.UnityEngine.Vector2.zero;
        setactive(self.mObj_Selected,false);
    end

end

--endregion