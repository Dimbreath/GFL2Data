require("UI.UIBaseCtrl")

UISimCombatTeachingLevelItemV2 = class("UISimCombatTeachingLevelItemV2", UIBaseCtrl);
UISimCombatTeachingLevelItemV2.__index = UISimCombatTeachingLevelItemV2
--@@ GF Auto Gen Block Begin
function UISimCombatTeachingLevelItemV2:__InitCtrl()
    self.mTrans_Root = self:GetRectTransform("Root")

    self.mText_Name = self:GetText("GrpLevelName/Text_Name")
    self.mText_Num = self:GetText("GrpNum/Text_Num")

    self.mTrans_Lock = self:GetRectTransform("GrpState/Trans_Lock")
    self.mTrans_Unlock = self:GetRectTransform("GrpState/Trans_TextUnlock")
    self.mTrans_Finish = self:GetRectTransform("GrpState/Trans_TextFinish")

    self.mTrans_Now = self:GetRectTransform("GrpBg/ImgNow")
    self.mTrans_Complete = self:GetRectTransform("GrpBg/ImgComplete")
    self.mTrans_Frame = self:GetRectTransform("GrpBg/ImgFrame")

    self.mBtn_SelfBtn = self:GetSelfButton()
end

--@@ GF Auto Gen Block End

UISimCombatTeachingLevelItemV2.mData = nil
UISimCombatTeachingLevelItemV2.stageData = nil
UISimCombatTeachingLevelItemV2.isUnLock = false
UISimCombatTeachingLevelItemV2.mAnimator = nil;

UISimCombatTeachingLevelItemV2.OrangeColor = Color(246 / 255, 113 / 255, 25 / 255, 255 / 255)
UISimCombatTeachingLevelItemV2.WhiteColor = Color(1, 1, 1, 0.6)

function UISimCombatTeachingLevelItemV2:InitCtrl(root)
    self:SetRoot(root);
    self:__InitCtrl();

    self.mAnimator = self.mUIRoot:GetComponent("Animator")
end



function UISimCombatTeachingLevelItemV2:SetData(data)
    if data then
        self.mData = data
        setactive(self.mUIRoot.gameObject, true)

        self.mText_Name.text = data.StageData.name.str;
        self.mText_Num.text = data.StcData.number

        if(data.IsUnlocked) then
            setactive(self.mTrans_Lock, false)

            if(data.IsCompleted) then
                setactive(self.mTrans_Finish,true)
                setactive(self.mTrans_Complete,true)
                setactive(self.mTrans_Now,false)
                setactive(self.mTrans_Unlock,false)

                self.mAnimator:SetBool("Completed",true)
            else
                setactive(self.mTrans_Finish,false)
                setactive(self.mTrans_Complete,false)
                setactive(self.mTrans_Now,true)
                setactive(self.mTrans_Unlock,true)

                self.mAnimator:SetBool("Completed",false)
            end
        else
            setactive(self.mTrans_Lock, true)
            setactive(self.mTrans_Unlock,false)
            setactive(self.mTrans_Finish,false)
        end
        
    else
        setactive(self.mUIRoot.gameObject, false)
    end
    
end

function UISimCombatTeachingLevelItemV2:SetSelected(isChoose)
    self.mBtn_SelfBtn.interactable = not isChoose;
end


function UISimCombatTeachingLevelItemV2:UpdateLockState()
    if self.mData.unlock == 1 then
        return true
    elseif self.mData.unlock == 2 then
        return NetCmdSimulateBattleData:CheckStageIsUnLock(self.mData.unlock_detail)
    elseif self.mData.unlock == 3 then

    end
end

