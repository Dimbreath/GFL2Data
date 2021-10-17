require("UI.UIBaseView")
UAVLevelUpBreakPanelView = class("UAVLevelUpBreakPanelView", UIBaseView);
UAVLevelUpBreakPanelView.__index = UAVLevelUpBreakPanelView

function UAVLevelUpBreakPanelView.ctor()
    UAVLevelUpBreakPanelView.super.ctor(self)
    
end

function UAVLevelUpBreakPanelView:__InitCtrl()
    self.mText_TitleName=self:GetText("Root/GrpDialog/GrpText/TitleText")
    self.mText_FirstName=self:GetText("Root/GrpText/GrpContent/TextName")
    self.mBtn_Close=self:GetButton("Root/GrpBg/Btn_Close")
    self.mText_Panel=self:GetText("Root/GrpDialog/GrpCenter/GrpTop/TextLevel")
    self.mText_FromLv=self:GetText("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextNow/Text_Level")
    self.mText_ToLv=self:GetText("Root/GrpDialog/GrpCenter/GrpLevelUp/GrpTextSoon/Text_Level")
    self.mTrans_Content=self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpPowerUp/AttributeList/Viewport/Content")
    self.mTrans_GrpDialog=self:GetRectTransform("Root/GrpDialog")

end

function UAVLevelUpBreakPanelView:InitCtrl(root)
    self:SetRoot(root);
    self:__InitCtrl();
end

