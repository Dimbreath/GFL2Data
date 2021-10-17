---
--- Created by Administrator.
--- DateTime: 18/12/10 17:50
---
require("UI.UIBasePanel")
require("UI.UIManager")
require("UI.UITweenCamera")


UIBaseCollectResResultPanel  = class("UIBaseCollectResResultPanel ", UIBasePanel);
UIBaseCollectResResultPanel.__index = UIBaseCollectResResultPanel;


UIBaseCollectResResultPanel.mView = nil;


UIBaseCollectResResultPanel.mBaseResourceItemList=nil;


function UIBaseCollectResResultPanel:ctor()
    UIBaseCollectResResultPanel.super.ctor(self);
end

function UIBaseCollectResResultPanel.Open()
    UIManager.OpenUI(UIDef.UIBaseCollectResResultPanel);
end

function UIBaseCollectResResultPanel.Close()
    UIManager.CloseUI(UIDef.UIBaseCollectResResultPanel);
end

function UIBaseCollectResResultPanel.Init(root, data)

    UIBaseCollectResResultPanel.super.SetRoot(UIBaseCollectResResultPanel, root);

    self = UIBaseCollectResResultPanel;
    self.mView = UIBaseCollectResResultView;
    self.mView:InitCtrl(root);

end






function UIBaseCollectResResultPanel.OnInit()
    self = UIBaseCollectResResultPanel;

    self.mBaseResourceItemList=List:New();

    UIUtils.GetButtonListener(self.mView.mBtn_ComfirmBtn.gameObject).onClick =self.ReturnClick;
    --CS.GF2.Message.MessageSys.Instance:AddListener(4003,self.UpdateHeartMessage);

    self:UpdateView(nil);

end



function UIBaseCollectResResultPanel.UpdateView(msg)
    self = UIBaseCollectResResultPanel;
    --拿数据
    local itemCmdDatas=NetCmdFacilityData.mCollectItemList;

    --
    for i = 1, self.mBaseResourceItemList:Count() do
        self.mBaseResourceItemList[i]:SetData(nil);
    end

    for i = 1, itemCmdDatas.Count do
        local itemCmdData=itemCmdDatas[i-1];

            if i <=self.mBaseResourceItemList:Count() then
                self.mBaseResourceItemList[i]:SetData(itemCmdData);
            else
                local view=UIMsgBosItemlistItem:New();
                view:InitCtrl(self.mView.mTrans_Massage_BaseCollectResItemList);
                view:SetData(itemCmdData);
                self.mBaseResourceItemList:Add(view);
            end
    end

end



function UIBaseCollectResResultPanel.OnShow()
    self = UIBaseCollectResResultPanel;
end



--关闭界面
function UIBaseCollectResResultPanel.ReturnClick(obj)
    self = UIBaseCollectResResultPanel;
    UIBaseCollectResResultPanel.Close();
end



function UIBaseCollectResResultPanel.OnRelease()
    self = UIBaseCollectResResultPanel;

end




