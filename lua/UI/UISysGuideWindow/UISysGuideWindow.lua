require("UI.UIBasePanel")
---@class UISysGuideWindow : UIBasePanel
UISysGuideWindow = class("UISysGuideWindow", UIBasePanel)
UISysGuideWindow.__index = UISysGuideWindow

UISysGuideWindow.mSysId = 0
UISysGuideWindow.pageList = {}
UISysGuideWindow.pageDataList = nil
UISysGuideWindow.mShowConfirm = false

UISysGuideWindow.mCurIndex = 0;
UISysGuideWindow.mTags = nil ;

UISysGuideWindow.OnPageCloseCallback = nil;

function UISysGuideWindow:ctor()
    UISysGuideWindow.super.ctor(self)
end

function UISysGuideWindow.Close()
    CS.GuideManager.Instance:ClosePopUpGuide();
    MessageSys:SendMessage(CS.GF2.Message.UIEvent.CloseAISign,nil,true);
    UIManager.CloseUI(UIDef.UISysGuideWindow)
end

function UISysGuideWindow.OnShow()
    self = UISysGuideWindow
    self.mView.mCanvasGroup.blocksRaycasts = true;
    self.mView.mCanvasGroup.interactable = false;
    TimerSys:DelayCall(0.15, function()
        UISysGuideWindow.mView.mCanvasGroup.interactable = true;
    end)
end

function UISysGuideWindow.OnRelease()
    self = UISysGuideWindow
    self.mShowConfirm = false
    self.mSysId = 0;
    self.mTags = nil;

    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.TutorialInfoCallback, UISysGuideWindow.OnSetTutorialInfoCallback)
end

function UISysGuideWindow.Init(root, data)
    self = UISysGuideWindow
    UISysGuideWindow.super.SetRoot(UISysGuideWindow, root)

    self.mIsPop = true
    ---@type UIGuideWindowsView
    self.mView = UIGuideWindowsView.New()
    self.mView:InitCtrl(root)

    self.mSysId = data[1]
	self.mTags = {};
    UIUtils.GetButtonListener(self.mView.mBtn_FinishBtn.gameObject).onClick = function()
        if(UISysGuideWindow.OnPageCloseCallback ~= nil) then
            UISysGuideWindow.OnPageCloseCallback();
        end

        UISysGuideWindow.OnPageCloseCallback = nil;
        UISysGuideWindow.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_PreviousPageBtn.gameObject).onClick = function()
        UISysGuideWindow:OnBtnPreviousPage();
    end

    UIUtils.GetButtonListener(self.mView.mBtn_NextPageBtn.gameObject).onClick = function()
        UISysGuideWindow:OnBtnNextPage();
    end

    MessageSys:AddListener(CS.GF2.Message.UIEvent.TutorialInfoCallback, UISysGuideWindow.OnSetTutorialInfoCallback)

    MessageSys:SendMessage(CS.GF2.Message.UIEvent.CloseAISign,nil,false);
        
end



function UISysGuideWindow.OnInit()
    self = UISysGuideWindow
    self:InitPanel()
end

function UISysGuideWindow:InitPanel()
    setactive(self.mUIRoot, true)

    self.mCurIndex = 0;
    self.mShowConfirm = true

    if self.mSysId or self.mSysId ~= 0 then
        local sysData = TableData.listTutorialSystemDatas:GetDataById(self.mSysId)
        if sysData.id and sysData.id ~= 0 then
            self.pageDataList = TableData.GetSysGuidePagesByGroupId(sysData.id)
            if self.pageDataList == nil or self.pageDataList.Count == 0 then
                gferror(" systemPages 找不到  id  " .. sysData.id)
                return
            end

            for i = 1, self.pageDataList.Count do
                ---@type UIGuideIndicatorItemV2
                local simpleTag = UIGuideIndicatorItemV2:New();
                simpleTag:InitCtrl(self.mView.mProgressBarLayout)
                table.insert(self.mTags, simpleTag)
            end
            self.mBtn_y = self.mView.mBtn_NextPageBtn.transform.anchoredPosition.y
            self:UpdatePage(0, self.pageDataList[0]);

            setactive(self.mView.mBtn_PreviousPageBtn.gameObject, false)
            setactive(self.mView.mBtn_NextPageBtn.gameObject, not (self.pageDataList.Count == 1))

            if self.pageDataList.Count == 1 then
                setactive(self.mView.mProgressBarLayout, false)
            end
            setactive(self.mView.mBtn_FinishBtn.gameObject, self.mShowConfirm)
        end
    else
        self.Close()
    end
end

function UISysGuideWindow:UpdatePage(index, data)
    for i = 1, #self.mTags do
        if i == index + 1 then
            self.mTags[i]:SetOn(true)
        else
            self.mTags[i]:SetOn(false)
        end
    end

    self.mView.mImage_GuideImage.sprite = ResSys:GetSpriteByFullPath(data.media)
    self.mView.mText_GuideText.text = data.text.str
end

function UISysGuideWindow:OnBtnPreviousPage()
    self.mCurIndex = self.mCurIndex - 1
    if self.mCurIndex <= 0 then
        self.mCurIndex = 0
        setactive(self.mView.mBtn_PreviousPageBtn.gameObject, false)
    end
    setactive(self.mView.mBtn_NextPageBtn.gameObject, true)
    self:UpdatePage(self.mCurIndex, self.pageDataList[self.mCurIndex])
    self.mView.mAnimator:SetBool("Previous", true)
end

function UISysGuideWindow:OnBtnNextPage()
    self.mCurIndex = self.mCurIndex + 1
    if self.mCurIndex >= self.pageDataList.Count - 1 then
        self.mCurIndex = self.pageDataList.Count - 1
        setactive(self.mView.mBtn_FinishBtn.gameObject, true)
        setactive(self.mView.mBtn_NextPageBtn.gameObject, false)
    end
    setactive(self.mView.mBtn_PreviousPageBtn.gameObject, true)
    self:UpdatePage(self.mCurIndex, self.pageDataList[self.mCurIndex])
    self.mView.mAnimator:SetBool("Next", true)
end


function UISysGuideWindow.OnSetTutorialInfoCallback(msg)
    UISysGuideWindow.OnPageCloseCallback = msg.Content;
end




