require("UI.UIBasePanel")


UIMixConfirmPanel = class("UIMixConfirmPanel", UIBasePanel)
UIMixConfirmPanel.__index = UIMixConfirmPanel

UIMixConfirmPanel.mView = nil
UIMixConfirmPanel.mData = nil

UIMixConfirmPanel.mItemList = nil
UIMixConfirmPanel.mCostNum = nil
UIMixConfirmPanel.mMergeList = nil

UIMixConfirmPanel.itemNum =  0
UIMixConfirmPanel.itemId = 0

function UIMixConfirmPanel:ctor()
	UIMixConfirmPanel.super.ctor(self)
end

function UIMixConfirmPanel.Open()
	UIMixConfirmPanel.OpenUI(UIDef.UIMixConfirmPanel)
end

function UIMixConfirmPanel.Close()
	UIManager.CloseUI(UIDef.UIMixConfirmPanel)
end

function UIMixConfirmPanel.Init(root,data)
	self = UIMixConfirmPanel
	UIMixConfirmPanel.super.SetRoot(UIMixConfirmPanel, root)
	self.mIsPop = true
	self.mData = data

	self.mItemList =  data.itemList
	self.mCostNum = data.costNum;
	self.mMergeList = data.mergeList
	

	self.itemNum =  data.itemNum
	self.itemId =  data.itemId
end

function UIMixConfirmPanel.OnInit()
	self = UIMixConfirmPanel

	self.mView = UIMixConfirmPanelView.New()
	self.mView:InitCtrl(self.mUIRoot)

	UIUtils.GetListener(self.mView.mBtn_GrpBtn_BtnConfirm_Confim.gameObject).onClick = function()
		UIMixConfirmPanel:OnConfirm();
	end

	UIUtils.GetListener(self.mView.mBtn_Close.gameObject).onClick = function()
		UIMixConfirmPanel:OnClose();
	end

	UIUtils.GetListener(self.mView.mBtn_GrpBg_Close.gameObject).onClick = function()
		UIMixConfirmPanel:OnClose();
	end

	UIUtils.GetListener(self.mView.mBtn_GrpBtn_BtnCancel_Cancel.gameObject).onClick = function()
		UIMixConfirmPanel:OnClose();
	end

	self:UpdatePanel()
end

function UIMixConfirmPanel.onShow()
	self = UIMixConfirmPanel
end

function UIMixConfirmPanel.OnRelease()
	self = UIMixConfirmPanel

	UIMixConfirmPanel.mData = nil

end

function UIMixConfirmPanel:UpdatePanel()
	 
	clearallchild(self.mView.mTrans_Content)
	if self.mItemList ~= nil then
		for itemId, item in pairs(self.mItemList) do
			local itemview = UICommonItem.New();
			--local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab", self));
--[[			setparent(self.mView.mTrans_Content, obj.transform);
			obj.transform.localScale = vectorone;
			obj.transform.localPosition = vectorzero;]]
			itemview:InitCtrl(self.mView.mTrans_Content);
			itemview:SetItemData(item.itemId, item.itemNum);
		end
	end

    self.mView.mText_Num.text = self.mCostNum;
end


function UIMixConfirmPanel:OnClose()
	self:Close();
end

function UIMixConfirmPanel:OnConfirm()
	if self.mMergeList == nil then
		return ;
	end
	local mergeList = TableTools.ReverseList(self.mMergeList)
	local targetItemList = {}

	local targetItem = CS.ProtoCsmsg.ComposeTargetItem()
	targetItem.ItemId = self.itemId
	targetItem.ItemNum = self.itemNum
	table.insert(targetItemList, targetItem)
	 

	NetCmdItemData:SendCmdComposeItemsMsg(targetItemList, function(ret)
		if ret == CS.CMDRet.eSuccess then
			printstack("合成成功")
			CS.PopupMessageManager.PopupString(string_format(TableData.GetHintById(30026), str))
			--UIManager.CloseUI(UIDef.UIMixPanel)
			MessageSys:SendMessage(CS.GF2.Message.UIEvent.MergeEquipSucc,nil);
			self:OnClose()
		end
	end)
end









