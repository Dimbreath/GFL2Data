require("UI.UIBasePanel")
require("UI.CommonReadmePanel.UICommonReadmePanelView")

UICommonReadmePanel = class("UICommonReadmePanel", UIBasePanel)
UICommonReadmePanel.__index = UICommonReadmePanel

UICommonReadmePanel.mView = nil
UICommonReadmePanel.panelId = 0
UICommonReadmePanel.tagPrefab = nil
UICommonReadmePanel.tagList = {}
UICommonReadmePanel.curTag = nil
UICommonReadmePanel.isPlayAni = false

UICommonReadmePanel.TagPrefabPath = "Readme/UICommonReadMeTagItem.prefab"

function UICommonReadmePanel:ctor()
    UICommonReadmePanel.super.ctor(self)
end

function UICommonReadmePanel.Close()
    UIManager.CloseUI(UIDef.UICommonReadmePanel)
end

function UICommonReadmePanel.OnRelease()
    UICommonReadmePanel.tagList = {}
    UICommonReadmePanel.curTag = nil
    UICommonReadmePanel.isPlayAni = false
    if UICommonReadmePanel.tagPrefab then
        ResourceManager:UnloadAsset(UICommonReadmePanel.tagPrefab)
        UICommonReadmePanel.tagPrefab = nil
    end
end

function UICommonReadmePanel.Init(root, data)
    UICommonReadmePanel.super.SetRoot(UICommonReadmePanel, root)

    self = UICommonReadmePanel
    self.mIsPop = true
    self.mView = UICommonReadmePanelView.New()
    self.mView:InitCtrl(root)

    if data then
        self.panelId = data
        self:UpdatePanel()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_CloseButton.gameObject).onClick = function ()
        UICommonReadmePanel.Close()
    end
end

function UICommonReadmePanel:UpdatePanel()
    if self.panelId > 0 then
        local data = TableData.listReadmeDatas:GetDataById(self.panelId)
        if data then
            for i = 0, data.tag_id.Count - 1 do
                local tag = self:CreateTag()
                if tag then
                    self:UpdateTag(tag, data.tag_id[i])
                    table.insert(self.tagList, tag)
                end
                if i == 0 then
                    self:OnClickTag(tag)
                end
            end
        end
    end
end

function UICommonReadmePanel:CreateTag()
    if self.tagPrefab == nil then
        self.tagPrefab = UIUtils.GetUIRes(UICommonReadmePanel.TagPrefabPath,false)
    end
    local obj = instantiate(self.tagPrefab)
    obj.transform:SetParent(self.mView.mVLayout_ButtonListPanel.transform, false)
    local tag = {}
    tag.obj = obj
    tag.data = nil
    tag.transSelect = UIUtils.GetObject(obj, "Trans_Sel")
    tag.txtName = UIUtils.GetText(obj, "Text_ChapterName")
    tag.btnChoose = UIUtils.GetObject(obj, "Btn_ChooseButton")
    tag.txtSelectName = UIUtils.GetText(obj, "Trans_Sel/Text_ChapterName")

    setactive(tag.transSelect, false)

    return tag
end

function UICommonReadmePanel:UpdateTag(tag, tagId)
    if tag == nil or tagId == nil then
        return
    end
    local tagData = TableData.listReadmeTagDatas:GetDataById(tagId)
    if tagData then
        tag.data = tagData
        tag.txtName.text = tagData.tag_name.str
        tag.txtSelectName.text = tagData.tag_name.str

        local tempTag = tag
        UIUtils.GetButtonListener(tag.btnChoose).onClick = function ()
            self:OnClickTag(tempTag)
        end
    end
end

function UICommonReadmePanel:OnClickTag(tag)
    if tag and not self.isPlayAni then
        if self.curTag then
            if self.curTag.data.id == tag.data.id then
                return
            end
            setactive(self.curTag.transSelect, false)
        end

        setactive(tag.transSelect, true)
        self.curTag = tag

        self:UpdateContent(self.curTag.data)
    end
end

function UICommonReadmePanel:UpdateContent(data)
    if data then
        setactive(self.mView.mText_Title.gameObject, data.title_name ~= nil)
        setactive(self.mView.mText_HintDetail.gameObject, data.hint_detail ~= nil)
        setactive(self.mView.mTrans_BannerImagePanel.gameObject, not self:IsEmptyStr(data.banner_name))
        setactive(self.mView.mTrans_HugeImagePanel.gameObject, not self:IsEmptyStr(data.img_name))

        self.mView.mCanvasGroup.alpha = 0
        self.isPlayAni = true

        if data.title_name ~= nil then
            self.mView.mText_Title.text = data.title_name.str
        end

        if data.hint_detail ~= nil then
            local hint = CS.LuaUIUtils.Unescape(data.hint_detail.str)
            self.mView.mText_HintDetail.text = hint
        end

        if not self:IsEmptyStr(data.banner_name) then
            self.mView.mImage_BannerImagePanel_ADImage.sprite = IconUtils.GetReadmeSprite(data.banner_name)
        end

        if not self:IsEmptyStr(data.img_name) then
            self.mView.mImage_HugeImagePanel_ADImage.sprite = IconUtils.GetReadmeSprite(data.img_name)
        end

        setactive(self.mView.mTrans_ReadmeContent.gameObject, true)

        TimerSys:DelayCall(0.1, function ()
            UIUtils.ForceRebuildLayout(self.mView.mTrans_Message)
            self.mView.mScroll_Content.verticalNormalizedPosition = 1
        end)

        DOTween.CanvasGroupFade(self.mView.mCanvasGroup, 0.4, 1, 0.2, function ()
            self.isPlayAni = false
        end)
    else
        setactive(self.mView.mTrans_ReadmeContent.gameObject, false)
    end
end

function UICommonReadmePanel:IsEmptyStr(str)
    if str == nil or str == "" then
        return true
    end
    return false
end

