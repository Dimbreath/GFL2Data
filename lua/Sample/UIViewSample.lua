---
--- Created by Administrator.
--- DateTime: 18/9/8 16:52
---
require("UI.UIBaseView")

UIViewSample = class("UIViewSample", UIBaseView);
UIViewSample.__index = UIViewSample;

--构造
function UIViewSample:ctor()
    UIViewSample.super.ctor(self);
end

--初始化
function UIViewSample:InitCtrl(root)

    self:SetRoot(root);


end