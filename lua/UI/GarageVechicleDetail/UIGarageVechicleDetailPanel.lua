---
--- Created by Administrator.
--- DateTime: 18/9/8 16:50
---
require("UI.UIBasePanel")
require("UI.UIManager")
require("UI.UITweenCamera")
require("UI.GarageVechicleDetail.UIGaragePreviewPartItem")
require("UI.GarageVechicleDetail.UIPartListElementItem")
require("UI.GarageVechicleDetail.UIPropertyCompareItem")
require("UI.GarageVechicleDetail.UIPrefixTypeItem")

UIGarageVechicleDetailPanel = class("UIGarageVechicleDetailPanel", UIBasePanel);
UIGarageVechicleDetailPanel.__index = UIGarageVechicleDetailPanel;

---路径
UIGarageVechicleDetailPanel.mPath_PreviewPartItem = "Garage/UIGaragePreviewPartItem.prefab"
UIGarageVechicleDetailPanel.mPath_PartListItem = "Garage/UIPartListElementItem.prefab"
UIGarageVechicleDetailPanel.mPath_PartPropItem = "Garage/UIPropertyCompareItem.prefab"
UIGarageVechicleDetailPanel.mPath_PrefixItem = "Garage/UIPrefixTypeItem.prefab"

---变量


UIGarageVechicleDetailPanel.mView = nil;

UIGarageVechicleDetailPanel.PanelType = gfenum({"Preview", "PowerUp", "Starup", "Reform", "Adjustment" },0)
UIGarageVechicleDetailPanel.PanelElem = gfenum({"Tab", "PanelObj", "SetFunc" },0)
UIGarageVechicleDetailPanel.mCurPanelIndex = 0;

UIGarageVechicleDetailPanel.mCurCarrier = nil;
UIGarageVechicleDetailPanel.mCurCarrierStc = nil;
UIGarageVechicleDetailPanel.mCurCarrierPrefixStc = nil;
UIGarageVechicleDetailPanel.mCurCarrierLevelBaseProperty = nil;
UIGarageVechicleDetailPanel.mCurCarrierLevelProperty = nil;
UIGarageVechicleDetailPanel.mCurCarrierStarPropertys = nil;
UIGarageVechicleDetailPanel.mCurCarrierReformPropertys = nil;


UIGarageVechicleDetailPanel.mStarUpStarList=nil;
UIGarageVechicleDetailPanel.mPreviewStarList=nil;


--底部按钮图片
UIGarageVechicleDetailPanel.mBottomImages = nil;
--子界面，对应每一个底部按钮
UIGarageVechicleDetailPanel.mSubPanels = nil;

UIGarageVechicleDetailPanel.mPowerupMaxVars = nil;
UIGarageVechicleDetailPanel.mPowerupBearingChildNum = 12;

UIGarageVechicleDetailPanel.mReformRequireLvVars = nil;
UIGarageVechicleDetailPanel.mReformRequireStarVars = nil;
UIGarageVechicleDetailPanel.mReformComponentsVars = nil;
UIGarageVechicleDetailPanel.mReformPropertyVars = nil;
UIGarageVechicleDetailPanel.mReformNum = 5;
UIGarageVechicleDetailPanel.mReformTypeNum = 4;
UIGarageVechicleDetailPanel.mCurSelReform = 0;
UIGarageVechicleDetailPanel.mCurSelReformDoneData = nil;
UIGarageVechicleDetailPanel.mCurSelReformType = 0;
UIGarageVechicleDetailPanel.mCurSelReformTypeProperty = nil;
UIGarageVechicleDetailPanel.ReformElem = gfenum({"Btn", "DoneImg", "SelImg", "LineImg", "Data" },0)
--reform按钮
UIGarageVechicleDetailPanel.mReformElems = nil;
UIGarageVechicleDetailPanel.ReformType = gfenum({"Btn", "DoneImg", "SelImg", "Icon", "Name", "Desc", "Data" },0)
--reform类型按钮
UIGarageVechicleDetailPanel.mReformTypeBtns = nil;

UIGarageVechicleDetailPanel.mDetailCameraNodePath = "Virtual Cameras/Position_2";
UIGarageVechicleDetailPanel.mPrevReform = nil;

--PartsView
UIGarageVechicleDetailPanel.mPartsViewBtn = nil;
UIGarageVechicleDetailPanel.mPartsPreviewItemList = nil
UIGarageVechicleDetailPanel.mPartsViewItemList = nil
UIGarageVechicleDetailPanel.mPartsList = nil    ---零件物体列表
UIGarageVechicleDetailPanel.mPartPropList = nil
UIGarageVechicleDetailPanel.mReplacePartPropList = nil
UIGarageVechicleDetailPanel.mLastClickedPart = nil
UIGarageVechicleDetailPanel.mCurPartType = nil
UIGarageVechicleDetailPanel.mCurPartsList = nil
UIGarageVechicleDetailPanel.mCurChoosedPart = nil
UIGarageVechicleDetailPanel.mCurEquipedPart = nil
UIGarageVechicleDetailPanel.mPrefixItemList = nil
UIGarageVechicleDetailPanel.mTempPrefixData = nil


function UIGarageVechicleDetailPanel:ctor()
    UIGarageVechicleDetailPanel.super.ctor(self);
end

function UIGarageVechicleDetailPanel.Open()
    UIGarageVechicleDetailPanel.OpenUI(UIDef.UIGarageVechicleDetailPanel);
end

function UIGarageVechicleDetailPanel.Close()
    self=UIGarageVechicleDetailPanel;
    UIGarageVechicleDetailPanel.CloseUI(UIDef.UIGarageVechicleDetailPanel);
    CS.GF2.Message.MessageSys.Instance:RemoveListener(9004,self.UpdateStartUpInfoView);
end

function UIGarageVechicleDetailPanel.Init(root, data)

    UIGarageVechicleDetailPanel.super.SetRoot(UIGarageVechicleDetailPanel, root);

    self = UIGarageVechicleDetailPanel;

    CS.GF2.Message.MessageSys.Instance:AddListener(9004,self.UpdateStartUpInfoView);
    self.mView = UIGarageVechicleDetailView;
    self.mView:InitCtrl(root);
end

function UIGarageVechicleDetailPanel.InitPowerup()

    UIUtils.GetListener(self.mView.mBtn_PowerUp_PowerUpConfirmButton.gameObject).onClick = self.CarrierPowerupBtnClick;

end

function UIGarageVechicleDetailPanel:InitReform()

    self:InitReformVas();

    UIUtils.GetListener(self.mView.mBtn_Reform_CostComfirm_BottonComfirm.gameObject).onClick = self.ReformConfirmBtnClick;

    self.mReformElems = List:New("ReformElems");
    self.mReformElems:Add({self.mView.mBtn_Reform_ReformLevelLayout_ButtonI,
                          self.mView.mImage_Reform_ReformLevelLayout_ButtonI_ReformDone,
                          self.mView.mImage_Reform_ReformLevelLayout_ButtonI_Selected,
                          self.mView.mImage_Reform_ReformLevelLayout_LineI_LineDone});
    self.mReformElems:Add({self.mView.mBtn_Reform_ReformLevelLayout_ButtonII,
                          self.mView.mImage_Reform_ReformLevelLayout_ButtonII_ReformDone,
                          self.mView.mImage_Reform_ReformLevelLayout_ButtonII_Selected,
                          self.mView.mImage_Reform_ReformLevelLayout_LineII_LineDone});
    self.mReformElems:Add({self.mView.mBtn_Reform_ReformLevelLayout_ButtonIII,
                          self.mView.mImage_Reform_ReformLevelLayout_ButtonIII_ReformDone,
                          self.mView.mImage_Reform_ReformLevelLayout_ButtonIII_Selected,
                          self.mView.mImage_Reform_ReformLevelLayout_LineIII_LineDone});
    self.mReformElems:Add({self.mView.mBtn_Reform_ReformLevelLayout_ButtonIV,
                          self.mView.mImage_Reform_ReformLevelLayout_ButtonIV_ReformDone,
                          self.mView.mImage_Reform_ReformLevelLayout_ButtonIV_Selected,
                          self.mView.mImage_Reform_ReformLevelLayout_LineVI_LineDone});
    self.mReformElems:Add({self.mView.mBtn_Reform_ReformLevelLayout_ButtonV,
                          self.mView.mImage_Reform_ReformLevelLayout_ButtonV_ReformDone,
                          self.mView.mImage_Reform_ReformLevelLayout_ButtonV_Selected,
                          nil });
    for i = 1, self.mReformElems:Count() do
        UIUtils.GetListener(self.mReformElems[i][self.ReformElem.Btn].gameObject).onClick = self.ReformBtnClick;
    end

    self.mReformTypeBtns = List:New("ReformTypeBtns");
    self.mReformTypeBtns:Add({self.mView.mTrans_Reform_ReformOptions_Type1,
                              self.mView.mImage_Reform_ReformOptions_Type1_OldFrame,
                              self.mView.mImage_Reform_ReformOptions_Type1_SelectedFrame,
                              self.mView.mImage_Reform_ReformOptions_Type1_ReformIcon,
                              self.mView.mText_Reform_ReformOptions_Type1_ReformName,
                              self.mView.mText_Reform_ReformOptions_Type1_ReformDescription,
                              TableData.GetCarrierReformData(self.mReformPropertyVars[0])});
    self.mReformTypeBtns:Add({self.mView.mTrans_Reform_ReformOptions_Type2,
                              self.mView.mImage_Reform_ReformOptions_Type2_OldFrame,
                              self.mView.mImage_Reform_ReformOptions_Type2_SelectedFrame,
                              self.mView.mImage_Reform_ReformOptions_Type2_ReformIcon,
                              self.mView.mText_Reform_ReformOptions_Type2_ReformName,
                              self.mView.mText_Reform_ReformOptions_Type2_ReformDescription,
                              TableData.GetCarrierReformData(self.mReformPropertyVars[1])});
    self.mReformTypeBtns:Add({self.mView.mTrans_Reform_ReformOptions_Type3,
                              self.mView.mImage_Reform_ReformOptions_Type3_OldFrame,
                              self.mView.mImage_Reform_ReformOptions_Type3_SelectedFrame,
                              self.mView.mImage_Reform_ReformOptions_Type3_ReformIcon,
                              self.mView.mText_Reform_ReformOptions_Type3_ReformName,
                              self.mView.mText_Reform_ReformOptions_Type3_ReformDescription,
                              TableData.GetCarrierReformData(self.mReformPropertyVars[2])});
    self.mReformTypeBtns:Add({self.mView.mTrans_Reform_ReformOptions_Type4,
                              self.mView.mImage_Reform_ReformOptions_Type4_OldFrame,
                              self.mView.mImage_Reform_ReformOptions_Type4_SelectedFrame,
                              self.mView.mImage_Reform_ReformOptions_Type4_ReformIcon,
                              self.mView.mText_Reform_ReformOptions_Type4_ReformName,
                              self.mView.mText_Reform_ReformOptions_Type4_ReformDescription,
                              TableData.GetCarrierReformData(self.mReformPropertyVars[3])});

    for i = 1, self.mReformTypeBtns:Count() do
        UIUtils.GetListener(self.mReformTypeBtns[i][self.ReformType.Btn].gameObject).onClick = self.ReformTypeBtnClick;
    end
end

