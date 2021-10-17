require("UI.UIBaseView")

UISimCombatRunesPanelView = class("UISimCombatRunesPanelView", UIBaseView);
UISimCombatRunesPanelView.__index = UISimCombatRunesPanelView


function UISimCombatRunesPanelView:__InitCtrl()
    self.mTrans_RuneType = self:GetRectTransform("Root/GrpLeft/GrpTypeSelList/Viewport/Content")
    self.mTrans_RuneList = self:GetRectTransform("Root/GrpRight/GrpDetailsList/Viewport/Content")
    self.mBtn_Close = self:GetRectTransform("Root/GrpTop/BtnBack/ComBtnBackItemV2")
    self.mTrans_CombatLauncher = self:GetRectTransform("Trans_GrpCombatLauncher")
    self.mBtn_CloseLaunch = self:GetButton("Scroll_EquipList")
    self.mBtn_CommanderCenter = self:GetButton("Root/GrpTop/BtnHome/ComBtnHomeItemV2")
    --self.mText_Title = self:GetText("Con_Title/Text_Title")
    self.mScroll = UIUtils.GetScrollRectEx(self.mUIRoot, "Root/GrpRight/GrpDetailsList")

    self.mAnimator = self:GetRectTransform("Root"):GetComponent("Animator")
end

--@@ GF Auto Gen Block End

function UISimCombatRunesPanelView:InitCtrl(root)

    self:SetRoot(root);

    self:__InitCtrl();
    self.mTrans_TopCurrency = self:GetRectTransform("Root/GrpTop/GrpCurrency")
end