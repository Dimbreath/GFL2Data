require("UI.UIBasePanel")

UITipsPanel = class("UITipsPanel", UIBasePanel);
UITipsPanel.__index = UITipsPanel;

UITipsPanel.mView = nil;
UITipsPanel.mData = nil;

--UITipsPanel.NormalItemType = {1,2,3,6,7,8,9,10,11};
--UITipsPanel.GunType = 4;
--UITipsPanel.EquipmentType = 5;

function UITipsPanel:ctor()
	UITipsPanel.super.ctor(self);
end

function UITipsPanel.Open(itemData, num, needGetWay, showTime, relateId,closecallback)
	UITipsPanel.itemData = itemData
	UITipsPanel.num = num
	UITipsPanel.needGetWay = needGetWay
	UITipsPanel.showTime = showTime
	UITipsPanel.relateId = relateId
	UITipsPanel.closecallback=closecallback
	UIManager.OpenUI(UIDef.UITipsPanel);
end

function UITipsPanel.Close()
	self=UITipsPanel
	self.mView.updateFlag = false
	if self.closecallback~=nil then
		self.closecallback()
	end
	UIManager.CloseUI(UIDef.UITipsPanel);
end

function UITipsPanel.Init(root, data)

	UITipsPanel.super.SetRoot(UITipsPanel, root);

	self = UITipsPanel;

	self.mData = data;
	self.mIsPop = true

	if data ~= nil then
		UITipsPanel.itemData = data.Length >= 1 and data[0] or UITipsPanel.itemData
		UITipsPanel.num = data.Length >= 2 and data[1] or UITipsPanel.num
		if data.Length >= 3 then
			UITipsPanel.needGetWay=data[2]
		end
		--此处在C#中调用这里时，怀疑 and or 方式失效
		--UITipsPanel.needGetWay = data.Length >= 3 and data[2] or UITipsPanel.needGetWay
		UITipsPanel.showTime = data.Length >= 4 and data[3] or UITipsPanel.showTime
		UITipsPanel.relateId = data.Length >= 5 and data[4] or 0
	end

	self.mView = UIComItemDetailsPanelV2View;
	self.mView:InitCtrl(root);
	UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = self.OnCloseClick;
	UIUtils.GetButtonListener(self.mView.mBtn_BgClose.gameObject).onClick = self.OnCloseClick;

	MessageSys:AddListener(9007, self.OnUpdateItemData)
	MessageSys:AddListener(5002, self.OnUpdateItemData)
end

function UITipsPanel.OnCloseClick(gameObject)
	UITipsPanel.Close();
end

function UITipsPanel:SetToMaxIndex()
	self.mUIRoot.transform:SetSiblingIndex(self.mUIRoot.transform.parent.childCount - 1);
end


function UITipsPanel.OnInit()
	self = UITipsPanel
	UITipsPanel.super.SetPosZ(UITipsPanel)
	UITipsPanel:SetToMaxIndex()
	UITipsPanel.mView:ShowItemDetail(UITipsPanel.itemData, UITipsPanel.num, UITipsPanel.needGetWay, UITipsPanel.showTime, UITipsPanel.relateId)
	if self.mData~=nil and  self.mData.Length >= 6 then
		UIUtils.AddSubCanvas(self.mUIRoot.gameObject, self.mData[5], false)
	end
end

function UITipsPanel.OnShow()
	self = UITipsPanel;
end

function UITipsPanel.OnRelease()
	self = UITipsPanel;
	self.mView:onRelease()
	self.mData = nil;
	self.closecallback=nil
	MessageSys:RemoveListener(9007, self.OnUpdateItemData)
	MessageSys:RemoveListener(5002, self.OnUpdateItemData)
end

function UITipsPanel:ShowTips(itemData, num, needGetWay, showTime)
	--if itemData.type == self.GunType then
	--    self.mView:ShowGun(itemData, needGetWay);
	--elseif itemData.type == self.EquipmentType then
	--    self.mView:ShowEquipment(itemData, needGetWay);
	--else
	--    self.mView:ShowItem(itemData, num, needGetWay);
	--end

end

function UITipsPanel.OnUpdate()
	self = UITipsPanel
	if self.mView.updateFlag then
		self.mView:UpdateStaminaContent()
	end
end

function UITipsPanel.OnUpdateItemData()
	self = UITipsPanel
	self.mView:UpdateDetailContent()
	if self.mView.HowToGetPanel ~= nil then
		self.mView.HowToGetPanel:UpdatePanel()
	end
end