require("UI.UAVPanel.UIUAVContentBase")
UAVSkillInfoDialogContent = class("UAVSkillInfoDialogContent", UIUAVContentBase)
UAVSkillInfoDialogContent.__index = UAVSkillInfoDialogContent

UAVSkillInfoDialogContent.PrefabPath = "UAV/UAVSkillInfoDialogV2.prefab"
function UAVSkillInfoDialogContent:ctor(obj)
    
    UAVSkillInfoDialogContent.super.ctor(self, obj)
end

function UAVSkillInfoDialogContent:__InitCtrl()
    UISystem:AddContentUi("UAVSkillInfoDialogV2")
    self.mBtn_BgClose=self:GetButton("Root/GrpBg/Btn_Close")
    self.mBtn_Close=self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mText_TitleName=self:GetText("Root/GrpDialog/GrpTop/GrpText/TitleText")
    self.mImage_Icon=self:GetImage("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpTacticSkillIcon/GrpIcon/ImgIcon")
    self.mText_SkillName=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpText/Text_Name")
    self.mText_OilCostName=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpText/GrpCost/TextName")
    self.mText_OilCostNum=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpText/GrpCost/Text_Num")
    self.mText_UseTimesName=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpText/GrpTime/TextName")
    self.mText_UstTimesNum=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpText/GrpTime/Text_Num")
    self.mText_LevelNum=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillInfo/GrpLevel/Text_Level")
    self.mBtn_Info=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpSkillInfo/BtnInfo"))
    self.mText_SkillDes=self:GetText("Root/GrpDialog/GrpCenter/GrpSkillDescription/GrpSkillDescription/Viewport/Content/Text_Description")
    self.mTrans_SkillDetail=self:GetRectTransform("Root/GrpDialog/Trans_GrpSkillDetails")
    self.mBtn_DetailClose=self:GetButton("Root/GrpDialog/Trans_GrpSkillDetails/Btn_Close")
    self.mBtn_CloseDetailInfo=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/Trans_GrpSkillDetails/BtnInfo"))
    self.mText_DetailSkillDes=self:GetText("Root/GrpDialog/Trans_GrpSkillDetails/GrpAllSkillDescription/GrpDescribe/Viewport/Content/Text_Level1")
    self.mTrans_DetailSkillLeveDes=self:GetRectTransform("Root/GrpDialog/Trans_GrpSkillDetails/GrpAllSkillDescription/GrpDescribe/Viewport/Content/GrpLevelDescription")
    self.mLayoutlist={}
    self.mTrans_layout1=self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpSkillDescription/GrpSkillDiagram/Img_SkillDiagram_9x9")
    self.mTrans_layout2=self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpSkillDescription/GrpSkillDiagram/Img_SkillDiagram_17x17")
    self.mTrans_layout3=self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpSkillDescription/GrpSkillDiagram/Img_SkillDiagram_21x21")
    table.insert(self.mLayoutlist,getcomponent(self.mTrans_layout1,typeof(CS.GridLayout)))
    table.insert(self.mLayoutlist,getcomponent(self.mTrans_layout2,typeof(CS.GridLayout)))
    table.insert(self.mLayoutlist,getcomponent(self.mTrans_layout3,typeof(CS.GridLayout)))
   
end

function UAVSkillInfoDialogContent:SetData(data, parent,armid)
    UAVSkillInfoDialogContent.super.SetData(self, data, parent)
    CS.LuaUIUtils.AddCanvas(self.mUIRoot.gameObject,GlobalConfig.ContentPrefabOrder)
    self.mText_TitleName.text=TableData.GetHintById(105017)
    self.mText_OilCostName.text=TableData.GetHintById(105011)
    self.mText_UseTimesName.text=TableData.GetHintById(105012)
    self:UpdateInfo(armid)
    local armtabledata=TableData.GetUavArmsData()
    local uavarmdic=NetCmdUavData:GetUavArmData()
    local subid=string.sub(armtabledata[armid].SkillSet,1,3)
    local armskilltabledata=TableData.GetUarArmRevelantData(tonumber(subid..uavarmdic[armid].Level))
    local itemobjlist=List:New()
    for i = 2, 6 do
        itemobjlist:Add(tonumber(subid..i))
    end
    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick=function()
        self:OnClickClose()
    
    local armequipStateList=NetCmdUavData:GetArmEquipState()
    UIUAVPanel.UpdateRightSkillState(armequipStateList)
    end
    
    UIUtils.GetButtonListener(self.mBtn_BgClose.gameObject).onClick=function() 
        self:OnClickClose()
        local armequipStateList=NetCmdUavData:GetArmEquipState()
        UIUAVPanel.UpdateRightSkillState(armequipStateList)
    end
    UIUtils.GetButtonListener(self.mBtn_Info.gameObject).onClick=function()
        
        setactive(self.mTrans_SkillDetail.gameObject,true)
        self.mText_DetailSkillDes.text=armskilltabledata.Detail
        for i = 0, self.mTrans_DetailSkillLeveDes.childCount-1 do
            gfdestroy(self.mTrans_DetailSkillLeveDes:GetChild(i))
        end
        for i = 0, itemobjlist:Count()-1  do
        local instObj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ChrSkillDescriptionItemV2.prefab",self),self.mTrans_DetailSkillLeveDes);
        local item=UAVChrSkillDescriptionItem.New()
        item:InitCtrl(instObj.transform);
        local num=i+2
        item:InitData(itemobjlist[i+1],uavarmdic[armid].Level,num)
        end
    end
    UIUtils.GetButtonListener(self.mBtn_DetailClose.gameObject).onClick=function()
       
    setactive(self.mTrans_SkillDetail.gameObject,false)
end
    --self.mBtn_DetailClose.onClick=function() setactive(self.mTrans_SkillDetail.gameObject,false)end
    UIUtils.GetButtonListener(self.mBtn_CloseDetailInfo.gameObject).onClick=function()
    
    setactive(self.mTrans_SkillDetail.gameObject,false) end
end

function UAVSkillInfoDialogContent:UpdateInfo(armid)
    local armtabledata=TableData.GetUavArmsData()
    local uavarmdic=NetCmdUavData:GetUavArmData()
    --armtabledata[armid]
    local subid=string.sub(armtabledata[armid].SkillSet,1,3)
    local armskilltabledata=TableData.GetUarArmRevelantData(subid..uavarmdic[armid].Level)
    --self=UAVSkillInfoDialogContent
    self.mImage_Icon.sprite=UIUtils.GetIconSprite("Icon/Skill",armskilltabledata.Icon);
    self.mText_SkillName.text=TableData.GetUarArmRevelantData(subid..uavarmdic[armid].Level).Name
    self.mText_OilCostNum.text=armskilltabledata.TeCost
    self.mText_UstTimesNum.text=armskilltabledata.Stock
    self.mText_LevelNum.text=uavarmdic[armid].Level
    self.mText_DetailSkillDes.text=armskilltabledata.Detail
    self.mText_SkillDes.text=armskilltabledata.Detail
    --TODO 技能范围图片显示
    local battleskilldata=TableData.GetUarArmRevelantData(subid..uavarmdic[armid].Level)
    local skillrangedata=TableData.GetSkillData(battleskilldata.SkillList[0])
    CS.SkillRangeUIHelper.SetSkillRange(self.mLayoutlist,1,skillrangedata)
end



function UAVSkillInfoDialogContent:OnClickClose()
    gfdestroy(self.mUIRoot)
    
end

function UAVSkillInfoDialogContent:OnRelease()
    if self.itemPrefab then
        ResourceManager:UnloadAsset(self.itemPrefab)
    end
end











