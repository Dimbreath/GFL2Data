require("UI.UIBasePanel")
require("UI.CommanderCustomMadePanel.item.UICostumeItem")
require("UI.CommanderCustomMadePanel.item.UICustomItem")
require("UI.CommanderCustomMadePanel.item.UIExpressionItem")
require("UI.CommanderCustomMadePanel.item.UIPresetColorItem")
require("UI.CommanderCustomMadePanel.item.UITemplateItem")
require("UI.CommanderCustomMadePanel.item.UIColorPickerItem")
require("UI.CommanderCustomMadePanel.item.UILocationPickerItem")

UICommanderCustomMadePanel = class("UICommanderCustomMadePanel", UIBasePanel);
UICommanderCustomMadePanel.__index = UICommanderCustomMadePanel;


--UI路径
UICommanderCustomMadePanel.mPath_TemplateItem = "CommanderCustom/UITemplateItem.prefab";
UICommanderCustomMadePanel.mPath_CostumeItem = "CommanderCustom/UICostumeItem.prefab";
UICommanderCustomMadePanel.mPath_CustomItem = "CommanderCustom/UICustomItem.prefab";
UICommanderCustomMadePanel.mPath_ExpressionItem = "CommanderCustom/UIExpressionItem.prefab";
UICommanderCustomMadePanel.mPath_PresetColorItem = "CommanderCustom/UIPresetColorItem.prefab";
UICommanderCustomMadePanel.mPath_ColorPicker = "CommanderCustom/UIColorPickerItem.prefab"

--UI控件
UICommanderCustomMadePanel.mView = nil;


--逻辑参数
UICommanderCustomMadePanel.DecoType = gfenum({"TattooLeft", "TattooRight", "TattooUp","Headwear","Glasses","Beard","Earring"},0);
UICommanderCustomMadePanel.DetailTag = gfenum({"Hair", "Eye", "TattooLeft", "TattooRight", "TattooUp","Headwear","Glasses","Beard","Earring"},0);
UICommanderCustomMadePanel.mIsInit = true;
UICommanderCustomMadePanel.mStep = 0;
UICommanderCustomMadePanel.mTemplateItems = {};
UICommanderCustomMadePanel.mCustomHairStyleItems = {};
UICommanderCustomMadePanel.mCustomEyeTypeItems = {};
UICommanderCustomMadePanel.mCustomTattooItems = {};
UICommanderCustomMadePanel.mCustomCostumeItems = {};

UICommanderCustomMadePanel.mCurTempItem = nil;
UICommanderCustomMadePanel.mCurHairStyleItem = nil;
UICommanderCustomMadePanel.mCurEyeTypeItem = nil;
UICommanderCustomMadePanel.mCurDecoItems = {};
UICommanderCustomMadePanel.mCurCostumeItem = nil;
UICommanderCustomMadePanel.mDefaultDecoItems = {};

UICommanderCustomMadePanel.mCurColorPicker = nil;
UICommanderCustomMadePanel.mCurSelectTag = UICommanderCustomMadePanel.DetailTag.Hair;

--数据
UICommanderCustomMadePanel.mCurTemplateId = 1;
UICommanderCustomMadePanel.mHairColorData = nil;
UICommanderCustomMadePanel.mEyeColorData = nil;
UICommanderCustomMadePanel.mDecoColorDatas = {};

UICommanderCustomMadePanel.mFakeBodyIds = {111401,102300,110900};

UICommanderCustomMadePanel.mDecoPanelUIItems = {};
UICommanderCustomMadePanel.mDecoTypeButtonChosenItems = {};
UICommanderCustomMadePanel.mDecoColorPickerItems = {};

function UICommanderCustomMadePanel:ctor()
    UICommanderCustomMadePanel.super.ctor(self);
end

function UICommanderCustomMadePanel.Open()
    UICommanderCustomMadePanel.OpenUI(UIDef.UICommanderCustomMadePanel);
end

function UICommanderCustomMadePanel.Close()
    UIManager.CloseUI(UIDef.UICommanderCustomMadePanel);
end

function UICommanderCustomMadePanel.Init(root, data)
	UICommanderCustomMadePanel.super.SetRoot(UICommanderCustomMadePanel, root);
    self = UICommanderCustomMadePanel;
		
	self.mView = UICommanderCustomMadePanelView;
    self.mView:InitCtrl(root);
	
	self:InitDecoPanelUIItems();
	self:InitDecoTypeButtonChosenItems();
	self:InitDecoColorPickerItems();
	
	self:InitTemplateDetailPanel();
	self:InitTemplateTypes();
	self:InitDecoTypes();
		
	self:InitHairColorPrestItems();
	self:InitEyeColorPrestItems();
	
	self:InitHairPanelButtons();
	self:InitEyePanelButtons();
	self:InitDecorationPanelButtons();
	
	UIUtils.GetButtonListener(self.mView.mBtn_Return.gameObject).onClick = self.OnReturnClick;
	UIUtils.GetButtonListener(self.mView.mBtn_PresetDetailPanel_NextButton.gameObject).onClick = self.OnNextStepClicked;	
	UIUtils.GetButtonListener(self.mView.mBtn_PresetDetailPanel_DarkButton.gameObject).onClick = self.OnSkinColor1Clicked;
	UIUtils.GetButtonListener(self.mView.mBtn_PresetDetailPanel_BrightButton.gameObject).onClick = self.OnSkinColor2Clicked;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_HideFromViewButton.gameObject).onClick = self.OnHideOrShowView;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_ShowFromViewButton.gameObject).onClick = self.OnHideOrShowView;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_ResetAllButton.gameObject).onClick = self.OnResetAllClicked;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_ResetPresentButton.gameObject).onClick = self.OnResetCurrentClicked;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_NextButton.gameObject).onClick = self.OnConfirmClicked;
	
	FacilityBarrackData.InitNodeCamera();
	
	FacilityBarrackData.TweenCamToMain();
end

function UICommanderCustomMadePanel:InitTemplateTypes()
	self:InitHairStyle();
	self:InitEyeType();
	self:InitCostumeItems();
end

function UICommanderCustomMadePanel:InitDecoTypes()
	self:InitTattooItems();
	self:InitDecoItems();
end

------------------------------公共逻辑----------------------------------------
function UICommanderCustomMadePanel.OnNextStepClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	setactive(self.mView.mTrans_PresetDetailPanel.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel.gameObject,true);
	setactive(self.mView.mBtn_CustomDetailPanel_HideFromViewButton.gameObject, true);
	setactive(self.mView.mBtn_CustomDetailPanel_ShowFromViewButton.gameObject, false);
	
	if(self.mCurTemplateId ~= 2) then 
		FacilityBarrackData.TweenCamToDetail();	
	else
		FacilityBarrackData.TweenCamToPowerUpUpgrade();
	end
	
	self.OnHairClicked(nil);
	self.mStep = 1;
end

function UICommanderCustomMadePanel.OnPrevStepClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	setactive(self.mView.mTrans_PresetDetailPanel.gameObject,true);
	setactive(self.mView.mTrans_CustomDetailPanel.gameObject,false);
	setactive(self.mView.mBtn_CustomDetailPanel_HideFromViewButton.gameObject, false);
	setactive(self.mView.mBtn_CustomDetailPanel_ShowFromViewButton.gameObject, false);
	
	FacilityBarrackData.TweenCamToMain();
	self.mStep = 0;
end

function UICommanderCustomMadePanel.OnHideOrShowView(gameObj)
	self = UICommanderCustomMadePanel;
	
	if(self.mView.mBtn_CustomDetailPanel_HideFromViewButton.gameObject.activeSelf == true) then
		setactive(self.mView.mBtn_CustomDetailPanel_HideFromViewButton.gameObject, false);
		setactive(self.mView.mBtn_CustomDetailPanel_ShowFromViewButton.gameObject, true);
		
		setactive(self.mView.mTrans_CustomDetailPanel.gameObject, false);
	else
		setactive(self.mView.mBtn_CustomDetailPanel_HideFromViewButton.gameObject, true);
		setactive(self.mView.mBtn_CustomDetailPanel_ShowFromViewButton.gameObject, false);
		
		setactive(self.mView.mTrans_CustomDetailPanel.gameObject, true);
	end
