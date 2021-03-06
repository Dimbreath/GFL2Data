---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2019/3/19 15:57
---


require("UI.UIBasePanel")
require("UI.PostPanel.UIPostPanelView")
require("UI.PostPanel.item.UIPostContentTemplete_ButtonItem")
require("UI.PostPanel.item.UIPostContentTemplete_ImageItem")
require("UI.PostPanel.item.UIPostContentTemplete_TextItem")
require("UI.PostPanel.item.UIPostListItem")


UIPostPanel = class("UIPostPanel", UIBasePanel);
UIPostPanel.__index = UIPostPanel;

UIPostPanel.mView = nil;
UIPostPanel.mPath_ListItem = "Post/UIPostListItem.prefab"

UIPostPanel.mCurrentPanelType = 2;--默认为活动公�?
UIPostPanel.mPostPanelDataList = nil;
UIPostPanel.mPostListItemList = nil;
UIPostPanel.mPostBtnDict = nil;--key btnGameobj value btnScript
UIPostPanel.mUniView =nil;
UIPostPanel.__Opened = false;
UIPostPanel.readPostList = nil
UIPostPanel.callback = nil

function UIPostPanel:ctor()
    UIPostPanel.super.ctor(self);

end

function UIPostPanel.Open(callback)
    if not UIPostPanel.__Opened and not PostInfoConfig.PostIsNull then
        UIPostPanel.callback = callback
        UIManager.OpenUI(UIDef.UIPostPanel)
    else
        if callback then callback() end
    end
end

function UIPostPanel.Close()
    self = UIPostPanel
    if self.mView.animator then
        self.mView.animator:Play("UIPostPanel", 0, 0)
        TimerSys:DelayCall(0.3, function ()
            UIPostPanel.__Opened = false;
            PostInfoConfig.RecordReadPostList()
            UIManager.CloseUI(UIDef.UIPostPanel)
            if UIPostPanel.callback then UIPostPanel.callback() end
        end)
    end
end

function UIPostPanel.Init(root, data)

    UIPostPanel.super.SetRoot(UIPostPanel, root);

    self = UIPostPanel;

    self.mData = data;
    self.mIsPop = true

    self.mView = UIPostPanelView;
    self.mView:InitCtrl(root);
end

function UIPostPanel.OnInit()
    gfwarning("PostPanel init!")
    UIPostPanel.__Opened = true
    -- PostInfoConfig.ParseReadPost()
    UIPostPanel.RegisterListener()
    UIPostPanel.mPostPanelDataList= PostInfoConfig.PostDataList
    UIPostPanel.InitPanels()
end

function UIPostPanel.OnShow()
    self = UIPostPanel;

    -- UIPostPanel.mUIRoot.transform:SetAsLastSibling()
end

function UIPostPanel.OnRelease()
    self = UIPostPanel;
    UIPostPanel.mPostPanelDataList = nil;
    UIPostPanel.mPostListItemList = nil;
    UIPostPanel.mPostBtnDict = nil;
    UIPostPanel.mCurrentPanelType = 2;

    PostInfoConfig.DestroyPostTexture()
end

function UIPostPanel.RegisterListener()
    UIUtils.GetButtonListener(UIPostPanel.mView.mBtn_Return.gameObject).onClick = UIPostPanel.OnReturnClicked
    UIUtils.GetButtonListener(UIPostPanel.mView.mBtn_ActivityPost.gameObject).onClick =UIPostPanel.OnActivityBtnClicked
    UIUtils.GetButtonListener(UIPostPanel.mView.mBtn_GamePost.gameObject).onClick = UIPostPanel.OnGamePostBtnClicked

    UIPostPanel.mView.mScrollView.onValueChanged:AddListener(self.CheckScroll);
end


--Input a Button Component and it's Item
function UIPostPanel.RegisterBtnListener(btnItem,btnCompo)
    if UIPostPanel.mPostBtnDict == nil then
        UIPostPanel.mPostBtnDict = Dictionary:New()
    end

    local btnGameobj = btnCompo.gameObject
    if not UIPostPanel.mPostBtnDict:ContainsKey(btnGameobj) then
        UIPostPanel.mPostBtnDict:Add(btnGameobj,btnItem)
        UIUtils.GetButtonListener(btnGameobj).onClick = UIPostPanel.OnLabelBtnClicked
    end

end

function UIPostPanel.InitPanels()
    if UIPostPanel.mPostPanelDataList==nil then
        gferror("PostData is null!")
        return;
    end
    local timeStamp = CGameTime:GetTimestamp()
    local listItemPrefab = UIUtils.GetGizmosPrefab(UIPostPanel.mPath_ListItem,self);
    UIPostPanel.mPostListItemList = List:New()
    --gfwarning("Panel: "..UIPostPanel.mPostPanelDataList.Count)
    for i=0,UIPostPanel.mPostPanelDataList.Count - 1 do
        local postData = UIPostPanel.mPostPanelDataList[i]
        --gfwarning("Num:"..i)
        if postData.type == UIPostPanel.mCurrentPanelType and postData.startTime<timeStamp and postData.endTime>timeStamp then
            --gfwarning("List index:"..i)
            local listItemInst = instantiate(listItemPrefab,UIPostPanel.mView.mTrans_PostList.transform)
            local listItem = UIPostListItem.New()
            listItem:InitCtrl(listItemInst.transform)
            listItem:SetData(postData)
            --UIUtils.GetButtonListener(listItem.mBtn_Chosen.gameObject).onClick = UIPostPanel.OnListClicked
            UIUtils.GetButtonListener(listItem.mBtn_UnChosen.gameObject).onClick = UIPostPanel.OnListClicked
            UIPostPanel.mPostListItemList:Add(listItem)
        end
    end
    --
    --if(UIPostPanel.mPostPanelDataList.Count > 5) then
    --    setactive(UIPostPanel.mView.mTrans_Triangle.gameObject,true);
    --else
    --    setactive(UIPostPanel.mView.mTrans_Triangle.gameObject,false);
    --end

    
    UIPostPanel.ActiveDefaultList()
    
