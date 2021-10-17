require("UI.UIBasePanel")
require("UI.CommonReadmePanel.UITutorialInfoPanelView")

UITutorialInfoPanel = class("UITutorialInfoPanel", UIBasePanel)
UITutorialInfoPanel.__index = UITutorialInfoPanel

UITutorialInfoPanel.stageId = 0
UITutorialInfoPanel.pageList = {}
UITutorialInfoPanel.pageDataList = nil
UITutorialInfoPanel.showConfirm = false

UITutorialInfoPanel.OnPageCloseCallback = nil;

function UITutorialInfoPanel:ctor()
    UITutorialInfoPanel.super.ctor(self)
end

function UITutorialInfoPanel.Close()
    CS.GuideManager.Instance:ClosePopUpGuide();
    UIManager.CloseUI(UIDef.UITutorialInfoPanel)
end

function UITutorialInfoPanel.OnRelease()
    self = UITutorialInfoPanel
    self.stageId = 0
    self.pageList = {}
    self.showConfirm = false

    MessageSys:RemoveListener(CS.GF2.Message.UIEvent.TutorialInfoCallback, UITutorialInfoPanel.OnSetTutorialInfoCallback)
end

function UITutorialInfoPanel.Init(root, data)
    self = UITutorialInfoPanel
    local stageId = data[0]
    local showConfirm = data[1]
    --UITutorialInfoPanel.super.SetRoot(UITutorialInfoPanel, root)
    UITutorialInfoPanel.showConfirm = showConfirm == nil and true or showConfirm
    self.mHideFlag = (CS.GuideManager.s_CanvasObj ~= nil)
    if(CS.GuideManager.s_CanvasObj ~= nil) then
        TimerSys:DelayCall(0.1,function(obj)
            self.mUIRoot.transform:SetParent(CS.GuideManager.s_CanvasObj.transform);
            local pos = self.mUIRoot.transform.localPosition;
            self.mUIRoot.transform.localPosition = Vector3(pos.x,pos.y,0);
            setactive(self.mUIRoot, true)
        end);
    end

    UITutorialInfoPanel.super.SetRoot(UITutorialInfoPanel, root)

    self.mIsPop = true

    self.mView = UITutorialInfoPanelView.New()
    self.mView:InitCtrl(root)

    self.stageId = stageId

    UIUtils.GetButtonListener(self.mView.mBtn_CloseButton.gameObject).onClick = function()
        if(UITutorialInfoPanel.OnPageCloseCallback ~= nil) then
            UITutorialInfoPanel.OnPageCloseCallback();
        end

        UITutorialInfoPanel.OnPageCloseCallback = nil;
        UITutorialInfoPanel.Close()
    end

    MessageSys:AddListener(CS.GF2.Message.UIEvent.TutorialInfoCallback, UITutorialInfoPanel.OnSetTutorialInfoCallback)
    -- self:InitPanel()
end

function UITutorialInfoPanel.OnSetTutorialInfoCallback(msg)
    UITutorialInfoPanel.OnPageCloseCallback = msg.Content;
end

function UITutorialInfoPanel.OnInit()
    self = UITutorialInfoPanel
    self:InitPanel()
end

function UITutorialInfoPanel:InitPanel()
    setactive(self.mUIRoot, true)
    if self.stageId or self.stageId ~= 0 then
        local stageData = TableData.listStageDatas:GetDataById(self.stageId)
        if stageData.stage_guide_groupid and stageData.stage_guide_groupid ~= 0 then
            self.pageDataList = TableData.GetGuidePagesByGroupId(stageData.stage_guide_groupid)
            self:UpdatePagination(self.pageDataList.Count)
            self:InitTutorialInfo(self.pageDataList, self.mView.mTrans_Content, self.mView.mTrans_TempObj.gameObject)
            self.mView.mPageScroll:InitPageScroll()
            self.mView.mPageScroll:ResetData()
            self.mView.mPageScroll:SetPageChangedCallback(handler(self, self.OnPageCallback))

            setactive(self.mView.mTrans_Prev.gameObject, false)
            setactive(self.mView.mTrans_Next.gameObject, not (self.pageDataList.Count == 1))
            setactive(self.mView.mBtn_CloseButton.gameObject, self.showConfirm)
        end
    else
        self.Close()
    end
end

function UITutorialInfoPanel:OnPageCallback(index)
    if index == self.pageDataList.Count and (not self.showConfirm) then
        setactive(self.mView.mBtn_CloseButton.gameObject, true)
        self.showConfirm = true
    end
    setactive(self.mView.mTrans_Prev.gameObject, not (index == 1))
    setactive(self.mView.mTrans_Next.gameObject, not (index == self.pageDataList.Count or self.pageDataList.Count == 1))
end


function UITutorialInfoPanel:UpdatePagination(num)
    for i = 0, self.mView.mTrans_Pagination.childCount - 1 do
        setactive(self.mView.mTrans_Pagination:GetChild(i).gameObject, false)
    end

    for i = 1, num do
        if i > self.mView.mTrans_Pagination.childCount then
            local obj = instantiate(self.mView.mTrans_Pagination:GetChild(0).gameObject)
            obj.transform:SetParent(self.mView.mTrans_Pagination, false)
            obj.transform.localPosition = vectorzero
            obj.transform.localScale = vectorone
        end
        setactive(self.mView.mTrans_Pagination:GetChild(i - 1).gameObject, true)
    end
end

function UITutorialInfoPanel:InitTutorialInfo(data ,root, temp)
    for i = 0, data.Count - 1 do
        local page = nil
        local item = data[i]
        local obj = instantiate(temp)
        obj.transform:SetParent(root, false)
        obj.transform.localPosition = vectorzero
        obj.transform.localScale = vectorone
        setactive(obj, true)
        page = self:InitPageItem(obj, item, i)

        table.insert(self.pageList, page)
    end
end

function UITutorialInfoPanel:InitPageItem(obj, data, pageIndex)
    if not obj or not data then
        return nil
    end

    obj.name = "page_0" .. pageIndex
    local page = {}
    page.obj = obj
    page.index = pageIndex
    page.txtHint = UIUtils.GetText(obj, "DetailMask/Message/Trans_Text_HintDetail")
    page.imagePic = UIUtils.GetImage(obj, "DetailMask/Message/Trans_Image_Image")
    page.conMessage = UIUtils.GetRectTransform(obj, "DetailMask/Message")

    page.txtHint.text = data.text.str
    page.imagePic.sprite = ResSys:GetSpriteByFullPath(data.media)
    -- UIUtils.ForceRebuildLayout(page.conMessage)

    return page
end