end

function UICommanderCustomMadePanel.OnResetAllClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	local hint = TableData.GetHintById(11);
	MessageBox.Show("注意", hint, nil, self.OnResetAllConfirmed, nil);
end

function UICommanderCustomMadePanel.OnResetAllConfirmed()
	self = UICommanderCustomMadePanel;
	local id = self.mFakeBodyIds[self.mCurTempItem.mData.id];
	CS.CommanderModManager.Instance:ChangeTemplate(id,self.mCurTempItem.mData.id);
	
	self:InitTemplateTypes();
	self:ResetAllSelectDecoItems();
end	

function UICommanderCustomMadePanel.OnResetCurrentClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	CS.CommanderModManager.Instance:ResetCurrent(self.mCurSelectTag);
	
	if(self.mCurSelectTag == 1) then
		self:InitHairStyle();
		return;
	end
	
	if(self.mCurSelectTag == 2) then
		self:InitEyeType();
		return;
	end
	
	local index = self.mCurSelectTag - 2;
	self.mCurDecoItems[index]:SetSelect(false);
	self.mDefaultDecoItems[index]:SetSelect(true);
end


function UICommanderCustomMadePanel:ResetAllSelectDecoItems()
	for i = 1, #self.mCurDecoItems, 1 do
		local item = self.mCurDecoItems[i];
		local default = self.mDefaultDecoItems[i];
		if(item ~= nil and item ~= "") then
			item:SetSelect(false);
			default:SetSelect(true);
		end		
	end
end

function UICommanderCustomMadePanel.OnConfirmClicked()
	self = UICommanderCustomMadePanel;
	local data = CS.CommanderModManager.Instance.ModData;
	NetCmdCommanderData:SendReqRoleCommanderInit(data, self.OnConfirmCallback);
end

function UICommanderCustomMadePanel.OnConfirmCallback(ret)
	self = UICommanderCustomMadePanel;
	if ret == CS.CMDRet.eSuccess then
		gfdebug("捏人数据提交成功");
		MessageBox.Show("", "设置成功!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
    else
		gfdebug("捏人数据提交失败");
		MessageBox.Show("出错了", "捏人数据提交失败!", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
	end
end

------------------------------整体形象----------------------------------------
function UICommanderCustomMadePanel:InitTemplateDetailPanel()
	
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_TemplateItem,self);
	setactive(self.mView.mTrans_PresetDetailPanel.gameObject,true);
	self.mCurTemplateId = NetCmdCommanderData:GetDefaultTemplateId();
	
	local list = TableData.GetCommanderTemplateList();
	for i = 0, list.Count - 1, 1 do 
		if(list[i].id == 0) then
			break;
		end
		local instObj = instantiate(itemPrefab);
		local item = UITemplateItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(list[i]);
		
		local itemBtn = UIUtils.GetButtonListener(item.mUIRoot.gameObject);
		itemBtn.onClick = self.OnTemplateItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mView.mTrans_PresetDetailPanel_TemplateList.transform);
		self.mTemplateItems[i+1] = item;
		
		if(self.mCurTemplateId == list[i].id) then
			self.mCurTempItem = item;
		end
	end
	
	--self.mCurTempItem = self.mTemplateItems[1];
	self.mCurTempItem:SetSelect(true);
	
	self:InitCommanderModel();
	local complexion = NetCmdCommanderData:GetDefaultComplexion(self.mCurTemplateId);
	if(complexion == 1) then
		self.OnSkinColor2Clicked(nil);
	else
		self.OnSkinColor1Clicked(nil);
	end
	
	setactive(self.mView.mBtn_CustomDetailPanel_HideFromViewButton.gameObject, false);
	setactive(self.mView.mBtn_CustomDetailPanel_ShowFromViewButton.gameObject, false);
end

function UICommanderCustomMadePanel:InitCommanderModel()
	CS.CommanderModManager.Instance:InitDefaultModelRole(self.mFakeBodyIds[self.mCurTemplateId]);
end

function UICommanderCustomMadePanel.OnTemplateItemClicked(gameObj)
	self = UICommanderCustomMadePanel;
		
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		self.mIsInit = false;
		self.mCurTempItem:SetSelect(false);
		self.mCurTempItem = eventTrigger.param;
		self.mCurTempItem:SetSelect(true);
		
		local id = self.mFakeBodyIds[self.mCurTempItem.mData.id];
		CS.CommanderModManager.Instance:ChangeTemplate(id,self.mCurTempItem.mData.id);
		
		self.mCurTemplateId = self.mCurTempItem.mData.id;
		self:InitTemplateTypes();
		self:ResetAllSelectDecoItems();
		
		local complexion = NetCmdCommanderData:GetDefaultComplexion(self.mCurTemplateId);
		if(complexion == 1) then
			self.OnSkinColor2Clicked(self.mView.mBtn_PresetDetailPanel_BrightButton.gameObject);
		else
			self.OnSkinColor1Clicked(self.mView.mBtn_PresetDetailPanel_DarkButton.gameObject);
		end
	end
end



function UICommanderCustomMadePanel.OnSkinColor1Clicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	if(gameObj ~= nil) then
		CS.CommanderModManager.Instance:ChangeComplexion(0);
	end
	
	setactive(self.mView.mTrans_PresetDetailPanel_DarkChosen.gameObject, true);
	setactive(self.mView.mTrans_PresetDetailPanel_BrightChosen.gameObject, false);
end

function UICommanderCustomMadePanel.OnSkinColor2Clicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	if(gameObj ~= nil) then
		CS.CommanderModManager.Instance:ChangeComplexion(1);
	end
	
	setactive(self.mView.mTrans_PresetDetailPanel_DarkChosen.gameObject, false);
	setactive(self.mView.mTrans_PresetDetailPanel_BrightChosen.gameObject, true);
end


----------------------------------发型----------------------------------------

function UICommanderCustomMadePanel:InitHairStyle()
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_CustomItem,self);
	local hairList = NetCmdCommanderData:GetAvailableHairList(self.mCurTemplateId);
	local defaultId = NetCmdCommanderData:GetDefaultHairStyle(self.mCurTemplateId, self.mIsInit);
	
	self.ClearCustomHairStyleItems();
	for i = 0, hairList.Count-1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UICustomItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(hairList[i]);
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_CustomItemButton.gameObject);
		itemBtn.onClick = self.OnHairStyleItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeDetailList.transform);
		self.mCustomHairStyleItems[i+1] = item;
		
		if(defaultId == hairList[i].id) then
			self.mCurHairStyleItem = item;
		end
	end
	
	self.mCurHairStyleItem:SetSelect(true);
end

function UICommanderCustomMadePanel:InitHairColorPrestItems()
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_PresetColorItem,self);
	local listColor = NetCmdCommanderData:GetHairPresetColorList();
	
	
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorDetail_ColorPreset.gameObject, false);
	
	for i = 0, listColor.Count - 1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UIPresetColorItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(listColor[i]);
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_PresetColor.gameObject);
		itemBtn.onClick = self.OnHairColorPresetItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorDetail_ColorPresetList.transform);
	end
	
	local defaultColor = NetCmdCommanderData:GetDefaultHairColor(self.mCurTemplateId, self.mIsInit);
	self.mView.mImage_CustomDetailPanel_HairDetailPanel_HairColorDetail_ColorPresent.color = defaultColor;
end


function UICommanderCustomMadePanel:InitHairPanelButtons ()
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_HairButton.gameObject).onClick = self.OnHairClicked;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_HairDetailPanel_HairColorDetail_ColorPickerButton.gameObject).onClick = self.OnHairColorPickerClicked;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_HairDetailPanel_HairType.gameObject).onClick = self.OnHairStyleBtnClicked;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_HairDetailPanel_HairColor.gameObject).onClick = self.OnHairColorBtnClicked;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_HairDetailPanel_HairColorDetail_ColorPresetButton.gameObject).onClick = self.OnHairPresetButtonClicked;
end

