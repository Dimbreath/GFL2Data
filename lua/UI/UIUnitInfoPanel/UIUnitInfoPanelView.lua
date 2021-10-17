require("UI.UIBaseView")

UIUnitInfoPanelView = class("UIUnitInfoPanelView", UIBaseView)
UIUnitInfoPanelView.__index = UIUnitInfoPanelView



function UIUnitInfoPanelView:ctor()

end

function UIUnitInfoPanelView:__InitCtrl()

    self.mTrans_GrpInfo = self:GetRectTransform("Root/GrpChrEnemyInfo")
    self.mBtn_Close = self:GetButton("Root/GrpBg/Btn_Close")

end

function UIUnitInfoPanelView:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end

