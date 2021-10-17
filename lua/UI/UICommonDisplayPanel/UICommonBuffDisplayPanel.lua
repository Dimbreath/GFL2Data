require("UI.UIBaseView")

---@class UICommonBuffDisplayPanel : UIBasePanel
UICommonBuffDisplayPanel = class("UICommonBuffDisplayPanel", UIBasePanel)
UICommonBuffDisplayPanel.__index = UICommonBuffDisplayPanel

UICommonBuffDisplayPanel.mView = nil
UICommonBuffDisplayPanel.buffList = nil
UICommonBuffDisplayPanel.itemList = {}

function UICommonBuffDisplayPanel.Init(root, data)
	self = UICommonBuffDisplayPanel
	UICommonBuffDisplayPanel.super.SetRoot(UICommonBuffDisplayPanel, root)

	UICommonBuffDisplayPanel.buffList = data

	UICommonBuffDisplayPanel.mView = UICommonBuffDisplayPanelView.New()
	UICommonBuffDisplayPanel.mView:InitCtrl(root)

	self.mIsPop = true
end

function UICommonBuffDisplayPanel.OnInit()
	self = UICommonBuffDisplayPanel

	UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
		UICommonBuffDisplayPanel.Close()
	end

	UIUtils.GetButtonListener(self.mView.mBtn_Close1.gameObject).onClick = function()
		UICommonBuffDisplayPanel.Close()
	end

	self:UpdatePanel()
end

function UICommonBuffDisplayPanel.OnRelease()
	self = UICommonBuffDisplayPanel
	UICommonBuffDisplayPanel.buffList = nil
	UICommonBuffDisplayPanel.itemList = {}
end


function UICommonBuffDisplayPanel:UpdatePanel()
    self.mView.mText_SkillName.text = ""
    self.mView.mText_Description.text = ""

	setactive(self.mView.mTrans_Center.gameObject, self.buffList.Count > 0)
	setactive(self.mView.mTrans_GrpEmpty.gameObject, self.buffList.Count <= 0)

	for i = 0, self.buffList.Count - 1 do
		local curBuff = self.buffList[i]
		local buffItem = UICommonSkillItem.New()
		buffItem:InitCtrl(self.mView.mContent_Skill.transform)
		buffItem:SetData(curBuff)

		UIUtils.GetButtonListener(buffItem.mBtn_Skill.gameObject).onClick = function(obj)
			self:OnClickItem(buffItem)
		end

		if i == 0 then
			self:OnClickItem(buffItem)
		end
			
		table.insert(self.itemList, buffItem)
	end
end

function UICommonBuffDisplayPanel:OnClickItem(buffItem)
	for _, item in ipairs(self.itemList) do
		item:SetSelected(false)
	end
	
	buffItem:SetSelected(true)
	self.mView.mText_SkillName.text = buffItem.skillData.name.str
	self.mView.mText_Description.text = buffItem.skillData.description.str
end

function UICommonBuffDisplayPanel.Close()
	UIManager.CloseUI(UIDef.UICommonBuffDisplayPanel)
end

