require("UI.UIBasePanel")

UIRaidDuringPanel = class("UIRaidDuringPanel", UIBasePanel);
UIRaidDuringPanel.__index = UIRaidDuringPanel;

UIRaidDuringPanel.mView = nil;

function UIRaidDuringPanel:ctor()
    UIRaidDuringPanel.super.ctor(self);
end

function UIRaidDuringPanel.Open(data)
    self = UIRaidDuringPanel;
    UIManager.OpenUIByParam(UIDef.UIRaidDuringPanel,data);
end

function UIRaidDuringPanel.Close()
    UIManager.CloseUI(UIDef.UIRaidDuringPanel);
end

function UIRaidDuringPanel.Hide()
    self = UIRaidDuringPanel;
    self:Show(false);
end

function UIRaidDuringPanel.Init(root, data)
    UIRaidDuringPanel.super.SetRoot(UIRaidDuringPanel, root);
    UIRaidDuringPanel.mStageData = data;
    UIRaidDuringPanel.mIsPop = true;
end


function UIRaidDuringPanel.OnInit()
    self = UIRaidDuringPanel;
end

function UIRaidDuringPanel.OnShow()
    self = UIRaidDuringPanel;
    local canvasGroup = self.mUIRoot:Find("Root"):GetComponent("CanvasGroup")
    canvasGroup.blocksRaycasts = true;
end

function UIRaidDuringPanel.OnRelease()
    self = UIRaidDuringPanel;
end

