require("UI.UIBaseCtrl")

UIPostListItem = class("UIPostListItem", UIBaseCtrl);
UIPostListItem.__index = UIPostListItem
--@@ GF Auto Gen Block Begin
UIPostListItem.mText_Chosen_Title = nil;
UIPostListItem.mText_UnChosen_Title = nil;
UIPostListItem.mTrans_Chosen = nil;
UIPostListItem.mTrans_UnChosen = nil;
UIPostListItem.mTrans_NewMark = nil;

UIPostListItem.mBtn_Chosen = nil;
UIPostListItem.mBtn_UnChosen = nil;

function UIPostListItem:__InitCtrl()

	self.mText_Chosen_Title = self:GetText("UI_Trans_Chosen/Text_Title");
	self.mText_UnChosen_Title = self:GetText("UI_Trans_UnChosen/Text_Title");
	self.mTrans_Chosen = self:GetRectTransform("UI_Trans_Chosen");
	self.mTrans_UnChosen = self:GetRectTransform("UI_Trans_UnChosen");
	self.mTrans_NewMark = self:GetRectTransform("Trans_NewMark");

	self.mBtn_Chosen = self:GetButton("UI_Trans_Chosen");
	self.mBtn_UnChosen = self:GetButton("UI_Trans_UnChosen");
end

--@@ GF Auto Gen Block End
UIPostListItem.mTitle = nil;
UIPostListItem.mType = nil;
UIPostListItem.mLabelList = nil;
UIPostListItem.mWebAddress = nil;
UIPostListItem.mData = nil
UIPostListItem.isNew = false

UIPostListItem.mPath_ButtonItem = "Post/UIPostContentTemplete_ButtonItem.prefab"
UIPostListItem.mPath_ImageItem = "Post/UIPostContentTemplete_ImageItem.prefab"
UIPostListItem.mPath_ItemListItem = "Post/UIPostContentTemplete_ItemListItem.prefab"
UIPostListItem.mPath_TextItem = "Post/UIPostContentTemplete_TextItem.prefab"

function UIPostListItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPostListItem:SetData(postData)
    if self.mLabelList==nil then
        self.mLabelList = List:New()
    else
        self.mLabelList:Clear()
    end

    self.mData = postData
	--UIUtils.GetButtonListener(self.mBtn_Chosen.gameObject).onClick = self.OnClicked
	--UIUtils.GetButtonListener(self.mBtn_UnChosen.gameObject).onClick = self.OnClicked
	self.mText_Chosen_Title.text = postData.title
	self.mText_UnChosen_Title.text = postData.title
    self.mType = postData.type
    self.isNew = PostInfoConfig.CheckPostIsNew(postData.type, postData.id)
    setactive(self.mTrans_NewMark.gameObject, self.isNew)
    local labelPrefab = nil
    local labelInst = nil
    local label
    for i=0,postData.labelDataList.Count-1 do
        local labelData = postData.labelDataList[i]
        if labelData.modelType ==1 then
            labelPrefab = UIUtils.GetGizmosPrefab(UIPostListItem.mPath_TextItem,self);
            label = UIPostContentTemplete_TextItem.New()
        elseif labelData.modelType ==2 then
            labelPrefab = UIUtils.GetGizmosPrefab(UIPostListItem.mPath_ImageItem,self);
            label = UIPostContentTemplete_ImageItem.New()
        elseif labelData.modelType==3 then
            labelPrefab = UIUtils.GetGizmosPrefab(UIPostListItem.mPath_ButtonItem,self);
            label = UIPostContentTemplete_ButtonItem.New()
        elseif labelData.modelType==4 then
            labelPrefab = UIUtils.GetGizmosPrefab(UIPostListItem.mPath_ItemListItem,self);
            label = UIPostContentTemplete_ItemListItem.New()
        end

        labelInst = instantiate(labelPrefab,UIPostPanel.mView.mTrans_ContentLayout.transform)
        label:InitCtrl(labelInst.transform)
        label:SetData(labelData)
        self.mLabelList:Add(label)
    end
end

function UIPostListItem:SetUniView()
	print("Item 切换Uniview :"..self.mWebAddress)
    UIPostPanel.SetUniViewAddress(self.mWebAddress)
end

function UIPostListItem:OnRelease()
    for i=1,self.mLabelList:Count() do
        self.mLabelList[i]:DestroySelf()
    end
    self.mLabelList = nil
    self:DestroySelf()
end

function UIPostListItem:OnClicked()
	self:ChangeState(true)
    if self.isNew then
        PostInfoConfig.ReadPost(self.mData.type, self.mData.id)
        setactive(self.mTrans_NewMark, false)
        RedPointSystem:GetInstance():UpdateRedPointByType(RedPointConst.Notice)
    end
end

function UIPostListItem:OnCancel()
	self:ChangeState(false)
end

function UIPostListItem:ChangeState(activity)
	setactive(self.mTrans_Chosen,activity)
	setactive(self.mTrans_UnChosen,not activity)

--[[    if activity and self.mType==1 then
        self:SetUniView()
    end]]

	if self.mLabelList~=nil then
		for i=1,self.mLabelList:Count() do
            if self.mLabelList[i].modelType then
                
            end
			setactive(self.mLabelList[i].mUIRoot, activity)
		end
	end
	
end