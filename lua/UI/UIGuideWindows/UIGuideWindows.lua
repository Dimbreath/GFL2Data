require("UI.UIBasePanel")

UIGuideWindows = class("UIGuideWindows", UIBasePanel)
UIGuideWindows.__index = UIGuideWindows

UIGuideWindows.mStageId = 0
UIGuideWindows.pageList = {}
UIGuideWindows.pageDataList = nil
UIGuideWindows.mShowConfirm = false

UIGuideWindows.mCurIndex = 0;
UIGuideWindows.mTags = nil ;

UIGuideWindows.OnPageCloseCallback = nil;

function UIGuideWindows:ctor()
    UIGuideWindows.super.ctor(self)
end

function UIGuideWindows.Close()
    CS.GuideManager.Instance:ClosePopUpGuide();
    MessageSys:SendMessage(CS.GF2.Message.UIEvent.CloseAISign,nil,true);
    UIManager.CloseUI(UIDef.UIGuideWindows)
end

function UIGuideWindows.OnRelease()
    self = UIGuideWindows
    self.mShowConfirm = false
    self.mStageId = 0;
    self.mTags = nil;

    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.TutorialInfoCallback, UIGuideWindows.OnSetTutorialInfoCallback)
end

function UIGuideWindows.Init(root, data)
    self = UIGuideWindows
    UIGuideWindows.super.SetRoot(UIGuideWindows, root)
   
    self.mShowConfirm = NetCmdStageRecordData:IsEnterStage();

    UIGuideWindows.super.SetRoot(UIGuideWindows, root)

	self.mIsPop = true;
    self.mIsGuidePanel = true

    self.mView = UIGuideWindowsView.New()
    self.mView:InitCtrl(root)

    self.mStageId = data[0]
	self.mTags = {};
	UIGuideWindows.OnPageCloseCallback = data[1]
    UIUtils.GetButtonListener(self.mView.mBtn_FinishBtn.gameObject).onClick = function()
        if(UIGuideWindows.OnPageCloseCallback ~= nil) then
            UIGuideWindows.OnPageCloseCallback();
        end

        UIGuideWindows.OnPageCloseCallback = nil;
        UIGuideWindows.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_PreviousPageBtn.gameObject).onClick = function()
        UIGuideWindows:OnBtnPreviousPage();
    end

    UIUtils.GetButtonListener(self.mView.mBtn_NextPageBtn.gameObject).onClick = function()
        UIGuideWindows:OnBtnNextPage();
    end

    MessageSys:AddListener(CS.GF2.Message.UIEvent.TutorialInfoCallback, UIGuideWindows.OnSetTutorialInfoCallback)

    MessageSys:SendMessage(CS.GF2.Message.UIEvent.CloseAISign,nil,false);
        
end



function UIGuideWindows.OnInit()
    self = UIGuideWindows
    self:InitPanel()
end

function UIGuideWindows.OnShow()
    self = UIGuideWindows
    self.mView.mCanvasGroup.blocksRaycasts = true;
    self.mView.mCanvasGroup.interactable = false;
    TimerSys:DelayCall(0.15, function()
        self.mView.mCanvasGroup.interactable = true;
    end)
end

function UIGuideWindows:InitPanel()
    setactive(self.mUIRoot, true)

    self.mCurIndex = 0;

    if self.mStageId or self.mStageId ~= 0 then
        local stageData = TableData.listStageDatas:GetDataById(self.mStageId)
        if stageData.stage_guide_groupid and stageData.stage_guide_groupid ~= 0 then
            self.pageDataList = TableData.GetGuidePagesByGroupId(stageData.stage_guide_groupid)
            if self.pageDataList == nil or self.pageDataList.Count == 0 then
                gferror(" guidePages 找不到  stage_guide_groupid  " .. stageData.stage_guide_groupid)
                return
            end

            for i = 1, self.pageDataList.Count do
                local simpleTag = UIGuideIndicatorItemV2:New();
                simpleTag:InitCtrl(self.mView.mProgressBarLayout)
                table.insert(self.mTags, simpleTag)
            end
            
            self:UpdatePage(0, self.pageDataList[0]);

            setactive(self.mView.mBtn_PreviousPageBtn.gameObject, false)
            setactive(self.mView.mBtn_NextPageBtn.gameObject, not (self.pageDataList.Count == 1))
            setactive(self.mView.mBtn_FinishBtn.gameObject, self.mShowConfirm or self.pageDataList.Count == 1 )
        end
    else
        self.Close()
    end

    NetCmdStageRecordData:SetFistEnterTrue();
end

function UIGuideWindows:UpdatePage(index, data)
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

function UIGuideWindows:OnBtnPreviousPage()
    self.mCurIndex = self.mCurIndex - 1
    if self.mCurIndex <= 0 then
        self.mCurIndex = 0
        setactive(self.mView.mBtn_PreviousPageBtn.gameObject, false)
    end
    setactive(self.mView.mBtn_NextPageBtn.gameObject, true)
    self:UpdatePage(self.mCurIndex, self.pageDataList[self.mCurIndex])
    self.mView.mAnimator:SetBool("Previous", true)
end

function UIGuideWindows:OnBtnNextPage()
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


function UIGuideWindows.OnSetTutorialInfoCallback(msg)
    UIGuideWindows.OnPageCloseCallback = msg.Content;
end




