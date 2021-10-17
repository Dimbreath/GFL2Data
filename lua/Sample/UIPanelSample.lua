---
--- Created by Administrator.
--- DateTime: 18/9/8 16:50
---
require("UI.UIBasePanel")

UIPanelSample = class("UIPanelSample", UIBasePanel);
UIPanelSample.__index = UIPanelSample;

UIPanelSample.mView = nil;

function UIPanelSample:ctor()
    UIPanelSample.super.ctor(self);
end

function UIPanelSample.Open()
    UIManager.OpenUI(UIDef.UIPanelSample);
end

function UIPanelSample.Close()
    UIManager.CloseUI(UIDef.UIPanelSample);
end

function UIPanelSample.Init(root, data)

    UIPanelSample.super.SetRoot(UIFormationPanel, root);

    self = UIPanelSample;

    self.mData = data;

    self.mView = XXXXXXXXXXXXX;
    self.mView:InitCtrl(root);
end

function UIPanelSample.OnInit()

end

function UIPanelSample.OnShow()
    self = UIPanelSample;
end

function UIPanelSample.OnRelease()

    self = UIPanelSample;
end