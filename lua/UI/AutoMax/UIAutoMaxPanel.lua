--region *.lua

--�����controller
require("UI.UIBasePanel")
require("UI.AutoMax.UIAutoMaxPanelView")

UIAutoMaxPanel = class("UIAutoMaxPanel",UIBasePanel)
UIAutoMaxPanel.__index = UIAutoMaxPanel;

UIAutoMaxPanel.mView = nil;
UIAutoMaxPanel.mPath_AutoMaxPanel = "UIAutoMaxPanel.prefab";


--����
function UIAutoMaxPanel:ctor()
	UIAutoMaxPanel.super.ctor(self);
end

function UIAutoMaxPanel.Open()
	UIManager.OpenUI(UIDef.UIAutoMaxPanel)
end

function UIAutoMaxPanel.Close()
	UIManager.CloseUI(UIDef.UIAutoMaxPanel)
end

function UIAutoMaxPanel.Init(root,data)
	UIAutoMaxPanel.super.SetRoot(UIAutoMaxPanel,root)
	self = UIAutoMaxPanel
	self.mView = UIAutoMaxPanelView
	self.mView:InitCtrl(root)
	
	UIUtils.GetListener(self.mView.mButton_DetailReturn.gameObject).onClick = self.OnDetailButtonClicked
	CS.GF2.Message.MessageSys.Instance:AddListener(8001,self.OnUpdateUIResult);
end

function UIAutoMaxPanel.OnInit()

end

function UIAutoMaxPanel.OnShow()

end

function UIAutoMaxPanel.OnRelease()
	self = UIAutoMaxPanel;
	CS.GF2.Message.MessageSys.Instance:RemoveListener(8001,self.OnUpdateUIResult);
end

function UIAutoMaxPanel.OnUpdateUIResult(msg)
	self = UIAutoMaxPanel
	self.textStr = msg.Sender
	self.mView.mText_DetailText.text = self.textStr
end

function UIAutoMaxPanel.OnDetailButtonClicked()
	self = UIAutoMaxPanel
	CS.GF2.Message.MessageSys.Instance:SendMessage(CS.GF2.Message.AutoMaxEvent.DetailReturnButtonClicked,nil);
	gfwarning("AutoMaxReturn!")
	self.Close()
end
