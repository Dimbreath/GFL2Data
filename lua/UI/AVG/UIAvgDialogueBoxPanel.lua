--region *.lua
--Date
--"UI.AVG.UIAvgDialogueBoxPanel"

require("UI.UIBaseCtrl")

UIAvgDialogueBoxPanel = class("UIAvgDialogueBoxPanel", UIBaseCtrl);
UIAvgDialogueBoxPanel.__index = UIAvgDialogueBoxPanel;
UIAvgDialogueBoxPanel.mDialogueBoxText = nil;
UIAvgDialogueBoxPanel.mDialogueNameText = nil;
UIAvgDialogueBoxPanel.mDialoguePictureBox = nil;
UIAvgDialogueBoxPanel.mDialoguePictureRT = nil;
UIAvgDialogueBoxPanel.mSkipButton = nil;
UIAvgDialogueBoxPanel.mNextButton = nil;
UIAvgDialogueBoxPanel.mAutoButton = nil;
UIAvgDialogueBoxPanel.mRTCamera = nil;
UIAvgDialogueBoxPanel.director = nil;


--构造
function UIAvgDialogueBoxPanel:ctor()
    UIAvgDialogueBoxPanel.super.ctor(self);
end

--初始化
function UIAvgDialogueBoxPanel.InitCtrl(root, data)	
	self = UIAvgDialogueBoxPanel;
    self:SetRoot(root);
	
    self.mDialoguePictureBox = self:GetImage("PictureBoxC");
    self.mDialoguePictureRT = self:GetImage("PictureBoxRT");
    self.mDialogueBoxText = self:GetText("DialogueBoxB/Text");
    self.mDialogueNameText = self:GetText("DialogueNameD/Text");
    self.mSkipButton = self:GetButton("SkipButton");
    self.mAutoButton = self:GetButton("AutoButton");
    self.mNextButton = getcomponent(root.gameObject, typeof(CS.UnityEngine.UI.Button));
	
	UIUtils.GetListener(self.mSkipButton.gameObject).onClick = self.SkipAllClip;
	UIUtils.GetListener(self.mAutoButton.gameObject).onClick = self.SetAutoPlay;
	UIUtils.GetListener(self.mNextButton.gameObject).onClick = self.SkipToNextClip;

end

function UIAvgDialogueBoxPanel.SkipAllClip(gameobj)
	CS.DialogueControlManager.Instance:SkipAllClip(gameobj);
end

function UIAvgDialogueBoxPanel.SetAutoPlay(gameobj)
	CS.DialogueControlManager.Instance:SetAutoPlay(gameobj);
end

function UIAvgDialogueBoxPanel.SkipToNextClip(gameobj)
	CS.DialogueControlManager.Instance:SkipToNextClip(gameobj);
end