function UIGarageVechicleDetailPanel.OnInit()
    self = UIGarageVechicleDetailPanel;

    if self.mCurCarrier == nil then
        self:SetCurCarrier(CarrierNetCmdHandler:GetCarrier(0));
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Adjustment_AdjOptionAdvanced_SwitchToBasicBtn.gameObject).onClick = self.OnBaseBtnClicked;
    UIUtils.GetButtonListener(self.mView.mBtn_Adjustment_AdjOptionBasic_SwitchToAdvanced.gameObject).onClick = self.OnAdvancedBtnClicked;
    UIUtils.GetButtonListener(self.mView.mBtn_BackToListBtn.gameObject).onClick = self.BackToListBtnClick;
    UIUtils.GetButtonListener(self.mView.mBtn_Starup_SelectCarrierBtn.gameObject).onClick = self.SelectCarrierBtnClick;
    UIUtils.GetButtonListener(self.mView.mBtn_Starup_ButtonComfirm.gameObject).onClick = self.StarUpConfirmBtnClick;
    UIUtils.GetButtonListener(self.mView.mBtn_Preview_ButtonPartSlotsPanel.gameObject).onClick = self.OnPartPreviewButtonClicked;
    UIUtils.GetButtonListener(self.mView.mBtn_PartsView_ButtonExit.gameObject).onClick =  self.OnPartPreviewExitBtnClicked;
    UIUtils.GetButtonListener(self.mView.mBtn_PartsList_ButtonExit.gameObject).onClick = self.OnPartsListExitBtnClicked;
    UIUtils.GetButtonListener(self.mView.mBtn_PartsList_ComfirmBtn.gameObject).onClick= self.OnPartChangeConfirmBtnClicked;
    UIUtils.GetButtonListener(self.mView.mBtn_PartsList_RemovePart.gameObject).onClick = self.OnPartsListRemoveBtnClicked;
    UIUtils.GetButtonListener(self.mView.mBtn_Adjustment_AdjOptionAdvanced_CurPrefixNameBarButton.gameObject).onClick = self.OnAdvancedPrefixClicked;
    UIUtils.GetButtonListener(self.mView.mBtn_Adjustment_AdjOptionAdvanced_ConfirmButton.gameObject).onClick = self.OnAdvancedConfirmed;
    UIUtils.GetButtonListener(self.mView.mBtn_Adjustment_AdjOptionBasic_ConfirmButton.gameObject).onClick = self.OnBaseConfirmed;
    --CS.GF2.Message.MessageSys.Instance:AddListener(9004,self.UpdateStartUpInfoView);




    self.mStarUpStarList= List:New();
    self.mPreviewStarList=List:New();


    self.mSubPanels = List:New("SubPanels");
    self.mSubPanels:Add({self.mView.mImage_ButtomPageSwitch_Preview, self.mView.mTrans_Preview, self.SetPreviewInfo});
    self.mSubPanels:Add({self.mView.mImage_ButtomPageSwitch_PowerUp, self.mView.mTrans_PowerUp, self.SetPowerUpInfo});
    self.mSubPanels:Add({self.mView.mImage_ButtomPageSwitch_Starup, self.mView.mTrans_Starup, self.SetStarUpInfo});
    self.mSubPanels:Add({self.mView.mImage_ButtomPageSwitch_Reform, self.mView.mTrans_Reform, self.SetReformInfo});
    self.mSubPanels:Add({self.mView.mImage_ButtomPageSwitch_Adjustment, self.mView.mTrans_Adjustment, self.SetAdjustmentInfo});
    for i = 1, self.mSubPanels:Count() do
        UIUtils.GetListener(self.mSubPanels[i][self.PanelElem.Tab].gameObject).onClick = self.BottomBtnClick;
    end

    self:InitPowerup();
    self:InitReform();
end

function UIGarageVechicleDetailPanel.OnShow()
    self = UIGarageVechicleDetailPanel;
	
	self:TweenCamera();
	
    if self.mCurPanelIndex > 0 then
        self.mSubPanels[self.mCurPanelIndex][self.PanelElem.SetFunc]();
    else
        self:OpenSubPanel(self.PanelType.Preview);
    end
end

function UIGarageVechicleDetailPanel.OnRelease()

    self = UIGarageVechicleDetailPanel;

    self.mSubPanels = nil;
    self.mCurPanelIndex = 0;
    self.mCurCarrier = nil;
    self.mCurSelReform = 0;
    self.mCurSelReformType = 0;
    self.mPartsPreviewItemList = nil
    self.mPartsViewItemList = nil
    self.mPartsList = nil
    self.mPartPropList = nil
    self.mReplacePartPropList = nil
    self.mLastClickedPart = nil
    self.mCurPartType = nil
    self.mCurPartsList = nil
    self.mCurChoosedPart = nil
    self.mCurEquipedPart = nil
    self.mPrefixItemList = nil
    self.mTempPrefixData = nil
end

function UIGarageVechicleDetailPanel:SetCurCarrier(carrier)

    if carrier == nil then
        gferror("载具培养界面设置了空的载具数据！");
        return;
    end

    self.mCurCarrier = carrier;
    self.mCurCarrierStc = TableData.GetCarrierBaseBodyData(carrier.stc_carrier_id);
    self.mCurCarrierPrefixStc = TableData.GetCarrierPrefixData(carrier.prefix);
    --强化基础属性
    local propData = TableData.GetCarrierPropertyData(self.mCurCarrierStc.property_id);
    self.mCurCarrierLevelBaseProperty = TableData.GetCarrierBasePropertyData(propData.data_start_id + carrier.level);
    --强化属性
    self.mCurCarrierLevelProperty = TableData.GetCarrierPropertyData(self.mCurCarrierStc.property_id);
    --升星属性
    if self.mCurCarrierStarPropertys == nil then
        self.mCurCarrierStarPropertys = List:New("StarPropertys");
    else
        self.mCurCarrierStarPropertys:Clear();
    end

    local starProperty = TableData.GetCarrierStarupProperty(self.mCurCarrier.star)

    if starProperty~=nil then
        self.mCurCarrierStarPropertys:Add(starProperty)
    end
    --改造属性
    if self.mCurCarrierReformPropertys == nil then
        self.mCurCarrierReformPropertys = List:New("ReformPropertys");
    else
        self.mCurCarrierReformPropertys:Clear();
    end
    local reforms = self.mCurCarrier.reform;
    for i = 1, reforms.Length do
        if reforms[i - 1] ~= 0 then
            local reformData =TableData.GetCarrierReformData(reforms[i - 1]);
            self.mCurCarrierReformPropertys:Add(TableData.GetCarrierPropertyData(reformData.property));
        end
    end
    UIGarageVechicleDetailPanel.mCurSelReform = self.mCurCarrier.reform.Length+1
	
	CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList:Clear();
end

function UIGarageVechicleDetailPanel:_GetLevelRealProperty(levelBaseProp, propno)
    if levelBaseProp ~= nil and self.mCurCarrierLevelProperty ~= nil then
        return self.mCurCarrierLevelProperty:GetRealProp(levelBaseProp, propno);
    end
    return 0;
end

function UIGarageVechicleDetailPanel:_GetStarupRealProperty(starupProp, propno)
    if starupProp ~= nil then
        return starupProp:GetRealProp(propno);
    end
    return 0;
end

function UIGarageVechicleDetailPanel:_GetReformRealProperty(reformProp, index, propno)
    local prop = 0;

    for i = 1, self.mCurCarrierReformPropertys:Count() do
        --替换已有reform
        if index == i then
            if reformProp ~= nil then
                prop = prop + reformProp:GetRealProp(propno);
            end
        else
            local curProperty = self.mCurCarrierReformPropertys[i];
            if curProperty ~= nil then
                prop = prop + curProperty:GetRealProp(propno);
            end
        end
    end

    --新的reform
    if index > self.mCurCarrierReformPropertys:Count() and reformProp ~= nil then
        prop = prop + reformProp:GetRealProp(propno);
    end

    return prop;
end

function UIGarageVechicleDetailPanel:GetAdjustmentProp(value, propno)
    if self.mCurCarrierPrefixStc ~= nil then
        value = value * self.mCurCarrierPrefixStc:GetPropPrefix(propno, self.mCurCarrier.adjustment);
    end

    return GFMath.FloorToInt(value);
end


function UIGarageVechicleDetailPanel:GetPowerupRealProperty(levelBaseProp, propno)
    local value = self:_GetLevelRealProperty(levelBaseProp, propno);
    for i = 1, self.mCurCarrierStarPropertys:Count() do
        value = value + self:_GetStarupRealProperty(self.mCurCarrierStarPropertys[i], propno);
    end
    value = value + self:_GetReformRealProperty(nil, 0, propno);
    return self:GetAdjustmentProp(value, propno);
end

function UIGarageVechicleDetailPanel:GetReformRealProperty(reformProp, index, propno)
    local value = self:_GetLevelRealProperty(self.mCurCarrierLevelBaseProperty, propno);
    for i = 1, self.mCurCarrierStarPropertys:Count() do
        value = value + self:_GetStarupRealProperty(self.mCurCarrierStarPropertys[i], propno);
    end
    value = value + self:_GetReformRealProperty(reformProp, index, propno);
    return self:GetAdjustmentProp(value, propno);
end

--设置载具预览界面
function UIGarageVechicleDetailPanel.SetPreviewInfo()

    self = UIGarageVechicleDetailPanel;

    self.mCurCarrier = CarrierNetCmdHandler:GetCarrierByID(self.mCurCarrier.id);
    self.mCurCarrierStc = TableData.GetCarrierBaseBodyData(self.mCurCarrier.stc_carrier_id);

    if self.mCurCarrier == nil or self.mCurCarrierStc == nil then
        gferror("当前载具为空，无法设置概览信息！");
        return;
    end

    --gfdebug(self.mCurCarrierStc.name);

    --载具名称
    self.mView.mText_Preview_Name.text = self.mCurCarrierStc.name;
    --载具类型
    self.mView.mText_Preview_Prefix.text=TableData.listCarrierPrefixDatas:GetDataById(self.mCurCarrier.prefix).name;

    --等级
    self.mView.mText_Preview_LevelText.text=self.mCurCarrier.level;


    --当前星数
    for i = 1, self.mPreviewStarList:Count() do
        setactive(self.mPreviewStarList[i],false)
    end


    for i = 1, self.mCurCarrier.star do
        if i<=self.mPreviewStarList:Count() then
            setactive(self.mPreviewStarList[i],true)
        else
            local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/StarA.prefab",self));
            setparent(self.mView.mTrans_Preview_Stars  ,obj.transform);
            obj.transform.localScale=vectorone;
            self.mPreviewStarList:Add(obj);
        end
    end


    --稀有度
    self.mView.mImage_Preview_Rank.sprite=IconUtils.GetRaritySprite("Rarity_"..self.mCurCarrierStc.rank);


    --HP
    self.mView.mText_Preview_HPText.text=self.mCurCarrier.hp;
    self.mView.mImage_Preview_HP.fillAmount=self.mCurCarrier.hp/self.mCurCarrier.prop.max_hp;

    --改造
    self.mView.mText_Preview_ReformText.text=self.mCurCarrier.reform.Length;
    self.mView.mImage_Preview_Reform.fillAmount=self.mCurCarrier.reform.Length/5;


    --移动力
    self.mView.mText_Preview_Speed.text=self.mCurCarrier.prop.max_speed;

    --油耗
    self.mView.mText_Preview_Param.text=self.mCurCarrier.prop.fuel_param;

    --载重

    local curLoad = CarrierTrainNetCmdHandler:GetCarrierCurrentLoad(self.mCurCarrier.id);
    self.mView.mText_Preview_Bearin.text=curLoad.."<color=white>/"..self.mCurCarrier.prop.max_bearing.."</color>";

    --属性
    self.mView.mText_Preview_Pow.text=self.mCurCarrier.prop.pow;
    self.mView.mText_Preview_Taunt.text=self.mCurCarrier.prop.taunt;
    self.mView.mText_Preview_Pierce.text=self.mCurCarrier.prop.pierce;
    self.mView.mText_Preview_Armor.text=self.mCurCarrier.prop.armor;
    self.mView.mText_Preview_Expertise.text=self.mCurCarrier.prop.expertise;
    self.mView.mText_Preview_Flexible.text=self.mCurCarrier.prop.flexible;
    self.mView.mText_Preview_Crit.text=self.mCurCarrier.prop.crit;
    self.mView.mText_Preview_Tough.text=self.mCurCarrier.prop.tough;

    --零件
    self.UpdatePreviewPartsSlot()

end

function UIGarageVechicleDetailPanel.GetPropertyPercent(var, index)

    self = UIGarageVechicleDetailPanel;

    if self.mPowerupMaxVars == nil then
        self.mPowerupMaxVars = TableData.GetGlobalCFGIntsVal(GCFGConst.carrier_ui_property_max_value);
    end

    return var / self.mPowerupMaxVars[index];
