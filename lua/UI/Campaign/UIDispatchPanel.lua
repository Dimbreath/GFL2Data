---
--- Created by 6队.
--- DateTime: 18/8/9 15:53
---

require("UI.UIBasePanel");
require("UI.Campaign.UIDispatchView")
require("UI.Campaign.Item.UIDispatchTeamItem")

UIDispatchPanel = class("UIDispatchCtrl", UIBasePanel);
UIDispatchPanel.__index = UIDispatchPanel;
UIDispatchPanel.mTeamItemList=nil;
UIDispatchPanel.mTeamItemIDList=nil;


UIDispatchPanel.mLastIndex=nil;

UIDispatchPanel.mCurSelectTeamID=nil;


---panel用途  nil 用于大地图 1 用于 模拟作战
UIDispatchPanel.mPanelTypeEnum = gfenum({"SLG","SimCombat"},0)
UIDispatchPanel.mPanelType = nil;
UIDispatchPanel.mNetTeamHandle = nil;

function UIDispatchPanel:ctor()
    UIDispatchPanel.super.ctor(self);
end

function UIDispatchPanel.Open()
    UIDispatchPanel.mNetTeamHandle = CS.NetCmdTeamData.Instance;
    UIManager.OpenUI(UIDef.UIDispatchPanel);
end

function UIDispatchPanel.Close()
    self=UIDispatchPanel;

    UIDispatchPanel.mNetTeamHandle = nil;
    UIDispatchPanel.mPanelType = nil;
    CS.GF2.Message.MessageSys.Instance:RemoveListener(9001,self.UpdateMessage);
    UIManager.CloseUI(UIDef.UIDispatchPanel);
    gfwarning("Dispatch Close!")
end

function UIDispatchPanel.Init(root, data)
    if UIDispatchPanel.mPanelType == nil then
        UIDispatchPanel.mPanelType = UIDispatchPanel.mPanelTypeEnum.SLG
    end

    UIDispatchPanel.mNetTeamHandle = CS.NetCmdTeamData.Instance;
    UIDispatchPanel.super.SetRoot(UIDispatchPanel, root);
    self = UIDispatchPanel;

    self.mUIRoot=root;
    self.mView = UIDispatchView;
    self.mView:InitCtrl(root);

    self.mLastIndex=0;

    CS.GF2.Message.MessageSys.Instance:AddListener(9001,self.UpdateMessage);

    UIUtils.GetListener(self.mView.mButton_Exit.gameObject).onClick = self.OnExitBtnClick;
    UIUtils.GetListener(self.mView.mButton_Confirm.gameObject).onClick = self.OnConfirmBtnClick;


    local mTeamIDList= NetTeamHandle:GetTeamIDList();

    self.mTeamItemList=List:New();
    self.mTeamItemIDList=List:New();


    for i = 1, mTeamIDList.Count do
        if mTeamIDList[i-1]  ~= 100 then --过滤母基地梯队
            local itemView=UIDispatchTeamItem.New();
            local m=self.mView.mGrid_TeamList;

            if self.mView.mGrid_TeamList ~=nil then

                itemView:InitCtrl(self.mView.mGrid_TeamList);
                self.mTeamItemList:Add(itemView);
                local mBtnClick=UIUtils.GetButtonListener(itemView.mButton_Select.gameObject);
                mBtnClick.onClick = self.SelectTeamClick;
                mBtnClick.param=mTeamIDList[i-1];
                mBtnClick.paramIndex=i;
                UIUtils.GetListener(itemView.mButton_Repair.gameObject).onClick =self.RepairClick;
                UIUtils.GetListener(itemView.mButton_Repair.gameObject).param =mTeamIDList[i-1];
            end
        end
    end


    setactive(self.mView.mText_CurTeamNum, false);
    self.mView.mText_CurTeamNum.text="";
    self.mCurSelectTeamID=0;

    self:UpdateView();

    self.mView.mButton_Confirm.interactable=false;
end



--选择一个点伍
function UIDispatchPanel.SelectTeamClick(gameobj)

    self=UIDispatchPanel;
    local teamClick=UIUtils.GetButtonListener(gameobj)


    --如果不在可派遣范围则  什么都不干
    if self.mPanelType ==self.mPanelTypeEnum.SLG then
        if CampaignPool:CheckAddTeam(teamClick.param) ~="" then

            return;
        end
    end


    if (self.mLastIndex ~=0) then
        self.mTeamItemList[self.mLastIndex]:SetSelectType(UIDispatchTeamItem.mSelectType.Usefull);
    end

    self.mTeamItemList[teamClick.paramIndex]:SetSelectType(UIDispatchTeamItem.mSelectType.Selecting);
    self.mLastIndex=teamClick.paramIndex;
    self.mView.mText_CurTeamNum.text=UIUtils.StringFormat("{0:D2}",teamClick.param);
    self.mCurSelectTeamID=teamClick.param;
    self.mView.mButton_Confirm.interactable=true;
    setactive(self.mView.mText_CurTeamNum,true);
    --gfdebug("SelectTeam:"..teamClick.param);
end



function UIDispatchPanel.UpdateMessage(msg)

    self = UIDispatchPanel;
    gfwarning("MessageUpdate!")
    self:UpdateView();

end


function UIDispatchPanel:UpdateView()


    local mTeamIDList= NetTeamHandle:GetTeamIDList();


    for i = 1, self.mTeamItemList:Count() do

        self.mTeamItemList[i]:InitData(mTeamIDList[i-1]);

    end

end







function UIDispatchPanel.OnExitBtnClick(gameObject)
    UIDispatchPanel.Close();
end

function UIDispatchPanel.OnConfirmBtnClick(gameObject)

    self=UIDispatchPanel;
    if self.mCurSelectTeamID == 0 then
        return;
    end
    local guns = self.mNetTeamHandle:GetTeamById(self.mCurSelectTeamID);
    if guns ~= nil then

        local hasMember = false;
        for i = 1, guns.Length do
            if guns[i - 1] ~= nil then
                hasMember = true;
                break;
            end
        end

        if guns.Length == 0 or not hasMember then
            MessageBox.Show("注意", "当前编队没有乘客", nil, nil);
            return;
        end



    end
    --大地图
    if self.mPanelType ==self.mPanelTypeEnum.SLG then
        if self.mCurSelectTeamID ~=0 then

            CampaignPool:AddTeamFormLua(self.mCurSelectTeamID);

            self:Close();

        end
    --模拟作战
    else


        if UISimCombatPanel.HaveEnoughStamina() then
            UIDispatchPanel:Close();
            -- NetCmdSimulateBattleData:StartSimCombat(UISimCombatPanel.currentSelectedStageID,UIDispatchPanel.mCurSelectTeamID)
        else
            local storeGoods = NetCmdStoreData:GetStoreGoodById(1)
            if storeGoods.remain_times <1 then
                MessageBox.Show("注意","体力不足！无法开始战斗！",MessageBox.ShowFlag.eMidBtn)
                return
            else
                QuickStorePurchase.QuickPurchase(1,1,201,UISimCombatPanel,UISimCombatPanel.UpdateSimStamina,"体力x100",storeGoods.remain_times)
            end

        end


    end

end





function UIDispatchPanel.RepairClick(gameobj)

    local eventClick=UIUtils.GetListener(gameobj);


    local value=CampaignPool:TryCalRepairAllInTeamByTeamid(eventClick.param);

    if value then
        UIManager.OpenUI(UIDef.UIRepairConfirmPanel);
    end

end