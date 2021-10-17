--region *.lua
--Date

require("UI.UIBaseCtrl")
---@class UIBaseView : UIBaseCtrl
UIBaseView = class("UIBaseView", UIBaseCtrl);
UIBaseView.__index = UIBaseView;

--构造
function UIBaseView:ctor()
    UIBaseView.super.ctor(self);
end

--endregion