function UICommanderCustomMadePanel.OnHairClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel.gameObject,true);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_DecorationDetailPanel.gameObject,false);
	
	setactive(self.mView.mTrans_CustomDetailPanel_HairChosenText.gameObject,true);
	setactive(self.mView.mImage_CustomDetailPanel_HairChosenImage.gameObject,true);	
	setactive(self.mView.mTrans_CustomDetailPanel_EyeChosenText.gameObject,false);
	setactive(self.mView.mImage_CustomDetailPanel_EyeChosenImage.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_DecorationChosenText.gameObject,false);
	setactive(self.mView.mImage_CustomDetailPanel_DecorationChosenImage.gameObject,false);
	
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeChosenBG.gameObject,false);
	self.OnHairStyleBtnClicked(nil);	
	self.mCurSelectTag = self.DetailTag.Hair;
end

function UICommanderCustomMadePanel.OnHairStyleBtnClicked(gameObj)
	self = UICommanderCustomMadePanel;
	if(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeChosenBG.gameObject.activeSelf == false) then
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeChosenBG.gameObject,true);
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeChosenArrow.gameObject,true);
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeDetail.gameObject,true);
	else
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeChosenBG.gameObject,false);
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeChosenArrow.gameObject,false);
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeDetail.gameObject,false);
	end
	
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorChosenBG.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorChosenArrow.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorDetail.gameObject,false);
	
	CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairDetailList);
	self.ResizeHairDetailPanel();
end

function UICommanderCustomMadePanel.OnHairColorBtnClicked(gameObj)
	self = UICommanderCustomMadePanel;
	if(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorChosenBG.gameObject.activeSelf == false) then
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorChosenBG.gameObject,true);
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorChosenArrow.gameObject,true);
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorDetail.gameObject,true);
	else
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorChosenBG.gameObject,false);
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorChosenArrow.gameObject,false);
		setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorDetail.gameObject,false);
	end
	
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeChosenBG.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeChosenArrow.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeDetail.gameObject,false);
	
end

function UICommanderCustomMadePanel.OnHairStyleItemClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		self.mCurHairStyleItem:SetSelect(false);
		self.mCurHairStyleItem = eventTrigger.param;
		self.mCurHairStyleItem:SetSelect(true);
		
		CS.CommanderModManager.Instance:ChangeHairStyle(self.mCurHairStyleItem.mData.id);
	end
end

function UICommanderCustomMadePanel.OnHairColorPresetItemClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local item = eventTrigger.param;
		CS.CommanderModManager.Instance:ChangeHairColor(item.mColor);
		self.mView.mImage_CustomDetailPanel_HairDetailPanel_HairColorDetail_ColorPresent.color = item.mColor;
	end
	
	setactive(self.mView.mBtn_CustomDetailPanel_HairDetailPanel_HairColorDetail_ColorPickerButton.gameObject, true);
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorDetail_ColorPreset.gameObject, false);
end

function UICommanderCustomMadePanel.OnHairColorPickerClicked(gameObj)
	self = UICommanderCustomMadePanel;
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_ColorPicker,self);
	local instObj = instantiate(itemPrefab);
	
	UIUtils.AddListItem(instObj,self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairDetailList.transform.parent);
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairDetailList.gameObject, false);
	
	local item = UIColorPickerItem.New();
	item:InitCtrl(instObj.transform);
	item:InitCallBack(self.OnHairColorChanged,self.OnHairColorConfirmed);
	if(self.mHairColorData ~= nil) then
		item:InitHandlePos(self.mHairColorData.handlePos);
	end
	
	self.mCurColorPicker = item;
end

function UICommanderCustomMadePanel.OnHairColorChanged(data)
	self = UICommanderCustomMadePanel;
	CS.CommanderModManager.Instance:ChangeHairColor(data.color);
	self.mHairColorData = data;
end

function UICommanderCustomMadePanel.OnHairColorConfirmed()
	self = UICommanderCustomMadePanel;
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairDetailList.gameObject, true);
	self.mCurColorPicker:DestroySelf();
	self.mCurColorPicker = nil;
	
	self.mView.mImage_CustomDetailPanel_HairDetailPanel_HairColorDetail_ColorPresent.color = self.mHairColorData.color;
end

function UICommanderCustomMadePanel.OnHairPresetButtonClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	setactive(self.mView.mBtn_CustomDetailPanel_HairDetailPanel_HairColorDetail_ColorPickerButton.gameObject, false);
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairColorDetail_ColorPreset.gameObject, true);
end

function UICommanderCustomMadePanel.ClearCustomHairStyleItems()
	self = UICommanderCustomMadePanel;
	
	for i = 1,#self.mCustomHairStyleItems,1 do
		self.mCustomHairStyleItems[i]:DestroySelf();
	end
	
	self.mCustomHairStyleItems = {};
end

function UICommanderCustomMadePanel.ResizeHairDetailPanel()
	self = UICommanderCustomMadePanel;
	local hairDetailPanel = self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeDetail;
	local typeList = self.mView.mTrans_CustomDetailPanel_HairDetailPanel_HairTypeDetailList;	
	local size = typeList.sizeDelta;
	hairDetailPanel.sizeDelta = size;
end

----------------------------------眼睛----------------------------------------

function UICommanderCustomMadePanel:InitEyeType()
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_CustomItem,self);
	local eyeList = NetCmdCommanderData:GetAvailableEyeList(self.mCurTemplateId);
	local defaultId = NetCmdCommanderData:GetDefaultEyeStyle(self.mCurTemplateId, self.mIsInit);

	self.ClearCustomEyeTypeItems();
	for i = 0, eyeList.Count-1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UICustomItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(eyeList[i]);
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_CustomItemButton.gameObject);
		itemBtn.onClick = self.OnEyeTypeItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeDetailList.transform);
		self.mCustomEyeTypeItems[i+1] = item;
		
		if(defaultId == eyeList[i].id) then
			self.mCurEyeTypeItem = item;
			gfdebug(defaultId);
		end
	end
	
	self.mCurEyeTypeItem:SetSelect(true);
end

function UICommanderCustomMadePanel:InitEyePanelButtons ()
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_EyeButton.gameObject).onClick = self.OnEyeClicked;	
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_EyeDetailPanel_EyeColorDetail_ColorPickerButton.gameObject).onClick = self.OnEyeColorPickerClicked;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_EyeDetailPanel_EyeType.gameObject).onClick = self.OnEyeTypeBtnClicked;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_EyeDetailPanel_EyeColor.gameObject).onClick = self.OnEyeColorBtnClicked;
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_EyeDetailPanel_EyeColorDetail_ColorPresetButton.gameObject).onClick = self.OnEyePresetButtonClicked;
end

function UICommanderCustomMadePanel:InitEyeColorPrestItems()
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_PresetColorItem,self);
	local listColor = NetCmdCommanderData:GetHairPresetColorList();
	
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorDetail_ColorPreset.gameObject, false);
	
	for i = 0, listColor.Count - 1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UIPresetColorItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(listColor[i]);
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_PresetColor.gameObject);
		itemBtn.onClick = self.OnEyeColorPresetItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorDetail_ColorPresetList.transform);
	end
	
	local defaultColor = NetCmdCommanderData:GetDefaultEyeColor(self.mCurTemplateId, self.mIsInit);
	self.mView.mImage_CustomDetailPanel_EyeDetailPanel_EyeColorDetail_ColorPresent.color = defaultColor;
end

function UICommanderCustomMadePanel.OnEyeClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel.gameObject,true);
	setactive(self.mView.mTrans_CustomDetailPanel_DecorationDetailPanel.gameObject,false);
	
	setactive(self.mView.mTrans_CustomDetailPanel_HairChosenText.gameObject,false);
	setactive(self.mView.mImage_CustomDetailPanel_HairChosenImage.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeChosenText.gameObject,true);
	setactive(self.mView.mImage_CustomDetailPanel_EyeChosenImage.gameObject,true);
	setactive(self.mView.mTrans_CustomDetailPanel_DecorationChosenText.gameObject,false);
	setactive(self.mView.mImage_CustomDetailPanel_DecorationChosenImage.gameObject,false);
	
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeChosenBG.gameObject,false);
	self.OnEyeTypeBtnClicked(nil);
	self.mCurSelectTag = self.DetailTag.Eye;
