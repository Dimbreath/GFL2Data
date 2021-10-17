require("UI.UIBaseCtrl")

UISimCombatTeachingRewardItemV2 = class("UISimCombatTeachingRewardItemV2", UIBaseCtrl);
UISimCombatTeachingRewardItemV2.__index = UISimCombatTeachingRewardItemV2
--@@ GF Auto Gen Block Begin
function UISimCombatTeachingRewardItemV2:__InitCtrl()
    self.mTrans_Root = self:GetRectTransform("Root")

    self.mText_Name = self:GetText("GrpCollectNum/GrpTaskName/Text_Task")
    self.mText_Num = self:GetText("GrpCollectNum/GrpPer/Text_Num")

    self.mTrans_Content = self:GetRectTransform("GrpReward/Content")

    self.mTrans_UnCompleted = self:GetRectTransform("GrpState/Trans_TextUnCompleted")
    self.mTrans_Completed = self:GetRectTransform("GrpState/Trans_TextCompleted")
    self.mTrans_CanCompleted = self:GetRectTransform("GrpState/Trans_TextCanCompleted")

    self.mBtn_Receive = UIUtils.GetTempBtn(self:GetRectTransform("GrpState/Trans_TextCanCompleted"))
end

--@@ GF Auto Gen Block End

UISimCombatTeachingRewardItemV2.mData = nil


function UISimCombatTeachingRewardItemV2:InitCtrl(root)
    self:SetRoot(root);
    self:__InitCtrl();

end



function UISimCombatTeachingRewardItemV2:SetData(data)
    if data then
        self.mData = data
        setactive(self.mUIRoot.gameObject, true)

        self.mText_Name.text = data.StcData.chapter_mission
        self.mText_Num.text = TableData.GetHintById(103038)..": "..data.Progress .."%"

        for itemId, itemNum in pairs(data.Reward) do
            local item = UICommonItem.New()
            item:InitCtrl(self.mTrans_Content)
            item:SetItemData(itemId, itemNum)              
        end

        
        if(data.IsReceived) then
            setactive(self.mTrans_Completed,true)
            setactive(self.mTrans_UnCompleted,false)
            setactive(self.mTrans_CanCompleted,false)
        elseif(data.IsCompleted) then
            setactive(self.mTrans_Completed,false)
            setactive(self.mTrans_UnCompleted,false)
            setactive(self.mTrans_CanCompleted,true)
        else
            setactive(self.mTrans_Completed,false)
            setactive(self.mTrans_UnCompleted,true)
            setactive(self.mTrans_CanCompleted,false)
        end
    else
        setactive(self.mUIRoot.gameObject, false)
    end
    
end


