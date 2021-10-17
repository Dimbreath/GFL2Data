require("UI.UIBaseCtrl")

UISimCombatTeachingChapterItemV2 = class("UISimCombatTeachingChapterItemV2", UIBaseCtrl);
UISimCombatTeachingChapterItemV2.__index = UISimCombatTeachingChapterItemV2
--@@ GF Auto Gen Block Begin
function UISimCombatTeachingChapterItemV2:__InitCtrl()
    self.mTrans_Root = self:GetRectTransform("Root")

    self.mImg_Bg = self:GetImage("Root/GrpChapter/GrpBg/Img_Bg")
    self.mImg_Icon = self:GetImage("Root/GrpChapter/GrpIcon/Img_Icon")
    self.mTxt_Name = self:GetText("Root/GrpChapter/GrpText/Text_Name")
    self.mTxt_TextLock = self:GetText("Root/GrpState/Trans_TextLock")
    self.mTxt_Progress = self:GetText("Root/GrpState/Trans_TextProgress")

    self.mTrans_Lock = self:GetRectTransform("Root/GrpChapter/Trans_GrpLock")
    self.mTrans_Progress = self:GetRectTransform("Root/GrpState/Trans_TextProgress")
    self.mTrans_Finish = self:GetRectTransform("Root/GrpState/Trans_Finish")
    self.mTrans_RedPoint = self:GetRectTransform("Root/Trans_RedPoint")

    self:InstanceUIPrefab("UICommonFramework/ComRedPointItemV2.prefab", self.mTrans_RedPoint, true)

    self.mTrans_Guide = self:GetRectTransform("Root/Trans_BtnGuide")
    self.mBtn_Guide = self:GetButton("Root/Trans_BtnGuide/Btn_Guide")

    self.mBtn_SelfBtn = self:GetButton("Root")
end

--@@ GF Auto Gen Block End

UISimCombatTeachingChapterItemV2.mData = nil
UISimCombatTeachingChapterItemV2.stageData = nil
UISimCombatTeachingChapterItemV2.isUnLock = false

UISimCombatTeachingChapterItemV2.OrangeColor = Color(246 / 255, 113 / 255, 25 / 255, 255 / 255)
UISimCombatTeachingChapterItemV2.WhiteColor = Color(1, 1, 1, 0.6)

function UISimCombatTeachingChapterItemV2:InitCtrl(root)
    self:SetRoot(root);
    self:__InitCtrl();

end



function UISimCombatTeachingChapterItemV2:SetData(data)
    if data then
        self.mData = data
        setactive(self.mUIRoot.gameObject, true)
        self.mImg_Bg.sprite = IconUtils.GetAtlasV2("SimCombatTeaching", data.StcData.chapter_Bg);
        self.mImg_Icon.sprite = IconUtils.GetAtlasV2("SimCombatTeaching", data.StcData.chapter_icon);
        self.mTxt_Name.text = data.StcData.chapter_name;

        if(data.IsUnlocked and data.IsPrevCompleted) then
            setactive(self.mTrans_Lock,false);
            setactive(self.mTxt_TextLock.gameObject,false);
            setactive(self.mTrans_Progress,true)

            if(data.Progress < 100) then
                setactive(self.mTrans_Finish,false);
                setactive(self.mTrans_Progress,true)
                self.mTxt_Progress.text = TableData.GetHintById(103038)..": "..data.Progress .."%"
            else
                setactive(self.mTrans_Finish,true);
                setactive(self.mTrans_Progress,false)
            end
            
            setactive(self.mTrans_Guide,false)
            -- local completeIds = data:GetCompleteIds();
            -- if(completeIds.Count > 0) then
            --     setactive(self.mTrans_Guide,true)
            -- else
            --     setactive(self.mTrans_Guide,false)
            -- end

            -- UIUtils.GetButtonListener(self.mBtn_Guide.gameObject).onClick = function()
            --     self:ShowGuide(data)
            -- end
        

        else
            setactive(self.mTrans_Lock,true);
            setactive(self.mTxt_TextLock.gameObject,true);
            setactive(self.mTrans_Progress,false)

        end

        self:UpdateRedPoint()
    else
        setactive(self.mUIRoot.gameObject, false)
    end
    
end

function UISimCombatTeachingChapterItemV2:UpdateRedPoint()
    if(self.mData:CheckRedPoint()) then
        setactive(self.mTrans_RedPoint,true)
    else
        setactive(self.mTrans_RedPoint,false)
    end
end


function UISimCombatTeachingChapterItemV2:UpdateLockState()
    if self.mData.unlock == 1 then
        return true
    elseif self.mData.unlock == 2 then
        return NetCmdSimulateBattleData:CheckStageIsUnLock(self.mData.unlock_detail)
    elseif self.mData.unlock == 3 then

    end
end

function UISimCombatTeachingChapterItemV2:SetDisable()
    self.mBtn_SelfBtn.interactable = false;
end

function UISimCombatTeachingChapterItemV2:ShowGuide(data)
    local completeIds = data:GetCompletedTutorials();

end
