require("UI.UIBasePanel")
require("UI.StorePanel.UIStoreSkinPanelView")
require("UI.SkinIconItem.UISkinIconItem")

UIStoreSkinPanel = class("UIStoreSkinPanel", UIBasePanel)
UIStoreSkinPanel.__index = UIStoreSkinPanel

UIStoreSkinPanel.mView = nil

UIStoreSkinPanel.mPath_CostumeItem = "Character/UISkinIconItem.prefab"

UIStoreSkinPanel.skinConfigList = {}
UIStoreSkinPanel.skinItemList = {}
UIStoreSkinPanel.currentSkin = nil
UIStoreSkinPanel.currentModel = nil
UIStoreSkinPanel.curZoomParam = 0
UIStoreSkinPanel.roleType = -1     -- 1 人形  2 npc

UIStoreSkinPanel.mIsViewMode = false
UIStoreSkinPanel.mIsSendingCancelNewTipsCmd = false
UIStoreSkinPanel.mCameraResetPos = vectorzero

--- const
UIStoreSkinPanel.MAX_ZOOM_PARAM = 100
UIStoreSkinPanel.MAX_ZOOM_POS = Vector3(5.47, 1.5, -8.2)
UIStoreSkinPanel.MODEL_VIEW_POS = Vector3(6, 0.15, -4.7)
UIStoreSkinPanel.MODEL_RESET_POS = Vector3(5.39,0.08,-4.36)
--- const

function UIStoreSkinPanel:ctor()
    UIStoreSkinPanel.super.ctor(self)
end

function UIStoreSkinPanel.Open()
    self = UIStoreSkinPanel
end

function UIStoreSkinPanel.Close()

end

--- data：
--- param1 : 角色数据
--- param2 : 角色类型    1 人形   2 NPC
function UIStoreSkinPanel.Init(root, data)
    UIStoreSkinPanel.super.SetRoot(UIStoreSkinPanel, root)
    UIStoreSkinPanel.mData = data[1]
    UIStoreSkinPanel.roleType = data[2]
    UIStoreSkinPanel.mView = UIStoreSkinPanelView
    UIStoreSkinPanel.mView:InitCtrl(root)

    UIUtils.GetButtonListener(UIStoreSkinPanel.mView.mBtn_Return.gameObject).onClick = UIStoreSkinPanel.OnReturnClick
    UIUtils.GetButtonListener(UIStoreSkinPanel.mView.mBtn_ConfirmButton.gameObject).onClick = UIStoreSkinPanel.OnConfirmClick
    UIUtils.GetButtonListener(UIStoreSkinPanel.mView.mBtn_ViewButton.gameObject).onClick = UIStoreSkinPanel.OnViewClick
    UIUtils.GetButtonListener(UIStoreSkinPanel.mView.mBtn_CloseView.gameObject).onClick = UIStoreSkinPanel.OnViewCloseClick
end

function UIStoreSkinPanel.OnInit()
	self = UIStoreSkinPanel

    self:InitPanel()
end

function UIStoreSkinPanel.OnShow()
    self = UIStoreSkinPanel
end

function UIStoreSkinPanel.OnRelease()
    self = UIStoreSkinPanel

    self:ResetModel()

    self.skinConfigList = {}
    self.skinItemList = {}
    self.currentSkin = nil
    self.currentModel = nil
    self.curZoomParam = 0
    self.roleType = -1

    self.mIsViewMode = false
    self.mIsSendingCancelNewTipsCmd = false

    InputSys:OneFingerDragingEvent('-', self.OneFingerDragingEventHandle)
    InputSys:TwoFingerScaleEvent('-', self.TwoFingerScaleHandle)
end

function UIStoreSkinPanel.Hide()
    self = UIStoreSkinPanel
    self:Show(false)
end

----------------- private --------------
function UIStoreSkinPanel:InitPanel()
    if self.mData == nil then
        return
    end

    self.mCameraResetPos = UIMainStorePanel.mRTCamera.position

    self.skinConfigList = self:FiltrateData()
    if self.skinConfigList then
        self:InitSkinList(self.skinConfigList)
    end
    UIUtils.ForceRebuildLayout(self.mView.mTrans_Title)
    self:UpdatePanel()
end

