require("UI.UIBaseCtrl")

UIDailyQuestListItem = class("UIDailyQuestListItem", UIBaseCtrl);
UIDailyQuestListItem.__index = UIDailyQuestListItem
--@@ GF Auto Gen Block Begin
UIDailyQuestListItem.mBtn_UndoQuest_GotoQuest = nil;
UIDailyQuestListItem.mImage_IconImage = nil;
UIDailyQuestListItem.mText_Title = nil;
UIDailyQuestListItem.mText_Task = nil;
UIDailyQuestListItem.mText_Progress = nil;
UIDailyQuestListItem.mTrans_UndoQuest = nil;
UIDailyQuestListItem.mTrans_FinishQuest1 = nil;
UIDailyQuestListItem.mTrans_ItemList = nil;
--UIDailyQuestListItem.mTrans_FinishQuest2 = nil;

function UIDailyQuestListItem:__InitCtrl()
    

    self.mBtn_UndoQuest_GotoQuest = self:GetSelfButton();
 
    self.mTrans_RewardItem =   self:GetRectTransform("GrpItem");
    
    self.mText_Title = self:GetText("GrpCenterText/Text_Tittle");
    self.mText_Task = self:GetText("GrpCenterText/Text_Content");
    self.mText_Progress = self:GetText("GrpCenterText/Text_Percent");
    self.mTrans_UndoQuest = self:GetRectTransform("GrpState/GrpAction");
    self.mTrans_FinishQuest1 = self:GetRectTransform("GrpState/GrpTextCompleted");
    --self.mTrans_ItemList = self:GetRectTransform("UI_Trans_ItemList");
    self.mTrans_FinishQuest2 = self:GetRectTransform("GrpItem/Trans_GrpCompleted");
end

--@@ GF Auto Gen Block End

UIDailyQuestListItem.mItemViewList = nil;
UIDailyQuestListItem.mFinishColor = "FDFDFD";
UIDailyQuestListItem.mUnFinishColor = "2e3337";

UIDailyQuestListItem.mItemView = nil;

function UIDailyQuestListItem:InitCtrl()

    local obj = instantiate(UIUtils.GetGizmosPrefab("DailyQuest/DailyQuestItemV2.prefab",self));
    self:SetRoot(obj.transform);
    self:__InitCtrl();

    self.mItemViewList = List:New();

    self.mImageScrollBar1 = self:GetImage("GrpCenterText/GrpProgressBar/Img_ProgressBar");
  
end

function UIDailyQuestListItem:SetData(data, typeData)
    if data ~= nil then
        setactive(self.mUIRoot, true);

        self.mText_Title.text = data.name;
        self.mText_Task.text = data.description
        self.mText_Progress.text = data:GetProgressStr();
        self.mImageScrollBar1.fillAmount = data:GetProgress();




        local state = data:GetState();

        if state == 0 then
            setactive(self.mBtn_UndoQuest_GotoQuest, true);

            setactive(self.mTrans_FinishQuest1,false);
            setactive(self.mTrans_FinishQuest2,false);
            setactive(self.mTrans_UndoQuest, true);

            self.mText_Title.color = CS.GF2.UI.UITool.StringToColor(self.mUnFinishColor);
            self.mText_Task.color = CS.GF2.UI.UITool.StringToColor(self.mUnFinishColor);
            self.mText_Progress.color = CS.GF2.UI.UITool.StringToColor(self.mUnFinishColor);


        elseif state == 1 then
            setactive(self.mBtn_UndoQuest_GotoQuest, false);

            setactive(self.mTrans_FinishQuest1,true);
            setactive(self.mTrans_FinishQuest2,true);
            setactive(self.mTrans_UndoQuest, false);

        elseif state == 2 then


            self.mBtn_UndoQuest_GotoQuest.interactable = false
            setactive(self.mTrans_FinishQuest1,true);
            setactive(self.mTrans_FinishQuest2,true);
            setactive(self.mTrans_UndoQuest, false);

            self.mText_Title.color = CS.GF2.UI.UITool.StringToColor(self.mFinishColor);
            self.mText_Task.color = CS.GF2.UI.UITool.StringToColor(self.mFinishColor);
            self.mText_Progress.color = CS.GF2.UI.UITool.StringToColor(self.mFinishColor);

            self.mText_Progress.text ="100%" ;
            self.mImageScrollBar1.fillAmount = 1;

        else
            gferror(data.id);
        end

        if (self.mItemView ~= nil) then
            gfdestroy(self.mItemView.mObj)
        end
        
       
        if state == 0 then
            local datas = data.rewardList;
            local stcData = nil;
            for itemId, num in pairs(datas) do
                stcData = TableData.GetItemData(itemId)
                self.mItemView = UICommonItem.New();
                self.mItemView:InitCtrl(self.mTrans_RewardItem.transform)
                self.mItemView:SetItemData(stcData.id, num)
            end
        end


    else
        setactive(self.mUIRoot, false);
    end
end