end

function UIGarageVechicleDetailPanel:ShowPowerupAddons(show)
    setactive(self.mView.mText_PowerUp_NextLevel, show);

    setactive(self.mView.mText_PowerUp_HP_PropertyAddOn, show);
    setactive(self.mView.mText_PowerUp_HP_Plus, show);
    setactive(self.mView.mImage_PowerUp_HP_AttackNewFill, show);

    setactive(self.mView.mText_PowerUp_Armor_PropertyAddOn, show);
    setactive(self.mView.mImage_PowerUp_Armor_AttackNewFill, show);
    setactive(self.mView.mText_PowerUp_Armor_Plus, show);

    setactive(self.mView.mText_PowerUp_Pow_PropertyAddOn, show);
    setactive(self.mView.mText_PowerUp_Pow_Plus, show);
    setactive(self.mView.mImage_PowerUp_Pow_AttackNewFill, show);

    setactive(self.mView.mText_PowerUp_Pierce_PropertyAddOn, show);
    setactive(self.mView.mText_PowerUp_Pierce_Plus, show);
    setactive(self.mView.mImage_PowerUp_Pierce_AttackNewFill, show);

    setactive(self.mView.mText_PowerUp_Exp_PropertyAddOn, show);
    setactive(self.mView.mText_PowerUp_Exp_Plus, show);
    setactive(self.mView.mImage_PowerUp_Exp_AttackNewFill, show);

    setactive(self.mView.mText_PowerUp_Crit_PropertyAddOn, show);
    setactive(self.mView.mText_PowerUp_Crit_Plus, show);
    setactive(self.mView.mImage_PowerUp_Crit_AttackNewFill, show);

    setactive(self.mView.mText_PowerUp_Flex_PropertyAddOn, show);
    setactive(self.mView.mText_PowerUp_Flex_Plus, show);
    setactive(self.mView.mImage_PowerUp_Flex_AttackNewFill, show);

    setactive(self.mView.mText_PowerUp_Taunt_PropertyAddOn, show);
    setactive(self.mView.mText_PowerUp_Taunt_Plus, show);
    setactive(self.mView.mImage_PowerUp_Taunt_AttackNewFill, show);

    setactive(self.mView.mText_PowerUp_Tough_PropertyAddOn, show);
    setactive(self.mView.mText_PowerUp_Tough_Plus, show);
    setactive(self.mView.mImage_PowerUp_Tough_AttackNewFill, show);

    setactive(self.mView.mText_PowerUp_Bearing_PropertyAddOn, show);
    setactive(self.mView.mText_PowerUp_Bearing_Plus, show);
end

function UIGarageVechicleDetailPanel:SetBearingAmount(activeNum)

    local maxNum = self.mPowerupBearingChildNum;
    for i = 1, maxNum do
        setchildactive(self.mView.mImage_PowerUp_Bearing_AmountFill, i - 1, activeNum >= i);
    end
end

function UIGarageVechicleDetailPanel:SetBearingAmountAddon(add)

    local maxNum = self.mPowerupBearingChildNum;
    setchildactive(self.mView.mImage_PowerUp_Bearing_AmountFill, maxNum, add);

end

function UIGarageVechicleDetailPanel.SetPowerUpInfo()
    self = UIGarageVechicleDetailPanel;

    if self.mCurCarrier == nil or self.mCurCarrierStc == nil then
        gferror("当前载具为空，无法设置强化信息！");
        return;
    end

    local nextlevel = self.mCurCarrier.level + 1;
    local propData = TableData.GetCarrierPropertyData(self.mCurCarrierStc.property_id);
    local propBaseData = TableData.GetCarrierBasePropertyData(propData.data_start_id + nextlevel);

    --头部信息
    self.mView.mText_PowerUp_PowerUpCarrierName.text = self.mCurCarrierStc.name;
    self.mView.mText_PowerUp_PowerUpCarrierPrefix.text = self.mCurCarrierPrefixStc.name;
    self.mView.mText_PowerUp_PowerUpCarrierPower.text = self.mCurCarrier.prop.pow;
    self.mView.mText_PowerUp_CurrentLevel.text = self.mCurCarrier.level;
    self.mView.mText_PowerUp_NextLevel.text = nextlevel;

    --当前数值
    self.mView.mText_PowerUp_HP_PropertyCurrent.text = self.mCurCarrier.prop.max_hp;
    self.mView.mImage_PowerUp_HP_AttackOriginFill.fillAmount = self.GetPropertyPercent(self.mCurCarrier.prop.max_hp, CarrierPropNo.max_hp);
    self.mView.mText_PowerUp_Armor_PropertyCurrent.text = self.mCurCarrier.prop.armor;
    self.mView.mImage_PowerUp_Armor_AttackOriginFill.fillAmount = self.GetPropertyPercent(self.mCurCarrier.prop.armor, CarrierPropNo.armor);
    self.mView.mText_PowerUp_Pow_PropertyCurrent.text = self.mCurCarrier.prop.pow;
    self.mView.mImage_PowerUp_Pow_AttackOriginFill.fillAmount = self.GetPropertyPercent(self.mCurCarrier.prop.pow, CarrierPropNo.pow);
    self.mView.mText_PowerUp_Pierce_PropertyCurrent.text = self.mCurCarrier.prop.pierce;
    self.mView.mImage_PowerUp_Pierce_AttackOriginFill.fillAmount = self.GetPropertyPercent(self.mCurCarrier.prop.pierce, CarrierPropNo.pierce);
    self.mView.mText_PowerUp_Exp_PropertyCurrent.text = self.mCurCarrier.prop.expertise;
    self.mView.mImage_PowerUp_Exp_AttackOriginFill.fillAmount = self.GetPropertyPercent(self.mCurCarrier.prop.expertise, CarrierPropNo.expertise);
    self.mView.mText_PowerUp_Crit_PropertyCurrent.text = self.mCurCarrier.prop.crit;
    self.mView.mImage_PowerUp_Crit_AttackOriginFill.fillAmount = self.GetPropertyPercent(self.mCurCarrier.prop.crit, CarrierPropNo.crit);
    self.mView.mText_PowerUp_Flex_PropertyCurrent.text = self.mCurCarrier.prop.flexible;
    self.mView.mImage_PowerUp_Flex_AttackOriginFill.fillAmount = self.GetPropertyPercent(self.mCurCarrier.prop.flexible, CarrierPropNo.flexible);
    self.mView.mText_PowerUp_Taunt_PropertyCurrent.text = self.mCurCarrier.prop.taunt;
    self.mView.mImage_PowerUp_Taunt_AttackOriginFill.fillAmount = self.GetPropertyPercent(self.mCurCarrier.prop.taunt, CarrierPropNo.taunt);
    self.mView.mText_PowerUp_Tough_PropertyCurrent.text = self.mCurCarrier.prop.tough;
    self.mView.mImage_PowerUp_Tough_AttackOriginFill.fillAmount = self.GetPropertyPercent(self.mCurCarrier.prop.tough, CarrierPropNo.tough);
    self.mView.mText_PowerUp_Bearing_PropertyCurrent.text = self.mCurCarrier.prop.max_bearing;
    self:SetBearingAmount(self.mCurCarrier.prop.max_bearing);

    self.mView.mImage_PowerUp_PowerUpCarrierRank.sprite = IconUtils.GetRaritySprite("Rarity_"..self.mCurCarrierStc.rank);

    print(self.mCurCarrier.id);

    --升级加成
    if propBaseData ~= nil then

        local starupProp = self.mCurCarrierStarProperty;
        local addon = self:GetPowerupRealProperty(propBaseData, CarrierPropNo.max_hp);
        self.mView.mText_PowerUp_HP_PropertyAddOn.text = addon - self.mCurCarrier.prop.max_hp;
        self.mView.mImage_PowerUp_HP_AttackNewFill.fillAmount = self.GetPropertyPercent(addon, CarrierPropNo.max_hp);
        addon = self:GetPowerupRealProperty(propBaseData, CarrierPropNo.armor);
        self.mView.mText_PowerUp_Armor_PropertyAddOn.text = addon - self.mCurCarrier.prop.armor;
        self.mView.mImage_PowerUp_Armor_AttackNewFill.fillAmount = self.GetPropertyPercent(addon, CarrierPropNo.armor);
        addon = self:GetPowerupRealProperty(propBaseData, CarrierPropNo.pow);
        self.mView.mText_PowerUp_Pow_PropertyAddOn.text = addon - self.mCurCarrier.prop.pow;
        self.mView.mImage_PowerUp_Pow_AttackNewFill.fillAmount = self.GetPropertyPercent(addon, CarrierPropNo.pow);
        addon = self:GetPowerupRealProperty(propBaseData, CarrierPropNo.pierce);
        self.mView.mText_PowerUp_Pierce_PropertyAddOn.text = addon - self.mCurCarrier.prop.pierce;
        self.mView.mImage_PowerUp_Pierce_AttackNewFill.fillAmount = self.GetPropertyPercent(addon, CarrierPropNo.pierce);
        addon = self:GetPowerupRealProperty(propBaseData, CarrierPropNo.expertise);
        self.mView.mText_PowerUp_Exp_PropertyAddOn.text = addon - self.mCurCarrier.prop.expertise;
        self.mView.mImage_PowerUp_Exp_AttackNewFill.fillAmount = self.GetPropertyPercent(addon, CarrierPropNo.expertise);
        addon = self:GetPowerupRealProperty(propBaseData, CarrierPropNo.crit);
        self.mView.mText_PowerUp_Crit_PropertyAddOn.text = addon - self.mCurCarrier.prop.crit;
        self.mView.mImage_PowerUp_Crit_AttackNewFill.fillAmount = self.GetPropertyPercent(addon, CarrierPropNo.crit);
        addon = self:GetPowerupRealProperty(propBaseData, CarrierPropNo.flexible);
        self.mView.mText_PowerUp_Flex_PropertyAddOn.text = addon - self.mCurCarrier.prop.flexible;
        self.mView.mImage_PowerUp_Flex_AttackNewFill.fillAmount = self.GetPropertyPercent(addon, CarrierPropNo.flexible);
        addon = self:GetPowerupRealProperty(propBaseData, CarrierPropNo.taunt);
        self.mView.mText_PowerUp_Taunt_PropertyAddOn.text = addon - self.mCurCarrier.prop.taunt;
        self.mView.mImage_PowerUp_Taunt_AttackNewFill.fillAmount = self.GetPropertyPercent(addon, CarrierPropNo.taunt);
        addon = self:GetPowerupRealProperty(propBaseData, CarrierPropNo.tough);
        self.mView.mText_PowerUp_Tough_PropertyAddOn.text = addon - self.mCurCarrier.prop.tough;
        self.mView.mImage_PowerUp_Tough_AttackNewFill.fillAmount = self.GetPropertyPercent(addon, CarrierPropNo.tough);
        addon = self:GetPowerupRealProperty(propBaseData, CarrierPropNo.max_bearing);
        self.mView.mText_PowerUp_Bearing_PropertyAddOn.text = addon - self.mCurCarrier.prop.max_bearing;
        self:SetBearingAmountAddon(addon > self.mCurCarrier.prop.max_bearing);
        self:ShowPowerupAddons(true);
    else
        self:SetBearingAmountAddon(false);
        self:ShowPowerupAddons(false);
    end

    --消耗
    local curComponent = NetCmdItemData:GetItemCount(CmdConst.ItemComponent);
    self.mView.mText_PowerUp_Core_Count.text = NetCmdItemData:GetItemCount(CmdConst.ItemCore);
    self.mView.mText_PowerUp_Component_Count.text = curComponent;

    local levelupData = TableData.GetCarrierBodyLevelupData(nextlevel);
    if levelupData~= nil then
        self.mView.mText_PowerUp_PowerUpCostText.text = levelupData.level_components;
        self.mView.mBtn_PowerUp_PowerUpConfirmButton.interactable = curComponent >= levelupData.level_components;
    else
        self.mView.mText_PowerUp_PowerUpCostText.text = "0";
        self.mView.mBtn_PowerUp_PowerUpConfirmButton.interactable = false;
    end
end