end

function UICommanderCustomMadePanel.OnEyeTypeBtnClicked(gameObj)
	self = UICommanderCustomMadePanel;
	if(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeChosenBG.gameObject.activeSelf == false) then
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeChosenBG.gameObject,true);
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeChosenArrow.gameObject,true);
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeDetail.gameObject,true);
	else
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeChosenBG.gameObject,false);
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeChosenArrow.gameObject,false);
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeDetail.gameObject,false);
	end
	
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorChosenBG.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorChosenArrow.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorDetail.gameObject,false);
	
	CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeDetailList);
	self.ResizeEyeDetailPanel();
end

function UICommanderCustomMadePanel.OnEyeColorBtnClicked(gameObj)
	self = UICommanderCustomMadePanel;
	if(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorChosenBG.gameObject.activeSelf == false) then
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorChosenBG.gameObject,true);
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorChosenArrow.gameObject,true);
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorDetail.gameObject,true);
	else
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorChosenBG.gameObject,false);
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorChosenArrow.gameObject,false);
		setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorDetail.gameObject,false);
	end
	
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeChosenBG.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeChosenArrow.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeDetail.gameObject,false);
	
end

function UICommanderCustomMadePanel.OnEyeColorPresetItemClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local item = eventTrigger.param;
		CS.CommanderModManager.Instance:ChangeEyeColor(item.mColor);
		self.mView.mImage_CustomDetailPanel_EyeDetailPanel_EyeColorDetail_ColorPresent.color = item.mColor;
	end
	
	setactive(self.mView.mBtn_CustomDetailPanel_EyeDetailPanel_EyeColorDetail_ColorPickerButton.gameObject, true);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorDetail_ColorPreset.gameObject, false);
end

function UICommanderCustomMadePanel.OnEyeTypeItemClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		self.mCurEyeTypeItem:SetSelect(false);
		self.mCurEyeTypeItem = eventTrigger.param;
		self.mCurEyeTypeItem:SetSelect(true);
		
		CS.CommanderModManager.Instance:ChangeEyeType(self.mCurEyeTypeItem.mData.id);
	end
end


function UICommanderCustomMadePanel.OnEyeColorPickerClicked(gameObj)
	self = UICommanderCustomMadePanel;
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_ColorPicker,self);
	local instObj = instantiate(itemPrefab);
	
	UIUtils.AddListItem(instObj,self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeDetailList.transform.parent);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeDetailList.gameObject, false);
	
	local item = UIColorPickerItem.New();
	item:InitCtrl(instObj.transform);
	item:InitCallBack(self.OnEyeColorChanged,self.OnEyeColorConfirmed);
	if(self.mEyeColorData ~= nil) then
		item:InitHandlePos(self.mEyeColorData.handlePos);
	end
	
	self.mCurColorPicker = item;
end

function UICommanderCustomMadePanel.OnEyeColorChanged(data)
	self = UICommanderCustomMadePanel;
	CS.CommanderModManager.Instance:ChangeEyeColor(data.color);
	self.mEyeColorData = data;
end

function UICommanderCustomMadePanel.OnEyeColorConfirmed()
	self = UICommanderCustomMadePanel;
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeDetailList.gameObject, true);
	self.mCurColorPicker:DestroySelf();
	self.mCurColorPicker = nil;
	
	self.mView.mImage_CustomDetailPanel_EyeDetailPanel_EyeColorDetail_ColorPresent.color = self.mEyeColorData.mColor;
end

function UICommanderCustomMadePanel.OnEyePresetButtonClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	setactive(self.mView.mBtn_CustomDetailPanel_EyeDetailPanel_EyeColorDetail_ColorPickerButton.gameObject, false);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeColorDetail_ColorPreset.gameObject, true);
end

function UICommanderCustomMadePanel.ClearCustomEyeTypeItems()
	self = UICommanderCustomMadePanel;
	
	for i = 1,#self.mCustomEyeTypeItems,1 do
		self.mCustomEyeTypeItems[i]:DestroySelf();
	end
	
	self.mCustomEyeTypeItems = {};
end

function UICommanderCustomMadePanel.ResizeEyeDetailPanel()
	self = UICommanderCustomMadePanel;
	local eyeDetailPanel = self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeDetail;
	local typeList = self.mView.mTrans_CustomDetailPanel_EyeDetailPanel_EyeTypeDetailList;	
	local size = typeList.sizeDelta;
	eyeDetailPanel.sizeDelta = size;
end

----------------------------------纹身-----------------------------------------

function UICommanderCustomMadePanel:InitTattooItems()
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_CustomItem,self);
	local tattooList = TableData.GetCommanderTattooList();

	local defaultId = NetCmdCommanderData:GetDefaultTattooId(self.mCurTemplateId,1,self.mIsInit);
	for i = 0, tattooList.Count-1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UICustomItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(tattooList[i]);
		item.mDecoIndex = self.DecoType.TattooLeft;
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_CustomItemButton.gameObject);
		itemBtn.onClick = self.OnTattooItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mDecoPanelUIItems[1][10].transform);
		
		if(tattooList[i].id == defaultId) then
			self.mCurDecoItems[item.mDecoIndex] = item;
			--self.mDefaultDecoItems[item.mDecoIndex] = item;
			item:SetSelect(true);
		end
		
		if(i == 0) then
			self.mDefaultDecoItems[item.mDecoIndex] = item;
		end
	end

	local defaultId = NetCmdCommanderData:GetDefaultTattooId(self.mCurTemplateId,2,self.mIsInit);
	for i = 0, tattooList.Count-1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UICustomItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(tattooList[i]);
		item.mDecoIndex = self.DecoType.TattooRight;
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_CustomItemButton.gameObject);
		itemBtn.onClick = self.OnTattooItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mDecoPanelUIItems[2][10].transform);
		
		if(tattooList[i].id == defaultId) then
			self.mCurDecoItems[item.mDecoIndex] = item;
			--self.mDefaultDecoItems[item.mDecoIndex] = item;
			item:SetSelect(true);
		end
		
		if(i == 0) then
			self.mDefaultDecoItems[item.mDecoIndex] = item;
		end
	end

	local defaultId = NetCmdCommanderData:GetDefaultTattooId(self.mCurTemplateId,3,self.mIsInit);
	for i = 0, tattooList.Count-1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UICustomItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(tattooList[i]);
		item.mDecoIndex = self.DecoType.TattooUp;
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_CustomItemButton.gameObject);
		itemBtn.onClick = self.OnTattooItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mDecoPanelUIItems[3][10].transform);
		
		if(tattooList[i].id == defaultId) then
			self.mCurDecoItems[item.mDecoIndex] = item;
			--self.mDefaultDecoItems[item.mDecoIndex] = item;
			item:SetSelect(true);
		end
		
		if(i == 0) then
			self.mDefaultDecoItems[item.mDecoIndex] = item;
		end
	end
end

function UICommanderCustomMadePanel.OnTattooItemClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local item = eventTrigger.param;
		local index = item.mDecoIndex;
		
		self.mCurDecoItems[index]:SetSelect(false);
		self.mCurDecoItems[index] = eventTrigger.param;
		self.mCurDecoItems[index]:SetSelect(true);
		
		local data = item.mData;
		CS.CommanderModManager.Instance:ChangeFaceTattoo1(data.id);
	end
	
end

