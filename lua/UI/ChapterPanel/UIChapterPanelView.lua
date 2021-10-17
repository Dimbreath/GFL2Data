 require("UI.UIBaseView")

UIChapterPanelView = class("UIChapterPanelView", UIBaseView)
UIChapterPanelView.__index = UIChapterPanelView

function UIChapterPanelView:ctor()

end

function UIChapterPanelView:__InitCtrl()
    self.mBtn_Close = self:GetButton("Root/GrpTop/BtnBack/ComBtnBackItemV2")
    self.mBtn_CommandCenter = self:GetButton("Root/GrpTop/BtnHome/ComBtnHomeItemV2")
    self.mBtn_ChapterReward = self:GetButton("Root/GrpBottom/GrpLeft/GrpAward/Btn_StoryChapterAward")
    self.mBtn_PreChapter = self:GetButton("Root/GrpBottom/GrpRight/GrpBtnPreChapter/StoryChapterNumItemV2")
    self.mBtn_NextChapter = self:GetButton("Root/GrpBottom/GrpRight/GrpBtnNextChapter/StoryChapterNumItemV2")
    self.mBtn_ViewAVG = self:GetButton("Root/GrpCenter/GrpBtnViewAVG/Btn_ViewAVG")

    self.mImage_Bg = self:GetImage("Root/GrpBg/ImgBg")

    self.mText_ChapterNum = self:GetText("Root/GrpTop/GrpTextName/Text_ChapterName")
    self.mText_RewardNum = self:GetText("Root/GrpBottom/GrpLeft/GrpAward/Btn_StoryChapterAward/Root/GrpText/Text_Num")
    self.mText_PreChapterNum = self:GetText("Root/GrpBottom/GrpRight/GrpBtnPreChapter/StoryChapterNumItemV2/Root/GrpText/Text_Num")
    self.mText_NextChapterNum = self:GetText("Root/GrpBottom/GrpRight/GrpBtnNextChapter/StoryChapterNumItemV2/Root/GrpText/Text_Num")
    self.mText_CurrentChapterNum = self:GetText("Root/GrpBottom/GrpRight/GrpCurrentChapter/GrpText/Text_Num")
    self.mImage_ReceiveIcon = self:GetImage("Root/GrpBottom/GrpLeft/GrpAward/Btn_StoryChapterAward/Root/GrpIcon/ImgIcon")

    self.mTrans_ViewAVG = self:GetRectTransform("Root/GrpCenter/GrpBtnViewAVG")
    self.mTrans_Line = self:GetRectTransform("Root/GrpCenter/GrpLine")
    self.mTrans_DetailsList = self:GetRectTransform("Root/GrpCenter/GrpDetailsList")
    self.mTrans_CombatList = self:GetRectTransform("Root/GrpCenter/GrpDetailsList/Viewport/Content")
    self.mTrans_PreChapter = self:GetRectTransform("Root/GrpBottom/GrpRight/GrpBtnPreChapter")
    self.mTrans_NextChapter = self:GetRectTransform("Root/GrpBottom/GrpRight/GrpBtnNextChapter")
    self.mTrans_RewardRedPoint = self:GetRectTransform("Root/GrpBottom/GrpLeft/GrpAward/Btn_StoryChapterAward/Root/Trans_RedPoint")
    self.mTrans_CombatLauncher = self:GetRectTransform("Trans_GrpCombatLauncher")

    self.mTrans_Mask = self:GetRectTransform("Trans_Mask")
    
end

function UIChapterPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()

    local str = TableData.listTutorialSystemDatas:GetDataById(1)
    self.mBtn_Guide = self:GetRectTransform(str.awake_btn)
    self.mTrans_TopCurrency = self:GetRectTransform("Root/GrpTop/GrpCurrency")
end

