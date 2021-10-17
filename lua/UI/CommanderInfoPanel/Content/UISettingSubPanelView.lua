require("UI.UIBaseView")

---@class UISettingSubPanelView : UIBaseView
UISettingSubPanelView = class("UISettingSubPanelView", UIBaseView);
UISettingSubPanelView.__index = UISettingSubPanelView


function UISettingSubPanelView:__InitCtrl()
    self.mBtn_Exit = UIUtils.GetTempBtn(self:GetRectTransform("Trans_GrpAccount/Content/BtnExitAccount"))
    self.mBtn_Center = UIUtils.GetTempBtn(self:GetRectTransform("Trans_GrpAccount/Content/BtnUserCenter"))
    self.mBtn_Service = UIUtils.GetTempBtn(self:GetRectTransform("Trans_GrpAccount/Content/BtnServiceCenter"))

    self.mContent_Top = self:GetGridLayoutGroup("GrpTopTab/Content");
    self.mContent_Account = self:GetGridLayoutGroup("Trans_GrpAccount/Content");
    self.mContent_Sound = self:GetVerticalLayoutGroup("Trans_GrpSound/Viewport/Content");
    self.mContent_PictureQuality = self:GetVerticalLayoutGroup("Trans_GrpPictureQuality/Viewport/Content");
    self.mContent_Other = self:GetVerticalLayoutGroup("Trans_GrpOther/Viewport/Content");

    self.mTrans_Sound = self:GetRectTransform("Trans_GrpSound");
    self.mTrans_PictureQuality = self:GetRectTransform("Trans_GrpPictureQuality");
    self.mTrans_Account = self:GetRectTransform("Trans_GrpAccount");
    self.mTrans_Other = self:GetRectTransform("Trans_GrpOther");

    self.mTrans_GlobalSetting = self:GetRectTransform("Trans_GrpPictureQuality/Viewport/Content/GrpGlobalSetting")
    self.mTrans_OtherSettings = self:GetRectTransform("Trans_GrpPictureQuality/Viewport/Content/GrpOtherSettings")
end


function UISettingSubPanelView:InitCtrl(root)

    self:SetRoot(root);

    self:__InitCtrl();


end