----------------------------------装饰-----------------------------------------
function UICommanderCustomMadePanel:InitDecoItems()
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_CustomItem,self);
	local headwearList = NetCmdCommanderData:GetAvailableDecoList(self.mCurTemplateId,1);
	local glassesList = NetCmdCommanderData:GetAvailableDecoList(self.mCurTemplateId,2);
	local earringList = NetCmdCommanderData:GetAvailableDecoList(self.mCurTemplateId,4);

	local defaultId = NetCmdCommanderData:GetDefaultDecoId(self.mCurTemplateId,1,self.mIsInit);
	for i = 0, headwearList.Count-1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UICustomItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(headwearList[i]);
		item.mDecoIndex = self.DecoType.Headwear;
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_CustomItemButton.gameObject);
		itemBtn.onClick = self.OnDecoItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mDecoPanelUIItems[4][10].transform);
		
		if(headwearList[i].id == defaultId) then
			self.mCurDecoItems[item.mDecoIndex] = item;
			--self.mDefaultDecoItems[item.mDecoIndex] = item;
			item:SetSelect(true);
		end
		
		if(i == 0) then
			self.mDefaultDecoItems[item.mDecoIndex] = item;
		end
	end

	defaultId = NetCmdCommanderData:GetDefaultDecoId(self.mCurTemplateId,2,self.mIsInit);
	for i = 0, glassesList.Count-1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UICustomItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(glassesList[i]);
		item.mDecoIndex = self.DecoType.Glasses;
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_CustomItemButton.gameObject);
		itemBtn.onClick = self.OnDecoItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mDecoPanelUIItems[5][10].transform);
		
		if(glassesList[i].id == defaultId) then
			self.mCurDecoItems[item.mDecoIndex] = item;
			--self.mDefaultDecoItems[item.mDecoIndex] = item;
			item:SetSelect(true);
		end
		
		if(i == 0) then
			self.mDefaultDecoItems[item.mDecoIndex] = item;
		end
	end

	--TODO--
	self.mCurDecoItems[self.DecoType.Beard] = "";
	self.mDefaultDecoItems[self.DecoType.Beard] = "";
	--------
	
	defaultId = NetCmdCommanderData:GetDefaultDecoId(self.mCurTemplateId,4,self.mIsInit);
	for i = 0, earringList.Count-1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UICustomItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(earringList[i]);
		item.mDecoIndex = self.DecoType.Earring;
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_CustomItemButton.gameObject);
		itemBtn.onClick = self.OnDecoItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mDecoPanelUIItems[7][10].transform);
		
		if(earringList[i].id == defaultId) then
			self.mCurDecoItems[item.mDecoIndex] = item;
			--self.mDefaultDecoItems[item.mDecoIndex] = item;
			item:SetSelect(true);
		end
		
		if(i == 0) then
			self.mDefaultDecoItems[item.mDecoIndex] = item;
		end
	end
end

function UICommanderCustomMadePanel.OnDecoItemClicked(gameObj)
	self = UICommanderCustomMadePanel;

	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local item = eventTrigger.param;
		local index = item.mDecoIndex;
		
		self.mCurDecoItems[index]:SetSelect(false);
		self.mCurDecoItems[index] = eventTrigger.param;
		self.mCurDecoItems[index]:SetSelect(true);
		
		self.ChangeDeco(item);
	end
end



function UICommanderCustomMadePanel.ChangeDeco(item)
	self = UICommanderCustomMadePanel;
	local data = item.mData;
	
	if(data.position == 1) then
		CS.CommanderModManager.Instance:ChangeHeadDeco(data.id);
	end
	
	if(data.position == 2) then
		CS.CommanderModManager.Instance:ChangeEyeGlass(data.id);
	end
	
	if(data.position == 4) then
		CS.CommanderModManager.Instance:ChangeEarRing(data.id);
	end
end


function UICommanderCustomMadePanel.OnDecoColorPickerClicked(gameObj)
	self = UICommanderCustomMadePanel;
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_ColorPicker,self);
	local instObj = instantiate(itemPrefab);
	local index = 0;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		index = eventTrigger.param;
	end
	
	if(index == 0) then
		gfdebug("index error");
		return;
	end
	
	UIUtils.AddListItem(instObj,self.mView.mTrans_CustomDetailPanel_DecorationDetailList.transform.parent);
	setactive(self.mView.mTrans_CustomDetailPanel_DecorationDetailList.gameObject, false);
	
	local item = UIColorPickerItem.New();
	item:InitCtrl(instObj.transform);
	item:InitCallBack(self.OnDecoColorChanged,self.OnDecoColorConfirmed);
	if(self.mDecoColorDatas[index] ~= nil) then
		item:InitHandlePos(self.mDecoColorDatas[index].handlePos);
	end
	
	self.mCurColorPicker = item;
	self.mCurColorPicker.mTagIndex = index;
end

function UICommanderCustomMadePanel.OnDecoColorChanged(data)
	self = UICommanderCustomMadePanel;
	
	local tag = self.mCurColorPicker.mTagIndex;
	
	if(tag == self.DecoType.TattooLeft) then
		CS.CommanderModManager.Instance:ChangeFaceTattoo1Color(data.color);
	end
	
	if(tag == self.DecoType.Glasses) then
		CS.CommanderModManager.Instance:ChangeEyeGlassColor(data.color);		
	end
	
	if(tag == self.DecoType.Earring) then
		CS.CommanderModManager.Instance:ChangeEarRingColor(data.color);
	end
	
	self.mDecoColorDatas[tag] = data;
end

function UICommanderCustomMadePanel.OnDecoColorConfirmed()
	self = UICommanderCustomMadePanel;
	
	local tag = self.mCurColorPicker.mTagIndex;
	self.mDecoColorPickerItems[tag][5].color = self.mDecoColorDatas[tag].color;
	
	setactive(self.mView.mTrans_CustomDetailPanel_DecorationDetailList.gameObject, true);
	self.mCurColorPicker:DestroySelf();
	self.mCurColorPicker = nil;
end

function UICommanderCustomMadePanel.OnDecoPresetButtonClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		index = eventTrigger.param;
		
		setactive(self.mDecoColorPickerItems[index][1].gameObject, false);
		setactive(self.mDecoColorPickerItems[index][4].gameObject.gameObject, true);
	end	
end

function UICommanderCustomMadePanel.OnDecoColorPresetItemClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local item = eventTrigger.param[1];
		local index = eventTrigger.param[2];
		
		if(index == self.DecoType.TattooLeft) then
			CS.CommanderModManager.Instance:ChangeFaceTattoo1Color(item.mColor);
		end
	
		if(index == self.DecoType.Glasses) then
			CS.CommanderModManager.Instance:ChangeEyeGlassColor(item.mColor);		
		end
	
		if(index == self.DecoType.Earring) then
			CS.CommanderModManager.Instance:ChangeEarRingColor(item.mColor);
		end
		--CS.CommanderModManager.Instance:ChangeHairColor(item.mColor);
		self.mDecoColorPickerItems[index][5].color = item.mColor;
		
		setactive(self.mDecoColorPickerItems[index][1].gameObject, true);
		setactive(self.mDecoColorPickerItems[index][4].gameObject.gameObject, false);
	end
end

----------------------------------纹身装饰UI----------------------------------------

function UICommanderCustomMadePanel:InitDecorationPanelButtons ()
	UIUtils.GetButtonListener(self.mView.mBtn_CustomDetailPanel_DecorationButton.gameObject).onClick = self.OnDecorationClicked;
	
	for i = 1, #self.mDecoPanelUIItems, 1 do
		local btn = self.mDecoPanelUIItems[i][3];
		local itemBtn = UIUtils.GetButtonListener(btn.gameObject);
		itemBtn.onClick = self.OnDecoSelectButtonClicked;
		itemBtn.param = i;
		
		btn = self.mDecoPanelUIItems[i][4];
		itemBtn = UIUtils.GetButtonListener(btn.gameObject);
		itemBtn.onClick = self.OnDecoTypeButtonClicked;
		itemBtn.param = i;
		
		btn = self.mDecoPanelUIItems[i][5];
		itemBtn = UIUtils.GetButtonListener(btn.gameObject);
		itemBtn.onClick = self.OnDecoColorButtonClicked;
		itemBtn.param = i;
		
		btn = self.mDecoPanelUIItems[i][6];
		itemBtn = UIUtils.GetButtonListener(btn.gameObject);
		itemBtn.onClick = self.OnDecoLocationButtonClicked;
		itemBtn.param = i;
	end
	