end

function UIPostPanel.CheckScroll(pos)
    if(pos.y > 0) then
        setactive(UIPostPanel.mView.mTrans_Triangle.gameObject,true);
    else
        setactive(UIPostPanel.mView.mTrans_Triangle.gameObject,false);
    end
end

function UIPostPanel.ReleasePanels()
    if UIPostPanel.mPostListItemList~=nil then
        for i=1,UIPostPanel.mPostListItemList:Count() do
            UIPostPanel.mPostListItemList[i]:OnRelease()
        end
        UIPostPanel.mPostListItemList = nil;
    end


end

function UIPostPanel.SetUniViewAddress(address)
    --UIPostPanel.mView.mUniWebView_UniView.ReferenceRectTransform = UIPostPanel.mView.mTrans_ContentPanel
    print ("设置uniView地址！： "..address)
	
    MessageSys:SendMessage(1007,address);
    --CS.LuaUIUtils.SetUniWebViewAddress(UIPostPanel.mView.mUniWebView_UniView,address)
    --UIPostPanel.mView.mUniWebView_UniView.Show()
end

function UIPostPanel.ActiveDefaultList()
    for i=1,UIPostPanel.mPostListItemList:Count() do
        if UIPostPanel.mPostListItemList[i].mType == UIPostPanel.mCurrentPanelType then
            UIPostPanel.OnListClicked(UIPostPanel.mPostListItemList[i].mTrans_UnChosen.gameObject)
            return
        end
    end
end

function UIPostPanel.OnReturnClicked(gameobj)
    UIPostPanel.Close()
    -- UIUniTopBarPanel:Show(true)
    --UICommandCenterPanel:SetMaskEnable(true)
    --NetCmdCheckInData:SendGetDailyCheckInCmd(self.SendCheckInCallback);
end

function UIPostPanel.OnActivityBtnClicked(gameobj)
    gfwarning("Activity!")
    setactive(UIPostPanel.mView.mTrans_ActivityPost_Chosen.gameObject,true)
    setactive(UIPostPanel.mView.mTrans_ActivityPost_Unchosen.gameObject,false)
    setactive(UIPostPanel.mView.mTrans_GamePost_Chosen.gameObject,false)
    setactive(UIPostPanel.mView.mTrans_GamePost_Unchosen.gameObject,true)
    UIPostPanel.mCurrentPanelType = 2
    --setactive(UIPostPanel.mView.mUniWebView_UniView.gameObject,false)
    MessageSys:SendMessage(CS.GF2.Message.UIEvent.UniViewActivityChange,"false");
    UIPostPanel.ReleasePanels()
    UIPostPanel.InitPanels()

    UIPostPanel.mView.mContentScrollView.verticalNormalizedPosition = 1
end

function UIPostPanel.OnGamePostBtnClicked(gameobj)
    gfwarning("Post!")
    setactive(UIPostPanel.mView.mTrans_ActivityPost_Chosen.gameObject,false)
    setactive(UIPostPanel.mView.mTrans_ActivityPost_Unchosen.gameObject,true)
    setactive(UIPostPanel.mView.mTrans_GamePost_Chosen.gameObject,true)
    setactive(UIPostPanel.mView.mTrans_GamePost_Unchosen.gameObject,false)
    UIPostPanel.mCurrentPanelType = 1
    --setactive(UIPostPanel.mView.mUniWebView_UniView.gameObject,true)
    MessageSys:SendMessage(CS.GF2.Message.UIEvent.UniViewActivityChange,"true");
    UIPostPanel.ReleasePanels()
    UIPostPanel.InitPanels()

    UIPostPanel.mView.mContentScrollView.verticalNormalizedPosition = 1
end

function UIPostPanel.OnListClicked(gameobj)
    for i = 1,UIPostPanel.mPostListItemList:Count() do
        local postListItem = UIPostPanel.mPostListItemList[i]

        if gameobj==postListItem.mTrans_UnChosen.gameObject then          
            postListItem:OnClicked()
        else
            postListItem:OnCancel()
        end
    end
end

function UIPostPanel.OnLabelBtnClicked(gameobj)
    --for i=1,UIPostPanel.mPostBtnDict:Count() do
        if(UIPostPanel.mPostBtnDict:ContainsKey(gameobj))then
            UIPostPanel.mPostBtnDict[gameobj]:OnClicked()
            UIPostPanel.mView.mContentScrollView.verticalNormalizedPosition = 1
        end
    --end
end

--function UIPostPanel.SendCheckInCallback(ret)
--    self = UIPostPanel
--    if(NetCmdCheckInData:IsChecked()) then
--        UICommandCenterPanel:SetMaskEnable(false)  --- 关闭主界面Mask
--    end
--end
