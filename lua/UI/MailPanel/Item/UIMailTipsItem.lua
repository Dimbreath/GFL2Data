require("UI.UIBaseCtrl")

UIMailTipsItem = class("UIMailTipsItem", UIBaseCtrl);
UIMailTipsItem.__index = UIMailTipsItem

UIMailTipsItem.mText_TitleName = nil
UIMailTipsItem.mText_Warning = nil
UIMailTipsItem.mBtn_Cancel = nil
UIMailTipsItem.mBtn_Confirm = nil


function UIMailTipsItem:__InitCtrl()

    self.mText_TitleName = self:GetText("WarningBG/BG/TitlePanel/Text_TitelName")
    self.mText_Warning = self:GetText("WarningBG/Warning")
    self.mBtn_Cancel = self:GetButton("WarningBG/CancleBtn")
    self.mBtn_Confirm = self:GetButton("WarningBG/ConfirmBtn")
end


function UIMailTipsItem:InitCtrl(parent)
    local obj = instantiate(UIUtils.GetGizmosPrefab("Combat/PauseHintCtrl.prefab",self));
    CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, true)
    self:SetRoot(obj.transform)
    self:__InitCtrl()
end

function UIMailTipsItem:InitData(title, context)
    self.mText_TitleName.text = title
    self.mText_Warning.text = context

    setactive(self.mUIRoot.gameObject, true)
end

function UIMailTipsItem:CloseTips()
    setactive(self.mUIRoot.gameObject, false)
end