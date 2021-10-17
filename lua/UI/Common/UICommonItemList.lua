require("UI.UIBaseCtrl")

UICommonItemList = class("UICommonItemList", UIBaseCtrl);
UICommonItemList.__index = UICommonItemList
--@@ GF Auto Gen Block Begin
UICommonItemList.mBtn_panel_Close = nil;
UICommonItemList.mHLayout_ItemList = nil;

function UICommonItemList:__InitCtrl()

	self.mBtn_panel_Close = self:GetButton("UI_panel/Btn_Close");
	self.mHLayout_ItemList = self:GetHorizontalLayoutGroup("HLayout_ItemList");
end

--@@ GF Auto Gen Block End

function UICommonItemList:InitCtrl(root)

	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonItemList.prefab",self));
	self:SetRoot(obj.transform);
	setparent(root, obj.transform);
	obj.transform.localScale = vectorone
	
	self:SetRoot(obj.transform);

	self:__InitCtrl();

	UIUtils.GetButtonListener(self.mBtn_panel_Close.gameObject).onClick = function()
		setactive(self:GetRoot().gameObject, false);
	end

	--self:GetSelfRectTransform().anchorMin = vector2zero;
	--self:GetSelfRectTransform().anchorMax = vector2zero;

	self:GetSelfRectTransform().sizeDelta = vector2zero;
end

function UICommonItemList:SetData(data)

	clearallchild(self.mHLayout_ItemList.transform)
	if data ~=nil then
		for itemId, num  in pairs(data) do

			local itemview = UICommonItemS.New();
			local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonItemS.prefab",self));
			setparent(self.mHLayout_ItemList.transform, obj.transform);
			obj.transform.localScale = vectorone;
			itemview:InitCtrl(obj.transform);
			itemview:InitData(itemId, num);

		end
		setactive(self:GetRoot().gameObject, true);
	else
		setactive(self:GetRoot().gameObject, false);
	end
end 