end

function UICommanderCustomMadePanel:InitDecoPanelUIItems()

	self.mDecoPanelUIItems[1] = {self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList, 
								 self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_FaceTattooTagPanel,
								 self.mView.mBtn_CustomDetailPanel_FaceTattooLeftList_FaceTattoo, 
								 self.mView.mBtn_CustomDetailPanel_FaceTattooLeftList_TypeButton,
								 self.mView.mBtn_CustomDetailPanel_FaceTattooLeftList_ColorButton,
								 self.mView.mBtn_CustomDetailPanel_FaceTattooLeftList_LocationButton,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooLeftTypeDetail,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooLeftColorDetail,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooLeftTransparencyModifier,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooLeftTypeDetail_TypeList,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_FaceTattooChosenBG,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_FaceTattooChosenArrow};
								 
	self.mDecoPanelUIItems[2] = {self.mView.mTrans_CustomDetailPanel_FaceTattooRightList, 
								 self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_FaceTattooTagPanel,
								 self.mView.mBtn_CustomDetailPanel_FaceTattooRightList_FaceTattoo, 
								 self.mView.mBtn_CustomDetailPanel_FaceTattooRightList_TypeButton,
								 self.mView.mBtn_CustomDetailPanel_FaceTattooRightList_ColorButton,
								 self.mView.mBtn_CustomDetailPanel_FaceTattooRightList_LocationButton,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooRightTypeDetail,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooRightColorDetail,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooRightTransparencyModifier,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooRightTypeDetail_TypeList,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_FaceTattooChosenBG,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_FaceTattooChosenArrow};
								 
	self.mDecoPanelUIItems[3] = {self.mView.mTrans_CustomDetailPanel_FaceTattooUpList, 
								 self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_FaceTattooTagPanel,
								 self.mView.mBtn_CustomDetailPanel_FaceTattooUpList_FaceTattoo, 
								 self.mView.mBtn_CustomDetailPanel_FaceTattooUpList_TypeButton,
								 self.mView.mBtn_CustomDetailPanel_FaceTattooUpList_ColorButton,
								 self.mView.mBtn_CustomDetailPanel_FaceTattooUpList_LocationButton,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooUpTypeDetail,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooUpColorDetail,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooUpTransparencyModifier,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooUpTypeDetail_TypeList,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_FaceTattooChosenBG,
								 self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_FaceTattooChosenArrow};
								 
	self.mDecoPanelUIItems[4] = {self.mView.mTrans_CustomDetailPanel_HeadwearList, 
								 self.mView.mTrans_CustomDetailPanel_HeadwearList_HeadwearTagPanel,
								 self.mView.mBtn_CustomDetailPanel_HeadwearList_Headwear, 
								 self.mView.mBtn_CustomDetailPanel_HeadwearList_TypeButton,
								 self.mView.mBtn_CustomDetailPanel_HeadwearList_ColorButton,
								 self.mView.mBtn_CustomDetailPanel_HeadwearList_LocationButton,
								 self.mView.mTrans_CustomDetailPanel_HeadwearTypeDetail,
								 self.mView.mTrans_CustomDetailPanel_HeadwearColorDetail,
								 nil,
								 self.mView.mTrans_CustomDetailPanel_HeadwearTypeDetail_TypeList,
								 self.mView.mTrans_CustomDetailPanel_HeadwearList_HeadwearChosenBG,
								 self.mView.mTrans_CustomDetailPanel_HeadwearList_HeadwearChosenArrow};
								 
	self.mDecoPanelUIItems[5] = {self.mView.mTrans_CustomDetailPanel_GlassesList, 
		                         self.mView.mTrans_CustomDetailPanel_GlassesList_GlassesTagPanel,
								 self.mView.mBtn_CustomDetailPanel_GlassesList_Glasses, 
								 self.mView.mBtn_CustomDetailPanel_GlassesList_TypeButton,
								 self.mView.mBtn_CustomDetailPanel_GlassesList_ColorButton,
								 self.mView.mBtn_CustomDetailPanel_GlassesList_LocationButton,
								 self.mView.mTrans_CustomDetailPanel_GlassesTypeDetail,
								 self.mView.mTrans_CustomDetailPanel_GlassesColorDetail,
								 nil,
								 self.mView.mTrans_CustomDetailPanel_GlassesTypeDetail_TypeList,
								 self.mView.mTrans_CustomDetailPanel_GlassesList_GlassesChosenBG,
								 self.mView.mTrans_CustomDetailPanel_GlassesList_GlassesChosenArrow};
								 
	self.mDecoPanelUIItems[6] = {self.mView.mTrans_CustomDetailPanel_BeardList, 
							     self.mView.mTrans_CustomDetailPanel_BeardList_BeardTagPanel,
								 self.mView.mBtn_CustomDetailPanel_BeardList_Beard, 
								 self.mView.mBtn_CustomDetailPanel_BeardList_TypeButton,
								 self.mView.mBtn_CustomDetailPanel_BeardList_ColorButton,
								 self.mView.mBtn_CustomDetailPanel_BeardList_LocationButton,
								 self.mView.mTrans_CustomDetailPanel_BeardTypeDetail,
								 nil,
								 nil,
								 self.mView.mTrans_CustomDetailPanel_BeardTypeDetail_TypeList,
								 self.mView.mTrans_CustomDetailPanel_BeardList_BeardChosenBG,
								 self.mView.mTrans_CustomDetailPanel_BeardList_BeardChosenArrow};
								 
	self.mDecoPanelUIItems[7] = {self.mView.mTrans_CustomDetailPanel_EarringList, 
							     self.mView.mTrans_CustomDetailPanel_EarringList_EarringTagPanel,
								 self.mView.mBtn_CustomDetailPanel_EarringList_Earring, 
								 self.mView.mBtn_CustomDetailPanel_EarringList_TypeButton,
								 self.mView.mBtn_CustomDetailPanel_EarringList_ColorButton,
								 self.mView.mBtn_CustomDetailPanel_EarringList_LocationButton,
								 self.mView.mTrans_CustomDetailPanel_EarringTypeDetail,
								 self.mView.mTrans_CustomDetailPanel_EarringColorDetail,
								 nil,
								 self.mView.mTrans_CustomDetailPanel_EarringTypeDetail_TypeList,
								 self.mView.mTrans_CustomDetailPanel_EarringList_EarringChosenBG,
								 self.mView.mTrans_CustomDetailPanel_EarringList_EarringChosenArrow};							 
end

