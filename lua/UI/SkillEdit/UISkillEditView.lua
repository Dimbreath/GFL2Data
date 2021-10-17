require("UI.UIBaseView")

UISkillEditView = class("UISkillEditPanel", UIBaseView);
UISkillEditView.__index = UISkillEditView

UISkillEditView.mText_UI_SortType = nil;
UISkillEditView.mText_UI_Filter = nil;
UISkillEditView.mText_UI_FilterType = nil;
UISkillEditView.mText_UI_TicketNumCost = nil;
UISkillEditView.mText_UI_TicketNumCur = nil;
UISkillEditView.mImage_UI_Return = nil;
UISkillEditView.mImage_UI_AD_change = nil;
UISkillEditView.mImage_UI_FilterButton = nil;
UISkillEditView.mImage_UI_CoreList = nil;
UISkillEditView.mImage_UI_ActiveSkill = nil;
UISkillEditView.mImage_UI_PositiveSkill = nil;
UISkillEditView.mImage_UI_Area = nil;
UISkillEditView.mImage_UI_ClearButton = nil;
UISkillEditView.mImage_UI_ConfirmButton = nil;
UISkillEditView.mButton_UI_Return = nil;
UISkillEditView.mButton_UI_AD_change = nil;
UISkillEditView.mButton_UI_FilterButton = nil;
UISkillEditView.mButton_UI_ActiveSkill = nil;
UISkillEditView.mButton_UI_PositiveSkill = nil;
UISkillEditView.mButton_UI_ClearButton = nil;
UISkillEditView.mButton_UI_ConfirmButton = nil;

UISkillEditView.mActiveNoSelected = nil;
UISkillEditView.mPositiveNoSelected = nil;
UISkillEditView.mSkillListRoot = nil;
UISkillEditView.mCoresScrollRect = nil;

UISkillEditView.mList_CacheSkillItem = nil;
UISkillEditView.mList_UnCacheSkillItem = nil;

UISkillEditView.mPath_SkillItem = "SkillEdit/UICurSkillItem.prefab";

function UISkillEditView:InitCtrl(root)

	self:SetRoot(root);

	self.mText_UI_SortType = self:GetText("TopPanel/ListInfo/Options/Sort/UI_SortType");
	self.mText_UI_Filter = self:GetText("TopPanel/ListInfo/Options/UI_Filter");
	self.mText_UI_FilterType = self:GetText("TopPanel/ListInfo/Options/UI_Filter/UI_FilterType");
	self.mText_UI_TicketNumCost = self:GetText("ticketCost/UI_TicketNum/UI_TicketNumCost");
	self.mText_UI_TicketNumCur = self:GetText("ticketCost/UI_TicketNum/UI_TicketNumCur");
	self.mImage_UI_Return = self:GetImage("TopPanel/UI_Return");
	self.mImage_UI_AD_change = self:GetImage("TopPanel/ListInfo/Options/UI_AD_change");
	self.mImage_UI_FilterButton = self:GetImage("TopPanel/ListInfo/Options/UI_FilterButton");
	self.mImage_UI_CoreList = self:GetImage("Cores/UI_CoreList");
	self.mImage_UI_ActiveSkill = self:GetImage("CoreType/UI_ActiveSkill");
	self.mImage_UI_PositiveSkill = self:GetImage("CoreType/UI_PositiveSkill");
	self.mImage_UI_Area = self:GetImage("CoreEditArea/CoreArea/UI_Area");
	self.mImage_UI_ClearButton = self:GetImage("CoreEditArea/Title/UI_ClearButton");
	self.mImage_UI_ConfirmButton = self:GetImage("UI_ConfirmButton");
	self.mButton_UI_Return = self:GetButton("TopPanel/UI_Return");
	self.mButton_UI_AD_change = self:GetButton("TopPanel/ListInfo/Options/UI_AD_change");
	self.mButton_UI_FilterButton = self:GetButton("TopPanel/ListInfo/Options/UI_FilterButton");
	self.mButton_UI_ActiveSkill = self:GetButton("CoreType/UI_ActiveSkill");
	self.mButton_UI_PositiveSkill = self:GetButton("CoreType/UI_PositiveSkill");
	self.mButton_UI_ClearButton = self:GetButton("CoreEditArea/Title/UI_ClearButton");
	self.mButton_UI_ConfirmButton = self:GetButton("UI_ConfirmButton");
	
	self.mActiveNoSelected = self:FindChild("CoreType/UI_ActiveSkill/notSelected");
	self.mPositiveNoSelected = self:FindChild("CoreType/UI_PositiveSkill/notSelected");
	self.mSkillListRoot = self:FindChild("CurrentSkill/SkillList");	
	self.mCoresScrollRect = getcomponent(self:FindChild("Cores"),typeof(CS.UnityEngine.UI.ScrollRect));
	
	
	self:InitCacheItem();
end

function UISkillEditView:UpdateButton(isActiveSkill)
	
	if isActiveSkill == true then
		setactive(self.mActiveNoSelected,false);
		setactive(self.mPositiveNoSelected,true);
	else
		setactive(self.mActiveNoSelected,true);
		setactive(self.mPositiveNoSelected,false);
	end
end

function UISkillEditView:GetCacheSkillItem()	
	local cacheItem = self.mList_CacheSkillItem[1];
	self.mList_CacheSkillItem:RemoveAt(1);	
	self.mList_UnCacheSkillItem:Insert(1,cacheItem);
	setactive(cacheItem.transform,true);
	
	return cacheItem;
end

function UISkillEditView:ReturnToCache()	
	for i = 1, self.mList_UnCacheSkillItem:Count(), 1 do
		local obj = self.mList_UnCacheSkillItem[1];
		setactive(obj.transform,false);		
		self.mList_UnCacheSkillItem:RemoveAt(1);
		self.mList_CacheSkillItem:Insert(1,obj);
	end	
end

function UISkillEditView:InitCacheItem ()
	self.mList_CacheSkillItem = List:New(CS.UnityEngine.GameObject);
	self.mList_UnCacheSkillItem = List:New(CS.UnityEngine.GameObject);
	for i = 1,5,1 do
		local prefab = UIUtils.GetGizmosPrefab(self.mPath_SkillItem,self);
		local instObj = instantiate(prefab);
		--instObj.transform.parent = self.mSkillListRoot.transform;
		setparent(self.mSkillListRoot.transform,instObj.transform);
		setactive(instObj.transform,false);
		self.mList_CacheSkillItem:Add(instObj);
	end
end

function UISkillEditView:ClearSkillList()
	CS.UICoreDragUtility.ClearAllChildren(self.mSkillListRoot.transform);
end




