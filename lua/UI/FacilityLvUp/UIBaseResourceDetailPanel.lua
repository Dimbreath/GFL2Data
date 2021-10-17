---
--- Created by Administrator.
--- DateTime: 18/12/10 17:50
---
require("UI.UIBasePanel")
require("UI.UIManager")
require("UI.UITweenCamera")


UIBaseResourceDetailPanel = class("UIBaseResourceDetailPanel", UIBasePanel);
UIBaseResourceDetailPanel.__index = UIBaseResourceDetailPanel;

UIBaseResourceDetailPanel.mView = nil;


UIBaseResourceDetailPanel.mResFacilityListItemList=nil;


function UIBaseResourceDetailPanel:ctor()
    UIBaseResourceDetailPanel.super.ctor(self);
end

function UIBaseResourceDetailPanel.Open()
    UIManager.OpenUI(UIDef.UIBaseResourceDetailPanel);
end

function UIBaseResourceDetailPanel.Close()
    UIManager.CloseUI(UIDef.UIBaseResourceDetailPanel);
end

function UIBaseResourceDetailPanel.Init(root, data)

    UIBaseResourceDetailPanel.super.SetRoot(UIBaseResourceDetailPanel, root);

    self = UIBaseResourceDetailPanel;
    self.mView = UIBaseResourceDetailPanelView;
    self.mView:InitCtrl(root);
end






function UIBaseResourceDetailPanel.OnInit()
    self = UIBaseResourceDetailPanel;

    self.mResFacilityListItemList=List:New();


    UIUtils.GetButtonListener(self.mView.mBtn_DetailReturn.gameObject).onClick =self.ReturnClick;

    UIUtils.GetButtonListener(self.mView.mBtn_FacilityLvUpShortCut.gameObject).onClick =self.FacilityLvUpClick;
    UIUtils.GetButtonListener(self.mView.mBtn_CollectBtn.gameObject).onClick =self.CollectBtnClick;



    CS.GF2.Message.MessageSys.Instance:AddListener(4003,self.UpdateHeartMessage);





    self:UpdateView(nil);

end


--心跳消息监听
function UIBaseResourceDetailPanel.UpdateHeartMessage(msg)
    self=UIBaseResourceDetailPanel;
    self:UpdateView(nil);
end



function UIBaseResourceDetailPanel.UpdateView(msg)
    self = UIBaseResourceDetailPanel;

    --拿数据
    local facilityDatas=NetCmdFacilityData:GetProdResFacilityList();

    --
    for i = 1, self.mResFacilityListItemList:Count() do
        self.mResFacilityListItemList[i]:SetData(nil);
    end

    for i = 1, facilityDatas.Count do
        local facilityData=facilityDatas[i-1];
        if facilityData.id ~= 0 then
            if i <=self.mResFacilityListItemList:Count() then
                self.mResFacilityListItemList[i]:SetData(facilityData);
            else
                local view=ResFacilityListItem:New();
                view:InitCtrl(self.mView.mTrans_ResFacilityList);
                view:SetData(facilityData);
                self.mResFacilityListItemList:Add(view);
            end
        else
            gferror("UIBaseResourceDetailPanel 并不存在id为0的设施！");
        end
    end


end



function UIBaseResourceDetailPanel.OnShow()
    self = UIBaseResourceDetailPanel;
end



function UIBaseResourceDetailPanel.OnFacilityNodeClick(obj)
    self=UIBaseResourceDetailPanel;
    local mBtnClick=UIUtils.GetButtonListener(obj);
    if mBtnClick ~=nil then
        setactive(self.mView.mTrans_LevelUpDetail,true);
        self.mSelectFacilityID=mBtnClick.param;
        self:UpdateLevelUpDetailView();
        else
        gferror("找不到Button组件！");
    end
end




--打开设施规划界面
function UIBaseResourceDetailPanel.FacilityLvUpClick(obj)
    --self = UIBaseResourceDetailPanel;
    UIFacilityLvUpPanel.Open();
end



--资源收集
function UIBaseResourceDetailPanel.CollectBtnClick(obj)
    self = UIBaseResourceDetailPanel;
    NetCmdFacilityData:SendReqFacilityCollect(self.CollectComplete);

end

function UIBaseResourceDetailPanel.CollectComplete(ret)
    self = UIBaseResourceDetailPanel;
    self:UpdateView(nil);

    UIBaseCollectResResultPanel.Open();
end



--关闭界面
function UIBaseResourceDetailPanel.ReturnClick(obj)
    self = UIBaseResourceDetailPanel;
    UIBaseResourceDetailPanel.Close();
end



function UIBaseResourceDetailPanel.OnRelease()
    self = UIBaseResourceDetailPanel;

    CS.GF2.Message.MessageSys.Instance:RemoveListener(4003,self.UpdateHeartMessage);
    --CS.GF2.Message.MessageSys.Instance:RemoveListener(9006,self.UpdateHeartMessage);

end




