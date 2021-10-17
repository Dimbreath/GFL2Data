require("UI.UIBaseView")
---@class UICommonAvatarModifyPanelView : UIBaseView

UICommonAvatarModifyPanelView = class("UICommonAvatarModifyPanelView", UIBaseView)
UICommonAvatarModifyPanelView.__index = UICommonAvatarModifyPanelView

function UICommonAvatarModifyPanelView:ctor()

end

function UICommonAvatarModifyPanelView:__InitCtrl()
    self.mBtn_Confirm = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpRight/GrpAction/BtnReplace"))
    self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_CloseBg = self:GetButton("Root/GrpBg/Btn_Close")

    self.mTrans_AvatarList = self:GetRectTransform("Root/GrpDialog/GrpAvatar/GrpAvatarList/Viewport/Content")
    self.mTrans_DisplayAvatar = self:GetRectTransform("Root/GrpDialog/GrpRight/GrpAvatar")
    self.mText_AvatarName = self:GetText("Root/GrpDialog/GrpRight/GrpAvatarName/Text_AvatarName")
    self.mText_AvatarDesc = self:GetText("Root/GrpDialog/GrpRight/GrpAvatarDescription/Viewport/Content/Text_Description")

    self.mTrans_Replace = self:GetRectTransform("Root/GrpDialog/GrpRight/GrpAction/BtnReplace")
    self.mTrans_Equiped = self:GetRectTransform("Root/GrpDialog/GrpRight/GrpAction/Trans_UnLocked")
    self.mTrans_Lock = self:GetRectTransform("Root/GrpDialog/GrpRight/GrpAction/Trans_Locked")
end

function UICommonAvatarModifyPanelView:InitCtrl(root)
    self:SetRoot(root)
    self:__InitCtrl()
end
