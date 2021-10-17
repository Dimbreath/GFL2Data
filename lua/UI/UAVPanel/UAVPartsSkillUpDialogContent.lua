require("UI.UAVPanel.UIUAVContentBase")
UAVPartsSkillUpDialogContent = class("UAVSkillInfoDialogContent", UIUAVContentBase)
UAVPartsSkillUpDialogContent.__index = UAVPartsSkillUpDialogContent

UAVPartsSkillUpDialogContent.PrefabPath = "UAV/UAVPartsSkillUpDialogV2.prefab"
function UAVPartsSkillUpDialogContent:ctor(obj)
    
    UAVPartsSkillUpDialogContent.super.ctor(self, obj)
end

function UAVPartsSkillUpDialogContent:__InitCtrl()
    UISystem:AddContentUi("UAVPartsSkillUpDialogV2")
    self.mText_Title=self:GetText("Root/GrpDialog/GrpTop/GrpText/TitleText")
    self.mBtn_BgClose=self:GetButton("Root/GrpBg/Btn_Close")
    self.mBtn_Close=self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mImage_LeftUpIcon=self:GetImage("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpUAVIcon/GrpTacticSkill2DIcon/Img_Icon")
    self.mImage_ArmIcon=self:GetImage("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpUAVIcon/Grp3DModel/Img_3DModelIcon")
    self.mText_CostNum=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpUAVIcon/GrpCost/Text_Num")
    self.mText_ArmName=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpText/Text_Name")
    self.mText_NowLevel=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpLevelUp/GrpTextNow/Text_Level")
    self.mText_NextLevel=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpLevelUp/GrpTextSoon/Text_Level")
    self.mText_SkillDes=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillUp/GrpAllSkillDescription/GrpDescription/Viewport/Content/Text_SkillUp")
    self.mTrans_ItemScript=self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpConsume/GrpItem")
    self.mBtn_info=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpSkillInfo/BtnInfo"))
    self.mBtn_Confirm=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnConfirm"))
    self.mBtn_Cancle=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnCancel"))
    self.mTrans_SkillDetail=self:GetRectTransform("Root/GrpDialog/Trans_GrpSkillDetails")
    self.mBtn_DetailBgClose=self:GetButton("Root/GrpDialog/Trans_GrpSkillDetails/Btn_Close")
    self.mBtn_DetailClose=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/Trans_GrpSkillDetails/BtnInfo"))
    self.mText_DetailSkillDes=self:GetText("Root/GrpDialog/Trans_GrpSkillDetails/GrpAllSkillDescription/GrpDescribe/Viewport/Content/Text_Level1")
    self.mTrans_DetailLevelUpDes=self:GetRectTransform("Root/GrpDialog/Trans_GrpSkillDetails/GrpAllSkillDescription/GrpDescribe/Viewport/Content/GrpLevelDescription")
end

