---
--- Created by 6队.
--- DateTime: 18/8/9 16:04
---

require("UI.UIBaseView")
require("UI.Common.HeadViewItem")


UIDispatchTeamItem = class("UIDispatchTeamItem", UIBaseView);
UIDispatchTeamItem.__index = UIDispatchTeamItem;

--控件按照从左到右的顺序
UIDispatchTeamItem.mButton_Select = nil;
UIDispatchTeamItem.mRectTrans_Select = nil;

UIDispatchTeamItem.mText_TeamName = nil;
UIDispatchTeamItem.mText_CurTeamNum = nil;

UIDispatchTeamItem.mObject_SelectUsefull = nil;
UIDispatchTeamItem.mObject_SelectUnusefull = nil;
UIDispatchTeamItem.mObject_SelectSelecting = nil;

UIDispatchTeamItem.mText_CarrierName = nil;
UIDispatchTeamItem.mGrid_Level = nil;

UIDispatchTeamItem.mText_DayCombat = nil;
UIDispatchTeamItem.mText_NightCombat = nil;

UIDispatchTeamItem.mImage_Carrier = nil;
UIDispatchTeamItem.mImage_Hp = nil;

UIDispatchTeamItem.mGrid_Member = nil;
UIDispatchTeamItem.mButton_ToDetail = nil;

UIDispatchTeamItem.mObject_BackUsefull = nil;
UIDispatchTeamItem.mObject_BackUnusefull = nil;
UIDispatchTeamItem.mObject_BackSelecting = nil;

UIDispatchTeamItem.mSelectType = gfenum({"Selecting", "Usefull", "Unusefull"},-1);

UIDispatchTeamItem.mSelectMoveOffset = nil;
UIDispatchTeamItem.mOrgPosition = nil;

UIDispatchTeamItem.mText_Hint = nil;

UIDispatchTeamItem.mButton_Repair = nil;
UIDispatchTeamItem.mObj_GunList = nil;


UIDispatchTeamItem.mHeadViewItemList=nil;



function UIDispatchTeamItem:ctor()
    UIDispatchTeamItem.super.ctor(self);
end

function UIDispatchTeamItem:InitCtrl(root)

    self.mSelectMoveOffset = 45;
    self.mOrgPosition = CS.UnityEngine.Vector2.zero;
    local obj=instantiate(UIUtils.GetGizmosPrefab("Formation/DispatchDetilItem.prefab",self));

    self:SetRoot(obj.transform);
    setparent(root,obj.transform);
    obj.transform.localScale=vectorone;
    self.mButton_Select = self:GetButton("Common");
    self.mRectTrans_Select = self:GetRectTransform("Common");
    self.mOrgPosition =self.mRectTrans_Select.anchoredPosition;

    self.mText_TeamName = self:GetText("Common/TeamDetail/TeamName");
    self.mText_CurTeamNum = self:GetText("Common/TeamDetail/TeamMunber");

    self.mObject_SelectUsefull = self:FindChild("StatueIcon/Common");
    self.mObject_SelectUnusefull = self:FindChild("StatueIcon/CantUse");
    self.mObject_SelectSelecting = self:FindChild("StatueIcon/Chose");

    --Carrier
    self.mText_CarrierName = self:GetText("Common/TeamDetail/EchelonPanel/EchelonName");
    self.mGrid_Level = self:FindChild("Common/TeamDetail/TeamMunber");
    self.mText_DayCombat = self:GetText("Common/TeamDetail/EchelonPanel/TeamCombat/CommonCombat/Text");
    self.mText_NightCombat = self:GetText("Common/TeamDetail/EchelonPanel/TeamCombat/NightCombat/Text");
    self.mImage_Carrier = self:GetImage("Common/TeamDetail/EchelonPanel/EchelonIcon");
    self.mImage_Hp = self:GetImage("Common/TeamDetail/EchelonPanel/HpBG/HP");

    self.mGrid_Member = self:FindChild("Common/TeamDetail/GunList");
    self.mButton_ToDetail = self:GetButton("Common/EditTeamBtn");

    self.mObject_BackUsefull = self:FindChild("Common");
    self.mObject_BackUnusefull = self:FindChild("CantUse");
    self.mObject_BackSelecting = self:FindChild("ChosePanel");
    self.mButton_Repair=self:GetButton("CantUse/RepairButton");
    self.mObj_GunList=self:FindChild("Common/TeamDetail/GunList");
    self.mText_Hint=self:GetText("CantUse/Image/HintText");

    self.mHeadViewItemList=List:New();


end