function UIGarageVechicleDetailPanel.UpdateStartUpInfoView(msg)
    self = UIGarageVechicleDetailPanel;
    self:SetCurCarrier(CarrierNetCmdHandler:GetCarrierByID(self.mCurCarrier.id));
    self:SetStarUpInfo();
end

----------------------------------零件------------------------------------

---总览中的预览
function UIGarageVechicleDetailPanel.UpdatePreviewPartsSlot()
    self = UIGarageVechicleDetailPanel

    self:SetCurCarrier(CarrierNetCmdHandler:GetCarrierByID(self.mCurCarrier.id));
    local prefab = UIUtils.GetGizmosPrefab(self.mPath_PreviewPartItem,self);

    if self.mPartsPreviewItemList==nil then self.mPartsPreviewItemList = List:New(UIGaragePreviewPartItem)
    end
    local count = self.mPartsPreviewItemList:Count()
    for n=1,count do
        self.mPartsPreviewItemList[n]:Reset()
    end
    --gfwarning(count)
    for i=0,self.mCurCarrier.parts.Length-1 do
        local carrierPart = self.mCurCarrier.parts[i]
        if  count< (i+1) then
            local item = UIGaragePreviewPartItem.New()
            local itemObject = instantiate(prefab)
            UIUtils.AddListItem(itemObject,self.mView.mTrans_Preview_ButtonPartSlotsPanel_PartSlotLayout.transform)
            item:InitCtrl(itemObject.transform)
            item:SetData(carrierPart)
            self.mPartsPreviewItemList:Add(item)
        else
            local item = self.mPartsPreviewItemList[i+1]
            item:SetData(carrierPart)
        end
    end

    self.mView.mImage_Preview_ButtonPartSlotsPanel_BearingBar.fillAmount = CarrierNetCmdHandler:GetCarrierLoadAmount(self.mCurCarrier.id)
    --gfwarning(self.mView.mImage_Preview_ButtonPartSlotsPanel_BearingBar.fillAmount)
end



function UIGarageVechicleDetailPanel.OnPartPreviewButtonClicked()
    self = UIGarageVechicleDetailPanel
    setactive(self.mView.mBtn_BackToListBtn.transform,false)
    setactive(self.mView.mTrans_Preview,false)
    setactive(self.mView.mTrans_ButtomPageSwitch,false)
    setactive(self.mView.mTrans_PartsView,true)
    self.UpdatePartsViewData()
end

function UIGarageVechicleDetailPanel.OnPartPreviewExitBtnClicked()

    self = UIGarageVechicleDetailPanel
    setactive(self.mView.mBtn_BackToListBtn.transform,true)
    setactive(self.mView.mTrans_Preview,true)
    setactive(self.mView.mTrans_ButtomPageSwitch,true)
    setactive(self.mView.mTrans_PartsView,false)
    self:OpenSubPanel(self.PanelType.Preview)
    self.SetPreviewInfo()
end

---
function UIGarageVechicleDetailPanel.UpdatePartsViewData()
    self = UIGarageVechicleDetailPanel
    self.mView.mText_PartsView_CurBearing.text = CarrierNetCmdHandler:GetCarrierCurrentLoad(self.mCurCarrier.id)
    self.mView.mText_PartsView_MaxBearing.text = CarrierNetCmdHandler:GetCarrierByID(self.mCurCarrier.id).prop.max_bearing;
    local data = self.mCurCarrier
    if self.mPartsViewItemList ==nil
    then
        self.mPartsViewItemList = List:New(UIGaragePreviewPartItem)
        for i=1,6 do
        local item = UIPartSlotItem:New()
        local itemTrans =self.mView["mBtn_PartsView_Slot"..i].transform
        item:InitCtrl(itemTrans)
        item:UpdateData(i,data)
        local listener = UIUtils.GetButtonListener(itemTrans.gameObject)
        listener.onClick = self.OnPartsViewSlotBtnClicked
        listener.param = i
        self.mPartsViewItemList:Add(item)
        end
    else
        for i=1,6 do
            self.mPartsViewItemList[i]:UpdateData(i,data)
        end
    end

end

---零件槽被点击
function UIGarageVechicleDetailPanel.OnPartsViewSlotBtnClicked(gameobj)
    self = UIGarageVechicleDetailPanel
    self.mView.mText_PartsList_CurBearing.text = CarrierNetCmdHandler:GetCarrierCurrentLoad(self.mCurCarrier.id)
    self.mView.mText_PartsList_MaxBearing.text = self.mCurCarrier.prop.max_bearing;
    self.mView.mImage_PartsList_BearingBar.fillAmount = CarrierNetCmdHandler:GetCarrierLoadAmount(self.mCurCarrier.id)

    local eventTrigger = getcomponent(gameobj, typeof(CS.ButtonEventTriggerListener));
    local partIndex
    if eventTrigger ~= nil then
        partIndex = eventTrigger.param
    end
    setactive(self.mView.mTrans_PartsView,false)
    setactive(self.mView.mTrans_PartsList,true)

    self.mCurPartType = CarrierNetCmdHandler:GetPartTypeBySlotIndex(partIndex,self.mCurCarrier)
    self.mView.mText_PartsList_FilterType.text = TableData.GetPartDefineTypeData(self.mCurPartType).name

    self.UpdateAllPartsView()

end
---更新该界面所有动态数据
function UIGarageVechicleDetailPanel.UpdateAllPartsView()
    self = UIGarageVechicleDetailPanel
    self.mCurPartsList = CarrierNetCmdHandler:GetPartsListByType(self.mCurPartType)
    self.mCurChoosedPart = nil
    self.mCurEquipedPart = self.GetCurCarrierPart()
    self.UpdatePartsList()
    self.UpdatePartsSelectedAndCompare(nil)
end

function UIGarageVechicleDetailPanel.OnPartsListRemoveBtnClicked()
    self = UIGarageVechicleDetailPanel
    CarrierNetCmdHandler:ReqCarrierPartRemove( self.mCurCarrier.id,self.mCurEquipedPart.id,self.CmdPartRemoveCallback)
end

function UIGarageVechicleDetailPanel.CmdPartRemoveCallback (ret)
    self = UIGarageVechicleDetailPanel;
    if ret == CS.CMDRet.eSuccess then
        gfdebug("零件移除成功");
    else
        gfdebug("零件移除失败");
        MessageBox.Show("Error", "零件移除失败");
    end
    self:SetCurCarrier(CarrierNetCmdHandler:GetCarrierByID(self.mCurCarrier.id));

    self.OnPartsListExitBtnClicked()
end

function UIGarageVechicleDetailPanel.UpdatePartsList()
    local partList = self.mCurPartsList
    if self.mCurEquipedPart~=nil then
        partList:Remove(self.mCurEquipedPart)
        setactive(self.mView.mBtn_PartsList_RemovePart,true)
    else
        setactive(self.mView.mBtn_PartsList_RemovePart,false)
    end

    local prefab = UIUtils.GetGizmosPrefab(self.mPath_PartListItem,self);

    if self.mPartsList==nil then self.mPartsList = List:New(UIPartListElementItem)
    end
    local count = self.mPartsList:Count()
    for n=1,count do
        self.mPartsList[n]:Reset()
    end
    for i=0,partList.Count-1 do
        if i > count-1 then
            local item = UIPartListElementItem.New()
            local itemObject = instantiate(prefab)
            UIUtils.AddListItem(itemObject,self.mView.mTrans_PartsList_PartsListLayout.transform)
            item:InitCtrl(itemObject.transform)
            item:SetData(partList[i],self.mCurCarrier)
            self.mPartsList:Add(item)
            local listener = UIUtils.GetButtonListener(itemObject)
            listener.onClick = self.OnPartsListItemClicked
            listener.param = partList[i]
            listener.paramData = i+1   --表示在partItemList里的index
        else
            local item = self.mPartsList[i+1]
            item:SetData(partList[i],self.mCurCarrier)
            local listener = UIUtils.GetButtonListener(item.mUIRoot.gameObject)
            listener.onClick = self.OnPartsListItemClicked
            listener.param = partList[i]
            listener.paramData = i+1
        end
    end


end



function UIGarageVechicleDetailPanel.GetCurCarrierPartID()
    self = UIGarageVechicleDetailPanel
    for i=0,self.mCurCarrier.parts.Length-1 do
        local partType = CarrierNetCmdHandler:GetCarrierPartStcData(self.mCurCarrier.parts[i]).define_type
        if partType==self.mCurPartType then
            return self.mCurCarrier.parts[i]
        end

    end
    return nil
end

function UIGarageVechicleDetailPanel.GetCurCarrierPart()
    self = UIGarageVechicleDetailPanel
    for i=0,self.mCurCarrier.parts.Length-1 do
        local partType = CarrierNetCmdHandler:GetCarrierPartStcData(self.mCurCarrier.parts[i]).define_type
        if partType==self.mCurPartType then
            return CarrierNetCmdHandler:GetCarrierPart(self.mCurCarrier.parts[i])
        end

    end
    return nil
end


---零件列表零件被点击
function UIGarageVechicleDetailPanel.OnPartsListItemClicked(gameobj)
    self = UIGarageVechicleDetailPanel
    gfwarning("零件点击！")
    local eventTrigger = getcomponent(gameobj, typeof(CS.ButtonEventTriggerListener));
    local part
    local itemIndex
    if eventTrigger ~= nil then
        self.mCurChoosedPart = eventTrigger.param
        itemIndex = eventTrigger.paramData
    end
    self.UpdatePartsSelectedAndCompare(itemIndex)


end

---更新零件选中比较面板
function UIGarageVechicleDetailPanel.UpdatePartsSelectedAndCompare(itemIndex)
    self = UIGarageVechicleDetailPanel
    if self.mReplacePartPropList==nil then self.mReplacePartPropList = List:New(UIPropertyCompareItem)
    end
    if self.mPartPropList==nil then self.mPartPropList = List:New(UIPropertyCompareItem)
    end
    if(self.mLastClickedPart~=nil) then
        self.mLastClickedPart:ActiveSelf(false)
    end
    if itemIndex~=nil then
        self.mPartsList[itemIndex]:ActiveSelf(true)
        self.mLastClickedPart = self.mPartsList[itemIndex]
    end

    --local originalPart = self.GetCurCarrierPartByType(CarrierNetCmdHandler:GetCarrierPartStcData(self.mCurChoosedPart.id).define_type)
    local originalPart = self.GetCurCarrierPart()
    if originalPart==nil then
        setactive(self.mView.mTrans_PartsList_OriginPartPanel_NoneMask,true)
    else
        local partStcData = CarrierNetCmdHandler:GetCarrierPartStcData(originalPart.id)
        setactive(self.mView.mTrans_PartsList_OriginPartPanel_NoneMask,false)
        UIUtils.SetColor(self.mView.mImage_PartsList_OriginPartPanel_PartRankColor,TableData.GetGlobalGun_Quality_Color1(partStcData.rank))
        self.mView.mText_PartsList_OriginPartPanel_PartName.text = partStcData.name
        self.mView.mText_PartsList_OriginPartPanel_PartLevel.text = originalPart.level
        self.mView.mText_PartsList_OriginPartPanel_PartBearing.text = partStcData.bearing
        if self.mPartPropList:Count()==0 then
            --gfwarning("original生成")
            self.InstantiatePartProps(self.mView.mTrans_PartsList_OriginPartPanel_PropertyLayout,self.mPartPropList)
        end
    end
    self.UpdatePartPropList(originalPart,self.mPartPropList)

    if(self.mCurChoosedPart==nil) then
        setactive(self.mView.mTrans_PartsList_ReplacePartPanel_NoneMask,true)
        self.mView.mBtn_PartsList_ComfirmBtn.interactable = false
    else
        setactive(self.mView.mTrans_PartsList_ReplacePartPanel_NoneMask,false)
        self.mView.mBtn_PartsList_ComfirmBtn.interactable = true
        local newPartStcData = CarrierNetCmdHandler:GetCarrierPartStcData(self.mCurChoosedPart.id)
        UIUtils.SetColor(self.mView.mImage_PartsList_ReplacePartPanel_PartRankColor,TableData.GetGlobalGun_Quality_Color1(newPartStcData.rank))
        self.mView.mText_PartsList_ReplacePartPanel_PartLevel.text = self.mCurChoosedPart.level
        self.mView.mText_PartsList_ReplacePartPanel_PartName.text = newPartStcData.name
        self.mView.mText_PartsList_ReplacePartPanel_PartBearing.text = newPartStcData.bearing

        if self.mReplacePartPropList:Count()==0 then
            --gfwarning("Choosed生成")
            self.InstantiatePartProps(self.mView.mTrans_PartsList_ReplacePartPanel_PropertyLayout,self.mReplacePartPropList)
        end
    end

    self.UpdatePartPropList(self.mCurChoosedPart,self.mReplacePartPropList)

    UIUtils.ForceRebuildLayout(self.mView.mTrans_PartsList_ReplacePartPanel_PropertyLayout)


