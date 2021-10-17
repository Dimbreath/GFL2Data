---
--- Created by Administrator.
--- DateTime: 18/11/29 17:50
---
require("UI.UIBasePanel")
require("UI.UIManager")
require("UI.UITweenCamera")


UIFacilityLvUpPanel = class("UIFacilityLvUpPanel", UIBasePanel);
UIFacilityLvUpPanel.__index = UIFacilityLvUpPanel;


UIFacilityLvUpPanel.mView = nil;


UIFacilityLvUpPanel.mFacilityLvUpNodeDic=nil;
UIFacilityLvUpPanel.mFacilityLvUpLineList=nil;
UIFacilityLvUpPanel.mSelectFacilityID=nil;

UIFacilityLvUpPanel.mFacilityLvUpListItemList=nil;--升级显示属性选项列表

UIFacilityLvUpPanel.mFacilityLvUpReqItemList=nil;--升级需求项目列表


function UIFacilityLvUpPanel:ctor()
    UIFacilityLvUpPanel.super.ctor(self);
end

function UIFacilityLvUpPanel.Open()
    UIManager.OpenUI(UIDef.UIFacilityLvUpPanel);
end

function UIFacilityLvUpPanel.Close()
    UIManager.CloseUI(UIDef.UIFacilityLvUpPanel);
end

function UIFacilityLvUpPanel.Init(root, data)

    UIFacilityLvUpPanel.super.SetRoot(UIFacilityLvUpPanel, root);

    self = UIFacilityLvUpPanel;
    self.mView = UIFacilityLvUpPanelView;
    self.mView:InitCtrl(root);
end






function UIFacilityLvUpPanel.OnInit()
    self = UIFacilityLvUpPanel;
    self.mFacilityLvUpNodeDic=Dictionary:New();
    self.mFacilityLvUpLineList=List:New();


    self.mFacilityLvUpListItemList=List:New();
    self.mFacilityLvUpReqItemList=List:New();


    UIUtils.GetButtonListener(self.mView.mBtn_DetailReturn.gameObject).onClick =self.CloseLevelUpDetailView;
    UIUtils.GetButtonListener(self.mView.mBtn_LvUpButton.gameObject).onClick =self.LvUpClick;
    UIUtils.GetButtonListener(self.mView.mBtn_LvUpButtonFast.gameObject).onClick =self.FastLvUpClick;

    UIUtils.GetButtonListener(self.mView.mBtn_Return.gameObject).onClick =self.ReturnClick;



    CS.GF2.Message.MessageSys.Instance:AddListener(4003,self.UpdateHeartMessage);
    CS.GF2.Message.MessageSys.Instance:AddListener(9006,self.UpdateHeartMessage);


    local facilityDatas=TableData.listFacilityDatas:GetList();

    for i = 1, facilityDatas.Count do
        local facilityData=facilityDatas[i-1];
        if facilityData.id ~= 0 then

            local  facObj=self.mView:FindChild("PanelRoot/FacilityLvUpTreePanel/FacilityLvUpTree/FacilityLvUpNode"..facilityData.id);
            if facObj ~=nil then
                local facNode=FacilityLvUpNode:New();
                facNode:InitCtrl(facObj.transform);

                self.mFacilityLvUpNodeDic:Add(facilityData.id,facNode);
                local mBtnClick=UIUtils.GetButtonListener(facObj);
                mBtnClick.onClick = self.OnFacilityNodeClick;
                mBtnClick.param=facilityData.id;

                --升级线条
                local cmdData=NetCmdFacilityData:GetFacilityCmdDataById(facilityData.id);
                if cmdData ~=nil then
                    local facilityPropertyData=TableData.GetFacilityPropertyData(facilityData.id,cmdData.level);
                    if facilityPropertyData ~=nil then
                        for i = 1, facilityPropertyData.mLineIDList.Count do
                            local lineID=facilityPropertyData.mLineIDList[i-1].lineID;
                            local lineData=facilityPropertyData.mLineIDList[i-1];
                            local  facObj=self.mView:FindChild("PanelRoot/FacilityLvUpTreePanel/FacilityLvUpTree/FacilityLvUpLine"..lineID);
                            if facObj ~=nil then
                                local facLine=FacilityLvUpLine:New();
                                facLine:InitCtrl(facObj,lineData.startfacilityID,lineData.endfacilityID);
                                self.mFacilityLvUpLineList:Add(facLine);
                            else
                                gferror("[设施升级树] 找不到 线ID："..lineID);
                            end
                        end
                    else
                        gferror("[设施升级树]不存在配置数据 ID："..facilityData.id.."Level:"..cmdData.level);
                    end

                else
                    gferror("[设施升级树]不存在服务器设施数据 ID："..facilityData.id);
                end
            else
                gferror("[设施升级界面] 缺少FacilityLvUpNode"..facilityData.id.."组件");
            end
        end
    end




    self:UpdateView(nil);