function UAVPartsSkillUpDialogContent:SetData(data, parent)
    UAVPartsSkillUpDialogContent.super.SetData(self, data, parent)
    CS.LuaUIUtils.AddCanvas(self.mUIRoot.gameObject,GlobalConfig.ContentPrefabOrder)
    self.mGraphRayCaster=getcomponent(self.mUIRoot,typeof(CS.UnityEngine.UI.GraphicRaycaster))
    local nowarmid=UAVUtility.NowArmId
    local armtabledata=TableData.GetUavArmsData()
    local uavarmdic=NetCmdUavData:GetUavArmData()
    local armskilltabledata=TableData.GetUarArmRevelantData(tonumber(armtabledata[nowarmid].SkillSet))
    self.mText_Title.text=TableData.GetHintById(105020)
    self.mImage_LeftUpIcon.sprite=UIUtils.GetIconSprite("Icon/Skill",armskilltabledata.Icon)
    self.mImage_ArmIcon.sprite=UIUtils.GetIconSprite("Icon/UAV3DModelIcon","Icon_UAV3DModelIcon_"..armtabledata[nowarmid].ResCode)
    self.mText_CostNum.text=armtabledata[nowarmid].Cost
    self.mText_ArmName.text=armtabledata[nowarmid].Name

    self:UpdateTextInfo(nowarmid)
    local script=self.mTrans_ItemScript:GetComponent(typeof(CS.ScrollListChild))
    local itemobj=instantiate(script.childItem.gameObject,self.mTrans_ItemScript)
    local itembtn=UIUtils.GetButton(itemobj)

    local itemimg= UIUtils.GetImage(itemobj,"GrpItem/Img_Item")
    local itemData=TableData.GetItemData(armtabledata[nowarmid].ItemId)
    TipsManager.Add(itemobj.gameObject,itemData,nil,true,
            nil,nil,function()self:SetGraphRayCasterState(false)end,
            function()self:SetGraphRayCasterState(true)end)
    local itemrankimg=UIUtils.GetImage(itemobj,"GrpBg/Img_Bg")
    itemrankimg.sprite=IconUtils.GetQuiltyByRank(itemData.rank)
    MessageSys:AddListener(5112,function()self:OnClickClose()end)
    itemimg.sprite=UIUtils.GetIconSprite("Icon/" .. itemData.icon_path, itemData.icon)
    self.itemtext= UIUtils.GetText(itemobj,"Trans_GrpNum/ImgBg/Text_Num")
    local NowPartsNum=0
    if CS.LuaUtils.IsNullOrDestroyed(NetCmdItemData:GetItemCmdData(armtabledata[nowarmid].ItemId)) then
    NowPartsNum=0
    else
    NowPartsNum=NetCmdItemData:GetItemCmdData(armtabledata[nowarmid].ItemId).Num
    end

    local uavarmdic=NetCmdUavData:GetUavArmData()
    local upgradecostlist=armtabledata[nowarmid].UpgradeCost
    local NowUpGradeCost=0
    NowUpGradeCost=upgradecostlist[uavarmdic[nowarmid].Level-1]
    if NowPartsNum<NowUpGradeCost then
    self.isItemEnough=false
    self.itemtext.text=string.format("<color=#FF5E41>%d</color>/<color=#FFFFFF>%d</color>",NowPartsNum,NowUpGradeCost)
    else
    self.isItemEnough=true
    self.itemtext.text=NowPartsNum.."/"..NowUpGradeCost
    end
    UIUtils.GetButtonListener(self.mBtn_Confirm.gameObject).onClick=function()

    self:OnClickLevelUp(nowarmid,self.isItemEnough,NowUpGradeCost,uavarmdic[nowarmid].Level)
    end
    UIUtils.GetButtonListener(self.mBtn_Cancle.gameObject).onClick=function()
    --UIManager.CloseUI(UIDef.UIUAVPartsSkillUpDialogContent)
    self:OnClickClose()
    end
    UIUtils.GetButtonListener(self.mBtn_DetailBgClose.gameObject).onClick=function()

    setactive(self.mTrans_SkillDetail,false)
    end
    UIUtils.GetButtonListener(self.mBtn_DetailClose.gameObject).onClick=function()

    setactive(self.mTrans_SkillDetail,false)
    end
    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick=function()
    self:OnClickClose()
    end
    UIUtils.GetButtonListener(self.mBtn_BgClose.gameObject).onClick=function()
    self:OnClickClose()
    end
    local armtabledata=TableData.GetUavArmsData()
    local uavarmdic=NetCmdUavData:GetUavArmData()
    local subid=string.sub(armtabledata[nowarmid].SkillSet,1,3)
    local armskilltabledata=TableData.GetUarArmRevelantData(tonumber(subid..uavarmdic[nowarmid].Level))
    local itemobjlist=List:New()
    for i = 2, 6 do
    itemobjlist:Add(tonumber(subid..i))
    end
    UIUtils.GetButtonListener(self.mBtn_info.gameObject).onClick=function()

    setactive(self.mTrans_SkillDetail,true)
    self.mText_DetailSkillDes.text=armskilltabledata.Detail
    for i = 0, self.mTrans_DetailLevelUpDes.childCount-1 do
    gfdestroy(self.mTrans_DetailLevelUpDes:GetChild(i))
    end
    for i = 0, itemobjlist:Count()-1  do
    local instObj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ChrSkillDescriptionItemV2.prefab",self),self.mTrans_DetailLevelUpDes);
    local item=UAVChrSkillDescriptionItem.New()
    item:InitCtrl(instObj.transform);
    local num=i+2
    item:InitData(itemobjlist[i+1],uavarmdic[nowarmid].Level,num)
    end
    end
    