end

function UIGarageVechicleDetailPanel.InstantiatePartProps(trans,partList)
    local prefab = UIUtils.GetGizmosPrefab(self.mPath_PartPropItem,self);

    for i=1,10 do
        local propItem = UIPropertyCompareItem.New()
        local propObject = instantiate(prefab)
        UIUtils.AddListItem(propObject,trans)
        propItem:InitCtrl(propObject.transform)
        propItem:InitData(i)
        partList:Add(propItem)
    end
end

function UIGarageVechicleDetailPanel.UpdatePartPropList(part,list)
    for i=1,list:Count() do
        list[i]:SetData(part)
    end

end

function UIGarageVechicleDetailPanel.OnPartChangeConfirmBtnClicked()
    if(self.mCurEquipedPart~=nil)then
        CarrierNetCmdHandler:ReqCarrierPartAssemble(self.mCurCarrier.id,self.mCurEquipedPart.id, self.mCurChoosedPart.id,self.CmdPartAssembleCallback)
    else
        CarrierNetCmdHandler:ReqCarrierPartAssemble(self.mCurCarrier.id,self.mCurChoosedPart.id,self.CmdPartAssembleCallback)
    end
end

function UIGarageVechicleDetailPanel.CmdPartAssembleCallback (ret)
    self = UIGarageVechicleDetailPanel;
    if ret == CS.CMDRet.eSuccess then
        gfdebug("零件组装成功");
    else
        gfdebug("零件组装失败");
        MessageBox.Show("Error", "零件组装失败");
    end

    self:SetCurCarrier(CarrierNetCmdHandler:GetCarrierByID(self.mCurCarrier.id));

    self.OnPartsListExitBtnClicked()
end


function UIGarageVechicleDetailPanel.OnPartsListExitBtnClicked()
    self = UIGarageVechicleDetailPanel
    setactive(self.mView.mTrans_PartsView,true)
    setactive(self.mView.mTrans_PartsList,false)
    self.UpdatePartsViewData()
end



--升阶界面
function UIGarageVechicleDetailPanel.SetStarUpInfo()

    self = UIGarageVechicleDetailPanel;


    self.mCurCarrier = CarrierNetCmdHandler:GetCarrierByID(self.mCurCarrier.id);
    self.mCurCarrierStc = TableData.GetCarrierBaseBodyData(self.mCurCarrier.stc_carrier_id);

    --gfdebug("当前星数："..self.mCurCarrier.star);

    if self.mCurCarrier == nil or self.mCurCarrierStc == nil then
        gferror("当前载具为空，无法设置升价界面！");
        return;
    end

    --gfdebug(self.mCurCarrierStc.name);


    --当前拥有的核心数
    local coreNum=CS.NetCmdItemData.Instance:GetItemCount(110);
    self.mView.mText_Starup_Core_Count.text=coreNum;

    --稀有度
    self.mView.mImage_Starup_Rank.sprite=IconUtils.GetRaritySprite("Rarity_"..self.mCurCarrierStc.rank);


    --载具名称
    self.mView.mText_Starup_Name.text = self.mCurCarrierStc.name;
    --载具类型
    self.mView.mText_Preview_Prefix.text=TableData.listCarrierPrefixDatas:GetDataById(self.mCurCarrier.prefix).name;


    --升级星阶  比当前星级大一级

    if self.mCurCarrier.star == 5 then
        setactive(self.mView.mTrans_Starup_MaxMask,true);

        for i = 1, self.mCurCarrier.star do
            if i<=self.mStarUpStarList:Count() then
                setactive(self.mStarUpStarList[i],true)
            else
                local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/StarA.prefab",self));
                setparent(self.mView.mTrans_Starup_Stars,obj.transform);
                obj.transform.localScale=vectorone;
                self.mStarUpStarList:Add(obj);
            end
        end
    else
        local SelectedNum=CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList.Count;
        local totalNeedNum=TableData.GetStarUpNeedNumByCurrent(self.mCurCarrier.star);

        self.mView.mText_Starup_SelectedNumSpec.text=SelectedNum;
        self.mView.mText_Starup_NeededNum.text=totalNeedNum;

        for i = 1, 5 do
            if i<=totalNeedNum then
                setactive(self.mView.mImage_Starup_PlaceHolderList[i],true);
                if i <=SelectedNum then
                    setactive(self.mView.mImage_Starup_SelectedList[i],true);
                else
                    setactive(self.mView.mImage_Starup_SelectedList[i],false);
                end
            else
                setactive(self.mView.mImage_Starup_PlaceHolderList[i],false);
            end
        end


        setactive(self.mView.mTrans_Starup_MaxMask,false);



        for i = 1, self.mStarUpStarList:Count() do
            setactive(self.mStarUpStarList[i],false)
        end


        for i = 1, self.mCurCarrier.star+1 do
            if i<=self.mStarUpStarList:Count() then
                setactive(self.mStarUpStarList[i],true)
            else
                local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/StarA.prefab",self));
                setparent(self.mView.mTrans_Starup_Stars,obj.transform);
                obj.transform.localScale=vectorone;
                self.mStarUpStarList:Add(obj);
            end
        end
    end



    --升级强化提升的数值

	local nextLv = math.min(self.mCurCarrier.star+1,5);
    local curPropertyData=TableData.GetCarrierStarupBaseProperty(self.mCurCarrier.star);
    local nextPropertyData=TableData.GetCarrierStarupBaseProperty(nextLv);
	local maxStartPropertyData=TableData.GetCarrierStarupBaseProperty(5);
	
	local function GetStarUpValueStr(curValue,nextValue,curStar)
		if(curStar >= 5) then
			return "MAX";
		else
			return CS.GFFormula.GetStarUpAddtion(curValue,nextValue);
		end
	end

    --11111 火力  暴击  精准  穿甲
    self.mView.mTrans_Starup_Pow_ValueBar.sizeDelta= Vector2(56,CS.GFFormula.GetStarUpRatio(curPropertyData.pow,maxStartPropertyData.pow)*279.45);
	self.mView.mTrans_Starup_Pow_ValueBarNext.sizeDelta= Vector2(56,CS.GFFormula.GetStarUpRatio(nextPropertyData.pow,maxStartPropertyData.pow)*279.45);
    self.mView.mText_Starup_Pow_ValueNum.text=GetStarUpValueStr(curPropertyData.pow,nextPropertyData.pow,self.mCurCarrier.star);

    self.mView.mTrans_Starup_Crit_ValueBar.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(curPropertyData.crit,maxStartPropertyData.crit)*279.45);
	self.mView.mTrans_Starup_Crit_ValueBarNext.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(nextPropertyData.crit,maxStartPropertyData.crit)*279.45);
    self.mView.mText_Starup_Crit_ValueNum.text=GetStarUpValueStr(curPropertyData.crit,nextPropertyData.crit,self.mCurCarrier.star);

    self.mView.mTrans_Starup_Exp_ValueBar.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(curPropertyData.expertise,maxStartPropertyData.expertise)*279.45);
	self.mView.mTrans_Starup_Exp_ValueBarNext.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(nextPropertyData.expertise,maxStartPropertyData.expertise)*279.45);
    self.mView.mText_Starup_Exp_ValueNum.text=GetStarUpValueStr(curPropertyData.expertise,nextPropertyData.expertise,self.mCurCarrier.star);

    self.mView.mTrans_Starup_Pierce_ValueBar.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(curPropertyData.pierce,maxStartPropertyData.pierce)*279.45);
	self.mView.mTrans_Starup_Pierce_ValueBarNext.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(nextPropertyData.pierce,maxStartPropertyData.pierce)*279.45);
    self.mView.mText_Starup_Pierce_ValueNum.text=GetStarUpValueStr(curPropertyData.pierce,nextPropertyData.pierce,self.mCurCarrier.star);

    --222222 护甲  嘲讽  灵活  坚固
    self.mView.mTrans_Starup_Armor_ValueBar.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(curPropertyData.armor,maxStartPropertyData.armor)*279.45);
	self.mView.mTrans_Starup_Armor_ValueBarNext.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(nextPropertyData.armor,maxStartPropertyData.armor)*279.45);
    self.mView.mText_Starup_Armor_ValueNum.text=GetStarUpValueStr(curPropertyData.armor,nextPropertyData.armor,self.mCurCarrier.star);

    self.mView.mTrans_Starup_Taunt_ValueBar.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(curPropertyData.taunt,maxStartPropertyData.taunt)*279.45);
	self.mView.mTrans_Starup_Taunt_ValueBarNext.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(nextPropertyData.taunt,maxStartPropertyData.taunt)*279.45);
    self.mView.mText_Starup_Taunt_ValueNum.text=GetStarUpValueStr(curPropertyData.taunt,nextPropertyData.taunt,self.mCurCarrier.star);

    self.mView.mTrans_Starup_Flex_ValueBar.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(curPropertyData.flexible,maxStartPropertyData.flexible)*279.45);
	self.mView.mTrans_Starup_Flex_ValueBarNext.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(nextPropertyData.flexible,maxStartPropertyData.flexible)*279.45);
    self.mView.mText_Starup_Flex_ValueNum.text=GetStarUpValueStr(curPropertyData.flexible,nextPropertyData.flexible,self.mCurCarrier.star);

    self.mView.mTrans_Starup_Tough_ValueBar.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(curPropertyData.tough,maxStartPropertyData.tough)*279.45);
	self.mView.mTrans_Starup_Tough_ValueBarNext.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(nextPropertyData.tough,maxStartPropertyData.tough)*279.45);
    self.mView.mText_Starup_Tough_ValueNum.text=GetStarUpValueStr(curPropertyData.tough,nextPropertyData.tough,self.mCurCarrier.star);

    --33333333 血量  载重
    self.mView.mTrans_Starup_HP_ValueBar.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(curPropertyData.max_hp,maxStartPropertyData.max_hp)*279.45);
	self.mView.mTrans_Starup_HP_ValueBarNext.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(nextPropertyData.max_hp,maxStartPropertyData.max_hp)*279.45);
    self.mView.mText_Starup_HP_ValueNum.text=GetStarUpValueStr(curPropertyData.max_hp,nextPropertyData.max_hp,self.mCurCarrier.star);

    self.mView.mTrans_Starup_Bearing_ValueBar.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(curPropertyData.max_bearing,maxStartPropertyData.max_bearing)*279.45);
	self.mView.mTrans_Starup_Bearing_ValueBarNext.sizeDelta=Vector2(56,CS.GFFormula.GetStarUpRatio(nextPropertyData.max_bearing,maxStartPropertyData.max_bearing)*279.45);
    self.mView.mText_Starup_Bearing_ValueNum.text=GetStarUpValueStr(curPropertyData.max_bearing,nextPropertyData.max_bearing,self.mCurCarrier.star);


    --print(self.mView.mText_StarUp_SelectedNum);



    --确定 升星 按钮  开关  根据核心数量

    if self.mCurCarrier.star == 5 then
        self.mView.mBtn_Starup_ButtonComfirm.interactable=false;
        self.mView.mImage_Starup_ButtonComfirm.color=CS.GF2.UI.UITool.StringToColor("FFFFFFFF")
    else
        --当前已经选择的载具数量

        --还需要的核心数
        local num=TableData.GetStarUpNeedNumByCurrent(self.mCurCarrier.star)-CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList.Count;
        local numTotal=num*TableData.GetCoreNumByRank(self.mCurCarrierStc.rank);
        self.mView.mText_Starup_CoreCost.text= numTotal;

        if(numTotal <=coreNum ) then
            self.mView.mBtn_Starup_ButtonComfirm.interactable=true;
            self.mView.mImage_Starup_ButtonComfirm.color=CS.GF2.UI.UITool.StringToColor("D99900FF");
        else
            self.mView.mBtn_Starup_ButtonComfirm.interactable=false;
            self.mView.mImage_Starup_ButtonComfirm.color=CS.GF2.UI.UITool.StringToColor("FFFFFFFF");
        end
    end
