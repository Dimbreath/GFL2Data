require("UI.UIBaseView")

UISimCombatTeachingPanelView = class("UISimCombatTeachingPanelView", UIBaseView);
UISimCombatTeachingPanelView.__index = UISimCombatTeachingPanelView


function UISimCombatTeachingPanelView:__InitCtrl()
    -- self.mTrans_EquipType = self:GetRectTransform("Root/GrpLeft/GrpTypeSelList/Viewport/Content")
    -- self.mTrans_EquipList = self:GetRectTransform("Root/GrpRight/GrpDetailsList/Viewport/Content")
    self.mBtn_Close = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
    self.mBtn_CommanderCenter = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))
    self.mBtn_Description = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnDescription"))
    self.mBtn_Reward = self:GetButton("Root/BtnAward/Btn_Award")

    self.mTrans_Content = self:GetRectTransform("Root/GrpChapterList_Tab0/GrpDetailsList/Viewport/Content")
    self.mTrans_LevelList = self:GetRectTransform("Root/GrpChapterDetails_Tab1/GrpDetailsList")
    self.mTrans_LevelContent = self:GetRectTransform("Root/GrpChapterDetails_Tab1/GrpDetailsList/Viewport/Content")

    self.mTrans_ChapterList = self:GetRectTransform("Root/GrpChapterList_Tab0");
    self.mTrans_ChapterDetail = self:GetRectTransform("Root/GrpChapterDetails_Tab1")

    self.mTrans_ChapterDetailCurrent = self:GetRectTransform("Root/GrpChapterDetails_Tab1/GrpCurrentChapter")

    self.mTrans_CombatLauncher = self:GetRectTransform("Root/Trans_GrpCombatLauncher")

    self.mTrans_RewardRedPoint = self:GetRectTransform("Root/BtnAward/Btn_Award/Root/Trans_RedPoint");

    self:InstanceUIPrefab("UICommonFramework/ComRedPointItemV2.prefab", self.mTrans_RewardRedPoint, true)

    -- self.mBtn_CloseLaunch = self:GetButton("Scroll_EquipList")
    -- self.mBtn_CommanderCenter = self:GetButton("Root/GrpTop/BtnHome/ComBtnHomeItemV2")
    -- --self.mText_Title = self:GetText("Con_Title/Text_Title")
    -- self.mScroll = UIUtils.GetScrollRectEx(self.mUIRoot, "Root/GrpRight/GrpDetailsList")

    -- self.mAnimator = self:GetRectTransform("Root"):GetComponent("Animator")
end

--@@ GF Auto Gen Block End

function UISimCombatTeachingPanelView:InitCtrl(root)

    self:SetRoot(root);

    self:__InitCtrl();
end