function UIDispatchTeamItem:SetSelectType(selectType)
    local orgPos = self.mRectTrans_Select.anchoredPosition;

    if selectType == UIDispatchTeamItem.mSelectType.Selecting then
        setactive(self.mObject_BackUsefull, true);
        setactive(self.mObject_BackUnusefull, false);
        setactive(self.mObject_BackSelecting, true);

        setactive(self.mObject_SelectUsefull, false);
        setactive(self.mObject_SelectUnusefull, false);
        setactive(self.mObject_SelectSelecting, true);

        self.mRectTrans_Select.anchoredPosition =
        CS.UnityEngine.Vector2(self.mOrgPosition.x + self.mSelectMoveOffset, self.mOrgPosition.y);
    elseif selectType == UIDispatchTeamItem.mSelectType.Usefull then
        setactive(self.mObject_SelectUsefull, true);
        setactive(self.mObject_SelectUnusefull, false);
        setactive(self.mObject_SelectSelecting, false);

        setactive(self.mObject_BackUsefull, true);
        setactive(self.mObject_BackUnusefull, false);
        setactive(self.mObject_BackSelecting, false);

        self.mRectTrans_Select.anchoredPosition = self.mOrgPosition;
    elseif selectType == UIDispatchTeamItem.mSelectType.Unusefull then
        setactive(self.mObject_SelectUsefull, false);
        setactive(self.mObject_SelectUnusefull, true);
        setactive(self.mObject_SelectSelecting, false);

        setactive(self.mObject_BackUsefull, true);
        setactive(self.mObject_BackUnusefull, true);
        setactive(self.mObject_BackSelecting, false);
        self.mRectTrans_Select.anchoredPosition = self.mOrgPosition;
    end
end


function UIDispatchTeamItem:InitData(teamid)

    --载具
    gfdebug("teamid"..teamid)
    self.mText_CurTeamNum.text=UIUtils.StringFormat("{0:D2}",teamid);

    local cmd_carrier_data=CarrierNetCmdHandler:GetCarrierByTeamId(teamid);

    if cmd_carrier_data ~=nil then
        carrier_data=TableData.GetCarrierBaseBodyData(cmd_carrier_data.stc_carrier_id);
        if carrier_data ~=nil then
            self.mText_CarrierName.text = carrier_data.name;
            --self.mGrid_Level.text = cmd_carrier_data.level;
            self.mText_DayCombat.text = 0;
            self.mText_NightCombat.text = 0;
            self.mImage_Carrier.sprite =CS.IconUtils.GetIconSprite(2,carrier_data.icon);--CS.GF2Icon.Carrier
            if UIDispatchPanel.mPanelType ==nil then
                self.mImage_Hp.fillAmount =cmd_carrier_data.hp/cmd_carrier_data.prop.max_hp;
            else
                self.mImage_Hp.fillAmount = cmd_carrier_data.hp/cmd_carrier_data.prop.max_hp;
            end

        else
            gfdebug("找不到载具配置表数据ID"..cmd_carrier_data.stc_carrier_id)

        end
    else
        gfdebug("找不到载具服务器数据ID"..teamid)
    end


    --人形 头像 列表
    local gunArray=NetTeamHandle:GetTeamById(teamid);

    if gunArray ~=nil then
        gfdebug("找到了梯队的枪数据 teamID："..gunArray.Length)
        if gunArray.Length ~=0 then
            for i = 1, gunArray.Length do
                if i<= self.mHeadViewItemList:Count() then
                    self.mHeadViewItemList[i]:SetGunData(gunArray[i-1]);
                else
                    local veiw1=HeadViewItem.New();
                    veiw1:InitCtrl(self.mObj_GunList);
                    --local gundata= NetTeamHandle:GetGunByID(gunArray[i-1]);
                    veiw1:SetGunData(gunArray[i-1]);
                    self.mHeadViewItemList:Add(veiw1);
                end
            end
        end
    else
        gfdebug("找不梯队的枪数据 teamID："..teamid)
    end


    local hintstring=CampaignPool:CheckAddTeam(teamid);

    if UIDispatchPanel.mPanelType ==UIDispatchPanel.mPanelTypeEnum.SimCombat then
        hintstring =""
    end

    if hintstring =="" then
        self:SetSelectType(UIDispatchTeamItem.mSelectType.Usefull);
    else
        self:SetSelectType(UIDispatchTeamItem.mSelectType.Unusefull);
        self.mText_Hint.text=hintstring;

        setactive(self.mButton_Repair.gameObject,false);
        if hintstring=="当前载具血量为0"  then
            setactive(self.mButton_Repair.gameObject,true);
        end
        if hintstring =="梯队中所有人形血量为0"then
            setactive(self.mButton_Repair.gameObject,true);
        end
    end
 end




--endregion