end


function UIGarageVechicleDetailPanel:InitReformVas()
    if self.mReformRequireLvVars == nil then
        self.mReformRequireLvVars = TableData.GetGlobalCFGIntsVal(GCFGConst.carrier_reform_require_lv);
    end
    if self.mReformRequireStarVars == nil then
        self.mReformRequireStarVars = TableData.GetGlobalCFGIntsVal(GCFGConst.carrier_reform_require_star);
    end
    if self.mReformComponentsVars == nil then
        self.mReformComponentsVars = TableData.GetGlobalCFGIntsVal(GCFGConst.carrier_reform_components);
    end
    if self.mReformPropertyVars == nil then
        self.mReformPropertyVars = TableData.GetGlobalCFGIntsVal(GCFGConst.carrier_reform_type_property);
    end
end

function UIGarageVechicleDetailPanel:SetReformPropertyUI(proc, procdec, procadd, sign, value, cur, dst, propno)
    local addon = math.abs(dst - cur);
    if addon == 0 then
        setactive(proc.transform.parent, false);
        return;
    else
        setactive(proc.transform.parent, true);
    end
    if dst < cur then
        proc.fillAmount = self.GetPropertyPercent(dst, propno);
        procdec.fillAmount = self.GetPropertyPercent(cur, propno);
        sign.text = "-";
        value.text = addon;
        sign.color = procdec.color;
        value.color = procdec.color;
        setactive(procdec, true);
        setactive(procadd, false);
    else
        proc.fillAmount = self.GetPropertyPercent(cur, propno);
        procadd.fillAmount = self.GetPropertyPercent(dst, propno);
        sign.text = "+";
        value.text = addon;
        sign.color = procadd.color;
        value.color = procadd.color;
        setactive(procdec, false);
        setactive(procadd, true);
    end
end

function UIGarageVechicleDetailPanel:IsGenericReformMaxed()
	local count = 0;	
	local reforms = self.mCurCarrier.reform;
    for i = 1, reforms.Length do
        if reforms[i - 1] == 4 then
            count = count + 1;
        end
    end
	
	if count >= 3 then
		return true;
	else
		return false;
	end
end

function UIGarageVechicleDetailPanel:SelectReformType(index)

    if index > self.mReformTypeNum then
        index = self.mReformTypeNum;
    end

    self.mCurSelReformType = index;

    --中间reform类型
    for i = 1, self.mReformTypeBtns:Count() do
        local reformTypeBtn = self.mReformTypeBtns[i];
        setactive(reformTypeBtn[self.ReformType.SelImg], self.mCurSelReformType == i);
    end

    self.mCurSelReformTypeProperty = TableData.GetCarrierPropertyData(self.mReformTypeBtns[index][self.ReformType.Data].property);

    if self.mCurSelReformTypeProperty ~= nil then
        local addon = self:GetReformRealProperty(self.mCurSelReformTypeProperty, self.mCurSelReform, CarrierPropNo.max_hp);
        self:SetReformPropertyUI(self.mView.mImage_Reform_HP_ValueBar,
                self.mView.mImage_Reform_HP_ValueBarNegative,
                self.mView.mImage_Reform_HP_ValueBarPositive,
                self.mView.mText_Reform_HP_PlusOrMinus,
                self.mView.mText_Reform_HP_PropertyDelta,
                self.mCurCarrier.prop.max_hp, addon, CarrierPropNo.max_hp);
        addon = self:GetReformRealProperty(self.mCurSelReformTypeProperty, self.mCurSelReform, CarrierPropNo.armor);
        self:SetReformPropertyUI(self.mView.mImage_Reform_Armor_ValueBar,
                self.mView.mImage_Reform_Armor_ValueBarNegative,
                self.mView.mImage_Reform_Armor_ValueBarPositive,
                self.mView.mText_Reform_Armor_PlusOrMinus,
                self.mView.mText_Reform_Armor_PropertyDelta,
                self.mCurCarrier.prop.armor, addon, CarrierPropNo.armor);
        addon = self:GetReformRealProperty(self.mCurSelReformTypeProperty, self.mCurSelReform, CarrierPropNo.pow);
        self:SetReformPropertyUI(self.mView.mImage_Reform_Pow_ValueBar,
                self.mView.mImage_Reform_Pow_ValueBarNegative,
                self.mView.mImage_Reform_Pow_ValueBarPositive,
                self.mView.mText_Reform_Pow_PlusOrMinus,
                self.mView.mText_Reform_Pow_PropertyDelta,
                self.mCurCarrier.prop.pow, addon, CarrierPropNo.pow);
        addon = self:GetReformRealProperty(self.mCurSelReformTypeProperty, self.mCurSelReform, CarrierPropNo.pierce);
        self:SetReformPropertyUI(self.mView.mImage_Reform_Pierce_ValueBar,
                self.mView.mImage_Reform_Pierce_ValueBarNegative,
                self.mView.mImage_Reform_Pierce_ValueBarPositive,
                self.mView.mText_Reform_Pierce_PlusOrMinus,
                self.mView.mText_Reform_Pierce_PropertyDelta,
                self.mCurCarrier.prop.pierce, addon, CarrierPropNo.pierce);
        addon = self:GetReformRealProperty(self.mCurSelReformTypeProperty, self.mCurSelReform, CarrierPropNo.expertise);
        self:SetReformPropertyUI(self.mView.mImage_Reform_Exp_ValueBar,
                self.mView.mImage_Reform_Exp_ValueBarNegative,
                self.mView.mImage_Reform_Exp_ValueBarPositive,
                self.mView.mText_Reform_Exp_PlusOrMinus,
                self.mView.mText_Reform_Exp_PropertyDelta,
                self.mCurCarrier.prop.expertise, addon, CarrierPropNo.expertise);
        addon = self:GetReformRealProperty(self.mCurSelReformTypeProperty, self.mCurSelReform, CarrierPropNo.crit);
        self:SetReformPropertyUI(self.mView.mImage_Reform_Crit_ValueBar,
                self.mView.mImage_Reform_Crit_ValueBarNegative,
                self.mView.mImage_Reform_Crit_ValueBarPositive,
                self.mView.mText_Reform_Crit_PlusOrMinus,
                self.mView.mText_Reform_Crit_PropertyDelta,
                self.mCurCarrier.prop.crit, addon, CarrierPropNo.crit);
        addon = self:GetReformRealProperty(self.mCurSelReformTypeProperty, self.mCurSelReform, CarrierPropNo.flexible);
        self:SetReformPropertyUI(self.mView.mImage_Reform_Flex_ValueBar,
                self.mView.mImage_Reform_Flex_ValueBarNegative,
                self.mView.mImage_Reform_Flex_ValueBarPositive,
                self.mView.mText_Reform_Flex_PlusOrMinus,
                self.mView.mText_Reform_Flex_PropertyDelta,
                self.mCurCarrier.prop.flexible, addon, CarrierPropNo.flexible);
        addon = self:GetReformRealProperty(self.mCurSelReformTypeProperty, self.mCurSelReform, CarrierPropNo.taunt);
        self:SetReformPropertyUI(self.mView.mImage_Reform_Taunt_ValueBar,
                self.mView.mImage_Reform_Taunt_ValueBarNegative,
                self.mView.mImage_Reform_Taunt_ValueBarPositive,
                self.mView.mText_Reform_Taunt_PlusOrMinus,
                self.mView.mText_Reform_Taunt_PropertyDelta,
                self.mCurCarrier.prop.taunt, addon, CarrierPropNo.taunt);
        addon = self:GetReformRealProperty(self.mCurSelReformTypeProperty, self.mCurSelReform, CarrierPropNo.tough);
        self:SetReformPropertyUI(self.mView.mImage_Reform_Tough_ValueBar,
                self.mView.mImage_Reform_Tough_ValueBarNegative,
                self.mView.mImage_Reform_Tough_ValueBarPositive,
                self.mView.mText_Reform_Tough_PlusOrMinus,
                self.mView.mText_Reform_Tough_PropertyDelta,
                self.mCurCarrier.prop.tough, addon, CarrierPropNo.tough);
        addon = self:GetReformRealProperty(self.mCurSelReformTypeProperty, self.mCurSelReform, CarrierPropNo.max_bearing);
        self:SetReformPropertyUI(self.mView.mImage_Reform_Bearing_ValueBar,
                self.mView.mImage_Reform_Bearing_ValueBarNegative,
                self.mView.mImage_Reform_Bearing_ValueBarPositive,
                self.mView.mText_Reform_Bearing_PlusOrMinus,
                self.mView.mText_Reform_Bearing_PropertyDelta,
                self.mCurCarrier.prop.max_bearing, addon, CarrierPropNo.max_bearing);

        --猪一般的layout刷新
        setactive(self.mView.mVLayout_Reform_Properties, false);
        setactive(self.mView.mVLayout_Reform_Properties, true);
    end
end

function UIGarageVechicleDetailPanel:SelectReform(index)
	--gfdebug(index);
	
    if index > self.mReformNum then
        index = self.mReformNum;
    end

    self.mCurSelReform = index;
    self.mCurSelReformDoneData = self.mReformElems[index][self.ReformElem.Data];
    --上方reform按钮选中
    for i = 1, self.mReformElems:Count() do
        local reformElem = self.mReformElems[i];
        setactive(reformElem[self.ReformElem.SelImg], i == index);
    end

    --中间reform类型
	local count = 0;
    for i = 1, self.mReformTypeBtns:Count() do
        local reformTypeBtn = self.mReformTypeBtns[i];
        local reformData = reformTypeBtn[self.ReformType.Data];
        setactive(reformTypeBtn[self.ReformType.DoneImg], self.mCurSelReformDoneData == reformData);
        reformTypeBtn[self.ReformType.Name].text = reformData.name;
        reformTypeBtn[self.ReformType.Desc].text = reformData.description;
		
		if(self:IsGenericReformMaxed() == true) then
			setactive(self.mView.mTrans_Reform_ReformOptions_Type4_MaxMark,true);
		else
			setactive(self.mView.mTrans_Reform_ReformOptions_Type4_MaxMark,false);
		end
    end

    --消耗
    local curComponent = NetCmdItemData:GetItemCount(CmdConst.ItemComponent);
    local costComponent = self.mReformComponentsVars[index - 1];
    self.mView.mText_Reform_Component_Count.text = curComponent;
    self.mView.mText_Reform_CostComfirm_Count.text = costComponent;

    --需求等级
    local requireLv = self.mReformRequireLvVars[index - 1];
    self.mView.mText_Reform_Requirement_Level_LevelRequirement.text = requireLv;
    local lvEnable = requireLv <= self.mCurCarrier.level;
    setactive(self.mView.mImage_Reform_Requirement_Level_Enabled, lvEnable);
    setactive(self.mView.mImage_Reform_Requirement_Level_Disabled, not lvEnable);

    --需求星级
    local requireStar = self.mReformRequireStarVars[index - 1];
    for i = 1, TableData.GetMaxCarrierStar() do
        setchildactive(self.mView.mImage_Reform_Requirement_Star_StarRequirement, i - 1, requireStar >= i);
    end
    local starEnable = requireStar <= self.mCurCarrier.star;

    setactive(self.mView.mImage_Reform_Requirement_Star_Enabled, starEnable);
    setactive(self.mView.mImage_Reform_Requirement_Star_Disabled, not starEnable);

    self.mView.mBtn_Reform_CostComfirm_BottonComfirm.interactable = lvEnable and starEnable;
end