end

function UAVPartsSkillUpDialogContent:UpdateTextInfo(nowarmid)
    
    local uavarmdic=NetCmdUavData:GetUavArmData()
    local armtabledata=TableData.GetUavArmsData()
    local subid=string.sub(armtabledata[nowarmid].SkillSet,1,3)
    local armskilltabledata=TableData.GetUarArmRevelantData(subid..(uavarmdic[nowarmid].Level+1))
    self.mText_NowLevel.text=uavarmdic[nowarmid].Level
    self.mText_NextLevel.text=uavarmdic[nowarmid].Level+1
    self.mText_SkillDes.text=armskilltabledata.Detail

    
end

function UAVPartsSkillUpDialogContent:UpdateItemText(nowarmid)

    local armtabledata=TableData.GetUavArmsData()
    local uavarmdic=NetCmdUavData:GetUavArmData()
    local NowPartsNum=0
    if CS.LuaUtils.IsNullOrDestroyed(NetCmdItemData:GetItemCmdData(armtabledata[nowarmid].ItemId)) then
        NowPartsNum=0
    else
        NowPartsNum=NetCmdItemData:GetItemCmdData(armtabledata[nowarmid].ItemId).Num
    end
    local upgradecostlist=armtabledata[nowarmid].UpgradeCost
    local NowUpGradeCost=0
    --local isItemEnough=false
    NowUpGradeCost=upgradecostlist[uavarmdic[nowarmid].Level-1]
    if NowPartsNum<NowUpGradeCost then
        --isItemEnough=false
        self.isItemEnough=false
        self.itemtext.text=string.format("<color=#FF5E41>%d</color>/<color=#FFFFFF>%d</color>",NowPartsNum,NowUpGradeCost)
    else
        --isItemEnough=true
        self.isItemEnough=true
        self.itemtext.text=NowPartsNum.."/"..NowUpGradeCost
    end
end
 
function UAVPartsSkillUpDialogContent:OnClickLevelUp(nowarmid,isItemEnough,NowUpGradeCost,nowarmlevel)
    if isItemEnough then
    NetCmdUavData:SendUavArmLevelUpData(nowarmid,function(ret) 
    self:OnSuccessLevelUpCallBack(ret,nowarmid,nowarmlevel)
    end)
    else
        local uavarmdata=TableData.GetUavArmsData()
        local hint=TableData.GetHintById(225)
        local str=string_format(hint,TableData.GetItemData(uavarmdata[nowarmid].ItemId).Name.str)
        --TODO 弹出材料不足提示
        CS.PopupMessageManager.PopupString(str)
    end
end

function UAVPartsSkillUpDialogContent:OnSuccessLevelUpCallBack(ret,nowarmid,nowarmlevel)
    if ret == CS.CMDRet.eSuccess then
        UIUAVPanel.UpdateBottomSkillState(true)
        UIUAVPanel.UpdateRightAreaInfo()
        UIUAVPanel.UpdateLeftAreaInfo()
        UIUAVPanel.UpdateRightBtnState()
        if nowarmlevel == 5 then
            self:OnClickClose()
            --gfdestroy(self.mUIRoot)
            return
        end
        UIUtils.PopupPositiveHintMessage(810)
        self:UpdateTextInfo(nowarmid) 
        self:UpdateItemText(nowarmid)
    end
end

function UAVPartsSkillUpDialogContent:OnClickClose()
    gfdestroy(self.mUIRoot)
    MessageSys:RemoveListener(5112,self.MessageCallback)
end

function UAVPartsSkillUpDialogContent:MessageCallback()
    print(1)
end

function UAVPartsSkillUpDialogContent:SetGraphRayCasterState(active)
    if CS.LuaUtils.IsNullOrDestroyed(self.mGraphRayCaster)==false then
        self.mGraphRayCaster.enabled=active
    end
end














