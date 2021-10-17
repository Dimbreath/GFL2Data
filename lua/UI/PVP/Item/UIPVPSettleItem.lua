require("UI.UIBaseCtrl")

UIPVPSettleItem = class("UIPVPSettleItem", UIBaseCtrl);
UIPVPSettleItem.__index = UIPVPSettleItem

function UIPVPSettleItem:ctor()
	self.mIsPop = true
end

function UIPVPSettleItem:__InitCtrl()
	self.mBtn_CloseButton = self:GetButton("Btn_CloseButton");
	self.mHLayout_DropListLayout = self:GetHorizontalLayoutGroup("DropList/HLayout_DropListLayout")
end

function UIPVPSettleItem:InitCtrl(parent)
	local itemPrefab = UIUtils.GetGizmosPrefab("PVP/UIPVPSettleItem.prefab", self)
	local instObj = instantiate(itemPrefab)

	CS.LuaUIUtils.SetParent(instObj.gameObject, parent.gameObject, true)
	self:SetRoot(instObj.transform);

	self:__InitCtrl();

	UIUtils.GetButtonListener(self.mBtn_CloseButton.gameObject).onClick = function()
		self:OnBtnClose()
	end

	-- UIUtils.AddCanvas(self.mUIRoot.gameObject, UIManager.GetResourceBarSortOrder() + 1)
end

function UIPVPSettleItem:SetData(rewardList)
	if rewardList == nil or rewardList.Count <= 0 then
		return
	end
	for id, num in pairs(rewardList) do
		local item = UICommonItemL.New()
		item:InitCtrl(self.mHLayout_DropListLayout.transform)
		item:SetData(id, num)
	end
end

function UIPVPSettleItem:OnBtnClose()
	NetCmdPvPData:ReqNrtPvpWeeklySettleAcquire(function ()
		UINRTPVPPanel:ShowSettleLevelChange()
	end)
	gfdestroy(self.mUIRoot.gameObject)
end