--改造界面
function UIGarageVechicleDetailPanel.SetReformInfo()

    self = UIGarageVechicleDetailPanel;

    self.mCurCarrier = CarrierNetCmdHandler:GetCarrierByID(self.mCurCarrier.id);
    self.mCurCarrierStc = TableData.GetCarrierBaseBodyData(self.mCurCarrier.stc_carrier_id);


    if self.mCurCarrier == nil or self.mCurCarrierStc == nil then
        gferror("当前载具为空，无法设置强化信息！");
        return;
    end

    --头部信息
    self.mView.mText_Reform_Name.text = self.mCurCarrierStc.name;
    self.mView.mText_Reform_Prefix.text = self.mCurCarrierPrefixStc.name;
    self.mView.mText_Reform_BattlePower.text = self.mCurCarrier.prop.pow;
    self.mView.mText_Reform_Level.text = self.mCurCarrier.level;

    --reform原始数值
    self.mView.mText_Reform_HP_PropertyOrigin.text = self.mCurCarrier.prop.max_hp;
    self.mView.mText_Reform_Armor_PropertyOrigin.text = self.mCurCarrier.prop.armor;
    self.mView.mText_Reform_Pow_PropertyOrigin.text = self.mCurCarrier.prop.pow;
    self.mView.mText_Reform_Pierce_PropertyOrigin.text = self.mCurCarrier.prop.pierce;
    self.mView.mText_Reform_Exp_PropertyOrigin.text = self.mCurCarrier.prop.expertise;
    self.mView.mText_Reform_Crit_PropertyOrigin.text = self.mCurCarrier.prop.crit;
    self.mView.mText_Reform_Flex_PropertyOrigin.text = self.mCurCarrier.prop.flexible;
    self.mView.mText_Reform_Taunt_PropertyOrigin.text = self.mCurCarrier.prop.taunt;
    self.mView.mText_Reform_Tough_PropertyOrigin.text = self.mCurCarrier.prop.tough;
    self.mView.mText_Reform_Bearing_PropertyOrigin.text = self.mCurCarrier.prop.max_bearing;

    --上方reform按钮
	
	local reformDone = 0;
	if self.mCurCarrier.reform ~= nil then
		reformDone = self.mCurCarrier.reform.Length;
	end
	for i = 1, self.mReformElems:Count() do
		local reformElem = self.mReformElems[i];
		if reformDone >= i then
			setactive(reformElem[self.ReformElem.DoneImg], true);
			if reformElem[self.ReformElem.LineImg] ~= nil then
				setactive(reformElem[self.ReformElem.LineImg], true);
			end
			reformElem[self.ReformElem.Data] = TableData.GetCarrierReformData(self.mCurCarrier.reform[i - 1]);
		else
			setactive(reformElem[self.ReformElem.DoneImg], false);
			if reformElem[self.ReformElem.LineImg] ~= nil then
				setactive(reformElem[self.ReformElem.LineImg], false);
			end
			reformElem[self.ReformElem.Data] = nil;
		end

	end
	
	if(self:IsUnlockNewReform() == true) then
		self.mCurSelReform = self.mCurCarrier.reform.Length+1;
	end

    if self.mCurSelReform == 0 then
        if reformDone == 0 then
            self:SelectReform(1);
        else
            self:SelectReform(reformDone);
        end
    else
        self:SelectReform(self.mCurSelReform);
    end

    --选中强化类型
    if self.mCurSelReformType == 0 then
        self:SelectReformType(1);
    else
        self:SelectReformType(self.mCurSelReformType);
    end
	
	
end

function UIGarageVechicleDetailPanel:IsUnlockNewReform()
	if(self.mPrevReform == nil) then
		return true;
	end
	
	local prev = self.mPrevReform;
	local cur = self.mCurCarrier.reform;
	local prevCount = 1;
	local curCount = 1;
	
	if(prev.Length == 0) then
		prevCount = 0;
	else
		for i = prev.Length, 0,-1 do
			if prev[i - 1] ~= 0 then
				prevCount = i;
				break;
			end
		end
	end
	
	if(cur.Length == 0) then
		curCount = 0;
	else
		for i = cur.Length, 0,-1 do
			if cur[i - 1] ~= 0 then
				curCount = i;
				break;
			end
		end
	end
	if(curCount > prevCount) then
		return true;
	else
		return false;
	end
	
end

---调试
function UIGarageVechicleDetailPanel.SetAdjustmentInfo()

    self = UIGarageVechicleDetailPanel;




    setactive(self.mView.mTrans_Adjustment_AdjOptionBasic,true)
    setactive(self.mView.mTrans_Adjustment_AdjOptionAdvanced,false)

    self.UpdateAdjustmentData(nil)

end


function UIGarageVechicleDetailPanel.UpdateAdjustmentData(mPrefixData)
    self.mCurCarrier = CarrierNetCmdHandler:GetCarrierByID(self.mCurCarrier.id);
    self.mCurCarrierStc = TableData.GetCarrierBaseBodyData(self.mCurCarrier.stc_carrier_id);


    if self.mCurCarrier == nil or self.mCurCarrierStc == nil then
        gferror("当前载具为空，无法设置调试信息！");
        return;
    end
    local baseItemNum = NetCmdItemData:GetItemCount(105)
    local advancedItemNum = NetCmdItemData:GetItemCount(106)
    local baseCost = TableData.GetGlobalCFGIntVal(GCFGConst.carrier_body_adjustment_cost)
    local advancedCost = TableData.GetGlobalCFGIntVal(GCFGConst.carrier_body_sp_adjustment_cost)
    local prefixData
    if mPrefixData==nil then
        prefixData = TableData.GetCarrierPrefixData(self.mCurCarrier.prefix)
        self.mTempPrefixData = nil
    else
        prefixData = mPrefixData
    end
---设置确认按钮


    local adjustment = self.mCurCarrier.adjustment/10

    self.mView.mText_Adjustment_AdjustmentScroll_Count.text = baseItemNum
    self.mView.mText_Adjustment_AdvAdjustmentScroll_Count.text = advancedItemNum
    self.mView.mText_Adjustment_AdjOptionBasic_Cost.text = baseCost
    self.mView.mText_Adjustment_AdjOptionAdvanced_CoreCost.text = advancedCost

    if baseItemNum<baseCost or adjustment>=100 then
        self.mView.mBtn_Adjustment_AdjOptionBasic_ConfirmButton.interactable = false
    else
        self.mView.mBtn_Adjustment_AdjOptionBasic_ConfirmButton.interactable = true
    end

    if prefixData== TableData.GetCarrierPrefixData(self.mCurCarrier.prefix) or advancedItemNum<advancedCost then
        self.mView.mBtn_Adjustment_AdjOptionAdvanced_ConfirmButton.interactable = false
    else
        self.mView.mBtn_Adjustment_AdjOptionAdvanced_ConfirmButton.interactable = true
    end

    self.mView.mText_Adjustment_AdjOptionBasic_CurPrefixName.text = prefixData.name
    self.mView.mText_Adjustment_AdjOptionAdvanced_CurPrefixName.text = prefixData.name
    self.mView.mImage_Adjustment_AdjOptionBasic_RateFill.fillAmount = adjustment/100
    self.mView.mImage_Adjustment_AdjOptionAdvanced_RateFill.fillAmount = adjustment/100
    self.mView.mText_Adjustment_AdjOptionBasic_RateValue.text = adjustment
    self.mView.mText_Adjustment_AdjOptionAdvanced_RateValue.text = adjustment


    local prefixPropData = TableData.GetCarrierPropertyData(prefixData.max_property)
    local prefixPropList = List:New()
    prefixPropList:Add(prefixPropData.max_hp*0.1)
    prefixPropList:Add(prefixPropData.pow*0.1)
    prefixPropList:Add(prefixPropData.taunt*0.1)
    prefixPropList:Add(prefixPropData.pierce*0.1)
    prefixPropList:Add(prefixPropData.armor*0.1)
    prefixPropList:Add(prefixPropData.expertise*0.1)
    prefixPropList:Add(prefixPropData.flexible*0.1)
    prefixPropList:Add(prefixPropData.crit*0.1)
    prefixPropList:Add(prefixPropData.tough*0.1)

    local prefixIndexList = List:New()
    local prefixValueList = List:New()
    for i=1,prefixPropList:Count() do
        if prefixPropList[i]~=0 then
            gfwarning("prefixProp"..prefixPropList[i])
            prefixIndexList:Add(i)
            prefixValueList:Add(prefixPropList[i])
        end
    end

    for n=1,prefixIndexList:Count() do
        --local sprite = ResSys:GetSprite("property/"..TableData.GetDefineCarrierProperty(prefixIndexList[n]).icon_normal)
		-- local sprite = UIUtils.GetIconSprite("UIRes/UISprite/property",TableData.GetDefineCarrierProperty(prefixIndexList[n]).icon_normal)
        self.mView["mImage_Adjustment_AdjOptionBasic_"..n.."_PropertyPositive_PropertyIcon"].sprite = sprite
        self.mView["mImage_Adjustment_AdjOptionBasic_"..n.."_PropertyNegative_PropertyIcon"].sprite = sprite
        self.mView["mImage_Adjustment_AdjOptionAdvanced_"..n.."_PropertyNegative_PropertyIcon"].sprite = sprite
        self.mView["mImage_Adjustment_AdjOptionAdvanced_"..n.."_PropertyPositive_PropertyIcon"].sprite = sprite

        local name = PropertyUtils.GetPropertyName(TableData.GetDefineCarrierProperty(prefixIndexList[n]).define_name)
        --gfwarning("define_name:"..name)
        self.mView["mText_Adjustment_AdjOptionAdvanced_"..n.."_PropertyNegative_PropertyName"].text = name
        self.mView["mText_Adjustment_AdjOptionAdvanced_"..n.."_PropertyPositive_PropertyName"].text = name
        self.mView["mText_Adjustment_AdjOptionBasic_"..n.."_PropertyNegative_PropertyName"].text = name
        self.mView["mText_Adjustment_AdjOptionBasic_"..n.."_PropertyPositive_PropertyName"].text = name


        self.mView["mText_Adjustment_AdjOptionAdvanced_"..n.."_PropertyNegative_PropertyNum"].text = prefixValueList[n]
        self.mView["mText_Adjustment_AdjOptionAdvanced_"..n.."_PropertyPositive_PropertyValue"].text = "+"..prefixValueList[n]
        self.mView["mText_Adjustment_AdjOptionBasic_"..n.."_PropertyNegative_PropertyNum"].text = prefixValueList[n]
        self.mView["mText_Adjustment_AdjOptionBasic_"..n.."_PropertyPositive_PropertyValue"].text = "+"..prefixValueList[n]
        if prefixValueList[n]>0 then
            setactive(self.mView["mTrans_Adjustment_AdjOptionBasic_"..n.."_PropertyPositive"],true)
            setactive(self.mView["mTrans_Adjustment_AdjOptionBasic_"..n.."_PropertyNegative"],false)
            setactive(self.mView["mTrans_Adjustment_AdjOptionBasic_"..n.."_PropertyNone"],false)



            setactive(self.mView["mTrans_Adjustment_AdjOptionAdvanced_"..n.."_PropertyPositive"],true)
            setactive(self.mView["mTrans_Adjustment_AdjOptionAdvanced_"..n.."_PropertyNegative"],false)
            setactive(self.mView["mTrans_Adjustment_AdjOptionAdvanced_"..n.."_PropertyNone"],false)
            elseif prefixValueList[n]<0 then
            setactive(self.mView["mTrans_Adjustment_AdjOptionBasic_"..n.."_PropertyPositive"],false)
            setactive(self.mView["mTrans_Adjustment_AdjOptionBasic_"..n.."_PropertyNegative"],true)
            setactive(self.mView["mTrans_Adjustment_AdjOptionBasic_"..n.."_PropertyNone"],false)


            setactive(self.mView["mTrans_Adjustment_AdjOptionAdvanced_"..n.."_PropertyPositive"],false)
            setactive(self.mView["mTrans_Adjustment_AdjOptionAdvanced_"..n.."_PropertyNegative"],true)
            setactive(self.mView["mTrans_Adjustment_AdjOptionAdvanced_"..n.."_PropertyNone"],false)
        end
    end

    if prefixIndexList:Count()<3 then
        for n=prefixIndexList:Count(),3 do
            setactive(self.mView["mTrans_Adjustment_AdjOptionBasic_"..n.."_PropertyPositive"],false)
            setactive(self.mView["mTrans_Adjustment_AdjOptionBasic_"..n.."_PropertyNegative"],false)
            setactive(self.mView["mTrans_Adjustment_AdjOptionBasic_"..n.."_PropertyNone"],true)

            setactive(self.mView["mTrans_Adjustment_AdjOptionAdvanced_"..n.."_PropertyPositive"],false)
            setactive(self.mView["mTrans_Adjustment_AdjOptionAdvanced_"..n.."_PropertyNegative"],false)
            setactive(self.mView["mTrans_Adjustment_AdjOptionAdvanced_"..n.."_PropertyNone"],true)
        end
    end