end


--心跳消息监听
function UIFacilityLvUpPanel.UpdateHeartMessage(msg)
    self=UIFacilityLvUpPanel;

    self:UpdateView(nil);


    if self.mView.mTrans_LevelUpDetail.gameObject.activeInHierarchy == true then
        self:UpdateLevelUpDetailView();
    end


end



function UIFacilityLvUpPanel.UpdateView(msg)
    self = UIFacilityLvUpPanel;

    local facilityDatas=TableData.listFacilityDatas:GetList();

    --Node
    for i = 1, facilityDatas.Count do
        local facilityData=facilityDatas[i-1];
        if facilityData.id ~= 0 then
            if self.mFacilityLvUpNodeDic:ContainsKey(facilityData.id)==true then
                local facNode=self.mFacilityLvUpNodeDic[facilityData.id];
                facNode:SetData(facilityData);
            else
                gferror("[设施升级界面] 缺少"..facilityData.id.."组件");
            end
        end
    end


    --Line
    for i = 1, self.mFacilityLvUpLineList:Count() do

        local lineView=self.mFacilityLvUpLineList[i];
        lineView:UpdateView();
    end

end



function UIFacilityLvUpPanel.OnShow()
    self = UIFacilityLvUpPanel;
end



function UIFacilityLvUpPanel.OnFacilityNodeClick(obj)
    self=UIFacilityLvUpPanel;
    local mBtnClick=UIUtils.GetButtonListener(obj);
    if mBtnClick ~=nil then
        setactive(self.mView.mTrans_LevelUpDetail,true);
        self.mSelectFacilityID=mBtnClick.param;
        self:UpdateLevelUpDetailView();
        self:HighLightNode();

    else
        gferror("找不到Button组件！");
    end

end


