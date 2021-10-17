 require("UI.UIBaseView")

UIChapterHardPanelView = class("UIChapterHardPanelView", UIBaseView)
UIChapterHardPanelView.__index = UIChapterHardPanelView

function UIChapterHardPanelView:ctor()

end

function UIChapterHardPanelView:__InitCtrl()
    self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
    self.mBtn_CommandCenter = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))
    self.mBtn_Guide = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnGuide"))

    self.mBtn_ChapterReward = self:GetButton("Root/GrpBottom/GrpLeft/GrpAward/Btn_StoryChapterAward");
    self.mImage_Bg = self:GetImage("Root/GrpBg/ImgBg")
    self.mText_ChapterNum = self:GetText("Root/GrpTop/GrpTextName/Text_ChapterName");
    self.mText_RewardNum = self:GetText("Root/GrpBottom/GrpLeft/GrpAward/Btn_StoryChapterAward/Root/GrpText/Text_Num");
    self.mText_CurrentChapterNum = self:GetText("Root/GrpBottom/GrpRight/GrpCurrentChapter/GrpText/Text_Num");

    self.mImage_ReceiveIcon = self:GetImage("Root/GrpBottom/GrpLeft/GrpAward/Btn_StoryChapterAward/Root/GrpIcon/ImgIcon")

    self.mTrans_Line = self:GetRectTransform("Root/GrpCenter/GrpDetailsList/Viewport/Content/GrpLine");
    self.mTrans_DetailsList = self:GetRectTransform("Root/GrpCenter/GrpDetailsList")
    self.mTrans_CombatList = self:GetRectTransform("Root/GrpCenter/GrpDetailsList/Viewport/Content");
    self.mTrans_PreChapter = self:GetRectTransform("Root/GrpBottom/GrpRight/GrpBtnPreChapter")
    self.mTrans_NextChapter = self:GetRectTransform("Root/GrpBottom/GrpRight/GrpBtnNextChapter")
    self.mTrans_RewardRedPoint = self:GetRectTransform("Root/GrpBottom/GrpLeft/GrpAward/Btn_StoryChapterAward/Root/Trans_RedPoint");
    self.mTrans_Mask = self:GetRectTransform("Trans_Mask");
    self.mTrans_CombatLauncher = self:GetRectTransform("Trans_GrpCombatLauncher");

    self:InstanceUIPrefab("UICommonFramework/ComRedPointItemV2.prefab", self.mTrans_RewardRedPoint, true)
end

function UIChapterHardPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()

    self.mTrans_TopCurrency = self:GetRectTransform("Root/GrpTop/GrpCurrency")

    local btnPrefab = UIUtils.GetGizmosPrefab("story/StoryChapterNumItemV2.prefab", self)
    local prevBtnObj = instantiate(btnPrefab)
    CS.LuaUIUtils.SetParent(prevBtnObj.gameObject, self.mTrans_PreChapter.gameObject, true)
    self.mBtn_PreChapter = UIUtils.GetButton(prevBtnObj)

    local nextBtnObj = instantiate(btnPrefab)
    CS.LuaUIUtils.SetParent(nextBtnObj.gameObject, self.mTrans_NextChapter.gameObject, true)
    self.mBtn_NextChapter = UIUtils.GetButton(nextBtnObj)

    self.mText_PreChapterNum = UIUtils.GetText(prevBtnObj, "Root/GrpText/Text_Num")
    self.mText_NextChapterNum = UIUtils.GetText(nextBtnObj, "Root/GrpText/Text_Num")

end