end

function UIGarageVechicleDetailPanel.OnBaseBtnClicked(gameObject)
    self = UIGarageVechicleDetailPanel
    setactive(self.mView.mTrans_Adjustment_AdjOptionBasic,true)
    setactive(self.mView.mTrans_Adjustment_AdjOptionAdvanced,false)
    self.UpdateAdjustmentData(nil)
end

function UIGarageVechicleDetailPanel.OnAdvancedBtnClicked(gameObject)
    self = UIGarageVechicleDetailPanel

    setactive(self.mView.mTrans_Adjustment_AdjOptionBasic,false)
    setactive(self.mView.mTrans_Adjustment_AdjOptionAdvanced,true)
    --self.mView.mBtn_Adjustment_AdjOptionAdvanced_ConfirmButton.interactable = false
    self.UpdateAdjustmentData(nil)
end

function UIGarageVechicleDetailPanel.OnAdvancedPrefixClicked()
    self = UIGarageVechicleDetailPanel
    setactive(self.mView.mTrans_Adjustment_AdjOptionAdvanced_PrefixList,true)
    local prefab = UIUtils.GetGizmosPrefab(self.mPath_PrefixItem,self);
    if self.mPrefixItemList ==nil then self.mPrefixItemList = List:New(UIPrefixTypeItem)
    end

    local mPrefixData
    if self.mTempPrefixData~=nil then
        mPrefixData = self.mTempPrefixData
    else
        mPrefixData = TableData.GetCarrierPrefixData(self.mCurCarrier.prefix)
    end
    local prefixDatas = TableData.GetAllCarrierPrefixData()

    prefixDatas:Remove(mPrefixData)
    gfwarning(prefixDatas.Count)
    local count = self.mPrefixItemList:Count()
    gfwarning(count)
    for n=1,count do
        self.mPrefixItemList[n]:Reset()
    end

    for i=0, prefixDatas.Count-1 do
        if i>count-1 then
            local item = UIPrefixTypeItem.New()
            local itemObject = instantiate(prefab)
            UIUtils.AddListItem(itemObject,self.mView.mTrans_Adjustment_AdjOptionAdvanced_PrefixList)
            item:InitCtrl(itemObject.transform)
            item:SetData(prefixDatas[i])
            self.mPrefixItemList:Add(item)
            local listener = UIUtils.GetButtonListener(itemObject)
            listener.onClick = self.OnPrefixItemClicked
            listener.param = prefixDatas[i]
        else
            local item = self.mPrefixItemList[i+1]
            item:SetData(prefixDatas[i])
            local listener = UIUtils.GetButtonListener(item.mUIRoot.gameObject)
            listener.onClick = self.OnPrefixItemClicked
            listener.param = prefixDatas[i]
        end
    end



end

function UIGarageVechicleDetailPanel.OnPrefixItemClicked(gameobj)
    self = UIGarageVechicleDetailPanel

    setactive(self.mView.mTrans_Adjustment_AdjOptionAdvanced_PrefixList,false)
    --self.mView.mBtn_Adjustment_AdjOptionAdvanced_ConfirmButton.interactable = true
    local eventTrigger = getcomponent(gameobj, typeof(CS.ButtonEventTriggerListener));
    if eventTrigger ~= nil then
        self.mTempPrefixData = eventTrigger.param
    end

    self.UpdateAdjustmentData(self.mTempPrefixData)
end

function UIGarageVechicleDetailPanel.OnAdvancedConfirmed()
    local prefixID
    if self.mTempPrefixData~=nil then
        prefixID = self.mTempPrefixData.id
    else
        prefixID = self.mCurCarrier.prefix
    end
    gfwarning(prefixID)
    CarrierNetCmdHandler:ReqCarrierSpAdjust(self.mCurCarrier.id,prefixID,self.CmdAdjustCallBack)

end

function UIGarageVechicleDetailPanel.OnBaseConfirmed()
    CarrierNetCmdHandler:ReqCarrierAdjust(self.mCurCarrier.id,self.CmdAdjustCallBack)
end

function UIGarageVechicleDetailPanel.CmdAdjustCallBack(ret)
    self = UIGarageVechicleDetailPanel;
    if ret == CS.CMDRet.eSuccess then
        gfdebug("调试成功");
    else
        gfdebug("调试失败");
        MessageBox.Show("Error", "调试失败");
    end
    self.UpdateAdjustmentData(nil)
end
--打开界面，起始索引为1
function UIGarageVechicleDetailPanel:OpenSubPanel(index)

    if index == self.mCurPanelIndex then
        return;
    end

    self.mCurPanelIndex = index;
    for i = 1, self.mSubPanels:Count() do

        local panelarr = self.mSubPanels[i];

        setactive(panelarr[self.PanelElem.PanelObj], i == index);

        if i == index then
            panelarr[self.PanelElem.SetFunc]();
            UIUtils.SetAlpha(panelarr[self.PanelElem.Tab], 1);
        else
            UIUtils.SetAlpha(panelarr[self.PanelElem.Tab], 0);
        end

    end
	
	if(i ~= 3) then
		CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList:Clear();
	end
end

function UIGarageVechicleDetailPanel.BackToListBtnClick(gameObject)

    self = UIGarageVechicleDetailPanel;
    UISystem:ShowUI(UIDef.UIGarageMainPanel, true);
    UISystem:ShowUI(UIDef.UIGarageVechicleDetailPanel, false);

end



--选择载具按钮
function UIGarageVechicleDetailPanel.SelectCarrierBtnClick(gameObject)
    self=UIGarageVechicleDetailPanel;
    CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList:Clear();
    CarrierTrainNetCmdHandler.mStarUpNum=TableData.GetStarUpNeedNumByCurrent(self.mCurCarrier.star);
    --打开载具选择界面
    UICarrierSelectionPanel.Open(UIDef.UIGarageVechicleDetailPanel,self.mCurCarrier);
end


--确定 升星 按钮
function UIGarageVechicleDetailPanel.StarUpConfirmBtnClick(gameObject)
    self = UIGarageVechicleDetailPanel;

    if self.mView.mBtn_Starup_ButtonComfirm.interactable then
        local num=TableData.GetStarUpNeedNumByCurrent(self.mCurCarrier.star)-CarrierTrainNetCmdHandler.mSelectCarrierForStarUpIDList.Count;
        CarrierTrainNetCmdHandler:ReqCarrierStarUp(self.mCurCarrier.id,nil,num*TableData.GetCoreNumByRank(self.mCurCarrierStc.rank),nil);
    end
end

function UIGarageVechicleDetailPanel.PowerupCallBack(ret)
    self = UIGarageVechicleDetailPanel;
    self:SetCurCarrier(CarrierNetCmdHandler:GetCarrierByID(self.mCurCarrier.id));
    self.SetPowerUpInfo();
end

function UIGarageVechicleDetailPanel.ReformCallBack(ret)
    self = UIGarageVechicleDetailPanel;
	
	local tempSelect = self.mCurSelReform;
    self:SetCurCarrier(CarrierNetCmdHandler:GetCarrierByID(self.mCurCarrier.id));
	self.mCurSelReform = tempSelect;
    self.SetReformInfo();
	
	if(self.mCurCarrier.reform.Length <= self.mCurSelReform) then
		self:SelectReformType(1);
		return;
	end
	
	if(self:IsGenericReformMaxed() == true and self.mCurCarrier.reform[self.mCurSelReform-1] == 4) then
		self:SelectReformType(1);
	end

end

--载具powerup按钮
function UIGarageVechicleDetailPanel.CarrierPowerupBtnClick(gameObject)

    if self.mView.mBtn_PowerUp_PowerUpConfirmButton.interactable == false then
        return;
    end

    local nextlevel = self.mCurCarrier.level + 1;
    local levelupData = TableData.GetCarrierBodyLevelupData(nextlevel);

    local comsumNum = levelupData.level_components;
    local curNum = NetCmdItemData:GetItemCount(CmdConst.ItemComponent);
    if curNum < comsumNum then
        gferror("零件不足强化失败！");
        return;
    end

    CarrierTrainNetCmdHandler:ReqCarrierLvUp(self.mCurCarrier.id, comsumNum, self.PowerupCallBack);
end


function UIGarageVechicleDetailPanel.BottomBtnClick(gameObject)

    for i = 1, self.mSubPanels:Count() do
        if self.mSubPanels[i][self.PanelElem.Tab].gameObject == gameObject then
            self:OpenSubPanel(i);
            break;
        end
    end
end

function UIGarageVechicleDetailPanel.ReformConfirmBtnClick(gameObject)
	self = UIGarageVechicleDetailPanel;
	self.mPrevReform = self.mCurCarrier.reform;
    if self.mView.mBtn_Reform_CostComfirm_BottonComfirm.interactable == false then
        return;
    end
	
	local nextReformTypeId = self.mReformTypeBtns[self.mCurSelReformType][self.ReformType.Data].id;
	local curReformTypeId = 0;
	if(self.mCurCarrier.reform.Length > self.mCurSelReform) then
		curReformTypeId = self.mCurCarrier.reform[self.mCurSelReform - 1];
	end
	
	if(nextReformTypeId == curReformTypeId) then
		MessageBox.Show("注意", "不能改造相同的类型！", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
		return;
	end
	
	local curBearing = CarrierNetCmdHandler:GetCarrierCurrentLoad(self.mCurCarrier.id);
	local maxBearingAfter  = self:GetReformRealProperty(self.mCurSelReformTypeProperty, self.mCurSelReform, CarrierPropNo.max_bearing);

	if(maxBearingAfter < curBearing)  then
		MessageBox.Show("注意", "改造后，载重将不足以承载现有配件，请卸下部分配件再进行改造", MessageBox.ShowFlag.eMidBtn, nil, nil, nil);
		return;
	end
	
    CarrierTrainNetCmdHandler:ReqCarrierReform(self.mCurCarrier.id,
            self.mCurSelReform - 1,
            nextReformTypeId, self.ReformCallBack);
end

function UIGarageVechicleDetailPanel.ReformBtnClick(gameObject)

    self = UIGarageVechicleDetailPanel;

    for i = 1, self.mReformElems:Count() do
        --必须上一级强化过才可选中
        if self.mReformElems[i][self.ReformElem.Btn].gameObject == gameObject then
            if i == 1 or self.mReformElems[i-1][self.ReformElem.Data] ~= nil then
                self:SelectReform(i);
                self:SelectReformType(self.mCurSelReformType);
                break;
            end
        end
    end

end

function UIGarageVechicleDetailPanel.ReformTypeBtnClick(gameObject)

    self = UIGarageVechicleDetailPanel;

    for i = 1, self.mReformTypeBtns:Count() do
        if self.mReformTypeBtns[i][self.ReformType.Btn].gameObject == gameObject then
			if(i == 4 and self:IsGenericReformMaxed() == true) then
				gfdebug("泛用改造只能改造最多3次,不能选择");
				return;
			end
						
            self:SelectReformType(i);
            break;
        end
    end
end

function UIGarageVechicleDetailPanel:TweenCamera()
	local camera = UIUtils.FindTransform("Main Camera");
	local target = UIUtils.FindTransform(self.mDetailCameraNodePath);	
	UITweenCamera.TweenCamera(camera,target,0.5);
end











