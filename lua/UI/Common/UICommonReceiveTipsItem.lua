require("UI.UIBaseCtrl")

UICommonReceiveTipsItem = class("UICommonReceiveTipsItem", UIBaseCtrl);
UICommonReceiveTipsItem.__index = UICommonReceiveTipsItem
--@@ GF Auto Gen Block Begin
UICommonReceiveTipsItem.mText_Title = nil;
UICommonReceiveTipsItem.mHLayout_ItemList = nil;
UICommonReceiveTipsItem.mTrans_ItemList = nil;

function UICommonReceiveTipsItem:__InitCtrl()

	self.mText_Title = self:GetText("Title/Text_Title");
	self.mHLayout_ItemList = self:GetHorizontalLayoutGroup("ItemList/Trans_HLayout_ItemList");
	self.mTrans_ItemList = self:GetRectTransform("ItemList/Trans_HLayout_ItemList");
end

--@@ GF Auto Gen Block End

UICommonReceiveTipsItem.mItemViewList = nil;

function UICommonReceiveTipsItem:InitCtrl(parent)
	--实例化
	  local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonReceiveTipsItem.prefab",self));
	  self:SetRoot(obj.transform);
	  setparent(parent,obj.transform);
	  obj.transform.localScale=vectorone;
	  obj.transform.anchoredPosition = CS.Vector2.zero;
	  obj.transform.offsetMin = CS.Vector2.zero;
	  obj.transform.offsetMax = CS.Vector2.zero;
	  self:SetRoot(obj.transform);
	  self:__InitCtrl();

	  self.mItemViewList=List:New();
end


function UICommonReceiveTipsItem:SetData(itemlist)

	if itemlist~=nil then
	 setactive(self.mUIRoot,true);

	 local datas=itemlist;

	 --for i = 1, self.mItemViewList:Count() do
		-- self.mItemViewList[i]:SetData(nil,nil);
	 --end

	 for i = 0, datas.Count-1 do
		 if i< self.mItemViewList:Count() then
			 self.mItemViewList[i+1]:SetData(datas[i].itemid,datas[i].num);
		 else
			 local itemview=UICommonItemS.New();
			 local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/UICommonItemS.prefab",self));
			 setparent(self.mTrans_ItemList,obj.transform);
			 obj.transform.localScale=vectorone;
			 itemview:InitCtrl(obj.transform);
			 self.mItemViewList:Add(itemview);
			 itemview:SetData(datas[i].itemid,datas[i].num);

			 local stcData = TableData.GetItemData(datas[i].itemid);
			 self.mText_Title.text=stcData.name.."*"..tostring(datas[i].num);
			 --stcData.name..

		 end
	 end


	else
	 setactive(self.mUIRoot,false);
	end
end