function UICommanderCustomMadePanel:InitDecoTypeButtonChosenItems ()
	self.mDecoTypeButtonChosenItems[1] = {self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_TypeChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_TypeChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_TypeChosenText,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_ColorChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_ColorChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_ColorChosenText,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_LocationChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_LocationChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooLeftList_LocationChosenText};
										  
	self.mDecoTypeButtonChosenItems[2] = {self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_TypeChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_TypeChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_TypeChosenText,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_ColorChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_ColorChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_ColorChosenText,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_LocationChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_LocationChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooRightList_LocationChosenText};

	self.mDecoTypeButtonChosenItems[3] = {self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_TypeChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_TypeChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_TypeChosenText,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_ColorChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_ColorChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_ColorChosenText,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_LocationChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_LocationChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_FaceTattooUpList_LocationChosenText};	
	
	self.mDecoTypeButtonChosenItems[4] = {self.mView.mTrans_CustomDetailPanel_HeadwearList_TypeChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_HeadwearList_TypeChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_HeadwearList_TypeChosenText,
										  self.mView.mTrans_CustomDetailPanel_HeadwearList_ColorChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_HeadwearList_ColorChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_HeadwearList_ColorChosenText,
										  self.mView.mTrans_CustomDetailPanel_HeadwearList_LocationChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_HeadwearList_LocationChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_HeadwearList_LocationChosenText};
										  
	self.mDecoTypeButtonChosenItems[5] = {self.mView.mTrans_CustomDetailPanel_GlassesList_TypeChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_GlassesList_TypeChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_GlassesList_TypeChosenText,
										  self.mView.mTrans_CustomDetailPanel_GlassesList_ColorChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_GlassesList_ColorChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_GlassesList_ColorChosenText,
										  self.mView.mTrans_CustomDetailPanel_GlassesList_LocationChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_GlassesList_LocationChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_GlassesList_LocationChosenText};
										  
	self.mDecoTypeButtonChosenItems[6] = {self.mView.mTrans_CustomDetailPanel_BeardList_TypeChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_BeardList_TypeChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_BeardList_TypeChosenText,
										  self.mView.mTrans_CustomDetailPanel_BeardList_ColorChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_BeardList_ColorChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_BeardList_ColorChosenText,
										  self.mView.mTrans_CustomDetailPanel_BeardList_LocationChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_BeardList_LocationChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_BeardList_LocationChosenText};
										  
	self.mDecoTypeButtonChosenItems[7] = {self.mView.mTrans_CustomDetailPanel_EarringList_TypeChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_EarringList_TypeChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_EarringList_TypeChosenText,
										  self.mView.mTrans_CustomDetailPanel_EarringList_ColorChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_EarringList_ColorChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_EarringList_ColorChosenText,
										  self.mView.mTrans_CustomDetailPanel_EarringList_LocationChosenImage1,
										  self.mView.mTrans_CustomDetailPanel_EarringList_LocationChosenImage2,
										  self.mView.mTrans_CustomDetailPanel_EarringList_LocationChosenText};
end

function UICommanderCustomMadePanel:InitDecoColorPickerItems()
	self.mDecoColorPickerItems[1] = {self.mView.mBtn_CustomDetailPanel_FaceTattooLeftColorDetail_ColorPickerButton,
									 self.mView.mBtn_CustomDetailPanel_FaceTattooLeftColorDetail_ColorPresetButton,
									 self.mView.mTrans_CustomDetailPanel_FaceTattooLeftColorDetail_ColorPresetList,
									 self.mView.mTrans_CustomDetailPanel_FaceTattooLeftColorDetail_ColorPreset,
									 self.mView.mImage_CustomDetailPanel_FaceTattooLeftColorDetail_ColorPresent};
										
	self.mDecoColorPickerItems[2] = {self.mView.mBtn_CustomDetailPanel_FaceTattooRightColorDetail_ColorPickerButton,
									 self.mView.mBtn_CustomDetailPanel_FaceTattooRightColorDetail_ColorPresetButton,
									 self.mView.mTrans_CustomDetailPanel_FaceTattooRightColorDetail_ColorPresetList,
									 self.mView.mTrans_CustomDetailPanel_FaceTattooRightColorDetail_ColorPreset,
									 self.mView.mImage_CustomDetailPanel_FaceTattooRightColorDetail_ColorPresent};
										
	self.mDecoColorPickerItems[3] = {self.mView.mBtn_CustomDetailPanel_FaceTattooUpColorDetail_ColorPickerButton,
									 self.mView.mBtn_CustomDetailPanel_FaceTattooUpColorDetail_ColorPresetButton,
									 self.mView.mTrans_CustomDetailPanel_FaceTattooUpColorDetail_ColorPresetList,
									 self.mView.mTrans_CustomDetailPanel_FaceTattooUpColorDetail_ColorPreset,
									 self.mView.mImage_CustomDetailPanel_FaceTattooUpColorDetail_ColorPresent};

	self.mDecoColorPickerItems[4] = {self.mView.mBtn_CustomDetailPanel_HeadwearColorDetail_ColorPickerButton,
									 self.mView.mBtn_CustomDetailPanel_HeadwearColorDetail_ColorPresetButton,
									 self.mView.mTrans_CustomDetailPanel_HeadwearColorDetail_ColorPresetList,
									 self.mView.mTrans_CustomDetailPanel_HeadwearColorDetail_ColorPreset,
									 self.mView.mImage_CustomDetailPanel_HeadwearColorDetail_ColorPresent};

	self.mDecoColorPickerItems[5] = {self.mView.mBtn_CustomDetailPanel_GlassesColorDetail_ColorPickerButton,
									 self.mView.mBtn_CustomDetailPanel_GlassesColorDetail_ColorPresetButton,
									 self.mView.mTrans_CustomDetailPanel_GlassesColorDetail_ColorPresetList,
									 self.mView.mTrans_CustomDetailPanel_GlassesColorDetail_ColorPreset,
									 self.mView.mImage_CustomDetailPanel_GlassesColorDetail_ColorPresent};

    self.mDecoColorPickerItems[6] = {nil,
									 nil,
									 nil,
									 nil,
									 nil};

    self.mDecoColorPickerItems[7] = {self.mView.mBtn_CustomDetailPanel_EarringColorDetail_ColorPickerButton,
									 self.mView.mBtn_CustomDetailPanel_EarringColorDetail_ColorPresetButton,
									 self.mView.mTrans_CustomDetailPanel_EarringColorDetail_ColorPresetList,
									 self.mView.mTrans_CustomDetailPanel_EarringColorDetail_ColorPreset,
									 self.mView.mImage_CustomDetailPanel_EarringColorDetail_ColorPresent};		

											
	for i = 1, #self.mDecoColorPickerItems, 1 do 
		local picker = self.mDecoColorPickerItems[i][1];
		local preset = self.mDecoColorPickerItems[i][2];
		
		if(picker ~= nil) then	
			itemBtn = UIUtils.GetButtonListener(picker.gameObject);
			itemBtn.onClick = self.OnDecoColorPickerClicked;
			itemBtn.param = i;
		
			self.mDecoColorDatas[i] = nil;	
		    self:InitDecoColorPrestItems(i);
			
			itemBtn = UIUtils.GetButtonListener(preset.gameObject);
			itemBtn.onClick = self.OnDecoPresetButtonClicked;
			itemBtn.param = i;
		end
	end
end

function UICommanderCustomMadePanel:InitDecoColorPrestItems(index)
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_PresetColorItem,self);
	local listColor = NetCmdCommanderData:GetHairPresetColorList();
	
	setactive(self.mDecoColorPickerItems[index][4].gameObject, false);
	
	for i = 0, listColor.Count - 1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UIPresetColorItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(listColor[i]);
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_PresetColor.gameObject);
		itemBtn.onClick = self.OnDecoColorPresetItemClicked;
		itemBtn.param = {item,index};
		
		UIUtils.AddListItem(instObj,self.mDecoColorPickerItems[index][3].transform);
	end
	
	local defaultColor = NetCmdCommanderData:GetDefaultDecoColor(self.mCurTemplateId, index, self.mIsInit);
	self.mDecoColorPickerItems[index][5].color = defaultColor;
end



function UICommanderCustomMadePanel.OnDecorationClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	setactive(self.mView.mTrans_CustomDetailPanel_HairDetailPanel.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeDetailPanel.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_DecorationDetailPanel.gameObject,true);
	
	setactive(self.mView.mTrans_CustomDetailPanel_HairChosenText.gameObject,false);
	setactive(self.mView.mImage_CustomDetailPanel_HairChosenImage.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_EyeChosenText.gameObject,false);
	setactive(self.mView.mImage_CustomDetailPanel_EyeChosenImage.gameObject,false);
	setactive(self.mView.mTrans_CustomDetailPanel_DecorationChosenText.gameObject,true);
	setactive(self.mView.mImage_CustomDetailPanel_DecorationChosenImage.gameObject,true);
	
	self.UnselectDecoTypeButtons();	
end

