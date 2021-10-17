---
--- Created by firwg.
--- DateTime: 18/9/9 15:53
---

require("UI.UIBasePanel")
require("UI.Campaign.UIMaintainView")


UIMaintainPanel = class("UIMaintainPanel", UIBasePanel);

UIMaintainPanel.__index = UIMaintainPanel;
UIMaintainPanel.mView=nil;
UIMaintainPanel.mMaintainItemList=nil;--维护列表


function UIMaintainPanel:ctor()
    UIMaintainPanel.super.ctor(self);
end

function UIMaintainPanel.Open()
    UIManager.OpenUI(UIDef.UIMaintainPanel);
end

function UIMaintainPanel.Close()
    CS.GF2.Message.MessageSys.Instance:RemoveListener(9003,self.UpdateMessage);
    CS.GF2.Message.MessageSys.Instance:RemoveListener(4003,self.UpdateHeartMessage);
    CS.GF2.Message.MessageSys.Instance:RemoveListener(5000,self.UpdateResView);
    UIManager.CloseUI(UIDef.UIMaintainPanel);
end

function UIMaintainPanel.Init(root, data)

    UIMaintainPanel.super.SetRoot(UIMaintainPanel,root);
    self = UIMaintainPanel;

    self.mView = UIMaintainView;
    self.mView:InitCtrl(root);

    UIUtils.GetListener(self.mView.mButton_Return.gameObject).onClick = self.OnExitBtnClick;

    CS.GF2.Message.MessageSys.Instance:AddListener(9003,self.UpdateMessage);
    CS.GF2.Message.MessageSys.Instance:AddListener(4003,self.UpdateHeartMessage);
    CS.GF2.Message.MessageSys.Instance:AddListener(5000,self.UpdateResView);



    local mAllBtnClick=UIUtils.GetButtonListener(self.mView.mButton_MaintainAll.gameObject);
    mAllBtnClick.onClick = self.AccAllGunMaintainClick;


    self.mMaintainItemList=List:New();
    local list=CampaignPool:GetCampaignMissionList();--拿到维护列表


    local num=TableData:GetMaintainTotalNum();

    --根据配置表 生成所有槽位，包括未解锁
    for i = 1, num do
        local itemView=MaintainViewItem.New();
        itemView:InitCtrl(self.mView.mTrans_ItemList);
        self.mMaintainItemList:Add(itemView);
        local mBtnClick=UIUtils.GetButtonListener(itemView.mButtonAccMaintain.gameObject);
        mBtnClick.onClick = self.AccGunMaintainClick;
        local mBtnAddClick=UIUtils.GetButtonListener(itemView.mButtonAdd.gameObject);
        mBtnAddClick.onClick = self.AddGunMaintainClick;
    end

    self:UpdateView();
end


--消息监听
function UIMaintainPanel.UpdateMessage(msg)
    self:UpdateView();
end

--消息监听
function UIMaintainPanel.UpdateHeartMessage(msg)

    local maintainGunList=NetTeamHandle:GetGunMaintainList();

    for i = 1, self.mMaintainItemList:Count() do
        --如果是当前维护的列表中
        if i<(maintainGunList.Count+1)then
            gunMaintain= maintainGunList[i-1];
            local time=gunMaintain.end_time-CS.CGameTime.Instance:GetTimestamp();
            if (time>0) then
                self.mMaintainItemList[i].mTextMaintainTime.text =tostring(CS.CGameTime.ReturnDurationBySec(time));
            end
        else

        end
    end
end


function UIMaintainPanel.UpdateResView(msg)

    local MTP=NetCmdItemData:GetItemCount(109);
    local Diomand=NetTeamHandle:GetMaintainResDiomandNum();

    self.mView.mText_ResMTPNum.text = MTP;
    self.mView.mText_ResDiamondNum.text = tostring(Diomand);

end





--界面刷新
function UIMaintainPanel:UpdateView()
    --资源信息更新

    local SpaceNum=NetTeamHandle:GetMyGunMaintainSpaceNum();
    local maintainGunList=NetTeamHandle:GetGunMaintainList();
    local MTP=NetCmdItemData:GetItemCount(109);
    local Diomand=NetTeamHandle:GetMaintainResDiomandNum();
    local num=TableData:GetMaintainTotalNum();

    self.mView.mText_ResMTPNum.text = MTP;
    self.mView.mText_ResDiamondNum.text = tostring(Diomand);
    self.mView.mText_UsedNum.text = "<color=#FFB400FF>"..tostring(maintainGunList.Count).."</color>/"..tostring(SpaceNum);


    for i = 1, self.mMaintainItemList:Count() do

        if (i<=SpaceNum) then
            --如果是当前维护的列表中
            if i<(maintainGunList.Count+1)then
                gunMaintain= maintainGunList[i-1];
                local mAccBtnClick=UIUtils.GetButtonListener(self.mMaintainItemList[i].mButtonAccMaintain.gameObject);
                mAccBtnClick.param=gunMaintain.gun_id;
                local mAddBtnClick=UIUtils.GetButtonListener(self.mMaintainItemList[i].mButtonAdd.gameObject);
                mAddBtnClick.param=gunMaintain.gun_id;
                local gundata=NetTeamHandle:GetGunByID(gunMaintain.gun_id);
                self.mMaintainItemList[i]:SetData(gundata);
            else
                self.mMaintainItemList[i]:SetData(nil);
            end
        end
    end

    self:UpdateHeartMessage(nil);

end



--在空的槽位添加一个
function UIMaintainPanel.AddGunMaintainClick(gameobj)
    local mClick=UIUtils.GetButtonListener(gameobj);
    self.Close();
    UICharacterSelectionPanel.OpenByPre(UIDef.UIMaintainPanel, false);
end

--加速一个
function UIMaintainPanel.AccGunMaintainClick(gameobj)
    self =UIMaintainPanel;
    local mClick=UIUtils.GetButtonListener(gameobj);
    --gfdebug(mClick.param);

    local num=0;

    num=TableData.GetGunQuickMaintainResDiamondNum(mClick.param);

    MessageBox.ShowDiamondMsg("快速维护消耗",tostring(num),"确定","取消",MessageBox.ShowFlag.eNone,mClick.param,self.AccGunMaintainConfirm, nil);
end

--加速一个 确定
function UIMaintainPanel.AccGunMaintainConfirm(data)
    NetTeamHandle:SendReqGunQuicklyMaintain(data);
end


--加速所有
function UIMaintainPanel.AccAllGunMaintainClick(gameobj)
    self=UIMaintainPanel;
    --计算所有需要消耗的钻石
    local DiamondNum=0;

    local maintainGunList=NetTeamHandle:GetGunMaintainList();

    if maintainGunList.Count ~=0 then
        for i = 1, maintainGunList.Count do
            local num=TableData.GetGunQuickMaintainResDiamondNum(maintainGunList[i-1].gun_id);
            DiamondNum=DiamondNum+num;
        end
        MessageBox.ShowDiamondMsg("快速维护消耗",tostring(DiamondNum),"确定","取消",MessageBox.ShowFlag.eNone,nil,self.AccAllGunMaintainConfirm, nil);
    else
        gfdebug("不存在可以加速维护的对象！");
    end


end

--加速所有 确定
function UIMaintainPanel.AccAllGunMaintainConfirm(data)
    NetTeamHandle:SendReqAllGunQuicklyMaintain();
end



--返回上级菜单
function UIMaintainPanel.OnExitBtnClick(gameObject)
    UIMaintainPanel.Close();
end