function UIStoreSkinPanel:InitSkinList(skinConfigList)
    if #self.skinItemList > #skinConfigList then
        for i = #skinConfigList, #self.skinItemList do
            self.skinItemList[i]:EnableSkinItem(false)
        end
    end
    for i = 1, #skinConfigList do
        local item = nil
        if i <= #self.skinItemList then
            item = self.skinItemList[i]
        else
            local costumePrefab = UIUtils.GetGizmosPrefab(self.mPath_CostumeItem,self);
            local instObj = instantiate(costumePrefab)
            item = UISkinIconItem.New()
            item:InitCtrl(instObj.transform)
            UIUtils.AddListItem(instObj, self.mView.mTrans_SkinListPanel.transform)
            local btnListener = UIUtils.GetButtonListener(item.mBtn_SkinIcon.gameObject)
            btnListener.onClick = self.OnCostumeItemClick
            btnListener.param = item
            table.insert(self.skinItemList, item)
        end
        item:SetData(skinConfigList[i])
    end
end

function UIStoreSkinPanel:UpdatePanel()
    self:UpdateView()
end

function UIStoreSkinPanel.OnReturnClick(gameobj)
    self = UIStoreSkinPanel
    UIManager.CloseUI(UIDef.UIStoreSkinPanel)
    UIMainStorePanel:ShowPanel()
end

function UIStoreSkinPanel.OnConfirmClick()
    self = UIStoreSkinPanel
    if self.currentSkin == nil then
        return
    end
    if self.currentSkin:GetData().id == self.mData.costume_id then
        return
    end
    local skinId = self.currentSkin:GetData().id
    NetCmdNpcData:SendReqNpcChangeCostumeCmd(self.mData.id, skinId, self.OnChangeSkinCB)
end

function UIStoreSkinPanel.OnViewClick()
    self = UIStoreSkinPanel
    self.mIsViewMode = true
    self:UpdateViewMode()
end

function UIStoreSkinPanel.OnViewCloseClick()
    self = UIStoreSkinPanel
    self.mIsViewMode = false
    self:UpdateViewMode()
end

function UIStoreSkinPanel:FiltrateData()
    local list = {}
    local tableData = TableData.listCostumeDatas
    for i = 0, tableData.Count - 1 do
        local config = tableData[i]
        if config.gun_id == self.mData.id and config.type == self.roleType then
            table.insert(list, config)
        end
    end
    table.sort(list,function (a, b)
        return a.sequence < b.sequence
    end)
    return list
end

function UIStoreSkinPanel:UpdateView()
    for _, item in ipairs(self.skinItemList) do
        local data = item:GetData()
        item.IsLocked = self:IsCostumeLocked(data.id)
        item.IsNew = self:IsCostumeNew(data.id)
        item.IsDressed = data.id == self.mData.costume_id
        if data.id == self.mData.costume_id then
            self.currentSkin = item
            self.OnCostumeItemClick(item.mBtn_SkinIcon.gameObject)
        end
        item:SetState()
    end
    self:UpdateDescription()
    self.mView.mText_SkinHavePerCent.text = self:CalculateSkinHasPercent() .. "<size=30>%</size>"
    self.mView.mText_OverView_GunName.text = self.mData.TabNpcData.name.str
    setactive(self.mView.mTrans_OverView_GunGrade, self.roleType == 1)
    if self.roleType == 1 then
        self:InitGunGrade()
    end
end

function UIStoreSkinPanel:UpdateDescription()
    if self.currentSkin then
        local data = self.currentSkin:GetData()
        self.mView.mText_DescriptionDetailPanel_SkinName.text = data.name.str
        self.mView.mText_DescriptionDetailPanel_SkinDSC.text = data.description.str
        self.mView.mBtn_ConfirmButton.interactable = (not self.currentSkin.IsLocked) and (not self.currentSkin.IsDressed)

        -- Update Model
        self.currentModel = UIMainStorePanel:CreateModel(data.model_config_id)
        self:ResetViewPos()
    end
end

function UIStoreSkinPanel:UpdateViewMode()
    setactive(self.mView.mBtn_ViewButton.gameObject, not self.mIsViewMode)
    setactive(self.mView.mBtn_CloseView.gameObject, self.mIsViewMode)
    setactive(self.mView.mTrans_SkinOption.gameObject, not self.mIsViewMode)

    if self.mIsViewMode then
        InputSys:OneFingerDragingEvent('+', self.OneFingerDragingEventHandle)
        InputSys:TwoFingerScaleEvent('+', self.TwoFingerScaleHandle)
        self:MoveModelToPos(self.MODEL_VIEW_POS)
    else
        InputSys:OneFingerDragingEvent('-', self.OneFingerDragingEventHandle)
        InputSys:TwoFingerScaleEvent('-', self.TwoFingerScaleHandle)
        self:ResetViewPos(true)
    end
end