function UICommanderCustomMadePanel.OnDecoSelectButtonClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local i = eventTrigger.param;	
		local primePanel = self.mDecoPanelUIItems[i][1];
		local tagPanel = self.mDecoPanelUIItems[i][2];
		local typeDetailPanel = self.mDecoPanelUIItems[i][7];
		local chosenBG = self.mDecoPanelUIItems[i][11];
		local chosenArrow = self.mDecoPanelUIItems[i][12];
				
		if(tagPanel.gameObject.activeSelf == true) then
			self.UnselectDecoTypeButtons();	
			return;
		end
		
		self.UnselectDecoTypeButtons();	
		setactive(tagPanel.gameObject,true);
		setactive(typeDetailPanel.gameObject,true);	
		setactive(chosenBG.gameObject, true);
		setactive(chosenArrow.gameObject, true);
		
		self.OnDecoTypeButtonClicked(self.mDecoPanelUIItems[i][4].gameObject);
		
		self.mCurSelectTag = i+2;
	end
end

function UICommanderCustomMadePanel.UnselectDecoTypeButtons()
	self = UICommanderCustomMadePanel;
	for i = 1, #self.mDecoPanelUIItems, 1 do
	
		local tagPanel = self.mDecoPanelUIItems[i][2];
		local typeDetailPanel = self.mDecoPanelUIItems[i][7];
		local colorDetailPanel = self.mDecoPanelUIItems[i][8];
		local transDetailPanel = self.mDecoPanelUIItems[i][9];	
		local chosenBG = self.mDecoPanelUIItems[i][11];
		local chosenArrow = self.mDecoPanelUIItems[i][12];
		
		setactive(chosenBG.gameObject, false);
		setactive(chosenArrow.gameObject, false);
		
		setactive(tagPanel.gameObject,false);
		setactive(typeDetailPanel.gameObject,false);
		if(colorDetailPanel ~= nil) then
			setactive(colorDetailPanel.gameObject,false);
		end
		if(transDetailPanel ~= nil) then
			setactive(transDetailPanel.gameObject,false);
		end
	end
	
	CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mView.mTrans_CustomDetailPanel_DecorationDetailList);
end

function UICommanderCustomMadePanel.OnDecoTypeButtonClicked (gameObj)

	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local i = eventTrigger.param;	
		local typeDetailPanel = self.mDecoPanelUIItems[i][7];
		local colorDetailPanel = self.mDecoPanelUIItems[i][8];
		local transDetailPanel = self.mDecoPanelUIItems[i][9];
			
		setactive(typeDetailPanel.gameObject, true);
		if(colorDetailPanel ~= nil) then
			setactive(colorDetailPanel.gameObject, false);
		end
		if(transDetailPanel ~= nil) then
			setactive(transDetailPanel.gameObject, false);
		end
		
		self.SetDecoChosenButtons(i,0);
	end
	
	CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mView.mTrans_CustomDetailPanel_DecorationDetailList);
	self.ResizeDecoTypeDetailPanel();	
end

function UICommanderCustomMadePanel.OnDecoColorButtonClicked (gameObj)
	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local i = eventTrigger.param;	
		local typeDetailPanel = self.mDecoPanelUIItems[i][7];
		local colorDetailPanel = self.mDecoPanelUIItems[i][8];
		local transDetailPanel = self.mDecoPanelUIItems[i][9];
		
		setactive(typeDetailPanel.gameObject, false);
		if(colorDetailPanel ~= nil) then
			setactive(colorDetailPanel.gameObject, true);
		end
		if(transDetailPanel ~= nil) then
			setactive(transDetailPanel.gameObject, true);
		end
		
		self.SetDecoChosenButtons(i,1);
	end
end

function UICommanderCustomMadePanel.OnDecoLocationButtonClicked (gameObj)
	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		local i = eventTrigger.param;	
		local typeDetailPanel = self.mDecoPanelUIItems[i][7];
		local colorDetailPanel = self.mDecoPanelUIItems[i][8];
		local transDetailPanel = self.mDecoPanelUIItems[i][9];
		
		setactive(typeDetailPanel.gameObject, false);
		if(colorDetailPanel ~= nil) then
			setactive(colorDetailPanel.gameObject, false);
		end
		if(transDetailPanel ~= nil) then
			setactive(transDetailPanel.gameObject, false);
		end
		
		self.SetDecoChosenButtons(i,2);
	end
end

function UICommanderCustomMadePanel.SetDecoChosenButtons(typeIndex,btnIndex)
	self = UICommanderCustomMadePanel;
	
	--local group = self.mDecoTypeButtonChosenItems[typeIndex];
	for i = 1, 9, 1 do
		local b = ((math.floor((i-1) / 3) == btnIndex));
		local item = self.mDecoTypeButtonChosenItems[typeIndex][i];
		if(item ~= nil) then
			setactive(item.gameObject,b);
		end
	end
end

function UICommanderCustomMadePanel.ResizeDecoTypeDetailPanel()
	self = UICommanderCustomMadePanel;
	
	for i = 1, #self.mDecoPanelUIItems, 1 do
		local typeDetailPanel = self.mDecoPanelUIItems[i][7];
		local typeList = self.mDecoPanelUIItems[i][10];
		local size = typeList.sizeDelta;
		
		typeDetailPanel.sizeDelta = size;
	end
end

----------------------------------换装----------------------------------------

function UICommanderCustomMadePanel:InitCostumeItems()
	local itemPrefab = UIUtils.GetGizmosPrefab(self.mPath_CostumeItem,self);
	local costumeList = NetCmdCommanderData:GetAvailableCostumeList(self.mCurTemplateId);	
	local defaultId = NetCmdCommanderData:GetDefaultCostumeId(self.mCurTemplateId);
	
	self.ClearCustomCostumeItems();
	for i = 0, costumeList.Count-1, 1 do 

		local instObj = instantiate(itemPrefab);
		local item = UICostumeItem.New();
		item:InitCtrl(instObj.transform);
		item:InitData(costumeList[i]);
		
		local itemBtn = UIUtils.GetButtonListener(item.mBtn_TemplateUnchosen.gameObject);
		itemBtn.onClick = self.OnCostumeItemClicked;
		itemBtn.param = item;
		
		UIUtils.AddListItem(instObj,self.mView.mTrans_CustomDetailPanel_CostumeList.transform);
		self.mCustomCostumeItems[i+1] = item;
		
		if(defaultId == costumeList[i].id) then
			self.mCurCostumeItem = item;
		end
	end
	
	self.mCurCostumeItem:SetSelect(true);
end

function UICommanderCustomMadePanel.ClearCustomCostumeItems()
	self = UICommanderCustomMadePanel;
	
	for i = 1,#self.mCustomCostumeItems,1 do
		self.mCustomCostumeItems[i]:DestroySelf();
	end
	
	self.mCustomCostumeItems = {};
end

function UICommanderCustomMadePanel.OnCostumeItemClicked(gameObj)
	self = UICommanderCustomMadePanel;
	
	local eventTrigger = getcomponent(gameObj, typeof(CS.ButtonEventTriggerListener));
	if eventTrigger ~= nil then
		self.mCurCostumeItem:SetSelect(false);
		self.mCurCostumeItem = eventTrigger.param;
		self.mCurCostumeItem:SetSelect(true);
		
		local id = self.mFakeBodyIds[self.mCurTempItem.mData.id];
		CS.CommanderModManager.Instance:ChangeCostume(id,self.mCurCostumeItem.mData.id);
	end
end

------------------------------------------------------------------------------

function UICommanderCustomMadePanel.OnReturnClick(gameObj)	
    self = UICommanderCustomMadePanel;	
	
	if(self.mStep == 1) then
		self.OnPrevStepClicked(nil);
	else
		self.Close();
		SceneSys:ReturnMain();
	end
end

function UICommanderCustomMadePanel.OnRelease()
    self = UICommanderCustomMadePanel;
	
	self.mIsInit = true;
	self.mCurTemplateId = 1;
	self.mStep = 0;
	self.mCurTempItem = nil;
	self.mTemplateItems = {};
	self.mCustomHairStyleItems = {};
	self.mCustomEyeTypeItems = {};
	self.mCustomTattooItems = {};
	self.mCustomCostumeItems = {};
	self.mCurDecoItems = {};
	self.mHairColorData = nil;
	self.mEyeColorData = nil;
end