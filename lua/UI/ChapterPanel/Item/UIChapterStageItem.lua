require("UI.UIBaseCtrl")

UIChapterStageItem = class("UIChapterStageItem", UIBaseCtrl)
UIChapterStageItem.__index = UIChapterStageItem

function UIChapterStageItem:__InitCtrl()

	self.mBtn_ChapterStage = self:GetButton("Btn_ChapterStage")
	self.mText_StageNumber = self:GetText("Btn_ChapterStage/Trans_Stage/Trans_Normal/Text_StageNumber")
	self.mText_StageName = self:GetText("Btn_ChapterStage/Trans_Stage/Trans_Normal/Text_StageName")
    self.mText_BranchName = self:GetText("Btn_ChapterStage/Trans_Stage/Trans_Branch/Text_StageName")
    self.mText_BranchCode = self:GetText("Btn_ChapterStage/Trans_Stage/Trans_Branch/BranchText")
    self.mImage_Camp = self:GetImage("Btn_ChapterStage/Trans_Stage/Trans_Branch/Trans_CampMask/Image_Camp")
    self.mImage_Story = self:GetImage("Btn_ChapterStage/Trans_Story/Image_Story")
    self.mImage_LeftPoint = self:GetImage("Trans_LeftPoint/Image_Trans_LeftPoint")
    self.mImage_RightPoint1 = self:GetImage("Trans_RightPoint/Image_RightLine1")
    self.mImage_RightPoint2 = self:GetImage("Trans_RightPoint/Image_RigntLine2")
	self.mTrans_BossImage = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Normal/Trans_BossImage")
	self.mTrans_challenge1 = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Normal/ChallengePanel/Trans_challenge1")
	self.mTrans_challenge2 = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Normal/ChallengePanel/Trans_challenge2")
	self.mTrans_challenge3 = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Normal/ChallengePanel/Trans_challenge3")
    self.mTrans_Branchchallenge1 = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Branch/ChallengePanel/Trans_challenge1")
    self.mTrans_Branchchallenge2 = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Branch/ChallengePanel/Trans_challenge2")
    self.mTrans_Branchchallenge3 = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Branch/ChallengePanel/Trans_challenge3")
	self.mTrans_ChosenBackground = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Choose")
    self.mTrans_NormalBg = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Normal/Trans_NormalBG")
    -- self.mTrans_HardBg = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Normal/Trans_HardBG")
	self.mTrans_Lock = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Normal/Trans_Lock")
    self.mTrans_BranchLock = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Branch/Trans_Lock")
	self.mTrans_LeftPoint = self:GetRectTransform("Trans_LeftPoint")
	self.mTrans_RightPoint = self:GetRectTransform("Trans_RightPoint")
    self.mTrans_Noraml = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Normal")
    self.mTrans_Branch = self:GetRectTransform("Btn_ChapterStage/Trans_Stage/Trans_Branch")
    self.mTrans_Stage = self:GetRectTransform("Btn_ChapterStage/Trans_Stage")
    self.mTrans_Story = self:GetRectTransform("Btn_ChapterStage/Trans_Story")
    self.mTrans_StoryChoose = self:GetRectTransform("Btn_ChapterStage/Trans_Story/Trans_StoryChoose")
    self.mTrans_StoryLock = self:GetRectTransform("Btn_ChapterStage/Trans_Story/Trans_StoryLock")
	self.mTrans_Mask = self:GetRectTransform("Trans_Mask")
    self.mTrans_Next = self:GetRectTransform("Trans_Next")
end

--@@ GF Auto Gen Block End

UIChapterStageItem.mData = nil
UIChapterStageItem.mIsUnLock = false
UIChapterStageItem.currentPoint = nil
UIChapterStageItem.isHard = false
function UIChapterStageItem:InitCtrl(obj)
    self:SetRoot(obj)
    self:__InitCtrl()
end


function UIChapterStageItem:SetData(data, isDifficulty)
    self.mData = data
    self.isHard = isDifficulty

    if data ~= nil then
        setactive(self.mTrans_Stage, data.type ~= GlobalConfig.StoryType.Story)
        setactive(self.mTrans_Story, data.type == GlobalConfig.StoryType.Story)
        if data.type ~= GlobalConfig.StoryType.Story then
            self:UpdateStage()
        else
            self:UpdateStory()
        end

        self:ResetPoint()
        setactive(self.mUIRoot,true)
    else
        setactive(self.mUIRoot,false)
    end
end

function UIChapterStageItem:ResetPoint()
    setactive(self.mTrans_RightPoint, false)
    setactive(self.mTrans_LeftPoint, false)
    self.mTrans_RightPoint.pivot = Vector2(1, 0)
    self.mTrans_LeftPoint.pivot = Vector2(0, 0.5)
    if self.mTrans_LeftPoint.anchoredPosition.y ~= self.mTrans_RightPoint.anchoredPosition.y then
        self.mTrans_RightPoint.anchoredPosition = Vector2(self.mTrans_RightPoint.anchoredPosition.x, self.mTrans_LeftPoint.anchoredPosition.y)
    end
