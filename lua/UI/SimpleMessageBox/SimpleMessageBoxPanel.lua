require("UI.UIBaseView")

---@class SimpleMessageBoxPanel : UIBasePanel
SimpleMessageBoxPanel = class("SimpleMessageBoxPanel", UIBasePanel);
SimpleMessageBoxPanel.__index = SimpleMessageBoxPanel

--@@ GF Auto Gen Block Begin
SimpleMessageBoxPanel.mBtn_Close = nil;
SimpleMessageBoxPanel.mBtn_Close1 = nil;
SimpleMessageBoxPanel.mText_Title = nil;
SimpleMessageBoxPanel.mText_ = nil;
SimpleMessageBoxPanel.mContent_ = nil;
SimpleMessageBoxPanel.mScrollbar_ = nil;
SimpleMessageBoxPanel.mList_ = nil;

function SimpleMessageBoxPanel.Init(root, data)
	self = SimpleMessageBoxPanel
	self.messageData = data
	self.mIsPop = true
	SimpleMessageBoxPanel.super.SetRoot(SimpleMessageBoxPanel, root)
	self:InitCtrl(root)
end

function SimpleMessageBoxPanel:InitCtrl(root)
	self:SetRoot(root);

	self.mBtn_BgClose = UIUtils.GetButton(root, "Root/GrpBg/Btn_Close");
	self.mBtn_Close = UIUtils.GetButton(root, "Root/GrpDialog/GrpTop/GrpClose/Btn_Close");
	self.mText_Title = UIUtils.GetText(root, "Root/GrpDialog/GrpTop/GrpText/TitleText");
	self.mText_Content = UIUtils.GetText(root, "Root/GrpDialog/GrpCenter/GrpTextList/Viewport/Content/Text_Content");

	UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick = function()
		self.Close()
	end
	UIUtils.GetButtonListener(self.mBtn_BgClose.gameObject).onClick = function()
		self.Close()
	end

	self.animator = getchildcomponent(root,"Root", typeof(CS.UnityEngine.Animator))
end

--@@ GF Auto Gen Block End

--- static func
function SimpleMessageBoxPanel.Show(messageContent)
	UIManager.OpenUIByParam(UIDef.SimpleMessageBoxPanel, messageContent)
end

function SimpleMessageBoxPanel.ShowByParam(title, content, zPos)
	SimpleMessageBoxPanel.Show({ title, content, zPos })
end


function SimpleMessageBoxPanel.Close()
	UIManager.CloseUI(UIDef.SimpleMessageBoxPanel)
end


function SimpleMessageBoxPanel:UpdatePanel()
	--self.mText_Title.text = self.messageData[1]
	--self.mText_Content.text = self.messageData[2]
end