--region *.lua

require("UI.UIBasePanel")
require("UI.ChapterSelect.UIChapterSelectChapterItem")
require("UI.ChapterSelect.UIChapterSelectView")
require("UI.ChapterSelect.UIChapterSelect3DView")

UIChapterSelectPanel = class("UIChapterSelectPanel", UIBasePanel);
UIChapterSelectPanel.__index = UIChapterSelectPanel;

UIChapterSelectPanel.mView = nil;
UIChapterSelectPanel.m3DView = nil;

UIChapterSelectPanel.mPath_ChapterItem = "ChapterUnit.prefab";
UIChapterSelectPanel.mPrefab_ChapterItem = nil;

UIChapterSelectPanel.mChapterItems = nil;

UIChapterSelectPanel.mCurSelect = nil;
UIChapterSelectPanel.mCurSelectData = nil;

UIChapterSelectPanel.mUIHolder = nil;

--构造
function UIChapterSelectPanel:ctor()
    UIChapterSelectPanel.super.ctor(self);
end

function UIChapterSelectPanel.Open()
    UIManager.OpenUI(UIDef.UIChapterSelectPanel);
end

function UIChapterSelectPanel.Close()
    UIManager.CloseUI(UIDef.UIChapterSelectPanel);
end

function UIChapterSelectPanel.Init(root, data)

    UIChapterSelectPanel.super.SetRoot(UIChapterSelectPanel, root);

    self = UIChapterSelectPanel;

    self.mView = UIChapterSelectView;
    self.mView:InitCtrl(root);
    
    UIUtils.GetListener(self.mView.mButton_Return.gameObject).onClick = self.OnReturnBtnClick;
   
    self:InitChapters();

    InputSys:OneFingerClickEvent('+', self.OneFingerClickEventHandle);
end

function UIChapterSelectPanel.Init3DCanvas(root, data)

    self = UIChapterSelectPanel;
    
    self.m3DView = UIChapterSelect3DView;
    self.m3DView:InitCtrl(root);

    self.mUIHolder = data;

    self:SelectChapter(self.mCurSelectData, true);
end

function UIChapterSelectPanel.OnReopen()
    self:SelectChapter(self.mCurSelectData, true);
end

function UIChapterSelectPanel:InitChapters()

    self.mChapterItems = List:New(UIChapterSelectChapterItem);

    for i = 1, CampaignPool.campaignDataCount do
        local campaignData = CampaignPool:GetCampaignDataByIndex(i - 1);
        if campaignData ~= nil then
            if self.mPrefab_ChapterItem == nil then
                self.mPrefab_ChapterItem = self:GetItemPrefab(self.mPath_ChapterItem);
            end
            local prefabInst = instantiate(self.mPrefab_ChapterItem);
            UIUtils.AddListItem(prefabInst, self.mView.mList_Chapters);
            local chapterItem = UIChapterSelectChapterItem.New();
            chapterItem:InitCtrl(prefabInst.transform);
            chapterItem:SetUIData(campaignData);
            self.mChapterItems:Add(chapterItem);

            local selectBtn = UIUtils.GetListener(chapterItem.mButton_Select.gameObject);
            selectBtn.onClick = self.OnChapterItemClick;
            selectBtn.param = chapterItem;
            selectBtn.paramData = campaignData;

            if CampaignPool.campaignData ~= nil and campaignData.id == CampaignPool.campaignData.id then
                self.mCurSelect = chapterItem;
                self.mCurSelectData = campaignData;
                chapterItem:SetSelect(true);
                chapterItem:SetInPlace(true);
            else
                chapterItem:SetSelect(false);
                chapterItem:SetInPlace(false);
            end
        end
    end

    if self.mCurSelect == nil and self.mChapterItems:Count() > 0 then
        self.mCurSelect = self.mChapterItems[1];
        self.mCurSelectData = self.mCurSelect.mData;
        self.mCurSelect:SetSelect(true);
    end
end

function UIChapterSelectPanel:SelectChapter(data, immediately)
    UIChapterSelectPanel.mUIHolder:SelectChapter(data.id);
    self.m3DView:SetData(data);
    CS.GF2.Message.MessageSys.Instance:SendMessage(CS.GF2.Message.UIEvent.OnAreaFocusMsg, data.camera_position, immediately);
end

function UIChapterSelectPanel.OnInit()
    
end

function UIChapterSelectPanel.OnShow()
    self = UIChapterSelectPanel;
end

function UIChapterSelectPanel.OnRelease()

    self = UIChapterSelectPanel;
    
    InputSys:OneFingerClickEvent('-', UIChapterSelectPanel.OneFingerClickEventHandle);

    mPath_ChapterItem = nil;
    for i = 1, self.mChapterItems:Count() do
        self.mChapterItems[i]:Release();
    end
    self.mChapterItems:Clear();

    self.mUIHolder = nil;

    self.mCurSelect = nil;
    self.mCurSelectData = nil;

    self.mView = nil;
    self.m3DView = nil;
end

function UIChapterSelectPanel.OnChapterItemClick(gameobj)
    self = UIChapterSelectPanel;
    local btnTrigger = getcomponent(gameobj, typeof(CS.EventTriggerListener));
    if btnTrigger ~= nil then
        if btnTrigger.param ~= nil and btnTrigger.paramData ~= nil then
            
            if self.mCurSelect ~= nil then
                self.mCurSelect:SetSelect(false);
            end

            self.mCurSelect = btnTrigger.param;
            self.mCurSelectData = btnTrigger.paramData;
            self.mCurSelect:SetSelect(true);

            self:SelectChapter(self.mCurSelectData, false);
        end
    end
end

function UIChapterSelectPanel.OneFingerClickEventHandle(pos)
    print("UIChapterSelectPanel.OneFingerClickEventHandle")
    self = UIChapterSelectPanel;

    local hitchapter = self.mUIHolder:GetHitChapter(pos);
    if self.mCurSelectData ~= nil and self.mCurSelectData.id == hitchapter then
        if CampaignPool.campaignInfo == nil then
            CampaignPool:SendReqCampaignStart(self.mCurSelectData);
        else 
            if CampaignPool.campaignInfo.id ~= self.mCurSelectData.id then
                CampaignPool:SendReqCampaignZoneTransfer(self.mCurSelectData.id, tonumber(self.mCurSelectData.start_zone));
            end
        end
    end
end

function UIChapterSelectPanel.OnReturnBtnClick(gameobj)
    UIChapterSelectPanel.mUIHolder:ExitCurrent();
end

function UIChapterSelectPanel:GetItemPrefab(path)
    local sourcePrefab = UIUtils.GetGizmosPrefab(path,self);
    if sourcePrefab == nil then
        print("没有资源 ："..path);
    end
    return sourcePrefab;
end

--endregion