end

function UIChapterStageItem:SetPointColor(nextStoryIsUnLock)
    local color = nextStoryIsUnLock and UIChapterPanel.OrangeColor or UIChapterPanel.WhiteColor
    self.mImage_LeftPoint.color = self.mIsUnLock and UIChapterPanel.OrangeColor or UIChapterPanel.WhiteColor
    self.mImage_RightPoint1.color = color
    self.mImage_RightPoint2.color = color
end

function UIChapterStageItem:UpdateStage()
    local stageData=TableData.GetStageData(self.mData.stage_id)
    local stageRecord = NetCmdDungeonData:GetCmdStoryData(self.mData.id)

    if stageData ~=nil then
        self.mText_StageName.text = self.mData.name.str
        self.mText_BranchName.text = self.mData.name.str
        self.mText_StageNumber.text = self.mData.code
        self.mText_BranchCode.text = self.mData.code
        self.mIsUnLock = NetCmdDungeonData:IsUnLockStory(self.mData.id)
        if(self.mData.type == GlobalConfig.StoryType.Branch) then
            local campData = TableData.listCampDatas:GetDataById(self.mData.camp)
            self.mImage_Camp.sprite = UIUtils.GetIconSprite("Icon/Camp",campData.icon);
        end


        local isNext = stageRecord == nil and true or (stageRecord.first_pass_time <= 0)
        setactive(self.mTrans_Lock, self.mData.type == GlobalConfig.StoryType.Normal and not self.mIsUnLock)
        setactive(self.mTrans_BranchLock, self.mData.type == GlobalConfig.StoryType.Branch and not self.mIsUnLock)
        setactive(self.mTrans_Noraml, self.mData.type == GlobalConfig.StoryType.Normal)
        setactive(self.mTrans_Branch, self.mData.type == GlobalConfig.StoryType.Branch)
        setactive(self.mImage_Camp, self.mData.type == GlobalConfig.StoryType.Branch)
        setactive(self.mTrans_NormalBg, not self.isHard)
        -- setactive(self.mTrans_HardBg, self.isHard)
        setactive(self.mTrans_Next, self.mData.type == GlobalConfig.StoryType.Normal and isNext and self.mIsUnLock)
    else
        gfdebug("  "..self.mData.stage_id)
    end

    local cmdData= NetCmdDungeonData:GetCmdStoryData(self.mData.id)
    if self.mData.type == GlobalConfig.StoryType.Normal then
        self:UpdateChallenge(cmdData, "mTrans_challenge")
    elseif self.mData.type == GlobalConfig.StoryType.Branch then
        self:UpdateChallenge(cmdData, "mTrans_Branchchallenge")
    end

    setactive(self.mTrans_BossImage, stageData.special_mark == 2)
end

function UIChapterStageItem:UpdateStory()
    local stageData=TableData.GetStageData(self.mData.stage_id)

    if stageData ~=nil then
        self.mIsUnLock = NetCmdDungeonData:IsUnLockStory(self.mData.id)
        setactive(self.mTrans_StoryLock, not self.mIsUnLock)

        self.mImage_Story.sprite = ResSys:GetChapterMapBG(self.mData.cover)
        -- self.mAssetObjects:Add(self.mImage_StoryCover.sprite)
    else
        gfdebug("  "..self.mData.stage_id)
    end
end

function UIChapterStageItem:UpdateChallenge(cmdData, root)
    for i = 1, GlobalConfig.MaxChallenge do
        setactive(self[root .. i],  cmdData ~= nil and cmdData.complete_challenge.Length >= i)
    end
end


function UIChapterStageItem:SetSelected(data)
    if self.mData == nil then
        return
    end

    if self.mData.type ~= GlobalConfig.StoryType.Story then
        setactive(self.mTrans_ChosenBackground.gameObject, data)
    else
        setactive(self.mTrans_StoryChoose.gameObject, data)
    end
end

function UIChapterStageItem:SetUpOrDownPoint()
    local temVec = self.mTrans_RightPoint.anchoredPosition
    if self:GetSelfRectTransform().anchoredPosition.y >= 0 then
        self.mTrans_RightPoint.pivot = Vector2(1, 1)
        temVec.y = temVec.y + self.mTrans_RightPoint.sizeDelta.y / 2
    else
        self.mTrans_RightPoint.pivot = Vector2(1, 0)
        temVec.y = temVec.y - self.mTrans_RightPoint.sizeDelta.y / 2
    end
    self.mTrans_RightPoint.anchoredPosition = temVec
end

function UIChapterStageItem:InitStagePos(delta)
    if self.mData then
        local rect = self:GetSelfRectTransform()
        rect.anchoredPosition = Vector2(self.mData.mSfxPos.x + delta, self.mData.mSfxPos.y)
    end
end