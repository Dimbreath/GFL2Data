require("UI.UIBaseCtrl")

UIGuildQuestItem = class("UIGuildQuestItem", UIBaseCtrl)
UIGuildQuestItem.__index = UIGuildQuestItem

UIGuildQuestItem.guildData = nil
UIGuildQuestItem.type = 0
UIGuildQuestItem.rewardItemList = {}
UIGuildQuestItem.mData = nil

function UIGuildQuestItem:ctor()
    UIGuildQuestItem.super.ctor(self)
    self.rewardItemList = {}
end

function UIGuildQuestItem:__InitCtrl()
    self.mBtn_UndoQuest_GotoQuest = self:GetButton("UI_Trans_UndoQuest/Btn_GotoQuest")
    self.mBtn_CompleteQuest = self:GetButton("UI_Trans_FinishedQuest/Btn_CompleteQuest")
    self.mImage_UnDoIcon = self:GetImage("UI_Trans_UndoQuest/Mask/Image_IconImage")
    self.mImage_FinishIcon = self:GetImage("UI_Trans_FinishedQuest/Mask/Image_IconImage")
    self.mText_UndoQuest_Title = self:GetText("UI_Trans_UndoQuest/Mask/Text_Title")
    self.mText_UndoQuest_Progress = self:GetText("UI_Trans_UndoQuest/Mask/Text_Progress")
    self.mText_FinishQuest_Title = self:GetText("UI_Trans_FinishedQuest/Mask/Text_Title")
    self.mText_FinishQuest_Progress = self:GetText("UI_Trans_FinishedQuest/Mask/Text_Progress")
    self.mText_UndoTask = self:GetText("UI_Trans_UndoQuest/Mask/Text_Task")
    self.mText_FinishTask = self:GetText("UI_Trans_FinishedQuest/Mask/Text_Task")
    self.mTrans_UndoQuest = self:GetRectTransform("UI_Trans_UndoQuest")
    self.mTrans_FinishQuest = self:GetRectTransform("UI_Trans_FinishedQuest")
    self.mTrans_ItemList = self:GetRectTransform("UI_Trans_ItemList")
    self.mSlider_UndoQuest = self:GetSlider("UI_Trans_UndoQuest/Mask/Scrollbar")
    self.mSlider_FinishQuest = self:GetSlider("UI_Trans_FinishedQuest/Mask/Scrollbar")
end

function UIGuildQuestItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("Guild/UIGuildQuestItem.prefab",self))
    setparent(parent, obj.transform)
    obj.transform.localScale = vectorone
    self:SetRoot(obj.transform)
    self:__InitCtrl()

    UIUtils.GetButtonListener(self.mBtn_UndoQuest_GotoQuest.gameObject).onClick = function()
        self:OnGotoBtnClick()
    end
end

function UIGuildQuestItem:SetData(data)
    self.mData = data
    if data then
        self.mText_UndoQuest_Title.text = data.tableData.name.str
        self.mText_FinishQuest_Title.text = data.tableData.name.str
        self.mText_UndoTask.text = data.tableData.description.str
        self.mText_FinishTask.text = data.tableData.description.str
        self.mText_UndoQuest_Progress.text = data:GetProgressStr()
        self.mText_FinishQuest_Progress.text = data:GetProgressStr()

        self.mSlider_FinishQuest.value = data:GetProgress()
        self.mSlider_UndoQuest.value = data:GetProgress()

        local state = data:GetState()
        setactive(self.mBtn_UndoQuest_GotoQuest, state == 0)
        setactive(self.mBtn_CompleteQuest, state == 1)
        setactive(self.mTrans_UndoQuest, state == 0)
        setactive(self.mTrans_FinishQuest, state == 1)

        local datas = data.tableData.reward_list
        local prefab = UIUtils.GetGizmosPrefab(UICommonItemS.Path_UICommonItemS, self)

        for _, v in ipairs(self.rewardItemList) do
            v:SetData(nil, nil)
        end

        local i = 1
        for itemId, num in pairs(datas) do
            if i < #self.rewardItemList then
                self.rewardItemList[i]:SetData(itemId, num)
            else
                local instObj = instantiate(prefab)
                local itemview = UICommonItemS.New()
                itemview:InitCtrl(instObj.transform)
                itemview:SetData(itemId, num)
                UIUtils.AddListItem(instObj, self.mTrans_ItemList.transform)
                table.insert(self.rewardItemList, itemview)
            end
            i = i + 1
        end
    end
end

function UIGuildQuestItem:OnGotoBtnClick()

end