--刷新升级详细界面
function UIFacilityLvUpPanel.UpdateLevelUpDetailView()
    self = UIFacilityLvUpPanel;

    --拿数据
    local facilityData=TableData.listFacilityDatas:GetDataById(self.mSelectFacilityID);
    local cmdData=NetCmdFacilityData:GetFacilityCmdDataById(self.mSelectFacilityID);
    local curfacilityPropertyData=TableData.GetFacilityPropertyData(facilityData.id,cmdData.level);
    local nextlevel=cmdData.level+1;
    local nextfacilityPropertyData=TableData.GetFacilityPropertyData(facilityData.id,nextlevel);

    --升级属性显示

    for i = 1, self.mFacilityLvUpListItemList:Count() do
        self.mFacilityLvUpListItemList[i]:SetData(nil);
    end

    local LvUpPropertyList=curfacilityPropertyData.mFacilityPropertyItemList;

    local nextplayerperkList = nil;

    if nextfacilityPropertyData ~=nil then
        nextplayerperkList=nextfacilityPropertyData.mFacilityPropertyItemList;
    end

    for i = 1, LvUpPropertyList.Count do
        local playerperkData=LvUpPropertyList[i-1];
        local nextplayerperkData=nil;

        if nextplayerperkList ~=nil then
            nextplayerperkData=nextplayerperkList[i-1];
        end

        if i <=self.mFacilityLvUpListItemList:Count() then
            self.mFacilityLvUpListItemList[i]:SetData(playerperkData);
            self.mFacilityLvUpListItemList[i]:SetNextData(nextplayerperkData);
        else
            local view=FacilityLvUpListItem:New();
            view:InitCtrl(self.mView.mTrans_LvUpList);
            view:SetData(playerperkData);
            view:SetNextData(nextplayerperkData);
            self.mFacilityLvUpListItemList:Add(view);
        end
    end

    ----设施是否升级中

    if cmdData.up_end_time ~=0 then
        setactive(self.mView.mTrans_PanelReqMAX.gameObject,false);
        setactive(self.mView.mTrans_PanelReqUpgrading.gameObject,true);

        local timeSec=cmdData.up_end_time-CGameTime:GetTimestamp();

        if timeSec >curfacilityPropertyData.lvup_time then
            timeSec=curfacilityPropertyData.lvup_time;
        elseif timeSec < 0 then
            timeSec=0;
        end

        self.mView.mText_upgradingTime.text=CS.CGameTime.ReturnDurationBySec(timeSec);

        local cur= curfacilityPropertyData.lvup_time-(cmdData.up_end_time-CGameTime:GetTimestamp());

        self.mView.mImage_upgradeFill.fillAmount=cur/curfacilityPropertyData.lvup_time;

        setactive(self.mView.mBtn_LvUpButton.gameObject,false);
        setactive(self.mView.mBtn_LvUpButtonFast.gameObject,true);

        self.mView.mText_GemReqNumer.text="10";
    else
        setactive(self.mView.mTrans_PanelReqUpgrading.gameObject,false);
        setactive(self.mView.mBtn_LvUpButton.gameObject,true);
        setactive(self.mView.mBtn_LvUpButtonFast.gameObject,false);
        --满级判断
        if cmdData.level<facilityData.max_level then
            setactive(self.mView.mTrans_PanelReqMAX.gameObject,false);
            --升级需求  建材数量  其他建筑等级 任务是否完成
            local ReqItemList=curfacilityPropertyData.mFacilityReqItemList;
            for i = 1, self.mFacilityLvUpReqItemList:Count() do
                self.mFacilityLvUpReqItemList[i]:SetData(nil);
            end
            for i = 1, ReqItemList.Count do
                local reqItemViewData=ReqItemList[i-1];
                if i <=self.mFacilityLvUpReqItemList:Count() then
                    self.mFacilityLvUpReqItemList[i]:SetData(reqItemViewData);
                    UIUtils.GetButtonListener(self.mFacilityLvUpReqItemList[i].mTrans_goto.gameObject).param =reqItemViewData;
                else
                    local view=FacilityLvUpReqItem:New();
                    view:InitCtrl(self.mView.mTrans_RequestList);
                    view:SetData(reqItemViewData);

                    UIUtils.GetButtonListener(view.mTrans_goto.gameObject).onClick =self.ReqItemClick;
                    UIUtils.GetButtonListener(view.mTrans_goto.gameObject).param =reqItemViewData;
                    self.mFacilityLvUpReqItemList:Add(view);
                end
            end

            --是否满足升级条件
            self.mView.mBtn_LvUpButton.interactable=NetCmdFacilityData:IsCouldLvUp(cmdData.id);
            --需要时间
            self.mView.mText_TimeReqNumer.text=CS.CGameTime.ReturnDurationBySec(curfacilityPropertyData.lvup_time);
        else

            self.mView.mBtn_LvUpButton.interactable=false;
            setactive(self.mView.mTrans_PanelReqMAX.gameObject,true);
        end



    end



end



