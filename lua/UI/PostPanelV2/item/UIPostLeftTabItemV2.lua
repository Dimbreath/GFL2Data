require("UI.UIBaseCtrl")

---@class UIPostLeftTabItemV2 : UIBaseCtrl
UIPostLeftTabItemV2 = class("UIPostLeftTabItemV2", UIBaseCtrl);
UIPostLeftTabItemV2.__index = UIPostLeftTabItemV2
--@@ GF Auto Gen Block Begin
UIPostLeftTabItemV2.mText_Data = nil;
UIPostLeftTabItemV2.mText_Name = nil;
UIPostLeftTabItemV2.mTrans_RedPoint = nil;

function UIPostLeftTabItemV2:__InitCtrl()

	self.mText_Data = self:GetText("GrpNor/GrpText/Text_Data");
	self.mText_Name = self:GetText("GrpNor/GrpText/Text_Name");
	self.mTrans_RedPoint = self:GetRectTransform("GrpNor/Trans_RedPoint");
end

--@@ GF Auto Gen Block End

UIPostLeftTabItemV2.mTitle = nil;
UIPostLeftTabItemV2.mType = nil;
UIPostLeftTabItemV2.mLabelList = nil;
UIPostLeftTabItemV2.mWebAddress = nil;
UIPostLeftTabItemV2.mData = nil
UIPostLeftTabItemV2.isNew = false
UIPostLeftTabItemV2.mBtn = nil
UIPostLeftTabItemV2.mAnimator = nil

UIPostLeftTabItemV2.mPath_ButtonItem = "Post/PostRightButtonItemV2.prefab"
UIPostLeftTabItemV2.mPath_ImageItem = "Post/PostRightBannerItemV2.prefab"
UIPostLeftTabItemV2.mPath_ItemListItem = "Post/PostRightItemV2.prefab"
UIPostLeftTabItemV2.mPath_TextItem = "Post/PostRightTextDescriptionItemV2.prefab"
UIPostLeftTabItemV2.mPath_TextTitleItem = "Post/PostRightTextTitleItemV2.prefab"

function UIPostLeftTabItemV2:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

	self.mBtn = self:GetSelfButton();
	self.mAnimator = getcomponent(root.gameObject, typeof(CS.UnityEngine.Animator))
end

function UIPostLeftTabItemV2:SetData(postData)
	if self.mLabelList==nil then
		self.mLabelList = List:New()
	else
		self.mLabelList:Clear()
	end

	self.mData = postData
	self.mText_Name.text = postData.title
	local dateTime = CS.CGameTime.ConvertLongToDateTime(postData.startTime)
	self.mText_Data.text = dateTime.Month .. "/" .. dateTime.Day
	self.mType = postData.type
	self.isNew = PostInfoConfig.CheckPostIsNew(postData.type, postData.id)
	setactive(self.mTrans_RedPoint.gameObject, self.isNew)
	local labelPrefab = nil
	local labelInst = nil
	local label
	for i=0,postData.labelDataList.Count-1 do
		local labelData = postData.labelDataList[i]
		if labelData.modelType ==1 then
			labelPrefab = UIUtils.GetGizmosPrefab(UIPostLeftTabItemV2.mPath_TextItem,self);
			label = UIPostRightTextDescriptionItemV2.New()
		elseif labelData.modelType ==2 then
			labelPrefab = UIUtils.GetGizmosPrefab(UIPostLeftTabItemV2.mPath_ImageItem,self);
			label = UIPostRightBannerItemV2.New()
		elseif labelData.modelType==3 then
			labelPrefab = UIUtils.GetGizmosPrefab(UIPostLeftTabItemV2.mPath_ButtonItem,self);
			label = UIPostRightButtonItemV2.New()
		elseif labelData.modelType==4 then
			labelPrefab = UIUtils.GetGizmosPrefab(UIPostLeftTabItemV2.mPath_ItemListItem,self);
			label = UIPostRightItemV2.New()
		elseif labelData.modelType==5 then
			labelPrefab = UIUtils.GetGizmosPrefab(UIPostLeftTabItemV2.mPath_TextTitleItem,self);
			label = UIPostRightTextTitleItemV2.New()
		end


		labelInst = instantiate(labelPrefab,UIPostPanelV2.mView.mVLayout_Content.transform)
		label:InitCtrl(labelInst.transform)
		label:SetData(labelData)
		self.mLabelList:Add(label)
	end
end

function UIPostLeftTabItemV2:SetUniView()
	print("Item 切换Uniview :"..self.mWebAddress)
	UIPostPanelV2.SetUniViewAddress(self.mWebAddress)
end

function UIPostLeftTabItemV2:OnRelease()
	for i=1,self.mLabelList:Count() do
		self.mLabelList[i]:DestroySelf()
	end
	self.mLabelList = nil
	self:DestroySelf()
end

function UIPostLeftTabItemV2:OnClicked()
	self:ChangeState(true)
	if self.isNew then
		PostInfoConfig.ReadPost(self.mData.type, self.mData.id)
		setactive(self.mTrans_RedPoint, false)
		RedPointSystem:GetInstance():UpdateRedPointByType(RedPointConst.Notice)
	end
end

function UIPostLeftTabItemV2:OnCancel()
	self:ChangeState(false)
end

function UIPostLeftTabItemV2:ChangeState(activity)
	if activity then
		UIUtils.SetInteractive(self.mUIRoot, false)
	else
		UIUtils.SetInteractive(self.mUIRoot, true)
	end

	if self.mLabelList~=nil then
		for i=1,self.mLabelList:Count() do
			if self.mLabelList[i].modelType then

			end
			setactive(self.mLabelList[i].mUIRoot, activity)
		end
	end

end