require("UI.UIBaseView")
---@class UISimCombatGoldPanelView : UIBaseView
UISimCombatGoldPanelView = class("UISimCombatGoldPanelView", UIBaseView);
UISimCombatGoldPanelView.__index = UISimCombatGoldPanelView


function UISimCombatGoldPanelView:__InitCtrl()
    self.mBtn_Back = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnBack"))
    self.mBtn_Home = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnHome"))
    self.mBtn_Description = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpTop/BtnDescription"))
    self.mText_Remaining = self:GetText("Root/GrpRemainingTimes/GrpText/Text");
    self.mText_Num = self:GetText("Root/GrpRemainingTimes/GrpTimes/Text_Num");
    self.mContent_Details = self:GetGridLayoutGroup("Root/GrpCenter/GrpDetailsList/Viewport/Content");
    self.mList_Details = self:GetScrollRect("Root/GrpCenter/GrpDetailsList");
    self.mTrans_CombatLauncher = self:GetRectTransform("Trans_GrpCombatLauncher");
end

--@@ GF Auto Gen Block End

function UISimCombatGoldPanelView:InitCtrl(root)

    self:SetRoot(root);

    self:__InitCtrl();
    self.mTrans_TopCurrency = self:GetRectTransform("Root/GrpTop/GrpCurrency")
end