function UIStoreSkinPanel.OnCostumeItemClick(gameObject)
    self = UIStoreSkinPanel
    if self.mIsSendingCancelNewTipsCmd then
        return
    end
    if self.currentSkin then
        self.currentSkin:SetClicked(false)
    end
    local btnListener = getcomponent(gameObject, typeof(CS.ButtonEventTriggerListener))
    if btnListener ~= nil then
        local costumeItem = btnListener.param
        costumeItem:SetClicked(true)
        self.currentSkin = costumeItem
        local data = costumeItem:GetData()
        if costumeItem.IsNew then
            local skinId = data.id
            NetCmdIllustrationData:SendCmdCancelNewTips(10, skinId, UIStoreSkinPanel.RefreshNewTips)
            self.mIsSendingCancelNewTipsCmd = true
        end
        self:UpdateDescription()
    end
end

function UIStoreSkinPanel.OnChangeSkinCB()
    self = UIStoreSkinPanel
    self:UpdatePanel()
end

function UIStoreSkinPanel.OneFingerDragingEventHandle(touchPoint, offset)
    self = UIStoreSkinPanel
    local delta = offset.x
    self.currentModel.transform:Rotate(Vector3.down, delta)
end

function UIStoreSkinPanel.TwoFingerScaleHandle(delta)
    self = UIStoreSkinPanel

    self.curZoomParam = self.curZoomParam + (delta * 100)
    self.curZoomParam = math.min(self.curZoomParam, self.MAX_ZOOM_PARAM)
    self.curZoomParam = math.max(self.curZoomParam, 0)

    local zoomPercent = self.curZoomParam / self.MAX_ZOOM_PARAM
    local offsetPos = self.MAX_ZOOM_POS - self.mCameraResetPos
    local pos = self.mCameraResetPos + (offsetPos * zoomPercent)

    UIMainStorePanel.mRTCamera.position = pos
end

function UIStoreSkinPanel.RefreshNewTips()
    self = UIStoreSkinPanel
    NetCmdIllustrationData:RemoveNewTips(10, self.currentSkin:GetData().id)
    self.currentSkin.IsNew = false
    self.currentSkin:SetState()
    self.mIsSendingCancelNewTipsCmd = false
end

function UIStoreSkinPanel:IsCostumeLocked(costumeId)
    local indexData = NetCmdIllustrationData:GetIllustrationData(10)
    if indexData == nil then
        return true
    end

    local isLocked = true
    for id, item in pairs(indexData.Details) do
        if costumeId == id then
            isLocked = false
            break
        end
    end
    --for m = 0, indexData.Details.Keys.Count - 1 do
    --    if costumeId == indexData.stc_ids[m] then
    --        isLocked = false
    --        break
    --    end
    --end
    return isLocked
end

function UIStoreSkinPanel:IsCostumeNew(costumeId)
    local indexData = NetCmdIllustrationData:GetIllustrationData(10)
    if indexData == nil then
        return false
    end

    for id, item in pairs(indexData.Details) do
        if costumeId == id then
            return item
        end
    end

    --for m = 0, indexData.news.Length - 1 do
    --    if costumeId == indexData.news[m] then
    --        return true
    --    end
    --end


    return false
end

function UIStoreSkinPanel:CalculateSkinHasPercent()
    local count = 0
    for _, skin in ipairs(self.skinItemList) do
        if not skin.IsLocked then
            count = count + 1
        end
    end
    return math.ceil((count / #self.skinItemList) * 100)
end

function UIStoreSkinPanel:MoveModelToPos(pos)
    CS.UITweenManager.PlayLocalPositionTween(self.currentModel.transform, self.currentModel.transform.localPosition, pos, 0.3)
end

function UIStoreSkinPanel:ResetViewPos(needMove)
    needMove = needMove == true and true or false
    self.currentModel.transform.localEulerAngles = Vector3(0,180,0)
    UIMainStorePanel.mRTCamera.position = self.mCameraResetPos
    if needMove then
        self:MoveModelToPos(self.MODEL_RESET_POS)
    else
        self.currentModel.transform.localPosition = self.MODEL_RESET_POS
    end

end

function UIStoreSkinPanel:ResetModel()
    if self.currentSkin:GetData().id ~= self.mData.costume_id then
        local data = TableData.GetGunCostumesData(self.mData.costume_id).model_config_id
        self.currentModel = UIMainStorePanel:CreateModel(data)
    end
    self.currentModel.transform.position = Vector3(4.9,0.15,-4.36)
    self.currentModel.transform.localEulerAngles = Vector3(0,180,0)
    UIMainStorePanel.mRTCamera.position = self.mCameraResetPos
end

--- TODO 人形星级显示
function UIStoreSkinPanel:InitGunGrade()

end