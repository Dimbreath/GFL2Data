require("UI.UIBaseView")

UISimCombatEquipPanelView = class("UISimCombatEquipPanelView", UIBaseView);
UISimCombatEquipPanelView.__index = UISimCombatEquipPanelView


function UISimCombatEquipPanelView:__InitCtrl()
    self.mTrans_EquipType = self:GetRectTransform("Root/GrpLeft/GrpTypeSelList/Viewport/Content")
    self.mTrans_EquipList = self:GetRectTransform("Root/GrpRight/GrpDetailsList/Viewport/Content")
    self.mBtn_Close = self:GetRectTransform("Root/GrpTop/BtnBack/ComBtnBackItemV2")
    self.mTrans_CombatLauncher = self:GetRectTransform("Root/Trans_GrpCombatLauncher")
    self.mBtn_CloseLaunch = self:GetButton("Scroll_EquipList")
    self.mBtn_CommanderCenter = self:GetButton("Root/GrpTop/BtnHome/ComBtnHomeItemV2")
    --self.mText_Title = self:GetText("Con_Title/Text_Title")
    self.mScroll = UIUtils.GetScrollRectEx(self.mUIRoot, "Root/GrpRight/GrpDetailsList")

    self.mAnimator = self:GetRectTransform("Root"):GetComponent("Animator")
end

--@@ GF Auto Gen Block End

function UISimCombatEquipPanelView:InitCtrl(root)

    self:SetRoot(root);

    self:__InitCtrl();
    self.mTrans_TopCurrency = self:GetRectTransform("Root/GrpTop/GrpCurrency")
end