--点击需求Item
function UIFacilityLvUpPanel.ReqItemClick(obj)
    self = UIFacilityLvUpPanel;
    local reqItemViewData= UIUtils.GetButtonListener(obj).param;

    if reqItemViewData.type==2 then
        --建筑等级判断
        local cmddata= NetCmdFacilityData:GetFacilityCmdDataById(reqItemViewData.paramIntOne);
        if cmddata.level< reqItemViewData.paramIntTwo then

            setactive(self.mView.mTrans_LevelUpDetail,false);

            --定位
            local  trans=self.mFacilityLvUpNodeDic[reqItemViewData.paramIntOne]:GetSelfRectTransform();
            local xx=CS.UIUtils.GetPosMiddleInScrollRect(trans.anchoredPosition.x);
            self.mView.mTrans_FacilityLvUpTree.anchoredPosition = CS.UnityEngine.Vector2(xx,0);


            --gfdebug(reqItemViewData.paramIntOne);
            self:HighLightNode();
            self.mFacilityLvUpNodeDic[reqItemViewData.paramIntOne]:SetHighLight(true);
            self:UpdateView(nil);

        end

    end

end


--高亮
function UIFacilityLvUpPanel.HighLightNode()
    self = UIFacilityLvUpPanel;

    local facilityDatas=TableData.listFacilityDatas:GetList();

    --Node
    for i = 1, facilityDatas.Count do
        local facilityData=facilityDatas[i-1];
        if facilityData.id ~= 0 then
            if self.mFacilityLvUpNodeDic:ContainsKey(facilityData.id)==true then
                local facNode=self.mFacilityLvUpNodeDic[facilityData.id];
                facNode:SetHighLight(false);
            else
                --gferror("[设施升级界面] 缺少"..facilityData.id.."组件");
            end
        end
    end

end





--升级按钮
function UIFacilityLvUpPanel.LvUpClick(obj)
    self = UIFacilityLvUpPanel;
    NetCmdFacilityData:SendReqFacilityLevelUp(self.mSelectFacilityID,self.LvUpClickCallBack);
end

function UIFacilityLvUpPanel.LvUpClickCallBack(ret)
    self = UIFacilityLvUpPanel;
    gfdebug("升级中");
    self:UpdateLevelUpDetailView();
end



--快速升级按钮
function UIFacilityLvUpPanel.FastLvUpClick(obj)
    self = UIFacilityLvUpPanel;



    local Diomand=NetTeamHandle:GetMaintainResDiomandNum();


    if Diomand <10 then
        MessageBox.Show("注意","钻石不足",nil,nil,nil);
    else
        MessageBox.Show("快速建造","是否确认消耗XX钻石马上完成该建筑的升级？",nil,self.FastLvUpConfirmClick,nil);
    end

end


function UIFacilityLvUpPanel.FastLvUpConfirmClick(ret)
    self = UIFacilityLvUpPanel;
    NetCmdFacilityData:SendReqFacilityFastLevelUp(self.mSelectFacilityID,self.FastLvUpClickCallBack);
end


function UIFacilityLvUpPanel.FastLvUpClickCallBack(ret)
    self = UIFacilityLvUpPanel;
    self:UpdateLevelUpDetailView();
end




--关闭升级详细界面
function UIFacilityLvUpPanel.CloseLevelUpDetailView(obj)
    self=UIFacilityLvUpPanel;
    setactive(self.mView.mTrans_LevelUpDetail,false);
    self:UpdateView(nil);

end




--关闭界面
function UIFacilityLvUpPanel.ReturnClick(obj)
    self = UIFacilityLvUpPanel;
    UIFacilityLvUpPanel.Close();
end





function UIFacilityLvUpPanel.OnRelease()
    self = UIFacilityLvUpPanel;

    CS.GF2.Message.MessageSys.Instance:RemoveListener(4003,self.UpdateHeartMessage);
    CS.GF2.Message.MessageSys.Instance:RemoveListener(9006,self.UpdateHeartMessage);

end




