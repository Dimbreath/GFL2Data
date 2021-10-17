require("UI.UIBaseView")

---@class UICommonAffixDisplayPanelView : UIBaseView
UICommonAffixDisplayPanelView = class("UICommonAffixDisplayPanelView", UIBaseView)
UICommonAffixDisplayPanelView.__index = UICommonAffixDisplayPanelView

function UICommonAffixDisplayPanelView:__InitCtrl()

	self.mBtn_Close = self:GetButton("Root/GrpBg/Btn_Close")
	self.mBtn_Close1 = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
	self.mContent_Affix = self:GetVerticalLayoutGroup("Root/GrpDialog/GrpCenter/GrpAffixList/Viewport/Content")
	self.mScrollbar_Affix = self:GetScrollbar("Root/GrpDialog/GrpCenter/GrpAffixList/Scrollbar")
	self.mList_Affix = self:GetScrollRect("Root/GrpDialog/GrpCenter/GrpAffixList")
end

--@@ GF Auto Gen Block End

function UICommonAffixDisplayPanelView:InitCtrl(root)

	self:SetRoot(root)

	self:__InitCtrl()

end